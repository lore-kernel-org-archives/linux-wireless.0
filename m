Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.95.110]:26836 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2DHLcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 07:32:46 -0400
Received: from s87.loopia.se (localhost [127.0.0.1])
	by s87.loopia.se (Postfix) with ESMTP id 79F381E17167
	for <linux-wireless@vger.kernel.org>; Sun,  8 Apr 2012 13:16:47 +0200 (CEST)
Received: from s87.loopia.se ([127.0.0.1])
	by s87.loopia.se (s87.loopia.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 6Ih8CtWsXqFp for <linux-wireless@vger.kernel.org>;
	Sun,  8 Apr 2012 13:16:47 +0200 (CEST)
Received: from s328.loopia.se (s34.loopia.se [194.9.94.70])
	by s87.loopia.se (Postfix) with ESMTP id 2CE3F1DE4D9B
	for <linux-wireless@vger.kernel.org>; Sun,  8 Apr 2012 13:16:47 +0200 (CEST)
Received: from 78-69-68-166-no170.tbcn.telia.com (HELO ymer.localnet) (jan@simonson.se@[78.69.68.166])
          (envelope-sender <jan@simonson.se>)
          by s328.loopia.se (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 8 Apr 2012 11:16:47 -0000
From: Jan Simonson <jan@simonson.se>
To: linux-wireless@vger.kernel.org
Reply-To: jan@simonson.se
Subject: RTL8192e-pci NIC
Date: Sun, 08 Apr 2012 13:16:46 +0200
Message-ID: <1502184.lhzNHmlX61@ymer> (sfid-20120408_133321_708517_65475ACC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm using a Samsung R720 laptop with a RTL8192e-pci NIC and Fedora 16. The 
driver has been in kmod-staging from fusion until recently. Now it is removed 
from staging and instead a driver is included in the kernel pack from Fedora. 
After booting with this new kernel the relevant modules are loaded (see below)
but the wireless connection is not available. Using the module earlier from 
Fusion worked most of the time and better and better over time.

[root@ymer ~]# uname -r
3.3.0-8.fc16.x86_64
[root@ymer ~]# lsmod|grep rtl
rtl8192se              93742  0 
rtlwifi               104513  1 rtl8192se
mac80211              496450  2 rtl8192se,rtlwifi
cfg80211              195558  2 rtlwifi,mac80211
[root@ymer ~]# modinfo rtl8192se
filename:       
/lib/modules/3.3.0-8.fc16.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko
firmware:       rtlwifi/rtl8192sefw.bin
description:    Realtek 8192S/8191S 802.11n PCI wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Realtek WlanFAE <wlanfae@realtek.com>
author:         lizhaoming      <chaoming_li@realsil.com.cn>
alias:          pci:v000010ECd00008174sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008173sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008172sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008171sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008192sv*sd*bc*sc*i*
depends:        rtlwifi,mac80211
intree:         Y
vermagic:       3.3.0-8.fc16.x86_64 SMP mod_unload 
parm:           swenc:Set to 1 for software crypto (default 0)
 (bool)
parm:           ips:Set to 0 to not use link power save (default 1)
 (bool)
parm:           swlps:Set to 1 to use SW control power save (default 0)
 (bool)
parm:           fwlps:Set to 1 to use FW control power save (default 1)
 (bool)
parm:           debug:Set debug level (0-5) (default 0) (int)
[root@ymer ~]# lspci -nnv
snip---
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. 
RTL8192E/RTL8192SE Wireless LAN Controller [10ec:8192] (rev 01)
        Subsystem: Askey Computer Corp. Device [144f:7160]
        Flags: fast devsel, IRQ 16
        I/O ports at 3000 [size=256]
        Memory at f6000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 93-8a-a9-fe-ff-d2-24-00
        Kernel modules: rtl8192se
snip---
[root@ymer ~]#

What is wrong and what shall I do to make the NIC function?

Best regards
Jan Simonson
