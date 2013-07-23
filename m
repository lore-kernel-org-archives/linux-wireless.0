Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab3GWLx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 07:53:57 -0400
Date: Tue, 23 Jul 2013 13:56:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Subject: [PATCH] mac80211: fix monitor interface suspend crash regression
Message-ID: <20130723115650.GB1687@redhat.com> (sfid-20130723_135400_464775_6C416D8E)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My commit:

commit 12e7f517029dad819c45eca9ca01fdb9ba57616b
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Feb 28 10:55:26 2013 +0100

    mac80211: cleanup generic suspend/resume procedures

removed check for deleting MONITOR and AP_VLAN when suspend. That can
cause a crash (i.e. in iwlagn_mac_remove_interface()) since we remove
interface in the driver that we did not add before.

Reference:
http://marc.info/?l=linux-kernel&m=137391815113860&w=2

Bisected-by: Ortwin Glück <odi@odi.ch>
Reported-and-tested-by: Ortwin Glück <odi@odi.ch>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/pm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 7fc5d0d..3401262 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -99,10 +99,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* remove all interfaces */
+	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
+		if (!ieee80211_sdata_running(sdata) ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
+
 		drv_remove_interface(local, sdata);
 	}
 
-- 
1.7.11.7

