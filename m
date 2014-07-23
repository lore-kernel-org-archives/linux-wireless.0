Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59614 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaGWPyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 11:54:10 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	sven@narfation.org, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv3 0/2] ath10k spectral scan support
Date: Wed, 23 Jul 2014 17:53:55 +0200
Message-Id: <1406130837-10353-1-git-send-email-sw@simonwunderlich.de> (sfid-20140723_175414_200110_43BF22D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the third "PATCH" patchset iteration for the ath10k spectral
scan feature. It includes quite a few style fixes, the compile issues
were fixed when debugfs were disabled, and sending WMI commands after
a firmware crash should not happen any more. Thanks to Michal, Chun-Yeow
and Kalle for reviewing!

To view the samples, please have a look at the fft_eval tool [1] which
now supports both ath9k and ath10k formats.

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

Please see the patches for more information on the changes.

Cheers,
    Simon

[1] https://github.com/simonwunderlich/FFT_eval

Simon Wunderlich (1):
  ath10k: add spectral scan feature

Sven Eckelmann (1):
  ath: Move spectral debugfs structs to shared header

 drivers/net/wireless/ath/ath10k/Kconfig    |   1 +
 drivers/net/wireless/ath/ath10k/Makefile   |   1 +
 drivers/net/wireless/ath/ath10k/core.c     |   7 +-
 drivers/net/wireless/ath/ath10k/core.h     |  10 +
 drivers/net/wireless/ath/ath10k/debug.c    |   3 +
 drivers/net/wireless/ath/ath10k/mac.c      |   7 +
 drivers/net/wireless/ath/ath10k/spectral.c | 557 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |  82 +++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 104 +++++-
 drivers/net/wireless/ath/ath10k/wmi.h      |  97 +++++
 drivers/net/wireless/ath/ath9k/spectral.h  |  71 +---
 drivers/net/wireless/ath/spectral_common.h | 113 ++++++
 12 files changed, 982 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
 create mode 100644 drivers/net/wireless/ath/spectral_common.h

-- 
1.9.1

