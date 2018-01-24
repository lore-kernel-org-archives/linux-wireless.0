Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:32326 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932108AbeAXIC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 03:02:26 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH v2 0/4] ath9k: AR9003 noise floor calibration support
Date: Wed, 24 Jan 2018 09:02:15 +0100
Message-Id: <1516780939-7176-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180124_090232_353033_3C639BEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 series allows to calibrate noise floor for different frequency
bins. Once it's done it's possible to get more accurate rssi/signal
values over whole frequency band at a given temperature.
The RSSI/signal accuracy reported by calibrated RF cards improves
from 6 to up to 2dB.

This could be interesting for application which require good signal
accuracy like roaming or mesh protocols.

V2: Copied cover letter feature description to patch 3 in the series.

Wojciech Dubowik (4):
  ath9k: Alternative EEPROM size for AR9003
  ath9k: Read noise floor calibration data from eeprom
  ath9k: Use calibrated noise floor value when available
  ath9k: Display calibration data piers in debugfs

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 133 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  10 ++
 drivers/net/wireless/ath/ath9k/calib.c         |  38 ++++---
 drivers/net/wireless/ath/ath9k/hw.h            |   2 +
 4 files changed, 160 insertions(+), 23 deletions(-)

-- 
2.7.4
