Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57281 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABQxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 11:53:30 -0500
Received: by mail-wg0-f54.google.com with SMTP id n12so12895960wgh.9
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 08:53:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
From: Michal Suchanek <hramrach@gmail.com>
Date: Thu, 2 Jan 2014 17:52:47 +0100
Message-ID: <CAOMqctSBd+AvYzKJT+JMPW5h62P2pWKHgV+1wiR0BP7ALarijQ@mail.gmail.com> (sfid-20140102_175333_669163_5E57AE88)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 19 December 2013 11:12, Chen-Yu Tsai <wens@csie.org> wrote:
> Hi,
>
> On Thu, Dec 19, 2013 at 12:39 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>> Hi,
>>
>> On Thu, Dec 19, 2013 at 12:16 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 12/18/2013 02:12 PM, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>>>>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>>>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>>>>> brcmfmac driver in the near future?
>>>>>
>>>>> Hi Julian,
>>>>>
>>>>> I am working on a patch to support this chip. It is looking promising.
>>>>> Just have to go after a firmware image to be sure.
>>>>
>>>> Cool. Do you have a cubietruck? With my latest wip tree:
>>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next
>>>
>>> No cubietruck here. I googled the term last week because it came up and
>>> found embeddedcomputer.nl selling it.
>>>
>>>> We've mmc/sdio controller support on top of 3.13-rc4, it would be
>>>> nice if we could also get the wifi and bluetooth to work here.
>
> I got the chip to respond to probing. It is BCM43362 for sure.
>
>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat device
>   0xa962
>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat vendor
>   0x02d0
>
> Vendor ID is Broadcom. Device ID is 43362.
> But I get two devices, mmc1:0001:1 and mmc1:0001:2. I don't know
> if this is normal or not.
>
> Bluetooth still isn't responding.
>

Well, bluetooth is supposed to be attached to an UART, not SDIO.
That's what the datasheets of the chip I found looked like.

Not sure how firmware is supposed to fit in in this case but this
would not be the first serial BT chip requiring firmware, would it?

Thanks

Michal
