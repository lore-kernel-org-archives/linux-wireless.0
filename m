Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63204 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2ATNg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:36:29 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 0/8] Allow the user to define suspend mode
Date: Fri, 20 Jan 2012 19:05:36 +0530
Message-ID: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120120_143632_527617_0C870D3F)
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

V2 changes:
 
 * Existing automatic suspend mode selection logic is retained.
 * Suspend mode retry logic is improved without using loop.
 * Small patches are folded with appropriate patches as per Kalle's comments.
 * New wmi function is added to process set host sleep mode cmd processed event.

Raja Mani (8):
  ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend
  ath6kl: Add a new func to configure default WOW patterns for AP mode
  ath6kl: Add a new func to config default WOW patterns for non AP mode
  ath6kl: Move WOW patterns config code to a separate function.
  ath6kl: Configure WOW patterns while going to wow_suspend
  ath6kl: Return a proper error code when not in connected state
  ath6kl: Add a support to handle the host sleep mode cmd processed
    event
  ath6kl: Wait for host sleep mode cmd processed event during WOW
    suspend

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  238 +++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/core.c     |   12 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    5 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   86 +++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   20 +++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 +-
 6 files changed, 288 insertions(+), 78 deletions(-)

