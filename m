Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63825 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3DOOWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:22:00 -0400
Received: by mail-wg0-f51.google.com with SMTP id b12so4579877wgh.18
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 07:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366012397.74181.YahooMailNeo@web193503.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
	<CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com>
	<1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-Vmo===nANf3g5psxf3aV7L8jVQ8mjRP+1WM0PSS9PgcGHBA@mail.gmail.com>
	<1365561451.4973.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmokkC4veD4UMfP99Rbkyd3OZMxK46vZaQfqbDX9Ux6E3vA@mail.gmail.com>
	<1365574412.20937.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmonwA=25ooSXFrNJydkERWwP7D_iY+VvDu_wz+=G7tNoBQ@mail.gmail.com>
	<1366012397.74181.YahooMailNeo@web193503.mail.sg3.yahoo.com>
Date: Mon, 15 Apr 2013 07:21:55 -0700
Message-ID: <CAJ-Vmomdv1Z2_H7L_=wU+g355b0HOgMQBt6MXkJv+Aqr1EG=Rg@mail.gmail.com> (sfid-20130415_162206_515617_053BBE02)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please supply the register values that you're programming in here.

Thanks,



adrian


On 15 April 2013 00:53, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian,
>     I continued my testing with:
> 1. 2-wire coexistence mode with WLAN_ACTIVE and BT_ACTIVE lines
> 2.  Different values to the weight registers. For most of the cases I give a
> 0x0000 weightage to WLAN and 0xFFFF weightage to BT, to ensure that BT
> always gets the priority for any type of WLAN traffic.
> 3. WiFi in Access Point mode. I have connected one WiFi source (WiFi camera
> as client ) and WiFi destination (Laptop as client).
>
> I definetely see a lot of difference (based on status of WLAN_ACTIVE) with
> and without Co-existence active. Following are the observations:
> 1. Without the BT_ACTIVE signal, the WLAN traffic seems to be evenly
> distributed.
> 2. Next I duty cycle BT_ACTIVE with 100ms period, 70ms for BT and 30ms for
> WiFi. The observation is that when BT_ACTIVE is true, the WiFi activity is
> REDUCED but not completely eliminated. My understanding is that when
> BT_ACTIVE is True WLAN should show logic '0'.
>
> The following are some queries:
> a. WiFi chipset is in WiFI AP mode and WLAN_ACTIVE is True when either
> WLAN_TX or WLAN_RX is True. So are the pulses I see during BT_ACTIVE true
> are because of WLAN_RX? The following is the configuration for WLAN_ACTIVE
> gpio
>
> /* Configure the desired GPIO port for TX_FRAME output */
>  ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
>        AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
> b. Is there a way to configure the MUX and GPIO in a manner to do some thing
> like this?
>     When WLAN_TX is active than GPIO6 is activated
>     When WLAN_RX is active than GPIO7 is activated.
> c. Or is it that I need to use 3-wire coexistence for this kind of wifi
> configuration (WiFI AP mode)?
> d. Please let me know if there is any basic mis-understanding I have?
>
> Thanks & regards
> Sandeep.
> From: Adrian Chadd <adrian@freebsd.org>
> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
> Cc: Sujith Manoharan <sujith@msujith.org>; ath9k-devel
> <ath9k-devel@lists.ath9k.org>; "linux-wireless@vger.kernel.org"
> <linux-wireless@vger.kernel.org>
> Sent: Wednesday, 10 April 2013 12:52 PM
>
> Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
>
> No, wifi stomping occurs with both 2-wire and 3-wire.
>
> BT_PRIORITY just gives the MAC the ability to tell the difference
> between high priority TX and any bt activity requiring the air, so the
> MAC can then choose a weight based on differnet kinds of BT inputs.
>
> If all you have is two wire, then you don't get separate weight table
> entries for different kinds of BT transmissions.
>
>
>
> adrian
>
> On 9 April 2013 23:13, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>> Hello Mr.Adrian,
>>    Thanks for your response. I understand the following: Please correct if
>> I am wrong.
>> 1. With WLAN_ACTIVE and BT_ACTIVE, the wireless medium is managed between
>> BT
>> and WLAN without stomping the traffic.
>> 2. With WLAN_ACTIVE, BT_ACTIVE and BT_PRIORITY, WiFI traffic stomping is
>> possible.
>>
>> Regards
>> Sandeep.
>>
>> From: Adrian Chadd <adrian@freebsd.org>
>> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
>> Cc: Sujith Manoharan <sujith@msujith.org>; ath9k-devel
>> <ath9k-devel@lists.ath9k.org>; "linux-wireless@vger.kernel.org"
>> <linux-wireless@vger.kernel.org>
>> Sent: Wednesday, 10 April 2013 11:07 AM
>>
>> Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
>>
>> Right, but same deal - if it asserts the line, it should stomp wifi
>> transmission in your particular scheme.
>>
>>
>>
>> adrian
>>
>>
>> On 9 April 2013 19:37, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>>> Hello Mr.Adrian,
>>>    Thanks for your response. During googling, I had come across the
>>> following 2-wire coexistence solution from owl modules.
>>>
>>>
>>>
>>> http://support.connectblue.com/display/PRODWLAN/cB-OWL22x+Bluetooth+co-existence+application+note
>>> According to this application note, for 2-wire coexistence, WLAN_ACTIVE
>>> and
>>> BT_PRIORITY signals are used rather than WLAN_ACTIVE and BT_ACTIVE.  What
>>> is
>>> your opinion on this? And as I understand owl modules are based on
>>> Atheros
>>> chipsets.
>>>
>>> Regards
>>> Sandeep.
>>>
>>> From: Adrian Chadd <adrian@freebsd.org>
>>> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
>>> Cc: Sujith Manoharan <sujith@msujith.org>; ath9k-devel
>>> <ath9k-devel@lists.ath9k.org>; "linux-wireless@vger.kernel.org"
>>> <linux-wireless@vger.kernel.org>
>>> Sent: Wednesday, 10 April 2013 4:30 AM
>>>
>>> Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
>>>
>>> Hi,
>>>
>>> Yes, "WLAN_ACTIVE" here is just both TX and RX activity.
>>>
>>> So if it were working, that would stay low.
>>>
>>>
>>>
>>> adrian
>>>
>>>
>>
>>
>
>
