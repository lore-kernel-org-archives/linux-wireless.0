Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34610 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1ASBnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 20:43:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 17:43:32 -0800
Date: Tue, 18 Jan 2011 17:43:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	"pstew@google.com" <pstew@google.com>
Subject: Re: [PATCH 1/5] ath9k: warn when we get a ATH9K_INT_TIM_TIMER and
 are idle
Message-ID: <20110119014348.GK8082@tux>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-2-git-send-email-lrodriguez@atheros.com>
 <4D363FBA.3000207@candelatech.com>
 <AANLkTi=cWF0UrHG2DXoYp1NLP6F179A6pQ3P-tLFBNTg@mail.gmail.com>
 <4D36417C.4080000@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D36417C.4080000@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 05:42:20PM -0800, Ben Greear wrote:
> On 01/18/2011 05:38 PM, Luis R. Rodriguez wrote:
> > On Tue, Jan 18, 2011 at 5:34 PM, Ben Greear<greearb@candelatech.com>  wrote:
> >> On 12/06/2010 06:48 PM, Luis R. Rodriguez wrote:
> >>>
> >>> We should not be idle when we get the ATH9K_INT_TIM_TIMER,
> >>> otherwise we wake up the chip and that throws off the idle
> >>> state, the driver needs to be in full sleep when idle and
> >>> nothing should turn it awake without turning it back to
> >>> full sleep again. If we leave the chip idle and suspend,
> >>> upon resume the device will become unusable and we get:
> >>>
> >>> ath: Starting driver with initial channel: 5745 MHz
> >>> ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef&    0x00000003 !=
> >>> 0x00000000
> >>>
> >>> Cc: Paul Stewart<pstew@google.com>
> >>> Cc: Amod Bodas<amod.bodas@atheros.com>
> >>> signed-off-by: Luis R. Rodriguez<lrodriguez@atheros.com>
> >>> ---
> >>>   drivers/net/wireless/ath/ath9k/main.c |    1 +
> >>>   1 files changed, 1 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> >>> b/drivers/net/wireless/ath/ath9k/main.c
> >>> index f026a03..fd27ec9 100644
> >>> --- a/drivers/net/wireless/ath/ath9k/main.c
> >>> +++ b/drivers/net/wireless/ath/ath9k/main.c
> >>> @@ -770,6 +770,7 @@ irqreturn_t ath_isr(int irq, void *dev)
> >>>                 if (status&    ATH9K_INT_TIM_TIMER) {
> >>>                         /* Clear RxAbort bit so that we can
> >>>                          * receive frames */
> >>> +                       WARN_ON(sc->ps_idle);
> >>>                         ath9k_setpower(sc, ATH9K_PM_AWAKE);
> >>>                         ath9k_hw_setrxabort(sc->sc_ah, 0);
> >>>                         sc->ps_flags |= PS_WAIT_FOR_BEACON;
> >>
> >> Looks like this patch never made it in.
> >>
> >> Should it be in, or should I just drop it from my queue?
> >>
> >
> > Eh, it shouldn't happen and if we warn we should use the new debugging
> > warn once thingy you added. I never saw that trigger so probably we
> > can just ignore it.
> 
> I've been running this patch for months and haven't noticed the
> WARN_ON hit, so probably it's not needed.  Of course, I disable
> power-saving..so maybe I'm not a good test case :P

Which is why its OK if this goes in with the debug message thingy
only.

  Luis
