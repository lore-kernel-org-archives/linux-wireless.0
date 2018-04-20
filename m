Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-1857040130.protonmail.ch ([185.70.40.130]:36272 "EHLO
        mail-1857040130.protonmail.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753541AbeDTHHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 03:07:41 -0400
Date: Fri, 20 Apr 2018 02:49:16 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Anichang <anichang@protonmail.ch>
Reply-To: Anichang <anichang@protonmail.ch>
Subject: ath9k and AR9220 (Mikrotik R52N) initialization error on old small router (Asus WL-500g Premium v1)
Message-ID: <kYongBLbYjUNzhU8bwJob4q8LdrN26YvvO1Jr2JrIsPKX8vn6CYvTQiSXAladjuCU7YO9HtTGwT_jKzOYIyRJW8PdE70BXRFINCPDl_sXZE=@protonmail.ch> (sfid-20180420_090744_963142_1E6C62C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having issues with a Mikrotik R52N mini-pci board (AR9220) on the old A=
sus WL-500g Premium v1 and Openwrt/LEDE 17.01.4 (compat-wireless-2017-01-31=
).=20

Dmesg reports:

[  942.063606] ssb: PCI: Fixing up device 0000:00:02.0
[  942.073038] ath: phy3: address test failed addr: 0x00008000 - wr:0x55555=
555 !=3D rd:0x45555555
[  942.081787] ath: phy3: Unable to initialize hardware; initialization sta=
tus: -19
[  942.089390] ath9k 0000:00:02.0: Failed to initialize device

lspci -v

00:02.0 Network controller: Qualcomm Atheros AR922X Wireless Network Adapte=
r (rev 01)
        Subsystem: Qualcomm Atheros Device 4205
        Flags: 66MHz, medium devsel, IRQ 6
        Memory at 40000000 (32-bit, non-prefetchable) [size=3D65537]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=3D2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=3D2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=3D2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=3D2]
        Memory at <unassigned> (32-bit, non-prefetchable) [size=3D2]
        Expansion ROM at <unassigned> [disabled] [size=3D2]
        Capabilities: [44] Power Management version 2

It looks like an old problem: https://forum.openwrt.org/viewtopic.php?pid=
=3D97509#p97509 .

I tried to comment out the call to ath9k_hw_chip_test function without resu=
lts. Then I tried to randomly change some addresses I've found up and there=
 but I didn't get any clue about the driver so ... here I am.

Any idea?

Thanks

Anichang
