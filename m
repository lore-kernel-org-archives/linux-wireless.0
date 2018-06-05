Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42607 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbeFEKt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 06:49:58 -0400
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
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [RFT 3/6] wlcore: Add support for runtime PM
Date: Tue, 5 Jun 2018 10:49:53 +0000
Message-ID: <ee4810afed194b20bad0a6cb6fa5ba52@ti.com> (sfid-20180605_125002_286099_333CAA4C)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com> <20180531171420.GQ5705@atomide.com>
 <fe42f9d6bb744cd39e38db8f51c0b74e@ti.com> <20180605042000.GA5738@atomide.com>
 <20180605104404.GD5738@atomide.com>
In-Reply-To: <20180605104404.GD5738@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> * Tony Lindgren <tony@atomide.com> [180605 04:22]:
> > * Reizer, Eyal <eyalr@ti.com> [180603 06:07]:
> > > I have noticed the following recovery a couple of times on my setup
> when the board was
> > > just sitting for a long time with just pings
> > > It starts with a firmware recovery started from the interrupt handler=
 but
> the recovery fails
> >
> > Sounds like the recovery needs some more work :)
> >
> > > leaving the sdio stuck.
> > > At this stage the only way to get out of it is unload/load of the dri=
ver
> modules.
> > > Have you seen this on your side as well?
> >
> > Hmm I don't think I've seen this one yet.
> >
> > > 64 bytes from 192.168.100.1: seq=3D32772 ttl=3D64 time=3D9.644 ms
> > > 64 bytes from 192.168.100.1: seq=3D32773 ttl=3D64 time=3D9.572 ms
> > > 64 bytes from 192.168.100.1: seq=3D32774 ttl=3D64 time=3D10.974 ms
> > > 64 bytes from 192.168.100.1: seq=3D32775 ttl=3D64 time=3D9.618 ms
> > > [127899.040526] wlcore: ERROR SW watchdog interrupt received! startin=
g
> recovery.
> >
> > Do you know what does the SW watchdog means here? Does it mean the
> > interrupt did not get delivered to wlcore? Or a spurious IRQ to wlcore?
> > Or a timeout waiting for the ELP wake interrupt?
>=20
> Also, can you check if patch "[RFT 7/6] wlcore: Make sure firmware is
> initialized
> in wl1271_op_add_interface()" already fixes this issue if you did not hav=
e it
> already applied?
>=20
Sure will do. The firmware that showed this issue has some extra debugging =
info
Enabled in it and this may have been the cause of the recovery (Infernal lo=
gging error).
The fact that it didn't recover was the issue itself. I am now running with=
 the latest's=20
firmware 8.9.0.0.78 and will see if I can still replicate it.
If I see it, I will try applying patch 7 and see if it helps. Right now I d=
on't yet have
It applied.

Best Regard,
Eyal
