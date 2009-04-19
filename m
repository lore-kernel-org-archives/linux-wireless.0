Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56504 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758080AbZDSPxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 11:53:22 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 17:53:19 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240154704.898.18.camel@johannes.local>
Message-ID: <20090419155319.158810@gmx.net> (sfid-20090419_175326_972960_2D11561D)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240097845.25826.1.camel@johannes.local>	 <20090419125212.158800@gmx.net>	
 (sfid-20090419_145246_566920_BF082D12)
 <1240147050.25826.5.camel@johannes.local>	 <20090419133544.158820@gmx.net>	
 (sfid-20090419_153615_967882_D1A9F951)
 <1240148519.898.3.camel@johannes.local>	 <20090419140523.158830@gmx.net>	
 (sfid-20090419_160555_446977_A429511B)
 <1240150277.898.7.camel@johannes.local>	 <20090419151629.158790@gmx.net>
 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> It will pass in a cfg80211_bss structure instead of all those paramet=
ers
> once we move all the stuff into cfg80211.

This is not mode specific.

All members of cfg80211_bss are not known by the user-space without sca=
nning. I don't like the idea of needing the wpa_supplicant for joining =
an unencrypted network.

I want even with nl80211 able to simply call:
iw dev wlan0 assoc test_ssid
like I now call:
iwconfig wlan0 essid test_ssid

> True. But I'm not much interested in technical arguments about this
> point since I and others are convinced that this way is better.

Maybe it's easier to design and implement but not necessarily the clean=
er and more thought-out API, I think.

Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
