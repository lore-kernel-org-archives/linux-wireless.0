Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37676 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2CNOPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 10:15:05 -0400
Received: by wibhq7 with SMTP id hq7so2672822wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2012 07:15:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: make uapsd_* keys per-vif
Date: Wed, 14 Mar 2012 16:15:03 +0200
Message-Id: <1331734503-22049-2-git-send-email-eliad@wizery.com> (sfid-20120314_151511_454230_07041075)
In-Reply-To: <1331734503-22049-1-git-send-email-eliad@wizery.com>
References: <1331734503-22049-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uapsd_queues and uapsd_max_sp_len are relevant only for managed
interfaces, and can be configured differently for each vif.

Move them from the local struct to sdata->u.mgd, and update
the debugfs functions accordingly.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/debugfs.c        |   81 -----------------------------------------
 net/mac80211/debugfs_netdev.c |   58 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h    |   28 +++++++-------
 net/mac80211/main.c           |    2 -
 net/mac80211/mlme.c           |    8 +++--
 net/mac80211/tx.c             |    4 +-
 6 files changed, 79 insertions(+), 102 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 483e96e..cc5b7a6 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -97,85 +97,6 @@ static const struct file_operations reset_ops = {
 	.llseek = noop_llseek,
 };
 
-static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
-				 size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
-				      local->uapsd_queues);
-}
-
-static ssize_t uapsd_queues_write(struct file *file,
-				  const char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	u8 val;
-	int ret;
-
-	ret = kstrtou8_from_user(user_buf, count, 0, &val);
-	if (ret)
-		return ret;
-
-	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
-		return -ERANGE;
-
-	local->uapsd_queues = val;
-
-	return count;
-}
-
-static const struct file_operations uapsd_queues_ops = {
-	.read = uapsd_queues_read,
-	.write = uapsd_queues_write,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
-
-static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-
-	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
-				      local->uapsd_max_sp_len);
-}
-
-static ssize_t uapsd_max_sp_len_write(struct file *file,
-				      const char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	unsigned long val;
-	char buf[10];
-	size_t len;
-	int ret;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-	buf[len] = '\0';
-
-	ret = kstrtoul(buf, 0, &val);
-
-	if (ret)
-		return -EINVAL;
-
-	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
-		return -ERANGE;
-
-	local->uapsd_max_sp_len = val;
-
-	return count;
-}
-
-static const struct file_operations uapsd_max_sp_len_ops = {
-	.read = uapsd_max_sp_len_read,
-	.write = uapsd_max_sp_len_write,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
-
 static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 		       size_t count, loff_t *ppos)
 {
@@ -362,8 +283,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
-	DEBUGFS_ADD(uapsd_queues);
-	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index ef5cf26..a32eeda 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -337,6 +337,62 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 
 __IEEE80211_IF_FILE_W(tkip_mic_test);
 
+static ssize_t ieee80211_if_fmt_uapsd_queues(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	return snprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_queues);
+}
+
+static ssize_t ieee80211_if_parse_uapsd_queues(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+		return -ERANGE;
+
+	ifmgd->uapsd_queues = val;
+
+	return buflen;
+}
+__IEEE80211_IF_FILE_W(uapsd_queues);
+
+static ssize_t ieee80211_if_fmt_uapsd_max_sp_len(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	return snprintf(buf, buflen, "0x%x\n", ifmgd->uapsd_max_sp_len);
+}
+
+static ssize_t ieee80211_if_parse_uapsd_max_sp_len(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return -EINVAL;
+
+	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+		return -ERANGE;
+
+	ifmgd->uapsd_max_sp_len = val;
+
+	return buflen;
+}
+__IEEE80211_IF_FILE_W(uapsd_max_sp_len);
+
 /* AP attributes */
 IEEE80211_IF_FILE(num_sta_authorized, u.ap.num_sta_authorized, ATOMIC);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
@@ -469,6 +525,8 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(ave_beacon);
 	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
+	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 796b13b..20597db 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -460,6 +460,20 @@ struct ieee80211_if_managed {
 		IEEE80211_MFP_REQUIRED
 	} mfp; /* management frame protection */
 
+	/*
+	 * Bitmask of enabled u-apsd queues,
+	 * IEEE80211_WMM_IE_STA_QOSINFO_AC_BE & co. Needs a new association
+	 * to take effect.
+	 */
+	unsigned int uapsd_queues;
+
+	/*
+	 * Maximum number of buffered frames AP can deliver during a
+	 * service period, IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL or similar.
+	 * Needs a new association to take effect.
+	 */
+	unsigned int uapsd_max_sp_len;
+
 	int wmm_last_param_set;
 
 	u8 use_4addr;
@@ -1018,20 +1032,6 @@ struct ieee80211_local {
 				*/
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
-	/*
-	 * Bitmask of enabled u-apsd queues,
-	 * IEEE80211_WMM_IE_STA_QOSINFO_AC_BE & co. Needs a new association
-	 * to take effect.
-	 */
-	unsigned int uapsd_queues;
-
-	/*
-	 * Maximum number of buffered frames AP can deliver during a
-	 * service period, IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL or similar.
-	 * Needs a new association to take effect.
-	 */
-	unsigned int uapsd_max_sp_len;
-
 	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7f99551..c206fbb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -595,8 +595,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
-	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
-	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 
 	INIT_LIST_HEAD(&local->interfaces);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c08924a..a1d47d0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -583,8 +583,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (assoc_data->wmm_used && local->hw.queues >= 4) {
 		if (assoc_data->uapsd_used) {
-			qos_info = local->uapsd_queues;
-			qos_info |= (local->uapsd_max_sp_len <<
+			qos_info = ifmgd->uapsd_queues;
+			qos_info |= (ifmgd->uapsd_max_sp_len <<
 				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
 		} else {
 			qos_info = 0;
@@ -1203,7 +1203,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		return;
 
 	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
-		uapsd_queues = local->uapsd_queues;
+		uapsd_queues = ifmgd->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)
@@ -3107,6 +3107,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->flags = 0;
 	ifmgd->powersave = sdata->wdev.ps;
+	ifmgd->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+	ifmgd->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 
 	mutex_init(&ifmgd->mtx);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 570737d..51907be 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -226,12 +226,12 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	 * have correct qos tag for some reason, due the network or the
 	 * peer application.
 	 *
-	 * Note: local->uapsd_queues access is racy here. If the value is
+	 * Note: ifmgd->uapsd_queues access is racy here. If the value is
 	 * changed via debugfs, user needs to reassociate manually to have
 	 * everything in sync.
 	 */
 	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
-	    && (local->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+	    && (ifmgd->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 	    && skb_get_queue_mapping(tx->skb) == 0)
 		return TX_CONTINUE;
 
-- 
1.7.6.401.g6a319

