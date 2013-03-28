Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3C1Pqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:46:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: replace some dead code by a warning
Date: Thu, 28 Mar 2013 16:46:35 +0100
Message-Id: <1364485596-30425-3-git-send-email-johannes@sipsolutions.net> (sfid-20130328_164654_315396_254B0680)
In-Reply-To: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net>
References: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Given the (nested) switch statements, this code can't
be reached, so make it warn instead of manipulating
the carrier state which seems purposeful.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2bdbf14..273d851 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -581,7 +581,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		case NL80211_IFTYPE_P2P_DEVICE:
 			break;
 		default:
-			netif_carrier_on(dev);
+			/* not reached */
+			WARN_ON(1);
 		}
 
 		/*
-- 
1.8.0

