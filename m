Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1J1J7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 05:59:55 -0400
Subject: [PATCH] mac80211: disable powersave for broken APs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bill C Riemers <briemers@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 11:59:47 +0200
Message-ID: <1319795987.8931.7.camel@jlt3.sipsolutions.net> (sfid-20111028_115958_723700_DB411019)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only AID values 1-2007 are valid, but some APs have been
found to send random bogus values, in the reported case an
AP that was sending the AID field value 0xffff, an AID of
0x3fff (16383).

There isn't much we can do but disable powersave since
there's no way it can work properly in this case.

Cc: stable@vger.kernel.org
Reported-by: Bill C Riemers <briemers@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Bill, please test this patch and see if you still see the
warnings, or you can revert your iwlwifi changes and test
then, it should work.

John, please wait for Bill to test before you apply, just
to confirm it fixes the issue.

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-10-28 11:03:50.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-10-28 11:51:48.000000000 +0200
@@ -393,6 +393,7 @@ struct ieee80211_if_managed {
 
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
+	bool broken_ap; /* AP is broken -- turn off powersave */
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
 				 ap_smps, /* smps mode AP thinks we're in */
 				 driver_smps_mode; /* smps mode request */
--- a/net/mac80211/mlme.c	2011-10-12 17:11:31.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-10-28 11:57:50.000000000 +0200
@@ -637,6 +637,9 @@ static bool ieee80211_powersave_allowed(
 	if (!mgd->powersave)
 		return false;
 
+	if (mgd->broken_ap)
+		return false;
+
 	if (!mgd->associated)
 		return false;
 
@@ -1489,10 +1492,21 @@ static bool ieee80211_assoc_success(stru
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 
 	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
-		printk(KERN_DEBUG "%s: invalid aid value %d; bits 15:14 not "
-		       "set\n", sdata->name, aid);
+		printk(KERN_DEBUG
+		       "%s: invalid AID value 0x%x; bits 15:14 not set\n",
+		       sdata->name, aid);
 	aid &= ~(BIT(15) | BIT(14));
 
+	ifmgd->broken_ap = false;
+
+	if (aid == 0 || aid > IEEE80211_MAX_AID) {
+		printk(KERN_DEBUG
+		       "%s: invalid AID value %d (out of range), turn off PS\n",
+		       sdata->name, aid);
+		aid = 0;
+		ifmgd->broken_ap = true;
+	}
+
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 


