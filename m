Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYFSSfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 14:35:17 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [RFC PATCH 2/2] mac80211: workaround for resetting the tx power
Date: Thu, 19 Jun 2008 21:35:12 +0300
Message-Id: <1213900512-21565-2-git-send-email-tomas.winkler@intel.com> (sfid-20080619_203521_649954_37AE7805)
In-Reply-To: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch is a workaround for the unreliable disassociation
flow. The resetting of the tx power is now performed upon
association/reassociation.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 313b02a..378ccd5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2148,6 +2148,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
 
+	/***********************************************************
+	 * Workaround - Until disassociation flow is trustworthy...
+	 ***********************************************************/
+	/* Reset power level. Get the tx power from the current channel/user.*/
+	if (ifsta->country_max_pwr || local->hw.conf.tpc_pwr_limit) {
+		ifsta->country_max_pwr = 0;
+		local->hw.conf.tpc_pwr_limit = 0;
+		ieee80211_hw_config(local);
+	}
+	/***********************************************************
+	 * End of Workaround
+	 ***********************************************************/
+
 	if (ifsta->state != IEEE80211_ASSOCIATE) {
 		printk(KERN_DEBUG "%s: association frame received from "
 		       "%s, but not in associate state - ignored\n",
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

