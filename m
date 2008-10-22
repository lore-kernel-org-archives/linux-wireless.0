Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52426 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYJWDOA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 23:14:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 20:14:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: make use of regulatory tx power settings on change of tx power
Date: Wed, 22 Oct 2008 13:13:53 -0700
Message-ID: <1224706433-12582-1-git-send-email-lrodriguez@atheros.com> (sfid-20081023_051407_701491_5BD48F63)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not know what max power to allow until a device is targeting
a channel, therefore only allow changing tx power if a channel is defined.
Also make use of the channel's max power setting as defined by
regulatory rules before allowing the user to use the requested power
setting. If the user asked us to figure it out we use the max allowed
by regulatory.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/wext.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 31d2e74..c6167d2 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -656,6 +656,7 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 				      union iwreq_data *data, char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_channel* chan = local->hw.conf.channel;
 	u32 reconf_flags = 0;
 	int new_power_level;
 
@@ -663,20 +664,13 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 		return -EINVAL;
 	if (data->txpower.flags & IW_TXPOW_RANGE)
 		return -EINVAL;
+	if (!chan)
+		return -EINVAL;
 
-	if (data->txpower.fixed) {
-		new_power_level = data->txpower.value;
-	} else {
-		/*
-		 * Automatic power level. Use maximum power for the current
-		 * channel. Should be part of rate control.
-		 */
-		struct ieee80211_channel* chan = local->hw.conf.channel;
-		if (!chan)
-			return -EINVAL;
-
+	if (data->txpower.fixed)
+		new_power_level = min(data->txpower.value, chan->max_power);
+	else /* Automatic power level setting */
 		new_power_level = chan->max_power;
-	}
 
 	if (local->hw.conf.power_level != new_power_level) {
 		local->hw.conf.power_level = new_power_level;
-- 
1.5.6.3

