Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59499 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3LRLLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 06:11:47 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: Re: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
Date: Wed, 18 Dec 2013 12:11:43 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <CADnKcVie-gqXMNS-c+ObtFrwuN3RYJVaPsnPc9=DuPxBKiPaaA@mail.gmail.com>
In-Reply-To: <CADnKcVie-gqXMNS-c+ObtFrwuN3RYJVaPsnPc9=DuPxBKiPaaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312181211.44024.sw@simonwunderlich.de> (sfid-20131218_121153_827602_5D6E97EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Marek,

> On 17 December 2013 15:44, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> > Sorry for answering after so many revisions, but ... why do you think
> > this is required? Many APs first do a CAC on all available channels, but
> > then pick one channel and use that, while being able to switch to
> > another channel immediately.
> > 
> > WIth this patch (if I understand that correctly), this is not possible
> > anymore. Why do you think it is required? I can not find this requirement
> > in ETSI, at least.
> > 
> > To quote from ETSI 301.893:
> > 
> > Once the RLAN has started operations on an Available Channel, then that
> > channel becomes an Operating Channel. During normal operation, the master
> > device shall monitor all Operating Channels (In-Service Monitoring) to
> > ensure that there is no radar operating within these channel(s). If no
> > radar was detected on an Operating Channel but the RLAN stops operating
> > on that channel, then the channel becomes an Available Channel.
> > 
> > I think this patch is wrong and should not be applied.
> > 
> > Thanks,
> > 
> >     Simon
> 
> I also have doubts when reading this specification:
> 
> ETSI 301.893 v1.7.0:
> 
> "A master device shall only start operations on Available Channels. At
> installation (or reinstallation) of the equipment, the RLAN is assumed
> to have no Available Channels within the band 5 250 MHz to 5 350 MHz
> and/or 5 470 MHz to 5 725 MHz. In such a case, before starting
> operations on one or more of these channels, the master device shall
> perform either a Channel Availability Check or an Off-Channel CAC to
> ensure that there are no radars operating on any selected channel. If
> no radar has been detected, the channel(s) becomes an Available
> Channel(s) and remains as such until a radar signal is detected during
> the In-Service Monitoring. The Channel Availability Check or the
> Off-Channel CAC may be performed over a wider bandwidth such that all
> channels within the tested bandwidth become Available Channels."
> 
> First thing: how to interpret words installation and reinstallation?
> If we include stating hostapd in installation process then we should
> have no available channels when starting hostapd.

Hm, I'd interpret installation/reinstallion as "setting a device at its 
installation position and power it on", at least more than "starting some 
software on the AP". The former might even interpreted as that the available 
channel list can be kept during reboots.

I agree that this clause is a bit vague, but having an empty list when 
starting hostap is certainly the strictest interpretation over a variety of 
others.

> 
> Second thing: How to interpret this sentence: "If no radar has been
> detected, the channel(s) becomes an Available Channel(s) and remains
> as such until a radar signal is detected during the In-Service
> Monitoring."
> As I understand this sentence channel can be available as long as
> radar detection works, so called In-Service Monitoring. When in
> service monitoring is off then channel can not be available. Of course
> this is my interpretation. 

We only need in-service monitoring/radar detection as long as we use the 
channel. If we don't use the channel, we are not forced to do in-service 
monitoring. And if we don't have in-service monitoring, the sentence makes no 
statement (from a logic point of view, the premise is missing).

Using the channel and not having in-service monitoring is a bug and not a case 
we should consider.

> So if there are APs than can monitor one
> channel after switch to new channel then I agree that both channels
> can be available. In hostapd when last AP interface is stopped then it
> is no longer monitoring current channel, so starting AP after some
> time can not happened without CAC. 

ETSI does not require a timeout of available channels in v1.7.1. There was a 
timeout of 24 hours for available channels until v.1.4.1, but it was scratched 
in v.1.5.1.

What you say that an AP may not be started after some time on an available 
channel without CAC is nowhere required in the ETSI specification. It is just 
an assumption you make (please prove me otherwise if I'm wrong). There is no 
timeout anymore, and the spec clearly states that a channel should return to 
available channel after transmissions are stopped (4.7.1.3/master devices/(c), 
this is what i quoted originally). So we should be able to re-use the channel, 
even after long time.

> Simple case: we have our AP on
> mobile device, it was stopped in one place where was no radars and
> after moving to new place we start AP again. But this new place is in
> radar range. So we should start beaconig or start CAC first?

Actually that is an interesting case, but I think the spec (thankfully) does 
not consider mobile devices at all. I think this is also a corner case, not 
the main case.

I know a few access points (e.g. the big Cisco outdoor APs) which scan all 
channels on boot (which takes ~10-~15 minutes) before starting to operate. 
When they detect a radar they immediately switch to another channel.

A free software implementation may just do the same, even using another 
program than hostap to clear all channels using CAC and then starting hostap 
(hostap does not implement that clear all channels right now, but it's just a 
few lines iw patch to implement). I don't think that channels should change 
state when any of these userspace applications terminates. :)

Cheers,
    Simon
