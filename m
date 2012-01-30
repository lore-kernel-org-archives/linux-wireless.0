Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4714 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2A3Lqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:46:53 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v3 0/4] Allow the user to define suspend mode
Date: Mon, 30 Jan 2012 17:13:08 +0530
Message-ID: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120130_124656_998309_FB49F40B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

This series of patch enables the user to specify the suspend mode 
via module parameter (suspend_mode) while doing insmod of the driver.

   To select Cut Power mode:
      insmod ath6kl_sdio.ko suspend_mode = 1

   To select Deep Sleep mode:
      insmod ath6kl_sdio.ko suspend_mode = 2

   To select WOW suspend mode:
      insmod ath6kl_sdio.ko suspend_mode = 3

Existing module param 'suspend_cutpower' variable is renamed to 
'suspend_mode' for this purspose.

Additionally, If the user doesn't provide any WOW patterns, 
the default WOW patterns will be configured while going to
WOW suspend mode.

V3 changes:

 * Module parameter suspend_mode data type is changed from
   unsigned char to unsigned int.
 * Host sleep mode cmd processed event related changes are grouped into
   a single patch.
 * All WOW pattern configuration changes are grouped into a single patch.
 * Renamed few func names,
    ath6kl_set_sdio_pm_keep_pwr_wake_irq() => ath6kl_sdio_pm_caps()
    ath6kl_ap_add_default_wow_patterns() => ath6kl_wow_ap()
    ath6kl_non_ap_add_default_wow_patterns() => ath6kl_wow_sta()
    ath6kl_add_usr_wow_patterns() => ath6kl_wow_usr()

V2 changes:
 
 * Existing automatic suspend mode selection logic is retained.
 * Suspend mode retry logic is improved without using loop.
 * Small patches are folded with appropriate patches as per Kalle's comments.
 * New wmi function is added to process set host sleep mode cmd processed event.


Raja Mani (4):
  ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend
  ath6kl: Configure WOW patterns while going to wow_suspend
  ath6kl: Wait for host sleep mode cmd processed event during WOW
    suspend
  ath6kl: Return a proper error code when not in connected state

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  244 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/core.c     |   12 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    5 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   86 ++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   20 +++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 +-
 6 files changed, 290 insertions(+), 82 deletions(-)

