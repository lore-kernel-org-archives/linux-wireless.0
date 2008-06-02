Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYFBRcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:32:05 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2 V2] mac80211: removing shadowed sband
Date: Mon,  2 Jun 2008 20:31:57 +0300
Message-Id: <1212427917-7007-2-git-send-email-tomas.winkler@intel.com> (sfid-20080602_193212_304090_71A262F5)
In-Reply-To: <1212427917-7007-1-git-send-email-tomas.winkler@intel.com>
References: <1212427917-7007-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes doubly defined sband variable

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2f63739..6388b76 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -612,13 +612,10 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 
 	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
 	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
-		struct ieee80211_supported_band *sband;
 		struct ieee80211_rate *rate;
 		s8 baserate = -1;
 		int idx;
 
-		sband = tx->local->hw.wiphy->bands[tx->channel->band];
-
 		/* Do not use multiple retry rates when using RTS/CTS */
 		info->control.alt_retry_rate_idx = -1;
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

