Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3C0Qv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:51:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] mac80211: replace some dead code by a warning
Date: Wed, 27 Mar 2013 17:51:21 +0100
Message-Id: <1364403082-20722-3-git-send-email-johannes@sipsolutions.net> (sfid-20130327_175135_750553_98A4E938)
In-Reply-To: <1364403082-20722-1-git-send-email-johannes@sipsolutions.net>
References: <1364403082-20722-1-git-send-email-johannes@sipsolutions.net>
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

