Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1CGCKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:10:36 -0500
Received: by yxs7 with SMTP id 7so1452154yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:10:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16017.691812.916489@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:40:25 +0530
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: [RFC 00/34] ath9k_htc AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the current patchset for enabing AP mode for ath9k_htc.
TX status processing has been enabled in the FW and the host
driver has been updated accordingly. TX filtering hasn't been fixed
yet, though.

The updated FW can be found at: http://linuxwireless.org/en/users/Drivers/ath9k_htc#AP_Mode

Sujith Manoharan (34):
  ath9k_htc: Fix WMI and beacon header
  ath9k_htc: Add beacon slots
  ath9k_htc: Add TSF adjust capability
  ath9k_htc: Configure the beacon queue
  ath9k_htc: Handle buffered frames in AP mode
  ath9k_htc: Enable AP mode
  ath9k_htc: Fix beacon miss under heavy load
  ath9k_htc: Queue WMI events
  ath9k_htc: Move debug code to a separate file
  ath9k_htc: Add RX error statistics
  ath9k_htc: Fix RX length check
  ath9k_htc: Remove unused WMI commands
  ath9k_htc: Use SKB's private area for TX parameters
  ath9k_htc: Sync struct ath9k_htc_target_sta with FW
  ath9k_htc: Sync struct ath9k_htc_target_vif with FW
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

 drivers/net/wireless/ath/ath9k/Makefile         |    2 +
 drivers/net/wireless/ath/ath9k/hif_usb.c        |  320 +++++++++----
 drivers/net/wireless/ath/ath9k/hif_usb.h        |    7 +-
 drivers/net/wireless/ath/ath9k/htc.h            |  163 +++++---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  315 +++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |  406 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |   12 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |   20 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  322 +++----------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  583 ++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/htc_hst.c        |   50 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h        |   14 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |  119 +++--
 drivers/net/wireless/ath/ath9k/wmi.h            |   65 +++-
 14 files changed, 1758 insertions(+), 640 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_debug.c

-- 
1.7.4.1

