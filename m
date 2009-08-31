Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:51239 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZHaTZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:25:26 -0400
Received: by iwn42 with SMTP id 42so1936775iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 12:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890908311215u378951e8j3283037ec6794764@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	<43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
	<3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
	<43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
	<1251357267.20531.4.camel@johannes.local> <3ace41890908270243i7c1d8ddav322a35c566d2c010@mail.gmail.com>
	<3ace41890908311143q697898a3mcbc681d3941b45c9@mail.gmail.com>
	<43e72e890908311154x51fd9481iea5e10fc5515af80@mail.gmail.com>
	<3ace41890908311215u378951e8j3283037ec6794764@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 12:25:08 -0700
Message-ID: <43e72e890908311225r3b0d80bcqcb3e3e11d81a255e@mail.gmail.com>
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
To: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 12:15 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Mon, Aug 31, 2009 at 7:54 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> On Mon, Aug 31, 2009 at 11:43 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>>> On Thu, Aug 27, 2009 at 10:43 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>>>> On Thu, Aug 27, 2009 at 8:14 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>>>>> On Wed, 2009-08-26 at 16:45 -0700, Luis R. Rodriguez wrote:
>>>>>
>>>>>> Johannes, did kernels < 2.6.31 have /sys/class/rfkill ?
>>>>>
>>>>> Yes, but I never understood why that matters. If you've got
>>>>> compat-wireless "rfkill" loaded then the original rfkill can't be loaded
>>>>> anyway. And their symbols would probably clash anyway if the original is
>>>>> built in, in which case you can't use compat.
>>>>>
>>>>> You haven't renamed cfg80211's sysfs either, so why rfkill?
>>>>>
>>>>> johannes
>>>>>
>>>>
>>>> There are a couple of wimax drivers which depends on rfkill... or
>>>> bluetooth drivers? I think one likely reason is that there are valid
>>>> situations or hardware combinations which requires having both of them
>>>> loaded. (but that's a whole can of worms )
>>>
>>> Argh, I just have a stacktrace after reboot - toshiba_acpi.ko (on a
>>> toshiba laptop) requires the stock-kernel rfkill-* symbols, and rfkill
>>> won't load because of my modified compat-wireless rfkill_backport.ko
>>> which takes up /sys/class/rfkill rather than
>>> /sys/class/rfkill_backport . There's your reason from sysfs renaming.
>>> I wonder why/how I could unload rfkill.ko earlier, since the *_acpi.ko
>>> needs it - maybe I had acpi unloaded as a side-effect also.
>>>
>>> I guess we'll need hal to treat /sys/class/rfkill_backport like
>>> /sys/class/rfkill  then - will file a bug somewhere on freedesktop,
>>> although I hear hal is on its way out....
>>
>> How many modules depend on rfkill, as with ssb maybe we should just
>> add them all ? I'm not volunteering though, but just pointing out that
>> if its not that many as with ssb perhaps its best to just add the
>> other drivers.
>>
>>  Luis
>>
>
> for fedora 11's stock, (which probably have all the modules of any use)
> #depmod -v | grep rfkill_register shows, besides drivers/net/wireless/* ,
>
> kernel/drivers/net/usb/hso.ko
> kernel/drivers/platform/x86/dell-laptop.ko
> kernel/drivers/platform/x86/acer-wmi.ko
> kernel/drivers/platform/x86/hp-wmi.ko
> kernel/drivers/platform/x86/sony-laptop.ko
> kernel/drivers/platform/x86/thinkpad_acpi.ko
> kernel/drivers/platform/x86/toshiba_acpi.ko
> kernel/net/wireless/cfg80211.ko

OK not so bad except for:

> kernel/net/wimax/wimax.ko

That's touching another subsystem but we could technically merge wimax
into compat-wireless if Inaky thinks that's a good idea. the point
here is to unify anything that uses rfkill for backport usage.

> If everything that depends on rkill is bundled with
> compat-wireless, there is probablt no need for the symbol and sysfs
> renaming hacks.

Right which is why I think this may be reasonable to do. Any thoughts Inaky?

  Luis
