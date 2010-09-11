Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33724 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0IKQS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:18:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/8 v2] compat-wireless: ath9kl and compat_autoconf.h fixes
Date: Sat, 11 Sep 2010 18:18:24 +0200
Message-Id: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains some fixes for the ath6kl driver, the 
compat_autoconf.h file now contains most of the conditions from 
config.mk and some fixes for CONFIG_WIRELESS_EXT=n were added.

This patch series was build tested with kernel 2.6.24 to 2.6.37.
It was build tested with kernel config:
 * CONFIG_WIRELESS_EXT=n + CONFIG_CFG80211_WEXT=n
 * CONFIG_WIRELESS_EXT=n + CONFIG_CFG80211_WEXT=y
 * CONFIG_WIRELESS_EXT=y + CONFIG_CFG80211_WEXT=n
 * CONFIG_WIRELESS_EXT=y + CONFIG_CFG80211_WEXT=y

v1 -> v2:
 * split "add conditions form config into compat_autoconf.h"
 * reorder patches
 * add brcm80211 driver

Hauke Mehrtens (8):
  compat-wireless: handle depending on something build as module
  compat-wireless: make atk6kl build with older kernels
  compat-wireless: fix for CONFIG_WIRELESS_EXT=n
  compat-wireless: build if kernel does not have mac80211
  compat-wireless: add conditions form config into compat_autoconf.h
  compat-wireless: Add warning if wext is deactivated
  compat-wireless: remove special handling for CONFIG_CFG80211_WEXT
  compat-wireless: add brcm80211 driver

 Makefile                                     |    1 +
 config.mk                                    |  139 ++++++++++++++------------
 patches/10-add-wext-handlers-to-netdev.patch |    8 ++-
 patches/33-autoconf.patch                    |   15 +++
 patches/34-backport-bin_attribute.patch      |   47 +++++++++
 patches/35-backport-brcm80211-Makefile.patch |   11 ++
 scripts/admin-update.sh                      |    1 +
 scripts/gen-compat-autoconf.sh               |    8 +-
 8 files changed, 161 insertions(+), 69 deletions(-)
 create mode 100644 patches/33-autoconf.patch
 create mode 100644 patches/34-backport-bin_attribute.patch
 create mode 100644 patches/35-backport-brcm80211-Makefile.patch

