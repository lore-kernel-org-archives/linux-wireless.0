Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:35022 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752330AbdHJGgu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 02:36:50 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: RE: [v6] wlcore: add missing nvs file name info for wilink8
Date: Thu, 10 Aug 2017 06:35:46 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com> (sfid-20170810_083717_303573_653EC5FE)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
 <20170809172651.GA3934@atomide.com>
 <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
 <20170809211620.GF3934@atomide.com>
In-Reply-To: <20170809211620.GF3934@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > Sorry for top posting (mobile...)
> > I have verified with system design and the data sheet that every wilink=
 6/7
> chip has a mac address in fuse so probably the board you have (pretty old=
,
> right?) has this mac address in fuse. Maybe it was from very early batche=
s?
> Anyway I see no reason to change it.
> > Anyway the calibrator can be used to store a different one into the nvs=
 file
> that will overide it.
>=20
> Well clearly at least this one does not have any valid hardware
> mac address, the hardware mac address is broken with all zeroes.
>=20

Looks like it is not really all zeros but rather 00:00:00:00:00:01.=20
I wonder if it is just a one board issue or not...

> It seems that you can easily add a check for empty mac address, no?
> And you already showed a version that falls back to a random mac
> address.
>=20

Of course I can add a check for this but need to make sure it=20
is not just one private case.
Do you happen to have another omap3-evm and can check if this is a typical =
case
For the wilink modules that were assembled on this EVM?
I have not seen another module here that showed this issue and want to make=
=20
Sure it is really a common issue before adding additional checks to the ker=
nel.

> The fact that is old does not change a thing, we still need to
> support it no matter what the data sheet and your system design
> says. A fix that breaks other things is not really a fix :)
>=20

Sure, just want to make sure we are not trying to add work around just for
A couple of faulty devices.

> > I have verified using a couple of com6 modules with an am335x-evm and
> they had mac addresses read ok.
>=20
> Sounds like there are multiple variants of the wl12xx
> available then.
>=20
I am trying to find out internally if there is a possibility that there wer=
e devices
Produced in the past where the internal fuses were not programmed with a va=
lid=20
Address before being assembled into the modules.

Best Regards,
Eyal
