Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYIQUbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 16:31:24 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Adam =?ISO-8859-1?Q?C=E9cile?= "(Le_Vert)" <gandalf@le-vert.net>,
	Jochen Friedrich <jochen@scram.de>,
	linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>
In-Reply-To: <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com> (sfid-20080917_221957_497607_0A215EEE)
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net> <1221650286.9262.57.camel@johannes.berg>
	 <69e28c910809171319r30d763cse24744a198e41f92@mail.gmail.com>
	 (sfid-20080917_221957_497607_0A215EEE)
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Sep 2008 22:31:07 +0200
Message-Id: <1221683467.7412.6.camel@localhost> (sfid-20080917_223129_167408_A4459858)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-17 at 22:19 +0200, Stefanik G=C3=A1bor wrote:

> So, the actual command used, for example, is:
> iw dev wlan0 interface add mon0 type monitor

that seems fine.

> Similarly, the code used for removing interfaces is
> IW_ERROR=3D`iw dev "$iface" interface del 2>&1 | grep "nl80211 not fo=
und"`
> If I interpret your mail correctly, then this should be changed to:
> IW_ERROR=3D`iw dev "$iface" del 2>&1 | grep "nl80211 not found"`

I don't know why you insist on that grep, it should exit with a non-zer=
o
status code.... but you can use both forms, I added the invisible alias=
=2E

> Will the same syntax change be made for the add feature? I mean this:
> iw dev wlan0 add mon0 type monitor

No. What are you adding?

> Also, the following syntax would be even better:
> iw --add mon0 --dev=3Dwlan0 --type=3Dmonitor
> or:
> iw -dwlan0 -tmonitor add mon0
>=20
> Or at least allowing stuff like this:
> iw type monitor add mon0 dev wlan0

No. All of those are gross and not very object oriented.

> An experimental branch of aircrack-ng contains a slightly different
> version, which also has these additional changes:
> -Mesh support has been removed (as I couldn't get it compile with
> -Wall -Werror, which is a requirement for inclusion into aircrack-ng)

That's an extremely stupid requirement as warnings may pop up on variou=
s
platforms which you cannot anticipate, making it hard for users.


Anyway, you're free to fork it and do whatever you like that aircrack-n=
g
needs, but please don't call it iw and don't encourage debian to ship i=
t
as 'iw'.

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
