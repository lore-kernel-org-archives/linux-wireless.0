Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670Ab1JNUoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/6] iwlagn: use 6 Mbps rate for no-CCK scans
Date: Fri, 14 Oct 2011 12:54:48 -0700
Message-Id: <1318622088-14679-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224443_968471_90302734)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When userspace requested that a scan not be
done with CCK rates, use 6 Mbps. This is used
for example for P2P scanning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e5d727f..a26fbd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -678,7 +678,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			priv->contexts[IWL_RXON_CTX_BSS].active.flags &
 						RXON_FLG_CHANNEL_MODE_MSK)
 				       >> RXON_FLG_CHANNEL_MODE_POS;
-		if (chan_mod == CHANNEL_MODE_PURE_40) {
+		if ((priv->scan_request && priv->scan_request->no_cck) ||
+		    chan_mod == CHANNEL_MODE_PURE_40) {
 			rate = IWL_RATE_6M_PLCP;
 		} else {
 			rate = IWL_RATE_1M_PLCP;
-- 
1.7.0.4

