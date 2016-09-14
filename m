Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55450 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759655AbcINPTT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:19:19 -0400
Message-ID: <57D96A6C.1060101@candelatech.com> (sfid-20160914_171924_397261_991A5794)
Date: Wed, 14 Sep 2016 08:19:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 11/21] ath10k: add fw-powerup-fail to ethtool stats.
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-12-git-send-email-greearb@candelatech.com> <87fup2eey2.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fup2eey2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:25 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This gives user-space a normal-ish way to detect that
>> firmware has failed to start and that a reboot is
>> probably required.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.h  | 1 +
>>   drivers/net/wireless/ath/ath10k/debug.c | 2 ++
>>   drivers/net/wireless/ath/ath10k/pci.c   | 2 ++
>>   3 files changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index 6aa7a14..e7c228a 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -698,6 +698,7 @@ struct ath10k {
>>
>>   	enum ath10k_hw_rev hw_rev;
>>   	u16 dev_id;
>> +	bool fw_powerup_failed; /* If true, might take reboot to recover. */
>>   	u32 chip_id;
>>   	u32 target_version;
>>   	u8 fw_version_major;
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
>> index 76b5163..05b5ea4 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -1541,6 +1541,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
>>   	"d_fw_crash_count",
>>   	"d_fw_warm_reset_count",
>>   	"d_fw_cold_reset_count",
>> +	"d_fw_powerup_failed", /* boolean */
>>   };
>>
>>   #define ATH10K_SSTATS_LEN ARRAY_SIZE(ath10k_gstrings_stats)
>> @@ -1640,6 +1641,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
>>   	data[i++] = ar->stats.fw_crash_counter;
>>   	data[i++] = ar->stats.fw_warm_reset_counter;
>>   	data[i++] = ar->stats.fw_cold_reset_counter;
>> +	data[i++] = ar->fw_powerup_failed;
>>
>>   	spin_unlock_bh(&ar->data_lock);
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
>> index dbf0db8..2adc459 100644
>> --- a/drivers/net/wireless/ath/ath10k/pci.c
>> +++ b/drivers/net/wireless/ath/ath10k/pci.c
>> @@ -2709,10 +2709,12 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
>>   		goto err_ce;
>>   	}
>>
>> +	ar->fw_powerup_failed = false;
>>   	return 0;
>>
>>   err_ce:
>>   	ath10k_pci_ce_deinit(ar);
>> +	ar->fw_powerup_failed = true;
>>
>>   err_sleep:
>>   	return ret;
>
> I didn't test myself, but if the firmware boot fails during module load
> we should return an error and the module would fail to load (and hence
> no network interface available). And if the firmware boot fails during
> the interface up call (mac80211 calling ath10k_start()) we should return
> an error and the interface would stay down. IMHO that's enough of
> indications to the user space, I don't see how providing this boolean
> via ethtool stats is really needed.


There are lots of reasons that interfaces can fail to come up or exist.

The work-around for the power-up fail is a system reboot, so I wanted to
know for certain when this case existed so that I could warn users
that they needed a reboot.

That said, I haven't seen this problem in a while, so maybe this patch is
no longer to useful.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
