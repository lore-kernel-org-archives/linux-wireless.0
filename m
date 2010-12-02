Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59010 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0LBLHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:07:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:07:11 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 00/27] Add support for AR9485
Date: Thu, 2 Dec 2010 03:06:44 -0800
Message-ID: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

	This patch set adds support for a new chip of AR9003 family.
This chip is an 1x1 and 2.4Ghz band only.

Vasanth

V2 
---
* A New patch to find and save the max number of supported tx and rx chains.
* Removed duplicate code in pll contorl configuration.

Vasanthakumar Thiagarajan (27):
  ath9k_hw: Define hw version macros for AR9485
  ath9k_hw: Add initvals.h for AR9485
  ath9k_hw: Enable hw initialization for AR9485
  ath9k_hw: Initialize mode registers for AR9485
  ath9k_hw: Initialize tx/rx gain table from initvals.h for AR9485
  ath9k_hw: Eeeprom changes for AR9485
  ath9k_hw: Disable LDPC for AR9485
  ath9k: Disable TX STBC for AR9485
  ath9k: Enable extended synch for AR9485 to fix L0s recovery issue
  ath9k_hw: Find the maximum number of chains that hw supports
  ath9k: Configure pll control for AR9485
  ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7 from an array for
    AR9485
  ath9k_hw: Add a helper function to get spur channel pointer from cal
    data for AR9003 family
  ath9k: Read spur channel information from eeprom for AR9485
  ath9k_hw: Configure xpa bias level for AR9485
  ath9k_hw: Read and configure antenna diversity control for AR9485
  ath9k_hw: Configure attenuation control  only for supported chains
  ath9k_hw: Configure internal regulator for AR9485
  ath9k_hw: Read and configure turnning caps to regulate freq accuracy
  ath9k_hw: Configure power control only for the supported chains
  ath9k_hw: Program appropriate chianmask for AR9485 before starting
    AGC/IQ cal
  ath9k_hw: Define IQcal correction coefficient registers using index
  ath9k_hw: Add IQ cal changes for AR9485
  ath9k_hw: Program appropriate register for temperature compensation
    cal for AR9485
  ath9k_hw: Setup paprd only for supported chains
  ath9k_hw: Disable MRC CCK for AR9485
  ath9k: Add device id of AR9485 to pci table

 drivers/net/wireless/ath/ath.h                   |    1 +
 drivers/net/wireless/ath/ath9k/ani.c             |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |  256 ++++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |  189 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h   |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  278 +++++--
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c    |   37 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |   60 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |   70 ++-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |  943 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c              |   33 +-
 drivers/net/wireless/ath/ath9k/hw.h              |    5 +
 drivers/net/wireless/ath/ath9k/init.c            |    4 +-
 drivers/net/wireless/ath/ath9k/main.c            |    3 +
 drivers/net/wireless/ath/ath9k/pci.c             |   13 +
 drivers/net/wireless/ath/ath9k/reg.h             |   10 +
 16 files changed, 1743 insertions(+), 163 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9485_initvals.h

