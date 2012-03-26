Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58141 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 11:23:00 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] mac80211: inform the offchannel status to AP if no powersave
Date: Mon, 26 Mar 2012 20:53:37 +0530
Message-ID: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120326_172305_818416_B00687BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station has to inform the offchannel status to the assiociated AP
while switching b/w oper and off-channel. The station uses pspoll to
fetch the buffered data from the AP and the pspoll frame can only be
used when the powersave is enabled. For non-PS case, the station has
to use nullfunc frame notification. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/offchannel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f054e94..f7aedfc 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -129,7 +129,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
+			if ((offchannel_ps_enable || !sdata->u.mgd.powersave) &&
 			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata, true);
@@ -152,7 +152,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			continue;
 
 		/* Tell AP we're back */
-		if (offchannel_ps_disable &&
+		if ((offchannel_ps_disable || !sdata->u.mgd.powersave) &&
 		    sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_disable(sdata);
-- 
1.7.9.4

