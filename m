Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39687 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYIIQKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 12:10:07 -0400
Message-ID: <48C69E11.5090102@atheros.com> (sfid-20080909_181035_567706_69C0CB59)
Date: Tue, 9 Sep 2008 21:32:25 +0530
From: vasanthakumar thiagarajan <vasanth.thiagarajan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Add RF kill support
References: <20080909153422.GA7651@vasanth-lnx.users.atheros.com>	 (sfid-20080909_173954_277503_9881BAF1) <1220975170.31304.184.camel@johannes.berg>
In-Reply-To: <1220975170.31304.184.camel@johannes.berg>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> +#ifdef CONFIG_RFKILL
>> +	u16 ah_rfsilent;
>> +	u32 ah_rfkill_gpio ;
>>     
>
> small typo, space too much.
>
>   
ok, thanks.
>> --- a/drivers/net/wireless/ath9k/core.h
>> +++ b/drivers/net/wireless/ath9k/core.h
>> @@ -40,6 +40,9 @@
>>  #include <asm/page.h>
>>  #include <net/mac80211.h>
>>  #include <linux/leds.h>
>> +#ifdef CONFIG_RFKILL
>> +#include <linux/rfkill.h>
>> +#endif
>>  
>>  #include "ath9k.h"
>>  #include "rc.h"
>> @@ -823,6 +826,17 @@ struct ath_led {
>>  	bool registered;
>>  };
>>  
>> +#ifdef CONFIG_RFKILL
>> +/* Rfkill */
>> +#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
>> +
>> +struct ath_rfkill {
>> +	struct rfkill *rfkill;
>> +	struct delayed_work rfkill_poll;
>> +	char rfkill_name[32];
>> +};
>> +#endif
>> +
>>     
>
> No need to protect any of this with an #ifdef.
>
>   
>> +#ifdef CONFIG_RFKILL
>> +#define SC_OP_RFKILL_REGISTERED	BIT(11)
>> +#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
>> +#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
>> +#endif
>>     
>
> Nor that.
>  
>   
ok.
>> +static void ath9k_ht_conf(struct ath_softc *sc,
>> +			  struct ieee80211_bss_conf *bss_conf)
>> +{
>> +#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
>> +	struct ath_ht_info *ht_info = &sc->sc_ht_info;
>>     
>
> All that doesn't seem to belong into this patch?
>
> johannes
>   
I just rearranged (purely change in the location of few static functions
in the file) the code to avoid
the prototype declaration of the functions which are called (before
their definition) in case of any
failure during rfkill_register().

Thanks for your comments.

Regards

Vasanth

