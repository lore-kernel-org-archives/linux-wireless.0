Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21614 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbZIQDxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:53:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:53:47 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
Message-ID: <19121.45772.489140.407518@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:23:48 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/12] ath9k bug fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of patches fixing various bugs in the driver.
These apply on top of wireless-testing.

Luis would rebase his pending patches on top of these
and resend them.

Thanks.
Sujith

Senthil Balasubramanian (2):
  ath9k: Adjust the chainmasks properly
  ath9k: Fix bug in chain handling

Sujith (3):
  ath9k: Restore TSF after RESET
  ath9k: Fix chip wakeup issue
  ath9k: Fix regression in PA calibration

Vasanthakumar Thiagarajan (3):
  ath9k: Fix rx data corruption
  ath9k: Don't read NF when chip has gone through full sleep mode
  ath9k: Do a full reset for AR9280

Vivek Natarajan (4):
  ath9k: Set default noise floor value for AR9287
  ath9k: Revamp PCIE workarounds
  ath9k: Fix AHB reset for AR9280
  ath9k: Disable autosleep feature by default.

 drivers/net/wireless/ath/ath9k/calib.c      |   23 +++-
 drivers/net/wireless/ath/ath9k/calib.h      |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c         |  198 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h         |    4 +-
 drivers/net/wireless/ath/ath9k/main.c       |    8 +-
 drivers/net/wireless/ath/ath9k/reg.h        |    3 +-
 7 files changed, 149 insertions(+), 92 deletions(-)

