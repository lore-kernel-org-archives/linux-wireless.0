Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04D6C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EADB20685
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EADB20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbeI3Q3k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:29:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39974 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbeI3Q3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:29:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id o2-v6so5848985wmh.5
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 02:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aV9DGfI3iBF//F6rHsAvwt0crlkVERRI8N75N5sn52s=;
        b=t+ItYDRhZ8NqUYYfGRmobSBF5DC2dyoHWwTS90H+bP0DxbuQRr8vkbzrHs3xAlFTK7
         NbX7Zcko6lgnCnICi6XRJg5J14eSJsHW90u+w0QGhSR2VFj/ckAJY4gAQjIHO+w+sTUf
         Mmd09S6Zj+y0kn94xGF39bI7qPHgyfZLI7cfpMCSqlfGNCIQDW1iEtHi0iZb2ZoY3q00
         0nJIzW0qM4uXR/ajsl34bVnm8tonv5IqTBCrpEutImiTFarw1DuRwe6rYKtj8CG0I7Q+
         twsj/3ksw+n0ZxUxemqzODW+6cP75e0Vw6RttNpDLrMNd2tXeNPFAhC8iTUxzfUJIQj4
         0z2Q==
X-Gm-Message-State: ABuFfoh+ZDyKKjJ8Dg29lLrzLy45tz0lGyXpAZmHIO++RUq7p/SCqTde
        vnVBCLq6HUmAHl76m/qBXgBBwSa+a9k=
X-Google-Smtp-Source: ACcGV60hd9Ch/S1CBA0IPrvhz12AK0k4UH6f+72MiTUQDe4DgXmRwsZXJZl0DxXS+bgsv3iaDNiKrg==
X-Received: by 2002:a1c:f010:: with SMTP id a16-v6mr2415536wmb.5.1538301437679;
        Sun, 30 Sep 2018 02:57:17 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 12-v6sm4898375wms.11.2018.09.30.02.57.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:57:17 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 03/10] mt76x0: mac: use sta ewma estimation for rssi tracking
Date:   Sun, 30 Sep 2018 11:56:59 +0200
Message-Id: <20180930095706.28428-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use shared mt76x02 utility routines for rssi tracking.
Moreover remove no longer used con_mon_lock spinlock
and following variable:
- ap_bssid
- bcn_freq_off
- bcn_phy_mode
- avg_rssi

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 41 +++++--------------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  3 --
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    | 12 ------
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 20 +++------
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |  2 +-
 6 files changed, 17 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 4b8314844d36..a67a82670901 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -354,7 +354,6 @@ mt76x0_alloc_device(struct device *pdev,
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
 	spin_lock_init(&dev->mac_lock);
-	spin_lock_init(&dev->con_mon_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
 
 	return dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index f55734a922aa..eccb9451273f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -196,31 +196,16 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 		   FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
 }
 
-static void
-mt76x0_rx_monitor_beacon(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi,
-			  u16 rate, int rssi)
-{
-	dev->bcn_phy_mode = FIELD_GET(MT_RXWI_RATE_PHY, rate);
-	dev->avg_rssi = ((dev->avg_rssi * 15) / 16 + (rssi << 8)) / 256;
-}
-
-static int
-mt76x0_rx_is_our_beacon(struct mt76x0_dev *dev, u8 *data)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)data;
-
-	return ieee80211_is_beacon(hdr->frame_control) &&
-		ether_addr_equal(hdr->addr2, dev->ap_bssid);
-}
-
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
-			void *rxi)
+			  void *rxi)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x02_rxwi *rxwi = rxi;
 	u32 len, ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
+	struct mt76x02_sta *sta;
 	int rssi, pad_len = 0;
