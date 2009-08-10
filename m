Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:42855 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZHJORc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 10:17:32 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-zigbee-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Sergey Lapin <slapin@ossfans.org>
Subject: [RFC 0/2] Software implementation of IEEE 802.15.4
Date: Mon, 10 Aug 2009 18:16:38 +0400
Message-Id: <1249913800-10176-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

In this (small) patchset we'd like to present the grounds of our software
IEEE 802.15.4 MAC implementation. Especially this patchset contains only
packet dissection and data path (in generic parts) and virtual loopback
driver (as an example user).

Please review.

Dmitry Eremin-Solenikov (2):
      mac802154: add a software MAC 802.15.4 implementation
      ieee802154: add virtual loopback driver

 MAINTAINERS                 |    1 +
 drivers/ieee802154/Kconfig  |   13 +
 drivers/ieee802154/Makefile |    1 +
 drivers/ieee802154/fakelb.c |  255 ++++++++++++
 include/linux/mac802154.h   |   35 ++
 include/net/mac802154.h     |  106 +++++
 net/Kconfig                 |    1 +
 net/Makefile                |    1 +
 net/mac802154/Kconfig       |   17 +
 net/mac802154/Makefile      |    4 +
 net/mac802154/dev.c         |  924 +++++++++++++++++++++++++++++++++++++++++++
 net/mac802154/mac802154.h   |   85 ++++
 net/mac802154/mac_cmd.c     |   99 +++++
 net/mac802154/mdev.c        |  295 ++++++++++++++
 net/mac802154/mib.h         |   32 ++
 net/mac802154/rx.c          |   98 +++++
 16 files changed, 1967 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ieee802154/fakelb.c
 create mode 100644 include/linux/mac802154.h
 create mode 100644 include/net/mac802154.h
 create mode 100644 net/mac802154/Kconfig
 create mode 100644 net/mac802154/Makefile
 create mode 100644 net/mac802154/dev.c
 create mode 100644 net/mac802154/mac802154.h
 create mode 100644 net/mac802154/mac_cmd.c
 create mode 100644 net/mac802154/mdev.c
 create mode 100644 net/mac802154/mib.h
 create mode 100644 net/mac802154/rx.c


