Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29277 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaCCPcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 10:32:41 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
	<87bnya6xey.fsf@kamboji.qca.qualcomm.com>
	<52FE3766.1080509@candelatech.com>
Date: Mon, 3 Mar 2014 17:32:35 +0200
In-Reply-To: <52FE3766.1080509@candelatech.com> (Ben Greear's message of "Fri,
	14 Feb 2014 07:33:58 -0800")
Message-ID: <87zjl747sc.fsf@kamboji.qca.qualcomm.com> (sfid-20140303_163245_023839_9435EA22)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 02/13/2014 10:06 PM, Kalle Valo wrote:
>
>> @@ -1542,20 +1542,20 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
>>
>>   	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
>>   	if (ret) {
>> -		ath10k_warn("failed to setup peer SMPS: %d\n", ret);
>> +		ath10k_warn("failed to setup peer SMPS for vdev: %d\n", ret);
>>   		return ret;
>>   	}
>
> Looks like that could use the vdev id in it...I must have missed it on
> my first attempt.

I fix this before I apply the patch.

>> @@ -3252,7 +3252,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>>   			   arvif->vdev_id, sta->addr);
>>   		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
>>   		if (ret)
>> -			ath10k_warn("Failed to delete peer: %pM for VDEV: %d ret %i\n",
>> +			ath10k_warn("Failed to delete peer %pM for vdev %d: %i\n",
>>   				    sta->addr, arvif->vdev_id, ret);
>
>
> While you are harmonizing the messages...maybe change all instances of
> "failed to "Failed ?
>
> I wasn't sure what was preferred so I left that alone when doing my patch.

Actually, I'll send a separate patch for this. Easier that way.

> The rest of the changes look fine to me.

Thanks for the review.

-- 
Kalle Valo
