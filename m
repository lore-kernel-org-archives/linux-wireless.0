Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49656 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaI2QFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 12:05:17 -0400
Message-ID: <5429833C.60003@candelatech.com> (sfid-20140929_180522_974050_045B8903)
Date: Mon, 29 Sep 2014 09:05:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 07/10] ath10k: add fw-powerup-fail to ethtool stats.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com> <1411507045-18973-7-git-send-email-greearb@candelatech.com> <87a95i3kcb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a95i3kcb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2014 01:24 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This gives user-space a normal-ish way to detect that
>> firmware has failed to start and that a reboot is
>> probably required.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -1851,7 +1851,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>  			    ret);
>>  
>>  		if (ath10k_pci_reset_mode == ATH10K_PCI_RESET_WARM_ONLY)
>> -			return ret;
>> +			goto out;
>>  
>>  		ath10k_warn(ar, "trying cold reset\n");
>>  
>> @@ -1859,11 +1859,17 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>  		if (ret) {
>>  			ath10k_err(ar, "failed to power up target using cold reset too (%d)\n",
>>  				   ret);
>> -			return ret;
>> +			goto out;
>>  		}
>>  	}
>>  
>> -	return 0;
>> +out:
>> +	/* If we have failed to power-up, it may take a reboot to
>> +	 * get the NIC back online.
>> +	 * Set flag accordinly so that user-space can know.
>> +	 */
>> +	ar->fw_powerup_failed = !!ret;
>> +	return ret;
>>  }
> 
> Would it be better to use ATH10K_STATE_WEDGED for this and then just
> export the state value to user space? Or should we have two different
> states, like FW_WEDGED and HW_WEDGED?

I didn't want to mess with the state machine.  This counter
is just a clue to users that things might be badly wrong.  Some systems
might recover with another hard reset, some will hang the entire
system hard, and some will just stick in this state unable to
recover.  Some of my systems exhibit this last behaviour, so at
least with this patch I can warn the user that they need to
reboot to regain wifi functionality.

If you want to tie it to a state machine, that is OK with me, but
I don't want to mess with it because that code is already tricky
enough.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

