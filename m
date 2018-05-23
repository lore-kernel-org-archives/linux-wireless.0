Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44174 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932649AbeEWRC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 13:02:56 -0400
Date: Wed, 23 May 2018 10:02:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180523170252.GN98604@atomide.com> (sfid-20180523_190311_669920_DFB31977)
References: <a5eb26fc5db445f2a6473df1306da735@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a5eb26fc5db445f2a6473df1306da735@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180523 12:45]:
> > 
> > >
> > > Here's a modified version of your patch, does that put wlcore to
> > > idle with wowlan during suspend for you?
> > >
> > 
> > Still no joy.
> > It suspends/resumes ok but leaves the firmware disabled from entering ELP.
> 
> Spent some time on it today and looks like adding calls to pm_generic_runtime_suspend ()
> And pm_generic_runtime_resume is helping and all seems to work well.

Oh right yeah you got it, I totally forgot about those.

> See the modified version of your patch below.
> Let me know what you think.

Looks good to me, one comment below..

> -    wlcore_fw_sleep(wl);
> +    spin_lock_irqsave(&wl->wl_lock, flags);
> +    set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
> +    spin_unlock_irqrestore(&wl->wl_lock, flags);
> +
> +    pm_generic_runtime_suspend(wl->dev);
> 
>      return 0;

Maybe just return pm_generic_runtime_suspend(wl->dev)
here?

> @@ -1845,6 +1816,8 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
>               wl->wow_enabled);
>      WARN_ON(!wl->wow_enabled);
> 
> +    pm_generic_runtime_resume(wl->dev);
> +

And add error handling to pm_generic_runtime_resume(wl->dev)
here?

Then if you can please post your patch with proper Signed-off-by
I'll add it to my set and repost v3 of all the patches :)

Regards,

Tony
