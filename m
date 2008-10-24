Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYJXSen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:34:43 -0400
Message-Id: <20081024183323.354025000@sipsolutions.net> (sfid-20081024_203446_937137_58C58EDE)
References: <20081024183219.735241000@sipsolutions.net>
Date: Fri, 24 Oct 2008 20:32:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] wireless: clean up regulatory ignore_request function
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function has a few WARNs that may eventually trigger
when an AP sends rogue beacons, those must be removed. Some
of the comments in the function are also inappropriate as
this function is concerned with the global hint, not a per-
wiphy thing (which a multidomain flag on a wiphy would imply).

I'm convinced that we don't need to do anything to implement
multi-domain capability as 802.11-2007 specifies it because
it makes only two things mandatory:
 * starting of BSS/IBSS must have country information
   (this can easily be done with a mac80211 patch)
 * a STA must adopt the country information (we already have
   the framework for this)

But we don't have anything implemented anyway for now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |   67 +++++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-10-24 11:06:46.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-24 11:09:16.000000000 +0200
@@ -311,24 +311,25 @@ static int ignore_request(struct wiphy *
 	case REGDOM_SET_BY_INIT:
 		return -EINVAL;
 	case REGDOM_SET_BY_CORE:
-		/* Always respect new wireless core hints, should only
-		 * come in for updating the world regulatory domain at init
-		 * anyway */
+		/*
+		 * Always respect new wireless core hints, should only happen
+		 * when updating the world regulatory domain at init.
+		 */
 		return 0;
 	case REGDOM_SET_BY_COUNTRY_IE:
+		if (unlikely(!is_an_alpha2(alpha2)))
+			return -EINVAL;
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
 			if (last_request->wiphy != wiphy) {
-				/* Two cards with two APs claiming different
-				 * different Country IE alpha2s!
-				 * You're special!! */
-				if (!alpha2_equal(last_request->alpha2,
-						cfg80211_regdomain->alpha2)) {
-					/* XXX: Deal with conflict, consider
-					 * building a new one out of the
-					 * intersection */
-					WARN_ON(1);
+				/*
+				 * Two cards with two APs claiming different
+				 * different Country IE alpha2s. We could
+				 * intersect them, but that seems unlikely
+				 * to be correct. Reject second one for now.
+				 */
+				if (!alpha2_equal(alpha2,
+						  cfg80211_regdomain->alpha2))
 					return -EOPNOTSUPP;
-				}
 				return -EALREADY;
 			}
 			/* Two consecutive Country IE hints on the same wiphy */
@@ -336,42 +337,28 @@ static int ignore_request(struct wiphy *
 				return 0;
 			return -EALREADY;
 		}
-		if (WARN_ON(!is_alpha2_set(alpha2) || !is_an_alpha2(alpha2)),
-				"Invalid Country IE regulatory hint passed "
-				"to the wireless core\n")
-			return -EINVAL;
-		/* We ignore Country IE hints for now, as we haven't yet
-		 * added the dot11MultiDomainCapabilityEnabled flag
-		 * for wiphys */
-		return 1;
+		/*
+		 * Ignore Country IE hints for now, need to think about
+		 * what we need to do to support multi-domain operation.
+		 */
+		return -EOPNOTSUPP;
 	case REGDOM_SET_BY_DRIVER:
-		BUG_ON(!wiphy);
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
 			return -EALREADY;
-		if (last_request->initiator == REGDOM_SET_BY_CORE)
-			return 0;
-		/* XXX: Handle intersection, and add the
-		 * dot11MultiDomainCapabilityEnabled flag to wiphy. For now
-		 * we assume the driver has this set to false, following the
-		 * 802.11d dot11MultiDomainCapabilityEnabled documentation */
-		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-			return 0;
 		return 0;
 	case REGDOM_SET_BY_USER:
-		if (last_request->initiator == REGDOM_SET_BY_USER ||
-		    last_request->initiator == REGDOM_SET_BY_CORE)
-			return 0;
-		/* Drivers can use their wiphy's reg_notifier()
-		 * to override any information */
-		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
-			return 0;
-		/* XXX: Handle intersection */
+		/*
+		 * If the user wants to override the AP's hint, we may
+		 * need to follow both and use the intersection. For now,
+		 * reject any such attempt (but we don't support country
+		 * IEs right now anyway.)
+		 */
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return -EOPNOTSUPP;
 		return 0;
-	default:
-		return -EINVAL;
 	}
+
+	return -EINVAL;
 }
 
 /* Used by nl80211 before kmalloc'ing our regulatory domain */

-- 

