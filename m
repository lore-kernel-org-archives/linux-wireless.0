Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:2026 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYI0LeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 07:34:21 -0400
Received: by ug-out-1314.google.com with SMTP id k3so73933ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 04:34:19 -0700 (PDT)
To: "Tomas Winkler" <tomasw@gmail.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Date: Sat, 27 Sep 2008 13:34:14 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com, hmh@hmh.eng.br,
	linux-wireless@vger.kernel.org
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com> <200809271012.33908.IvDoorn@gmail.com> <1ba2fa240809270408i1eab50f7lb48739d75deab676@mail.gmail.com>
In-Reply-To: <1ba2fa240809270408i1eab50f7lb48739d75deab676@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809271334.15190.IvDoorn@gmail.com> (sfid-20080927_133439_085894_65ABDB0B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 September 2008, Tomas Winkler wrote:
> On Sat, Sep 27, 2008 at 11:12 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > On Saturday 27 September 2008, Tomas Winkler wrote:
> >> >> > That's definitely other option we wanted to suggest that mac80211
> >> >> > would register itself to rfkill subsystem and will provide to driver
> >> >> > appropriate callbacks.  The question is how  drivers vary in the rfkil
> >> >> > implementation and whether it wouldn't be more complex, in that case
> >> >> > the notification is quite clean solution.
> >> >>
> >> >> How complex does it have to be?
> >>
> >> > Not really, probably it only needs to be a wrapper around rfkill_force_state
> >> > where we can use the RFKILL_ defines to indicate the BLOCKED status.
> >>
> >> Implementation wise it's more complicated since you have to teach each
> >> driver under mac80211, this mean more
> >> code and more bugs but I'm not sure this is the objective on this list
> >> :) As opposite to just notifying mac about a rfkill
> >> event so it's not trying to configure to access device, etc.
> >
> > Those driver that do generate RFKILL events already have the rfkill structure
> > implemented, so for those drivers they only have to remvoe that code and just
> > call the mac80211 rfkill handler when the RFKILL key is pressed.
> > All other drivers which don't have a rfkill button don't have to do anything because
> > mac80211 handles everything for them.
> 
> Each driver has to implement the low level of rfkill. I'm not sure how
> mac80211 could handle it.

What low level of rfkill? You mean the rfkill_force_state call?
I already said that can be done through a wrapper function provided by mac80211,
the driver just calls it when the RFKILL key was pressed.

For the remainder of the rfkill implementation in mac80211, all mac80211 needs to
do is _listen_ to toggle_radio() callback function and acts upon that request.

> >> >> > > That means that the only change needed in ieee80211_ioctl_siwtxpower() is
> >> >> > > only allowing the enabling of the radio when RFKILL is not set to BLOCKED.
> >> >> >
> >> >> > That's just complicates everything and moving the policy  decisions to
> >> >> > the driver after all even
> >> >> > form txpower off you implement it as soft rfkill.
> >> >
> >> > Why does it complicate things? It means that mac80211 doesn't use
> >> > rfkill_force_state() when the user triggers a radio state change using
> >> > iw/iwconfig/ifconfig or whatever userspace tool.
> >>
> >> I'm not sure I understand your intention, how do you plane to kill
> >> radio then in this case, you are still to obliged to do so.
> >
> > Correct, and you can still do that using the approach how it is currently implemented
> > in mac80211. Calling config() with the disable_radio field set.
> 
> This is wrong approach you are pushing more policy into driver.

