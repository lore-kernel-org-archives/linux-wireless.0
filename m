Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59096 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424Ab1J3NmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 09:42:07 -0400
Received: by wyg36 with SMTP id 36so5143973wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2011 06:42:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: use min rate as basic rate for buggy APs
Date: Sun, 30 Oct 2011 15:41:59 +0200
Message-Id: <1319982119-17803-1-git-send-email-eliad@wizery.com> (sfid-20111030_144214_190024_48DF25C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some buggy APs (and even P2P_GO) don't advertise their
basic rates in the association response.

In such case, use the min supported rate as the
basic rate.

Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: add debug print (Johannes)

 net/mac80211/mlme.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5d8da..d3672e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1482,6 +1482,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	int i, j, err;
 	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
+	int min_rate = INT_MAX, min_rate_index = -1;
 
 	/* AssocResp and ReassocResp have identical structure */
 
@@ -1537,6 +1538,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				rates |= BIT(j);
 				if (is_basic)
 					basic_rates |= BIT(j);
+				if (rate < min_rate) {
+					min_rate = rate;
+					min_rate_index = j;
+				}
 				break;
 			}
 		}
@@ -1554,11 +1559,25 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				rates |= BIT(j);
 				if (is_basic)
 					basic_rates |= BIT(j);
+				if (rate < min_rate) {
+					min_rate = rate;
+					min_rate_index = j;
+				}
 				break;
 			}
 		}
 	}
 
+	/*
+	 * some buggy APs don't advertise basic_rates. use the lowest
+	 * supported rate instead.
+	 */
+	if (unlikely(!basic_rates) && min_rate_index >= 0) {
+		printk(KERN_DEBUG "%s: No basic rates in AssocResp. "
+		       "Using min supported rate instead.\n", sdata->name);
+		basic_rates = BIT(min_rate_index);
+	}
+
 	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
-- 
1.7.6.401.g6a319

