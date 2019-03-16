Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24D0C4360F
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A42BE218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZCTzhvVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfCPUmp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:45 -0400
Received: from nbd.name ([46.4.11.11]:39542 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbfCPUmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5kjSyjiE/+z0074Ex+j9SsrohJoDhQ4Q1eOzVTnIPkM=; b=ZCTzhvVIgaKkovyNcudiUVVwpf
        fuGAl9u1bdDkW8bAtBUOUMTwE0nPJ41nFagd3P9/T6HauwLTObUV27ODNo94nlmi/fgJsWXxL2AS3
        qKqRS+drgRVGHv+HHgTD+hXgfNonVvHwbrWoTsnmNWbhxSzTyem51SaBCpAoThRup3Uw=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5G8h-0005Ry-NV
        for linux-wireless@vger.kernel.org; Sat, 16 Mar 2019 21:42:43 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id C5E41530F04B; Sat, 16 Mar 2019 21:42:42 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] mt76: store software PN/IV in wcid
Date:   Sat, 16 Mar 2019 21:42:40 +0100
Message-Id: <20190316204242.73560-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316204242.73560-1-nbd@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoids expensive 64-bit atomic access in the data path

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c   | 6 +++++-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c  | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 7 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 7 +++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 1 +
 6 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 40b3ce01e74d..6bee65edb26a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -220,6 +220,8 @@ struct mt76_wcid {
 	u8 rx_key_pn[IEEE80211_NUM_TIDS][6];
 
 	u32 tx_info;
+
+	u64 tx_pn;
 	bool sw_iv;
 
 	u8 packet_id;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index d6e260ca1423..fb1961ac9dc6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -924,7 +924,11 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	txwi[3] = cpu_to_le32(val);
 
 	if (key) {
-		u64 pn = atomic64_inc_return(&key->tx_pn);
+		u64 pn;
+
+		spin_lock(&dev->mt76.lock);
+		pn = ++wcid->tx_pn;
+		spin_unlock(&dev->mt76.lock);
 
 		txwi[3] |= cpu_to_le32(MT_TXD3_PN_VALID);
 		txwi[4] = cpu_to_le32(pn & GENMASK(31, 0));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 7849528db134..3754723190d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -472,6 +472,7 @@ mt7603_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (cmd == SET_KEY) {
 		key->hw_key_idx = wcid->idx;
 		wcid->hw_key_idx = idx;
+		wcid->tx_pn = atomic64_read(&key->tx_pn);
 	} else {
 		if (idx == wcid->hw_key_idx)
 			wcid->hw_key_idx = -1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 29dbe18abbc9..8e5f920deef1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -352,7 +352,12 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		txwi->wcid = 0xff;
 
 	if (wcid && wcid->sw_iv && key) {
-		u64 pn = atomic64_inc_return(&key->tx_pn);
+		u64 pn;
+
+		spin_lock(&dev->mt76.lock);
+		pn = ++wcid->tx_pn;
+		spin_unlock(&dev->mt76.lock);
+
 		ccmp_pn[0] = pn;
 		ccmp_pn[1] = pn >> 8;
 		ccmp_pn[2] = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index ec94d612f53c..736a77936249 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -420,10 +420,13 @@ static void mt76x02_key_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	wcid = (struct mt76_wcid *) sta->drv_priv;
 
-	if (wcid->hw_key_idx != key->keyidx || wcid->sw_iv)
+	if (wcid->hw_key_idx != key->keyidx)
 	    return;
 
-	mt76x02_mac_wcid_sync_pn(dev, wcid->idx, key);
+	if (wcid->sw_iv)
+		atomic64_set(&key->tx_pn, wcid->tx_pn);
+	else
+		mt76x02_mac_wcid_sync_pn(dev, wcid->idx, key);
 }
 
 static void mt76x02_reset_state(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a6bb71a6ed0d..079ac265ef26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -433,6 +433,7 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
 			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			wcid->sw_iv = true;
+			wcid->tx_pn = atomic64_read(&key->tx_pn);
 		}
 	} else {
 		if (idx == wcid->hw_key_idx) {
-- 
2.17.0

