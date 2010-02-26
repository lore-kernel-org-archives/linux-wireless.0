Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38355 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800Ab0BZBGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 20:06:05 -0500
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] libertas: add auto auth mode feature
Date: Thu, 25 Feb 2010 17:16:36 -0800
Message-Id: <1267146996-3725-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Auto auth mode is enabled by default. If user doesn't specify the
auth mode, while association driver will first try with open mode
and then with shared key mode. If user specifies an auth mode,
auto auth is disabled and driver will not try association with
another auth mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/assoc.c |   22 +++++++++++++++++++++-
 drivers/net/wireless/libertas/dev.h   |    1 +
 drivers/net/wireless/libertas/main.c  |    1 +
 drivers/net/wireless/libertas/wext.c  |    4 ++++
 4 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index f03d5e4..95d3d4c 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -31,6 +31,9 @@ u8 lbs_bg_rates[MAX_RATES] =
 0x00, 0x00 };
 
 
+static int assoc_helper_wep_keys(struct lbs_private *priv,
+		struct assoc_request *assoc_req);
+
 /**
  *  @brief This function finds common rates between rates and card rates.
  *
@@ -610,7 +613,7 @@ static int lbs_assoc_post(struct lbs_private *priv,
 
 	if (status_code) {
 		lbs_mac_event_disconnected(priv);
-		ret = -1;
+		ret = status_code;
 		goto done;
 	}
 
@@ -813,7 +816,24 @@ static int lbs_try_associate(struct lbs_private *priv,
 		goto out;
 
 	ret = lbs_associate(priv, assoc_req, CMD_802_11_ASSOCIATE);
+	/* If the association fails with current auth mode, let's
+	 * try by changing the auth mode
+	 */
+	if ((priv->authtype_auto) &&
+			(ret == WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG) &&
+			(assoc_req->secinfo.wep_enabled) &&
+			(priv->connect_status != LBS_CONNECTED)) {
+		if (priv->secinfo.auth_mode == IW_AUTH_ALG_OPEN_SYSTEM)
+			priv->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
+		else
+			priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
+		if (!assoc_helper_wep_keys(priv, assoc_req))
+			ret = lbs_associate(priv, assoc_req,
+						CMD_802_11_ASSOCIATE);
+	}
 
+	if (ret)
+		ret = -1;
 out:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 6977ee8..058d172 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -133,6 +133,7 @@ struct lbs_private {
 	u8 wpa_ie_len;
 	u16 wep_tx_keyidx;
 	struct enc_key wep_keys[4];
+	u8 authtype_auto;
 
 	/* Wake On LAN */
 	uint32_t wol_criteria;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index cd8ed7f..0e24c96 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -831,6 +831,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->is_auto_deep_sleep_enabled = 0;
 	priv->wakeup_dev_required = 0;
 	init_waitqueue_head(&priv->ds_awake_q);
+	priv->authtype_auto = 1;
 
 	mutex_init(&priv->lock);
 
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 71f88a0..aad6263 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1440,8 +1440,10 @@ static int lbs_set_encode(struct net_device *dev,
 		set_bit(ASSOC_FLAG_WEP_TX_KEYIDX, &assoc_req->flags);
 
 	if (dwrq->flags & IW_ENCODE_RESTRICTED) {
+		priv->authtype_auto = 0;
 		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
 	} else if (dwrq->flags & IW_ENCODE_OPEN) {
+		priv->authtype_auto = 0;
 		assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	}
 
@@ -1620,8 +1622,10 @@ static int lbs_set_encodeext(struct net_device *dev,
 			goto out;
 
 		if (dwrq->flags & IW_ENCODE_RESTRICTED) {
+			priv->authtype_auto = 0;
 			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_SHARED_KEY;
 		} else if (dwrq->flags & IW_ENCODE_OPEN) {
+			priv->authtype_auto = 0;
 			assoc_req->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 		}
 
-- 
1.5.3.6

