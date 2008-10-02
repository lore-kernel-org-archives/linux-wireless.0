Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65528 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYJCCeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 22:34:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 19:34:11 -0700
Date: Thu, 2 Oct 2008 12:33:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Regulatory Framework & rt2x00.
Message-ID: <20081002193357.GP5960@tesla> (sfid-20081003_043416_831943_53B1B792)
References: <48E52D07.8050900@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48E52D07.8050900@kpnplanet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 01:20:23PM -0700, Gertjan van Wingerde wrote:
> Hi Luis,
> 
> I'm working on making rt2x00 use the regulatory framework to report its
> EEPROM region settings to mac80211, 

Excellent! Glad to see someone pick this work up for Ralink!

> and I have stumbled upon an issue
> that I don't really know how to solve with the current regulatory
> framework code.
>
> The problem I'm facing is that many of the Ralink devices have 2 region
> settings in their EEPROM, one for 802.11a networks, and one for
> 802.11[bgn] networks. So far I have only seen devices where these two
> settings contain the same region indication, but I don't know whether
> this is the case for all devices.

Actually as per the documenation I have the EEPROM *should not* be
relied on for proper regulatory compliance on some Ralink devices.
The windows registry is used so for these I'd recommend to rely on
db.txt and help enhance it further. Not sure if the documentation
for *all* devices says this though so we'll have to find out.

I'll send you the documentation I have in private.

Anyway Atheros devices also use a per band EEPROM value, I don't follow
the issue (should you really want to follow the EEPROM, please check the
documentation I will send you).

> At this point in time I use the regulatory_hint function at driver
> start-up time to communicate the region setting that matches the
> configured band, but that would (probably) not hold up when the user
> reconfigures the mode.

It does if you really want it to by using the reg_notifier() callback
you can register. We plan on eventually using this on ath9k for example
to respect the EEPROM values to come up with the intersection of the
regulatory domain the user set and what the EEPROM has. I had sent
an intersection patch a while ago under RFC for 802.11d. The
intersection routine is not yet merged.

> So, at this point in time I have the following questions:
> 1. How would I be able to communicate both these settings to the
> regulatory framework?

I think I answered them, please let me know if you need further
information.

> 2. Should I re-use regulator_hint whenever the configured band changes?

Nope, never.

> 3. Would a driver supplied region override a user configured setting
> (via iw/crda)?

Only if a callback is provided, reg_notifier() or if you register
*always* only the channels in that regulatory domain. I wouldn't
recommend this last strategy, but instead to use the first. The nice
thing with the first approach is you get to eventually support
world roaming then. You accomplish this by *not* allowing new regulatory
changes if the initiator was REGDOM_SET_BY_USER but consider them
to be applicable if your device has the
dot11MultiDomainCapabilityEnabled flag enabled, which by the 802.11
standard should be assumed to false *and* if the initiator was
REGDOM_SET_BY_COUNTRY_IE, which indicates the new regulatory_hint()
came from processing a 802.11d country IE; heck you can even check
the alpha2 here and decide if you device is world-roaming capable
in this country too. In fact to world roam since the IEEE-802.11
Country IE is crap (it really lacks a lot of information to really
be regulatory compliant IMO) we will need to do the intersection
of the built regulatory domain from the recieved Country IE and
what we have in our db.txt -- our db.txt has other information
such as DFS flags (note if your stack supports DFS for all modes
then DFS flags are useless as you are compliant to DFS always) and
max channel bandwidth limitations. If you want to be even more
conservative you can then take the intersection of this new intersected
regulatory domain and what you define based on your intelligence on
your EEPROM. What you end up is perhaps the most compliant regulatory
solution for world roaming available :)

> I would appreciate your help in solving this issue.

I hope this helps,

  Luis
