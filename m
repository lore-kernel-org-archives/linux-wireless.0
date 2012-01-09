Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2AIIjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:39:31 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 0/8] Allow the user to define suspend mode
Date: Mon, 9 Jan 2012 14:06:14 +0530
Message-ID: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093934_746682_2B7B0621)
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

Dynamic suspend mode selection logic based on the host SDIO 
host controller is removed in ath6kl_sdio_suspend(). 
Now, ath6kl_sdio_suspend() will react based on the module 
parameter 'suspend_mode'.

Additionally, If the user doesn't provide any WOW patterns, 
the default WOW patterns will be configured while going to 
WOW suspend mode.

Please provide your comments on this patch series.

Raja Mani (8):
  ath6kl: Rename modparam variable suspend_cutpower to suspend_mode
  ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend()
  ath6kl: Add a new func to configure default WOW patterns for AP mode
  ath6kl: Add a new func to config default WOW patterns for non AP mode
  ath6kl: Move WOW patterns config code to a separate function.
  ath6kl: Configure WOW patterns while going to wow_suspend
  ath6kl: Removed unused ATH6KL_CONF_SUSPEND_CUTPOWER macro
  ath6kl: Return a proper error code when not in connected state

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  222 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   11 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |  105 ++++++++-----
 4 files changed, 258 insertions(+), 82 deletions(-)

