Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:32393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYGEV2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 17:28:39 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2062326rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 14:28:39 -0700 (PDT)
Message-ID: <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com> (sfid-20080705_232844_206868_1D91B2B0)
Date: Sun, 6 Jul 2008 00:28:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Question on rfkill double block
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <20080702193202.GA20410@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214982208.14590.473.camel@debian.sh.intel.com>
	 <20080702193202.GA20410@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 2, 2008 at 10:32 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 02 Jul 2008, Zhu Yi wrote:
>> It doesn't say what to do if both the hardware and software rfkill lines
>> are active when RFKILL_STATE_UNBLOCKED is asked. Should we deactivate
>> the software rfkill in this case? Otherwise below usage won't turn on
>> the radio:
>
> Well, we allow double-blocking to make sure the radio isn't unblocked by
> mistake.  The bias in rfkill is to block, as that is safer.
>
> The issue is that if we get a RFKILL_STATE_UNBLOCKED request, and we are at
> RFKILL_STATE_HARD_BLOCKED, we need to return an error (we can't set the
> requested state).  But since we returned an error, should we do the best we
> can, or should we do nothing?
>
> I am really not sure what would be better: to remove the double-blocking
> while still returning an error, or to leave the radio as is (be it
> double-blocked or just blocked by the hardware rfkill line) and return an
> error.
>
> Both would work just fine as far as the rfkill class goes, it wouldn't get
> confused by either as far as I can tell (*as long as an error is
> returned!*).  But we really should pick one of the two, and document that
> IMHO.
>
> My best guess is that doing a half-unblock would be less confusing to the
> user, but we can ask the userspace GUI people about it ;-)  Dan?
>
>> hardware rfkill activate
>> software rfkill activate
>> RFKILL_STATE_UNBLOCKED request
>> hardware rfkill deactivate
>>
>> Furthermore, if we permit double block, what should get_state() return?
>
> get_state() returns RFKILL_STATE_HARD_BLOCKED when any hardware rfkill lines
> are active.  If ALL hardware rfkill lines are inactive, it will return
> RFKILL_STATE_SOFT_BLOCKED if any software rfkill lines are ative.
>
> And if EVERY rfkill line is inactive, it returns RFKILL_STATE_UNBLOCKED.
>
> This makes sense, as you are basically stuck without being able to go
> anywere when in RFKILL_STATE_HARD_BLOCKED, until something external changes
> the hardware rfkill lines.
>
>> Shouldn't rfkill_state ???be bitmap instead of enum?
>
> We could do that, too.  But a bitmap would cause trouble due to the ABI we
> inherited from the rfkill in the stable kernels, so it would be cleaner to
> just add a fourth state (RFKILL_STATE_DOUBLE_BLOCKED).
>
> However, I am pretty certain we will find firmware (hardware is less likely
> to be this stupid) that has erratic behaviour when RFKILL_STATE_HARD_BLOCKED
> (and thus you don't really know if you managed to double-block or remove a
> double-block).  In fact, that's the kind of crap I am used to fight in
> thinkpad-acpi, although I sure hope thinkpads don't have this particular
> quirk.
>
> So, I pose this question:  Four states would allow us to tell the user the
> radio is JUST hardware-killed or JUST software-killed for some hardware, but
> does THAT enhance the user experience in any way?  Do GUIs really need that
> detail?

>From my experience from other OS the states of SW and HW RF KILL
switches should be independent and visible to user space
otherwise it's very hard to make something coherent out of it. It
should be visible to user himself so he/she knows what switch actually
press. And also to let say unmanned application, most important in
preserving SW switch state across reboots and resume/suspend events.
Radio state is just simple AND function of all the switches in the
game anything else just leads to confusion.
Currently we have rkill switch from sysfs, hw rfkill, iwconfig txpower
off, the last one is better to eliminate but still we have TRIPLE
BLOCKING

Thanks
Tomas
