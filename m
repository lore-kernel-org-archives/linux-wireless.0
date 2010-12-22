Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0LVO1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:27:46 -0500
Received: by wyb28 with SMTP id 28so5082982wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:27:44 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 00/18] AP mode support for wl12xx
Date: Wed, 22 Dec 2010 16:27:19 +0200
Message-Id: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add access point mode support to the wl12xx driver.
This mode uses a separate firmware and has a different initialization
sequence.

In all instances, the flow has been split according to the operating
mode of the driver (AP/STA), so as not to affect STA mode functionality.

v1->2: rebased on latest wl12xx tree

Arik Nemtsov (18):
  wl1271: Add AP related configuration to conf_drv_settings
  wl1271: AP mode - AP specific CMD_CONFIGURE sub-commands
  wl1271: AP mode - add AP specific event
  wl1271: AP-mode high level commands
  wl1271: AP mode - workaround for FW bug on station remove
  wl1271: AP mode - init sequence
  wl1271: AP specific RX filter configuration
  wl1271: Add AP related definitions to HOST-FW interface
  wl1271: Configure AP on BSS info change
  wl1271: AP mode config in ieee80211_ops.config
  wl1271: AP mode - change filter config
  wl1271: AP mode - add STA add/remove ops
  wl1271: AP mode - changes in TX path
  wl1271: AP mode - record TX configuration settings
  wl1271: AP mode - encryption support
  wl1271: AP mode - fetch appropriate firmware for AP
  wl1271: Read MAC address from NVS file on HW startup
  wl1271: Enable AP-mode

 drivers/net/wireless/wl12xx/acx.c          |   62 +++-
 drivers/net/wireless/wl12xx/acx.h          |   31 ++-
 drivers/net/wireless/wl12xx/boot.c         |    6 +-
 drivers/net/wireless/wl12xx/boot.h         |    3 +
 drivers/net/wireless/wl12xx/cmd.c          |  300 +++++++++++-
 drivers/net/wireless/wl12xx/cmd.h          |  143 +++++-
 drivers/net/wireless/wl12xx/conf.h         |   26 +-
 drivers/net/wireless/wl12xx/event.c        |    7 +-
 drivers/net/wireless/wl12xx/event.h        |    8 +-
 drivers/net/wireless/wl12xx/init.c         |  352 ++++++++++---
 drivers/net/wireless/wl12xx/init.h         |    5 +-
 drivers/net/wireless/wl12xx/main.c         |  752 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/rx.h           |   12 +-
 drivers/net/wireless/wl12xx/tx.c           |   70 ++-
 drivers/net/wireless/wl12xx/tx.h           |   13 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |   68 +++-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    5 +
 17 files changed, 1582 insertions(+), 281 deletions(-)

