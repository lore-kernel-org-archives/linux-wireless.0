Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2KWHme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:42:34 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: disable HT advertising unless AP supports it
Date: Fri, 23 Nov 2012 08:43:00 +0100
Message-Id: <1353656580-12134-4-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084238_804173_782858A8)
In-Reply-To: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
References: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the AP doesn't support HT, or more importantly if
it does but we have to disable it because its IEs are
broken, don't advertise HT support in our association
request. Otherwise, we configure our channel to be a
20 MHz non-HT channel but the AP might still think we
support HT, or even 40 MHz.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 42b2c3f..6d49d6c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3267,6 +3267,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		sdata->needed_rx_chains = min(chains, local->rx_chains);
 	} else {
 		sdata->needed_rx_chains = 1;
+		sdata->u.mgd.flags |= IEEE80211_STA_DISABLE_HT;
 	}
 
 	/* will change later if needed */
-- 
1.8.0

