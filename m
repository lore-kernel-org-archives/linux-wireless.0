Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55095 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1KHNB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:01:26 -0500
Received: by faan17 with SMTP id n17so473311faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 05:01:25 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, linville@tuxdriver.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] ath: Fix NULL ptr dereference in ath_reg_apply_world_flags
Date: Tue,  8 Nov 2011 14:01:13 +0100
Message-Id: <1320757273-26298-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111108_140131_058652_51689EE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This happens with devices using a regulatory domain 0x68 that are only
5Ghz capable because ath_reg_apply_active_scan_flags assumes that we
always have a 2,4Ghz band.

CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 82cd838c, ra == 82cd8384
Oops[#1]:
Cpu 0
$ 0 : 00000000 00000061 00000003 00000024
$ 4 : 00000003 000016c1 82f900ac 00000024
$ 8 : 00000000 82cda304 0058bad8 00000005
$12 : 005908f8 001e8481 00000003 1dcd6500
$16 : 00000002 00000000 82c700c0 82c700c0
$20 : 82d415e4 82c70d64 82c70200 82c715bc
$24 : 00000000 11e1a300
$28 : 82ce2000 82ce3c70 82c715a8 82cd8384
Hi : 00000000
Lo : 0000001e
epc : 82cd838c ath_reg_apply_world_flags+0x78/0x17c [ath]
Not tainted
ra : 82cd8384 ath_reg_apply_world_flags+0x70/0x17c [ath]
Status: 1000d403 KERNEL EXL IE
Cause : 80800008
BadVA : 00000000
PrId : 00019374 (MIPS 24Kc)
Modules linked in: ath9k(+) ath9k_common ath9k_hw ath mac80211 cfg80211
	compat_firmware_class compat arc4 aes_generic deflate ecb cbc
	leds_gpio button_hotplug gpio_buttons input_polldev ie
Process insmod (pid: 464, threadinfo=82ce2000, task=838b31d8, tls=00000000)
Stack : 00000000 00000002 82f900ac 82c700c0 82d415e4 82c70d64 00000000 00000068
82f900ac 82cd88f4 82c700c0 82cda304 00000001 000020f0 82f90000 82c70d40
00000002 82f90000 82f900ac 82d4207c 82d518a0 00000002 7fee6118 8017c0d8
00000008 8397ba00 82c70d40 00000000 82c70200 83813000 83813058 b0010000
82d518a0 00000002 7fee6118 82d4b8c8 83445cc0 80120dc0 83804000 800eeda0
...
Call Trace:
[<82cd838c>] ath_reg_apply_world_flags+0x78/0x17c [ath]
[<82cd88f4>] ath_regd_init+0x464/0x488 [ath]
[<82d4207c>] ath9k_init_device+0x6a4/0x6b4 [ath9k]
[<82d4b8c8>] ath_pci_probe+0x27c/0x358 [ath9k]
[<80181de0>] pci_device_probe+0x64/0xa4
[<8019e874>] driver_probe_device+0xb8/0x190
[<8019e9b8>] __driver_attach+0x6c/0xa4
[<8019dfc0>] bus_for_each_dev+0x60/0xb0
[<8019d744>] bus_add_driver+0xc4/0x25c
[<8019ed6c>] driver_register+0xe0/0x198
[<8018206c>] __pci_register_driver+0x50/0xe0
[<82dd0010>] ath9k_init+0x10/0x54 [ath9k]
[<8006b4a0>] do_one_initcall+0x68/0x1ec
[<800a901c>] sys_init_module+0xec/0x23c
[<80062544>] stack_done+0x20/0x3c

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/regd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 028310f..f1be57f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -253,6 +253,8 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	int r;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (!sband)
+		return;
 
 	/*
 	 * If no country IE has been received always enable active scan
-- 
1.7.3.4

