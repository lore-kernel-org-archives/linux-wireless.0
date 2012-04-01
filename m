Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DASUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 14:20:12 -0400
Received: by iagz16 with SMTP id z16so3164770iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2012 11:20:11 -0700 (PDT)
Message-ID: <4F789C57.2090903@lwfinger.net> (sfid-20120401_202017_997743_56987651)
Date: Sun, 01 Apr 2012 13:20:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Kernel Panics from ath9k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few weeks ago, I was trying to help an inexperienced user on the openSUSE 
Wireless Forum who was having "crashes" caused by his AR9285 device. The crash 
turned out to be a kernel panic. As expected, I was not able to help him, and I 
ordered one of these cards through E-bay. It just arrived, and I am able to 
duplicate the panics. For me, they occur when changing from a WPA2-encrypted AP 
to one with WPA encryption. When switching from WPA2 to WEP, the NULL 
dereference does not occur; however, the connection fails.

I captured enough info from the debugging console to know that the panic results 
from "BUG: unable to handle kernel NULL pointer dereference at (null)" that 
originates at ath_tx_start+0x2c0/0x4b0. The kernel is x86_64 and I am currently 
testing kernel v3.4-rc1-214-g1ac7a92 from Linus's tree. I have not yet tested 
the wireless-testing tree, but I do not see any commits there that appear to 
address this issue.

The address of the traceback translates to line 1878 of 
drivers/net/wireless/ath/ath9k/xmit.c, which is (ironically) a WARN_ON that says

                 WARN_ON(tid->ac->txq != txctl->txq);

By testing each of the pointers in the above statement, I determined that 
tid->ac is NULL. Note: This statement is actually in ath_tx_start_dma(), which 
appears to be in-lined by the compiler. My tests process the pointers from left 
to right, and txctl or txctl->txq may also be NULL. The setting of tid is done with

                 tid = ATH_AN_2_TID(txctl->an, tidno);

I have not traced this any further yet to see why tid is not correct.

The full lspci output for my device is

06:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) [168c:002b] (rev 01)
         Subsystem: Accton Technology Corporation Device [1113:d811]
         Flags: bus master, fast devsel, latency 0, IRQ 20
         Memory at f8000000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
         Capabilities: [60] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
         Capabilities: [170] Power Budgeting <?>
         Kernel driver in use: ath9k

I will be happy to provide any further information that may be required.

Larry
