Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15787 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZI2CfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 22:35:20 -0400
Received: by ey-out-2122.google.com with SMTP id 4so192942eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 19:35:22 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Sep 2009 03:35:22 +0100
Message-ID: <3ace41890909281935k284402f3q90b54ae20a636eeb@mail.gmail.com>
Subject: compat-wireless master-2009-09-28 breakage and suggested fixes
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

A couple of breakages against current wireless testing head:

compat-release  - master-2009-09-23-1-gd1e5747
git-describe  v2.6.32-rc1-39226-g63dbea4
master-tag master-2009-09-28

-----------
make[1]: Entering directory `/usr/src/kernels/2.6.30.8-67.fc11.x86_64'
  CC [M]  /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/main.o
In file included from
/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/main.c:29:
/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/ieee80211_i.h:1053:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘ieee80211_monitor_start_xmit’
/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/ieee80211_i.h:1055:
error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘ieee80211_subif_start_xmit’
make[3]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/main.o]
Error 1
make[2]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211] Error 2
make[1]: *** [_module_/home/Hin-Tak/tmp-git/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.30.8-67.fc11.x86_64'
make: *** [modules] Error 2
----------

----------
  CC [M]  /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/iface.o
/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/iface.c: In
function ‘ieee80211_if_add’:
/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/iface.c:815:
error: implicit declaration of function ‘SET_NETDEV_DEVTYPE’
make[3]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211/iface.o]
Error 1
make[2]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/net/mac80211] Error 2
make[1]: *** [_module_/home/Hin-Tak/tmp-git/compat-wireless-2.6] Error 2
----------

The first error can be fixed by inserting the netdev_tx_t enum:

----------------
$ diff -u ../wireless-testing/net/mac80211/ieee80211_i.h
net/mac80211/ieee80211_i.h
--- ../wireless-testing/net/mac80211/ieee80211_i.h	2009-09-29
01:21:11.000000000 +0100
+++ net/mac80211/ieee80211_i.h	2009-09-29 02:43:26.000000000 +0100
@@ -28,6 +28,24 @@
 #include "key.h"
 #include "sta_info.h"

+#ifdef NETDEV_TX_OK
+#undef NETDEV_TX_OK
+#endif
+#ifdef NETDEV_TX_BUSY
+#undef NETDEV_TX_BUSY
+#endif
+#ifdef NETDEV_TX_LOCKED
+#undef NETDEV_TX_LOCKED
+#endif
+
+/* Driver transmit return codes */
+enum netdev_tx {
+       NETDEV_TX_OK = 0,       /* driver took care of packet */
+       NETDEV_TX_BUSY,         /* driver tx path was busy*/
+       NETDEV_TX_LOCKED = -1,  /* driver tx lock was already taken */
+};
+typedef enum netdev_tx netdev_tx_t;
+
 struct ieee80211_local;

 /* Maximum number of broadcast/multicast frames to buffer when some of the
------------------

The 2nd by adding SET_NETDEV_DEVTYPE():
----------
--- ../wireless-testing/net/mac80211/iface.c	2009-09-29 01:21:11.000000000 +0100
+++ net/mac80211/iface.c	2009-09-29 02:50:54.000000000 +0100
@@ -22,6 +22,8 @@
 #include "led.h"
 #include "driver-ops.h"

+#define SET_NETDEV_DEVTYPE(net, devtype)       ((net)->dev.type = (devtype))
+
 /**
  * DOC: Interface list locking
  *
-------------

The first change is due to this:

commit d0cf9c0dadcdc89a755bcb301cfc9c796eb28ccf
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Mon Aug 31 19:50:57 2009 +0000

    wireless: convert drivers to netdev_tx_t

and the 2nd change due to this:

commit 384912ed194e43c03ad1cdaa09b0b1e488c34d46
Author: Marcel Holtmann <marcel@holtmann.org>
Date:   Mon Aug 31 21:08:19 2009 +0000

    net: Add DEVTYPE support for Ethernet based devices

Both of these changes are traced back to changes in
<linux/netdevice.h> , which compat-wireless does not ship. What's your
policy on these kind of changes to compat-wireless?
(the 2nd SET_NETDEV_DEVTYPE change probably can be spanned by an
ifndef SET_NETDEV_DEVTYPE, and roll into
"compat/patches/01-netdev.patch"? Should the first kind of change also
go into compat/patches/01-netdev.patch?)
