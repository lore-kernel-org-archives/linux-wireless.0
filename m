Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:65281 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab1BUCVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:21:19 -0500
Received: by gwj23 with SMTP id 23so744531gwj.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:21:19 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.51903.862083.544544@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:45:27 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k_htc patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Here are some cleanups/fixes. These add some preliminary
code needed to enable AP mode. AP mode is not enabled in this
series, it would be done later when proper TX status reporting
and TX filtering is added to the firmware. These patches don't
require a firmware update and the internal patch queue was growing
long and unwieldy, so it would be good to have these merged.

Sujith

Sujith Manoharan (23):
  ath9k_htc: Handle storage devices
  ath9k_htc: Allow upto two simultaneous interfaces
  ath9k_htc: Unify target capability updating
  ath9k_htc: Fix error handling in add_interface
  ath9k_htc: Remove OP_PREAMBLE_SHORT
  ath9k_htc: Remove OP_PROTECT_ENABLE
  ath9k_htc: Remove OP_ASSOCIATED variable
  ath9k_htc: Set the BSSID mask for multiple interfaces
  ath9k_htc: Make sequence number calculation per-VIF
  ath9k_htc: Use VIF from the packet's control data
  ath9k_htc: Protect ampdu_action with a mutex
  ath9k_htc: Maintain individual counters for interfaces
  ath9k_htc: Allow AP interface to be created
  ath9k_htc: Calculate and set the HW opmode
  ath9k_htc: Add ANI for AP mode
  ath9k_htc: Disable powersave if an AP interface is present
  ath9k_htc: Configure beacon timers in AP mode
  ath9k_htc: Fix TBTT calculation for IBSS mode
  ath9k_htc: Handle BSSID/AID for multiple interfaces
  ath9k_htc: Fix host RX initialization
  ath9k_htc: Fix RX filters
  ath9k_htc: Add debug code to print endpoint mapping
  ath9k_htc: Fix error path in URB allocation

 drivers/net/wireless/ath/ath9k/hif_usb.c        |   78 ++++-
 drivers/net/wireless/ath/ath9k/htc.h            |   76 ++++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  137 +++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   19 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  448 ++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   82 +++--
 drivers/net/wireless/ath/ath9k/reg.h            |    1 +
 drivers/net/wireless/ath/ath9k/wmi.c            |    4 -
 8 files changed, 643 insertions(+), 202 deletions(-)

-- 
1.7.4.1

