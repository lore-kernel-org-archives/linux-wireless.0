Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49269 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZCYWhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 18:37:09 -0400
Subject: [BISECTED] AR5414 fails to scan after "ath5k: Update reset code"
From: Pavel Roskin <proski@gnu.org>
To: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 25 Mar 2009 18:37:05 -0400
Message-Id: <1238020625.15025.15.camel@mj> (sfid-20090325_233718_714304_E986F687)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

AR5414 fails to scan most of the time starting with the revision
94f2e0d6234991d0c10d458f6f378934efbdf6d6 "ath5k: Update reset code"

I have about 18 APs in the range.  With the latest kernel, the scan
results are usually empty.  I tried reverting parts of the patch, as it
cannot be cleanly reverted on top of wireless-testing, and I've seen
scan results with all APs occasionally, but most of the time the scan
results would be empty.

With the last working revision, bbcce7389a7288c48d96d13bbf521e901236d287
"ath5k: Update initvals", scanning gives all APs in range every time.

The chip is reported by the driver as:
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)

$ lspci -vnn -s 0000:0b:00.0
0b:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
        Subsystem: Apple Computer Inc. Device [106b:0086]
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fe8f0000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140] Virtual Channel <?>
        Kernel driver in use: ath5k
        Kernel modules: ath_pci, ath5k

It's a PCI Express minicard.  The kernel architecture is x86_64.

-- 
Regards,
Pavel Roskin
