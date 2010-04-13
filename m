Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55550 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0DMHdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 03:33:13 -0400
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout
 configuration
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne (Nokia-D/Tampere)" <janne.ylalehto@nokia.com>
In-Reply-To: <871vekpexo.fsf@purkki.valot.fi>
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271061120.3877.6.camel@jlt3.sipsolutions.net>
	 <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	 <1271063175.3877.13.camel@jlt3.sipsolutions.net>
	 <1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
	 <871vekpexo.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 10:29:06 +0300
Message-ID: <1271143746.10120.1232.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I looked into this slightly more, below some more thoughts.

On Mon, 2010-04-12 at 22:57 +0200, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> > There are triggers for reducing the timeout, other than those mentioned
> > by you above. A hand-held might for example attempt to save power based
> > on the amount of user activity on the device in general.
> 
> Yes, this makes sense. We definitely want user space to inform kernel
> about different requirements.
> 
> > That's something only user space would know about, but still is a
> > very important factor in deciding the dynamic ps timeout value.
> 
> But we do not want to tie our hands to a simple timeout value because
> that only applies to the very crude dynamic ps implementation we have
> currently. What if, next year, we have an uber cool new power save
> implementation in mac80211 which doesn't use the timeout value at all,
> what do we do with the nl80211 timeout parameter then? Deprecate it?

I agree that letting user-space configure a raw timeout is rather crude.
But in my view the problem really is that we don't have that uber-cool
power save feature of the future yet, and hence cannot fully take its
needs into account. So apparently, until we do, we have to live without
even the crude one?

Or is it better to deprecate a semi-complex interface instead of a crude
one, if even that does not meet all requirements of whats to come?

> Also please remember we have also other cfg80211 drivers than
> mac80211. Finding a common ps interface for all of them is next to
> impossible. Some of them might support ps timeout, but some of them
> will not.
> 
> > Also AFAIK currently in nl80211 there is no way go to "full power-save"
> > i.e. disable dynamic power-save, which is something user-space might
> > want to do to conserve power if the hand-held is not being used.
> 
> With a more advanced power save implementation in mac80211 we should
> be able to this automatically, for example, based on information from
> PM qos interface, amount of data transfered etc.
> 
> > Are you more hesitant on the concept of configuring the dynamic ps
> > behavior from user-space or the granularity of control here? 
> 
> For me it's the former.
> 
> > In the nl80211 interface the literal timeout value could be replaced
> > by something to indicate the level of power-saving needed, for
> > example.
> 
> Something like levels 1-5? This was proposed some time (years?) ago, I
> didn't like it then and I didn't like it now. It's just too vague.
> 
> I think power save control should happen outside nl80211. The problem
> here is that we want to inform kernel about events (or states) in user
> space (display turned off, user activity, voip call etc.). We need a
> different interface for that, nl80211 is not suitable for this. Also
> other subsystems than wireless would definitely benefit from this kind
> of information. The interface might already exist (pm qos?) or we have
> to create a new one, I haven't studied this that much.

I looked into this slightly. I can see, that the mac80211 has support
for a latency-wish from user-space, using pm_qos. This seems to affect
only the dtim-period somehow (by the way, at least the wl1251 driver has
an obvious bug about this - if the AP dtim is > 1 and user-space
configures the latency properly, you can make the wl1251 miss broadcast
traffic in PSM.)

> >> In some sense I think it would be smarter to implement a gradual
> >> powersave policy where the device first still wakes up for every
> >> beacon and only later goes down to waking up for DTIM only (which
> >> may or may not be the same ...)
> >
> > Yes, this is a good idea, although I still feel it does not alleviate
> > the need for what I tried to explain above.
> 
> The need is definitely valid, I don't deny that. It just needs to be
> implemented differently compared to what old Wireless Extensions did.
> 
> I would recommend to see if the pm qos interface can be used to hint
> mac80211 dynamic ps enough so that you would get similar end result as
> with the WE power timeout value. It should be possible, but I haven't
> checked the code myself.
> 

The problem here is that the latency at least cannot be used in any
simple and/or general way I can think of to control the dynamic PS
timeout. So we would still need to add some crude PS level stuff anyway,
unless someone comes up with that uber-cool solution of tomorrow already
today.

I see there is fierce resistance, so I'll drop looking into this here.
As far as I can see, the result of this is that anyone using linux
wireless in their hand-held devices either cannot switch to nl80211
today or have to use nl80211 and wext simultaneously.

-Juuso

