Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52292 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753153AbXJXVak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 17:30:40 -0400
Subject: [PATCH] mac80211: Accept auto txpower setting
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 23:30:36 +0200
Message-Id: <1193261436.10211.1.camel@localhost> (sfid-20071024_223052_420033_537F0740)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the SIWTXPOWER ioctl to also accept a txpower setting of
"automatic". Since mac80211 currently cannot tell drivers to automatically
adjust tx power, we select the tx power level of the current channel. While
this is kind of a hack, it certainly saves some iwconfig users from headaches.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/ieee80211_ioctl.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 83e4035..2667a80 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -632,22 +632,35 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	bool need_reconfig = 0;
+	u8 new_power_level;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
 		return -EINVAL;
 	if (data->txpower.flags & IW_TXPOW_RANGE)
 		return -EINVAL;
-	if (!data->txpower.fixed)
-		return -EINVAL;
 
-	if (local->hw.conf.power_level != data->txpower.value) {
-		local->hw.conf.power_level = data->txpower.value;
+	if (data->txpower.fixed) {
+		new_power_level = data->txpower.value;
+	} else {
+		/* Automatic power level. Get the px power from the current
+		 * channel. */
+		struct ieee80211_channel* chan = local->oper_channel;
+		if (!chan)
+			return -EINVAL;
+
+		new_power_level = chan->power_level;
+	}
+
+	if (local->hw.conf.power_level != new_power_level) {
+		local->hw.conf.power_level = new_power_level;
 		need_reconfig = 1;
 	}
+
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
 		local->hw.conf.radio_enabled = !(data->txpower.disabled);
 		need_reconfig = 1;
 	}
+
 	if (need_reconfig) {
 		ieee80211_hw_config(local);
 		/* The return value of hw_config is not of big interest here,
-- 
1.5.3.4

