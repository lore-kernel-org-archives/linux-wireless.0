Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35908 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab2JENYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 09:24:31 -0400
Message-ID: <506EDF89.5000805@openwrt.org> (sfid-20121005_152434_595037_1C644580)
Date: Fri, 05 Oct 2012 15:24:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <2629427.e28b8DS3gI@bentobox> <506ED3D4.7050107@openwrt.org> <2475573.rN7d8lielt@bentobox>
In-Reply-To: <2475573.rN7d8lielt@bentobox>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-05 3:07 PM, Sven Eckelmann wrote:
> On Friday 05 October 2012 14:34:28 Felix Fietkau wrote:
>> On 2012-10-05 1:08 PM, Sven Eckelmann wrote:
> [...]
>> Please try this patch to see if it gets rid of these interrupts:
>> ---
>> --- a/drivers/net/wireless/ath/ath9k/ani.c
>> +++ b/drivers/net/wireless/ath/ath9k/ani.c
>> @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
>>  		if (IS_CHAN_2GHZ(chan)) {
>>  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
>>  					    ATH9K_ANI_FIRSTEP_LEVEL);
>> -			if (AR_SREV_9300_20_OR_LATER(ah))
>> +			if (AR_SREV_9300_20_OR_LATER(ah) &&
>> +			    ah->caps.rx_chainmask != 1)
>>  				ah->ani_function |= ATH9K_ANI_MRC_CCK;
>>  		} else
>>  			ah->ani_function = 0;
> 
> Looks partially good. At least this patch fixed parts my friday :D
> 
> I have more similar bugs, but at least this one is related to a bandwidth 
> problem which I also wanted to check today. But it didn't fix _this_ invalid 
> register access on the client device (but I don't see it anymore on the AP 
> device).
Are you sure that it's still the same register access on the client
side? I don't see how it could still access MRC related registers with
this part masked out.

Maybe it would make sense to come up with a debugging patch that checks
the IRQ status register on every register access to see if an error was
reported by the last one, and if there is an error, throw a stack trace.

- Felix
