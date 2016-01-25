Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49698 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbcAYJFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 04:05:53 -0500
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCHv2 0/4] net: rfkill: gpio: replace platform data with build-in property
Date: Mon, 25 Jan 2016 12:03:45 +0300
Message-Id: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20160125_100559_359155_E3ED392E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The changes to the unified properties interface that I have been
waiting for are finally available in v4.5-rc1.


Heikki Krogerus (4):
  net: rfkill: add rfkill_find_type function
  net: rfkill: gpio: get the name and type from device property
  ARM: tegra: use build-in device properties with rfkill_gpio
  net: rfkill: gpio: remove rfkill_gpio_platform_data

 arch/arm/mach-tegra/board-paz00.c | 17 +++++++-----
 include/linux/rfkill-gpio.h       | 37 -------------------------
 include/linux/rfkill.h            | 15 +++++++++++
 net/rfkill/Kconfig                |  3 +--
 net/rfkill/core.c                 | 57 ++++++++++++++++++++-------------------
 net/rfkill/rfkill-gpio.c          | 24 ++++++++---------
 6 files changed, 66 insertions(+), 87 deletions(-)
 delete mode 100644 include/linux/rfkill-gpio.h

-- 
2.7.0.rc3

