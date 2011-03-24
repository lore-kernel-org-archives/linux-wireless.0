Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10877 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1CXJtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 05:49:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 02:48:39 -0700
Message-ID: <4D8B138A.9050204@atheros.com>
Date: Thu, 24 Mar 2011 15:18:58 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>
CC: Sujith <m.sujith@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: cleanup few redundant macros
References: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com> <19851.4373.967588.536327@gargle.gargle.HOWL> <4D8B130E.6090307@atheros.com>
In-Reply-To: <4D8B130E.6090307@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 March 2011 03:16 PM, Mohammed Shajakhan wrote:
> On Thursday 24 March 2011 03:08 PM, Sujith wrote:
>    
>> Mohammed Shafi Shajakhan wrote:
>>
>>      
>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>
>>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>> ---
>>>    drivers/net/wireless/ath/ath9k/ath9k.h  |    4 ----
>>>    drivers/net/wireless/ath/ath9k/common.c |    2 +-
>>>    drivers/net/wireless/ath/ath9k/mac.c    |    2 --
>>>    3 files changed, 1 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>>> index 099bd41..24b747c 100644
>>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>>> @@ -120,13 +120,11 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
>>>    /* RX / TX */
>>>    /***********/
>>>
>>> -#define ATH_MAX_ANTENNA         3
>>>    #define ATH_RXBUF               512
>>>    #define ATH_TXBUF               512
>>>    #define ATH_TXBUF_RESERVE       5
>>>    #define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
>>>    #define ATH_TXMAXTRY            13
>>> -#define ATH_MGT_TXMAXTRY        4
>>>
>>>    #define TID_TO_WME_AC(_tid)				\
>>>    	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
>>> @@ -688,8 +686,6 @@ void ath9k_ps_restore(struct ath_softc *sc);
>>>
>>>    u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
>>>
>>> -void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>>> -
>>>    void ath_start_rfkill_poll(struct ath_softc *sc);
>>>    extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
>>>    void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
>>> diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
>>> index 615e682..16ba8c6 100644
>>> --- a/drivers/net/wireless/ath/ath9k/common.c
>>> +++ b/drivers/net/wireless/ath/ath9k/common.c
>>> @@ -116,7 +116,7 @@ void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
>>>
>>>    	if (chan->band == IEEE80211_BAND_2GHZ) {
>>>    		ichan->chanmode = CHANNEL_G;
>>> -		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
>>> +		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;
>>>
>>>        
>> There's a reason for this: 8813262ea79acf9daa0e03901bdfe93db4dc4ca5
>> If channel handling has been cleaned up since then, this can be removed.
>>      
>>
>>      
> Oh Ok thanks, I will resend the patch without that change.
> but anyway CHANNEL_G is defined as (CHANNEL_2GHZ|CHANNEL_OFDM).
> Please tell me what I am missing.
>    
Now this change is correct?
>> Sujith
>> .
>>
>>
>>      
> .
>
>    
