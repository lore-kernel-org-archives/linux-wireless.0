Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42986 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BVGwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 01:52:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 22:52:00 -0800
Date: Tue, 22 Feb 2011 12:21:58 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] ath9k: configure opmode sepecific beacon timers
 dynamically
Message-ID: <20110222065157.GA14252@vmraj-lnx.users.atheros.com>
References: <1297877604-8084-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=Kpib=BbwmTpOREinsN7mOjKEVs_Z5Fueftsm8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTi=Kpib=BbwmTpOREinsN7mOjKEVs_Z5Fueftsm8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 11:15:36PM +0530, Björn Smedman wrote:
> On Wed, Feb 16, 2011 at 6:33 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > Current ath9k code does not handle beacon timers on opmode
> > specific. One such example is that a STA beacon config overwrites
> > already configured AP vif's beacon timers during scan.
> >
> > So select a vif as primary based on opmode and configure that
> > vif's bss and beacon config in hw and update the primary vif
> > on opmode change, interface up/down and bss info change.
> >
> > And also while moving back to single STA vif from multi STA vifs,
> > power save is enabled and hw has to be reconfigured with proper
> > beacon and bssid. Otherwise connection poll will be triggered
> > so frequently due to beacon loss.
> 
> It's really nice to see multi-vif beacons get some attention, thanks. :)

Thanks.
> Just one thought: Is the "opmode" concept really necessary? It's been
> discussed previously and I think the conclusion is often that it would
> be better to iterate all the current vifs and do something logical
> based on that instead of setting an "opmode".
>
Yes. currently opmode is set based on vif iteration and the changes were
merged under "ath9k: Fix up hardware mode and beacons with multiple vifs".
And beacon config is filled by doing vif iteration againgt matching opmode.

--
Rajkumar
> Do you think it would be possible to remove the "opmode" construct
> from your patch? Do you think it would be an improvement?
>
> Björn Smedman
