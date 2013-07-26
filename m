Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3GZITe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/7] iwlwifi: pcie: reset the NIC before the bring up
Date: Fri, 26 Jul 2013 10:19:25 +0200
Message-Id: <1374826768-2440-4-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101942_302902_04C24D66)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to clean all kinds of bad state it might be in.
This solves situation where HW RFkill was switched while
the NIC was offline.
Until now, we relied on the firmware to do clean the
interrupt, but new firmwares don't do that any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 826c156..96cfcdd 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -670,6 +670,11 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 		return err;
 	}
 
+	/* Reset the entire device */
+	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	usleep_range(10, 15);
+
 	iwl_pcie_apm_init(trans);
 
 	/* From now on, the op_mode will be kept updated about RF kill state */
-- 
1.8.0

