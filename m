Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751027AbYHaIFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2008 04:05:39 -0400
Message-ID: <48BA50CF.9030601@gmx.net> (sfid-20080831_100555_737564_C99DA302)
Date: Sun, 31 Aug 2008 10:05:35 +0200
From: Eric <plukje@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Eric <plukje@gmx.net>
Subject: rt2500 probe responses with wep and fragmented bit set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

I'm trying to get master mode to work with a pci rt2500 card, running 
ubuntu, git wl kernel, git hostapd and libnl1.1.
Runningt hostapd in verbose mode screams MGMT (TX callback) fail (in 
fact, it manages to do 1 ack, the rest are failures).
Now, for the record, hostapd is configured to run as an open AP, the 
most basic configuration you can think of.
When analyzing the actual responses (tcpdumping on the mon.wlan0 iface, 
using wireshark to disect), I discovered that the probe responses for a 
SSID broadcast
had the WEP bit and the Fragmentation bit set, consistently, for all 
probe responses.

Somehow I dont think that frame of 81 bytes needs either bits set.
Does anyone know wether this falls in the category mac80211, hostapd 
bug, or rt2x00 bug?

kind regards,

Eric

N.B.
According to the rt2x00 project admin, rt2x00 doesnt touch the ieee80211 
header.  (see 
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=4969 ).

N.B2.
I'm currently not subscribed to the mailinglist, please keep me in the 
cc, thank you.
