Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55719 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZLVPVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:21:19 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] compat: Build fixes for compat-wireless
Date: Tue, 22 Dec 2009 16:19:59 +0100
Message-Id: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some fixes for compat.git and compat-wireless.git
Build test for kernel 2.6.27 to 2.6.33 was successfull.
For kernel 2.6.25 and 2.6.26 debugfs_remove_recursive is still missing.

PS: The last compat-wireless package at 
http://wireless.kernel.org/download/compat-wireless-2.6/ is 2009-12-11.

--
Hauke

---
Hauke Mehrtens (2):
  compat: Backport pcmcia from 2.6.33
  compat: autoconf.h moved from linux/ to generated/ with kernel 2.6.33

 compat/Makefile               |    1 +
 compat/compat-2.6.33.c        |  130 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.14.h |    3 +-
 include/linux/compat-2.6.18.h |    3 +-
 include/linux/compat-2.6.19.h |    2 +-
 include/linux/compat-2.6.21.h |    2 +-
 include/linux/compat-2.6.22.h |    2 +-
 include/linux/compat-2.6.23.h |    2 +-
 include/linux/compat-2.6.24.h |    3 +-
 include/linux/compat-2.6.25.h |    2 +-
 include/linux/compat-2.6.26.h |    2 +-
 include/linux/compat-2.6.27.h |    2 +-
 include/linux/compat-2.6.28.h |    2 +-
 include/linux/compat-2.6.29.h |    2 +-
 include/linux/compat-2.6.30.h |    3 +-
 include/linux/compat-2.6.31.h |    2 +-
 include/linux/compat-2.6.32.h |    2 +-
 include/linux/compat-2.6.33.h |   25 +++++++-
 include/linux/compat-2.6.h    |    6 ++-


Hauke Mehrtens (3):
  compat-wireless: Activate ssb and libertas
  compat-wireless: activate usbnet for kernel > 2.6.28
  compat-wireless: Add more functions into netdev oops backport

 Makefile                                |    4 +--
 config.mk                               |   17 +++++++--
 patches/01-netdev.patch                 |   28 +++++++++++++--
 patches/18-rename-usb-net-symbols.patch |   58 +++++++++++++++++++++++++++++++
 patches/99-change-makefiles.patch       |   21 +++++------
 scripts/admin-update.sh                 |    8 ++--
 6 files changed, 109 insertions(+), 27 deletions(-)
 create mode 100644 patches/18-rename-usb-net-symbols.patch

