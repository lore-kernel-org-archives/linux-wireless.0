Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbXHWQup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:50:45 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFtM-00012O-8o
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:50:44 +0100
Message-Id: <20070823164525.263344000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 10/11] mac80211: fix warnings introduced by the doc patches
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a warning about NUM_IEEE80211_MODES missing
in a switch statement. Intentionally do not add a default
case so we get warnings at these places if we need to add
new modes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/util.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-dev.orig/net/mac80211/util.c	2007-08-23 18:40:37.441897709 +0200
+++ wireless-dev/net/mac80211/util.c	2007-08-23 18:41:09.941897709 +0200
@@ -97,6 +97,9 @@ void ieee80211_prepare_rates(struct ieee
 			    rate->rate == 55 || rate->rate == 110)
 				rate->flags |= IEEE80211_RATE_BASIC;
 			break;
+		case NUM_IEEE80211_MODES:
+			/* not useful */
+			break;
 		}
 
 		/* Set ERP and MANDATORY flags based on phymode */
@@ -117,6 +120,9 @@ void ieee80211_prepare_rates(struct ieee
 			    rate->rate == 240)
 				rate->flags |= IEEE80211_RATE_MANDATORY;
 			break;
+		case NUM_IEEE80211_MODES:
+			/* not useful */
+			break;
 		}
 		if (ieee80211_is_erp_rate(mode->mode, rate->rate))
 			rate->flags |= IEEE80211_RATE_ERP;

-- 

