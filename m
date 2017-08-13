Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60093 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdHMNH6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Aug 2017 09:07:58 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: RE: [v6] wlcore: add missing nvs file name info for wilink8
Date: Sun, 13 Aug 2017 13:07:49 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36425195@DFRE01.ent.ti.com> (sfid-20170813_150812_683329_177BC4A0)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
 <20170809172651.GA3934@atomide.com>
 <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
 <20170809211620.GF3934@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B364233E7@DFRE01.ent.ti.com>
 <20170810172635.GO8569@atomide.com>
In-Reply-To: <20170810172635.GO8569@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > >
> > >
> > > Sure, just want to make sure we are not trying to add work around jus=
t
> for
> > > A couple of faulty devices.
> > >
> > > > > I have verified using a couple of com6 modules with an am335x-evm
> and
> > > > they had mac addresses read ok.
> > > >
> > > > Sounds like there are multiple variants of the wl12xx
> > > > available then.
> > > >
> > > I am trying to find out internally if there is a possibility that the=
re were
> > > devices
> > > Produced in the past where the internal fuses were not programmed
> with a
> > > valid
> > > Address before being assembled into the modules.
> > >
> >
> > Seems like MAC address for wilink6/7 was added to devices that were
> produced  around Q3 of 2010
> > In case you still have this omap3-evm up and can just do a quick check =
for
> me as I don't have this board, can you try using the following command:
> >
> > cat /sys/bus/platform/drivers/wl12xx_driver/wl12xx.0.auto/hw_pg_ver
> >
> > and let me know what the output you get is?
>=20
> Sure, my omap3-evm has hw_pg_ver set to 3.
>=20
Ok, you have a PG3.0 device. Mac address was added in PG3.1 so it explains
Why the mac address remains zero and not read from fuse.
Will use random mac in case it is read a zero.

Best Regards,
Eyal
