Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZDTSZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 14:25:08 -0400
Subject: WARN on return of ieee80211_if_config
From: reinette chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 20 Apr 2009 11:31:11 -0700
Message-Id: <1240252271.5206.63.camel@rc-desk> (sfid-20090420_202513_315107_6248E432)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

In 2.6.30 we are starting to see people encountering a WARN when
resuming with HW rfkill enabled. The WARN is printed from
net/mac80211/pm.c:159 in 2.6.30, for current wireless-testing it is 
net/mac80211/util.c:1050.

With that function resuming multiple interfaces I do not know if it will
make sense to return an error code if one fails. So, it seems that
__ieee80211_resume()/ieee80211_reconfig() will always return zero. Even
so, the case where ieee80211_if_config() fails needs to be
accommodated. 

Would something like this make sense?

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 0273023..46f2961 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -156,8 +156,11 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
-			WARN_ON(ieee80211_if_config(sdata, changed));
-			ieee80211_bss_info_change_notify(sdata, ~0);
+			if (ieee80211_if_config(sdata, changed))
+				printk(KERN_DEBUG "%s: failed to configure interface\n",
+				       sdata->dev->name);
+			else
+				ieee80211_bss_info_change_notify(sdata, ~0);
 			break;
 		case NL80211_IFTYPE_WDS:
 			break;


Thank you

Reinette


