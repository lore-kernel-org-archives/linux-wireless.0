Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:4153 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYFEIdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 04:33:37 -0400
Received: by rv-out-0506.google.com with SMTP id l9so594962rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 01:33:37 -0700 (PDT)
Message-ID: <1ba2fa240806050133sd8ee9e2u2773a1bf1cce9bcb@mail.gmail.com> (sfid-20080605_103342_962973_6589528C)
Date: Thu, 5 Jun 2008 11:33:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <20080605003808.GA16599@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2008 at 3:38 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 05 Jun 2008, Tomas Winkler wrote:
>> SW should be able to more sw radio switch regardless of hw switch so
>
> Be extremely careful with "should" and any ideas you might have of the
> capabilities of rf switch hardware, because chances are firmware-based
> switches will frustate you.   In fact, you're wrong.  Some firmware
> softswitches don't let you change their status when there is also a
> hardware switch present, and that hardware switch is in the "block
> transmissions" state.
>

SW switch is a software state and what you are now describing here  is
not software per se.(I know that firmware is also a software) This is
diametrically different  from HW switch that you just cannot move by
any sw means. If you trigger RFKILL from SW and for some firmware
reason cannot get directly to HW just record the state.


>> I believe it's better to have separate sysfs entry for sw and hw switch states.
>> hw sysfs file should be read only.
>
> When you do this (have more than one rfkill class for the same device),
> the kernel events and uevents are not able to propagate the real state
> of the device anymore:  upon the recepit of any event, you need to
> *locate* all rfkill switches attached to that device, query them all,
> and only if all of them are in state RFKILL_STATE_ON, will the device be
> in RFKILL_STATE_ON.
>
> So, we'd need to change the rfkill class to avoid all that hassle (see
> more on this below).
>
> Sincerely, I heavly prefer to add a third state (RFKILL_STATE_HARDOFF or
> something like that).  That is a safe path that will have no subtle
> interactions with the way rfkill is meant to be used.  I am not so sure
> the other possibilities have this advantage, even if I cannot pinpoint
> what interactions they could cause right now.
>
>> I agree it good to keep radio state separately as well.
>
> I don't like this either, unless by "separate" you mean outside of
> rfkill entirely.
>
> What you seem to be calling "radio state" is the effective state of a
> device with more than one kill line (be it software or hardware).  We
> could call that "device rfkill state" instead of "switch rfkill state"
> to avoid confusion, I suppose.

This is radio state and not rfkill switch state.


> Anyway, if we are to use various *related* rfkill switches per device,
> rfkill needs further changes, including an extra callback into the
> driver, so as to be able to export the device rfkill state also in all
> switch rfkill state events (otherwise these events become quite useless
> for many uses).
>
> It is more complicated and heavyweight a solution for very little gain
> when compared to the addition of a third RFKILL_STATE state, IMO.
> Remeber that multiple related switches per device adds complexity to the
> INTERFACE, and therefore to all applications that use that interface.
>
>> Third I think this patch use opposite logic as used currently in
>> practice. RFKILL_ON means that radio is off .
>
> The correct reading of rfkill class states are:
>
> RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
> RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.
>



> Nothing else is correct.
>

This is opposite logic as used in industry and you are creating mess
here. RFKILL_ON means that you killed the radio and it moves
radio to disable state.
If you want to use your logic the remove the world KILL form it.
RF_ON, RF_OFF would match your intention.

Tomas
