Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab2BQUX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/26] iwlwifi: enable receiving beacons when not associated
Date: Fri, 17 Feb 2012 11:13:54 -0800
Message-Id: <1329506034-1394-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212418_167079_C4E74B9B)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

If the firmware implements beacon filtering,
beacons are filtered when not associated. This causes
association failures on channels marked passive.

Enabling this flag indicates to the firmware to allow
the beacons to pass through when not associated only.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8ca9570..35dd7e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -900,6 +900,22 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	/*
+	 * If the ucode decides to do beacon filtering before
+	 * association, it will lose beacons that are needed
+	 * before sending frames out on passive channels. This
+	 * causes association failures on those channels. Enable
+	 * receiving beacons in such cases.
+	 */
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (!bss_conf->assoc)
+			ctx->staging.filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
+		else
+			ctx->staging.filter_flags &=
+						    ~RXON_FILTER_BCON_AWARE_MSK;
+	}
+
 	if (force || memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
 		iwlagn_commit_rxon(priv, ctx);
 
-- 
1.7.0.4

