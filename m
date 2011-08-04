Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60359 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1HDOqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 10:46:45 -0400
Received: by fxh19 with SMTP id 19so1815905fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 07:46:44 -0700 (PDT)
From: David Abdurachmanov <david.abd@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: Significant difference between 2.6.34 and 2.6.39 (libertas_sdio/ad-hoc) ?
Date: Thu, 4 Aug 2011 17:46:36 +0300
Message-Id: <31C4BF3B-4B8A-4684-894C-3D2DC5484C0A@gmail.com> (sfid-20110804_164659_727576_0A5C2588)
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1244.3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using Gumstix Overo Fire COM, which has Wi2Wi chip (based on Marvell's 88W8686). The Angstrom Linux distribution build uses *libertas* driver (SDIO) for WiFi. I am trying to create WEP encrypted and restricted Ad-hoc (IBSS) network.

This sequence of commands are used for testing:
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 4
iwconfig wlan0 essid 'TestMeNow'
iwconfig wlan0 key restricted 0123456789
ip link set wlan0 up

*NOTE:* With iw utility I don't see how to make restricted network. Any hints?

2.6.34 output:
---
wlan0     IEEE 802.11b/g  ESSID:"TestMeNow"  
        Mode:Ad-Hoc  Frequency:2.427 GHz  Cell: 02:26:F6:97:61:87   
        Bit Rate:0 kb/s   Tx-Power=13 dBm   
        Retry short limit:8   RTS thr=2347 B   Fragment thr=2346 B   
        Encryption key:0123-4567-89   Security mode:restricted
        Power Management:off
        Link Quality=0/100  Signal level=-94 dBm  Noise level=-94 dBm
        Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
        Tx excessive retries:0  Invalid misc:0   Missed beacon:0

MacBook WiFi scanning tool:
---
Enc/Cipher:	WEP
Encrypted:	Yes

2.6.39 (same results with 3.0)
---
wlan0     IEEE 802.11bg  ESSID:"TestMeNow"  
        Mode:Ad-Hoc  Frequency:2.427 GHz  Cell: 02:2D:5D:76:F8:0A   
        Retry  long limit:7   RTS thr:off   Fragment thr:off
        Encryption key:0123-4567-89
        Power Management:on

Scanning tool:
---
Enc/Cipher:	None
Encrypted:	No

What you get on .39 kernel is open network without WEP encryption. Were there any significant changes in the kernel between .34 and .39 that affects wireless networks or at least libertas driver?

Thanks in advance, 
David Abdurachmanov