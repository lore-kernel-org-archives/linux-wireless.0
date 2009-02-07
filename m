Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60387 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753388AbZBGXfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 18:35:10 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 08 Feb 2009 00:35:07 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090207233507.67590@gmx.net> (sfid-20090208_003516_614522_FC4D4B9B)
MIME-Version: 1.0
Subject: generic ieee80211_sta_commit()?
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

after a "ip link set wlan0 down" and than "ip link set wlan0 up" the wi=
fi connection don't come up again. If you do a "iwconfig wlan0 channel =
4" beaconing in IBSS doesn't work anymore.

My thought to fix this is to add a generic ieee80211_sta_commit() funct=
ion which is called after the most config changes (e.g. SSID, BSSID, ch=
annel, interface up, ...), so that a clean rejoin is done by the functi=
on and the driver hangs not in an undefined state. And I think it's mor=
e elegant, because ieee80211_sta_set_bssid() then doesn't need to call =
ieee80211_sta_set_ssid() anymore to do the rejoin.

What do you think about it? If agree I will implement it after Johannes=
 IBSS changes are applied to avoid confusion.

Regards
Alina

--=20
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