What policy? With rfkill implemented in mac80211, the driver needs to no _nothing_
about rfkill. All it does is listen to mac80211 to enable/disable the radio. Which is something
it should be doing already.
Furthermore, drivers who have implemented a rfkill structure already could remove it and
just use the wrapper function I mentioned earlier to inform mac80211 about the RFKILL event
(coming from the actual HW key/button/slider!) and mac80211 can forward the request to
rfkill. (Unless of course you want to make the rfkills structure visible to the driver, which
probably isn't a good idea). 

> > I am just saying that userspace commands like:
> >        ifconfig wlan0 up
> >        iwconfig wlan0 txpower on
> > are not RFKILL events which are handled by the rfkill layer. Those are userspace commands
> > which can simply be handled by mac80211. The rfkill layer is there to support events
> > when a user presses the RFKILL button/key/slider on the device or laptop.
> 
> wlan0 up is not rfkill event but txpower on/off definitely provide
> rfkill line as defiend in Henriques doc  and has affect on rfkill
> state separating them just creates more confusion.

I repeat: rfkill is only a layer to provide support for HARDWARE rfkill events, aka pressing
a button/key/slider on the HARDWARE. It is not a notification system which is triggered for
userspace events.

rfkill is intended to act correctly when the user presses the RFKILL key on its hardware, it generates
an event and a userspace agent can act upon it by (for example) shutting down all radios because
pressing the RFKILL key means the hardware has entered a region where no wireless devices are allowed.

If you start generating events for userspace commands like "iwconfig wlan0 txpower off" then you
can get userspace agents that decide to disable wlan1, wlan2, off as well.

> This is trying to create two APIs for the same thing both paths just
> results into software rfkill  and this just pushes arbitration too low
> into the driver. Driver should be just notified if to kill or arise
> from death the radio

Yes, and so it receives that command. I am not seeing the problem.

> > See the discussion between Henrique and me
> >        "[RFC] b43: A patch for control of the radio LED using rfkill"
> > from last week.

You can find the thread here:
	http://marc.info/?l=linux-wireless&m=122171448920267&w=2
it is the entire discussion between me and Henrique about this issue.

> >> > mac80211 doesn't generate rfkill events because it isn't tied to any device
> >> > keys/buttons/sliders. That is what the drivers do. And they should only listen
> >> > to that key/button/slider.
> >>
> >> writing 0 to sysfs file is not a button either it sill should soft
> >> kill the radio.
> >
> > Well that feature was requested by others to create simple RFKILL event listeners
> > in userspace to toggle the radio through the rfkill interface. Since using that interface
> > you can simply toggle the radio state for all devices of the same type.
> >
> 
> >> The sw switch is here to enable
> >> killing and enabling radio from software. All the buttons stuff should
> >> go under hard switches.
> >
> > Where is it documented that the RFKILL_STATE_SOFT_BLOCKED is for events from software?
> 
> It's definitely affected if I call radio.disabled through mac->config

Again, RFKILL layer is intended to provide support for the _HARDWARE_ generated events.

> > RFKILL_STATE_HARD_BLOCKED was called into life for non-overridable RFKILL states, not
> > to allow for software states to be handled in rfkill.
> >
> 
> > The rfkill layer is not the global radio state handler for any wireless device, it is the radio
> > state handler for RFKILL events coming from actually pressing RFKILL keys on hardware.
> 
> I cannot say I like this definition, again it creates opening for too
> many APIs doing the same thing.

RFKILL generates events for HW key/button/slider events, and forwards that event to userspace.
How many API's are doing that?

> >> > So all that has to be done is:
> >> >        * rfkill BLOCK event received in mac80211
> >> >        * set flag to indicate the BLOCKED state
> >> >        * disable radio
> >>
> >> In case of notification chain you don't disable radio from mac80211
> >>
> >> >        * prevent radio being enabled through ifup
> >> >        * prevent radio being enabled through iwconfig txpower on
> >> >
> >> >        * rfkill UNBLOCK event received from mac80211
> >> >        * clear flag to indicate UNBLOCKED state
> >> >        * restore radio to the by iwconfig/ifup configured state
> >> Same here.
> >> Tomas
> >
> > All the more reason then to use the rfkill structure directly instead of
> > using the notification system.
> 
> You contradict your self. If rfkill subsystem is to handle just button
> events  why it doesn't just handle the rfill state notifications

You mean why rfkill doesn't directly turn events into toggle_radio() events?
Because that would be policy in the kernel, and those things should be done
in userspace.

Ivo
