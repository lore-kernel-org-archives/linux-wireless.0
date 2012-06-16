Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28006 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2FPRIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 13:08:14 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: add a 2-way Authentication challenge to IBSS mode
Date: Sat, 16 Jun 2012 18:50:03 +0200
Message-Id: <1339865405-10787-3-git-send-email-ordex@autistici.org> (sfid-20120616_190852_914612_533E9B6C)
In-Reply-To: <1339865405-10787-1-git-send-email-ordex@autistici.org>
References: <1339865405-10787-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode, whenever a new station is added a 2-way authentication challenge
is performed. Actually this event can be used to recognise a new station joining
the cell even if its sta_info entry is already in the list.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ibss.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b253d0a..a497c03 100644
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
1.7.9.4

