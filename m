Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26820 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab0CQV1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:00 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 00/12] ATH9K htc driver - supports AR9271
Date: Wed, 17 Mar 2010 14:25:13 +0530
Message-ID: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This series adds support for Atheros AR9271. This series also includes
the set of patches (split up of ath9k_hw changes for HTC) which Luis had
sent a couple of days ago.

So this series addresses all the concerns we had earlier and is good to go.

Thanks
Senthil

Sujith (12):
  ath9k_hw: update initialization values for AR9271
  ath9k_hw: add GPIO setup code for AR9271
  ath9k_hw: skip chip tests for AR9271
  ath9k_hw: fix TX descriptor setup for AR9271
  ath9k_hw: Fix full sleep setup for AR9271
  ath9k_hw: fix noisefloor history buffer usage on AR9271
  ath9k_hw: restrict valid nf readings for AR9271 to -114
  ath9k_hw: use the skip count for PA calibration on AR9271
  ath9k_hw: always set the core clock for AR9271
  ath9k_hw: add HTC init hardware call for special resets for AR9271
  ath9k_hw: fix hardware deinit
  ath9k_htc: Support for AR9271 chipset.

 drivers/net/wireless/ath/Kconfig                |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig          |   21 +
 drivers/net/wireless/ath/ath9k/Makefile         |   10 +
 drivers/net/wireless/ath/ath9k/calib.c          |   25 +-
 drivers/net/wireless/ath/ath9k/common.c         |  421 ++++++
 drivers/net/wireless/ath/ath9k/common.h         |   17 +
 drivers/net/wireless/ath/ath9k/hif_usb.c        |  993 ++++++++++++++
 drivers/net/wireless/ath/ath9k/hif_usb.h        |  105 ++
 drivers/net/wireless/ath/ath9k/htc.h            |  441 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  260 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  713 ++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 1626 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |  604 +++++++++
 drivers/net/wireless/ath/ath9k/htc_hst.c        |  463 +++++++
 drivers/net/wireless/ath/ath9k/htc_hst.h        |  246 ++++
 drivers/net/wireless/ath/ath9k/hw.c             |  134 +-
 drivers/net/wireless/ath/ath9k/hw.h             |    8 +
 drivers/net/wireless/ath/ath9k/init.c           |    3 +
 drivers/net/wireless/ath/ath9k/initvals.h       |  141 ++-
 drivers/net/wireless/ath/ath9k/mac.c            |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h            |   26 +
 drivers/net/wireless/ath/ath9k/reg.h            |    3 +
 drivers/net/wireless/ath/ath9k/wmi.c            |  319 +++++
 drivers/net/wireless/ath/ath9k/wmi.h            |  126 ++
 drivers/net/wireless/ath/debug.h                |    1 +
 25 files changed, 6596 insertions(+), 114 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/hif_usb.c
 create mode 100644 drivers/net/wireless/ath/ath9k/hif_usb.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_init.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_main.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_hst.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_hst.h
 create mode 100644 drivers/net/wireless/ath/ath9k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath9k/wmi.h

