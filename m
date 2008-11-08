Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36093 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYKHGLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 01:11:19 -0500
Received: from [71.112.128.23] (pool-71-112-128-23.sttlwa.dsl-w.verizon.net [71.112.128.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id mA85BcqW019914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 7 Nov 2008 21:11:39 -0800
Message-ID: <49151F8A.7040901@candelatech.com> (sfid-20081108_071123_869572_3B2D3E27)
Date: Fri, 07 Nov 2008 21:11:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Trouble with bcm4312 rev 01 on the HP 2133
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying kernel 2.6.27.4-79.fc10 (Fedora 10 preview) on an HP 2133 
mini-note system.

I *believe* I extracted the firmware properly, but when I load b43, I 
get only a single
line in /var/log/messages, like it doesn't find the hardware or 
something?  Will there be
any obvious errors I could check for to see if the firmware is correct?

Nov  7 20:48:17 localhost kernel: Broadcom 43xx driver loaded [ 
Features: PMLR, Firmware-ID: FW13 ]


According to lspci, I have this wifi NIC:

lspci -x
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)
00: e4 14 15 43 06 01 10 00 01 00 80 02 08 00 00 00
10: 04 c0 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 7c 13
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00

lspci -v
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)
        Subsystem: Hewlett-Packard Company BCM4312 802.11b/g Wireless 
LAN Controller
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fdffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information <?>
        Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACS Voil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACS Voil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACS Voil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Capabilities: [13c] Virtual Channel <?>
        Capabilities: [160] Device Serial Number 21-00-25-ff-ff-00-02-6d
        Capabilities: [16c] Power Budgeting <?>

Any idea of what I might be doing wrong?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


