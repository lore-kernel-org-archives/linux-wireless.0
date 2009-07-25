Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZGYJ6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 05:58:37 -0400
Subject: [PATCH] mac80211: fix receiving deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 11:58:36 +0200
Message-Id: <1248515916.19945.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel reported a warning, which quite obviously comes
from an oversight in the code handling deauth frames,
and which resulted in multiple follow-up warnings due
to this missing handling. This patch adds the missing
deauth handling (telling cfg80211 about it) and also
removes the follow-up warnings since they could happen
due to races even if nothing is wrong. I've explained
the races in the comments.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/mac80211/mlme.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-25 11:03:12.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-25 11:55:35.000000000 +0200
@@ -2003,6 +2003,9 @@ static void ieee80211_sta_rx_queued_mgmt
 	case RX_MGMT_CFG80211_ASSOC:
 		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, skb->len);
 		break;
+	case RX_MGMT_CFG80211_DEAUTH:
+		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len, NULL);
+		break;
 	default:
 		WARN(1, "unexpected: %d", rma);
 	}
@@ -2498,8 +2501,13 @@ int ieee80211_mgd_deauth(struct ieee8021
 		}
 	}
 
-	/* cfg80211 should catch this... */
-	if (WARN_ON(!bssid)) {
+	/*
+	 * cfg80211 should catch this ... but it's racy since
+	 * we can receive a deauth frame, process it, hand it
+	 * to cfg80211 while that's in a locked section already
+	 * trying to tell us that the user wants to disconnect.
+	 */
+	if (!bssid) {
 		mutex_unlock(&ifmgd->mtx);
 		return -ENOLINK;
 	}
@@ -2524,8 +2532,13 @@ int ieee80211_mgd_disassoc(struct ieee80
 
 	mutex_lock(&ifmgd->mtx);
 
-	/* cfg80211 should catch that */
-	if (WARN_ON(&ifmgd->associated->cbss != req->bss)) {
+	/*
+	 * cfg80211 should catch this ... but it's racy since
+	 * we can receive a disassoc frame, process it, hand it
+	 * to cfg80211 while that's in a locked section already
+	 * trying to tell us that the user wants to disconnect.
+	 */
+	if (&ifmgd->associated->cbss != req->bss) {
 		mutex_unlock(&ifmgd->mtx);
 		return -ENOLINK;
 	}


