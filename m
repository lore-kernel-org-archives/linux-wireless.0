Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4460C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8863E20857
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EE7Itci5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfCZIe0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:34:26 -0400
Received: from nbd.name ([46.4.11.11]:38944 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfCZIeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 04:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=reiBErJ+x//gFvl3axP/iGVRIVA62x6ssV7DhOxrHzg=; b=EE7Itci5bWJAwZr4Ge3mbge1Z3
        iCJyrYS7U7KA3st/g4JEdaUAEftv1xpjAIMondyyV41oqxlrDUloZGtUIFHxuK8gU2+MdzNsJHiFU
        W/ash1kJMMuHhq1BlzCSUzbh4TZq7GRCj+uJ71ZPvKif4xFIvNDzBHknwgmKaQB5At6A=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8hXK-0000fz-Oj; Tue, 26 Mar 2019 09:34:22 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id E4BE65583F85; Tue, 26 Mar 2019 09:34:21 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH 5.1 2/3] mt76: mt7603: fix sequence number assignment
Date:   Tue, 26 Mar 2019 09:34:20 +0100
Message-Id: <20190326083421.57998-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190326083421.57998-1-nbd@nbd.name>
References: <20190326083421.57998-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If the MT_TXD3_SN_VALID flag is not set in the tx descriptor, the hardware
assigns the sequence number. However, the rest of the code assumes that the
sequence number specified in the 802.11 header gets transmitted.
This was causing issues with the aggregation setup, which worked for the
initial one (where the sequence numbers were still close), but not for
further teardown/re-establishing of sessions.

Additionally, the overwrite of the TID sequence number in WTBL2 was resetting
the hardware assigned sequence numbers, causing them to drift further apart.

Fix this by using the software assigned sequence numbers

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 53 +++++--------------
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  6 +--
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 3 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 5e31d7da96fc..5abc02b57818 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -343,7 +343,7 @@ void mt7603_mac_rx_ba_reset(struct mt7603_dev *dev, void *addr, u8 tid)
 		 MT_BA_CONTROL_1_RESET));
 }
 
-void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
+void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid,
 			    int ba_size)
 {
 	u32 addr = mt7603_wtbl2_addr(wcid);
@@ -358,43 +358,6 @@ void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
 		mt76_clear(dev, addr + (15 * 4), tid_mask);
 		return;
 	}
-	mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
-
-	mt7603_mac_stop(dev);
-	switch (tid) {
-	case 0:
-		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID0_SN, ssn);
-		break;
-	case 1:
-		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID1_SN, ssn);
-		break;
-	case 2:
-		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID2_SN_LO,
-			       ssn);
-		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID2_SN_HI,
-			       ssn >> 8);
-		break;
-	case 3:
-		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID3_SN, ssn);
-		break;
-	case 4:
-		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID4_SN, ssn);
-		break;
-	case 5:
-		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID5_SN_LO,
-			       ssn);
-		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID5_SN_HI,
-			       ssn >> 4);
-		break;
-	case 6:
-		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID6_SN, ssn);
-		break;
-	case 7:
-		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID7_SN, ssn);
-		break;
-	}
-	mt7603_wtbl_update(dev, wcid, MT_WTBL_UPDATE_WTBL2);
-	mt7603_mac_start(dev);
 
 	for (i = 7; i > 0; i--) {
 		if (ba_size >= MT_AGG_SIZE_LIMIT(i))
@@ -827,6 +790,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt7603_vif *mvif;
 	int wlan_idx;
@@ -834,6 +798,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	int tx_count = 8;
 	u8 frame_type, frame_subtype;
 	u16 fc = le16_to_cpu(hdr->frame_control);
+	u16 seqno = 0;
 	u8 vif_idx = 0;
 	u32 val;
 	u8 bw;
@@ -919,7 +884,17 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 		tx_count = 0x1f;
 
 	val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, tx_count) |
-	      FIELD_PREP(MT_TXD3_SEQ, le16_to_cpu(hdr->seq_ctrl));
+		  MT_TXD3_SN_VALID;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		seqno = le16_to_cpu(hdr->seq_ctrl);
+	else if (ieee80211_is_back_req(hdr->frame_control))
+		seqno = le16_to_cpu(bar->start_seq_num);
+	else
+		val &= ~MT_TXD3_SN_VALID;
+
+	val |= FIELD_PREP(MT_TXD3_SEQ, seqno >> 4);
+
 	txwi[3] = cpu_to_le32(val);
 
 	if (key) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index cc0fe0933b2d..31a7ca691195 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -584,13 +584,13 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		mtxq->aggr = true;
 		mtxq->send_bar = false;
-		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, ba_size);
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, ba_size);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		mtxq->aggr = false;
 		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, -1);
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, -1);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		mtxq->agg_ssn = *ssn << 4;
@@ -598,7 +598,7 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		mtxq->aggr = false;
-		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, -1);
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, -1);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 79f332429432..6049f3b7c8fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -200,7 +200,7 @@ void mt7603_beacon_set_timer(struct mt7603_dev *dev, int idx, int intval);
 int mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb);
 void mt7603_mac_add_txs(struct mt7603_dev *dev, void *data);
 void mt7603_mac_rx_ba_reset(struct mt7603_dev *dev, void *addr, u8 tid);
-void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
+void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid,
 			    int ba_size);
 
 void mt7603_pse_client_reset(struct mt7603_dev *dev);
-- 
2.17.0

