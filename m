Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49956 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731091AbeISQOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:14:36 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/5] ath9k: FFT fixes and improvements
Date: Wed, 19 Sep 2018 12:37:06 +0200
Message-Id: <20180919103711.19304-1-sw@simonwunderlich.de> (sfid-20180919_123721_829348_316250C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During FFT evaluation on an AR9462 adapter, we noticed that there were
way less FFT samples received than we would expect. This patchset adds
some counters to be able to check for received (and discarded) FFT
samples, and fixes a variety of issues I found while debugging.

Cheers,
     Simon

Simon Wunderlich (5):
  ath9k: add counters for good and errorneous FFT/spectral frames
  ath9k: return when short FFT frame was handled
  ath9k: fix and simplify FFT max index retrieval
  ath9k: FFT magnitude check: don't consider lower 3 data bits
  ath9k: fix reporting calculated new FFT upper max

 drivers/net/wireless/ath/ath9k/common-debug.c    |  2 +
 drivers/net/wireless/ath/ath9k/common-debug.h    |  4 ++
 drivers/net/wireless/ath/ath9k/common-spectral.c | 83 +++++++++---------------
 drivers/net/wireless/ath/ath9k/common-spectral.h | 17 +++++
 4 files changed, 55 insertions(+), 51 deletions(-)

-- 
2.11.0
