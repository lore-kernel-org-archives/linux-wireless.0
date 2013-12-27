Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59049 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3L0Mg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 07:36:26 -0500
Received: by mail-vc0-f178.google.com with SMTP id lh4so4744479vcb.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Dec 2013 04:36:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52BD68BA.3080304@broadcom.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com>
 <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com> <52BD68BA.3080304@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 27 Dec 2013 20:36:05 +0800
Message-ID: <CAGb2v67Q=q4vyOftb+BLhAYR-6d04dDP3+kY3b88U8_vCvAmgQ@mail.gmail.com> (sfid-20131227_133629_774994_C12CE012)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>, benn@cubietech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Dec 27, 2013 at 7:47 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/26/2013 05:13 PM, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Thu, Dec 19, 2013 at 6:12 PM, Chen-Yu Tsai <wens@csie.org> wrote:
>>> Hi,
>>>
>>> On Thu, Dec 19, 2013 at 12:39 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>>>> Hi,
>>>>
>>>> On Thu, Dec 19, 2013 at 12:16 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>>>> On 12/18/2013 02:12 PM, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>>>>>>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>>>>>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>>>>>>> brcmfmac driver in the near future?
>>>>>>>
>>>>>>> Hi Julian,
>>>>>>>
>>>>>>> I am working on a patch to support this chip. It is looking promising.
>>>>>>> Just have to go after a firmware image to be sure.
>>>>>>
>>>>>> Cool. Do you have a cubietruck? With my latest wip tree:
>>>>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next
>>>>>
>>>>> No cubietruck here. I googled the term last week because it came up and
>>>>> found embeddedcomputer.nl selling it.
>>>>>
>>>>>> We've mmc/sdio controller support on top of 3.13-rc4, it would be
>>>>>> nice if we could also get the wifi and bluetooth to work here.
>>>
>>> I got the chip to respond to probing. It is BCM43362 for sure.
>>>
>>>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat device
>>>   0xa962
>>>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat vendor
>>>   0x02d0
>>>
>>> Vendor ID is Broadcom. Device ID is 43362.
>>> But I get two devices, mmc1:0001:1 and mmc1:0001:2. I don't know
>>> if this is normal or not.
>
> There might be three devices/functions. The last digit of the device
> indicates the SDIO function number. Function 1 allows access to F1
> registers in the SDIO core of the device and F2 is for WLAN
> functionality. F3 could be providing BT functionality, but I am not
> familiar with that part.
>
>> Merry Christmas everyone. I got AP6210 (BCM43362) to work with mainline
>> brcmfmac driver. I only tested managed mode. Monitor mode does not work.
>> You can use firmware from CubieTech images.
>
> brcmfmac does not support monitor mode. It does support AP mode and P2P
> modes.
>
>> Things missing:
>>
>>   1. output clock is using default 32KHz from 24M / 750.
>>      need to find some place to put clk_set_rate call.
>
> What clock is this? You mean there is a clock output driven by the
> AP6210 module or Cubieboard provides it to the module.

Cubieboard provides it to the module.

BCM43362 (WiFi) and BCM20710 (BT) both accept an external 32768 Hz
clock as low power clock. They can also use internal oscillator for
this, so it is optional. But according to BCM20710 datasheet, this
external clock is required to auto-detect the frequency of the main
oscillator if it's not the default 20MHz. On the CubieTruck, it is
26 MHz. For just WiFi, I think we don't need it.

>>   2. BCM43362 out-of-band interrupts not supported.
>>      OOB interrupt in brcmfmac is set using platform data.
>>      Need to put this is board code, or add device tree support.
>
> It would be good to add device tree support so the driver can first look
> for device tree data and have platform data and in-band as backup mechanism.

I'm not sure how to add support. Add a child node to the SD/MMC
controller, perhaps? I thought SDIO devices were like USB, in
that the system scans the bus and detects them.

>> Core ID and addresses were found using bcmdhd driver debug output.
>> Arend might want to take a look at the patch:
>>
>>   https://github.com/wens/linux/commit/d945809d27de930eba5db0ca4bb7936e3ca88865
>
> I have different addresses from the chip documentation, but my test spin
> went poorly. So much for hardware documentation. I will give these
> values a try. In my patch there is also bcm43362 specific SDIO drive
> strength programming (see attachment). The patch won't apply as my tree
> is a bit different due to some rework in the SDIO part of brcmfmac. So
> you probably need to pick the missing part from it.

Maybe it's a remarked chip? (is that possible?)
The firmware CubieTech has is for a BCM40181 though.

Added the drive strength programming by hand. Changed the table variable
name to match the others. Pushed on to my tree. Beware there are some
hacks trying to get BT to work. :p

>
>> Working tree:
>>
>>   https://github.com/wens/linux/tree/wip/sunxi-next-wifi
>>
>> Comments welcome :)
>
> No comment, but: Nice work!

Thanks. BTW, who should submit the patch? :)


ChenYu

>
> Gr. AvS
>
>>>
>>> Bluetooth still isn't responding.
>>
>> Bluetooth still not working. :(
>> Has anyone had any luck with this?
>>
>>>
>>>>>> I'm certainly willing to give some patches for this a try. Do you
>>>>>> have an example of what the dts file for a board with broadcom sdio
>>>>>> wifi looks like ?
>>>>>
>>>>> I am still struggling with dts changes for a Pandaboard. As I understood
>>>>> the cubietruck uses AP6210 module and the dts really depends on how
>>>>> things are wired up with it. Apart from the SDIO lines it may have an
>>>>> additional GPIO output to power the module and GPIO inputs to wakeup the
>>>>> host and interrupt line.
>>>>
>>>> Yes it does. 2 GPIO lines for power, 1 for WiFi, 1 for BT.
>>>> Also takes 2 GPIO inputs for interrupts. Not sure how to feed this
>>>> to the driver. Last, it takes a clock output out of the A20 for the
>>>> low power 32k clock. Not sure if this is mandatory?
>>>>
>>>> I've read the schematics more than a few times. I can get a dts out
>>>> tomorrow. I was planning on doing the clock output and rfkill part
>>>> first.
>>>
>>> Here's my tree, in case anyone wants to play around. It will be rebased
>>> a lot.
>>>
>>>   https://github.com/wens/linux/tree/wip/sunxi-next-wifi
>>>
>>> The DT is not finished yet. External interrupts and low power clock are
>>> still missing. Can anyone provide an example for useing the PIO EINT
>>> interrupt pins?
>>>
>>>
>>> Cheers,
>>>
>>> ChenYu
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
