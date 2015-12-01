Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbbLAJ7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/41] iwlwifi: pcie: remove pointer from debug message
Date: Tue,  1 Dec 2015 11:58:53 +0200
Message-Id: <1448963947-24302-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110304_808009_E69ACABF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since this pointer is not shown anywhere else, it's useless.
Remove it, just keeping the indexes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 2b5d3e1..3db82bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -996,8 +996,7 @@ restart:
 		rxb = rxq->queue[i];
 		rxq->queue[i] = NULL;
 
-		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d (%p)\n",
-			     r, i, rxb);
+		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d\n", r, i);
 		iwl_pcie_rx_handle_rb(trans, rxb, emergency);
 
 		i = (i + 1) & RX_QUEUE_MASK;
-- 
2.5.0

