Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55272 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbZK1Qmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 11:42:54 -0500
Date: Sat, 28 Nov 2009 14:42:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: Re: rfkill: persistent device suspend/resume
Message-ID: <20091128164257.GA28189@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk>
 <1245161645.13461.3.camel@johannes.local>
 <4A37AEB7.6060405@tuffmail.co.uk>
 <20090618030806.GE29569@khazad-dum.debian.net>
 <20091128124158.GB17373@khazad-dum.debian.net>
 <4B114288.2000409@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B114288.2000409@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Nov 2009, Alan Jenkins wrote:
> Sorry for my naff patch description. The actual corner case is when
> the soft rfkill state changes between when we suspend and resume.

Ah, ok.

> "we really want to restore the hardware to the previous soft state"
> 
> Context warning: this only affects "persistent" rfkill devices. We
> currently do this for everything except thinkpad-acpi and
> eeepc-laptop.

Yes.  This is _only_ about persistent rfkill devices, i.e. thinkpads and
eeepc.

> Blame Marcel, the current choice was his suggestion :). I think his
> argument was that restoring the state could impose policy, and that
> this would be bad. I didn't resist too hard because his principle
> provides a marginal feature in eeepc-laptop.

Actually, that is a good argument, and I was not aware of it.

> [That said, I later noticed that it speeds up resume from s2ram.
> eeepc-laptop is 'special'; its WLDS method takes a whole second to
> run.]

Which is another good argument.

I can fix the regression in thinkpad-acpi either way, and I have just
found that I _will_ have to change code in thinkpad-acpi to fix it in
either case.

But I'd rather do it in the best way possible :)

If the current way (no resume for persistent devices) has real
advantages, I will just deal with it in the driver.

> To elaborate:
> 
> The state in NV-ram may be changed deliberately. On eeepc-laptop,
> you can change it in the BIOS setup screen - and then resume from
> hibernation. Marcel suggests that overriding this change would be a
> policy decision, which userspace should be able to control. The
> simplest way to do so is to simply preserve the state (and emit an
> event to notify userspace of the change).

I see.  that's the missing link.  While thinkpads _can_ do that too, it
changes the *hard* kill line, and it (obviously) cannot be overriden at
all... When you disable radios in the ThinkPad BIOS, they _stay_
disabled... at least on the IBM models.

I was aware of the change-in-NVRAM possibility, but dismissed it since
we don't support booting another OS in the middle of a hibernation
cycle.  The idea that the BIOS could be used to change NVRAM didn't
cross my mind.

> I thought thinkpad-acpi might also allow such changes. At least for
> some controls, the BIOS defaults to implementing them itself, right?

Yes, but for the radios, the BIOS goes the way of "disabled is
disabled", and doesn't let you change the NVRAM.  That might have
changed on the newer Lenovo models, but I have not heard of any changes
yet.

> Even if this isn't true for rfkill on the thinkpad, it's a
> possibility we may encounter in future. Imagine a system where this

You told me EEEPC takes good advantage of the current way of doing
things, and I can certainly make it work properly in thinkpad-acpi as
well.

So, as far as I am concerned, you proved to me that there are strong
advantages for the current way of doing things, and until there is a
compelling need to have radios locked on resume, I think it is best to
leave things as is.

> - hibernate
> - boot resume kernel
> - user presses rfkill key -> BIOS toggles the rfkill state
> - load kernel from hibernation image
> - rfkill resume now unconditionally overrides the rfkill state

Yeah, ugly mess.

> rfkill-input is scheduled for removal in anticipation of rfkilld. If
> you want to schedule removal of persistent rfkill devices in
> anticipation of "rfkilld with persistence", that would seem just as
> reasonable :-p. I'm sure Johannes would then accept the small change
> to the rfkill core to fix this regression.

Nah, I think it is best to deal it in the driver, given the data you
just presented.

And I am strongly against foring users to use rfkilld-based persistence
in platforms that can do better (i.e. thinkpad-acpi and eeepc) :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
