Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1JYI0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 04:26:36 -0400
Received: by wyg36 with SMTP id 36so229727wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2011 01:26:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: use min rate as basic rate for buggy APs
Date: Tue, 25 Oct 2011 10:26:34 +0200
Message-Id: <1319531194-26839-1-git-send-email-eliad@wizery.com> (sfid-20111025_102641_751110_23F8ECB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some buggy APs (and even P2P_GO) don't advertise their
basic rates in the association response.

In such case, use the min supported rate as the
basic rate.

Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5d8da..064df37 100644
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
@@ -1554,11 +1559,22 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
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
+	if (unlikely(!basic_rates) && min_rate_index >= 0)
+		basic_rates = BIT(min_rate_index);
+
 	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
-- 
1.7.6.401.g6a319

