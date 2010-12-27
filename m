Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49088 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0L0SKJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 13:10:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PXHWH-0008LL-9J
	for linux-wireless@vger.kernel.org; Mon, 27 Dec 2010 19:10:05 +0100
Received: from devbox.leverton.org ([217.155.219.12])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 19:10:05 +0100
Received: from nick by devbox.leverton.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 19:10:05 +0100
To: linux-wireless@vger.kernel.org
From: Nick Leverton <nick@leverton.org>
Subject: printk %pV compatibility in b43 and ath for compat-wireless
Date: Mon, 27 Dec 2010 18:05:54 +0000 (UTC)
Message-ID: <loom.20101227T190514-850@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using compat-wireless with Debian 2.6.32 (kernel for forthcoming Debian 6.0 
release).  It mostly works well but one thing that has crept in recently is the 
use of new printk features such as %pV which old kernels don't support.  I 
noticed this whilst trying the new b43 n-phy code (for which much thanks to 
everyone involved), as I get kernel messages printed of the following form:

Dec 23 21:10:46 nickl kernel: [688182.007780] Broadcom 43xx driver loaded [ 
Features: PMNLS, Firmware-ID: FW13 ]
Dec 23 21:10:50 nickl kernel: [688186.100195] b43-phy0: f535bb54
Dec 23 21:10:50 nickl kernel: [688186.198711] ADDRCONF(NETDEV_UP): wlan0: link 
is not ready
Dec 23 21:11:09 nickl kernel: [688205.048054] b43-phy0: f4a3bb54
Dec 23 21:11:09 nickl kernel: [688205.145589] ADDRCONF(NETDEV_UP): wlan0: link 
is not ready
Dec 23 21:11:20 nickl kernel: [688216.484744] ADDRCONF(NETDEV_CHANGE): wlan0: 
link becomes ready
Dec 23 21:11:31 nickl kernel: [688225.667842] b43-phy0 ERROR: f56a5f34
Dec 23 21:12:14 nickl kernel: [688235.585265] b43-phy0 ERROR: f56a5f34
Dec 23 21:12:50 nickl kernel: [688270.140937] b43-phy0 ERROR: f56a5f34
Dec 23 21:13:11 nickl kernel: [688306.427195] b43-phy0 ERROR: f56a5f34
Dec 23 21:14:05 nickl kernel: [688327.492370] b43-phy0 ERROR: f56a5f34
Dec 23 21:16:23 nickl kernel: [688381.712250] b43-phy0 ERROR: f56a5f34
Dec 23 21:22:59 nickl kernel: [688518.942314] b43-phy0 ERROR: f56a5f34
Dec 23 21:23:00 nickl kernel: [688529.935161] b43-phy0 ERROR: f56a5f34

As of 20101223, the following code uses %pV, some of which can be seen above:

./drivers/net/wireless/b43/main.c:      printk(KERN_INFO "b43-%s: %pV",
./drivers/net/wireless/b43/main.c:      printk(KERN_ERR "b43-%s ERROR: %pV",
./drivers/net/wireless/b43/main.c:      printk(KERN_WARNING "b43-%s 
warning: %pV",
./drivers/net/wireless/b43/main.c:      printk(KERN_DEBUG "b43-%s debug: %pV",
./drivers/net/wireless/ath/main.c:      rtn = printk("%sath: %pV", level, 
&vaf);
./drivers/net/wireless/b43legacy/main.c:        
printk(KERN_INFO "b43legacy-%s: %pV",
./drivers/net/wireless/b43legacy/main.c:        printk(KERN_ERR "b43legacy-%s 
ERROR: %pV",
./drivers/net/wireless/b43legacy/main.c:        
printk(KERN_WARNING "b43legacy-%s warning: %pV",
./drivers/net/wireless/b43legacy/main.c:        printk(KERN_DEBUG "b43legacy-%s 
debug: %pV",

It would be useful to know the error message behind the vararg !

I tried applying the patches which introduced %pV to kernel.org, but 2.6.32 is 
too old.  Could this be fixed either in the compat b43 driver or in a compat 
back-feature, please ?

Thankyou

Nick

