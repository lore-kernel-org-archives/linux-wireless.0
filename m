Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39428 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754997AbZHCMgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 08:36:44 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 03 Aug 2009 14:36:42 +0200
From: "Joerg Albert" <jal2@gmx.de>
In-Reply-To: <1249289274.4561.0.camel@johannes.local>
Message-ID: <20090803123642.242160@gmx.net>
MIME-Version: 1.0
References: <4A759341.1090006@gmx.de>  <4A7612F8.80802@gmx.de>	
 <1249289084.2007.54.camel@johannes.local>
 <1249289274.4561.0.camel@johannes.local>
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On Mon, 2009-08-03 at 10:44 +0200, Johannes Berg wrote:
> 
> > > >     ifconfig wlan1 down
> > > >     iwconfig wlan1 mode managed essid huhu
> > > >     ifconfig wlan1 up
> > > >     ifconfig wlan1 down
> > > >     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
> 
> > No, it's a bug in cfg80211 :)
> 
> But it's not making sense to me. I'll have to try to reproduce it. In
> any case, we shouldn't be calling in to mac80211 from cfg80211 while the
> interface is down.

I guess this is caused by the call to __cfg80211_leave_ibss()
in  net/wireless/ibss.c::cfg80211_ibss_wext_siwfreq() trying to
disable the beacon via net/mac80211::ieee80211_ibss_leave().
-- 
Neu: GMX Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02
