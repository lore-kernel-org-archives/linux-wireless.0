Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:53318 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517AbZJGB55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:57:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] libertas: Use lbs_is_cmd_allowed() check in command handling routines.
Date: Tue,  6 Oct 2009 19:20:28 -0700
Message-Id: <1254882028-26154-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

lbs_is_cmd_allowed() check is added in __lbs_cmd_async() and
lbs_prepare_and_send_command(). The check is removed from other places.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/cmd.c     |   34 ++++++++
 drivers/net/wireless/libertas/debugfs.c |   46 -----------
 drivers/net/wireless/libertas/decl.h    |    1 -
 drivers/net/wireless/libertas/scan.c    |   11 ---
 drivers/net/wireless/libertas/wext.c    |  133 -------------------------------
 5 files changed, 34 insertions(+), 191 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 3a3e894..0fb3125 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -75,6 +75,30 @@ static u8 is_command_allowed_in_ps(u16 cmd)
 }
 
 /**
+ *  @brief This function checks if the command is allowed.
+ *
+ *  @param priv         A pointer to lbs_private structure
+ *  @return             allowed or not allowed.
+ */
+
+static int lbs_is_cmd_allowed(struct lbs_private *priv)
+{
+	int ret = 1;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (!priv->is_auto_deep_sleep_enabled) {
+		if (priv->is_deep_sleep) {
+			lbs_deb_cmd("command not allowed in deep sleep\n");
+			ret = 0;
+		}
+	}
+
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
+}
+
+/**
  *  @brief Updates the hardware details like MAC address and regulatory region
  *
  *  @param priv    	A pointer to struct lbs_private structure
@@ -1452,6 +1476,11 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		goto done;
 	}
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
 	cmdnode = lbs_get_cmd_ctrl_node(priv);
 
 	if (cmdnode == NULL) {
@@ -2104,6 +2133,11 @@ static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 		goto done;
 	}
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		cmdnode = ERR_PTR(-EBUSY);
+		goto done;
+	}
+
 	cmdnode = lbs_get_cmd_ctrl_node(priv);
 	if (cmdnode == NULL) {
 		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 8a7e931..893a55c 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -117,11 +117,6 @@ static ssize_t lbs_sleepparams_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 		ret = -EFAULT;
@@ -162,11 +157,6 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	ret = lbs_cmd_802_11_sleep_params(priv, CMD_ACT_GET, &sp);
 	if (ret)
 		goto out_unlock;
@@ -233,9 +223,6 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	u8 freq;
 	int events = 0;
 
-	if (!lbs_is_cmd_allowed(priv))
-		return -EBUSY;
-
 	buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -288,9 +275,6 @@ static ssize_t lbs_threshold_write(uint16_t tlv_type, uint16_t event_mask,
 	char *buf;
 	int ret;
 
-	if (!lbs_is_cmd_allowed(priv))
-		return -EBUSY;
-
 	buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -460,11 +444,6 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		free_page(addr);
-		return -EBUSY;
-	}
-
 	offval.offset = priv->mac_offset;
 	offval.value = 0;
 
@@ -517,11 +496,6 @@ static ssize_t lbs_wrmac_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		res = -EBUSY;
-		goto out_unlock;
-	}
-
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
@@ -558,11 +532,6 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		free_page(addr);
-		return -EBUSY;
-	}
-
 	offval.offset = priv->bbp_offset;
 	offval.value = 0;
 
@@ -616,11 +585,6 @@ static ssize_t lbs_wrbbp_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		res = -EBUSY;
-		goto out_unlock;
-	}
-
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
@@ -657,11 +621,6 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		free_page(addr);
-		return -EBUSY;
-	}
-
 	offval.offset = priv->rf_offset;
 	offval.value = 0;
 
@@ -715,11 +674,6 @@ static ssize_t lbs_wrrf_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		res = -EBUSY;
-		goto out_unlock;
-	}
-
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 44f0b24..fb91c36 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -34,7 +34,6 @@ int lbs_process_event(struct lbs_private *priv, u32 event);
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
 int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
-int lbs_is_cmd_allowed(struct lbs_private *priv);
 int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
 int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index e468e15..6c95af3 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -950,11 +950,6 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	if (!priv->radio_on) {
 		ret = -EINVAL;
 		goto out;
@@ -1022,12 +1017,6 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		err = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", err);
-		return err;
-	}
-
 	/* iwlist should wait until the current scan is finished */
 	if (priv->scan_channel)
 		return -EAGAIN;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 38a451e..69dd19b 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -46,32 +46,6 @@ static inline void lbs_cancel_association_work(struct lbs_private *priv)
 }
 
 /**
- *  @brief This function checks if the command is allowed.
- *
- *  @param priv         A pointer to lbs_private structure
- *  @return             allowed or not allowed.
- */
-
-int lbs_is_cmd_allowed(struct lbs_private *priv)
-{
-	int         ret = 1;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->is_auto_deep_sleep_enabled) {
-		if (priv->is_deep_sleep) {
-			lbs_deb_wext("IOCTLS called when station"
-					"is in deep sleep\n");
-			ret = 0;
-		}
-	}
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return ret;
-}
-
-
-/**
  *  @brief Find the channel frequency power info with specific channel
  *
  *  @param priv 	A pointer to struct lbs_private structure
@@ -193,11 +167,6 @@ static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		lbs_deb_leave(LBS_DEB_WEXT);
-		return -EBUSY;
-	}
-
 	cfp = lbs_find_cfp_by_band_and_channel(priv, 0,
 					   priv->curbssparams.channel);
 
@@ -308,12 +277,6 @@ static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	if (vwrq->disabled)
 		val = MRVDRV_RTS_MAX_VALUE;
 
@@ -335,11 +298,6 @@ static int lbs_get_rts(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, &val);
 	if (ret)
 		goto out;
@@ -362,12 +320,6 @@ static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	if (vwrq->disabled)
 		val = MRVDRV_FRAG_MAX_VALUE;
 
@@ -389,11 +341,6 @@ static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, &val);
 	if (ret)
 		goto out;
@@ -443,11 +390,6 @@ static int lbs_get_txpow(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	if (!priv->radio_on) {
 		lbs_deb_wext("tx power off\n");
 		vwrq->value = 0;
@@ -481,11 +423,6 @@ static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
         if ((vwrq->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
                 return -EOPNOTSUPP;
 
@@ -534,11 +471,6 @@ static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	vwrq->disabled = 0;
 
 	if (vwrq->flags & IW_RETRY_LONG) {
@@ -907,9 +839,6 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv))
-		return NULL;
-
 	priv->wstats.status = priv->mode;
 
 	/* If we're not associated, all quality values are meaningless */
