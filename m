Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47352 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0BQWDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 17:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <2C0E2BCD-7589-45DE-B7D4-DBEFBFAE879D@gmail.com>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
	 <20100217180342.GA22522@srcf.ucam.org>
	 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
	 <20100217191708.GA15554@core.coreip.homeip.net>
	 <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com>
	 <20100217195435.GA15742@core.coreip.homeip.net>
	 <22ee4e771002171218t69cc4348ia0300a645ce9763d@mail.gmail.com>
	 <069C4DAE-598D-45F1-99B5-DA5BAF718179@gmail.com>
	 <22ee4e771002171328w3c9cbb8n663c291e9d3634e5@mail.gmail.com>
	 <2C0E2BCD-7589-45DE-B7D4-DBEFBFAE879D@gmail.com>
Date: Wed, 17 Feb 2010 23:03:08 +0100
Message-ID: <22ee4e771002171403o6f0b99e8qd683d78e74fe4522@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 10:40 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Feb 17, 2010, at 1:28 PM, Christian Lamparter <chunkeey@googlemail.com>
> wrote:
>
>> On Wed, Feb 17, 2010 at 9:52 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>>>
>>> Sorry, I was not clear enough. I meant something in works in Linux
>>> software
>>> stack, I was aware that certain router have these buttons already.
>>>
>>
>> wpa_supplicant and hostapd's CLI have this wps_pbc command.
>> It's more a question of: what application will get to receive the event.
>
> Right. So as soon as you have an idea about userspace consumer
> for the event ping me and I'd be glad to add a key definition for the event.
Idea? Be a bit more specific...

As a matter of fact, there are a few potential consumer in the kernel:

arm/mach-kirkwood/mv88f6281gtw_ge-setup.c:
.code           = KEY_F1,
.gpio           = 46,
.desc           = "WPS Button(F1)",
.active_low     = 1,

arm/mach-orion5x/wrt350n-v2-setup.c:
.code           = KEY_WLAN,
.gpio           = 2,
.desc           = "WPS Button",
.active_low     = 1,




and there's a lot more "out-off-tree":
https://dev.openwrt.org/browser/trunk/target/linux/ar71xx/files/arch/mips/ar71xx

mach-tew-632brp.c:
.desc           = "wps",
.type           = EV_KEY,
.code           = BTN_1,
.threshold      = 3,
.gpio           = TEW_632BRP_GPIO_BTN_WPS,

carl9170:
input_set_capability(input, EV_KEY, BTN_0);


as you can see, people are using BTN_1, BTN_0, F1, WLAN (rfkill?)
as WPS Button substitute. Maybe it would be a good idea to get it right
now!
