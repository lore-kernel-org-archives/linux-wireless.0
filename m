Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60440 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbeEVNsm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:48:42 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "Shahar Patury" <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Date: Tue, 22 May 2018 13:48:33 +0000
Message-ID: <eae7c720c09549f0b4ff83f88ad6959b@ti.com> (sfid-20180522_154846_426978_5C72D793)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com> <20180521224339.GD98604@atomide.com>
 <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
 <20180522133158.GE98604@atomide.com>
In-Reply-To: <20180522133158.GE98604@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> * Reizer, Eyal <eyalr@ti.com> [180522 13:28]:
> > Actually the below patch removing the call to wlcore_fw_sleep() avoids =
this
> error.
> > The downside is that the wl8 firmware remains fully active during supen=
d, so
> we
> > Would need to find the root cause why the last call allowing the wilink=
8
> firmware
> > To go into ELP mode during suspend is only completing on resume and not
> during
> > Suspend enter.
> >
> > diff --git a/drivers/net/wireless/ti/wlcore/main.c
> > b/drivers/net/wireless/ti/wlcore/main.c
> > index 4c297aa..8df1ae6 100644
> > --- a/drivers/net/wireless/ti/wlcore/main.c
> > +++ b/drivers/net/wireless/ti/wlcore/main.c
> > @@ -1789,7 +1789,6 @@ static int wl1271_op_suspend(struct
> ieee80211_hw *hw,
> >                 goto out_sleep;
> >
> >  out_sleep:
> > -       pm_runtime_put_noidle(wl->dev);
> >         mutex_unlock(&wl->mutex);
> >
> >         if (ret < 0) {
> > @@ -1821,15 +1820,7 @@ static int wl1271_op_suspend(struct
> ieee80211_hw *hw,
> >          */
> >         cancel_delayed_work(&wl->tx_watchdog_work);
> >
> > -       /*
> > -        * Use an immediate call for allowing the firmware to go into p=
ower
> > -        * save during suspend.
> > -        * Using a workque for this last write was only hapenning on re=
sume
> > -        * leaving the firmware with power save disabled during suspend=
,
> > -        * while consuming full power during wowlan suspend.
> > -        */
> > -       wlcore_fw_sleep(wl);
> > -
> > +       pm_runtime_put_noidle(wl->dev);
> >         return 0;
> >  }
>=20
> OK try replacing the pm_runtime_put_noidle() above with just
> pm_runtime_put_sync(). The reason why I put noidle there was the
> wlcore_fw_sleep() call, with that gone put_sync should do the trick.
>=20

I have tried that already. Same problem. The last call to:
ret =3D wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP)

which allows the firmware to get into ELP state during wowlan suspend is=20
only completing after system resume for some unknown reason...

Best Regards,
Eyal
