Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51252 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab2DMIE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 04:04:58 -0400
Message-ID: <4F87DE24.9040409@openwrt.org> (sfid-20120413_100548_438988_489E20EC)
Date: Fri, 13 Apr 2012 10:04:52 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 3.4] ath9k: wake up the hardware from full sleep when
 idle is turned off
References: <1334255791-55353-1-git-send-email-nbd@openwrt.org> <20359.36073.677675.375722@gargle.gargle.HOWL>
In-Reply-To: <20359.36073.677675.375722@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-13 4:18 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> The hardware needs a reset to recover from full sleep. Issue this reset
>> directly in the ath9k_config call that turns off idle, otherwise tx
>> remains dead until the first channel change after the idle state change
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/main.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index ba5af8e..fcb13e3 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -1584,6 +1584,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>>  	struct ath_hw *ah = sc->sc_ah;
>>  	struct ath_common *common = ath9k_hw_common(ah);
>>  	struct ieee80211_conf *conf = &hw->conf;
>> +	bool reset_channel = false;
>>  
>>  	ath9k_ps_wakeup(sc);
>>  	mutex_lock(&sc->mutex);
>> @@ -1592,6 +1593,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>>  		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
>>  		if (sc->ps_idle)
>>  			ath_cancel_work(sc);
>> +		else
>> +			/*
>> +			 * The chip needs a reset to properly wake up from
>> +			 * full sleep
>> +			 */
>> +			reset_channel = ah->chip_fullsleep;
> 
> This doesn't seem to work...
> 
> Since IDLE is broken currently, the HW never enters FULL_SLEEP mode and
> reset_channel will always be zero, and a chip reset will be done only via
> IEEE80211_CONF_CHANGE_CHANNEL.
Consider this preparation for fixing idle mode.

- Felix
