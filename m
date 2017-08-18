Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pv35p12im-ztdg05031101.me.com ([17.133.186.213]:34821 "EHLO
        pv35p12im-ztdg05031101.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752311AbdHRVEY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 17:04:24 -0400
Received: from process-dkim-sign-daemon.pv35p12im-ztdg05031101.me.com by
 pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0OUW00A00FS69J00@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Fri, 18 Aug 2017 21:04:24 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by pv35p12im-ztdg05031101.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) with ESMTPSA id <0OUW00HZ2FV5DC50@pv35p12im-ztdg05031101.me.com> for
 linux-wireless@vger.kernel.org; Fri, 18 Aug 2017 21:04:21 +0000 (GMT)
From: =?utf-8?Q?H=C3=A5vard_Rabbe?= <hrabbe@me.com>
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: ath9k driver - is it possible to disable tx/rx radio chains?
Date: Fri, 18 Aug 2017 23:04:16 +0200
References: <0DB9FDCC-490C-438E-AA50-1C751565A9AE@me.com>
 <8cf52994-eda4-d88f-a236-2b74c085bf3f@neratec.com>
To: linux-wireless@vger.kernel.org
In-reply-to: <8cf52994-eda4-d88f-a236-2b74c085bf3f@neratec.com>
Message-id: <73CCFF27-AA9B-4F1C-BAAF-EA38C5CC31C2@me.com> (sfid-20170818_230430_309435_26289A16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
Thank you so much. You made my day!
The command works. Im looking forward to test it out :-)


I also have two of these card. they don=E2=80=99t have the same bitmap, =
but I assume they work the same way?

qca9882 chipset with 2 chains available using ath10k driver:
	Available Antennas: TX 0x3 RX 0x3
	Configured Antennas: TX 0x3 RX 0x3

qca9880 chipset with 3 chains available using ath10k driver:
	Available Antennas: TX 0x3 RX 0x3
	Configured Antennas: TX 0x3 RX 0x3


Best Regards,

H=C3=A5vard

> On 18 Aug 2017, at 09:00, Matthias May <matthias.may@neratec.com> =
wrote:
>=20
> On 18/08/17 01:32, H=C3=A5vard Rabbe wrote:
>> Hi
>> I=E2=80=99m using wifi card with AR9280 chipset that uses the ath9k =
driver.
>>=20
>> The card has 2 available radio chains and I=E2=80=99m only going to =
connect 1 antenna.
>>=20
>> Is it possible to disable the radio chain im not using?
>>=20
>>=20
>> Best Regards,
>>=20
>> H=C3=A5vard Rabbe
>>=20
>=20
> Help text from iw:
> phy <phyname> set antenna <bitmap> | all | <tx bitmap> <rx bitmap>
>=20
> You can set the rx/tx mask with
> iw phy phy0 set antenna 1
> to not use the second chain
>=20
> or
> iw phy phy0 set antenna 1 3
> to not use the second chain for tx, but still use it for rx.
>=20
> You can see the currently active mask with:
> iw list | grep Antenna
>=20
> Be aware that the value set here is a bitmask only allows the values =
1/3/7 (for 1, 2 and 3 chains).
> Chain 0 is always active.
> --> You can not disable chain 0 and only use chain 1.
>=20
> BR
> Matthias
