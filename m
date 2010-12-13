Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45263 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0LMLkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:06 -0500
Received: by eyg5 with SMTP id 5so4064715eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:05 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/17] rt2x00: Implement get_survey callback for rt2800
Date: Mon, 13 Dec 2010 12:31:58 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com>
In-Reply-To: <201012131231.28313.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131231.59890.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Implement the get_survey callback to allow user space to read statistics
about the current channel condition.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   10 ++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   49 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 5 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9dcbf87..03f9fa1 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -699,8 +699,18 @@
 
 /*
  * CH_TIME_CFG: count as channel busy
+ * EIFS_BUSY: Count EIFS as channel busy
+ * NAV_BUSY: Count NAS as channel busy
+ * RX_BUSY: Count RX as channel busy
+ * TX_BUSY: Count TX as channel busy
+ * TMR_EN: Enable channel statistics timer
  */
 #define CH_TIME_CFG     	        0x110c
+#define CH_TIME_CFG_EIFS_BUSY		FIELD32(0x00000010)
+#define CH_TIME_CFG_NAV_BUSY		FIELD32(0x00000008)
+#define CH_TIME_CFG_RX_BUSY		FIELD32(0x00000004)
+#define CH_TIME_CFG_TX_BUSY		FIELD32(0x00000002)
+#define CH_TIME_CFG_TMR_EN		FIELD32(0x00000001)
 
 /*
  * PBF_LIFE_TIMER: TX/RX MPDU timestamp timer (free run) Unit: 1us
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9b592d9..b7de1a5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1625,6 +1625,13 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	}
 
 	msleep(1);
+
+	/*
+	 * Clear channel statistic counters
+	 */
+	rt2800_register_read(rt2x00dev, CH_IDLE_STA, &reg);
+	rt2800_register_read(rt2x00dev, CH_BUSY_STA, &reg);
+	rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC, &reg);
 }
 
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
@@ -2259,6 +2266,17 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, INT_TIMER_CFG_PRE_TBTT_TIMER, 6 << 4);
 	rt2800_register_write(rt2x00dev, INT_TIMER_CFG, reg);
 
+	/*
+	 * Set up channel statistics timer
+	 */
+	rt2800_register_read(rt2x00dev, CH_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, CH_TIME_CFG_EIFS_BUSY, 1);
+	rt2x00_set_field32(&reg, CH_TIME_CFG_NAV_BUSY, 1);
+	rt2x00_set_field32(&reg, CH_TIME_CFG_RX_BUSY, 1);
+	rt2x00_set_field32(&reg, CH_TIME_CFG_TX_BUSY, 1);
+	rt2x00_set_field32(&reg, CH_TIME_CFG_TMR_EN, 1);
+	rt2800_register_write(rt2x00dev, CH_TIME_CFG, reg);
+
 	return 0;
 }
 
@@ -3539,6 +3557,37 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(rt2800_ampdu_action);
 
+int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
+		      struct survey_info *survey)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	u32 idle, busy, busy_ext;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+
+	rt2800_register_read(rt2x00dev, CH_IDLE_STA, &idle);
+	rt2800_register_read(rt2x00dev, CH_BUSY_STA, &busy);
+	rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC, &busy_ext);
+
+	if (idle || busy) {
+		survey->filled = SURVEY_INFO_CHANNEL_TIME |
+				 SURVEY_INFO_CHANNEL_TIME_BUSY |
+				 SURVEY_INFO_CHANNEL_TIME_EXT_BUSY;
+
+		survey->channel_time = (idle + busy) / 1000;
+		survey->channel_time_busy = busy / 1000;
+		survey->channel_time_ext_busy = busy_ext / 1000;
+	}
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(rt2800_get_survey);
+
 MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("Ralink RT2800 library");
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 81cbc92..e3c995a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -199,5 +199,7 @@ u64 rt2800_get_tsf(struct ieee80211_hw *hw);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
+		      struct survey_info *survey);
 
 #endif /* RT2800LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 433c7f3..3a1468a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -943,6 +943,7 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.ampdu_action		= rt2800_ampdu_action,
 	.flush			= rt2x00mac_flush,
+	.get_survey		= rt2800_get_survey,
 };
 
 static const struct rt2800_ops rt2800pci_rt2800_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 935b76d..042e47d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -562,6 +562,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.ampdu_action		= rt2800_ampdu_action,
 	.flush			= rt2x00mac_flush,
+	.get_survey		= rt2800_get_survey,
 };
 
 static const struct rt2800_ops rt2800usb_rt2800_ops = {
-- 
1.7.2.3

