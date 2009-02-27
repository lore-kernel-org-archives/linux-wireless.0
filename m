Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754387AbZB0JBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:44 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 10:01:40 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090227082545.291220@gmx.net>
Message-ID: <20090227090140.291190@gmx.net> (sfid-20090227_100227_500291_D5E28C8A)
MIME-Version: 1.0
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
 <20090227082545.291220@gmx.net>
Subject: Re: IBSS issues
To: "Alina Friedrichsen" <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith!

> The strange thing is after the ping from peer1 to peer2, the ping fro=
m
> peer2 to peer1 works too. The same is if I start tcpdump on peer1. Af=
ter
> stopping tcpdump it keeps working. Looking...

I found it. :)
The problem is the following code:
[drivers/net/wireless/ath9k/main.c, ath9k_configure_filter(), line 2399=
]

if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
        if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
                memcpy(sc->curbssid, ath_bcast_mac, ETH_ALEN);
                sc->curaid =3D 0;
                ath9k_hw_write_associd(sc);
        }
}

On scanning the BSSID is set to the broadcast MAC, but never set back.

Im not sure how to fix it in the cleanest way. I know to less about the=
 handling of multi interface devices. ath9k people can you help please?

Thanks
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
