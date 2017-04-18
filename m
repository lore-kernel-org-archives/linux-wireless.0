Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56829 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdDRG4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 02:56:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-13
Date: Tue, 18 Apr 2017 06:56:28 +0000
Message-ID: <87h91m6w6f.fsf@qca.qualcomm.com> (sfid-20170418_085638_485837_B013E0E8)
References: <1492086857.31741.20.camel@coelho.fi>
        <87lgqy6x6n.fsf@codeaurora.org>
In-Reply-To: <87lgqy6x6n.fsf@codeaurora.org> (Kalle Valo's message of "Tue, 18
        Apr 2017 09:34:40 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Luca Coelho <luca@coelho.fi> writes:
>
>> Here's my first pull-request intended for v4.12.  This is generic
>> development work, nothing really stands out.  More
>> details in the tag description.
>>
>> I have sent this out before, and kbuildbot reported success.
>>
>> Please let me know if there are any issues.
>>
>> Cheers,
>> Luca.
>>
>>
>> The following changes since commit 1aed89640a899cd695bbfc976a4356affa474=
646:
>>
>>   mwifiex: apply radar flag (2017-04-05 15:54:52 +0300)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
>> tags/iwlwifi-next-for-kalle-2017-04-13
>>
>> for you to fetch changes up to 87d0e1af9db3bff4ec2f68fd4d032f89c23867a4:
>>
>>   iwlwifi: mvm: separate queue mapping from queue enablement (2017-04-11=
 15:25:00 +0300)
>>
>> ----------------------------------------------------------------
>> Patches intended for v4.12:
>>
>>   * Some small fixes here and there;
>>   * The usual cleanups and small improvements;
>>   * Work to support A000 devices continues;
>>   * New FW API version;
>>   * Some debugging improvements;
>>
>> ----------------------------------------------------------------
>
> This one has few conflicts. I can fix those manually, but can you give
> some guidance how?

I think I got it now, see below for the diff I did. Can you please
check that?

The resolution is also in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git/log/?h=3Dpending

diff --cc drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9d28db7f56aa,2d68cee41306..a552955f72f7
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@@ -1806,11 -1805,10 +1805,11 @@@ int iwl_mvm_send_add_bcast_sta(struct i
  			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
  		int queue;
 =20
 -		if (vif->type =3D=3D NL80211_IFTYPE_AP)
 +		if (vif->type =3D=3D NL80211_IFTYPE_AP ||
 +		    vif->type =3D=3D NL80211_IFTYPE_ADHOC)
- 			queue =3D IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+ 			queue =3D mvm->probe_queue;
  		else if (vif->type =3D=3D NL80211_IFTYPE_P2P_DEVICE)
- 			queue =3D IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+ 			queue =3D mvm->p2p_dev_queue;
  		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
  			return -EINVAL;
 =20
@@@ -1864,29 -1836,18 +1863,23 @@@ static void iwl_mvm_free_bcast_sta_queu
 =20
  	lockdep_assert_held(&mvm->mutex);
 =20
 +	if (vif->type =3D=3D NL80211_IFTYPE_AP ||
 +	    vif->type =3D=3D NL80211_IFTYPE_ADHOC)
 +		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
 +				    IWL_MAX_TID_COUNT, 0);
 +
- 	if (mvmvif->bcast_sta.tfd_queue_msk &
- 	    BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)) {
- 		iwl_mvm_disable_txq(mvm,
- 				    IWL_MVM_DQA_AP_PROBE_RESP_QUEUE,
+ 	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->probe_queue)) {
+ 		iwl_mvm_disable_txq(mvm, mvm->probe_queue,
  				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
  				    0);
- 		mvmvif->bcast_sta.tfd_queue_msk &=3D
- 			~BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE);
+ 		mvmvif->bcast_sta.tfd_queue_msk &=3D ~BIT(mvm->probe_queue);
  	}
 =20
- 	if (mvmvif->bcast_sta.tfd_queue_msk &
- 	    BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE)) {
- 		iwl_mvm_disable_txq(mvm,
- 				    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
+ 	if (mvmvif->bcast_sta.tfd_queue_msk & BIT(mvm->p2p_dev_queue)) {
+ 		iwl_mvm_disable_txq(mvm, mvm->p2p_dev_queue,
  				    vif->hw_queue[0], IWL_MAX_TID_COUNT,
  				    0);
- 		mvmvif->bcast_sta.tfd_queue_msk &=3D
- 			~BIT(IWL_MVM_DQA_P2P_DEVICE_QUEUE);
+ 		mvmvif->bcast_sta.tfd_queue_msk &=3D ~BIT(mvm->p2p_dev_queue);
  	}
  }
 =20
diff --cc drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1ba0a6f55503,568b0793e84e..ffbbe7228f5d
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@@ -518,12 -517,11 +518,12 @@@ static int iwl_mvm_get_ctrl_vif_queue(s
  		if (info->hw_queue =3D=3D info->control.vif->cab_queue)
  			return info->hw_queue;
 =20
 -		WARN_ONCE(1, "fc=3D0x%02x", le16_to_cpu(fc));
 +		WARN_ONCE(info->control.vif->type !=3D NL80211_IFTYPE_ADHOC,
 +			  "fc=3D0x%02x", le16_to_cpu(fc));
- 		return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+ 		return mvm->probe_queue;
  	case NL80211_IFTYPE_P2P_DEVICE:
  		if (ieee80211_is_mgmt(fc))
- 			return IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+ 			return mvm->p2p_dev_queue;
  		if (info->hw_queue =3D=3D info->control.vif->cab_queue)
  			return info->hw_queue;
  =
