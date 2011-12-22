Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55503 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1LVUrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/6] compat-wireless: various fixes
Date: Thu, 22 Dec 2011 21:47:24 +0100
Message-Id: <1324586850-5212-1-git-send-email-hauke@hauke-m.de> (sfid-20111222_214748_878408_B1094141)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This make compat-wireless apply against current linux-next and build 
with kernel version from 2.6.27 to 3.2. This series just contains some 
patches handing some recent changes in linux-next nothing special.

Hauke Mehrtens (6):
  compat-wireless: compile fix for commit patches/09-threaded-irq.patch
  compat-wireless: remove platform_device_id for kernel < 2.6.30
  compat-wireless: CONFIG_BT_L2CAP and CONFIG_BT_SCO removed
  compat-wireless: make patches apply again
  compat-wireless: use other workqueue
  compat-wireless: no trans_start on netdev_queue

 config.mk                                       |    2 -
 patches/08-rename-config-options.patch          |   29 +------------
 patches/09-threaded-irq.patch                   |   22 +++++-----
 patches/29-sdio_no_suspend.patch                |   47 +++++++++++++++-------
 patches/31-backport-sk_add_backlog.patch        |   24 ------------
 patches/35-fix-makefile-includes.patch          |    4 +-
 patches/45-remove-platform-id-table.patch       |   23 +++++++++++
 patches/46-use_other_workqueue.patch            |   15 +++++++
 patches/47-no_trans_start_on_netdev_queue.patch |   13 ++++++
 9 files changed, 99 insertions(+), 80 deletions(-)
 delete mode 100644 patches/31-backport-sk_add_backlog.patch
 create mode 100644 patches/45-remove-platform-id-table.patch
 create mode 100644 patches/46-use_other_workqueue.patch
 create mode 100644 patches/47-no_trans_start_on_netdev_queue.patch

-- 
1.7.5.4

