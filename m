Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1521 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab0BPEXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 23:23:53 -0500
Received: from [192.168.0.22] (unknown [72.92.88.10])
	by smtprelay2.cesmail.net (Postfix) with ESMTPSA id 4ED5434C6D
	for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2010 23:33:58 -0500 (EST)
Subject: rt2800pci: corrupted addr3 in probe requests
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 15 Feb 2010 23:23:44 -0500
Message-Id: <1266294224.2951.24.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm trying to get rt2800pci work with my card.  It's Belkin N Wireless
Notebook Card, part no F5D8013, ver 1011.  lspci identifies it as:

04:00.0 Network controller [0280]: RaLink RT2800 802.11n PCI [1814:0601]
        Subsystem: Belkin Device [1799:8013]

wireless-testing was working with the card on Saturday (it must have
been master-2010-02-13), and I tested the patches that are in
wireless-testing now.  Everything was fine.

The testing consisted simply of running wpa_supplicant and seeing it
associate to an AP.

After upgrading to master-2010-02-15, I found that wpa_supplicant would
fail to associate.  The output indicates that at least receiving works,
as the AP is found:

# wpa_supplicant -c /etc/wpa_supplicant/mike1.conf -D nl80211 -i wlan26
CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:25:9c:28:15:62 (SSID='mike1' freq=2437 MHz)
CTRL-EVENT-SCAN-RESULTS 

But Wireshark running on another interface shows that there are probe
requests sent by the card, but there are no replies.  And that's not
surprising, because the BSSID is not exactly the broadcast address:

    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Source address: BelkinIn_07:c8:87 (00:1c:df:07:c8:87)
    BSS Id: ff:ff:ff:ff:1d:56 (ff:ff:ff:ff:1d:56)
    Fragment number: 3
    Sequence number: 1886

0000  00 00 1a 00 2f 48 00 00  02 ea 16 3d 00 00 00 00   ..../H.. ...=....
0010  10 02 85 09 a0 00 d3 01  00 00 40 00 00 00 ff ff   ........ ..@.....
0020  ff ff ff ff 00 1c df 07  c8 87 ff ff ff ff 1d 56   ........ .......V
0030  e3 75                                              .u               

I tried to bisect the problem, but the results are inconclusive.  First
master-2010-02-13 worked, then it didn't.

I also see error messages in the kernel log.  I don't know if they are
related:

[ 1024.210553] phy5 -> rt2x00pci_regbusy_read: Error - Indirect register
access failed: offset=0x00007010, value=0x05100000
[ 1024.211083] phy5 -> rt2x00pci_regbusy_read: Error - Indirect register
access failed: offset=0x00007010, value=0x05100000
[ 1024.211595] phy5 -> rt2x00pci_regbusy_read: Error - Indirect register
access failed: offset=0x00007010, value=0x05100000
[ 1024.231900] phy5 -> rt2800pci_mcu_status: Error - MCU request failed,
no response from hardware

Sometimes there are only two error messages:

[  809.350455] phy5 -> rt2800pci_mcu_status: Error - MCU request failed,
no response from hardware
[  809.470046] phy5: device now idle
[  809.510516] phy5 -> rt2800pci_mcu_status: Error - MCU request failed,
no response from hardware

-- 
Regards,
Pavel Roskin
