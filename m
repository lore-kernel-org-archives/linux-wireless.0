Return-Path: <SRS0=4jqP=4Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DFDC10F27
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Mar 2020 22:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96CC02083E
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Mar 2020 22:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583705387;
	bh=Szh491bPK7s8qmqvcoZoRBi8TtZHxSfor9FjNPNFrtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H2nsfhaiXIrmGIlsC/5QR26ghiRQ4cGKyR7enzP/7do5K85DtkKIXkLoPwKwvhhkK
	 pkt/dOxBQ9mC/XoZmxtzPVYXbRDMic/d3mnzqy9RLN8ET/mWvLx5BBUEhXHFZ/0XG4
	 6VDcB1RE1hphsSK6OW/FpHmy+wZIqWGV7ng/qVuM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgCHWJr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Mar 2020 18:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgCHWJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Mar 2020 18:09:46 -0400
Received: from localhost.localdomain (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4FE206D5;
        Sun,  8 Mar 2020 22:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583705385;
        bh=Szh491bPK7s8qmqvcoZoRBi8TtZHxSfor9FjNPNFrtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN1ZztdGyBEh0jNGYLAc1pVtY4huvz5JiZxqrjBrcdcabTI3ukIb0rJtgY8ryIuaG
         8AvVgNm95hKxdH6CfsJRPf/RHD9skPbDT7ojvp5jKgXkglOk5xM7SSRHGdhcaxSus1
         5/A1KucVHJ10sYTn62Cxzso0pLQtlISudMVfLUnE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com
Subject: [PATCH v2 24/25] mt76: mt7615: get rid of sta_rec_wtbl data structure
Date:   Sun,  8 Mar 2020 23:08:36 +0100
Message-Id: <04ed6473baf7e5481c1bb0f25219c04de92c1cd6.1583705012.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1583705012.git.lorenzo@kernel.org>
References: <cover.1583705012.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sobstitute sta_rec_wtbl data structure with tlv one

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 17 +++++++----------
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h |  7 +------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index afe192e0c48a..f417b3084e9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -478,7 +478,7 @@ static struct wtbl_req_hdr *
 mt7615_mcu_alloc_wtbl_req(struct mt7615_sta *msta, int cmd,
 			  void *sta_wtbl, struct sk_buff **skb)
 {
-	struct sta_rec_wtbl *sta_hdr = sta_wtbl;
+	struct tlv *sta_hdr = sta_wtbl;
 	struct wtbl_req_hdr hdr = {
 		.wlan_idx = msta->wcid.idx,
 		.operation = cmd,
@@ -504,7 +504,7 @@ mt7615_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
 			  void *sta_ntlv, void *sta_wtbl)
 {
 	struct sta_ntlv_hdr *ntlv_hdr = sta_ntlv;
-	struct sta_rec_wtbl *sta_hdr = sta_wtbl;
+	struct tlv *sta_hdr = sta_wtbl;
 	struct tlv *ptlv, tlv = {
 		.tag = cpu_to_le16(tag),
 		.len = cpu_to_le16(len),
@@ -1027,8 +1027,8 @@ mt7615_mcu_sta_ba(struct mt7615_dev *dev,
 		return PTR_ERR(skb);
 
 	mt7615_mcu_sta_ba_tlv(skb, params, enable, tx);
-	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL,
-				      sizeof(struct sta_rec_wtbl));
+
+	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
 
 	wtbl_hdr = mt7615_mcu_alloc_wtbl_req(msta, WTBL_SET, sta_wtbl, &skb);
 	mt7615_mcu_wtbl_ba_tlv(skb, params, enable, tx, sta_wtbl, wtbl_hdr);
@@ -1073,8 +1073,7 @@ mt7615_mcu_add_sta_cmd(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 	if (enable && sta)
 		mt7615_mcu_sta_ht_tlv(skb, sta);
 
-	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL,
-				      sizeof(struct sta_rec_wtbl));
+	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
 
 	wtbl_hdr = mt7615_mcu_alloc_wtbl_req(msta, WTBL_RESET_AND_SET,
 					     sta_wtbl, &skb);
@@ -1322,8 +1321,7 @@ mt7615_mcu_uni_tx_ba(struct mt7615_dev *dev,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL,
-				      sizeof(struct sta_rec_wtbl));
+	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
 
 	wtbl_hdr = mt7615_mcu_alloc_wtbl_req(msta, WTBL_SET, sta_wtbl, &skb);
 	if (IS_ERR(wtbl_hdr))
@@ -1374,8 +1372,7 @@ mt7615_mcu_uni_rx_ba(struct mt7615_dev *dev,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL,
-				      sizeof(struct sta_rec_wtbl));
+	sta_wtbl = mt7615_mcu_add_tlv(skb, STA_REC_WTBL, sizeof(struct tlv));
 
 	wtbl_hdr = mt7615_mcu_alloc_wtbl_req(msta, WTBL_SET, sta_wtbl, &skb);
 	if (IS_ERR(wtbl_hdr))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
index 039634ae0412..19ea86d88f6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
@@ -526,7 +526,7 @@ struct wtbl_raw {
 					 sizeof(struct sta_rec_basic) +	\
 					 sizeof(struct sta_rec_ht) +	\
 					 sizeof(struct sta_rec_vht) +	\
-					 sizeof(struct sta_rec_wtbl) +	\
+					 sizeof(struct tlv) +	\
 					 MT7615_WTBL_UPDATE_MAX_SIZE)
 
 #define MT7615_WTBL_UPDATE_BA_SIZE	(sizeof(struct wtbl_req_hdr) +	\
@@ -615,11 +615,6 @@ struct sta_rec_ba {
 	__le16 winsize;
 } __packed;
 
-struct sta_rec_wtbl {
-	__le16 tag;
-	__le16 len;
-} __packed;
-
 enum {
 	STA_REC_BASIC,
 	STA_REC_RA,
-- 
2.24.1

