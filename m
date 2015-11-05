Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.danego.net ([195.246.116.61]:63679 "EHLO smtp.danego.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031084AbbKEKif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 05:38:35 -0500
From: =?iso-8859-1?Q?Robert_Deli=EBn?= <robert@delien.nl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
Subject: ath6kl: SDIO hif-scatter broken?
Date: Thu, 5 Nov 2015 10:38:30 +0000
Message-ID: <6EA3E0BCC03CC34B89B01BD57ECBC718B17A9FA8@POBOX.postoffice.danego.net> (sfid-20151105_113838_763297_02B42131)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is hif-scatter on ath6kl SDIO broken?

I'm using a Digi SOM with a ath6kl connected to a i.MX28 (MXS) over SDIO, a Digi supplied 3.10 Kernel with Digi and own patches, Digi supplied ath6 firmware, and hostapd 2.6 devel.

I can connect to my target's AP and FTP server. Reading small files (~3kB) over FTP works. However, reading a large file (1GB) stalls after 80kB...220kB. At the moment of stall, the following errors are reported by the Kernel:
ath6kl: Scatter write request failed:-110
ath6kl: send scatter req failed: -110
ath6kl: req failed (status:-110, ep:2, len:1528 creds:1)
ath6kl: req failed (status:-110, ep:2, len:1528 creds:1)
ath6kl: tx complete error: -110
ath6kl: tx complete error: -110
<--- cut --->
I don't know if the transfer still continues very slowly or not at all, but I suppose not because in many cases the wireless connection the AP gets lost.

I have rigged the driver with a couple of printk's and it seems that smaller transfers don't use scatter, and that any transfer that does fails. The i.MX28 host supports 52 entries and the driver needs 16, so that's covered.

Changing the firmware into the vanilla version from https://wireless.wiki.kernel.org/en/users/drivers/ath6kl doesn't change anything.

Rigging the driver to force virtual scatter in the ath6kl SDIO driver creates a similar problem: Small transfers work, but large transfers make the firmware crash after ~200kB:
ath6kl: Scatter write request Ok
ath6kl: firmware crashed
ath6kl: crash dump:
ath6kl: hw 0x30000582 fw 3.2.0.251
ath6kl: 0: 0x30000582 0x000015b3 0x008ee731 0x004f5b31
ath6kl: 4: 0x008ee731 0x00060730 0x0000001e 0x00000012
ath6kl: 8: 0x00565bbc 0x00565bfc 0x005693d8 0x005693d8
ath6kl: 12: 0x00000009 0xffffffff 0x00917f9c 0x00917fa7
ath6kl: 16: 0x00917ca7 0x008e1038 0x00000000 0x00000000
ath6kl: 20: 0x408ee731 0x005441b8 0x00000001 0x004f5a00
ath6kl: 24: 0x808ee8c6 0x00544218 0x00565bfc 0xc08ee731
ath6kl: 28: 0x808efa6a 0x00544248 0x00565bbc 0x00000004
ath6kl: 32: 0x808e2756 0x00544278 0x005660d0 0x00000000
ath6kl: 36: 0x808e166c 0x005442a8 0x00000004 0x00542810
ath6kl: 40: 0x808e1640 0x005442d8 0x00540000 0x00000000
ath6kl: 44: 0x808e16bd 0x005442f8 0x00540d14 0x00000000
ath6kl: 48: 0x408e0c24 0x00544318 0x00519291 0x000017a8
ath6kl: 52: 0x00000000 0x00544338 0x00559301 0x00040020
ath6kl: 56: 0x005660d0 0x0f000000 0xf0000000 0x00000001

Again no difference with the vanilla firmware:
ath6kl: Scatter write request Ok
ath6kl: firmware crashed
ath6kl: crash dump:
ath6kl: hw 0x30000582 fw 3.2.0.144?
ath6kl: 0: 0x30000582 0x000015b3 0x008ee731 0x004f5b31
ath6kl: 4: 0x008ee731 0x00060730 0x0000001e 0x00000000
ath6kl: 8: 0x0056526c 0x005652ac 0x00568e88 0x00568e88
ath6kl: 12: 0x00000009 0xffffffff 0x00917f9c 0x00917fa7
ath6kl: 16: 0x00917ca7 0x008e1038 0x00000000 0x00000000
ath6kl: 20: 0x408ee731 0x005441b8 0x00000001 0x004f5a00
ath6kl: 24: 0x808ee8c6 0x00544218 0x0056cf08 0xc08ee731
ath6kl: 28: 0x808efa6a 0x00544248 0x0056526c 0x00000004
ath6kl: 32: 0x808e2756 0x00544278 0x00565780 0x00000000
ath6kl: 36: 0x808e166c 0x005442a8 0x00000004 0x00542810
ath6kl: 40: 0x808e1640 0x005442d8 0x00540000 0x00000000
ath6kl: 44: 0x808e16bd 0x005442f8 0x00540d14 0x00000000
ath6kl: 48: 0x408e0c24 0x00544318 0x00519291 0x000017a8
ath6kl: 52: 0x00000000 0x00544338 0x00559301 0x00040020
ath6kl: 56: 0x00565780 0x0f000000 0xf0000000 0x00000001

Has anybody seen this problem before? Any suggestion would be highly appreciated.