Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48797 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZDQUE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 16:04:57 -0400
Date: Fri, 17 Apr 2009 23:04:48 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not call cfg80211_send_disassoc with rcu held
Message-ID: <20090417200448.GA24430@jm.kir.nu> (sfid-20090417_220458_872228_D83B9737)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_send_mlme_event() uses GFP_KERNEL and could sleep. Better not
call it with rcu_read_lock held.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/mlme.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- uml.orig/net/mac80211/mlme.c	2009-04-16 11:04:05.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-04-17 23:00:01.000000000 +0300
@@ -874,15 +874,6 @@ static void ieee80211_set_disassoc(struc
 		ieee80211_rx_bss_put(local, bss);
 	}
 
-	if (self_disconnected) {
-		if (deauth)
-			ieee80211_send_deauth_disassoc(sdata,
-				IEEE80211_STYPE_DEAUTH, reason);
-		else
-			ieee80211_send_deauth_disassoc(sdata,
-				IEEE80211_STYPE_DISASSOC, reason);
-	}
-
 	ifmgd->flags &= ~IEEE80211_STA_ASSOCIATED;
 	changed |= ieee80211_reset_erp_info(sdata);
 
@@ -901,6 +892,15 @@ static void ieee80211_set_disassoc(struc
 
 	rcu_read_unlock();
 
+	if (self_disconnected) {
+		if (deauth)
+			ieee80211_send_deauth_disassoc(sdata,
+				IEEE80211_STYPE_DEAUTH, reason);
+		else
+			ieee80211_send_deauth_disassoc(sdata,
+				IEEE80211_STYPE_DISASSOC, reason);
+	}
+
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 

-- 
Jouni Malinen                                            PGP id EFC895FA
