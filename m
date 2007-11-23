Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14392 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXKWIoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 03:44:11 -0500
Received: from lin01.mn-solutions.de (pD95F8443.dip0.t-ipconnect.de [217.95.132.67])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 7AD295E5A87
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 09:44:08 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 313E21E00FD
	for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 09:41:14 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Fri, 23 Nov 2007 09:44:40 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711221719.40412.hs4233@mail.mn-solutions.de> <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com>
In-Reply-To: <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711230944.40222.hs4233@mail.mn-solutions.de> (sfid-20071123_084415_359674_DF0AEBFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also, are you sure you understand completely what is going on?

That Debian was not able to set the script might really be a 
different problem.

> As far as I can see, the Debian wireless-tools ifup script
> (package version 29-1) *is* setting the key before it sets the
> essid. In fact, setting the ssid and key both happen in a
> pre-up script, which is run before the interface is even
> brought up.

Yes, Debian /etc/network/if-pre-up.d/wireless-tools first sets 
all stuff up, then calls iwconfig essid, and only then brings 
the interface up.

So you're right, the "doesn't associate" problem is not Debian's 
fault (I actually never suspected Debian to be faulty, it worked 
flawless all the time and I haven't changed anything there).

Now I disabled Debians startup scripts and did the thing 
manually. And voila, it doesn't work when done manually.


As it stands, I now have two sequences that doesn't associate 
with mac80211/b43:


Debian's sequence:

$ pccardctl insert
$ iwconfig eth1 key:11111
$ iwconfig eth1 essid MUMBLEFUTZ
$ ifconfig eth1 up

My older sequence:

$ pccardctl insert
$ ifconfig eth1 up
$ iwconfig eth1 essid MUMBLEFUTZ
$ iwconfig eth1 key:11111




Litte side note: with the first sequence, after about a minute 
the driver scans and associates anyway:

10:27:50.846680   eth1     Set Encryption key:****-****-**
10:27:55.440949   eth1     Set ESSID:"MUMBLEFUTZ"
10:29:06.047881   eth1     Scan request completed
10:29:06.064521   eth1     Custom driver 
event:ASSOCINFO(ReqIEs=...)
10:29:06.064550   eth1     New Access Point/Cell 
address:00:13:19:80:DA:30

While I find the timeout of a minute way too high (especially for 
a moving environment, e.g. storage warehouse), it's better than 
nothing.

The second sequence doesn't associate at all, not even after five 
minutes.


Again, both (!) sequences work with several non-mac80211-drivers 
that I used in production during the last 5 years. And I'm still 
inclined to call this a regression: things that used to work 
stopped working.
