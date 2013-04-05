Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46965 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161515Ab3DEIRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:17:25 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so3411217wgg.26
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 01:17:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
Date: Fri, 5 Apr 2013 01:17:23 -0700
Message-ID: <CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com> (sfid-20130405_101733_034732_45415949)
Subject: Re: AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's nothing public, no. Just the source code. :)


adrian


On 5 April 2013 01:00, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Thanks Mr. Adrian. I will revert back to you after sometime. But are there
> any documents/datasheets explaining on the BTCOEX mode registers, timing
> diagrams for 2-wire/3-wire coexistence based on Atheros chipset?
> I have already gone through the ath9k website; but does not contain these
> details.
> Thanks & Regards
> Sandeep.
>
> From: Adrian Chadd <adrian@freebsd.org>
> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
> Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>;
> ath9k-devel <ath9k-devel@lists.ath9k.org>
> Sent: Friday, 5 April 2013 9:43 AM
>
> Subject: Re: AR9287 ; 2-wire coexistence expected behavior
>
> You'll have to give me some more time to digest what I'm reading
> internally; it's all new to me.
>
> For FreeBSD, you can look at these files in FreeBSD-HEAD:
>
> sys/dev/ath/ath_hal/ar5416/ar5416_btcoex.c
> sys/dev/ath/ath_hal/ar9002/ar9285_btcoex.c (not that relevant for you,
> but still)
>
> These contain the register writes that the internal reference HAL is
> doing when programming btcoex for AR9285/AR9287.
>
> The AR9287 should support 2-wire coex fine.
>
> Just read those source files. The ar5416InitBTCoex() programs the
> BT_ACTIVE / WLAN_ACTIVE gpio's when you say the coexistence type is
> 2-wire. There's weights and such being programmed elsewhere; you need
> to make sure you pick the default values for that and try it out.
>
> I can't help you more than that at the moment; I'm busy doing other
> work that doesn't at all touch wifi. :)
>
>
>
> Adrian
>
> On 4 April 2013 20:08, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>> Hello Mr.Adrian,
>>    Thanks for your mail. Regarding your comment below:
>>
>> "THen you need to ensure the bluetooth coexistence registers are
>> programmed
>> so that btactive will correctly stomp wifi traffic."
>>
>> Can you please elaborate on this? As I understand the concept of
>> "stomping"
>> is only in 3-wire coexistence; correct me if I am wrong.
>>
>> As mentioned earlier, the set-up we have is a PCB board with general
>> purpose
>> MCU controlling the 2-wire coexistence pins of AR9287. As there are other
>> 2.4GHz radio (called PROP radio here) on the board, we want to ensure that
>> both radios do not transmit at the same time which will result in
>> collisions. Hence we want to build a co-operative coexistence approach so
>> that when PROP radio is active (by asserting BT_ACTIVE), AR9287 has to
>> buffer transmissions and allow PROP radio to be active. Only when PROP
>> radio
>> is inactive (BT_ACTIVE is deasserted), only then WiFi can be active. Hope
>> this is achievable?
>>
>> Thanks & Regards
>> Sandeep.
>>
>> From: Adrian Chadd <adrian@freebsd.org>
>> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
>> Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>;
>> ath9k-devel <ath9k-devel@lists.ath9k.org>
>> Sent: Thursday, 4 April 2013 11:36 PM
>>
>> Subject: Re: AR9287 ; 2-wire coexistence expected behavior
>>
>> Hi!
>>
>> I'm glad you're looking into this in more depth!
>>
>> On 4 April 2013 08:19, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>>
>>> I understand that ATH_BTCOEX_CFG_2_WIRE, ATH_BTACTIVE_GPIO_9280 (GPIO6 as
>>> per btcoex.h) and ATH_WLANACTIVE_GPIO_9280 (GPIO5 as per btcoex.h) are
>>> used.
>>
>> Ok, right.
>>
>>> I next started monitoring GPIO5 on oscillaoscope to see WLAN activity and
>>> I
>>> could see a lot of pulse trains. Next in order to simulate high priority
>>> BT
>>> traffic, I pulled the line GPIO6 high. But I did not see any change in
>>> WLAN
>>> activity as I could continue to see the pulse trains. My expectation was
>>> that there should not be any WLAN activity and hence no pulses. Please
>>> guide
>>> if I am missing anything?
>>
>> Well, firstyl you need to ensure that the GPIO pin has been programmed
>> to be an input, and it's of the right bluetooth type. As I said
>> before, GPIO pins can be input, output; they can be connected via an
>> internal mux to a variety of "behaviours". Take a look at the gpio
>> configure code in ath9k to see more.
>>
>> THen you need to ensure the bluetooth coexistence registers are
>> programmed so that btactive will correctly stomp wifi traffic.
>>
>> THat's all I know for now. Sorry.
>>
>>
>>
>> adrian
>>
>>
>
>
