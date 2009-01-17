Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33406 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756094AbZAQWM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 17:12:27 -0500
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 17 Jan 2009 23:12:25 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090108091055.GA7009@jm.kir.nu>
Message-ID: <20090117221225.301920@gmx.net> (sfid-20090117_231232_652841_83CF39F2)
MIME-Version: 1.0
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu>
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni!

> I agree that merge part (updating Beacon/ProbeRsp data) can be skippe=
d
> for same BSSID, but this change seems to break timesync by removing c=
all
> to local->ops->reset_tsf(). I don't think that that should be removed
> unconditionally.

I have looked in the Source of ath5k and ath9k. It seens to me that the=
 TSF sync is done in the low-level driver and/or the hardware directly.=
 So I see no reason to set it back to zero, if you have a dummy merge t=
o the same BSSID and channel. (E.g. caused by TSF overflows.) I think i=
t should only done if you change the network, so BSSID and/or channel i=
s deferent.

Any doubts?

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
