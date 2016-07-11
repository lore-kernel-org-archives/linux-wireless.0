Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbcGKCGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 22:06:17 -0400
Date: Mon, 11 Jul 2016 12:06:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 net-next tree
Message-ID: <20160711120614.0cdca5fa@canb.auug.org.au> (sfid-20160711_040637_800406_E3727792)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/mvm/scan.c

between commit:

  7947d3e075cd ("mac80211: Add support for beacon report radio measurement")

from the net-next tree and commit:

  69e046423ad7 ("iwlwifi: mvm: change scan timeout to a delayed work")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 1cac10c5d818,fb25d9e41912..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@@ -400,9 -396,10 +400,9 @@@ void iwl_mvm_rx_lmac_scan_complete_noti
  			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
  
  		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
 -		ieee80211_scan_completed(mvm->hw,
 -				scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 +		ieee80211_scan_completed(mvm->hw, &info);
  		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
- 		del_timer(&mvm->scan_timer);
+ 		cancel_delayed_work(&mvm->scan_timeout_dwork);
  	} else {
  		IWL_ERR(mvm,
  			"got scan complete notification but no scan is running\n");
@@@ -1433,13 -1432,9 +1435,13 @@@ void iwl_mvm_rx_umac_scan_complete_noti
  
  	/* if the scan is already stopping, we don't need to notify mac80211 */
  	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
 -		ieee80211_scan_completed(mvm->hw, aborted);
 +		struct cfg80211_scan_info info = {
 +			.aborted = aborted,
 +		};
 +
 +		ieee80211_scan_completed(mvm->hw, &info);
  		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
- 		del_timer(&mvm->scan_timer);
+ 		cancel_delayed_work(&mvm->scan_timeout_dwork);
  	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
  		ieee80211_sched_scan_stopped(mvm->hw);
  		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
@@@ -1644,14 -1630,9 +1646,14 @@@ out
  		 * to release the scan reference here.
  		 */
  		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
- 		del_timer(&mvm->scan_timer);
+ 		cancel_delayed_work(&mvm->scan_timeout_dwork);
 -		if (notify)
 -			ieee80211_scan_completed(mvm->hw, true);
 +		if (notify) {
 +			struct cfg80211_scan_info info = {
 +				.aborted = true,
 +			};
 +
 +			ieee80211_scan_completed(mvm->hw, &info);
 +		}
  	} else if (notify) {
  		ieee80211_sched_scan_stopped(mvm->hw);
  		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
