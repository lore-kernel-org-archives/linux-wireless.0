Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0FIK4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 06:56:30 -0400
Subject: [PATCH v2] mac80211: fix deauth before assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Miles Lane <miles.lane@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
References: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:56:26 +0200
Message-ID: <1276080986.14580.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we receive a deauthentication frame before
having successfully associated, we neither print
a message nor abort assocation. The former makes
it hard to debug, while the latter later causes
a warning in cfg80211 when, as will typically be
the case, association timed out.

This warning was reported by many, e.g. in
https://bugzilla.kernel.org/show_bug.cgi?id=15981,
but I couldn't initially pinpoint it. I verified
the fix by hacking hostapd to send a deauth frame
instead of an association response.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
That previous one didn't even apply to the right tree, how did you ever
test it? Or did you just fix up the context?

 net/mac80211/mlme.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-09 12:51:33.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-09 12:54:35.000000000 +0200
@@ -1760,8 +1760,45 @@ static void ieee80211_sta_rx_queued_mgmt
 	mutex_unlock(&ifmgd->mtx);
 
 	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
-	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH)
+	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
+		struct ieee80211_local *local = sdata->local;
+		struct ieee80211_work *wk;
+
+		mutex_lock(&local->work_mtx);
+		list_for_each_entry(wk, &local->work_list, list) {
+			if (wk->sdata != sdata)
+				continue;
+
+			if (wk->type != IEEE80211_WORK_ASSOC)
+				continue;
+
+			if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
+				continue;
+			if (memcmp(mgmt->sa, wk->filter_ta, ETH_ALEN))
+				continue;
+
+			/*
+			 * Printing the message only here means we can't
+			 * spuriously print it, but it also means that it
+			 * won't be printed when the frame comes in before
+			 * we even tried to associate or in similar cases.
+			 *
+			 * Ultimately, I suspect cfg80211 should print the
+			 * messages instead.
+			 */
+			printk(KERN_DEBUG
+			       "%s: deauthenticated from %pM (Reason: %u)\n",
+			       sdata->name, mgmt->bssid,
+			       le16_to_cpu(mgmt->u.deauth.reason_code));
+
+			list_del_rcu(&wk->list);
+			free_work(wk);
+			break;
+		}
+		mutex_unlock(&local->work_mtx);
+
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
+	}
 
  out:
 	kfree_skb(skb);


