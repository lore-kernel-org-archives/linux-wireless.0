Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36259 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BUWbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:38 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/7] compat-wireless: some general fixes
Date: Mon, 21 Feb 2011 23:31:17 +0100
Message-Id: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These fixes are needed to make compat-wireless work again. This 
replaces the patches send on 17. Feburay. To remove 08-rename-config-
options.patch we need the KConfig system and it would also fix some 
other problems. To make things work again the patches for compat are 
also needed.

Hauke Mehrtens (7):
  compat-wireless: rename some config options
  compat-wireless: backport pm ops for atlx
  compat-wireless: some updates to bluetooth patch
  compat-wireless: brcm80211 fix is in upstream now
  compat-wireless: Add drivers/net/wireless/rtlwifi/rtl8192c
  compat-wireless: generate CONFIG_COMPAT_KERNEL_39
  compat-wireless: build ath9k common when no pci is available

 config.mk                                    |   28 +++---
 patches/08-rename-config-options.patch       |  132 ++++++++++++++++++++++++++
 patches/08-rename-iwl4965-config.patch       |   63 ------------
 patches/11-dev-pm-ops.patch                  |   33 ++++++-
 patches/16-bluetooth.patch                   |  130 +++++++++++++++++---------
 patches/38-brcm80211-mac80211-backport.patch |   14 ---
 patches/99-change-makefiles.patch            |    2 +-
 scripts/admin-update.sh                      |    1 +
 scripts/driver-select                        |    4 +-
 9 files changed, 265 insertions(+), 142 deletions(-)
 create mode 100644 patches/08-rename-config-options.patch
 delete mode 100644 patches/08-rename-iwl4965-config.patch
 delete mode 100644 patches/38-brcm80211-mac80211-backport.patch

