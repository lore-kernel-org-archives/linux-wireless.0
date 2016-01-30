Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:53814 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100AbcA3RCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 12:02:21 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH v3 6/6] libertas: add an cfg80211 interface for powersaving
Date: Sat, 30 Jan 2016 18:01:56 +0100
Message-Id: <1454173316-13444-7-git-send-email-andreas@kemnade.info> (sfid-20160130_180311_722239_9518F1CA)
In-Reply-To: <1454173316-13444-1-git-send-email-andreas@kemnade.info>
References: <1454173316-13444-1-git-send-email-andreas@kemnade.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an interface for handling commands like
iwconfig wlanX power on/off. Such an interface formerly existed
when the driver used wext.

While performance with sdio in polling mode without using
powersave mode is quite bad, powersaving mode is unusable,
so do not enable it under such conditions.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
changes in v3: corrected paths
changes in v2: reordered, was 3/6
 drivers/net/wireless/marvell/libertas/cfg.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 8317afd..fd18d03 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -2038,6 +2038,43 @@ static int lbs_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 
 
+int lbs_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+		       bool enabled, int timeout)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+
+	if  (!(priv->fwcapinfo & FW_CAPINFO_PS)) {
+		if (!enabled)
+			return 0;
+		else
+			return -EINVAL;
+	}
+	/* firmware does not work well with too long latency with power saving
+	 * enabled, so do not enable it if there is only polling, no
+	 * interrupts (like in some sdio hosts which can only
+	 * poll for sdio irqs)
+	 */
+	if  (priv->is_polling) {
+		if (!enabled)
+			return 0;
+		else
+			return -EINVAL;
+	}
+	if (!enabled) {
+		priv->psmode = LBS802_11POWERMODECAM;
+		if (priv->psstate != PS_STATE_FULL_POWER)
+			lbs_set_ps_mode(priv,
+					PS_MODE_ACTION_EXIT_PS,
+					true);
+		return 0;
+	}
+	if (priv->psmode != LBS802_11POWERMODECAM)
+		return 0;
+	priv->psmode = LBS802_11POWERMODEMAX_PSP;
+	if (priv->connect_status == LBS_CONNECTED)
+		lbs_set_ps_mode(priv, PS_MODE_ACTION_ENTER_PS, true);
+	return 0;
+}
 
 /*
  * Initialization
@@ -2056,6 +2093,7 @@ static struct cfg80211_ops lbs_cfg80211_ops = {
 	.change_virtual_intf = lbs_change_intf,
 	.join_ibss = lbs_join_ibss,
 	.leave_ibss = lbs_leave_ibss,
+	.set_power_mgmt = lbs_set_power_mgmt,
 };
 
 
-- 
2.1.4

