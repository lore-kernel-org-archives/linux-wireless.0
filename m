Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54103 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1AUC4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 21:56:48 -0500
Received: by pzk35 with SMTP id 35so217653pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 18:56:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.62903.947245.576431@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:25:51 +0530
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 00/33] ath9k_htc AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is the preliminary work for enabling AP mode for ath9k_htc.

A firmware update is needed, place look at:
http://wireless.kernel.org/en/users/Drivers/ath9k_htc#AP_Mode

Known issues:

* Beacon misses under heavy TX load
  ( hopefully, a fix would be sent out soon).

This has not been tested rigorously, so consider this series as
experimental code.

Sujith

Sujith Manoharan (33):
  ath9k_htc: Allow upto two simultaneous interfaces
  ath9k_htc: Unify target capability updation
  ath9k_htc: Fix error handling in add_interface
  ath9k_htc: Remove OP_PREAMBLE_SHORT
  ath9k_htc: Remove OP_PROTECT_ENABLE
  ath9k_htc: Remove OP_ASSOCIATED variable
  ath9k_htc: Set the BSSID mask for multiple interfaces
  ath9k_htc: Make sequence number calculation per-VIF
  ath9k_htc: Use VIF from the packet's control data
  ath9k_htc: Protect ampdu_action with a mutex
  ath9k_htc: Fix WMI and beacon header
  ath9k_htc: Maintain individual counters for interfaces
  ath9k_htc: Allow AP interface to be created
  ath9k_htc: Calculate and set the HW opmode
  ath9k_htc: Add ANI for AP mode
  ath9k_htc: Disable powersave if an AP interface is present
  ath9k_htc: Configure beacon timers in AP mode
  ath9k_htc: Add beacon slots
  ath9k_htc: Fix TBTT calculation for IBSS mode
  ath9k_htc: Add TSF adjust capability
  ath9k_htc: Configure the beacon queue
  ath9k_htc: Handle buffered frames in AP mode
  ath9k_htc: Enable AP mode
  ath9k_htc: Fix beacon miss under heavy load
  ath9k_htc: Queue WMI events
  ath9k_htc: Handle BSSID/AID for multiple interfaces
  ath9k_htc: Move debug code to a separate file
  ath9k_htc: Add RX error statistics
  ath9k_htc: Fix RX length check
  ath9k_htc: Fix host RX initialization
  ath9k_htc: Remove unused WMI commands
  ath9k_htc: Use SKB's private area for TX parameters
  ath9k_htc: Drain packets on station removal

 drivers/net/wireless/ath/ath9k/Makefile         |    2 +
 drivers/net/wireless/ath/ath9k/hif_usb.c        |   51 ++-
 drivers/net/wireless/ath/ath9k/htc.h            |  133 ++++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  432 ++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |  310 +++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   14 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  649 +++++++++++------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  127 +++--
 drivers/net/wireless/ath/ath9k/htc_hst.c        |   23 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h        |    7 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |   89 ++--
 drivers/net/wireless/ath/ath9k/wmi.h            |   18 +-
 12 files changed, 1329 insertions(+), 526 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_debug.c

-- 
1.7.3.5

