Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab0HWOxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/26] iwlwifi: use antenna A only under high BT load
Date: Mon, 23 Aug 2010 07:57:03 -0700
Message-Id: <1282575437-23270-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When bluetooth indicated high load, we should use
only antenna A in 2.4 GHz for management frames.
Add this condition to iwl_toggle_tx_ant() to make
sure it'll always be met. Note that scanning has
a separate way of forcing the antenna, because we
should scan on antenna A only regardless of BT
traffic load.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 72eda7e..5e8fc72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -147,6 +147,10 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 	int i;
 	u8 ind = ant;
 
+	if (priv->band == IEEE80211_BAND_2GHZ &&
+	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
+		return 0;
+
 	for (i = 0; i < RATE_ANT_NUM - 1; i++) {
 		ind = (ind + 1) < RATE_ANT_NUM ?  ind + 1 : 0;
 		if (valid & BIT(ind))
-- 
1.7.0.4

