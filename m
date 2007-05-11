Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-58.dex002.intermedia.net ([64.78.21.227]:29758 "EHLO
	dhost002-58.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbXEKPlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 11:41:52 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Fri, 11 May 2007 08:42:03 -0700
To: Andy Green <andy@warmcat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070511154203.GD16929@devicescape.com>
References: <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz> <46437DC8.2060805@linux.intel.com> <20070510212355.6c13cde8@griffin.suse.cz> <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com> <20070511001212.GB6971@tuxdriver.com> <464424A7.2040301@warmcat.com> <20070511142355.GB16929@devicescape.com> <464485FE.1020603@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464485FE.1020603@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2007 at 04:04:30PM +0100, Andy Green wrote:

> Could I possibly be talking about this?

> http://marc.info/?l=linux-wireless&m=117882282325836&w=2
> 
> You understand re-reading this that when he talks about "You submit one
> Tx request to the [']hardware['] and it then performs all the retries,
> fallbacks, etc without host interaction over overhead." this is stuff in
> the closed-source firmware?  Aka "binary blob" with restrictive license?

So? I don't see what this has to do with mac80211 rate control algorithm
selection. This is about 802.11 functionality that has very strict
timing requirements (SIFS between frame and ack and then re-try if no
ack received). That is (I would say, has to, in most cases) be done
somewhere else than on the host CPU. In other words, this is something
that really needs to be in the wlan hardware or firmware.

> Is it really true this is a feature of hardware and not closed-source
> firmware?  Because if I was designing such a thing - and I have designed
> similarly complex silicon - damnned if I would allocate pure hardware to
> it.  Since the device already has a concept of firmware, as we can all
> see, I would instead implement these multistage actions with the
> firmware.  Which happens to be closed source by Intel's choice.

I do not know ipw3945 design, but I do know other wlan chipsets that do
indeed take care of TX rate control between retries of the _same frame_
in hardware. No firmware involved there. Then again, I really do not
follow this logic of firmware being some horrible thing that simply
cannot be allowed to do anything. In this particular case, this really
has to be done at the wlan chip, not at the host CPU due to timing
requirements.

> AIUI the proposal is to tag packets with lists of rates to retry at.
> But if the aimed-for and typical case is that you get through on the
> first try, how interesting is it really to migrate the retry action to a
> closed-source and per-vendor (or per-device) implementation instead of
> coming through the rate selection action in the stack.

Being able to vary the TX rate on the SIFS-retries can produce huge
improvements to rate adaption. I see this a very much valid reason for
providing an alternative rate control algorithm that can take advantage
of the hardware/firmware features.

> Stack == mac80211.  No: what James is talking about, as I quoted above,
> is a firmware implementation of "per-packet rate-list automatic retry"
> that requires special support in mac80211.

I can only say that we see this quite differently and all I've seen from
James so far on this topic makes sense and should be supported in
mac80211. Firmware implementation does _not_ replace the mac80211 rate
control algorithm, but modified mac80211 rate control algorithm can be
used to improve rate adaption in this case and such modifications would
not benefit (or be possible) with some other wlan chipsets. Thus, need
for multiple mac80211 rate control algorithms and benefit from drivers
being able to propose which one to use by default.

> Let me ask: is it really so impossible to create a generic "nearly
> optimal" algorithm for rate selection in the stack that you have to
> offload the task to $DRIVER?  What is it about the awesome software
> running in $DRIVER or $DEVICE that can do a better job than mac80211
> ever can?

Yes, in practice, it is more or loess impossible with the timing
requirements on 802.11 retries. This is not about driver vs. mac80211,
this is about the timing differences between wlan chip vs. host CPU. I
don't want to implement all rate control stuff in hardware/firmware, but
the part that involves first couple of retransmission of frames that are
not acked within SIFS really falls for the wlan hardware (including
firmware, if used in the design) category, not host CPU, if aiming for
the best possible rate control.

-- 
Jouni Malinen                                            PGP id EFC895FA
