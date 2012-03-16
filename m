Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36939 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031294Ab2CPUpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 16:45:51 -0400
Date: Fri, 16 Mar 2012 13:45:47 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
CC: <linux-wireless@vger.kernel.org>, <henry@logout.com>
Subject: Re: [ath9k] mesh powersave hardware sleep + wakeup
Message-ID: <20120316204547.GG18861@tux> (sfid-20120316_214555_754189_E1EF61D6)
References: <4F630AEA.10703@etit.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F630AEA.10703@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 16, 2012 at 10:42:02AM +0100, Marco Porsch wrote:
> Hi,
> 
> I am trying to implement the IEEE 802.11s power save schemes in mac80211.
> In 11s it is defined that power save STA doze AND send beacons AND
> wake up periodically for multiple neighbors beacons.
> 
> Is this actually possible with current hardware/drivers (especially ath9k)?
> 
> Regards
> Marco Porsch
> 
> 
> 
> PS: More details:
> 
> We currently have power mode indication and state
> tracking and are working on powersave frame buffering and mesh
> synchronization.
> 
> A next topic will be to put the hardware to sleep to actually save energy.
> Until now we only implemented in mac82011. I looked through mac80211 and
> ath9k and am unsure, how to actually manage sleep and wakeup in the mesh
> context.
> Maybe I should give a brief introduction to IEEE 802.11s powersave here:
> - Each node has to send its own beacon
> - Power mode is not global, but link-specific
> - 3 power modes: active, light sleep, deep sleep
>   - active = always on
>   - light sleep = wake up for the neighbors beacon
>   - deep sleep = only wake up for sending own beacon
> 
> So the critical point here is, that we need to put the hardware to
> sleep but wake up for:
> - sending own beacon
> - TBTT of all neighbors towards we are in light sleep (or maybe all
> neighbors as proof-of-concept)
> so it is a mixture of ad-hoc , station code and completely new stuff.
> 
> A better explanation and a nice example of IEEE 802.11s powersave is
> given here:
> http://dl.dropbox.com/u/31741282/11s_powersave.pdf

I don't have time to review this but it sounds correct that the part
you want to focus on is introducing a wake up mechanism when you
need to initiate radiation for your own beacons. I think right now
we simply disable PS in mac80211 completely if we have a mode of
operation that require beconing. Your challenge is to lift that and
deal with the issues there and all the possible combinations. You
can help with this

This should help you:

http://wireless.kernel.org/en/users/Documentation/Power-consumption

For now you can focus on only allowing through Mesh devices and
the combinations of it but I suspect that some of the work you do
may also help with addressing P2P powersave.

  Luis
