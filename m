Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13601 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYIQWWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:22:43 -0400
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: Ineya Ineya <ineya@post.sk>, "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Sep 2008 15:22:22 -0700
Subject: RE: Re: iwlagn/iwl4965 problems with WEP and rmmod
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B153D0DFD@orsmsx501.amr.corp.intel.com> (sfid-20080918_002256_751244_D5D38F14)
References: <48D15A97.000001.07931@kamasutra>
In-Reply-To: <48D15A97.000001.07931@kamasutra>
Content-Type: text/plain; charset=iso-8859-2
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
=46rom: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-own=
er@vger.kernel.org] On Behalf Of Ineya Ineya
Sent: Wednesday, September 17, 2008 12:29 PM
To: Zhu, Yi; ineya@post.sk; linux-wireless@vger.kernel.org
Subject: Re: Re: iwlagn/iwl4965 problems with WEP and rmmod

So I tested more versions of compat-wireless-old and found 2 things:

i used same kernel - debian etchnhalf - 2.6.24-etchnhalf.1-amd64 #1 SMP



1.

packages:

compat-wireless-old-2008-09-04

compat-wireless-old-2008-09-05

compat-wireless-old-2008-09-10

compat-wireless-old-2008-09-12

compat-wireless-old-2008-09-13

compat-wireless-old-2008-09-14



allow me to associate with my router and authenticate via WEP, I made r=
eboot between trying each of those (mainly because rmmod causes my kern=
el to crash: http://i34.tinypic.com/6gwj01.jpg)



in each try I inserted built modules: cfg80211, mac80211, iwlcore and i=
wl4965



using packages:

compat-wireless-old-2008-09-15

compat-wireless-old-2008-09-16



with these packages I can\'t associate with my router, and I get messag=
e:

wlan0: association with AP 00:19:5b:e0:f3:20 timed out



procedure is the same, except that module iwl4965 is now called iwlagn,=
 and I have to manually add iwl4965.o to iwlagn in makefile in iwlwifi =
directory



I tried to make a diff between version 2008-09-14 and 2008-09-15, which=
 I hoped would be small, but the number of changes is huge. which makes=
 it hard to locate possible bug/change, which is causing this.



2:

I also found, that monitor mode seems to cause some troubles. After fre=
sh reboot drivers work fine and association is OK, but if I switch off =
wlan0, change mode to monitor, switch on card, play a bit (tcpdump, air=
odump-ng) and then again, switch off, set mode to managed, switch on an=
d try to connect to my router then association works, but I\'m not able=
 to get any IP and dhcpclient fails on timeout.



***************
Check out this patch for this.
http://www.intellinuxwireless.org/bugzilla/attachment.cgi?id=3D1564

Modified patch will be included in the next mac80211



***************




----- Origin=E1lna Spr=E1va -----

Od: Zhu Yi

Komu: Ineya Ineya

Poslan=E1: 17.09.2008 03:46

Predmet: Re: iwlagn/iwl4965 problems with WEP and rmmod



> On Tue, 2008-09-16 at 22:32 +0200, Ineya Ineya wrote:

> > I\\\'m using Debian Etc: 2.6.24-etchnhalf.1-amd64 #1 SMP kernel,

> >

> > and I downloaded compat-wireless-old-2008-09-15.tar.bz2 and

>

> Wonder if it is compat-wireless related. Do you have the problem in

> wireless-testing kernel or vanilla?

>

> Thanks,

> -yi

>

>


__________
http://cestovanie.sme.sk/ - Cel=FD svet na va=B9om monitore


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
