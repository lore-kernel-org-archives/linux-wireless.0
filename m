Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54650 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbeGQQuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 12:50:16 -0400
Message-ID: <1531844370.3250.12.camel@linux.intel.com> (sfid-20180717_181700_368483_60675DD2)
Subject: Re: IBSS timeouts
From: James Prestwood <james.prestwood@linux.intel.com>
To: Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Jul 2018 09:19:30 -0700
In-Reply-To: <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
         <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-17 at 09:57 +0200, Nicolas Cavallari wrote:
> On 16/07/2018 21:31, James Prestwood wrote:
> > 
> > Hello,
> > 
> > I am a developer for IWD and trying to implement IBSS networks. The
> > initial IBSS_JOIN, 4-way, and setting the keys all works and I am
> > able
> > to connect two stations. The problem is that I am hitting a timeout
> > in
> > the kernel once the connection has succeeded and there are no more
> > frames flowing between stations. I dug around in the kernel and saw
> > there is a 60 second inactivity timeout which is precicely what is
> > happening. After setting the keys 60 seconds go by and I recieve a
> > DEL_STATION (log attached).
> > 
> > My question is: is this timeout expected after the station has been
> > added and the keys are set? If so how does one reset this timeout
> > so
> > the connection can remain alive even if no data is being sent?
> > heartbeat of some kind?
> This is not normal, but it isn't your fault. It's more a problem with
> your card
> firmware/driver. What card/driver do you have ?

One side has an Intel 7260 and the other has an Atheros 9462. It seems
to only be the 7260 that is getting the DEL_STATION events after the
timeout. I haven't seen the Ath 9k behave like this.

> 
> In IBSS mode, all stations are required to send beacons. The protocol
> is a bit
> complex to arrange that, every 102.4ms, a station is chosen to emit
> the beacon.
> 
> Receiving beacons from a station is enough to reset its timer, so
> with a
> properly functioning station, this timer does not expire.
> 
> Unfortunately, in the wild, nobody test that IBSS beacons are
> generated, because
> without them, an open IBSS still appear to work...
Hmm, so how does one mitigate this? Manually sending beacons? That
would get messy if some cards do it automatically and some don't.

Something else I forgot to mention/ask in my original email was about
deauthentication. If one station does a LEAVE_IBSS, the other side
doesn't recieve a DEL_STATION until that 60 second inactivity timeout.
If we explicitly leave should the kernel send a deauth automatically? I
know wpa_supplicant explicitly sends a deauth, but I wasn't sure if
this was working around a bug or if it was the intended to be that way.

Thanks,
James
