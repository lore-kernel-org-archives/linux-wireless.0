Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43221 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2FRNck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 09:32:40 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] mac80211: cleanup offchannel_ps_enable argument
Date: Mon, 18 Jun 2012 19:03:52 +0530
Message-ID: <1340026432-18947-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120618_153243_568687_A7913C76)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'tell_ap' argument is always true. So that remove it
and simplify the function.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/offchannel.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index abb226d..1d9d687 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -25,8 +25,7 @@
  * because we *may* be doing work on-operating channel, and want our
  * hardware unconditionally awake, but still let the AP send us normal frames.
  */
-static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
-					   bool tell_ap)
+static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -47,8 +46,8 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
-	if (tell_ap && (!local->offchannel_ps_enabled ||
-			!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)))
+	if (!local->offchannel_ps_enabled ||
+	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
 		 * frame because AP knows that we are sleeping. But if the
@@ -133,7 +132,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 			if (offchannel_ps_enable &&
 			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
 			    sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_enable(sdata, true);
+				ieee80211_offchannel_ps_enable(sdata);
 		}
 	}
 	mutex_unlock(&local->iflist_mtx);
-- 
1.7.10.4

