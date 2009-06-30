Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:39751 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752612AbZF3RYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 13:24:21 -0400
Received: from localhost.localdomain (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 4C2AF2EF88
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 13:10:31 -0400 (EDT)
Received: from sprite (unknown [72.234.43.214]) (using TLSv1 with cipher
 AES256-SHA (256/256 bits)) (No client certificate requested) by
 b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id 067E52EF87 for
 <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 13:10:29 -0400 (EDT)
Received: from jroth by sprite with local (Exim 4.69) (envelope-from
 <joelz@pobox.com>) id 1MLgpY-0001Lr-Eb for linux-wireless@vger.kernel.org;
 Tue, 30 Jun 2009 07:09:16 -1000
Date: Tue, 30 Jun 2009 07:09:16 -1000
From: Joel Roth <joelz@pobox.com>
To: linux-wireless@vger.kernel.org
Subject: ath5k and Atheros AR242x - No scan results
Message-ID: <20090630170916.GB5137@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I'd appreciate some help troubleshooting my wireless connection.

I have a Toshiba Satellite L305 series laptop running Debian
sid with a recent, stock Debian kernel version 2.6.29-2-486.

$ lspci | grep Atheros

05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)

I am seeking to connect to a D-Link 614+ wireless router.
For initial testing, the AP is unencrypted, unsecured.

My wife's G3 i-Book with AfterTheMac USB wireless adapter
connected just fine, on the first try.

I believe I have the modules I should have:

$ lsmod | grep 80211
mac80211              139680  1 ath5k
cfg80211               21576  2 ath5k,mac80211

My wireless network interface is present:

$ iwconfig wlan0

wlan0     IEEE 802.11  ESSID:""  
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
          Tx-Power=0 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

$ ifconfig wlan0

wlan0     Link encap:Ethernet  HWaddr 00:21:63:82:82:40  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


However, I don't find the D-Link 614+:

$ iwlist wlan0 scan

wlan0     No scan results

And of course, dhclient fails to find a server.

Am I missing something? What could I try next?
I'd appreciate any pointers.

Thanks.

-- 
Joel Roth
