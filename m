Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65007 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab0DWE6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10453.750320.131252@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:27:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/11] ath9k_htc fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This series contains a bunch of fixes for ath9k_htc.
Ming Lei's comment about "ath9k_htc: Use USB reboot"
has also been addressed in this series.

Sujith

Sujith (11):
  ath9k_htc: Simplify TX URB management
  ath9k_htc: Handle device unplug properly
  ath9k_htc: Use multiple register writes
  ath9k_htc: Cancel running timers before disabling HW
  ath9k_hw: Remove pointless ANI deinit
  ath9k_htc: Pass correct private pointer
  ath9k_htc: Use USB reboot
  ath9k_htc: Process command data properly
  ath9k_htc: Increase WMI timeout value
  ath9k_htc: Fix WMI command race
  ath9k_htc: Really fix device hotunplug

 drivers/net/wireless/ath/ath9k/ani.c          |    9 --
 drivers/net/wireless/ath/ath9k/ani.h          |    1 -
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    5 +
 drivers/net/wireless/ath/ath9k/hif_usb.c      |  149 ++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hif_usb.h      |    1 -
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 ++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   12 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    3 -
 drivers/net/wireless/ath/ath9k/wmi.c          |   11 +-
 drivers/net/wireless/ath/ath9k/wmi.h          |    4 +-
 12 files changed, 117 insertions(+), 92 deletions(-)

