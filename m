Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44410 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965042AbeEXNVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 09:21:35 -0400
Date: Thu, 24 May 2018 06:21:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Eyal Reizer <eyalreizer@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] wlcore: use generic runtime pm calls for
 wowlan elp configuration
Message-ID: <20180524132132.GZ98604@atomide.com> (sfid-20180524_152158_731783_D02496BE)
References: <1527146337-17562-1-git-send-email-eyalr@ti.com>
 <87fu2hiilx.fsf@codeaurora.org>
 <06f0b1b5243a4ab7befad7b9109bf5a5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <06f0b1b5243a4ab7befad7b9109bf5a5@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180524 08:20]:
> > 
> > > With runtime PM enabled, we can now use generic calls to
> > > pm_generic_runtime_suspend and pm_generic_runtime_resume for
> > enabling elp
> > > during suspend when wowlan is enabled and waking the chip from elp
> > > on resume.
> > > remove the custom API that was used to ensure that the command
> > > that is used to allow ELP during suspend is completed before the system
> > > suspend.
> > >
> > > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> > > ---
> > > Dependent on the Runtime PM support for wlcore patch set that was
> > submitted
> > > by Tony Lindgren <tony@atomide.com>
> > 
> > Ok, I'll drop this from my queue. Please resubmit once Tony's patches
> > are ready to apply (or Tony can include this patch in his patchset).
> > 
> > BTW, for me it would be a lot easier if you could mark patches like this
> > as RFT (Request For Test) or RFC (Request For Comments). That way I can
> > automatically drop the patch without sending any emails.

Sorry for the noise, what seemed like a trivial change to use generic
runtime PM exposed few unexpected issues :) I'll do one more revision
of all the patches with RFT. Then when we are happy with that series,
I'll do one more patch to enable runtime PM autosuspend support to
avoid enabling and disabing the hardware constantly. And then after
that we should have the patches finally ready for merging.

Regards,

Tony
