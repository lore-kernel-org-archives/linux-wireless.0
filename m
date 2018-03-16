Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35248 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750749AbeCPLvv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:36 +0200
Message-Id: <20180316115136.1234-6-luca@coelho.fi> (sfid-20180316_125156_645163_AFD5E507)
In-Reply-To: <20180316115136.1234-1-luca@coelho.fi>
References: <20180316115136.1234-1-luca@coelho.fi>
Subject: [PATCH 5/5] iwlwifi: mvm: Move unused phy's to a default channel
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

When immediate quiet bit is set in CSA, the entire channel is blocked
by the firmware. It is expected that all the MACs will evacuate the
channel and the phy will be eventually either moved or removed.

Currently, the phy context is just unreferenced and thus, the quiet
bit is kept set and it will be impossible to TX on this phy, if we
will need to reuse it in the future.  This can be seen when doing a
channel switch with mode=1 (quiet) twice from channel X to Y and then
back to channel X.

Fix that, by moving the phy context to a default channel when not
referenced anymore.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 305cd56bf746..7f5434b34d0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017           Intel Deutschland GmbH
+ * Copyright(c) 2018           Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
@@ -34,6 +30,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2018           Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -286,6 +283,20 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
 		return;
 
 	ctxt->ref--;
+
+	/*
+	 * Move unused phy's to a default channel. When the phy is moved the,
+	 * fw will cleanup immediate quiet bit if it was previously set,
+	 * otherwise we might not be able to reuse this phy.
+	 */
+	if (ctxt->ref == 0) {
+		struct ieee80211_channel *chan;
+		struct cfg80211_chan_def chandef;
+
+		chan = &mvm->hw->wiphy->bands[NL80211_BAND_2GHZ]->channels[0];
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+		iwl_mvm_phy_ctxt_changed(mvm, ctxt, &chandef, 1, 1);
+	}
 }
 
 static void iwl_mvm_binding_iterator(void *_data, u8 *mac,
-- 
2.16.2
