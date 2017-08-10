Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:38714 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdHJH7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 03:59:41 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: RE: [v6] wlcore: add missing nvs file name info for wilink8
Date: Thu, 10 Aug 2017 07:59:32 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36422EAC@DFRE01.ent.ti.com> (sfid-20170810_095956_851855_E538A8D0)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
        <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
        <20170809172651.GA3934@atomide.com>
        <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
        <20170809211620.GF3934@atomide.com>
        <8665E2433BC68541A24DFFCA87B70F5B36422C65@DFRE01.ent.ti.com>
 <87r2wjeugk.fsf@codeaurora.org>
In-Reply-To: <87r2wjeugk.fsf@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> >> The fact that is old does not change a thing, we still need to
> >> support it no matter what the data sheet and your system design
> >> says. A fix that breaks other things is not really a fix :)
> >>
> >
> > Sure, just want to make sure we are not trying to add work around just =
for
> > A couple of faulty devices.
> >
> >> > I have verified using a couple of com6 modules with an am335x-evm an=
d
> >> they had mac addresses read ok.
> >>
> >> Sounds like there are multiple variants of the wl12xx
> >> available then.
> >>
> > I am trying to find out internally if there is a possibility that there=
 were
> devices
> > Produced in the past where the internal fuses were not programmed with
> a valid
> > Address before being assembled into the modules.
>=20
> Just a general remark, based on my past experience, you can't really
> know what hardware is out there, no matter how someone in the company
> claims otherwise. Uncalibrated devices, prototypes and calibration data
> broken are all possible and better be preparared for that in the driver.
>=20
> It's a good idea at least to detect and print a proper error message if
> the calibration data is broken. But if the data on the device only
> consists of MAC address and nothing else, then I guess using a random
> address is fine.
>=20

Understood. I will handle the zero mac address case and use random mac inst=
aed.
Just trying to find out how common it is as it seems strange devices like t=
hat found their way to boards that we shipped to customers.

Best Regards,
Eyal
