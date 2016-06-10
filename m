Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idris.smile.fr ([91.216.209.19]:60916 "EHLO idris.smile.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbcFJPn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 11:43:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by idris.smile.fr (Postfix) with ESMTP id 5EEEB1EE0951
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 17:37:10 +0200 (CEST)
Received: from idris.smile.fr ([127.0.0.1])
	by localhost (bluemind-mta.prod.vitry.intranet [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U5UoYIc20mcE for <linux-wireless@vger.kernel.org>;
	Fri, 10 Jun 2016 17:37:10 +0200 (CEST)
Received: from bluemind.smile.fr (bluemind.prod.vitry.intranet [10.10.1.35])
	by idris.smile.fr (Postfix) with ESMTP id 438451EE0479
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 17:37:10 +0200 (CEST)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by bluemind.smile.fr (Postfix) with ESMTP id 367645460439
	for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 17:37:10 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 10 Jun 2016 17:37:10 +0200
From: Vincent CESSON <vincent.cesson@smile.fr>
To: <linux-wireless@vger.kernel.org>
Subject: =?UTF-8?Q?mwifiex+wpa=5Fsupplicant=20cannot=20set=20up=20WPA/WPA?=
 =?UTF-8?Q?=32=20ADHOC?=
Message-ID: <4eed6159efdc3f86e4f549bb31ce6a74@smile.fr> (sfid-20160610_174332_596511_E6C03A77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I need to set a secured Adhoc network using WPA or WPA2 on my embedded 
device (linux 3.10, mwifiex backported 4.1.1, wpa_supplicant 2.5 (with 
CONFIG_IBSS_RSN=y), hostap 2.5). I tried the following configs:

WPA-NONE:
I start a WPA-NONE Adhoc with wpa_supplicant on the embedded device 
(see wpa_supplicant-wpa-none.conf + wpa_supplicant-wpa-none.log). Then 
from my computer (Ubuntu 14.04), I managed to join the network and ping 
the device without setting any password! The connection is not secured.

WPA-PSK:
I also tried WPA-RSN (see wpa_supplicant-rsn.conf + 
wpa_supplicant-rsn.log). As you can see in log file, the 4Way-Handshake 
is completed. But after some seconds, the log shows a timeout and an 
authentication failure. The device and my computer are connected to the 
same network and they share the same BSS, but ping always fails. Note 
that if I set a bad password on computer side, the handshake never 
completes.

dmesg does not show any error.
WEP works fine.

Any idea of what could be wrong?

Thank you,
Vincent
