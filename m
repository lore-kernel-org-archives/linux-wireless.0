Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43235 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab2FOVFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 17:05:35 -0400
Message-ID: <4FDBA39A.60809@openwrt.org> (sfid-20120615_230540_112526_E6FF98A5)
Date: Fri, 15 Jun 2012 23:05:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH 2/9] ath9k_hw: fix OFDM weak signal detection handling
References: <1339766727-61926-1-git-send-email-nbd@openwrt.org> <1339766727-61926-2-git-send-email-nbd@openwrt.org> <20120615173814.GA648@vmraj-lnx.qca.qualcomm.com>
In-Reply-To: <20120615173814.GA648@vmraj-lnx.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-15 7:38 PM, Rajkumar Manoharan wrote:
> On Fri, Jun 15, 2012 at 03:25:20PM +0200, Felix Fietkau wrote:
>> Commit "ath9k_hw: improve ANI processing and rx desensitizing parameters"
>> was unifying some code related to overriding OFDM weak signal detection,
>> but seems to have gotten some of the original intent wrong, probably
>> because of a misnamed variable.
>> 
>> The beacon RSSI is only valid in station mode, and the main reason to check
>> it in ath9k_hw_set_ofdm_nil is to make sure that OFDM weak signal detection
>> stays enabled if the RSSI is low, even when the OFDM noise immunity entry
>> is supposed to disable it.
>> 
>> The above commit removed the mode checks and changed the code so that
>> OFDM weak signal detection would only be changed if the rssi is high, which
>> is wrong for everything but client mode.
>> 
>> This patch restores the old behavior in a simplified form.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/ani.c |   11 +++++++----
>>  1 files changed, 7 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
>> index 18ce69d..cf31050 100644
>> --- a/drivers/net/wireless/ath/ath9k/ani.c
>> +++ b/drivers/net/wireless/ath/ath9k/ani.c
>> @@ -265,6 +265,7 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
>>  	struct ath_common *common = ath9k_hw_common(ah);
>>  	const struct ani_ofdm_level_entry *entry_ofdm;
>>  	const struct ani_cck_level_entry *entry_cck;
>> +	bool weak_sig;
>>  
>>  	ath_dbg(common, ANI, "**** ofdmlevel %d=>%d, rssi=%d[lo=%d hi=%d]\n",
>>  		aniState->ofdmNoiseImmunityLevel,
>> @@ -290,13 +291,15 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
>>  				     ATH9K_ANI_FIRSTEP_LEVEL,
>>  				     entry_ofdm->fir_step_level);
>>  
>> -	if (BEACON_RSSI(ah) >= aniState->rssiThrHigh &&
>> -	    (!aniState->ofdmWeakSigDetectOff !=
>> -	     entry_ofdm->ofdm_weak_signal_on)) {
>> +	weak_sig = entry_ofdm->ofdm_weak_signal_on;
>> +	if (ah->opmode == NL80211_IFTYPE_STATION &&
>> +	    BEACON_RSSI(ah) <= aniState->rssiThrHigh)
>> +		weak_sig = true;
>> +
>> +	if (!aniState->ofdmWeakSigDetectOff != weak_sig)
> 
> beacon rssi is updated and used in both station and ibss mode. isn't it?
Yeah, but in ibss mode it does not make much sense when there are
multiple peers and a less frequent update interval (due to distributed
beaconing).

- Felix
