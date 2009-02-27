Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14154 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZB0EXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 23:23:37 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2009 20:23:36 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.27087.578785.199636@gargle.gargle.HOWL> (sfid-20090227_052340_698689_879ED2FE)
Date: Fri, 27 Feb 2009 09:49:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Notify the driver only when the beacon interval changes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the driver is unconditionally notified of beacon
interval. This is a problem in AP mode, because the driver has
to know that the beacon interval has actualy changed to recalculate
TBTT and reset the HW TSF. Fix this to make mac80211 notify the driver
only when the beacon interval has been reconfigured to a new value.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---

( CC the list properly this time. )

 net/mac80211/cfg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c43129e..58693e5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -451,7 +451,8 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	 * This is a kludge. beacon interval should really be part
 	 * of the beacon information.
 	 */
-	if (params->interval) {
+	if (params->interval && (sdata->local->hw.conf.beacon_int !=
+				 params->interval)) {
 		sdata->local->hw.conf.beacon_int = params->interval;
 		err = ieee80211_hw_config(sdata->local,
 					IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
-- 
1.6.1

