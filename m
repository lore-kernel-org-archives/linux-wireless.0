Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/18] iwlagn: fix PAN slot timing wrt. DTIM
Date: Tue, 16 Nov 2010 08:01:47 -0800
Message-Id: <1289923311-14920-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the DTIM is not 1, then the slot timing is in
some cases required to be calclulated based on the
DTIM interval instead of the beacon interval, fix
that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index ffb2f41..366340f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -307,6 +307,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 	if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
+		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
 
 		/* should be set, but seems unused?? */
 		cmd.flags |= cpu_to_le16(IWL_WIPAN_PARAMS_FLG_SLOTTED_MODE);
@@ -329,10 +330,10 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 		if (test_bit(STATUS_SCAN_HW, &priv->status) ||
 		    (!ctx_bss->vif->bss_conf.idle &&
 		     !ctx_bss->vif->bss_conf.assoc)) {
-			slot0 = bcnint * 3 - 20;
+			slot0 = dtim * bcnint * 3 - 20;
 			slot1 = 20;
 		} else if (!ctx_pan->vif->bss_conf.idle &&
-                           !ctx_pan->vif->bss_conf.assoc) {
+			   !ctx_pan->vif->bss_conf.assoc) {
 			slot1 = bcnint * 3 - 20;
 			slot0 = 20;
 		}
-- 
1.7.0.4

