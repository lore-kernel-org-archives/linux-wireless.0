Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57096 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbbJEOhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:37 +0300
Message-Id: <1444055820-27506-6-git-send-email-luca@coelho.fi> (sfid-20151005_163811_997609_73B0E74E)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 06/29] iwlwifi: mvm: fix default disabled aggs in sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

For the ADD_STA command, when the flag for aggregation
disabling is set, there is a bitmap indicated what TIDs
are disabling aggregations and what aren't. Currently, by
default, all TIDs allow for aggregations since the value
we begin with is 0.

Change this default value to 0xffff so all TIDs don't
allow aggregations until explicitly turned on.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index fe2f538..18ca030 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -292,7 +292,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	/* HW restart, don't assume the memory has been zeroed */
 	atomic_set(&mvm->pending_frames[sta_id], 0);
-	mvm_sta->tid_disable_agg = 0;
+	mvm_sta->tid_disable_agg = 0xffff; /* No aggs at first */
 	mvm_sta->tfd_queue_msk = 0;
 
 	/* allocate new queues for a TDLS station */
-- 
2.5.3

