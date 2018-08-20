Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59526 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbeHTPWq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 11:22:46 -0400
Subject: Re: [PATCH] ath9k: fix tx99 with monitor mode interface
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
References: <20180820093751.63406-1-nbd@nbd.name>
 <87r2itp7ju.fsf@codeaurora.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <63d8abbd-f62a-1e53-b148-c22ef50b14b1@nbd.name> (sfid-20180820_140726_905854_C908648C)
Date: Mon, 20 Aug 2018 14:07:21 +0200
MIME-Version: 1.0
In-Reply-To: <87r2itp7ju.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-20 14:05, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> Tx99 is typically configured via a monitor mode interface, which does
>> not get added to the driver as a vif. Since the code currently expects
>> a configured virtual interface for tx99, enabling tx99 via debugfs fails.
>> Since the vif is not needed anyway, remove all checks for it.
>>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1251,15 +1251,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
>>  	struct ath_vif *avp = (void *)vif->drv_priv;
>>  	struct ath_node *an = &avp->mcast_node;
>>  
>> -	mutex_lock(&sc->mutex);
>> +	if (IS_ENABLED(CPTCFG_ATH9K_TX99))
>> +		return -EOPNOTSUPP;
> 
> Obviously this should be CONFIG_ATH9K_TX99, I'll fix that in the pending
> branch.
Sorry about that, I'll be more careful next time.

Thanks,

- Felix
