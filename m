Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2FUNw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:52:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] iwlwifi: fix radio reset scan dwell vs. quiet time
Date: Thu, 21 Jun 2012 15:52:51 +0200
Message-Id: <1340286773-2381-2-git-send-email-johannes@sipsolutions.net> (sfid-20120621_155302_275774_D081F8A6)
In-Reply-To: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
References: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My previous commit to shorten the radio reset time
caused issues as the firmware checks the active
dwell time against the quiet time, asserting that
the dwell is >= quiet time. This isn't really
needed in case of passive scanning like here, but
of course we need to pass that check.

To fix this, override the quiet time to be the
same as the radio reset dwell time.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/scan.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index f5b1452..6633074 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -720,6 +720,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	switch (priv->scan_type) {
 	case IWL_SCAN_RADIO_RESET:
 		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
+		/*
+		 * Override quiet time as firmware checks that active
+		 * dwell is >= quiet; since we use passive scan it'll
+		 * not actually be used.
+		 */
+		scan->quiet_time = cpu_to_le16(IWL_RADIO_RESET_DWELL_TIME);
 		break;
 	case IWL_SCAN_NORMAL:
 		if (priv->scan_request->n_ssids) {
-- 
1.7.10

