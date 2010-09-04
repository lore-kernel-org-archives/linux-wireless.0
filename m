Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54637 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0IDPHG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] compat-wireless: ath9kl and compat_autoconf.h fixes
Date: Sat,  4 Sep 2010 17:06:44 +0200
Message-Id: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains some fixes for the ath6kl driver, the 
compat_autoconf.h file now contains most of the conditions from 
config.mk and some fixes for CONFIG_WIRELESS_EXT=n were added.

Hauke Mehrtens (5):
  compat-wireless: add conditions form config into compat_autoconf.h
  compat-wireless: handle depending on something build as module
  compat-wireless: make atk6kl build with older kernels
  compat-wireless: fix for CONFIG_WIRELESS_EXT=n
  compat-wireless: build if kernel does not have mac80211

 config.mk                               |  102 ++++++++++++++++--------------
 patches/33-autoconf.patch               |   15 +++++
 patches/34-backport-bin_attribute.patch |   47 ++++++++++++++
 scripts/gen-compat-autoconf.sh          |    8 +--
 4 files changed, 118 insertions(+), 54 deletions(-)
 create mode 100644 patches/33-autoconf.patch
 create mode 100644 patches/34-backport-bin_attribute.patch

