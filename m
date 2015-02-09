Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:52539 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933484AbbBIT33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 14:29:29 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, pstew@chromium.org,
	samueltan@chromium.org
Date: Mon,  9 Feb 2015 21:29:15 +0200
Message-Id: <1423510155-7449-1-git-send-email-luca@coelho.fi> (sfid-20150209_202932_753859_1F4F9AC9)
Subject: [PATCH] nl80211: use loop index as type for net detect frequency results
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Tan <samueltan@chromium.org>

We currently add nested members of the NL80211_ATTR_SCAN_FREQUENCIES
as NLA_U32 attributes of type NL80211_ATTR_WIPHY_FREQ in
cfg80211_net_detect_results. However, since there can be an arbitrary number of
frequency results, we should use the loop index of the loop used to add the
frequency results to NL80211_ATTR_SCAN_FREQUENCIES as the type (i.e. nla_type)
for each result attribute, rather than a fixed type.

This change is in line with how nested members are added to
NL80211_ATTR_SCAN_FREQUENCIES in the functions nl80211_send_wowlan_nd and
nl80211_add_scan_req.

Signed-off-by: Samuel Tan <samueltan@chromium.org>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 454d7a0..57ab1ac 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12520,9 +12520,7 @@ static int cfg80211_net_detect_results(struct sk_buff *msg,
 			}
 
 			for (j = 0; j < match->n_channels; j++) {
-				if (nla_put_u32(msg,
-						NL80211_ATTR_WIPHY_FREQ,
-						match->channels[j])) {
+				if (nla_put_u32(msg, j, match->channels[j])) {
 					nla_nest_cancel(msg, nl_freqs);
 					nla_nest_cancel(msg, nl_match);
 					goto out;
-- 
2.1.4

