Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33722 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753073AbZBMVn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:43:57 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 13 Feb 2009 22:43:54 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1234559990.4219.27.camel@johannes.local>
Message-ID: <20090213214354.67600@gmx.net> (sfid-20090213_224400_664598_BCB4BE70)
MIME-Version: 1.0
References: <1234396421.16004.67.camel@johannes.local>	
 <20090213203641.199830@gmx.net> (sfid-20090213_213711_951136_CAB188EF)
 <1234559990.4219.27.camel@johannes.local>
Subject: Re: [PATCH] mac80211: split IBSS/managed code
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> > * In IBSS beaconing doesn't work.
>=20
> Odd, I'm sure that worked for me. What hw are you using?

I have tested it with ath5k and atk9k. Without this patch (tag: master-=
2009-02-12) beaconing works fine. Have you test it with a passive scann=
er like kismet?

> > * If you create a new IBSS network it
> >   scans for other networks to often
> >   3 times a second.
>
> That might've happened here too, but given that I never used ibss
> usually I didn't realise it was wrong ;)

This is to fast consecutively, so it scans and scans but it is not list=
ening on the working channel.

> > * If you join an existent IBSS it does
> >   the following strange things:
>
> That does look a little strange,

The STA information is expired much to fast. This is all the same STA/N=
ode in an endless loop.

> even if you disregard the fact that
> you're using compat without %pM :)

Why is a strange pointer used to display a MAC address, why not %x:%x:%=
x:%x:%x:%x? (?)

> I'll take a look at it and fix it up.

Thanks!

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
