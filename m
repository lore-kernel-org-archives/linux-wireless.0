Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:53 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 00/11] ath6kl: Add WOW support
Date: Mon, 7 Nov 2011 10:55:36 +0530
Message-ID: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062755_996209_7D0BD282)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Version 2 patch set is tested on Qualcomm MSM board and 
takes care most of the review comments given by Kalle.

V2 changes:
 * WOW mode selection logic is moved to HIF layer, earlier it was implemented in CFG i/f layer.
 * Individual parameters are used in the functions instead of struct as a parameter.
 * Unused one extra byte is removed in struct wmi_add_wow_pattern_cmd.
 * Used ar->state for WOW state handling and separate WOW state handling is removed. 
 * host sdio irq wake up capability is checked before entering into WOW suspend mode. 
 * Empty commit logs are avoided.  :-)
 * No error is reported from Sparse.
 * Rebased to multi vif implementation.

 and other minor corrections.

Using these patch set, WOW patterns can be controlled and configured via iw command. 
Please refer iw help menu for more details.

Limitations:
   * Optional bytes can't be specified while configuring WOW patterns from iw command.
     This is due to the limitation in the firmware.

   * Pattern byte matching will always happen from the first byte of received packet. 
     This is the limitation in the recent "iw" command (It doesn't take the pattern 
     offset where to start pattern matching in the received packets as of now).

Raja Mani (11):
  ath6kl: Add wmi functions to add/delete WOW patterns
  ath6kl: Add wmi functions to configure WOW mode and host sleep mode
  ath6kl: Add WOW suspend/resume implementation
  ath6kl: Include new parameter in suspend path for wowlan
  ath6kl: Add new state for WOW mode
  ath6kl: Move ath6kl_cfg80211_stop() call specific to deep sleep and
    cut pwr
  ath6kl: Invoke WOW suspend/resume calls during PM operation
  ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wake up
  ath6kl: Expose ath6kl's WOW capabilities to CFG layer
  ath6kl: Remove WARN_ON msg in Suspend path
  ath6kl: Remove few unused WMI stuff

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  188 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    5 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    5 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 +-
 drivers/net/wireless/ath/ath6kl/hif.h      |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   29 ++++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  164 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   64 ++++++++--
 9 files changed, 436 insertions(+), 28 deletions(-)

