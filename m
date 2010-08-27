Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42099 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab0H0SlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/7] compat-wireless: add support for kernel 2.6.24 and 2.6.25
Date: Fri, 27 Aug 2010 20:40:46 +0200
Message-Id: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series fixes some problems when compiling compat-wireless against 
kernel 2.6.24 or 2.6.25. Now this should work for every driver selected 
by default.
"add ifdefs into compat_autoconf.h" extends gen-compat-autoconf.sh to
handle some ifdef in config.mk.

This was compile tested with kernel 2.6.24 to 2.6.36.

Hauke Mehrtens (7):
  compat-wireless: do not use needed_headroom
  compat-wireless: fix patch stile.
  compat-wireless: remove linux/gpio.h include
  compat-wireless: multiple changes to config file
  compat-wireless: rename CONFIG_IWLWIFI config symbol
  compat-wireless: add ifdefs into compat_autoconf.h
  compat-wireless: add support for kernel 2.6.24

 config.mk                              |   63 +++++++++++++++++++-------------
 patches/01-netdev.patch                |   17 ++++++---
 patches/06-header-changes.patch        |   24 +++++++++++-
 patches/08-rename-iwl4965-config.patch |    8 ++++-
 patches/16-bluetooth.patch             |   26 +++++--------
 scripts/gen-compat-autoconf.sh         |   48 ++++++++++++------------
 6 files changed, 112 insertions(+), 74 deletions(-)

