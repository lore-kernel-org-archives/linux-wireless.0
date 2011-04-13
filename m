Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61976 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1DMFst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:48:49 -0400
Received: by iyb14 with SMTP id 14so273325iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:48:48 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14798.540347.460115@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:21:10 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 00/40] ath9k_htc AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch series adds AP mode for ath9k_htc.
New firmware is required, which will be submitted to linux-firmware.

This has been languishing for quite some time internally,
at least wider testing/review would happen if it's in -wl.

Sujith

Sujith Manoharan (40):
  ath9k_htc: Remove AR7010 v1.0 support
  ath9k_htc: Rename firmware
  ath9k_htc: Add a WMI command to get the firmware version
  ath9k_htc: Fix WMI and beacon header
  ath9k_htc: Add beacon slots
  ath9k_htc: Add TSF adjust capability
  ath9k_htc: Configure the beacon queue
  ath9k_htc: Handle buffered frames in AP mode
  ath9k_htc: Fix beacon miss under heavy load
  ath9k_htc: Queue WMI events
  ath9k_htc: Move debug code to a separate file
  ath9k_htc: Add RX error statistics
  ath9k_htc: Fix RX length check
  ath9k_htc: Remove unused WMI commands
  ath9k_htc: Use SKB's private area for TX parameters
  ath9k_htc: Sync struct ath9k_htc_target_sta with FW
  ath9k_htc: Sync struct ath9k_htc_target_vif with FW
  ath9k_htc: Sync struct ath9k_htc_cap_target with FW
  ath9k_htc: Remove unused WMI_WLAN_TXCOMP_EVENTID
  ath9k_htc: Move TX specific stuff to a separate structure
  ath9k_htc: Reduce TX queue size
  ath9k_htc: Sync MGMT/DATA packet headers with firmware
  ath9k_htc: Add a new WMI event WMI_TXSTATUS_EVENTID
  ath9k_htc: Increase URB count for REG_IN pipe
  ath9k_htc: Fix TX queue management
  ath9k_htc: Introduce new HTC API
  ath9k_htc: Move endpoint header parsing to TX tasklet
  ath9k_htc: Add TX slots
  ath9k_htc: Use helper functions for TX processing
  ath9k_htc: Drain pending TX frames properly
  ath9k_htc: Optimize HTC start/stop API
  ath9k_htc: Drain packets on station removal
  ath9k_htc: Add support for TX completion
  ath9k_htc: Add a debugfs file to dump TX slot information
  ath9k_htc: Add a debugfs file showing endpoint status
  ath9k_htc: Add a timer to cleanup WMI events
  ath9k_htc: Use separate URB pool for management frames
  ath9k_htc: Use helper routines for transmission
  ath9k_htc: Add detailed firmware statistics
  ath9k_htc: Enable AP and P2P modes

 drivers/net/wireless/ath/ath9k/Makefile         |    2 +
 drivers/net/wireless/ath/ath9k/hif_usb.c        |  331 +++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h        |    7 +-
 drivers/net/wireless/ath/ath9k/htc.h            |  208 +++++--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  318 ++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |  531 +++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |   12 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   54 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  322 +++-------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  790 ++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/htc_hst.c        |   50 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h        |   14 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |  122 +++--
 drivers/net/wireless/ath/ath9k/wmi.h            |   80 ++-
 14 files changed, 2124 insertions(+), 717 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_debug.c

-- 
1.7.4.4

