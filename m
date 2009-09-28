Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41476 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZI1H4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 03:56:35 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
Date: Mon, 28 Sep 2009 09:56:23 +0200
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
References: <200909252054.19762.rene.mayrhofer@gibraltar.at> <b6c5339f0909251352s4c30323awa588dd2f9f0d1af5@mail.gmail.com> <200909252329.01897.rene.mayrhofer@gibraltar.at>
In-Reply-To: <200909252329.01897.rene.mayrhofer@gibraltar.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909280956.23887.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [ 1698.498801] ath: EEPROM regdomain: 0x0                                                                                             
> 
> Does this indicate that the EEPROM is locked to country code
> 0x0 (whatever that is, probably US)? "iw reg" doesn't seem to
> change anything: 

Yep, that's the case.

However, "iw XXX reg set XX" should *STILL* change some things, 
so I guess that crda/regdb isn't still correctly installed. And 
you should still see something in your "dmesg" output. Hey, 
even "COUNTRY=AT crda" should change/produce something, e.g. 
check "dmesg" and "iw list".

However, I've now switched my kernel to no longer include

> [ 1686.542910] cfg80211: Using static regulatory domain info

You probably should either use CRDA ("the new way") or some 
static reg info in your kernel. I personally opted for CRDA, as 
this gives me more correct channel settings.


Regarding the wrong info in your EEPROM: check the README file 
from ath_info (svn co 
http://madwifi-project.org/svn/ath_info/trunk).

I currently have the feeling, that about 50% of all WLAN cards 
bought in Germany have a "wrong" EEPROM country. Maybe importers 
simply don't care about this.



Oh, and what I'm not yet getting: how can a wrong country setting 
lead to so much packet-loss?
