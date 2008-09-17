Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from otrok.post.sk ([85.248.69.172]:50351 "EHLO otrok.post.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYIQTXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 15:23:21 -0400
Message-ID: <48D15A97.000001.07931@kamasutra> (sfid-20080917_212326_402654_2D39E382)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-2
From: Ineya Ineya <ineya@post.sk>
To: <yi.zhu@intel.com>, <ineya@post.sk>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Re: iwlagn/iwl4965 problems with WEP and rmmod
Date: 17 Sep 2008 21:29:27 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I tested more versions of compat-wireless-old and found 2 things:=0D
i used same kernel - debian etchnhalf - 2.6.24-etchnhalf.1-amd64 #1 SMP=
=0D
=0D
1.=0D
packages:=0D
compat-wireless-old-2008-09-04=0D
compat-wireless-old-2008-09-05=0D
compat-wireless-old-2008-09-10=0D
compat-wireless-old-2008-09-12=0D
compat-wireless-old-2008-09-13=0D
compat-wireless-old-2008-09-14=0D
=0D
allow me to associate with my router and authenticate via WEP, I made r=
eboot between trying each of those (mainly because rmmod causes my kern=
el to crash: http://i34.tinypic.com/6gwj01.jpg)=0D
=0D
in each try I inserted built modules: cfg80211, mac80211, iwlcore and i=
wl4965=0D
=0D
using packages:=0D
compat-wireless-old-2008-09-15=0D
compat-wireless-old-2008-09-16=0D
=0D
with these packages I can\'t associate with my router, and I get messag=
e:=0D
wlan0: association with AP 00:19:5b:e0:f3:20 timed out=0D
=0D
procedure is the same, except that module iwl4965 is now called iwlagn,=
 and I have to manually add iwl4965.o to iwlagn in makefile in iwlwifi =
directory=0D
=0D
I tried to make a diff between version 2008-09-14 and 2008-09-15, which=
 I hoped would be small, but the number of changes is huge. which makes=
 it hard to locate possible bug/change, which is causing this.=0D
=0D
2:=0D
I also found, that monitor mode seems to cause some troubles. After fre=
sh reboot drivers work fine and association is OK, but if I switch off =
wlan0, change mode to monitor, switch on card, play a bit (tcpdump, air=
odump-ng) and then again, switch off, set mode to managed, switch on an=
d try to connect to my router then association works, but I\'m not able=
 to get any IP and dhcpclient fails on timeout.=0D
=0D
=0D
=0D
----- Origin=E1lna Spr=E1va -----=0D
Od: Zhu Yi  =0D
Komu: Ineya Ineya  =0D
Poslan=E1: 17.09.2008 03:46 =0D
Predmet: Re: iwlagn/iwl4965 problems with WEP and rmmod=0D
=0D
> On Tue, 2008-09-16 at 22:32 +0200, Ineya Ineya wrote:=0D
> > I\\\'m using Debian Etc: 2.6.24-etchnhalf.1-amd64 #1 SMP kernel, =0D
> > =0D
> > and I downloaded compat-wireless-old-2008-09-15.tar.bz2 and=0D
> =0D
> Wonder if it is compat-wireless related. Do you have the problem in=0D
> wireless-testing kernel or vanilla?=0D
> =0D
> Thanks,=0D
> -yi=0D
> =0D
>=20


__________
http://cestovanie.sme.sk/ - Cel=FD svet na va=B9om monitore


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
