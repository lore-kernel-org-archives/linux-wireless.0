Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34089 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933438AbcIGHtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 03:49:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id w12so1573548wmf.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2016 00:49:45 -0700 (PDT)
Received: from automatix.localnet (net-93-147-4-153.cust.dsl.teletu.it. [93.147.4.153])
        by smtp.gmail.com with ESMTPSA id q65sm2770791wmd.24.2016.09.07.00.49.43
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Sep 2016 00:49:44 -0700 (PDT)
From: Valerio Passini <valerio.passini@unicam.it>
To: linux-wireless@vger.kernel.org
Subject: Stability connection problems in ath9k kernel 4.7
Date: Wed, 07 Sep 2016 09:49:42 +0200
Message-ID: <1798564.U2X6r5Zons@automatix> (sfid-20160907_095006_868179_B7BDE5A2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have found some connection problems since 4.7 release using ath9k that turn 
the wifi pretty useless, I think it might be something in the power management 
because the signal seems really low. Previously, up to kernel 4.6.7 everything 
worked very well.
This is a sample of dmesg in kernel 4.7.2:
 239.898935] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX 
[  239.919995] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3) 
[  239.931877] wlp4s0: authenticated 
[  239.932357] wlp4s0: associate with XX:XX:XX:XX:XX:XX  (try 1/3) 
[  239.942171] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431 
status=0 aid=2) 
[  239.942301] wlp4s0: associated 
[  244.802853] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 
AR_DIAG_SW=0x02000020 DMADBG_7=0x0000
6100                                                                                                         
[  245.931832] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX  
[  245.953028] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3) 
[  245.958702] wlp4s0: authenticated 
[  245.960386] wlp4s0: associate withXX:XX:XX:XX:XX:XX  (try 1/3) 
[  245.980543] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431 
status=0 aid=2)

lspci on 4.6.7 kernel:
04:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter 
(rev 01)
        Subsystem: AzureWave AR9485 Wireless Network Adapter
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at f7900000 (64-bit, non-prefetchable) [size=512K]
        Expansion ROM at f7980000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
        Capabilities: [70] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: ath9k
        Kernel modules: ath9k

Probably you need some debugging output, but before recompiling the kernel I 
would like to know if you are interested in any kind of help from me and what 
steps I should take (I'm able to help in testing patches but I'm not familiar 
with git). Thank you

Valerio
