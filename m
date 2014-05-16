Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35360 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbaEPOB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:01:27 -0400
Message-ID: <53761A35.2000308@candelatech.com> (sfid-20140516_160145_201089_826F87CD)
Date: Fri, 16 May 2014 07:01:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  improve vdev map handling.
References: <1398882179-17100-1-git-send-email-greearb@candelatech.com> <878uq16e08.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878uq16e08.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2014 06:37 AM, Kalle Valo wrote:

>> -	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
>> +	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
> 
> Why remove the BIT()? Not that it matters much, I just think it's easier
> to read when BIT() macro is used. Would be good to convert all cases to
> use BIT anyway, but that's for a separate patch.

BIT doesn't work on 64-bit numbers (ie, if vdev_id > 31), and it takes a long time to
figure out exactly what it does (try grepping for BIT).  Open-coding means much
easier to fully understand the code.


>>  err_vdev_delete:
>>  	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
>> -	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
>> +	ar->free_vdev_map |= (1 << arvif->vdev_id);
> 
> Again why remove BIT()?
> 
>> @@ -2792,7 +2787,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
>>  	}
>>  	spin_unlock_bh(&ar->data_lock);
>>  
>> -	ar->free_vdev_map |= 1 << (arvif->vdev_id);
>> +	ar->free_vdev_map |= (1 << arvif->vdev_id);
> 
> Do we need the parenthesis?

No, though I like them visually.  It's at least more useful than
the previous placement.

I can respin the patch w/out them and with the == 0 and such.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

