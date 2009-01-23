Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47078 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750855AbZAWFkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:40:55 -0500
Cc: linux-wireless@vger.kernel.org, maximlevitsky@gmail.com,
	kalle.valo@iki.fi, samuel@sortiz.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 23 Jan 2009 06:40:53 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <3ace41890901222117q55040043lfcab89fc928422ed@mail.gmail.com>
Message-ID: <20090123054053.270710@gmx.net> (sfid-20090123_064059_430881_32EF9607)
MIME-Version: 1.0
References: <4979269F.1060500@lwfinger.net>
 <3ace41890901222117q55040043lfcab89fc928422ed@mail.gmail.com>
Subject: Re: Regression caused by commit
 e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
To: Hin-Tak Leung <hintak.leung@gmail.com>, Larry.Finger@lwfinger.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> I don't want to do a "me too", but my rtl8187B broke yesterday after
> upgrading to wireless-testing/compat-wireless head,
> and it worked again today. There are only two patches between
> yesterday and today and one of them is John's revert, so it is
> possible that the rtl8187B is also affected.
>=20
> The symptom is as you said, I can associate and authenticate, but dhc=
p
> won't finish and wpa_suplicant ifdown the device.
> I tried that a few times and restarting NM, modprobe -r/-v, etc. In
> the end it was easier just to blow away the compat-wireless update
> redirectory and revert back to the vendor-shipped kernel modules - an=
d
> hope that it is just a transient problem and the problem would go awa=
y
> when I git fetch next time :-).

I unfortunately can't reproduce the problem with my b43 und my other ca=
rds work fine, too. But I think the problem is that the NetworkManager =
does the following: (And causes with it some low level drivers and wifi=
 cards into trouble.)

[99554.112921] wlan0: Set SSID
[99554.113853] wlan0: Set BSSID
[99554.113861] wlan0: Set SSID
[99554.115084] wlan0: Set BSSID
[99554.115091] wlan0: Set SSID

Have you test it manual with the NetworkManager disabled?

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