+	u8 wcid;
 
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	if (WARN_ON(len < 10))
@@ -234,6 +219,9 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	if (rxwi->rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
+	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
+	sta = mt76x02_rx_get_sta(&dev->mt76, wcid);
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	pskb_trim(skb, len);
@@ -243,19 +231,10 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	status->freq = dev->mt76.chandef.chan->center_freq;
 	status->band = dev->mt76.chandef.chan->band;
 
-	mt76x02_mac_process_rate(status, rate);
-
-	spin_lock_bh(&dev->con_mon_lock);
-	if (mt76x0_rx_is_our_beacon(dev, skb->data)) {
-		mt76x0_rx_monitor_beacon(dev, rxwi, rate, rssi);
-	} else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST)) {
-		if (dev->avg_rssi == 0)
-			dev->avg_rssi = rssi;
-		else
-			dev->avg_rssi = (dev->avg_rssi * 15) / 16 + rssi / 16;
-
+	if (sta) {
+		ewma_signal_add(&sta->rssi, status->signal);
+		sta->inactive_count = 0;
 	}
-	spin_unlock_bh(&dev->con_mon_lock);
 
-	return len;
+	return mt76x02_mac_process_rate(status, rate);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index c3cea52ec0dc..ca6cde7a2f90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -68,9 +68,6 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	if (changed & BSS_CHANGED_ASSOC)
-		mt76x0_phy_con_cal_onoff(dev, info);
-
 	if (changed & BSS_CHANGED_BSSID) {
 		mt76x0_addr_wr(dev, MT_MAC_BSSID_DW0, info->bssid);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index e54468af6ba7..9060be6b071e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -70,7 +70,6 @@ enum mt_bw {
  * struct mt76x0_dev - adapter structure
  * @lock:		protects @wcid->tx_rate.
  * @mac_lock:		locks out mac80211's tx status and rx paths.
- * @con_mon_lock:	protects @ap_bssid, @bcn_*, @avg_rssi.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
  *			(accesses to RF and BBP).
@@ -94,15 +93,6 @@ struct mt76x0_dev {
 
 	atomic_t avg_ampdu_len;
 
-	/* Connection monitoring things */
-	spinlock_t con_mon_lock;
-	u8 ap_bssid[ETH_ALEN];
-
-	s8 bcn_freq_off;
-	u8 bcn_phy_mode;
-
-	int avg_rssi; /* starts at 0 and converges */
-
 	u8 agc_save;
 
 	bool no_2ghz;
@@ -153,8 +143,6 @@ int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev);
 int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi);
-void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
-			       struct ieee80211_bss_conf *info);
 void mt76x0_phy_set_txpower(struct mt76x0_dev *dev);
 
 /* MAC */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 4fd2c65e196a..ee7f071a96f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -818,12 +818,15 @@ static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
 
 static void mt76x0_dynamic_vga_tuning(struct mt76x0_dev *dev)
 {
+	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	u32 val, init_vga;
+	int avg_rssi;
 
-	init_vga = (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) ? 0x54 : 0x4E;
-	if (dev->avg_rssi > -60)
+	init_vga = chandef->chan->band == NL80211_BAND_5GHZ ? 0x54 : 0x4E;
+	avg_rssi = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
+	if (avg_rssi > -60)
 		init_vga -= 0x20;
-	else if (dev->avg_rssi > -70)
+	else if (avg_rssi > -70)
 		init_vga -= 0x10;
 
 	val = mt76_rr(dev, MT_BBP(AGC, 8));
@@ -844,17 +847,6 @@ static void mt76x0_phy_calibrate(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
-void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
-			       struct ieee80211_bss_conf *info)
-{
-	/* Start/stop collecting beacon data */
-	spin_lock_bh(&dev->con_mon_lock);
-	ether_addr_copy(dev->ap_bssid, info->bssid);
-	dev->avg_rssi = 0;
-	dev->bcn_freq_off = MT_FREQ_OFFSET_INVALID;
-	spin_unlock_bh(&dev->con_mon_lock);
-}
-
 static void
 mt76x0_rf_init(struct mt76x0_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 79c0b3ba1ccb..472a330821dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -53,7 +53,7 @@ void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	void *rxwi = skb->data;
 
 	skb_pull(skb, sizeof(struct mt76x02_rxwi));
-	if (!mt76x0_mac_process_rx(dev, skb, rxwi)) {
+	if (mt76x0_mac_process_rx(dev, skb, rxwi)) {
 		dev_kfree_skb(skb);
 		return;
 	}
-- 
2.19.0

