Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36180 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdGELxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 07:53:13 -0400
Date: Wed, 5 Jul 2017 20:52:58 +0900
From: Carsten Haitzler (The Rasterman) <raster@rasterman.com>
To: linux-wireless@vger.kernel.org
Subject: ath10k QCA6174 not working -> missing data in board2.bin?
Message-Id: <20170705205258.a5ca8ca700de06c5e3c33677@rasterman.com> (sfid-20170705_135317_540289_00A33797)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've scored myself a new laptop. With that come new problems.

I updated to 4.12.0 to make sure i'm on the latest.

lspci says:

01:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac Wireless Network Adapter (rev 32)

So relevant bits from dmesg:

[  124.268483] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[  124.524661] ath10k_pci 0000:01:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 144d:c14f
[  124.524668] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
[  124.526309] ath10k_pci 0000:01:00.0: firmware ver WLAN.RM.4.4.1-00008-QCARMSWP-1 api 6 features wowlan,ignore-otp crc32 bdced4e9
[  124.590884] ath10k_pci 0000:01:00.0: failed to fetch board data for bus=pci,vendor=168c,device=003e,subsystem-vendor=144d,subsystem-device=c14f,variant=K from ath10k/QCA6174/hw3.0/board-2.bin
[  124.590901] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A crc32 ed5f849a
[  125.164076] ath10k_pci 0000:01:00.0: Unknown eventid: 118809
[  125.167113] ath10k_pci 0000:01:00.0: Unknown eventid: 90118

I've tried firmware-6 from:

  https://github.com/kvalo/ath10k-firmware/tree/master/QCA6174/hw3.0

Specifically firmware-6.bin_WLAN.RM.4.4.1-00008-QCARMSWP-1. firmware-4.bin also is a no go.

How can I help make this work? I have all the windows .bin's but none of them
match the same header that the Linux fw bin files have (but a chunk of the
binary seems familiar having a quick binary dump of it). There is some
mysterious way of generating the Linux firmware files I can't google for.

I also have some help from the OEM - the engineers who made the laptop (not
the chip wifi maker though). I have already verified which GPIO lines control
RFkill on this device (and they are clear and unkilled by default - both lines
up at 1 and it's confirmed that this means RF is unblocked from the engineers.
It took me a while to figure out their GPIO mapping table/naming onto kernel
GPIO numbering). So the Wifi (an BT actually) should be powered on. It's a
combo chip.

So how can I help. What data do I need to scrounge to provide. How are firmware
files built to work for Linux (based off the windows ones) for ath10k?

-- 
------------- Codito, ergo sum - "I code, therefore I am" --------------
The Rasterman (Carsten Haitzler)    raster@rasterman.com
