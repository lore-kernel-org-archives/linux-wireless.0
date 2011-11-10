Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1KJBdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/28] iwlagn: don't always split remain-on-channel
Date: Wed,  9 Nov 2011 16:39:25 -0800
Message-Id: <1320885571-19122-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023342_854724_3FAA44A3)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to the P2P context always having the associated
bit set when we got to this code, we were splitting
up the remain-on-channel durations unconditionally.
This isn't needed -- if the P2P context is in P2P
device type mode it doesn't impose restrictions on
timing to skip it in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 625beec..359d218 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -416,6 +416,8 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 
 		if (!iwl_is_associated_ctx(ctx))
 			continue;
+		if (ctx->staging.dev_type == RXON_DEV_TYPE_P2P)
+			continue;
 		value = ctx->beacon_int;
 		if (!value)
 			value = IWL_PASSIVE_DWELL_BASE;
-- 
1.7.0.4

