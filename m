Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:49878 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751063AbeAWHlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 02:41:24 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
Date: Tue, 23 Jan 2018 08:35:21 +0100
Message-Id: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180123_084130_173810_21041217)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 series allows to calibrate noise floor for different frequency
bins. Once it's done it's possible to get more accurate rssi/signal
values over whole frequency band at a given temperature.
The RSSI/signal accuracy reported by calibrated RF cards improves
from 6 to up to 2dB.

This could be interesting for application which require good signal
accuracy like roaming or mesh protocols.

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
