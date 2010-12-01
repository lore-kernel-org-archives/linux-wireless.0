Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13825 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0LAHc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:32:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:32:43 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/26] Add support for AR9485 
Date: Tue, 30 Nov 2010 23:32:29 -0800
Message-ID: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

	This patch series add support for a new chipset of AR9003 family.
This chip(AR9485) is an 1x1 and 2.4Ghz band only.

Vasanth

Vasanthakumar Thiagarajan (26):
  ath9k_hw: Define hw version macros for AR9485
  ath9k_hw: Add initvals.h for AR9485
  ath9k_hw: Enable hw initialization for AR9485
  ath9k_hw: Initialize mode registers for AR9485
  ath9k_hw: Initialize tx/rx gain table from initvals.h for AR9485
  ath9k_hw: Eeeprom changes for AR9485
  ath9k_hw: Disable LDPC for AR9485
  ath9k: Disable TX STBC for AR9485
  ath9k: Enable extended synch for AR9485 to fix L0s recovery issue
  ath9k: Configure pll control for AR9485
  ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7 from an array for
    AR9485
  ath9k_hw: Add a helper function to get spur channel pointer from cal
    data for AR9003 family
  ath9k: Read spur channel information from eeprom for AR9485
  ath9k_hw: Configure xpa bias level for AR9485
  ath9k_hw: Read and configure antenna diversity control for AR9485
  ath9k_hw: Configure attenuation control only for chain 0 on AR9485
  ath9k_hw: Configure internal regulator for AR9485
  ath9k_hw: Read and configure turnning caps to regulate freq accuracy
  ath9k_hw: Configure power control only for chain 0 on AR9485
  ath9k_hw: Program appropriate chianmask for AR9485 before starting
    AGC/IQ cal
  ath9k_hw: Define IQcal correction coefficient registers using index
  ath9k_hw: Add IQ cal changes for AR9485
  ath9k_hw: Program appropriate register for temperature compensation
    cal for AR9485
  ath9k_hw: Setup paprd only for chain 0 on AR9485
  ath9k_hw: Disable MRC CCK for AR9485
  ath9k: Add device id of AR9485 to pci table

 drivers/net/wireless/ath/ath.h                   |    1 +
 drivers/net/wireless/ath/ath9k/ani.c             |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    |  256 ++++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |  193 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h   |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  278 +++++--
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c    |   40 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c      |   76 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h      |   70 ++-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |  943 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c              |   19 +-
 drivers/net/wireless/ath/ath9k/hw.h              |    3 +
 drivers/net/wireless/ath/ath9k/init.c            |    4 +-
 drivers/net/wireless/ath/ath9k/main.c            |    3 +
 drivers/net/wireless/ath/ath9k/pci.c             |   13 +
 drivers/net/wireless/ath/ath9k/reg.h             |   10 +
 16 files changed, 1745 insertions(+), 168 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9485_initvals.h

