Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:4188 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbYGGSsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 14:48:01 -0400
Received: by yx-out-2324.google.com with SMTP id 8so485091yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 11:48:00 -0700 (PDT)
Message-ID: <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com> (sfid-20080707_204808_506828_F37BEA8C)
Date: Mon, 7 Jul 2008 14:47:59 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Question on rfkill double block
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
In-Reply-To: <20080707165634.GA24815@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214982208.14590.473.camel@debian.sh.intel.com>
	 <20080702193202.GA20410@khazad-dum.debian.net>
	 <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com>
	 <20080706002037.GD21973@khazad-dum.debian.net>
	 <48719F2F.5060301@myrealbox.com>
	 <20080707165634.GA24815@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 12:56 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 07 Jul 2008, Andy Lutomirski wrote:
>> Perhaps it's time to throw out the userspace interface and start over,
>> or at least replace it and emulate the old one, too.
>
>> Maybe the new semantics should be something sensible with a read-only
>> file called "rfkill" that's backwards-compatible and shows the overall
>> state.  Then we could do gnarly things like making *every* mac80211
>> driver have software rfkill control, add inotify or something to the
>> rfkill file, and generally have good and easily comprehensible control
>> over all radios.  Hardware switches (and momentary swtiches and buttons
>
> wireless network device driver support for the rfkill class is on the way,
> but I don't think the mac80211 layer can help much (it is a very device
> specific thing, rfkill is not about stopping data transfers, it is about
> stopping energy emissions from the antennae).  If I am wrong about this,
> someone will step up and correct me quite soon :-)

I agree that rfkill is about stopping rf emission, but rf devices with
the emission turned off are generally useless (other than monitor
mode) and it might be nice to do everything possible to reduce power
consumption when rfkill is blocked.  Also, even if a device can't
specifically block RF emission, having an easy-to-use off switch is
still handy.

>
>> I'd suggest that nothing visible to userspace on the rfkill side go into
>> 2.6.27 until it can be done right and it's clear what this whole
>> mechanism is supposed to do.  I might even be talked into writing some
>> patches, because it would be kind of nice for all this stuff to work
>> right on my laptops.
>
> Well, please get the very latest wireless-testing tree, and read
> Documentation/rfkill.txt to see what has been done already (and remember
> that there could be some recent patches in this ML that have not been
> applied to wireless-testing yet).  You may need to read some threads from
> the last month too.
>
> In particular, read the small, recent thread about rfkill double-locking
> after you read Documentation/rfkill.txt.
>
> That will bring you up to speed with what is being done, and then we can
> talk more about it.  A lot of what you commented about is already in there,
> although not exactly in the same way as you talked about it.  The various ML
> threads (you can search linux-wireless and LKML for "rfkill" to find them)
> have the reasoning behind most of the details.
>
>> If I'm missing something I need to make rfkill suddenly work on my
>> machine, please give me some hints, too :)
>
> [...]

Now I'm running wireless-testing + thinkpad-acpi 0.21-20080703 and
everything appears to work (the button controls just bluetooth, the
switch works and gets noticed by the driver, etc).  I turned off
Ubuntu's hotkey-setup, which had some alternate thinkpad thing.

Nice work on the new thinkpad-acpi, BTW.  It's quite an improvement.

I'll play around with the new stuff.

--Andy
