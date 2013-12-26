Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3LZU36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Dec 2013 15:29:58 -0500
Message-ID: <52BC91AC.3070703@redhat.com> (sfid-20131226_213001_866250_C2E8545B)
Date: Thu, 26 Dec 2013 21:29:32 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
In-Reply-To: <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/26/2013 05:13 PM, Chen-Yu Tsai wrote:
> Hi,
>
> On Thu, Dec 19, 2013 at 6:12 PM, Chen-Yu Tsai <wens@csie.org> wrote:
>> Hi,
>>
>> On Thu, Dec 19, 2013 at 12:39 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>>> Hi,
>>>
>>> On Thu, Dec 19, 2013 at 12:16 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>>> On 12/18/2013 02:12 PM, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>>>>>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>>>>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>>>>>> brcmfmac driver in the near future?
>>>>>>
>>>>>> Hi Julian,
>>>>>>
>>>>>> I am working on a patch to support this chip. It is looking promising.
>>>>>> Just have to go after a firmware image to be sure.
>>>>>
>>>>> Cool. Do you have a cubietruck? With my latest wip tree:
>>>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next
>>>>
>>>> No cubietruck here. I googled the term last week because it came up and
>>>> found embeddedcomputer.nl selling it.
>>>>
>>>>> We've mmc/sdio controller support on top of 3.13-rc4, it would be
>>>>> nice if we could also get the wifi and bluetooth to work here.
>>
>> I got the chip to respond to probing. It is BCM43362 for sure.
>>
>>    root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat device
>>    0xa962
>>    root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat vendor
>>    0x02d0
>>
>> Vendor ID is Broadcom. Device ID is 43362.
>> But I get two devices, mmc1:0001:1 and mmc1:0001:2. I don't know
>> if this is normal or not.
>
> Merry Christmas everyone. I got AP6210 (BCM43362) to work with mainline
> brcmfmac driver. I only tested managed mode. Monitor mode does not work.
> You can use firmware from CubieTech images.
>
> Things missing:
>
>    1. output clock is using default 32KHz from 24M / 750.
>       need to find some place to put clk_set_rate call.
>
>    2. BCM43362 out-of-band interrupts not supported.
>       OOB interrupt in brcmfmac is set using platform data.
>       Need to put this is board code, or add device tree support.
>
> Core ID and addresses were found using bcmdhd driver debug output.
> Arend might want to take a look at the patch:
>
>    https://github.com/wens/linux/commit/d945809d27de930eba5db0ca4bb7936e3ca88865
>
> Working tree:
>
>    https://github.com/wens/linux/tree/wip/sunxi-next-wifi
>
> Comments welcome :)

Awesome! So now we have this working in upstream before we have it working with
3.4 kernels (at-least I've never managed to get it to work with 3.4 kernels).

Very nice Christmas present, thanks :)

I'll give this a spin and add it to the sunxi-devel branch.

Regards,

Hans


