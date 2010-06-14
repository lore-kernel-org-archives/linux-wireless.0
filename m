Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38539 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0FNLCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 07:02:03 -0400
Received: from MSI-MTA.marvell.com (msi-mta.marvell.com [10.68.76.91]) by dakia2.marvell.com with ESMTP id lNKedUQxzyUCyNfo for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 04:02:02 -0700 (PDT)
Subject: [PATCH 2/3] Libertas: fix WARN_ON issues in cfg80211 support
From: Kiran Divekar <dkiran@marvell.com>
Reply-To: dkiran@marvell.com
To: <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 22:01:30 +0530
Message-ID: <1276533090.18884.10.camel@pe-lt028>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In following scenarios WARN_ON() in cfg80211 code was triggered.
a) Driver unload or card removal.
b) Disconnect from infra network
c) Adhoc start/join
d) Adhoc stop
Added following fixes to avoid WARN_ON() in cfg80211 code.
a) Ensured that cfg80211_disconnected() function defined in cfg80211
code will be called only in infra mode.
b) Solved timing issue by moving cfg80211_disconnected() call inside
lbs_cfg_disconnect().
c) Updated "wdev->ssid" in driver code after Adhoc join/start
d) Removed unnecessory cfg80211_disconnected() call in lbs_remove_card.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/libertas/cfg.c     |   37 ++++++++++---------------------
 drivers/net/wireless/libertas/cmdresp.c |    4 ++-
 drivers/net/wireless/libertas/main.c    |    2 -
 3 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 7322e0d..e4b0409 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1238,28 +1238,6 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-
-
-
-/* callback from lbs_cfg_disconnect() */
-static int lbs_cfg_ret_disconnect(struct lbs_private *priv, unsigned long dummy,
-			      struct cmd_header *resp)
-{
-	lbs_deb_enter(LBS_DEB_CFG80211);
-
-	cfg80211_disconnected(priv->dev,
-			      priv->disassoc_reason,
-			      NULL, 0, /* TODO? */
-			      GFP_KERNEL);
-
-	/* TODO: get rid of priv->connect_status */
-	priv->connect_status = LBS_CONNECTED;
-
-	lbs_deb_leave(LBS_DEB_CFG80211);
-	return 0;
-}
-
-
 static int lbs_cfg_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	u16 reason_code)
 {
@@ -1277,9 +1255,14 @@ static int lbs_cfg_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(cmd.macaddr, &priv->assoc_bss, ETH_ALEN);
 	cmd.reasoncode = cpu_to_le16(reason_code);
 
-	__lbs_cmd_async(priv, CMD_802_11_DEAUTHENTICATE,
-			&cmd.hdr, sizeof(cmd),
-			lbs_cfg_ret_disconnect, 0);
+	if (lbs_cmd_with_response(priv, CMD_802_11_DEAUTHENTICATE, &cmd))
+		return -EFAULT;
+
+	cfg80211_disconnected(priv->dev,
+			priv->disassoc_reason,
+			NULL, 0,
+			GFP_KERNEL);
+	priv->connect_status = LBS_DISCONNECTED;
 
 	return 0;
 }
@@ -1673,6 +1656,10 @@ static void lbs_join_post(struct lbs_private *priv,
 			    params->beacon_interval,
 			    fake_ie, fake - fake_ie,
 			    0, GFP_KERNEL);
+
+	memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
+	priv->wdev->ssid_len = params->ssid_len;
+
 	cfg80211_ibss_joined(priv->dev, bssid, GFP_KERNEL);
 
 	/* TODO: consider doing this at MACREG_INT_CODE_LINK_SENSED time */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 9c18227..52b543c 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -31,7 +31,9 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	 * It causes problem in the Supplicant
 	 */
 	msleep_interruptible(1000);
-	lbs_send_disconnect_notification(priv);
+
+	if (priv->wdev->iftype == NL80211_IFTYPE_STATION)
+		lbs_send_disconnect_notification(priv);
 
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 51b7e19..58b031c 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -932,8 +932,6 @@ void lbs_remove_card(struct lbs_private *priv)
 		lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
 
-	lbs_send_disconnect_notification(priv);
-
 	if (priv->is_deep_sleep) {
 		priv->is_deep_sleep = 0;
 		wake_up_interruptible(&priv->ds_awake_q);
-- 
1.7.1



