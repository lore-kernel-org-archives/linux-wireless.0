Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40176 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0KZAyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 19:54:45 -0500
Received: by qwb7 with SMTP id 7so1502502qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Nov 2010 16:54:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim6G7rO852RCma7qg=LqTwNav6E_OdqwLD7esCP@mail.gmail.com>
References: <20101123191533.GP4303@makis.mantri> <AANLkTi=YLPnqRzzfXaeghQ-w5vDgfCX5v59tGbgSp8zA@mail.gmail.com>
 <AANLkTimEZnDrXYa4WOKn=9VvL0qwYUTbABy1WgmSqe4m@mail.gmail.com> <AANLkTim6G7rO852RCma7qg=LqTwNav6E_OdqwLD7esCP@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Fri, 26 Nov 2010 10:54:29 +1000
Message-ID: <AANLkTi=QquDgSAYn4HS+vupdNUTNSngt03ZKuakYu6Fd@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 16/30] ath5k: Set all IFS intervals, not
 just slot time
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Content-Type: text/plain; charset=ISO-8859-7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 25, 2010 at 8:41 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> On Wed, Nov 24, 2010 at 10:55 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> 2010/11/24 Jonathan Guerin <jonathan@guerin.id.au>:
>>>
>>>> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
>>>> index e691378..4556f29 100644
>>>> --- a/drivers/net/wireless/ath/ath5k/pcu.c
>>>> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
>>>> @@ -763,7 +763,7 @@ ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
>>>>  * @ah: The &struct ath5k_hw
>>>>  * @coverage_class: IEEE 802.11 coverage class number
>>>>  *
>>>> - * Sets slot time, ACK timeout and CTS timeout for given coverage class.
>>>> + * Sets IFS intervals and ACK/CTS timeouts for given coverage class.
>>>>  */
>>>>  void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
>>>>  {
>>>> @@ -772,7 +772,7 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
>>>>        int ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
>>>
>>> This is not quite right:
>>>
>>> According to the 802.11-2007 spec document, the ACKTimeout value is
>>> (Section 9.2.8 ACK procedure):
>>> ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay
>>>
>>> From Table 17-15--OFDM PHY characteristics, the values are:
>>> aSIFSTime = 16
>>> aSlotTime = 9
>>> aPHY-RX-START-Delay = 25
>>>
>>> Therefore, ACKTimeout = 50
>>>
>>> Ignoring my uniformed comments from before, this is the only thing I
>>> can see that's wrong.
>>>
>>> Cheers,
>>>
>>> Jonathan
>>
>> Hmm I didn't mess with set_coverage_class so i didn't look up for ack
>> timeout. That phy-rx-start-delay is standard value or hw specific ?
>> Also does it change with clockrate (bwmodes) ? We already have a phy
>> activation -> rx start delay (check patch 25). It's 10.000 on RF5111
>> and 2.000 on RF5112 and later, if we divide by A clock it's 250 on
>> RF5111 and 50 on RF5112 and later. Do you think it's related ?
>
> The phy-rx-start-delay is set in the standard. I'll find you the
> relevant pages soon.

The aPHY-RX-START-Delay value is specific per PHY. In the case of
OFDM, you can find the relevant timings at:

Table 17-15--OFDM PHY characteristics
aPHY-RX-START-Delay 25 ìs (20MHz) 49 ìs (10MHz) 97 ìs (5MHz)

>
> I'll look up the others tomorrow. I'm feeling pretty sick today, so
> not sure if I'll get a chance.

I just a quick look at the code. The first thing that pops to mind and
that is apparent in the Table mentioned above, you can't just multiply
by 2 every time you halve the channel - the value is actually slightly
shorter than this.

Secondly, I'm assuming that the AR5K_PHY_RX_DELAY register refers to
the aPHY-RX-START-Delay value from the standard. It would make sense
that the card require this value, as it is necessary in resetting the
NAV (9.2.5.4 Setting and resetting the NAV), for CTS timeouts (9.2.5.7
CTS procedure), & ACK Timeouts (9.2.8 ACK procedure). The first 2
cases both refer to station behaviour after an RTS frame, but are
slightly different in that one is from an overhearing station, whereas
the the second is from the sending station. In the driver, which case
is the CTSTimeout value used for?

Cheers,

Jonathan

>
> Cheers,
>
> Jonathan
>
>>
>> --
>> GPG ID: 0xD21DB2DB
>> As you read this post global entropy rises. Have Fun ;-)
>> Nick
>>
>
