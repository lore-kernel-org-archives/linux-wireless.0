Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:53716 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbZCPRdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 13:33:15 -0400
Subject: Oops and other problems in cfg80211
From: Quentin Armitage <Quentin@Armitage.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 16 Mar 2009 17:23:04 +0000
Message-Id: <1237224184.5027.600.camel@samson.armitage.org.uk> (sfid-20090316_183316_808159_596461D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If cfg80211 is compiled with CONFIG_WIRELESS_OLD_REGULATORY defined, if
insmod is loaded with "insmod cfg80211 ieee80211_regdom=EU" then the
execution of insmod mac80211, executing insmod ath5k causes an oops.
This is caused by wiphy_update_regulatory being called when last_request
== NULL, and the call of reg_is_world_roaming (via reg_process_beacons)
causes the oops at last_request->initiator != REGDOM_SET_BY_COUNTRY_IE.

If reg_is_world_roaming is modified to check for last_request not being
NULL, e.g.
if (last_request && last_request->initiator != REGDOM_SET_BY_COUNTRY_IE
&&
then I also get an oops in reg_device_remove where last_request is
referenced and there is only a subsequent check for it being NULL.

Even if the above two are fixed, it will not associate with the access
point, and `iwlist wlan0 channels` produces a rather confused list. It
appears that, despite the comment, in regulatory_init it is necessary to
call regulatory_hint_core even for the pseudo country EU.

Patch1 below covers the points above, although I am not sure how useful
the BUG_ON (!last_request) in reg_is_world_roaming is.

Having modified the above, I then found that the regulatory domain was
not being updated from the Country IE sent by the access point. It
appears that the code following the comment "so we optimize an early
check ..." in regulatory_hint_11d is a little over optimized, since if
the following if statement is true, every path through that block ends
in "goto out;". Patch 2 below allows the Country IE to be processed
(note it also needs an extra check around a WARN_ON, and so the
preceeding comment to that needs considering).

Quentin Armitage

=========  Patch 1 ================================================
--- a/net/wireless/reg.c	2009-03-13 05:14:06.000000000 +0000
+++ b/net/wireless/reg.c	2009-03-16 16:57:03.000000000 +0000
@@ -1128,6 +1128,8 @@ static bool reg_is_world_roaming(struct 
 	if (is_world_regdom(cfg80211_regdomain->alpha2) ||
 	    (wiphy->regd && is_world_regdom(wiphy->regd->alpha2)))
 		return true;
+
+	BUG_ON (!last_request) ;
 	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    wiphy->custom_regulatory)
 		return true;
@@ -2105,7 +2107,8 @@ void reg_device_remove(struct wiphy *wip
 
 	assert_cfg80211_lock();
 
-	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	if ( last_request )
+		request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
 	kfree(wiphy->regd);
 	if (!last_request || !request_wiphy)
@@ -2135,11 +2138,11 @@ int regulatory_init(void)
 	/*
 	 * The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
-	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2
+	 * stuck with the static values. We process "EU" code even though
+	 * that is not a valid ISO / IEC 3166 alpha2, since otherwise the
+	 * channels don't get set properly, and last_request is not set.
 	 */
-	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
-		err = regulatory_hint_core(ieee80211_regdom);
+	err = regulatory_hint_core(ieee80211_regdom);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
===============================================================

============= Patch 2 =======================================
--- a/net/wireless/reg.c	2009-03-16 16:55:11.000000000 +0000
+++ b/net/wireless/reg.c	2009-03-16 16:57:57.000000000 +0000
@@ -1692,7 +1692,8 @@ void regulatory_hint_11d(struct wiphy *w
 			 * to another country, and then gets IEs from an
 			 * AP with different settings
 			 */
-			goto out;
+			if (likely(last_request->initiator ==
NL80211_REGDOM_SET_BY_COUNTRY_IE))
+				goto out;
 		} else {
 			/*
 			 * Ignore IEs coming in on two separate wiphys with
@@ -1721,8 +1722,11 @@ void regulatory_hint_11d(struct wiphy *w
 	 * If we hit this before we add this support we want to be informed of
 	 * it as it would indicate a mistake in the current design
 	 */
-	if (WARN_ON(reg_same_country_ie_hint(wiphy, checksum)))
-		goto free_rd_out;
+	if (likely(last_request->initiator ==
NL80211_REGDOM_SET_BY_COUNTRY_IE))
+	{
+		if (WARN_ON(reg_same_country_ie_hint(wiphy, checksum)))
+			goto free_rd_out;
+	}
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
=============================================================

