Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbdDRGeo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 02:34:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-13
References: <1492086857.31741.20.camel@coelho.fi>
Date: Tue, 18 Apr 2017 09:34:40 +0300
In-Reply-To: <1492086857.31741.20.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 13 Apr 2017 15:34:17 +0300")
Message-ID: <87lgqy6x6n.fsf@codeaurora.org> (sfid-20170418_083452_679647_4B8761B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my first pull-request intended for v4.12.  This is generic
> development work, nothing really stands out.  More
> details in the tag description.
>
> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 1aed89640a899cd695bbfc976a4356affa474646:
>
>   mwifiex: apply radar flag (2017-04-05 15:54:52 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-04-13
>
> for you to fetch changes up to 87d0e1af9db3bff4ec2f68fd4d032f89c23867a4:
>
>   iwlwifi: mvm: separate queue mapping from queue enablement (2017-04-11 15:25:00 +0300)
>
> ----------------------------------------------------------------
> Patches intended for v4.12:
>
>   * Some small fixes here and there;
>   * The usual cleanups and small improvements;
>   * Work to support A000 devices continues;
>   * New FW API version;
>   * Some debugging improvements;
>
> ----------------------------------------------------------------

This one has few conflicts. I can fix those manually, but can you give
some guidance how?

diff --cc drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9d28db7f56aa,2d68cee41306..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@@ -1806,11 -1805,10 +1805,16 @@@ int iwl_mvm_send_add_bcast_sta(struct i
  			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
  		int queue;
  
++<<<<<<< HEAD
 +		if (vif->type == NL80211_IFTYPE_AP ||
 +		    vif->type == NL80211_IFTYPE_ADHOC)
 +			queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
++=======
+ 		if (vif->type == NL80211_IFTYPE_AP)
+ 			queue = mvm->probe_queue;
++>>>>>>> 17f9a54c7f7636fb67540a122d2dcf9ce47db9db
  		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
- 			queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+ 			queue = mvm->p2p_dev_queue;
  		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
  			return -EINVAL;
  
@@@ -1827,34 -1825,8 +1831,36 @@@
  
  	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
  					 mvmvif->id, mvmvif->color);
- 	if (ret)
- 		return ret;
  
++<<<<<<< HEAD
 +	/*
 +	 * In AP vif type, we also need to enable the cab_queue. However, we
 +	 * have to enable it after the ADD_STA command is sent, otherwise the
 +	 * FW will throw an assert once we send the ADD_STA command (it'll
 +	 * detect a mismatch in the tfd_queue_msk, as we can't add the
 +	 * enabled-cab_queue to the mask)
 +	 */
 +	if (iwl_mvm_is_dqa_supported(mvm) &&
 +	    (vif->type == NL80211_IFTYPE_AP ||
 +	     vif->type == NL80211_IFTYPE_ADHOC)) {
 +		struct iwl_trans_txq_scd_cfg cfg = {
 +			.fifo = IWL_MVM_TX_FIFO_MCAST,
 +			.sta_id = mvmvif->bcast_sta.sta_id,
 +			.tid = IWL_MAX_TID_COUNT,
 +			.aggregate = false,
 +			.frame_limit = IWL_FRAME_LIMIT,
 +		};
 +		unsigned int wdg_timeout =
 +			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
 +
 +		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue,
 +				   0, &cfg, wdg_timeout);
 +	}
 +
 +	return 0;
++=======
+ 	return ret;
++>>>>>>> 17f9a54c7f7636fb67540a122d2dcf9ce47db9db
  }
  
  static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
@@@ -1864,29 -1836,18 +1870,30 @@@
  
  	lockdep_assert_held(&mvm->mutex);
  
++<<<<<<< HEAD
 +	if (vif->type == NL80211_IFTYPE_AP ||
 +	    vif->type == NL80211_IFTYPE_ADHOC)
 +		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 +				    IWL_MAX_TID_COUNT, 0);
 +
 +	if (mvmvif->bcast_sta.tfd_queue_msk &
 +	    BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)) {
 +		iwl_mvm_disable_txq(mvm,
 +				    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
++=======
+ 	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->probe_queue)) {
+ 		iwl_mvm_disable_txq(mvm, mvm->probe_queue,
++>>>>>>> 17f9a54c7f7636fb67540a122d2dcf9ce47db9db
  				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
  				    0);
- 		mvmvif->bcast_sta.tfd_queue_msk &=
- 			~BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+ 		mvmvif->bcast_sta.tfd_queue_msk &= ~BIT(mvm->probe_queue);
  	}
  
- 	if (mvmvif->bcast_sta.tfd_queue_msk &
- 	    BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)) {
- 		iwl_mvm_disable_txq(mvm,
- 				    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
+ 	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->p2p_dev_queue)) {
+ 		iwl_mvm_disable_txq(mvm, mvm->p2p_dev_queue,
  				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
  				    0);
- 		mvmvif->bcast_sta.tfd_queue_msk &=
- 			~BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
+ 		mvmvif->bcast_sta.tfd_queue_msk &= ~BIT(mvm->p2p_dev_queue);
  	}
  }
  
diff --cc drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1ba0a6f55503,568b0793e84e..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@@ -518,12 -517,11 +518,17 @@@ static int iwl_mvm_get_ctrl_vif_queue(s
  		if (info->hw_queue == info->control.vif->cab_queue)
  			return info->hw_queue;
  
++<<<<<<< HEAD
 +		WARN_ONCE(info->control.vif->type != NL80211_IFTYPE_ADHOC,
 +			  "fc=0x%02x", le16_to_cpu(fc));
 +		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
++=======
+ 		WARN_ONCE(1, "fc=0x%02x", le16_to_cpu(fc));
+ 		return mvm->probe_queue;
++>>>>>>> 17f9a54c7f7636fb67540a122d2dcf9ce47db9db
  	case NL80211_IFTYPE_P2P_DEVICE:
  		if (ieee80211_is_mgmt(fc))
- 			return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+ 			return mvm->p2p_dev_queue;
  		if (info->hw_queue == info->control.vif->cab_queue)
  			return info->hw_queue;
  
