Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.matws.net ([88.175.162.123]:33552 "EHLO smtp.matws.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXKYOUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 09:20:37 -0500
Received: from [192.168.24.10] (unknown [192.168.24.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.matws.net (smtp.matws.net) with ESMTP id 62CC3280320
	for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2007 15:19:50 +0100 (CET)
Message-ID: <474984B1.90302@matws.net> (sfid-20071125_142050_558023_59312410)
Date: Sun, 25 Nov 2007 17:20:33 +0300
From: Matthieu PATOU <mat@matws.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: BCM4312 status
References: <47469E42.6050909@matws.net>
In-Reply-To: <47469E42.6050909@matws.net>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Matthieu PATOU a =E9crit :

> Yesterday I fetched a more recent version of the everything branch an=
d=20
> built a kernel with the latest patch from larry finger, I've planned =
to=20
> test it this afternoon, I'll publish then my results with this.
I finally conducted a test today.
My kernel is based on this commit 301df40749bdf144c72637795ba93d82e4b84=
682, and I used the patch published by Larry=20
=46inger on last thursday (title of the email : [PATCH V2] b43: Changes=
 to enable BCM4311 rev 02 with wireless core=20
revision 13).

My results with this kernel are worser than with the previous.

Just after loading the driver I have this message :
Nov 25 13:26:04 ares kernel: [   58.523036] b43-phy0 debug: Loading fir=
mware version 351.126 (2006-07-29 05:54:02)
Nov 25 13:26:04 ares kernel: [   58.575722] WARNING: at=20
/usr/local/src/linux-2.6.24-git/drivers/net/wireless/b43/wa.c:657 b43_w=
a
_all()
Nov 25 13:26:04 ares kernel: [   58.575738]  [<f8ba0d57>] b43_wa_all+0x=
197/0x6c0 [b43]
Nov 25 13:26:04 ares kernel: [   58.575759]  [<f8b99aad>] b43_phy_inita=
+0x5d/0x500 [b43]
Nov 25 13:26:04 ares kernel: [   58.575768]  [<f8b9a407>] b43_phy_initb=
6+0x3e7/0x6a0 [b43]
Nov 25 13:26:04 ares kernel: [   58.575783]  [<f8b9ab76>] b43_phy_initg=
+0x36/0xe10 [b43]
Nov 25 13:26:04 ares kernel: [   58.575796]  [msleep+21/32] msleep+0x15=
/0x20
Nov 25 13:26:04 ares kernel: [   58.575801]  [<f8b99259>] b43_radio_sel=
ectchannel+0xf9/0x480 [b43]
Nov 25 13:26:04 ares kernel: [   58.575821]  [<f8b9bea7>] b43_phy_init+=
0x277/0x580 [b43]
Nov 25 13:26:04 ares kernel: [   58.575835]  [<f8b902e3>] b43_chip_init=
+0x443/0x920 [b43]
Nov 25 13:26:04 ares kernel: [   58.575854]  [<f8b90995>] b43_wireless_=
core_init+0x1d5/0x700 [b43]
Nov 25 13:26:04 ares kernel: [   58.575870]  [<f8b91d67>] b43_op_start+=
0x77/0x90 [b43]
Nov 25 13:26:04 ares kernel: [   58.575882]  [<f8bb3a5d>] ieee80211_ope=
n+0x15d/0x460 [mac80211]
=2E..
Nov 25 13:26:04 ares kernel: [   58.576136]  [sys_socketcall+591/640] s=
ys_socketcall+0x24f/0x280
Nov 25 13:26:04 ares kernel: [   58.576149]  [sys_time+10/48] sys_time+=
0xa/0x30
Nov 25 13:26:04 ares kernel: [   58.576154]  [sysenter_past_esp+95/133]=
 sysenter_past_esp+0x5f/0x85
Nov 25 13:26:04 ares kernel: [   58.576168]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov 25 13:26:05 ares kernel: [   59.643488] b43-phy0 debug: Chip initia=
lized
Nov 25 13:26:05 ares kernel: [   59.643714] b43-phy0 debug: 64-bit DMA =
initialized
Nov 25 13:26:05 ares kernel: [   59.663763] b43-phy0 debug: Wireless in=
terface started
Nov 25 13:26:05 ares kernel: [   59.663767] b43-phy0 debug: Adding Inte=
rface type 2
Nov 25 13:26:05 ares kernel: [   59.664576] b43-phy0 ERROR: PHY transmi=
ssion error
Nov 25 13:26:05 ares kernel: [   59.664653] b43-phy0 ERROR: Fatal DMA e=
rror: 0x00000400, 0x00000000, 0x00000000,=20
0x00000000, 0x00000000, 0x00000000
Nov 25 13:26:05 ares kernel: [   59.664729] b43-phy0: Controller RESET =
(DMA error) ...
Nov 25 13:26:05 ares kernel: [   59.665301] ADDRCONF(NETDEV_UP): wlan0:=
 link is not ready
Nov 25 13:26:05 ares kernel: [   59.711870] b43-phy0 debug: Wireless in=
terface stopped
Nov 25 13:26:05 ares kernel: [   59.711907] b43-phy0 debug: DMA-64 0x02=
00 (RX) max used slots: 0/64
Nov 25 13:26:05 ares kernel: [   59.711946] b43-phy0 debug: DMA-64 0x03=
40 (TX) max used slots: 0/128
Nov 25 13:26:05 ares kernel: [   59.720294] b43-phy0 debug: DMA-64 0x03=
00 (TX) max used slots: 0/128
Nov 25 13:26:05 ares kernel: [   59.727866] b43-phy0 debug: DMA-64 0x02=
C0 (TX) max used slots: 0/128
Nov 25 13:26:06 ares kernel: [   59.736043] b43-phy0 debug: DMA-64 0x02=
80 (TX) max used slots: 0/128
Nov 25 13:26:06 ares kernel: [   59.744027] b43-phy0 debug: DMA-64 0x02=
40 (TX) max used slots: 0/128
Nov 25 13:26:06 ares kernel: [   59.751858] b43-phy0 debug: DMA-64 0x02=
00 (TX) max used slots: 0/128
Nov 25 13:26:06 ares kernel: [   59.867946] b43-phy0 debug: Loading fir=
mware version 351.126 (2006-07-29 05:54:02)
Nov 25 13:26:06 ares kernel: [   59.923806] WARNING: at=20
/usr/local/src/linux-2.6.24-git/drivers/net/wireless/b43/wa.c:657 b43_w=
a_all()
Nov 25 13:26:06 ares kernel: [   59.923825]  [<f8ba0d57>] b43_wa_all+0x=
197/0x6c0 [b43]
Nov 25 13:26:06 ares kernel: [   59.923845]  [<f8b99aad>] b43_phy_inita=
+0x5d/0x500 [b43]
Nov 25 13:26:06 ares kernel: [   59.923855]  [<f8b9a407>] b43_phy_initb=
6+0x3e7/0x6a0 [b43]
Nov 25 13:26:06 ares kernel: [   59.923870]  [<f8b9ab76>] b43_phy_initg=
+0x36/0xe10 [b43]
Nov 25 13:26:06 ares kernel: [   59.923883]  [msleep+21/32] msleep+0x15=
/0x20

And it keeps looping around the same set of message.

Any clue on to solve this problem ?
Any patch that i can test ?
Matthieu
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
