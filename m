Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018AbZB0K4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 05:56:41 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 11:56:34 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <18855.48369.413479.945570@gargle.gargle.HOWL>
Message-ID: <20090227105634.291200@gmx.net> (sfid-20090227_115644_204612_B4322B47)
MIME-Version: 1.0
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>
	<18855.43002.100899.931613@gargle.gargle.HOWL>
	<20090227095312.291210@gmx.net> <18855.48369.413479.945570@gargle.gargle.HOWL>
Subject: Re: IBSS issues
To: Sujith <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> Yes, the TBTT is calculated only once after joining the BSS network.

What about the following, which is called after scanning?
ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);

This calls indirectly the function which looks in the template for the =
TSF.

> Am not sure I understand the proposal. What would the tsf value in
> set_tsf() be ?
> 11.1.4 (IEEE802.11-2007) says that the TSF has to be reset to zero on
> joining
> an IBSS network. We do that correctly.

In the praxis setting the TSF should not a problem as log the value is =
not higher then the original TSF from the other node. As long the clock=
s are working correct and the other node is not moved with nearly light=
-speed this shouldn't happen. ;)

> To calculate the next TBTT, we
> can't use the
> HW TSF, since it has just been reset. And the Beacon's timestamp + in=
tval
> + FUDGE
> is what we do in ath9k to get the TBTT for this peer, which I think i=
s
> correct.
> A sniffer shows the beacon generation being evenly distributed.

I think the TSF timer keep this value more up-to-date than a static var=
iable in RAM, so that e.g. the speed of the CPU has a lower effect on t=
he de-sync of this value.

Regards
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
