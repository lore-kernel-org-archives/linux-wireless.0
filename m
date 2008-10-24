Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:13263 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751432AbYJXGsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:42 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Daniel C. Halperin" <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/10] iwlwifi: convert correctly rate_n_flags to PLCP index for mimo3 packets
Date: Thu, 23 Oct 2008 23:48:53 -0700
Message-Id: <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084854_019482_6A7243AE)
In-Reply-To: <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C. Halperin <daniel.c.halperin@intel.com>

The driver does not properly convert rate_n_flags to PLCP index for mimo3
packets. This makes mac80211 drop the packets

Signed-off-by: Daniel C. Halperin <daniel.c.halperin@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 20c7ff3..a3f97a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -120,7 +120,9 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		idx = (rate_n_flags & 0xff);
 
-		if (idx >= IWL_RATE_MIMO2_6M_PLCP)
+		if (idx >= IWL_RATE_MIMO3_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO3_6M_PLCP;
+		else if (idx >= IWL_RATE_MIMO2_6M_PLCP)
 			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
 
 		idx += IWL_FIRST_OFDM_RATE;
-- 
1.5.4.3

