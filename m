Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:31538 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbeEVOFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:05:30 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Date: Tue, 22 May 2018 14:05:22 +0000
Message-ID: <92eff64ea59740bfa395b53ff22c07d3@ti.com> (sfid-20180522_160534_430175_77838A73)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com> <20180521224339.GD98604@atomide.com>
 <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
 <20180522133158.GE98604@atomide.com>
 <eae7c720c09549f0b4ff83f88ad6959b@ti.com>
 <20180522135511.GI98604@atomide.com>
In-Reply-To: <20180522135511.GI98604@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >
> > > OK try replacing the pm_runtime_put_noidle() above with just
> > > pm_runtime_put_sync(). The reason why I put noidle there was the
> > > wlcore_fw_sleep() call, with that gone put_sync should do the trick.
> > >
> >
> > I have tried that already. Same problem. The last call to:
> > ret =3D wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP)
> >
> > which allows the firmware to get into ELP state during wowlan suspend i=
s
> > only completing after system resume for some unknown reason...
>=20
> Hmm maybe try also adding wl1271_power_off(wl) after put_sync()?
>=20

No, we don't want to power off the chip in wowlan mode.
We power it of only during standard suspend.

The trick is that it stays on during suspend and can be used=20
As a wakeup source to the host on specific packets received by
The firmware over the air.

BR,
Eyal
