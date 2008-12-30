Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752396AbYL3VU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 16:20:26 -0500
Cc: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 30 Dec 2008 22:20:24 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20081230165609.GA6324@jm.kir.nu>
Message-ID: <20081230212024.208070@gmx.net> (sfid-20081230_222031_321325_D48E3534)
MIME-Version: 1.0
References: <20081230025651.6500@gmx.net> <20081230113714.GA31451@jm.kir.nu>
 <20081230161539.184750@gmx.net> <20081230165609.GA6324@jm.kir.nu>
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni!

> But it _does_ break interoperability with standard compliant IBSS
> implementations if the forced BSSID means that the STA does not merge
> with another part of the IBSS when this should happen by the STA
> changing its BSSID to match with the other part.

But in the practice this is not a bug, it's an optional feature and you=
 can mix nodes with fixed BSSID and nodes without, so that the backbone=
 nodes (routers) force the rather client nodes (e.g. notebooks) to use =
this BSSID, so that the mesh network don't break into many pieces. That=
 was happen many times before we use a fixed BSSID.

You don't need to use it, if you don't want it, but we must use it, or =
it will not work.

> Agreed, but we should not claim that the behavior with hardcoded BSSI=
D
> would be standard IBSS.

It's a little modified IBSS, that allow you to build bigger networks. N=
ot a huge change, that is completely incompatible with the standard.

> It is something different and we should not
> confuse users by calling it the same. I would have nothing against
> this type of optional feature if it were called something else than I=
BSS
> (or "adhoc" which iwconfig uses for IBSS).

I can call it Moonchild [0], if you want. ;)
I don't care on the name of it.

> If that fix is separate from the change that introduces hardcoding of
> the BSSID, it would be better to bring that in as a separate patch.

I don't introduce setting of a fixed BSSID with this patch, I only fix =
some bugs of the current implementation.

Regards
Alina

[0] The Neverending Story
--=20
Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
