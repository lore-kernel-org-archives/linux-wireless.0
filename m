Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55973 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2BAAGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 19:06:31 -0500
Received: by pbdu11 with SMTP id u11so600210pbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 16:06:31 -0800 (PST)
MIME-Version: 1.0
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Wed, 1 Feb 2012 01:06:01 +0100
Message-ID: <CAO=xpBGCABtjPstHcxcPHL7MGXSa7nQw4ZtwJkfZiTq=DPAE1w@mail.gmail.com> (sfid-20120201_010635_177582_99D3F3D9)
Subject: compat-wireless can't compile under kernel 3.2.0 both 3.3-rc1-2 and
 2012-01-26 - error: missing binary operator before token "("
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm facing a bug you fixed in compat-wireless-3.3-rc1-2: rt2800pci:
fix spurious interrupts generation
But I must run a 3.2.0 kernel with some patches for my display driver
(cause I'm greedy and I want both to see the screen and access
internet)

I tested in kernel 3.0.0 and I can compile and see the bug is fixed.

but when I try to compile under 3.2.0 I get the following error:

$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/3.2.0-interlaced2+/build
M=/home/alfonso/wifi/compat-wireless-2012-01-26 modules
make[1]: Entering directory `/home/alfonso/tests/kernel/linux_keithp'
  LD      /home/alfonso/wifi/compat-wireless-2012-01-26/compat/built-in.o
  CC [M]  /home/alfonso/wifi/compat-wireless-2012-01-26/compat/main.o
In file included from include/net/net_namespace.h:13:0,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/net/net_namespace.h:7,
                 from include/linux/netdevice.h:49,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.29.h:5,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/net/netns/mib.h:15:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/net/netns/mib.h:15:15: error: missing binary operator before token "("
In file included from include/net/net_namespace.h:23:0,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/net/net_namespace.h:7,
                 from include/linux/netdevice.h:49,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.29.h:5,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/net/netns/xfrm.h:59:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/net/netns/xfrm.h:59:15: error: missing binary operator before token "("
In file included from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/net/net_namespace.h:7:0,
                 from include/linux/netdevice.h:49,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.29.h:5,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/net/net_namespace.h:80:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/net/net_namespace.h:80:15: error: missing binary operator
before token "("
In file included from include/linux/netdevice.h:54:0,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.29.h:5,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/net/netprio_cgroup.h: In function âtask_netprio_stateâ:
include/net/netprio_cgroup.h:44:5: warning: "IS_ENABLED" is not
defined [-Wundef]
include/net/netprio_cgroup.h:44:15: error: missing binary operator
before token "("
In file included from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.29.h:5:0,
                 from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:24,
                 from <command-line>:0:
include/linux/netdevice.h: At top level:
include/linux/netdevice.h:147:39: error: missing binary operator
before token "("
include/linux/netdevice.h:153:7: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:153:17: error: missing binary operator
before token "("
include/linux/netdevice.h:159:6: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:159:16: error: missing binary operator
before token "("
include/linux/netdevice.h:964:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:964:15: error: missing binary operator
before token "("
include/linux/netdevice.h:981:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:981:15: error: missing binary operator
before token "("
include/linux/netdevice.h:1123:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:1123:15: error: missing binary operator
before token "("
include/linux/netdevice.h:1126:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:1126:15: error: missing binary operator
before token "("
include/linux/netdevice.h:1289:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:1289:15: error: missing binary operator
before token "("
include/linux/netdevice.h:1293:5: warning: "IS_ENABLED" is not defined [-Wundef]
include/linux/netdevice.h:1293:15: error: missing binary operator
before token "("
include/linux/netdevice.h: In function ânetdev_uses_dsa_tagsâ:
include/linux/netdevice.h:1397:9: error: âstruct net_deviceâ has no
member named âdsa_ptrâ
include/linux/netdevice.h:1398:31: error: âstruct net_deviceâ has no
member named âdsa_ptrâ
include/linux/netdevice.h: In function ânetdev_uses_trailer_tagsâ:
include/linux/netdevice.h:1416:9: error: âstruct net_deviceâ has no
member named âdsa_ptrâ
include/linux/netdevice.h:1417:35: error: âstruct net_deviceâ has no
member named âdsa_ptrâ
In file included from
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-2.6.h:38:0,
                 from <command-line>:0:
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-3.3.h:
At top level:
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-3.3.h:28:20:
error: static declaration of âskb_complete_wifi_ackâ follows
non-static declaration
include/linux/skbuff.h:2260:6: note: previous declaration of
âskb_complete_wifi_ackâ was here
/home/alfonso/wifi/compat-wireless-2012-01-26/include/linux/compat-3.3.h:34:13:
error: conflicting types for ânetdev_features_tâ
include/linux/netdev_features.h:15:13: note: previous declaration of
ânetdev_features_tâ was here
make[3]: *** [/home/alfonso/wifi/compat-wireless-2012-01-26/compat/main.o]
Error 1
make[2]: *** [/home/alfonso/wifi/compat-wireless-2012-01-26/compat] Error 2
make[1]: *** [_module_/home/alfonso/wifi/compat-wireless-2012-01-26] Error 2
make[1]: Leaving directory `/home/alfonso/tests/kernel/linux_keithp'
make: *** [modules] Error 2

Thank you for you help,
alfonso
