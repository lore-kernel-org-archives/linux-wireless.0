Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45789 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764239AbZDHSdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: do not set dual_stream_ant_msk for 3 streams
Date: Wed,  8 Apr 2009 11:39:28 -0700
Message-Id: <1239215972-1795-3-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203406_403527_2524CAE5)
In-Reply-To: <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

This patch fixes a bug introduced by commit "iwlwifi: adding MIMO3 support
in rate scaling". We should not set the dual_stream_ant_msk (for 2x2 MIMO)
when using a 3x3 rate, this will cause a SYSASSERT in uCode.

Note: there is no triple_stream_ant_msk, because all three antennas are used.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 786b11d..98b6b37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2666,9 +2666,6 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 	} else if (num_of_ant(tbl_type.ant_type) == 2) {
 		lq_cmd->general_params.dual_stream_ant_msk =
 						tbl_type.ant_type;
-	} else if (num_of_ant(tbl_type.ant_type) == 3) {
-		lq_cmd->general_params.dual_stream_ant_msk =
-						tbl_type.ant_type;
 	} /* otherwise we don't modify the existing value */
 
 	index++;
-- 
1.5.6.3

