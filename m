Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:60250 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3JKMKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 08:10:00 -0400
Received: by mail-ea0-f175.google.com with SMTP id m14so1845806eaj.34
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 05:09:59 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: [PATCH v2 0/2] ath9k: spectral scan on HT40 channels
Date: Fri, 11 Oct 2013 14:09:53 +0200
Message-Id: <1381493395-7632-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131011_141006_280496_AD4BEBE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset add spectral scan capability on HT40 channels for
ath9k. In particular:
*[PATCH 1/2]: add nf parameter to ath9k_hw_getchan_noise() to compute noise
floor for ext chains
*[PATCH 2/2]: parse FFT samples on HT40 channels

Changes to the previous patchset:
* add channel_type field in fft_sample_ht20_40 structure to indicate HT40 type
(NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS)
* fix some checkpatch errors

Spectral scan has been tested using Simon Wunderlich's userspace program
(https://github.com/simonwunderlich/FFT_eval) on HT20 channels and using a Qt-Qwt
program (https://github.com/LorenzoBianconi/ath_spectral) on HT40 channels

Regards,
Lorenzo

Lorenzo Bianconi (2):
  ath9k: add noise floor parameter to ath9k_hw_getchan_noise
  ath9k: add HT40 spectral scan capability

 drivers/net/wireless/ath/ath9k/ath9k.h |  29 +++++++
 drivers/net/wireless/ath/ath9k/calib.c |  10 +--
 drivers/net/wireless/ath/ath9k/calib.h |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c    |   2 +-
 drivers/net/wireless/ath/ath9k/link.c  |   3 +-
 drivers/net/wireless/ath/ath9k/recv.c  | 146 ++++++++++++++++++++++++---------
 6 files changed, 147 insertions(+), 46 deletions(-)

-- 
1.8.1.2

