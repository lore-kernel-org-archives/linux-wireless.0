Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22965 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0DPGYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:24:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:24:15 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19400.614.725359.995680@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 11:53:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/10] ath9k_htc updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This series contains all the pending patches
for ath9k_htc, rebased over Luis' latest series.

Sujith

Sujith (10):
  ath9k_htc: Cleanup beacon configuration
  ath: Add buffered register write operations
  ath9k_htc: Implement multiple register write support
  ath9k_hw: Add macros for multiple register writes
  ath9k_hw: Relocate Opmode initialization
  ath9k_hw: Use buffered register writes
  ath9k_htc: Remove GPIO set on unload
  ath9k_htc: Add dropped SKB count to debugfs
  ath9k_htc: Handle WMI timeouts properly
  ath9k_htc: Fix sparse endian warnings

 drivers/net/wireless/ath/ath.h                  |   14 +++-
 drivers/net/wireless/ath/ath9k/ani.c            |   23 +++++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c     |   28 ++++++
 drivers/net/wireless/ath/ath9k/ar9002_calib.c   |    5 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c      |    7 ++-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c     |    5 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c      |   10 ++
 drivers/net/wireless/ath/ath9k/hif_usb.c        |   13 ++-
 drivers/net/wireless/ath/ath9k/htc.h            |   19 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   29 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  104 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   20 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   11 +--
 drivers/net/wireless/ath/ath9k/htc_hst.c        |    8 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h        |   24 +++---
 drivers/net/wireless/ath/ath9k/hw.c             |   79 ++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h             |   18 ++++
 drivers/net/wireless/ath/ath9k/mac.c            |   27 ++++++
 drivers/net/wireless/ath/ath9k/mac.h            |   10 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |   16 +++-
 drivers/net/wireless/ath/ath9k/wmi.h            |   19 ++++-
 21 files changed, 407 insertions(+), 82 deletions(-)

