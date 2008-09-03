Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYICUm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:42:28 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] mac80211: Fix low bit rate in IBSS
Date: Wed,  3 Sep 2008 23:42:19 +0300
Message-Id: <1220474540-16737-3-git-send-email-tomas.winkler@intel.com> (sfid-20080903_224231_265676_AF22540C)
In-Reply-To: <1220474540-16737-2-git-send-email-tomas.winkler@intel.com>
References: <1220474540-16737-1-git-send-email-tomas.winkler@intel.com>
 <1220474540-16737-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes regression in iwlwifi IBSS rate scaling caused by patch:

    commit 6bc37c06bc424bcf3f944e6a79e2d5bb537e02ed
    Author: Vladimir Koutny <vlado@work.ksp.sk>
    Date:   Fri Jun 13 16:50:44 2008 +0200

        mac80211: eliminate IBSS warning in rate_lowest_index()

An IBSS station is added in prepare_for_handlers where the rate scaling was
initialized only with single rate matching the received packet.
The correct rate scale information should be updated only in
ieee80211_rx_bss_info function where beacon is parsed. Because
of coding error the rate info was left untouched.
If a beacon has triggered the connection the rate remined 1Mbps.
This patch fixes this coding error

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Vladimir Koutny <vlado@work.ksp.sk>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7d53382..75510a9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2595,7 +2595,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 							rx_status->band);
 
 		prev_rates = sta->supp_rates[rx_status->band];
-		sta->supp_rates[rx_status->band] &= supp_rates;
+		sta->supp_rates[rx_status->band] = supp_rates;
 		if (sta->supp_rates[rx_status->band] == 0) {
 			/* No matching rates - this should not really happen.
 			 * Make sure that at least one rate is marked
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

