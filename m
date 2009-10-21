Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60665 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZJUBrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 21:47:03 -0400
Received: by fxm18 with SMTP id 18so7173607fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 18:47:06 -0700 (PDT)
Date: Tue, 20 Oct 2009 21:47:02 -0400
From: Celejar <celejar@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Broadcom 4318 not working with bleeding edge kernels
Message-Id: <20091020214702.a76fa4aa.celejar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[A version of this message was originally posted to the bcm43xx-dev
ML:

https://lists.berlios.de/pipermail/bcm43xx-dev/2009-October/006197.html

I received no response there, so I thought I'd try here.]

My Broadcom 4318 (details below) has been working fine for quite some
time with b43 in mainline.  As recently as 2.6.31, it was still working:

Oct 18 20:30:06 localhost wpa_supplicant[2892]: CTRL-EVENT-SCAN-RESULTS 
Oct 18 20:30:06 localhost wpa_supplicant[2892]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
Oct 18 20:30:06 localhost wpa_supplicant[2892]: Association request to the driver failed
Oct 18 20:30:07 localhost kernel: [   78.196304] wlan0: authenticate with AP 00:14:d1:3e:ff:30
Oct 18 20:30:07 localhost kernel: [   78.197716] wlan0: authenticated
Oct 18 20:30:07 localhost kernel: [   78.197719] wlan0: associate with AP 00:14:d1:3e:ff:30
Oct 18 20:30:07 localhost kernel: [   78.200084] wlan0: RX AssocResp from 00:14:d1:3e:ff:30 (capab=0x431 status=43 aid=0)
Oct 18 20:30:07 localhost kernel: [   78.200088] wlan0: AP denied association (code=43)
Oct 18 20:30:07 localhost kernel: [   78.397059] wlan0: associate with AP 00:14:d1:3e:ff:30
Oct 18 20:30:07 localhost wpa_supplicant[2892]: Associated with 00:14:d1:3e:ff:30
Oct 18 20:30:07 localhost kernel: [   78.399232] wlan0: RX AssocResp from 00:14:d1:3e:ff:30 (capab=0x431 status=0 aid=2)
Oct 18 20:30:07 localhost kernel: [   78.399237] wlan0: associated
Oct 18 20:30:07 localhost kernel: [   78.400055] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Oct 18 20:30:08 localhost dnsmasq[1968]: reading /var/run/dnsmasq/resolv.conf
Oct 18 20:30:08 localhost dnsmasq[1968]: using nameserver 192.168.0.1#53
Oct 18 20:30:09 localhost wpa_supplicant[2892]: WPA: Key negotiation completed with 00:14:d1:3e:ff:30 [PTK=CCMP GTK=CCMP]
Oct 18 20:30:09 localhost wpa_supplicant[2892]: CTRL-EVENT-CONNECTED - Connection to 00:14:d1:3e:ff:30 completed (auth) [id=0 id_str=]
Oct 18 20:30:09 localhost kernel: [   80.263676] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 00:14:d1:3e:ff:30
Oct 18 20:30:09 localhost kernel: [   80.263699] b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff

The early 2.6.32 rc kernels were giving oopses, apparently because of
this:

https://lists.berlios.de/pipermail/bcm43xx-dev/2009-October/006129.html

The patch is apparently in -rc5, but that kernel, while it doesn't
oops, fails to authenticate:

Oct 17 19:44:05 localhost wpa_supplicant[3477]: CTRL-EVENT-SCAN-RESULTS 
Oct 17 19:44:07 localhost wpa_supplicant[3477]: CTRL-EVENT-SCAN-RESULTS 
Oct 17 19:44:07 localhost wpa_supplicant[3477]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
Oct 17 19:44:07 localhost kernel: [  198.914180] wlan0: deauthenticating from 00:14:d1:3e:ff:30 by local choice (reason=3)
Oct 17 19:44:07 localhost kernel: [  198.914320] wlan0: direct probe to AP 00:14:d1:3e:ff:30 (try 1)
Oct 17 19:44:07 localhost kernel: [  198.917136] wlan0: direct probe responded
Oct 17 19:44:07 localhost kernel: [  198.917141] wlan0: authenticate with AP 00:14:d1:3e:ff:30 (try 1)
Oct 17 19:44:07 localhost kernel: [  198.918857] wlan0: authenticated
Oct 17 19:44:07 localhost kernel: [  198.918873] wlan0: associate with AP 00:14:d1:3e:ff:30 (try 1)
Oct 17 19:44:07 localhost kernel: [  198.921192] wlan0: RX AssocResp from 00:14:d1:3e:ff:30 (capab=0x431 status=43 aid=0)
Oct 17 19:44:07 localhost kernel: [  198.921196] wlan0: AP denied association (code=43)
Oct 17 19:44:17 localhost wpa_supplicant[3477]: Authentication with 00:14:d1:3e:ff:30 timed out.
Oct 17 19:44:19 localhost wpa_supplicant[3477]: CTRL-EVENT-SCAN-RESULTS 
Oct 17 19:44:19 localhost wpa_supplicant[3477]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
Oct 17 19:44:19 localhost wpa_supplicant[3477]: Association request to the driver failed
Oct 17 19:44:24 localhost wpa_supplicant[3477]: Authentication with 00:14:d1:3e:ff:30 timed out.
Oct 17 19:44:25 localhost wpa_supplicant[3477]: CTRL-EVENT-SCAN-RESULTS 
Oct 17 19:44:25 localhost wpa_supplicant[3477]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
Oct 17 19:44:25 localhost wpa_supplicant[3477]: Association request to the driver failed
Oct 17 19:44:30 localhost wpa_supplicant[3477]: Authentication with 00:14:d1:3e:ff:30 timed out.
Oct 17 19:44:31 localhost wpa_supplicant[3477]: CTRL-EVENT-SCAN-RESULTS 
Oct 17 19:44:31 localhost wpa_supplicant[3477]: Trying to associate with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz)
Oct 17 19:44:31 localhost wpa_supplicant[3477]: Association request to the driver failed

Any idea what's going on here?  I can, of course, do a bisection if
necessary, but I'm asking first in case there's a known or suspected
issue that someone can point me to.

[Please cc me on responses.]

Celejar
-- 
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

