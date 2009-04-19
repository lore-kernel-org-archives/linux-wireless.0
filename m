Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59266 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZDSRuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:50:03 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Marcel Holtmann <marcel@holtmann.org>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090419173354.158790@gmx.net>
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net>
	 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
	 <20090419161316.158790@gmx.net>
	 (sfid-20090419_181324_681308_BAEAE072) <1240158381.917.21.camel@johannes.local>
	 <20090419165443.158820@gmx.net>
	 (sfid-20090419_185516_519795_36D34B9B) <1240160241.28138.4.camel@johannes.local>
	 <20090419173354.158790@gmx.net>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 19:49:51 +0200
Message-Id: <1240163391.11795.59.camel@violet> (sfid-20090419_195008_020670_B93A1099)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alina,

> > I still haven't understood why those extra commands are bothering you so
> > much.
> 
> I want a simple generic API. I don't want to need the old wext for it.
> 
> This would be stupid for me:
> iwconfig wlan0 essid test_essid
> vs.
> iw dev wlan0 assoc test_essid
> iw dev wlan0 join_ibss test_essid
> iw dev wlan0 set meshid test_essid
> 
> On the last I get MS-DOS feeling.

you argue command line tools against kernel exposed API. Both have
nothing to do with each other on that level. If you don't like the iw
syntax then fix it and provide a command that does all three task for
you. No need to mess with the kernel interface for that.

Also the argument that WEXT does it doesn't fly with anybody here since
WEXT are clearly broken and not something we wanna ever copy again. If
cfg80211/nl80211 has to use a different API, then it will do that.

Regards

Marcel


