Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24143 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2DFKKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 06:10:36 -0400
Message-ID: <4F7EC117.7070500@qca.qualcomm.com> (sfid-20120406_121059_296033_51CB5EB8)
Date: Fri, 6 Apr 2012 15:40:31 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix target assert in p2p bringup with multi vif
References: <1333608369-18301-1-git-send-email-vthiagar@qca.qualcomm.com> <4F7EBF71.7070802@qca.qualcomm.com>
In-Reply-To: <4F7EBF71.7070802@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Friday 06 April 2012 03:33 PM, Kalle Valo wrote:
> On 04/05/2012 09:46 AM, Vasanthakumar Thiagarajan wrote:
>> Using interface 0 for p2p causes target assert. This is because
>> interface 0 is always initialized to non-p2p operations. Fix this
>> issue by initializing all the interfaces for p2p when fw is capable
>> of dynamic interface switching. When fw is not capable of dynamic
>> switching, make sure p2p is not brought up on interface which is
>> not initialized for this purpose.
>>
>> Reported-by: Naveen Singh navesing@qca.qualcomm.com
>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath6kl/cfg80211.c |   26 +++++++++++++++++++++++
>>   drivers/net/wireless/ath/ath6kl/init.c     |   31 ++++++++++++++++++----------
>>   2 files changed, 46 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> index 1272508..26fb3d7 100644
>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> @@ -1451,9 +1451,35 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
>>   					struct vif_params *params)
>>   {
>>   	struct ath6kl_vif *vif = netdev_priv(ndev);
>> +	int i;
>>
>>   	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
>>
>> +	/*
>> +	 * Don't bring up p2p on an interface which is not initialized
>> +	 * for p2p operation where fw does not have capability to switch
>> +	 * dynamically between non-p2p and p2p type interface.
>> +	 */
>> +	if (!test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
>> +		      vif->ar->fw_capabilities)) {
>> +		if (type == NL80211_IFTYPE_P2P_CLIENT ||
>> +		    type == NL80211_IFTYPE_P2P_GO) {
>> +			if (vif->ar->vif_max>  1) {
>> +				for (i = vif->ar->max_norm_iface;
>> +				     i<  vif->ar->vif_max; i++) {
>> +					if (i == vif->fw_vif_idx)
>> +						break;
>> +				}
>> +				if (i == vif->ar->vif_max) {
>> +					ath6kl_err("Invalid interface to bring up P2P\n");
>> +					return -EINVAL;
>> +				}
>> +			} else
>> +				if (vif->fw_vif_idx != 0)
>> +					return -EINVAL;
>> +		}
>> +	}
>
> IMHO this is difficult to read. Could it be simplified by reducing the
> unnecessary indentation:
>
> 	if (!test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
> 		      vif->ar->fw_capabilities)&&
>              (type == NL80211_IFTYPE_P2P_CLIENT ||
> 	     type == NL80211_IFTYPE_P2P_GO)) {
>
> 		if (vif->ar->vif_max == 0) {
> 			if (vif->fw_vif_idx != 0)
> 				return -EINVAL;
> 			else
> 				goto foo;
> 		}
>
> 		for (i = vif->ar->max_norm_iface;
> 		     i<  vif->ar->vif_max; i++) {
> 			if (i == vif->fw_vif_idx)
> 				break;
> 			}
> 		}
>
> 		if (i == vif->ar->vif_max) {
> 			ath6kl_err("Invalid interface to bring up P2P\n");
> 			return -EINVAL;
> 		}
> 	}
>
> foo:
>
> I'm sure I added bugs above but hopefully it still shows my idea. At
> least you can combine the first two if statements and get rid of one
> indentation level.

I get your idea, i'll change it. Thanks!

Vasanth
