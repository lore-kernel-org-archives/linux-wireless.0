Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from otrok.post.sk ([85.248.69.172]:52154 "EHLO otrok.post.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbYIRPB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:01:56 -0400
Message-ID: <48D26ED5.000001.22367@kamasutra> (sfid-20080918_170205_829727_9B4888FA)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-2
From: Ineya Ineya <ineya@post.sk>
To: <abhijeet.kolekar@intel.com>
Cc: <yi.zhu@intel.com>, <linux-wireless@vger.kernel.org>
Subject: Re: RE: Re: iwlagn/iwl4965 problems with WEP and rmmod
Date: 18 Sep 2008 17:08:05 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I applied the patch: http://www.intellinuxwireless.org/bugzilla/attachm=
ent.cgi?id=3D1564=0D
to 2008-09-14 version of compat-old and I can confirm that it works and=
 it is possible to use managed mode (associate, authenticate via WEP an=
d get IP address via DHCP) after monitor mode is switched off.=0D
=0D
I found that it doesn\'t work always and the closest description I can =
get is:=0D
=0D
the following combination was OK:=0D
(wlan0 is up in managed mode)=0D
ifconfig wlan0 down=0D
ifconfig wlan0 up=0D
iwconfig wlan0 channel 6 essid Net2 key s:12345 ap 00:19:5B:E0:F3:20=0D
dhclient wlan0=0D
=0D
but if I try:=0D
(wlan0 is up in managed mode)=0D
ifconfig wlan0 down=0D
iwconfig wlan0 channel 6 essid Net2 key s:12345 ap 00:19:5B:E0:F3:20=0D
ifconfig wlan0 up=0D
iwconfig wlan0 channel 6 essid Net2 key s:12345 ap 00:19:5B:E0:F3:20=0D
dhclient wlan0=0D
=0D
Please note the iwconfig used when wlan0 is down. If I use it in this w=
ay, then dhclient is not able to get IP address most of the time. Turni=
ng off and on again wlan0 and not using iwconfig while wlan0 is down se=
ems to cure the problem and in the next round dhclient will get IP.=0D
=0D
Anyway, thanks for the patch. :-)=0D
=0D
----- Origin=E1lna Spr=E1va -----=0D
Od: \"Kolekar, Abhijeet\"  =0D
Komu: Ineya Ineya , \"Zhu, Yi\" , \"linux-wireless@vger.kernel.org\"  =0D
Poslan=E1: 18.09.2008 00:22 =0D
Predmet: RE: Re: iwlagn/iwl4965 problems with WEP and rmmod=0D
=0D
> =0D
> =0D
> -----Original Message-----=0D
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-own=
er@vger.kernel.org] On Behalf Of Ineya Ineya=0D
> Sent: Wednesday, September 17, 2008 12:29 PM=0D
> To: Zhu, Yi; ineya@post.sk; linux-wireless@vger.kernel.org=0D
> Subject: Re: Re: iwlagn/iwl4965 problems with WEP and rmmod=0D
> =0D
=0D



__________
Sprievodca hern=FDm svetom - http://hry.sme.sk/


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
