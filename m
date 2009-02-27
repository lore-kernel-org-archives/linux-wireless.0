Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39988 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754739AbZB0JxQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 04:53:16 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 10:53:12 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <18855.43002.100899.931613@gargle.gargle.HOWL>
Message-ID: <20090227095312.291210@gmx.net> (sfid-20090227_105319_660044_8A3DC54F)
MIME-Version: 1.0
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net> <18855.43002.100899.931613@gargle.gargle.HOWL>
Subject: Re: IBSS issues
To: Sujith <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith!

> When peer2 joins the cell, the next TBTT is calculated based on the
> received beacon's
> timestamp. And since the TSF is reset in __ieee80211_sta_join_ibss(),=
 to
> program
> the TBTT timers, the timestamp is needed.

But is it calculated only one time after the join? The TSF value in the=
 template is really fast outdated. I think why not let __ieee80211_sta_=
join_ibss() call the set_tsf() callback, so that the TSF is mostly sync=
ed from the beginning on and fine-tuned later by the hardware?

Note: set_tsf() callback is currently broken for newer chipsets. I had =
posted a patch, but this was forgotten to apply. But I can repost it, i=
n the hope that it will be applied now.

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
