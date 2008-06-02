Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64654 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYFBPoT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:44:19 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] mac80211: removing shadowed sband
Date: Mon,  2 Jun 2008 18:44:12 +0300
Message-Id: <1212421452-5635-2-git-send-email-tomas.winkler@intel.com> (sfid-20080602_174422_429735_CA3CE41E)
In-Reply-To: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
References: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes doubly defined sband variable

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8a5b24d..f857d66 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -612,7 +612,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 
 	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
 	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
-		struct ieee80211_supported_band *sband;
 		struct ieee80211_rate *rate;
 		s8 baserate = -1;
 		int idx;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

