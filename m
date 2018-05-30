Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45350 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753604AbeE3VoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 17:44:15 -0400
Date: Wed, 30 May 2018 14:44:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Eyal Reizer <eyalreizer@gmail.com>
Subject: Re: [RFT 6/6] wlcore: Use generic runtime pm calls   for wowlan elp
 configuration
Message-ID: <20180530214411.GI5705@atomide.com> (sfid-20180530_234419_972393_03E5846B)
References: <63ad2f07fac941b88408352f6ddbce50@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <63ad2f07fac941b88408352f6ddbce50@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180530 06:37]:
> > > >
> > > > With runtime PM enabled, we can now use generic calls to
> > > > pm_generic_runtime_suspend and pm_generic_runtime_resume for
> > enabling elp
> > > > during suspend when wowlan is enabled and waking the chip from elp
> > > > on resume.
> > >
> > > Sry, but not sure you can :(
> > >
> > > These functions are not used by drivers directly because system suspend
> > > are not synchronized with PM runtime, so if you call
> > pm_generic_runtime_suspend()
> > > and, at the same time, there is pm_runtime_get_() in progress --> race ...
> > >
> > > The pm_runtime_force_() APIs have to be used, or
> > > PM runtime drivers functions can be called directly, but only if it possible to
> > be
> > > sure no other PM runtime calls active which is usually true at
> > suspend_noirq stage.
> > 
> > Oh right, those are subsystem calls. Seems like
> > pm_runtime_force_suspend/resume() should work here,
> > Eyal?
> > 
> 
> Oh, nice, wasn't aware of the pm_runtime_force_() calls.
> For some reason they are not documented in:
> https://www.kernel.org/doc/Documentation/power/runtime_pm.txt
> Perhaps they should be?

Sure why not submit a patch for that.

> Anyway I have tried them instead of pm_generic_runtime_() and they seem
> To work fine on my platform.
> Will test some more and submit a v2.

OK I'll your pick v2 into my series.

Regards,

Tony
