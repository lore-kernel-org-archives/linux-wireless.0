Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from otrok.post.sk ([85.248.69.172]:44586 "EHLO otrok.post.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYIPUof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:44:35 -0400
Message-ID: <48D017C9.000004.04390@kamasutra> (sfid-20080916_224453_952659_2DF8CDDA)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-2
From: Ineya Ineya <ineya@post.sk>
To: <linux-wireless@vger.kernel.org>
Subject: iwlagn/iwl4965 problems with WEP and rmmod
Date: 16 Sep 2008 22:32:09 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,=0D
=0D
I\'m using Debian Etc: 2.6.24-etchnhalf.1-amd64 #1 SMP kernel, =0D
and I downloaded compat-wireless-old-2008-09-15.tar.bz2 and iwlwifi-496=
5-ucode-228.57.2.21.tgz.=0D
=0D
1st problem was during compilation, because iwl4965.c wasn\'t compiled =
at all, so edited Makefile and added it to iwlagn objects: =0D
=0D
iwlagn-objs             :=3D iwl-agn.o iwl-4965.o iwl-agn-rs.o=0D
=0D
after this change I could insert modules to kernel and my card seems to=
 work, I could sniff all traffic in monitor mode (not just beacon packe=
ts as in debian\'s original driver).=0D
=0D
2nd problem came, when I was trying to authenticate with my router usin=
g WEP, this failed immeadiately with messages:=0D
Sep 16 21:06:32 ladovec kernel: wlan0: authenticate with AP 00:19:5b:e0=
:f3:20=0D
Sep 16 21:06:32 ladovec kernel: wlan0: authenticate with AP 00:19:5b:e0=
:f3:20=0D
Sep 16 21:06:33 ladovec kernel: wlan0: authentication with AP 00:19:5b:=
e0:f3:20 timed out=0D
Sep 16 21:08:06 ladovec kernel: wlan0: authenticate with AP 00:19:5b:e0=
:f3:20=0D
Sep 16 21:08:06 ladovec last message repeated 2 times=0D
Sep 16 21:08:06 ladovec kernel: wlan0: authentication with AP 00:19:5b:=
e0:f3:20 timed out=0D
Sep 16 21:08:26 ladovec kernel: wlan0: authenticate with AP 00:19:5b:e0=
:f3:20=0D
Sep 16 21:08:26 ladovec last message repeated 2 times=0D
Sep 16 21:08:26 ladovec kernel: wlan0: authentication with AP 00:19:5b:=
e0:f3:20 timed out=0D
Sep 16 21:09:04 ladovec kernel: wlan0: authenticate with AP 00:19:5b:e0=
:f3:20=0D
Sep 16 21:09:05 ladovec last message repeated 2 times=0D
Sep 16 21:09:05 ladovec kernel: wlan0: authentication with AP 00:19:5b:=
e0:f3:20 timed out=0D
=0D
using the debian\'s original driver iwl4965 I can authenticate with no =
problem.=0D
=0D
3rd problem is when I try to rmmod the iwlagn module, kernel crashes=0D
but I was able to get any hint, which would suggest why=0D
=0D
=0D
Is there anything I can try to fix the 2nd problem (the WEP authenticat=
ion)?=0D
=0D



__________
Najpopul=E1rnej=B9=ED blog na Slovensku - http://blog.sme.sk/


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
