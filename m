Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:42347
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZCUHAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 03:00:50 -0400
Date: Sat, 21 Mar 2009 15:50:06 +0900
From: Mattia Dongili <malattia@linux.it>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Message-ID: <20090321065006.GF3834@kamineko.org> (sfid-20090321_080115_164263_2DFC71BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I get this error consistently with all the recent kernels:
[  338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  598.885036] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[  598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x02AC ser 0x0000004E
[  601.869319] iwl3945: Can't stop Rx DMA.
then the wifi connection becomes useless and I have to re-associate to
the AP or sometimes to unload and reload the module to get my connection
back.

The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies for not
reporting it earlier).  Both my thinkpad x60s and my vaio sz72b are
affected.
Reproducing it is very easy, I just need to download even a small file.

After reading some older bug submissions I rebuilt the driver with debug
support and loaded it with debug=0x43fff, the log is here:
http://kamineko.org/kernel/kern.log
The beginning of the log is 2.6.28 with no debug, then you can see a
reboot and the module loaded with the debug option on 2.6.29-rc8.

Is this a known problem? Is there any other information I can provide to
help fixing it?

Thanks
-- 
mattia
:wq!
