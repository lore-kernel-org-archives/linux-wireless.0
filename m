Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:53650 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1EAHtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 03:49:09 -0400
Received: from [195.4.92.27] (helo=17.mx.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QGROs-00022T-Js
	for linux-wireless@vger.kernel.org; Sun, 01 May 2011 09:49:06 +0200
Received: from p54a1868d.dip0.t-ipconnect.de ([84.161.134.141]:47679 helo=mail.maya.org)
	by 17.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QGROs-0001rM-8Y
	for linux-wireless@vger.kernel.org; Sun, 01 May 2011 09:49:06 +0200
Message-ID: <4DBD10E8.2010308@01019freenet.de> (sfid-20110501_094913_470316_70A9F071)
Date: Sun, 01 May 2011 09:51:04 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: compat_wireless rt2x00 broken with 2.6.34.9: Invalid module format
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

the drivers rt2x00 can be compiled under linux 2.6.34.9 (OpenSuSE
kernel-desktop-2.6.34.9-4.1.x86_64) only with these warnings:

  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/wireless/core.o
/raid/home/andreas/compat-wireless-2011-04-29/net/wireless/core.c:7:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
/raid/home/andreas/compat-wireless-2011-04-29/net/wireless/core.c:7:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/wireless/sysfs.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/mac80211/work.o
  CC [M]
/raid/home/andreas/compat-wireless-2011-04-29/net/wireless/radiotap.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/mac80211/iface.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/wireless/util.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/mac80211/rate.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-04-29/net/wireless/reg.o
  CC [M]
/raid/home/andreas/compat-wireless-2011-04-29/net/mac80211/michael.o
/raid/home/andreas/compat-wireless-2011-04-29/net/wireless/reg.c:36:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
/raid/home/andreas/compat-wireless-2011-04-29/net/wireless/reg.c:36:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-04-29/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition


Afterwards, the modules can't be loaded at all:

modprobe rt2800pci
WARNING: Error inserting rfkill
(/lib/modules/2.6.34.9-4-desktop/kernel/net/rfkill/rfkill.ko): Invalid
module format
WARNING: Error inserting cfg80211
(/lib/modules/2.6.34.9-4-desktop/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.34.9-4-desktop/updates/net/mac80211/mac80211.ko):
Invalid module format
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko):
Invalid module format
WARNING: Error inserting rt2x00pci
(/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko):
Invalid module format
WARNING: Error inserting crc_ccitt
(/lib/modules/2.6.34.9-4-desktop/kernel/lib/crc-ccitt.ko): Invalid
module format
WARNING: Error inserting rt2800lib
(/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800lib.ko):
Invalid module format
FATAL: Error inserting rt2800pci
(/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800pci.ko):
Invalid module format

I tested version compat-wireless-2011-04-22 and compat-wireless-2011-04-30.


compat-wireless-2.6.39-rc1-3 modules can be loaded fine!


Regards,
Andreas
