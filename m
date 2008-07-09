Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59890 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbYGINaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:30:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KGZkA-0006e8-BB
	for linux-wireless@vger.kernel.org; Wed, 09 Jul 2008 13:30:02 +0000
Received: from 206-248-135-194.dsl.teksavvy.com ([206.248.135.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 13:30:02 +0000
Received: from monnier by 206-248-135-194.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 13:30:02 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Slow b43 with 2.6.25.9 on an asus wl-700ge home-router
Date: Wed, 09 Jul 2008 01:50:11 -0400
Message-ID: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20080709_153011_573319_F8AA0FD2)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally started to use the b43 driver on my home-router and am happy
to have it working at all (with WPA), but I notice that the speed is
pretty terrible: I cannot seem to get more than 100KB/s out of it (I
use it as a personal web proxy, so it ends up slowing down my
web-surfing :-( ).

Originally "iwconfig" told me that the bit rate was 2Mb/s (and even
that should allow me to get a bit more than 100KB/s).
After "iwconfig wlan0 rate 54M", the result is the same (except that
"iwconfig" tells me the bit rate is 54Mb/s).

More specifically, iwconfig tells me things like:

wlan0     IEEE 802.11  ESSID:"test"  
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:10:30:C0:50:50   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Link Quality=95/100  Signal level:-54 dBm  Noise level=-63 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

which seems to indicate that the reception is indeed good.
Any idea what I might want to check?

I did notice that my dmesg says things like
"received packet with  own address as source address".  This seems
related to my use of bridging, but:
1 - I have no bridging loop (actually I unplugged all ethernet cables,
    so the only active network interface in the bridge is wlan0).
2 - taking wlan0 out of the bridge eliminates those messages, but
    doesn't improve the bandwidth.

Any idea what might be going on?


        Stefan

