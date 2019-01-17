Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777EFC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4582220851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UzAHk741"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfAQNvj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:39 -0500
Received: from nbd.name ([46.4.11.11]:56464 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfAQNvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o6h5HnIcblSYmt2NTt35fZeX6eHsYMElbCa4dPap388=; b=UzAHk7415D+6vvCFiVyXpnkVre
        5K20+Gv51AdjJ/i7YBP/Lkebm2ICb6GwprNxfdsEVAOeUR0gbdpTbJHwRdWQADCTHqIsQn3LBniy/
        EglXZBkJA7kH3rIDV5/yRMEPx00NpIFfZcVop7mg9yDR+ldS8DD2CHYzU6NEn7IGofXA=;
Received: by maeck.lan (Postfix, from userid 501)
        id 3633F4C6F051; Thu, 17 Jan 2019 14:51:33 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mt76: move mt76x02_get_txpower to mt76 core
Date:   Thu, 17 Jan 2019 14:51:29 +0100
Message-Id: <20190117135133.2753-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It will be reused by mt7603 later

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c  | 18 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h      |  3 +++
 .../net/wireless/mediatek/mt76/mt76x0/pci.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h   |  2 --
 .../net/wireless/mediatek/mt76/mt76x02_util.c  | 18 ------------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c   |  2 +-
 8 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3d976ac4cb41..467b5a692ed1 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -710,3 +710,21 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_sta_state);
+
+int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     int *dbm)
+{
+	struct mt76_dev *dev = hw->priv;
+	int n_chains = __sw_hweight8(dev->antenna_mask);
+
+	*dbm = dev->txpower_cur / 2;
+
+	/* convert from per-chain power to combined
+	 * output on 2x2 devices
+	 */
+	if (n_chains > 1)
+		*dbm += 3;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_get_txpower);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8d56ab97abe3..16b342f63d29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -680,6 +680,9 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
+int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     int *dbm);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 720b05e325a5..1472c8699b29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -99,7 +99,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_survey = mt76_get_survey,
-	.get_txpower = mt76x02_get_txpower,
+	.get_txpower = mt76_get_txpower,
 	.flush = mt76x0e_flush,
 	.set_tim = mt76x0e_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0e6b43bb4678..f66e1b2f0980 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -155,7 +155,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x02_set_rts_threshold,
 	.wake_tx_queue = mt76_wake_tx_queue,
-	.get_txpower = mt76x02_get_txpower,
+	.get_txpower = mt76_get_txpower,
 };
 
 static int mt76x0u_register_device(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index d8bd0509a790..6d96766a6ed3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -172,8 +172,6 @@ void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     const u8 *mac);
 void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
-int mt76x02_get_txpower(struct ieee80211_hw *hw,
-			struct ieee80211_vif *vif, int *dbm);
 void mt76x02_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index d80c8eb5a0ec..59f50a957cd5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -607,24 +607,6 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
 
-int mt76x02_get_txpower(struct ieee80211_hw *hw,
-			struct ieee80211_vif *vif, int *dbm)
-{
-	struct mt76x02_dev *dev = hw->priv;
-	u8 nstreams = dev->mt76.chainmask & 0xf;
-
-	*dbm = dev->mt76.txpower_cur / 2;
-
-	/* convert from per-chain power to combined
-	 * output on 2x2 devices
-	 */
-	if (nstreams > 1)
-		*dbm += 3;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x02_get_txpower);
-
 void mt76x02_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta,
 		    bool ps)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 6a87b88eb036..06a26a152ba4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -191,7 +191,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.flush = mt76x2_flush,
 	.ampdu_action = mt76x02_ampdu_action,
-	.get_txpower = mt76x02_get_txpower,
+	.get_txpower = mt76_get_txpower,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.release_buffered_frames = mt76_release_buffered_frames,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 2b48cc51a30d..286c7f451090 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -138,5 +138,5 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.sw_scan_start = mt76x02_sw_scan,
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
-	.get_txpower = mt76x02_get_txpower,
+	.get_txpower = mt76_get_txpower,
 };
-- 
2.17.0

