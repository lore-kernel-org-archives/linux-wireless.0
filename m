Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab1KJBdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/28] iwlagn: explicitly program P2P QoS parameters
Date: Wed,  9 Nov 2011 16:39:16 -0800
Message-Id: <1320885571-19122-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023431_250394_E02F6BDA)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In P2P device mode, the device needs to have valid
QoS parameters. We currently have those because we
program parameters from any virtual interface into
all contexts, but not only do we want to get rid of
this -- it is also unpredictable since on the BSS
context we might have any parameters, and there it
might even be programmed for HT.

Explicitly program default QoS parameters into the
PAN context for P2P (the defaults are 11g but with
QoS disabled) to make device behaviour predictable.

This also helps when in a follow-up patch we will
use TX QoS parameters from mac80211 only for the
context they were meant for -- without this first
that would completely break P2P device discovery.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   28 +++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 43d795d..c06bfe4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1305,7 +1305,35 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	cancel_delayed_work(&priv->hw_roc_disable_work);
 
 	if (!ctx->is_active) {
+		static const struct iwl_qos_info default_qos_data = {
+			.def_qos_parm = {
+				.ac[0] = {
+					.cw_min = cpu_to_le16(3),
+					.cw_max = cpu_to_le16(7),
+					.aifsn = 2,
+					.edca_txop = cpu_to_le16(1504),
+				},
+				.ac[1] = {
+					.cw_min = cpu_to_le16(7),
+					.cw_max = cpu_to_le16(15),
+					.aifsn = 2,
+					.edca_txop = cpu_to_le16(3008),
+				},
+				.ac[2] = {
+					.cw_min = cpu_to_le16(15),
+					.cw_max = cpu_to_le16(1023),
+					.aifsn = 3,
+				},
+				.ac[3] = {
+					.cw_min = cpu_to_le16(15),
+					.cw_max = cpu_to_le16(1023),
+					.aifsn = 7,
+				},
+			},
+		};
+
 		ctx->is_active = true;
+		ctx->qos_data = default_qos_data;
 		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
 		memcpy(ctx->staging.node_addr,
 		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
-- 
1.7.0.4

