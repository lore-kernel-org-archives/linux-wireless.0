Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f176.google.com ([209.85.221.176]:55268 "EHLO
	mail-qy0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZFEM6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 08:58:07 -0400
MIME-Version: 1.0
In-Reply-To: <bc64b4640906042149pb83911bk4e0397da11f9fde6@mail.gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	 <9e4733910906042103q6c21886cia02d33cb278cef1e@mail.gmail.com>
	 <bc64b4640906042149pb83911bk4e0397da11f9fde6@mail.gmail.com>
Date: Fri, 5 Jun 2009 08:58:07 -0400
Message-ID: <9e4733910906050558h44382214m30fb8c9c7bbba63@mail.gmail.com>
Subject: Re: [RFC][WIP] IEEE 802.15.4 implementation for Linux v1
From: Jon Smirl <jonsmirl@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, slapin@ossfans.org,
	maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
	oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 5, 2009 at 12:49 AM, Dmitry
Eremin-Solenikov<dbaryshkov@gmail.com> wrote:
> 2009/6/5 Jon Smirl <jonsmirl@gmail.com>:
>> On Mon, Jun 1, 2009 at 10:54 AM, Dmitry
>> Eremin-Solenikov<dbaryshkov@gmail.com> wrote:
>>> Hi,
>>>
>>> As a part of research activities the Embedded Systems - Open Platform Group
>>> from Siemens Corporate Technology we are working on adding support for
>>> the IEEE 802.15.4 Wireless Personal Area Networks to the Linux. Our current
>>> implementation is neither certified nor even feature complete. However
>>> we'd like to present current state of our patchset to the Linux developers
>>> community to gain comments, fixes, ideas, etc. This is not yet a pull request,
>>> but more like an RFC.
>>
>> Does this stack work with the Atmel USB version of at86rf230?
>> ATAVRRZUSBSTICK, http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4396
>
> No, we do not support Atmel USB sticks, nor we do not have plans for
> adding support
> for it in the foreseable feature. However if the onboard ATmega can be
> programmed to
> provide usb-serial interface, one can use/adapt our serial discipline
> driver to control it.
> One will still have to write firmware for the on-stick ATmega chip.
>
> Or you can add support for any existing interface that is provided by
> RazorUSB card by yourself.
> We tried to make mac802154 drivers easy to implement.
>
>> It's not so simple to plug in the at86rf230 using SPI. Supporting USB
>> sticks lets you develop on a desktop PC.
>
> Hmm. One can solder (e.g.) the FTDI 2232 together with AT86RF230/231
> and use that combo
> instead of RazorUSB sticks.

Everything is there on USB stick. Interface, Zigbee chip, antenna, power, etc..
And they are cheap $40.

>
>> freaklabs.org is using ATAVRRZUSBSTICK
>
> I'll look for the interface they are using to control sticks and check
> how easy will it be to
> write a driver for it.

For development purposes you don't want to download the stack into the
USB stick, you just want to use USB as a transparent pass-through to
the Zigbee chip.

I have a Raven kit ordered, it will be here next week.


> --
> With best wishes
> Dmitry
>



-- 
Jon Smirl
jonsmirl@gmail.com
