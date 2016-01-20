Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:44648 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbcATHmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 02:42:51 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: kvalo@codeaurora.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	hns@goldelico.com
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH RFC] wireless:libertas: enable auto deep sleep
Date: Wed, 20 Jan 2016 08:41:49 +0100
Message-Id: <1453275709-25276-1-git-send-email-andreas@kemnade.info> (sfid-20160120_084310_505214_68261B30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enables auto deep sleep whenever the interface is up and
power managament is enabled, so there is also power management
when there is no connection
That reduces power consumption between scanning
intervals. Deep sleep mode is entered when there is
no activity for 1s.

The code looks a bit different to how things were done
with the wext interface in earlier times.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/net/wireless/libertas/cfg.c  |  3 +++
 drivers/net/wireless/libertas/main.c | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index fd18d03..bb6d8fd 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -2066,6 +2066,7 @@ int lbs_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			lbs_set_ps_mode(priv,
 					PS_MODE_ACTION_EXIT_PS,
 					true);
+		lbs_exit_auto_deep_sleep(priv);
 		return 0;
 	}
 	if (priv->psmode != LBS802_11POWERMODECAM)
@@ -2073,6 +2074,8 @@ int lbs_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	priv->psmode = LBS802_11POWERMODEMAX_PSP;
 	if (priv->connect_status == LBS_CONNECTED)
 		lbs_set_ps_mode(priv, PS_MODE_ACTION_ENTER_PS, true);
+	priv->auto_deep_sleep_timeout = 1000; /* 1000ms */
+	lbs_enter_auto_deep_sleep(priv);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index b35b8bc..82e69ca 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -161,6 +161,11 @@ int lbs_start_iface(struct lbs_private *priv)
 	lbs_update_channel(priv);
 
 	priv->iface_running = true;
+	/* if deep sleep was enabled before
+	 * the interface was brought down, reenable it
+	 */
+	if (priv->is_auto_deep_sleep_enabled)
+		lbs_enter_auto_deep_sleep(priv);
 	return 0;
 
 err:
@@ -227,6 +232,10 @@ int lbs_stop_iface(struct lbs_private *priv)
 
 	cancel_work_sync(&priv->mcast_work);
 	del_timer_sync(&priv->tx_lockup_timer);
+	/* autosleep should not mess with commands
+	 * when the interface is powered down
+	 */
+	del_timer_sync(&priv->auto_deepsleep_timer);
 
 	/* Disable command processing, and wait for all commands to complete */
 	lbs_deb_main("waiting for commands to complete\n");
@@ -824,7 +833,8 @@ static void auto_deepsleep_timer_fn(unsigned long data)
 	} else {
 		if (priv->is_auto_deep_sleep_enabled &&
 		    (!priv->wakeup_dev_required) &&
-		    (priv->connect_status != LBS_CONNECTED)) {
+		    (priv->connect_status != LBS_CONNECTED) &&
+		    priv->iface_running) {
 			struct cmd_header cmd;
 
 			lbs_deb_main("Entering auto deep sleep mode...\n");
-- 
2.1.4

