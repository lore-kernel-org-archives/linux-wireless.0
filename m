Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48299 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753900AbZAQDj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 22:39:57 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 17 Jan 2009 04:39:55 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090110091659.GC1170@jm.kir.nu>
Message-ID: <20090117033955.273880@gmx.net> (sfid-20090117_044004_278188_4AF6213D)
MIME-Version: 1.0
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu>
 <20090109205315.277310@gmx.net> <20090110091659.GC1170@jm.kir.nu>
Subject: Re: [PATCH] Fixed BSSID (timesync)
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking now for a better implementation for the IBSS fixed BSSID st=
uff, that handles the TSF sync correctly. I think now having centralize=
d IBSS join function ist more easy to maintain, as many little function=
s. This function can look in the environment for the current state, so =
that it can see what to do for the current join.

So I have moved all my fixed BSSID stuff in this centralized function, =
so that the TSF will be reseted, even if a fixed BSSID is set.

I will allow a channel change too, if you have a fixed BSSID but not a =
fixed channel setting. If there is a other IBSS network with the same B=
SSID but in an other channel.
Like now a BSSID change is allowed, if you set a fixed channel but not =
a fixed BSSID.
I think this would be a more clean and consistent implementation.

What do you think about it?
I will post a beta patch tomorrow.

Regards
Alina

--=20
Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
