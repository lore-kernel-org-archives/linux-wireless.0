Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39283 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab2DZSIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 0/9] compat-wireless: restructure header files in compat
Date: Thu, 26 Apr 2012 20:07:41 +0200
Message-Id: <1335463674-13003-1-git-send-email-hauke@hauke-m.de> (sfid-20120426_200811_897687_43DE405B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch series moves the compat code from include/linux/compat-*.h 
into new files with the same name as the file where this code is placed 
in the mainline kernel. With this approach we do not have to include 
all include/linux/compat-*.h files in the build process any more, but 
we extend the existing header files by the code needed.

This compiles without any warnings for me with kernel 3.2 to 3.4 and 
fixes the problems with pr_fmt() without the need of any patch.
Sometimes I had problems compiling compat-wireless, because some header 
file I would not like to include was included because of compat-2.6.h 
included mostly every header file available in the kernel.

This patch series is only done to support kernel >= 3.2, supporting the 
other versions is just more work, but I want to have some responses on 
this first. There are probably some other problems and some more 
cleanup is possible.
In the end we will remove the include/linux/compat-*.h files.

I have a problem where compat does changes to header files provided by 
compat-wireless like #define NL80211_FEATURE_SK_TX_STATUS 0 in compat-
2.6.33.h. To make this work we should add an other include directory in 
compat-wireless.
The hierarchy of include directories should be this: 1. include dir 
from compat, 2. include dir from compat-wireless, 3. the kernel include 
dir, now the 1. and the 2. are but into one directory.

This patch series or a more recent version can also be found on github:
https://github.com/hauke/compat/commits/header-new
https://github.com/hauke/compat-wireless/commits/header-new

Hauke Mehrtens (9):
  compat: move compat_system_workqueue_{create,destroy} and
    compat_pm_qos_power_{init,deinit}
  compat: include compat_autoconf.h
  compat: move br_port_exists
  compat: move netdev_attach_ops
  compat: move compat_pci_{suspend,resume}
  compat: move simple_open()
  compat: move code from compat-3.4.h
  compat: move code from compat-3.3.h
  compat: do not include compat-2.6.h

 Makefile                        |    1 -
 compat/compat-2.6.36.c          |    1 +
 compat/compat.h                 |   66 ++++++++++++
 compat/main.c                   |    1 +
 compat/pm_qos_params.c          |    1 +
 include/generated/autoconf.h    |    2 +
 include/linux/compat-2.6.25.h   |   39 -------
 include/linux/compat-2.6.28.h   |    3 -
 include/linux/compat-2.6.29.h   |  219 ---------------------------------------
 include/linux/compat-2.6.36.h   |   28 -----
 include/linux/compat-3.3.h      |   44 --------
 include/linux/compat-3.4.h      |   67 ------------
 include/linux/compat-3.5.h      |    2 -
 include/linux/compat.h          |   21 ++++
 include/linux/device.h          |   38 +++++++
 include/linux/etherdevice.h     |   51 +++++++++
 include/linux/fs.h              |   14 +++
 include/linux/if.h              |   28 +++++
 include/linux/netdev_features.h |   22 ++++
 include/linux/netdevice.h       |  205 ++++++++++++++++++++++++++++++++++++
 include/linux/pci.h             |   63 +++++++++++
 include/linux/rfkill.h          |    2 -
 include/linux/skbuff.h          |   34 ++++++
 include/linux/usb.h             |   24 +++++
 24 files changed, 571 insertions(+), 405 deletions(-)
 create mode 100644 compat/compat.h
 create mode 100644 include/generated/autoconf.h
 create mode 100644 include/linux/compat.h
 create mode 100644 include/linux/device.h
 create mode 100644 include/linux/etherdevice.h
 create mode 100644 include/linux/fs.h
 create mode 100644 include/linux/if.h
 create mode 100644 include/linux/netdev_features.h
 create mode 100644 include/linux/netdevice.h
 create mode 100644 include/linux/pci.h
 create mode 100644 include/linux/skbuff.h
 create mode 100644 include/linux/usb.h


Hauke Mehrtens (4):
  compat-wireless: fix header of compat-autoconf.h
  compat-wireless: also copy include/generated/ from compat
  compat-wireless: do not include linux/compat-2.6.h any more
  compat-wireless: copy *.h files from compat/compat

 Makefile                       |    1 -
 patches/53-pr_fmt.patch        |  823 ----------------------------------------
 scripts/admin-update.sh        |    3 +
 scripts/gen-compat-autoconf.sh |    4 +-
 4 files changed, 4 insertions(+), 827 deletions(-)
 delete mode 100644 patches/53-pr_fmt.patch
-- 
1.7.9.5

