Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:64089 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIQUv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 16:51:28 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1507022eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 13:51:26 -0700 (PDT)
Message-ID: <1ba2fa240809171351h293012daj4e1735f52e08b48b@mail.gmail.com> (sfid-20080917_225131_916722_58831D83)
Date: Wed, 17 Sep 2008 23:51:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Adel Gadllah" <adel.gadllah@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809171759.32645.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48CFC03A.8020708@lwfinger.net> <200809171619.33377.mb@bu3sch.de>
	 <20080917151822.GB5186@khazad-dum.debian.net>
	 <200809171759.32645.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2008 at 6:59 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 17 September 2008 17:18:22 Henrique de Moraes Holschuh wrote:
>> On Wed, 17 Sep 2008, Michael Buesch wrote:
>> > On Tuesday 16 September 2008 23:09:20 Matthew Garrett wrote:
>> > > Oh, hey, I suck. This one might stand a better chance of not falling
>> > > over.
>> > >
>> > > diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
>> > > index fec5645..991e318 100644
>> > > --- a/drivers/net/wireless/b43/rfkill.c
>> > > +++ b/drivers/net/wireless/b43/rfkill.c
>> > > @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
>> > >   struct b43_rfkill *rfk = &(dev->wl->rfkill);
>> > >
>> > >   if (!dev->radio_hw_enable) {
>> > > -         rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
>> > > +         rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
>> > >           return;
>> > >   }
>> > >
>> > >   if (!dev->phy.radio_on)
>> > > -         rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
>> > > +         rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
>> > >   else
>> > > -         rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>> > > -
>> > > +         rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
>> > >  }
>> >
>> > I still thing that it is really wrong to check and change the software
>> > rfkill state from within the _hardware_ rfkill state handler.
>> > So let's say this handler sets the state to SOFT_BLOCKED. Who is going
>> > to set it back to unblocked, if the user unblocks the radio?
>>
>> I would suggest reading the updated docs, but I know you'd rather just stay
>> away from rfkill.
>>
>> For reference:
>>
>> Basically, your wireless device driver has to monitor any hardware rfkill
>> lines and call rfkill_force_state() accordingly (you don't even need to
>> track if the state changed, rfkill core will do that).
>>
>> The call to rfkill_force_state() should set state to HARD_BLOCKED (any of
>> the hardware rfkill lines are active), SOFT_BLOCKED (no hardware rfkill
>> lines are active, but one of the software rfkill lines are active), or
>> UNBLOCKED (no rfkill lines of any type are active).
>>
>> Whether this is to be done through interrupts or pooling is something that
>> depends on your driver and the hardware.
>>
>> User and userspace interaction is taken care of by the rfkill core.  You do
>> nothing of the sort in the wireless device driver.
>>
>> There are *very few* exceptions for the above as far as wireless device
>> drivers go.  They are explained in the docs, and I know of no wireless
>> device driver that would require any them.
>>
>> > We can turn the radio on/off from the mac80211 config callback. Possibly
>> > we must tell rfkill about it (I'm not sure. I don't understand the API).
>> > I think this is pretty hard to get right, actually. HW-block and SW-block
>> > are two completely independent states in b43. You can HW-block and SW-block
>> > the device at the same time. So one must make sure that at any time the rfkill
>> > is in a sane state if _either_ HW-block or SW-block changes. Currently I think
>> > we only change rfkill state if HW-block state changes. Which is wrong.
>>
>> Again, for reference:
>>
>> You need to synthesize a single state (unblock/soft-block/hard-block) for a
>> transmitter from every rfkill line that affects that transmitter.  This
>> happens because the interface is a SINGLE ONE rfkill class per independent
>> wireless interface ("transmitter").
>
> Right. But that's not what I was talking about. The hw and sw rfkill is something
> _completely_ different in b43 and it's handled by _completely_ different codepaths.
> I just said that currently the sw-rfkill path does _not_ announce the state
> correctly to the rfkill subsystem. Additionally we must _not_ check the sw rfkill
> state from within the hw rfkill handlers, as it will get out of sync this way.
> (that's what we're currently doing. If you revert the commit from the subject
> this will go away, afaics).
> Telling rfkill about the state isn't the hard part, but the
> "You need to synthesize a single state" part, which currently is not done correctly.
> We currently have _two_ states. (Don't get me wrong, the fix is _not_ to remove
> either of these. The fix is to introduce a common rfkill notifier that constructs
> a common rfkill state from these two states. This notifier is called from hw-rfkill
> and sw-rfkill.)

In practice the rfkill in WiFi comes to 2 common cases
HW|SW

Most of the world SW and HW are independent states and radio is
enabled only in 0|0
        0|1
      /       \
0|0 -          - 1|1
      \       /
        1|0

Dell Only - Unblocking HW rfkill enabled radio.
            0|1
        /          \
0|0 -- <-HW- - 1|1
        \         /
	    1|0

This is why all vendors (including iwlwifi) that targets notebook and
friends markets need to implement independent SW HW rfkill switches
and we need 2 bits (4 states- 3 states are not  enought I've wrote
that couple of times....
Thanks
Tomas
