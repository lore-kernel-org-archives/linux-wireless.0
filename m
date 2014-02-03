Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56979 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaBCU6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:35 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so3908681eaj.18
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/62] iwlwifi: pcie: fix unused variable gcc warning
Date: Mon,  3 Feb 2014 22:57:19 +0200
Message-Id: <1391461088-8082-13-git-send-email-egrumbach@gmail.com> (sfid-20140203_223007_675748_0C379818)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In iwl_pcie_int_cause_non_ict, trans_pcie is used for lockdep
purposes only. Since this might not be enabled, trans_pcie
finds itself without user leading to a complaint from gcc.
Avoid using trans_pcie by inlining IWL_TRANS_GET_PCIE_TRANS.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 08c23d4..41f684d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -802,10 +802,9 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 
 static u32 iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
 
-	lockdep_assert_held(&trans_pcie->irq_lock);
+	lockdep_assert_held(&IWL_TRANS_GET_PCIE_TRANS(trans)->irq_lock);
 
 	trace_iwlwifi_dev_irq(trans->dev);
 
-- 
1.7.9.5

