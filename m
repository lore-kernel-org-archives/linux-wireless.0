Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51189 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0IMOgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 10:36:38 -0400
Message-ID: <4C8E36EE.7010007@candelatech.com>
Date: Mon, 13 Sep 2010 07:36:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
References: <4C8A8FF8.4030900@candelatech.com> <20100913121428.GA15567@vasanth-laptop>
In-Reply-To: <20100913121428.GA15567@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2010 05:14 AM, Vasanthakumar Thiagarajan wrote:
>>   	/* configure operational mode */
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index b32c8f0..4ce4029 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -110,7 +110,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
>>   static void ath_opmode_init(struct ath_softc *sc)
>>   {
>>   	struct ath_hw *ah = sc->sc_ah;
>> -	struct ath_common *common = ath9k_hw_common(ah);
>>
>>   	u32 rfilt, mfilt[2];
>>
>> @@ -118,9 +117,15 @@ static void ath_opmode_init(struct ath_softc *sc)
>>   	rfilt = ath_calcrxfilter(sc);
>>   	ath9k_hw_setrxfilter(ah, rfilt);
>>
>> -	/* configure bssid mask */
>> -	if (ah->caps.hw_caps&  ATH9K_HW_CAP_BSSIDMASK)
>> -		ath_hw_setbssidmask(common);
>> +	/* configure bssid mask, if ah->hw is configured.
>> +	 * it is NOT configured when mac80211 is calling
>> +	 * ieee80211_do_open, but probably just as well since
>> +	 * this STA isn't in the list yet.
>> +	 */
>> +	if (ah->hw) {
>
> This seems bogus. why a check for hw at this point??. IIRS hw of
> ah is not initialized at all, in that case this would fail always.
> Did you test with these code?

I did test it, and it worked for me.  Maybe we just shouldn't configure
the bssid mask in that method?  When using multiple VIFs, we need to do
the mask properly, and from what I can tell, when this method is called,
we do not have enough information to do that properly.

>
>> +	int avifs = ieee80211_count_sta_atomic(sc->hw);
>
> If your aim here is to get the number of virtual interfaces
> associated to a hw, sc->nvifs should work.

I'll check to see if this will work.

Thanks,
Ben

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
