Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1EZVZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 17:25:44 -0400
Received: by fxm17 with SMTP id 17so965683fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 14:25:43 -0700 (PDT)
Message-ID: <4DDEC554.9080702@googlemail.com> (sfid-20110526_232547_484266_6FE12F92)
Date: Thu, 26 May 2011 23:25:40 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com
CC: linux-wireless@vger.kernel.org
Subject: [hostapd] Multicast packets not encrypted
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I am using an encrypted connection with two dedicated devices using 
freeradius and hostapd with eap encryption - respectively 
wpa_supplicant. Everything is working fine, except transmission of 
multicast packets.

I put an independant device into monitor mode and - as to be expected - 
I can only see encrypted packets. Apart from multicast packets - those I 
can read in plain.

How can this be?

On the machines using the wireless encryption this routing table is present:

:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use 
Iface
10.0.0.0        0.0.0.0         255.0.0.0       U     0      0        0 
wlan0
224.0.0.0       0.0.0.0         240.0.0.0       U     0      0        0 
wlan0

Once I issue a

ping 224.0.0.1

I can read the ping packets in plain on the machine with the wireless 
card in monitor mode. Apart from that, the machine, that should receive 
the multicast packet, does not "see" the multicast packets (nothing to 
see in tcpdump of the respective receiver device, that is part of the 
encrypted connection).

Any suggestions?

Best regards,
Dennis
