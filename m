Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60325 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab0DLU5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 16:57:09 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne \(Nokia-D\/Tampere\)" <janne.ylalehto@nokia.com>
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout configuration
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271061120.3877.6.camel@jlt3.sipsolutions.net>
	<1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	<1271063175.3877.13.camel@jlt3.sipsolutions.net>
	<1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 12 Apr 2010 23:57:07 +0300
In-Reply-To: <1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com> (Juuso Oikarinen's message of "Mon\, 12 Apr 2010 12\:45\:35 +0300")
Message-ID: <871vekpexo.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> There are triggers for reducing the timeout, other than those mentioned
> by you above. A hand-held might for example attempt to save power based
> on the amount of user activity on the device in general.

Yes, this makes sense. We definitely want user space to inform kernel
about different requirements.

> That's something only user space would know about, but still is a
> very important factor in deciding the dynamic ps timeout value.

But we do not want to tie our hands to a simple timeout value because
that only applies to the very crude dynamic ps implementation we have
currently. What if, next year, we have an uber cool new power save
implementation in mac80211 which doesn't use the timeout value at all,
what do we do with the nl80211 timeout parameter then? Deprecate it?

Also please remember we have also other cfg80211 drivers than
mac80211. Finding a common ps interface for all of them is next to
impossible. Some of them might support ps timeout, but some of them
will not.

> Also AFAIK currently in nl80211 there is no way go to "full power-save"
> i.e. disable dynamic power-save, which is something user-space might
> want to do to conserve power if the hand-held is not being used.

With a more advanced power save implementation in mac80211 we should
be able to this automatically, for example, based on information from
PM qos interface, amount of data transfered etc.

> Are you more hesitant on the concept of configuring the dynamic ps
> behavior from user-space or the granularity of control here? 

For me it's the former.

> In the nl80211 interface the literal timeout value could be replaced
> by something to indicate the level of power-saving needed, for
> example.

Something like levels 1-5? This was proposed some time (years?) ago, I
didn't like it then and I didn't like it now. It's just too vague.

I think power save control should happen outside nl80211. The problem
here is that we want to inform kernel about events (or states) in user
space (display turned off, user activity, voip call etc.). We need a
different interface for that, nl80211 is not suitable for this. Also
other subsystems than wireless would definitely benefit from this kind
of information. The interface might already exist (pm qos?) or we have
to create a new one, I haven't studied this that much.

>> In some sense I think it would be smarter to implement a gradual
>> powersave policy where the device first still wakes up for every
>> beacon and only later goes down to waking up for DTIM only (which
>> may or may not be the same ...)
>
> Yes, this is a good idea, although I still feel it does not alleviate
> the need for what I tried to explain above.

The need is definitely valid, I don't deny that. It just needs to be
implemented differently compared to what old Wireless Extensions did.

I would recommend to see if the pm qos interface can be used to hint
mac80211 dynamic ps enough so that you would get similar end result as
with the WE power timeout value. It should be possible, but I haven't
checked the code myself.

-- 
Kalle Valo
