Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61180 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LRQjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 11:39:24 -0500
Received: by mail-vb0-f42.google.com with SMTP id w5so5234794vbf.29
        for <linux-wireless@vger.kernel.org>; Wed, 18 Dec 2013 08:39:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B1CA51.4010202@broadcom.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 19 Dec 2013 00:39:03 +0800
Message-ID: <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> (sfid-20131218_173927_371481_C457C69D)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Dec 19, 2013 at 12:16 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/18/2013 02:12 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>>> brcmfmac driver in the near future?
>>>
>>> Hi Julian,
>>>
>>> I am working on a patch to support this chip. It is looking promising.
>>> Just have to go after a firmware image to be sure.
>>
>> Cool. Do you have a cubietruck? With my latest wip tree:
>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next
>
> No cubietruck here. I googled the term last week because it came up and
> found embeddedcomputer.nl selling it.
>
>> We've mmc/sdio controller support on top of 3.13-rc4, it would be
>> nice if we could also get the wifi and bluetooth to work here.
>>
>> I'm certainly willing to give some patches for this a try. Do you
>> have an example of what the dts file for a board with broadcom sdio
>> wifi looks like ?
>
> I am still struggling with dts changes for a Pandaboard. As I understood
> the cubietruck uses AP6210 module and the dts really depends on how
> things are wired up with it. Apart from the SDIO lines it may have an
> additional GPIO output to power the module and GPIO inputs to wakeup the
> host and interrupt line.

Yes it does. 2 GPIO lines for power, 1 for WiFi, 1 for BT.
Also takes 2 GPIO inputs for interrupts. Not sure how to feed this
to the driver. Last, it takes a clock output out of the A20 for the
low power 32k clock. Not sure if this is mandatory?

I've read the schematics more than a few times. I can get a dts out
tomorrow. I was planning on doing the clock output and rfkill part
first.


Regards,

ChenYu


>
>> Regards,
>>
>> Hans
>>
>>
>> p.s.
>>
>> Your last name seems Dutch, are you Dutch, and if so, are you
>> located in the Netherlands?
>
> Geboren en getogen. We hebben idd een Broadcom vestiging in Nederland.
>
> Gr. AvS
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
