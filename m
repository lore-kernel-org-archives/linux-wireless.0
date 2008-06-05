Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:34280 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYFEQgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 12:36:35 -0400
Received: by yw-out-2324.google.com with SMTP id 9so440433ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 09:36:30 -0700 (PDT)
Message-ID: <1ba2fa240806050936o383111cepcd6733d1ed205a26@mail.gmail.com> (sfid-20080605_183643_332964_D6DD356C)
Date: Thu, 5 Jun 2008 19:36:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <200806051803.43193.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <200806051803.43193.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2008 at 7:03 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Thursday 05 June 2008, Henrique de Moraes Holschuh wrote:
>> On Thu, 05 Jun 2008, Tomas Winkler wrote:
>> > SW should be able to more sw radio switch regardless of hw switch so
>>
>> Be extremely careful with "should" and any ideas you might have of the
>> capabilities of rf switch hardware, because chances are firmware-based
>> switches will frustate you.   In fact, you're wrong.  Some firmware
>> softswitches don't let you change their status when there is also a
>> hardware switch present, and that hardware switch is in the "block
>> transmissions" state.
>>
>> > I believe it's better to have separate sysfs entry for sw and hw switch states.
>> > hw sysfs file should be read only.
>>
>> When you do this (have more than one rfkill class for the same device),
>> the kernel events and uevents are not able to propagate the real state
>> of the device anymore:  upon the recepit of any event, you need to
>> *locate* all rfkill switches attached to that device, query them all,
>> and only if all of them are in state RFKILL_STATE_ON, will the device be
>> in RFKILL_STATE_ON.
>>
>> So, we'd need to change the rfkill class to avoid all that hassle (see
>> more on this below).
>>
>> Sincerely, I heavly prefer to add a third state (RFKILL_STATE_HARDOFF or
>> something like that).  That is a safe path that will have no subtle
>> interactions with the way rfkill is meant to be used.  I am not so sure
>> the other possibilities have this advantage, even if I cannot pinpoint
>> what interactions they could cause right now.
>>
>> > I agree it good to keep radio state separately as well.
>>
>> I don't like this either, unless by "separate" you mean outside of
>> rfkill entirely.
>>
>> What you seem to be calling "radio state" is the effective state of a
>> device with more than one kill line (be it software or hardware).  We
>> could call that "device rfkill state" instead of "switch rfkill state"
>> to avoid confusion, I suppose.
>>
>> Anyway, if we are to use various *related* rfkill switches per device,
>> rfkill needs further changes, including an extra callback into the
>> driver, so as to be able to export the device rfkill state also in all
>> switch rfkill state events (otherwise these events become quite useless
>> for many uses).
>>
>> It is more complicated and heavyweight a solution for very little gain
>> when compared to the addition of a third RFKILL_STATE state, IMO.
>> Remeber that multiple related switches per device adds complexity to the
>> INTERFACE, and therefore to all applications that use that interface.
>>
>> > Third I think this patch use opposite logic as used currently in
>> > practice. RFKILL_ON means that radio is off .
>>
>> The correct reading of rfkill class states are:
>>
>> RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
>> RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.
>>
>> Nothing else is correct.
>>
>> We could certainly rename these states to
>>
>> enum rfkill_state {
>>       RFKILL_STATE_BLOCKED = 0,
>>       RFKILL_STATE_UNBLOCKED = 1,
>> };
>>
>> #define RFKILL_STATE_ON RFKILL_STATE_UNBLOCKED
>> #define RFKILL_STATE_OFF RFKILL_STATE_BLOCKED
>>
>> Ivo, do you want a patch that does the above (plus the documentation
>> changes, of course)?
>
> Patch would be good. I would however drop the #define RFKILL_STATE_ON
> and force the RFKILL_STATE_BLOCKED/RFKILL_STATE_UNBLOCKED usage
> to make sure everybody gets the right idea about the meaning.
>
> Ivo
>
Cannot this be just fixed with ~ sed -s/ON/OFF/g'  over the kernel?
Tomas
