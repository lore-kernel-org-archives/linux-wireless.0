Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:16496 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbYGGTSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 15:18:31 -0400
Received: by yx-out-2324.google.com with SMTP id 8so492922yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 12:18:30 -0700 (PDT)
Message-ID: <cb0375e10807071218w3dacef45kaaaba102ecc03c59@mail.gmail.com> (sfid-20080707_211836_106572_D674702B)
Date: Mon, 7 Jul 2008 15:18:30 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Question on rfkill double block
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
In-Reply-To: <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214982208.14590.473.camel@debian.sh.intel.com>
	 <20080702193202.GA20410@khazad-dum.debian.net>
	 <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com>
	 <20080706002037.GD21973@khazad-dum.debian.net>
	 <48719F2F.5060301@myrealbox.com>
	 <20080707165634.GA24815@khazad-dum.debian.net>
	 <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 2:47 PM, Andrew Lutomirski <luto@myrealbox.com> wrote:
> On Mon, Jul 7, 2008 at 12:56 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
>> On Mon, 07 Jul 2008, Andy Lutomirski wrote:

>>
>>> If I'm missing something I need to make rfkill suddenly work on my
>>> machine, please give me some hints, too :)
>>
>> [...]
>
> Now I'm running wireless-testing + thinkpad-acpi 0.21-20080703 and
> everything appears to work (the button controls just bluetooth, the
> switch works and gets noticed by the driver, etc).  I turned off
> Ubuntu's hotkey-setup, which had some alternate thinkpad thing.
>
> Nice work on the new thinkpad-acpi, BTW.  It's quite an improvement.
>
> I'll play around with the new stuff.

OK, got a "bug" for you.  I'm not sure whether it's a bug in rfkill,
rfkill-input, iwlwifi, thinkpad-acpi, or the way they all interact.

If I press the button on the keyboard (the icon makes it look like
wifi), then bluetooth is toggled on and off and nothing happens to
wlan rfkill.  This is fine with me.

But if I toggle bluetooth off (killed and therefore not present in the
system per thinkpad-acpi), then block wlan with the switch, then
unblock wlan with the switch, then bluetooth turns back on.  This only
happens with rfkill-input loaded.  I hope this isn't the intended
behavior.

The radio button does this (from evtest on "ThinkPad Extra Buttons"):

Event: time 1215457292.276962, type 1 (Key), code 385 (Radio), value 1
Event: time 1215457292.276977, -------------- Report Sync ------------
Event: time 1215457292.276982, type 1 (Key), code 385 (Radio), value 0
Event: time 1215457292.276984, -------------- Report Sync ------------


Toggling the switch to blocked then back to unblocked does:

Event: time 1215457296.509094, type 5 (?), code 3 (?), value 0
Event: time 1215457296.509107, -------------- Report Sync ------------
Event: time 1215457297.544226, type 5 (?), code 3 (?), value 1
Event: time 1215457297.544244, -------------- Report Sync ------------

So the right input events are generated (or maybe not -- should
thinkpad-acpi generate events at all for a hardware switch?), but it
looks like rfkill-input thinks that it's supposed to turn bluetooth on
when the switch goes on.

Is this an artifact of the present design or is it just a bug?

(My mental picture of how it should work is that there should be
"switches" and "switchable things," both of which show up in sysfs,
and which can be wired up arbitrarily (consistent with hardware, so a
switch that physically controls an rfkill line couldn't be unwired
from it) in sysfs, kinda like led triggers.  "switches" would be
things like the radio switch (which thinkpad-acpi can ignore
completely because iwlwifi or presumably any other wireless driver can
also see it), the rfkill minipci line, and virtual switches
synthesized from buttons (the bluetooth button, the light button, etc)
and switchable things could be radios, bluetooth devices, keyboard
lights, etc.)

--Andy
