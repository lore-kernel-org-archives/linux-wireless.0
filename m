Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47345 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab0CKVdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:01 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] compat-wireless: various patches
Date: Thu, 11 Mar 2010 22:32:40 +0100
Message-Id: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds orinoco driver and fixes some build and load problems of
recent comapt-wireless.

This series was compile tested with kernel 2.6.27 to 2.6.34
For kernel older than 2.6.27 qdisc_all_tx_empty must be backported.

Hauke Mehrtens (5):
  compat-wireless: rename {free,alloc}_ieee80211 to {free,alloc}_libipw
  compat-wireless: add orinoco to compat-wireless
  compat-wireless: fix building of iwmc3200wifi
  compat-wireless: remove some uneeded header files
  compat-wireless: update config symbols

 config.mk                         |   29 ++++++-
 patches/01-netdev.patch           |   73 +++++++++++++----
 patches/02-ksize.patch            |   25 ++++++
 patches/13-trace.patch            |   19 +++++
 patches/23-ipw.patch              |  161 +++++++++++++++++++++++++++++++++++++
 patches/24-pcmcia.patch           |   14 +++
 patches/99-change-makefiles.patch |    8 +-
 scripts/admin-update.sh           |    5 +-
 8 files changed, 306 insertions(+), 28 deletions(-)
 create mode 100644 patches/23-ipw.patch
 create mode 100644 patches/24-pcmcia.patch

Hauke Mehrtens (2):
  compat: update bitops.h
  compat: backport PCMCIA_DEVICE_PROD_ID3

 include/linux/bitops.h        |   33 ++++++++++++++++++++++++++++++---
 include/linux/compat-2.6.34.h |    7 +++++++
 2 files changed, 37 insertions(+), 3 deletions(-)


