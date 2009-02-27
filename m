Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35112 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755460AbZB0PfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 10:35:19 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 16:35:16 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <200902271503.13308.mb@bu3sch.de>
Message-ID: <20090227153516.318880@gmx.net> (sfid-20090227_163521_723860_96E29F82)
MIME-Version: 1.0
References: <20090226234307.51520@gmx.net> <200902271503.13308.mb@bu3sch.de>
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Michael!

> Could you explain what commit is supposed to to after the channel swi=
tch?
> To me it's not clear what the difference in functionality is.
> What do you expect to happen on the commit call after the channel cha=
nge.

I think after all changes which affect the selected network a rejoin sh=
ould be done.

=46or example you have at channel 4 a AP with the SSID "test" und at ch=
annel 11 an other AP with the same SSID, too.

If you now first say set_ssid("test") and then set_channel(11), we firs=
t join the network at channel 4 and then we switch the hardware low-lev=
el to channel 11. So we hang now in channel 4 with the BSSID of the net=
work in channel 4 and nothing works anymore.

I think the order of the commands should not affect the result on the e=
nd and the driver should never hang in an broken/undefined state if it =
can be recovered.

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
