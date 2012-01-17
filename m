Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:42158 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2AQXLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 18:11:52 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv5 1/2] mac80211: add a 2-way Authentication challenge to IBSS mode
Date: Wed, 18 Jan 2012 00:10:43 +0100
Message-Id: <1326841844-6923-1-git-send-email-ordex@autistici.org> (sfid-20120118_001156_115041_D399DF08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode, whenever a new station is added a 2-way authentication challenge
is performed. Actually this event can be used to recognise a new station joining
the cell even if its sta_info entry is already in the list.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

- based on patch: "mac80211: fix IBSS auth frame DA"
- fixed auth flooding. Thank Nicolas Cavallari for pointing it out


 net/mac80211/ibss.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9b70689..1b6e9a8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -298,6 +298,13 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
+	       "(auth_transaction=1)\n", sdata->vif.addr,
+	       sdata->u.ibss.bssid, addr);
+#endif
+	ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
+			    addr, sdata->u.ibss.bssid, NULL, 0, 0);
 	return sta;
 }
 
-- 
1.7.3.4

