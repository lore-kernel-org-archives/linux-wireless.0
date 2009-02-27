Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51359 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754879AbZB0VnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:43:19 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 22:43:17 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1235768725.7426.83.camel@johannes.local>
Message-ID: <20090227214317.254870@gmx.net> (sfid-20090227_224322_694535_8164DDEF)
MIME-Version: 1.0
References: <20090227184314.42290@gmx.net>	
 (sfid-20090227_194348_299848_A96EDA18)
 <1235768725.7426.83.camel@johannes.local>
Subject: Re: [PATCH] mac80211: Replacement for: Implement commit in	wireless
 extensions
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> I don't really see a need for that, it's only called in what, two
> places? And it makes things interdependent.

One centralized function is in
every case easier to maintain.
=46or example if you add mesh mode to it.

> At _least_ put it into a
> more appropriate file like wext.c

This function is config interface independent,
so wext.c is not the right place for it.

> and open-code it in cfg.c

This would be a better place for it
if it should be added to
mac80211_config_ops. If not I think
main.c is the best place for it.

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
