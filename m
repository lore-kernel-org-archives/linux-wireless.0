Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44476 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab0IWNb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 09:31:28 -0400
Message-ID: <4C9B56AC.6090608@candelatech.com>
Date: Thu, 23 Sep 2010 06:31:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: greearb@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [mac80211] ath5k:  Support virtual interfaces.
References: <1285213229-19138-1-git-send-email-greearb@candelatech.com> <4C9B2444.9030608@openwrt.org> <4C9B517C.9050204@candelatech.com> <4C9B5567.4080306@openwrt.org>
In-Reply-To: <4C9B5567.4080306@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 06:25 AM, Felix Fietkau wrote:
> On 2010-09-23 3:09 PM, Ben Greear wrote:

>>>> +	if (sc->nvifs>   1&&   !modparam_nohwcrypt) {
>>>> +		pr_err("ath5k: can not add multiple virtual interfaces with hardware encryption\n");
>>> Why not? Other drivers can do this just fine.
>>
>> ath9k and ath5k, at least, cannot do multiple STA with hardware encryption,
>> as far as I know.
> I think that can be fixed in software by switching over to using address
> based key lookup. In either case, this should not restrict the use of
> multiple AP interfaces...

Ok, I'll remove that code.

>
>>>> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
>>>> index 7f9d0d3..ec5c3c0 100644
>>>> --- a/drivers/net/wireless/ath/ath5k/base.h
>>>> +++ b/drivers/net/wireless/ath/ath5k/base.h
>>>> @@ -58,8 +58,8 @@
>>>>
>>>>    #define	ATH_RXBUF	40		/* number of RX buffers */
>>>>    #define	ATH_TXBUF	200		/* number of TX buffers */
>>>> -#define ATH_BCBUF	1		/* number of beacon buffers */
>>>> -
>>>> +#define ATH_BCBUF	16		/* number of beacon buffers */
>>> A value of 16 here seems a bit much for staggered beacons. IMHO that
>>> will increase the likelihood of stuck beacon issues in the long run.
>>> I think 4 would be a better value to start with for now.
>>> In the future we should probably make the SWBA timing more dynamic based
>>> on the actual number of AP mode interfaces.
>>
>> We ran tests before with at least 8 VAPs and it seemed to work fine.  Maybe
>> we can compromise to 8?
> Did you test it under very heavy load? My suggestion for supporting more
> interfaces would be to keep 4 SWBA slots, and after the fourth interface
> is added, assign the extra interfaces to the existing slots.
> Then when transmitting beacons, link together all DMA descriptors
> assigned to the current slot. That way you have less issues with
> imprecise timers, IRQ delays and similar things, which are more likely
> to show up on embedded hardware than on regular PCs. This also has the
> advantage of using less power, as it generates less useless wakeups per
> second.

We did test under load.  But, the truth is, I don't really understand this
beacon code..it was not originally written by me.  Also, I haven't tested
APs yet in .36...just STA so far.

If you think it should be limited to 4, I'll go ahead and do that.

Someone that understands it better can increase it later if desired.

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
