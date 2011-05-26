Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36788 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1EZF0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 01:26:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 22:26:11 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	<Rajkumar.Manoharan@Atheros.com>, <Vivek.Natarajan@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Add a debug entry to start/stop ANI
Date: Thu, 26 May 2011 10:56:15 +0530
Message-ID: <1306387575-5793-1-git-send-email-mshajakhan@atheros.com> (sfid-20110526_072647_054861_33C25D9C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

this helps the user to start/stop ANI dynamically.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |   52 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c  |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |   33 ++++++++++++++-----
 5 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 7cf4317..17c4b56 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -161,6 +161,7 @@ struct ath_common {
 	const struct ath_bus_ops *bus_ops;
 
 	bool btcoex_enabled;
+	bool disable_ani;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f75068b..e7cbbab 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -428,6 +428,7 @@ void ath_hw_check(struct work_struct *work);
 void ath_hw_pll_work(struct work_struct *work);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
+void ath_start_ani(struct ath_common *common);
 
 /**********/
 /* BTCOEX */
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d55ffd7..a3c6440 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -176,6 +176,56 @@ static const struct file_operations fops_rx_chainmask = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_disable_ani(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", common->disable_ani);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_disable_ani(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long disable_ani;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &disable_ani))
+		return -EINVAL;
+
+	common->disable_ani = !!disable_ani;
+
+	if (disable_ani) {
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
+	} else {
+		sc->sc_flags |= SC_OP_ANI_RUN;
+		ath_start_ani(common);
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_disable_ani = {
+	.read = read_file_disable_ani,
+	.write = write_file_disable_ani,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
 
 static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
@@ -1160,6 +1210,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    sc->debug.debugfs_phy, sc, &fops_rx_chainmask);
 	debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
+	debugfs_create_file("disable_ani", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_disable_ani);
 	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_regidx);
 	debugfs_create_file("regval", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 45c585a..d4b166c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -519,7 +519,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int i = 0;
-
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
@@ -585,6 +584,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
+	common->disable_ani = false;
 	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->sc_serial_rw);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8df1096..d2b67d8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -136,7 +136,7 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
-static void ath_start_ani(struct ath_common *common)
+void ath_start_ani(struct ath_common *common)
 {
 	struct ath_hw *ah = common->ah;
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
@@ -302,7 +302,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			ath_set_beacon(sc);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
-		ath_start_ani(common);
+		if (!common->disable_ani)
+			ath_start_ani(common);
 	}
 
  ps_restore:
@@ -972,6 +973,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	sc->hw_busy_count = 0;
 
 	/* Stop ANI */
+
 	del_timer_sync(&common->ani.timer);
 
 	ath9k_ps_wakeup(sc);
@@ -1021,7 +1023,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/* Start ANI */
-	ath_start_ani(common);
+	if (!common->disable_ani)
+		ath_start_ani(common);
+
 	ath9k_ps_restore(sc);
 
 	return r;
@@ -1412,8 +1416,12 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	/* Set up ANI */
 	if (iter_data.naps > 0) {
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_flags |= SC_OP_ANI_RUN;
-		ath_start_ani(common);
+
+		if (!common->disable_ani) {
+			sc->sc_flags |= SC_OP_ANI_RUN;
+			ath_start_ani(common);
+		}
+
 	} else {
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
@@ -1977,8 +1985,11 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-		sc->sc_flags |= SC_OP_ANI_RUN;
-		ath_start_ani(common);
+		if (!common->disable_ani) {
+			sc->sc_flags |= SC_OP_ANI_RUN;
+			ath_start_ani(common);
+		}
+
 	}
 }
 
@@ -2047,8 +2058,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (bss_conf->ibss_joined) {
 			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-			sc->sc_flags |= SC_OP_ANI_RUN;
-			ath_start_ani(common);
+
+			if (!common->disable_ani) {
+				sc->sc_flags |= SC_OP_ANI_RUN;
+				ath_start_ani(common);
+			}
+
 		} else {
 			sc->sc_flags &= ~SC_OP_ANI_RUN;
 			del_timer_sync(&common->ani.timer);
-- 
1.7.0.4