@@ -1010,12 +939,6 @@ static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1125,11 +1048,6 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	lbs_deb_wext("vwrq->value %d\n", vwrq->value);
 	lbs_deb_wext("vwrq->fixed %d\n", vwrq->fixed);
 
@@ -1188,11 +1106,6 @@ static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		lbs_deb_leave(LBS_DEB_WEXT);
-		return -EBUSY;
-	}
-
 	if (priv->connect_status == LBS_CONNECTED) {
 		vwrq->value = priv->cur_rate * 500000;
 
@@ -1219,11 +1132,6 @@ static int lbs_set_mode(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	if (   (*uwrq != IW_MODE_ADHOC)
 	    && (*uwrq != IW_MODE_INFRA)
 	    && (*uwrq != IW_MODE_AUTO)) {
@@ -1465,12 +1373,6 @@ static int lbs_set_encode(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1654,12 +1556,6 @@ static int lbs_set_encodeext(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1872,12 +1768,6 @@ static int lbs_set_auth(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1980,12 +1870,6 @@ static int lbs_get_auth(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	switch (dwrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_KEY_MGMT:
 		dwrq->value = priv->secinfo.key_mgmt;
@@ -2028,11 +1912,6 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	if (vwrq->disabled) {
 		lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 0);
 		goto out;
@@ -2152,12 +2031,6 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	if (!priv->radio_on) {
 		ret = -EINVAL;
 		goto out;
@@ -2285,12 +2158,6 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!lbs_is_cmd_allowed(priv)) {
-		ret = -EBUSY;
-		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-		return ret;
-	}
-
 	if (!priv->radio_on)
 		return -EINVAL;
 
-- 
1.5.4.3

