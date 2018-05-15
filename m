Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42128 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752453AbeEOQZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 12:25:50 -0400
Date: Tue, 15 May 2018 09:25:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] wlcore: Add support runtime PM
Message-ID: <20180515162546.GO98604@atomide.com> (sfid-20180515_182601_931848_B421561B)
References: <20180515161315.1997-1-tony@atomide.com>
 <20180515161315.1997-3-tony@atomide.com>
 <CAOf5uwkT4Vg1kQn5k=_z9XjXOLWbA0vioqH6KSdikZbCwyaYbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOf5uwkT4Vg1kQn5k=_z9XjXOLWbA0vioqH6KSdikZbCwyaYbA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Michael Nazzareno Trimarchi <michael@amarulasolutions.com> [180515 16:19]:
> On Tue, May 15, 2018 at 6:13 PM, Tony Lindgren <tony@atomide.com> wrote:
> > @@ -315,15 +319,17 @@ static ssize_t dynamic_fw_traces_write(struct file *file,
> >         if (unlikely(wl->state != WLCORE_STATE_ON))
> >                 goto out;
> >
> > -       ret = wl1271_ps_elp_wakeup(wl);
> > -       if (ret < 0)
> > +       ret = pm_runtime_get_sync(wl->dev);
> > +       if (ret < 0) {
> > +               pm_runtime_put_noidle(wl->dev);
> >                 goto out;
> > +       }
> >
> 
> Can you just change ps_elp_wakeup with
>        ret = pm_runtime_get_sync(wl->dev);
>        if (ret < 0) {
>                pm_runtime_put_noidle(wl->dev);
>                  goto out;
>        }
> 
> >         ret = wl18xx_acx_dynamic_fw_traces(wl);
> >         if (ret < 0)
> >                 count = ret;
> >
> > -       wl1271_ps_elp_sleep(wl);
> > +       pm_runtime_put(wl->dev);
> 
> and elp_sleep with this one

That's what I started with, but they really behave in a different way. And
there is no usage count. It's really best to just get rid of the custom PM
calls in favor of generic calls. That's because then we have much better
control for future changes in the driver with pm_runtime_use_autosuspend()
and pm_runtime_put_sync() for example.

Regards,

Tony
