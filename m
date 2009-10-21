Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:39535 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751977AbZJULBo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 07:01:44 -0400
Message-ID: <868263.12588.qm@web51404.mail.re2.yahoo.com>
Date: Wed, 21 Oct 2009 04:01:48 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: ath5k with two NICs runing IBSS and AP mode simultaneously causes error
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I have a configuration with two Atheros NICs (AR5212). To evaluate whether ath5k is now good enough to replace Madwifi I run the current wireless-testing branch and did some tests:
One interface (wlan0) is in IBSS mode joined to another host. I run iperf in both directions simultaneously over night. This worked very well (except for the known IBSS join bug).
Additionally I built hostapd 0.6.9 and run it with a very minmal configuration (interface=wlan1, driver=nl80211, ssid=MyNetwork, hw_mode=g, channel=1) and tried to connect from a WinXP client. I had not yet setup a DHCP server, so this was not actually expected to succeed.
I think immediately after starting hostapd the iperf run stopped and I got the following error message:
ath5k phy0: no further txbuf available, dropping packet.
The timing makes it very likely that the hostapd on wlan1 disturbed the iperf run on wlan0. Is this a known problem? Is there something I can do to help track this down?

 -- 
Regards 
Joerg 


      
