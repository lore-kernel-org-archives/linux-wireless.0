Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42573 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbXHDX06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 19:26:58 -0400
Message-ID: <46B50B3C.7000906@lwfinger.net>
Date: Sat, 04 Aug 2007 18:26:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Port of bcm43xx from softmac to mac80211 is available for testing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The port of bcm43xx from softmac to mac80211 is available for testing. There are two patch sets that 
can be downloaded from ftp://lwfinger.dynalias.org/patches and be applied to kernel 2.6.23-rc1 or 
-rc2, the mainstream git tree (Linus's), and Linville's wireless-2.6 git tree.

The two files are ftp://lwfinger.dynalias.org/patches/SSB_Final, which installs the SSB driver, and 
ftp://lwfinger.dynalias.org/patches/port_to_mac80211, which has the changes for the bcm43xx driver. 
The resulting driver will use V3 firmware.

These patches are similar to the 4301 test driver that was circulated earlier. The major change is 
that the earlier version was trying to set the power too low. Once that was fixed, performance has 
become quite good, as shown below. I'm still working on the power setup, which may help the BCM4306.

Transker rates (xmit/recv in Mbs), obtained by using an Iperf server on my LAN

Bit Rate	BCM4311		BCM4318		BCM4306
set (Mbs)
1		1.17/8.66	1.22/9.39	1.22/3.73
2		1.96/11.2	1.98/12.5	1.90/4.98
5.5		4.15/17.7	4.19/17.7	3.98/5.09
6		4.86/17.3	4.86/19.9	2.66/4.94
9		6.58/17.7	6.56/19.9	3.26/5.01
11		6.57/14.2	6.54/18.5	6.07/5.20
18		10.7/19.6	10.7/20.2	4.74/5.05
24		12.6/19.6	12.8/20.0	4.12/5.34
36		16.2/20.1	15.9/20.1	4.76/4.90
48		17.9/20.0	15.1/19.6	3.70/4.18
54		19.0/19.8	15.1/20.0	1.83/2.64

These results look rather good for the later models - my BCM4306 has a PHY rev of 1. On this 
version, much more is required in the PHY setup, and we clearly have more work for that device.

Please let me know of any problems in applying the patches, or any oops's that occur.

Larry



