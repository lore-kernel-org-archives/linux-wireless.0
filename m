Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:33523 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab1EBP7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 11:59:19 -0400
Received: from [195.4.92.11] (helo=1.mx.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QGvWm-0001B9-UK
	for linux-wireless@vger.kernel.org; Mon, 02 May 2011 17:59:16 +0200
Received: from p54a185ed.dip0.t-ipconnect.de ([84.161.133.237]:44645 helo=mail.maya.org)
	by 1.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QGvWm-0002Uk-Jb
	for linux-wireless@vger.kernel.org; Mon, 02 May 2011 17:59:16 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p42FxCvW002586
	for <linux-wireless@vger.kernel.org>; Mon, 2 May 2011 17:59:13 +0200
Message-ID: <4DBED54F.4020108@01019freenet.de> (sfid-20110502_175922_778453_3D3AAE4F)
Date: Mon, 02 May 2011 18:01:19 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Please fix compat-wireless for 2.6.34.9
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!


compat-wireless doesn't work anymore with kernel 2.6.34.9. The modules
can be build, but not loaded afterwards:

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


During compile, the following warnings are coming up:

  CC [M]  /raid/home/andreas/compat-wireless-2011-05-01/net/wireless/core.o
/raid/home/andreas/compat-wireless-2011-05-01/net/wireless/core.c:7:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
/raid/home/andreas/compat-wireless-2011-05-01/net/wireless/core.c:7:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
  CC [M]  /raid/home/andreas/compat-wireless-2011-05-01/net/wireless/sysfs.o
  CC [M]
/raid/home/andreas/compat-wireless-2011-05-01/net/wireless/radiotap.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-05-01/net/wireless/util.o
  LD
/raid/home/andreas/compat-wireless-2011-05-01/net/mac80211/built-in.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-05-01/net/mac80211/main.o
  CC [M]  /raid/home/andreas/compat-wireless-2011-05-01/net/wireless/reg.o
/raid/home/andreas/compat-wireless-2011-05-01/net/wireless/reg.c:36:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition
/raid/home/andreas/compat-wireless-2011-05-01/net/wireless/reg.c:36:1:
warning: "pr_fmt" redefined
In file included from /usr/src/linux-2.6.34.9-4/include/linux/skbuff.h:17,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/if_ether.h:124,
                 from
/usr/src/linux-2.6.34.9-4/include/linux/netdevice.h:29,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.29.h:5,
                 from
/raid/home/andreas/compat-wireless-2011-05-01/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
/usr/src/linux-2.6.34.9-4/include/linux/kernel.h:387:1: warning: this is
the location of the previous definition



Thank you,
Andreas
