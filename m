Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:65044 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964942AbeE3GfE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 02:35:04 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
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
Date: Wed, 30 May 2018 06:34:56 +0000
Message-ID: <63ad2f07fac941b88408352f6ddbce50@ti.com> (sfid-20180530_083549_407860_50F16717)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >
> > > With runtime PM enabled, we can now use generic calls to
> > > pm_generic_runtime_suspend and pm_generic_runtime_resume for
> enabling elp
> > > during suspend when wowlan is enabled and waking the chip from elp
> > > on resume.
> >
> > Sry, but not sure you can :(
> >
> > These functions are not used by drivers directly because system suspend
> > are not synchronized with PM runtime, so if you call
> pm_generic_runtime_suspend()
> > and, at the same time, there is pm_runtime_get_() in progress --> race =
...
> >
> > The pm_runtime_force_() APIs have to be used, or
> > PM runtime drivers functions can be called directly, but only if it pos=
sible to
> be
> > sure no other PM runtime calls active which is usually true at
> suspend_noirq stage.
>=20
> Oh right, those are subsystem calls. Seems like
> pm_runtime_force_suspend/resume() should work here,
> Eyal?
>=20

Oh, nice, wasn't aware of the pm_runtime_force_() calls.
For some reason they are not documented in:
https://www.kernel.org/doc/Documentation/power/runtime_pm.txt
Perhaps they should be?

Anyway I have tried them instead of pm_generic_runtime_() and they seem
To work fine on my platform.
Will test some more and submit a v2.

Best Regards,
Eyal
