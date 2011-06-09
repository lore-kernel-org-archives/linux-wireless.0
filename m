Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33039 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab1FIWD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:03:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 00/11] compat-wireless: Add support for kernel 3.XX
Date: Fri, 10 Jun 2011 00:03:31 +0200
Message-Id: <1307657022-23808-1-git-send-email-hauke@hauke-m.de> (sfid-20110610_000402_210197_5DF26742)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mostly add support for kernel 3.XX.
Some of these patches are needing patches for compat.git.

The patches with "Add to compat-3.0-stable" should also be applied to 
linux-3.0.0.y.

The generation of CONFIG_COMPAT_KERNEL_2_6_XX and 
CONFIG_COMPAT_KERNEL_3_XX is not clean, this has to be improved later, 
but it works for now.

v2:
 * integrate comments from Jonas
 * add bcma
 * fix some more patches and add missing bluetooth header
 * rename CONFIG_COMPAT_KERNEL_26XX to CONFIG_COMPAT_KERNEL_2_6_XX

Hauke Mehrtens (11):
  comapt-wireless: move doku to the correct place in config.mk
  compat-wireless: rename CONFIG_COMPAT_KERNEL_
  compat-wireless: add support for kernel 3.XX
  compat-wireless: make patches apply again
  compat-wireless: add missing header
  compat-wireless: activate CARL9170_WPC by default
  compat-wireless: activate CONFIG_RT2800{USB,PCI}_RT35XX by default.
  compat-wireless: sync atheros-debug.mk with config.mk
  compat-wireless: update enable-older-kernels patches
  compat-wireless: add missing bluetooth header
  compat-wireless: add bcma

 Makefile                                 |    2 +-
 config.mk                                |  128 +++++++++-------
 defconfigs/atheros-debug.mk              |  253 ++++++++++++++++++------------
 enable-older-kernels/enable-2.6.21.patch |   12 +-
 enable-older-kernels/enable-2.6.22.patch |   12 +-
 enable-older-kernels/enable-2.6.23.patch |   12 +-
 patches/08-rename-config-options.patch   |   10 +-
 patches/09-threaded-irq.patch            |   30 ++--
 patches/35-fix-makefile-includes.patch   |   10 +-
 scripts/admin-update.sh                  |    7 +-
 scripts/gen-compat-autoconf.sh           |    9 +-
 11 files changed, 282 insertions(+), 203 deletions(-)

-- 
1.7.4.1

