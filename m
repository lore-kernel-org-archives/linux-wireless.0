Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60400 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbaICT4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:49 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so10545550wid.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:48 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/36] iwlwifi: mvm: clear d0i3 state on recovery
Date: Wed,  3 Sep 2014 22:56:01 +0300
Message-Id: <1409774184-24665-13-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_736728_64FDD833)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If recovery happened after mvm entered d0i3 (e.g.
due to sysassert when releasing the bus), the
mvm->state wasn't cleared properly, causing the
ongoing recovery to fail (due to iwl_mvm_ref_sync
failure).

This in turn fails the ongoing recovery, and triggers
a reprobe, which terminates any ongoing wifi activity.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 83c2ce6..de4ae94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -803,6 +803,9 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	 * ucode_down ref until reconfig is complete */
 	iwl_mvm_unref_all_except(mvm, IWL_MVM_REF_UCODE_DOWN);
 
+	/* clear any stale d0i3 state */
+	clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
+
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
 }
-- 
1.9.1

