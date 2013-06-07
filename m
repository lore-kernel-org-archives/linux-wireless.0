Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:39787 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3FGNgW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:22 -0400
Received: from 89-71-197-70.dynamic.chello.pl (HELO localhost.localdomain) (moorray3@[89.71.197.70])
          (envelope-sender <moorray3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Jun 2013 15:36:20 +0200
From: Jakub Kicinski <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: [RFC 2/5] mac80211: return new mac address as soon as possible
Date: Fri,  7 Jun 2013 15:36:16 +0200
Message-Id: <1370612179-24385-3-git-send-email-moorray3@wp.pl> (sfid-20130607_153631_478950_5E8205D8)
In-Reply-To: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Once one of wiphy->addresses is found to be unused
we can return from __ieee80211_assign_perm_addr and
use it. The same for masked addresses.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/iface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dbee397..38898b3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1449,7 +1449,7 @@ static void __ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		if (!used) {
 			memcpy(perm_addr, local->hw.wiphy->addresses[i].addr,
 			       ETH_ALEN);
-			break;
+			return;
 		}
 	}
 
@@ -1507,10 +1507,12 @@ static void __ieee80211_assign_perm_addr(struct ieee80211_local *local,
 
 		if (!used) {
 			memcpy(perm_addr, tmp_addr, ETH_ALEN);
-			break;
+			return;
 		}
 		addr = (start & ~mask) | (val & mask);
 	} while (addr != start);
+
+	pr_debug("no free address found - using default\n");
 }
 
 static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
-- 
1.8.1.4

