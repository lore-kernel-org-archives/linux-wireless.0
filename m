Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33794 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbbARUSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 15:18:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: mvm: abort scheduled scan upon RFKILL
Date: Sun, 18 Jan 2015 22:18:03 +0200
Message-Id: <1421612283-27012-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150118_211813_633737_55C9423C)
In-Reply-To: <1421612183.26502.1.camel@egrumbacBox>
References: <1421612183.26502.1.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we have an active scheduled scan, and the RFKILL
interrupt kicks in, the stack will cancel the scheduled
scan as part of the down flow. But cancelling scheduled
scan usually implies sending a command to the firwmare
which has been killed as part of the RFKILL interrupt
handling.
Because of that, we returned an error to mac80211 when
it asked to stop the scheduled scan and didn't notify the
end of the scheduled scan. Besides a fat warning, this led
to a situation in which cfg80211 would refuse any new scan
request.

To disentangle this, fake that the scheduled scan has been
stopped without sending the command to the firwmare, return
0 after having properly let cfg80211 know that the scan
has been cancelled.

This is basically the same as:
commit 9b520d84957d63348e87c0f2cbd21d86e1e8f2f2
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue Nov 4 15:54:11 2014 +0200

    iwlwifi: mvm: abort scan upon RFKILL

    This code existed but not for all the different FW APIs
    we support.
    Fix this.

but for the scheduled scan case.

Link: http://permalink.gmane.org/gmane.linux.kernel.wireless.general/133232
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3fbba4b..844bf7c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1107,6 +1107,12 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 		return iwl_umac_scan_stop(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN,
 					  notify);
 
+	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
+		return 0;
+
+	if (iwl_mvm_is_radio_killed(mvm))
+		goto out;
+
 	if (mvm->scan_status != IWL_MVM_SCAN_SCHED &&
 	    (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) ||
 	     mvm->scan_status != IWL_MVM_SCAN_OS)) {
@@ -1143,6 +1149,7 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	if (mvm->scan_status == IWL_MVM_SCAN_OS)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 
+out:
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
 	if (notify) {
-- 
1.9.1

