Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53783 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbeIECZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 22:25:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id b19-v6so5937223wme.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 14:58:12 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 2/3] ath9k_htc: enable ANI debug output
Date: Tue,  4 Sep 2018 23:57:58 +0200
Message-Id: <1536098279-3268-2-git-send-email-pozega.tomislav@gmail.com> (sfid-20180904_235903_320816_C52452E6)
In-Reply-To: <1536098279-3268-1-git-send-email-pozega.tomislav@gmail.com>
References: <1536098279-3268-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable ANI output in debug file similar to how it's done on ath9k.
Disabling the entire feature is also working. Tested with ALFA
AWUS036NHA device.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   98 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |   49 ++++++++++++
 3 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 9f64e32..5490c5f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -564,6 +564,7 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv,
 				u8 enable_coex);
 void ath9k_htc_ani_work(struct work_struct *work);
+void ath9k_htc_check_ani(struct ath9k_htc_priv *priv);
 void ath9k_htc_start_ani(struct ath9k_htc_priv *priv);
 void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index a345da8..cfbb309 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -398,6 +398,102 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_ani(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath_hw *ah = priv->ah;
+	unsigned int len = 0;
+	const unsigned int size = 1024;
+	ssize_t retval = 0;
+	char *buf;
+	int i;
+	struct {
+		const char *name;
+		unsigned int val;
+	} ani_info[] = {
+		{ "ANI RESET", ah->stats.ast_ani_reset },
+		{ "OFDM LEVEL", ah->ani.ofdmNoiseImmunityLevel },
+		{ "CCK LEVEL", ah->ani.cckNoiseImmunityLevel },
+		{ "SPUR UP", ah->stats.ast_ani_spurup },
+		{ "SPUR DOWN", ah->stats.ast_ani_spurup },
+		{ "OFDM WS-DET ON", ah->stats.ast_ani_ofdmon },
+		{ "OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff },
+		{ "MRC-CCK ON", ah->stats.ast_ani_ccklow },
+		{ "MRC-CCK OFF", ah->stats.ast_ani_cckhigh },
+		{ "FIR-STEP UP", ah->stats.ast_ani_stepup },
+		{ "FIR-STEP DOWN", ah->stats.ast_ani_stepdown },
+		{ "INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero },
+		{ "OFDM ERRORS", ah->stats.ast_ani_ofdmerrs },
+		{ "CCK ERRORS", ah->stats.ast_ani_cckerrs },
+	};
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, size - len, "%15s: %s\n", "ANI",
+			 common->disable_ani ? "DISABLED" : "ENABLED");
+
+	if (common->disable_ani)
+		goto exit;
+
+	for (i = 0; i < ARRAY_SIZE(ani_info); i++)
+		len += scnprintf(buf + len, size - len, "%15s: %u\n",
+				 ani_info[i].name, ani_info[i].val);
+
+exit:
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static ssize_t write_file_ani(struct file *file,
+			      const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	unsigned long ani;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &ani))
+		return -EINVAL;
+
+	if (ani > 1)
+		return -EINVAL;
+
+	common->disable_ani = !ani;
+
+	if (common->disable_ani) {
+		clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
+		ath9k_htc_stop_ani(priv);
+	} else {
+		ath9k_htc_check_ani(priv);
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_ani = {
+	.read = read_file_ani,
+	.write = write_file_ani,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 /* Ethtool support for get-stats */
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
 static const char ath9k_htc_gstrings_stats[][ETH_GSTRING_LEN] = {
@@ -524,5 +620,7 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	ath9k_cmn_debug_ack_to(priv->debug.debugfs_phy, priv->ah);
 #endif
 
+	debugfs_create_file("ani", 0600, priv->debug.debugfs_phy, priv, &fops_ani);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a82ad73..73f6fe1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1505,11 +1505,55 @@ static void ath9k_htc_choose_set_bssid(struct ath9k_htc_priv *priv)
 	}
 }
 
+void ath9k_htc_check_ani(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_beacon_config *cur_conf = &priv->cur_beacon_conf;
+
+	/*
+	 * Check for the various conditions in which ANI has to
+	 * be stopped.
+	 */
+	if (ah->opmode == NL80211_IFTYPE_ADHOC) {
+		if (!cur_conf->enable_beacon)
+			goto stop_ani;
+	} else if (ah->opmode == NL80211_IFTYPE_AP) {
+		if (!cur_conf->enable_beacon) {
+			/*
+			 * Disable ANI only when there are no
+			 * associated stations.
+			 */
+			if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
+				goto stop_ani;
+		}
+	} else if (ah->opmode == NL80211_IFTYPE_STATION) {
+		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
+			goto stop_ani;
+	}
+
+	if (!test_bit(ATH_OP_ANI_RUN, &common->op_flags)) {
+		set_bit(ATH_OP_ANI_RUN, &common->op_flags);
+		ath9k_htc_start_ani(priv);
+	}
+
+	return;
+
+stop_ani:
+	clear_bit(ATH_OP_ANI_RUN, &common->op_flags);
+	ath9k_htc_stop_ani(priv);
+}
+
 static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
+#define CHECK_ANI				\
+	(BSS_CHANGED_ASSOC |			\
+	 BSS_CHANGED_IBSS |			\
+	 BSS_CHANGED_BEACON_ENABLED)
+
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1609,8 +1653,13 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_HT)
 		ath9k_htc_update_rate(priv, vif, bss_conf);
 
+	if (changed & CHECK_ANI)
+		ath9k_htc_check_ani(priv);
+
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
+
+#undef CHECK_ANI
 }
 
 static u64 ath9k_htc_get_tsf(struct ieee80211_hw *hw,
-- 
1.7.0.4
