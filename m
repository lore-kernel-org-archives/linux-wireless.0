Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbXIFNp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:45:57 -0400
Message-Id: <20070905234626.748078000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/21] mac80211: fix warnings introduced by the doc patches
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

--- wireless-dev.orig/net/mac80211/util.c	2007-09-06 01:34:56.144453431 +0200
+++ wireless-dev/net/mac80211/util.c	2007-09-06 01:35:20.344453431 +0200
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

