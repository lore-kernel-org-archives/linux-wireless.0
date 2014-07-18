Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:48343 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaGRN0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 09:26:37 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] ath10k spectral scan support
Date: Fri, 18 Jul 2014 15:26:30 +0200
Message-Id: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de> (sfid-20140718_152645_766617_296D8FCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first "PATCH" patchset iteration for the ath10k spectral
scan feature. The feature is still experimental, but we made quite
some progress.

The fft_eval tool has also been updated based on the new patchset, and
now supports both ath9k and ath10k sample formats in the same branch,
which has been merged into master [1].

The bin issue has been solved thanks to the valuable input of Michal and
Kathy! In my tests, most modes seem to support 64, 128 or 256 bins, and
an option to configure that has been added. 512 bins should be possible
as well under some circumstances according to Kathys mail, but I couldn't
get that working. Also HT80/64 bin reports look bogus, so these are
disabled for now. FFT_eval includes some data samples in case you are
interested.

The count issue is still open: Even when a count is specified, the
hardware seems to send endless samples. It seems to work most of the
time in VHT80 mode though, but in HT20 and HT40 the count value seems
to be ignored. To reproduce this, start hostapd with the desired
channel width and do:

echo 8 > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_count
echo manual > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
echo trigger > /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan_ctl
cat /sys/kernel/debug/ieee80211/phy0/ath10k/spectral_scan0 >> /tmp/fft.dump

Repeating the last line and checking the filesize will easily show
whether ath10k still sends samples or not. We would expect 8 samples in
this configuration.

See the patch for more information on the changes.

Thanks again to Michal, Kathy, Kalle and Sven for their support!

Cheers,
	Simon

[1] https://github.com/simonwunderlich/FFT_eval

Simon Wunderlich (1):
  ath10k: add spectral scan feature

Sven Eckelmann (1):
  ath: Move spectral debugfs structs to shared header

 drivers/net/wireless/ath/ath10k/Kconfig    |   1 +
 drivers/net/wireless/ath/ath10k/Makefile   |   3 +-
 drivers/net/wireless/ath/ath10k/core.c     |   4 +
 drivers/net/wireless/ath/ath10k/core.h     |   7 +
 drivers/net/wireless/ath/ath10k/debug.c    |   3 +
 drivers/net/wireless/ath/ath10k/mac.c      |   8 +
 drivers/net/wireless/ath/ath10k/spectral.c | 558 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |  64 ++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 104 +++++-
 drivers/net/wireless/ath/ath10k/wmi.h      |  94 +++++
 drivers/net/wireless/ath/ath9k/spectral.h  |  71 +---
 drivers/net/wireless/ath/spectral_common.h | 112 ++++++
 12 files changed, 958 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
 create mode 100644 drivers/net/wireless/ath/spectral_common.h

-- 
1.9.1

