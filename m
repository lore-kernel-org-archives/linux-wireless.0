Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:44264 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab2IXWQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 18:16:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0MAV006UFJ4WL810@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Sep 2012 23:46:08 +0200 (CEST)
Received: from pebbles.localnet ([unknown] [78.49.193.32])
 by relay-auth-2.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0MAV00EUAJ4WGV40@relay-auth-2.ms.rz.rwth-aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 24 Sep 2012 23:46:08 +0200 (CEST)
From: Stefan =?ISO-8859-1?Q?Br=FCns?= <stefan.bruens@rwth-aachen.de>
To: linux-wireless@vger.kernel.org
Subject: Throughput regression in b43 caused by spurious avoidance
 implementation
Date: Mon, 24 Sep 2012 23:46:05 +0200
Message-id: <1698401.RCfH1UvLZM@pebbles> (sfid-20120925_001615_466398_7EB90ECF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

as I have been plagued by the performance regression in b43 between linux 3.2 
and 3.3, I have bisected it:

git bisect good
49d55cef5b1925a5c1efb6aaddaa40fc7c693335 is the first bad commit
commit 49d55cef5b1925a5c1efb6aaddaa40fc7c693335
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Sun Dec 11 13:16:51 2011 +0100

    b43: N-PHY: implement spurious tone avoidance
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 f6177f4c33e1d382a430ad83db1e4b3f9dd66dfd 
1b161ac9a16a481f259606edda5039c2be5147f4 M      drivers

lspci -v{n,}:
08:00.0 0280: 14e4:432b (rev 01)
        Subsystem: 1028:000d
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at f0600000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number 7e-d8-e5-xx-xx-xx-xx
        Capabilities: [16c] Power Budgeting <?>
        Kernel driver in use: b43-pci-bridge

08:00.0 Network controller: Broadcom Corporation BCM4322 802.11a/b/g/n 
Wireless LAN Controller (rev 01)
        Subsystem: Dell Wireless 1510 Wireless-N WLAN Mini-Card

Used channel is channel 13, 2.472GHz, AP is AVM 7112, "G-only" mode.

Regards,

Stefan


-- 
Stefan Brüns  /  Bergstraße 21  /  52062 Aachen
phone: +49 241 53809034     mobile: +49 151 50412019
