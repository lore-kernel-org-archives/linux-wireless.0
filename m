Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58808 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbZKFXRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 18:17:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 2/2 v2.6.32] iwlwifi: Fix issue on file transfer stalled in HT mode
Date: Fri,  6 Nov 2009 15:17:05 -0800
Message-Id: <1257549425-13591-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257549425-13591-1-git-send-email-reinette.chatre@intel.com>
References: <1257549425-13591-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Turn on RTS/CTS for HT to prevent uCode TX fifo underrun

This is fix for
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2103

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
cc: stable@kernel.org
---
These patches are also targeting stable but do not apply there in its
current form. They will be backported and submitted there once they make it
into linux-2.6. The cc to stable@kernel.org is just informational.

 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 2716b91..950267a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -161,5 +161,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
-- 
1.5.6.3

