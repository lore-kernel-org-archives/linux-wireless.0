Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55092 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaINVJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 17:09:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] b43: add support for setting the beacon listen interval
Date: Sun, 14 Sep 2014 23:09:12 +0200
Message-Id: <1410728952-25779-5-git-send-email-hauke@hauke-m.de> (sfid-20140914_230933_441549_FB083648)
In-Reply-To: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
References: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/b43.h  | 1 +
 drivers/net/wireless/b43/main.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 018ed5f..29c67eb 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -300,6 +300,7 @@ enum {
 #define B43_SHM_SH_LFFBLIM		0x0046	/* Long frame fallback retry limit */
 #define B43_SHM_SH_BEACPHYCTL		0x0054	/* Beacon PHY TX control word (see PHY TX control) */
 #define B43_SHM_SH_EXTNPHYCTL		0x00B0	/* Extended bytes for beacon PHY control (N) */
+#define B43_SHM_SH_BCN_LI		0x00B6	/* beacon listen interval */
 /* SHM_SHARED ACK/CTS control */
 #define B43_SHM_SH_ACKCTSPHYCTL		0x0022	/* ACK/CTS PHY control word (see PHY TX control) */
 /* SHM_SHARED probe response variables */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 96edbd2..1b01e1f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3900,6 +3900,12 @@ static int b43_switch_band(struct b43_wldev *dev,
 	return 0;
 }
 
+static void b43_set_beacon_listen_interval(struct b43_wldev *dev, u16 interval)
+{
+	interval = min_t(u16, interval, (u16)0xFF);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_BCN_LI, interval);
+}
+
 /* Write the short and long frame retry limit values. */
 static void b43_set_retry_limits(struct b43_wldev *dev,
 				 unsigned int short_retry,
@@ -3928,6 +3934,9 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&wl->mutex);
 	b43_mac_suspend(dev);
 
+	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL)
+		b43_set_beacon_listen_interval(dev, conf->listen_interval);
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		phy->chandef = &conf->chandef;
 		phy->channel = conf->chandef.chan->hw_value;
-- 
1.9.1

