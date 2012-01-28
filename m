Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm21-vm3.bullet.mail.ukl.yahoo.com ([217.12.10.35]:49065 "HELO
	nm21-vm3.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751253Ab2A1HXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 02:23:11 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] mac80211: minstrel_ht should not override user supplied rts setting
Date: Sat, 28 Jan 2012 15:17:07 +0800
Message-Id: <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de> (sfid-20120128_082346_182122_66887F30)
In-Reply-To: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de>
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
---
 net/mac80211/rc80211_minstrel_ht.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ff5f7b8..9b889d7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -644,10 +644,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 				false, false);
 		else
 			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
-				false, true);
+				false, false);
 
 		minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate,
-				     false, !sample);
+				     false, false);
 
 		ar[3].count = 0;
 		ar[3].idx = -1;
@@ -658,7 +658,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		 * max_tp_rate -> max_prob_rate by default.
 		 */
 		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_prob_rate,
-				     false, !sample);
+				     false, false);
 
 		ar[2].count = 0;
 		ar[2].idx = -1;
-- 
1.7.5.4

