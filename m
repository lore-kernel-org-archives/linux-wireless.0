Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6488 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab2ASR0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 12:26:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.3] iwlwifi: fix PCI-E transport "inta" race
Date: Thu, 19 Jan 2012 08:20:57 -0800
Message-Id: <1326990057-31169-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120119_182622_400449_C04EDD28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interrupt comes in, we read the reason
bits and collect them into "trans_pcie->inta".
This happens with the spinlock held. However,
there's a bug resetting this variable -- that
happens after the spinlock has been released.
This means that it is possible for interrupts
to be missed if the reset happens after some
other interrupt reasons were already added to
the variable.

I found this by code inspection, looking for a
reason that we sometimes see random commands
time out. It seems possible that this causes
such behaviour, but I can't say for sure right
now since it happens extremely infrequently on
my test systems.

Cc: stable@vger.kernel.org [3.2]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 752493f..65d1f05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -972,11 +972,11 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	}
 #endif
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
 	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
 	trans_pcie->inta = 0;
 
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
 		IWL_ERR(trans, "Hardware error detected.  Restarting.\n");
-- 
1.7.0.4

