Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:59338 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbYDUJOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 05:14:44 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Jns6k-0005SV-QC
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:14:42 +0100
Message-ID: <480C5AFF.5020005@fenrir.org.uk> (sfid-20080421_101455_395583_495A4EE6)
Date: Mon, 21 Apr 2008 10:14:39 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
References: <fuhkfp$mnk$1@ger.gmane.org>
In-Reply-To: <fuhkfp$mnk$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas B=E4chler wrote:
> Using iwl3945 from compat-wireless, I can not use all the channels I=20
> should be allowed to use. In particular, I cannot see some 802.11a=20
> networks which I could see with ipw3945. Here is what I get:
>=20
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
>=20
> But:
>=20
> # ./iw dev wlan0 info
> Band 1:
> 	Frequencies:
> 		* 2412 MHz
> 		* 2417 MHz
> 		* 2422 MHz
> 		* 2427 MHz
> 		* 2432 MHz
> 		* 2437 MHz
> 		* 2442 MHz
> 		* 2447 MHz
> 		* 2452 MHz
> 		* 2457 MHz
> 		* 2462 MHz
> 		* 2467 MHz (disabled, passive scanning, no IBSS)
> 		* 2472 MHz (disabled, passive scanning, no IBSS)
> 	Bitrates:
> 		* 1.0 Mbps
> 		* 2.0 Mbps (short preamble supported)
> 		* 5.5 Mbps (short preamble supported)
> 		* 11.0 Mbps (short preamble supported)
> 		* 6.0 Mbps
> 		* 9.0 Mbps
> 		* 12.0 Mbps
> 		* 18.0 Mbps
> 		* 24.0 Mbps
> 		* 36.0 Mbps
> 		* 48.0 Mbps
> 		* 54.0 Mbps
> Band 2:
> 	Frequencies:
> 		* 5170 MHz (disabled, passive scanning, no IBSS)
> 		* 5180 MHz
> 		* 5190 MHz (disabled, passive scanning, no IBSS)
> 		* 5200 MHz
> 		* 5210 MHz (disabled, passive scanning, no IBSS)
> 		* 5220 MHz
> 		* 5230 MHz (disabled, passive scanning, no IBSS)
> 		* 5240 MHz
> 		* 5260 MHz (passive scanning, no IBSS, radar detection)
> 		* 5280 MHz (passive scanning, no IBSS, radar detection)
> 		* 5300 MHz (passive scanning, no IBSS, radar detection)
> 		* 5320 MHz (passive scanning, no IBSS, radar detection)
> 		* 5500 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5520 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5540 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5560 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5580 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5600 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5620 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5640 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5660 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5680 MHz (disabled, passive scanning, no IBSS, radar detection)
> 		* 5700 MHz (disabled, passive scanning, no IBSS, radar detection)
> 	Bitrates:
> 		* 6.0 Mbps
> 		* 9.0 Mbps
> 		* 12.0 Mbps
> 		* 18.0 Mbps
> 		* 24.0 Mbps
> 		* 36.0 Mbps
> 		* 48.0 Mbps
> 		* 54.0 Mbps
>=20
> Most of the 802.11a channels are disabled, as are channel 12 and 13 i=
n=20
> the 802.11g band (I am sure those 11g channels should be enabled).

If you're in the EU, I contributed a fix that has not yet made it into=20
the iwlwifi code as it is under review (the whole regulatory aspect is=20
difficult, there are so many caveats!).

Temporarily I'd suggest that you add:

options cfg80211 ieee80211_regdom=3D"JP"

into your /etc/modprobe.conf as it will enable the 2.4GHz channel 12 an=
d=20
13 for you, I'm not sure that the 802.11a channels will be correct, but=
=20
it's better than it was.

Eventually this should become:

options cfg80211 ieee80211_regdom=3D"EU"

once things are correctly defined again. But it may take a little while=
=2E=20
I need to check what's in 2.6.25 before I think about tweaking my patch=
,=20
but it will depend on John Linville as to whether it goes in to the=20
mainline kernel.

All a bit tricky!

A look here would be useful as a starting point:

http://en.wikipedia.org/wiki/List_of_WLAN_channels

but be aware there is a lot of legislation that affects the available=20
frequencies and it's not easy to get an overview of what is and isn't=20
allowed.

--=20

Brian

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
