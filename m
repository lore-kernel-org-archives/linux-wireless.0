Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49767 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaGYS0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 14:26:53 -0400
Subject: [PATCH v4 0/2] ath10k spectral scan support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Jul 2014 21:19:05 +0300
Message-ID: <20140725181753.10809.84231.stgit@potku.adurom.net> (sfid-20140725_202659_564829_7269D212)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patchset iteration the ath10k spectral scan feature.

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

[1] https://github.com/simonwunderlich/FFT_eval

v4:

* CPTCFG_ fixes
* rework spectral.c initialisation (ath10k_spectral_start() etc)
* only run a simple test

---

Simon Wunderlich (1):
      ath10k: add spectral scan feature

Sven Eckelmann (1):
      ath: Move spectral debugfs structs to shared header


 drivers/net/wireless/ath/ath10k/Kconfig    |    1 
 drivers/net/wireless/ath/ath10k/Makefile   |    1 
 drivers/net/wireless/ath/ath10k/core.c     |   10 
 drivers/net/wireless/ath/ath10k/core.h     |   11 +
 drivers/net/wireless/ath/ath10k/mac.c      |    8 
 drivers/net/wireless/ath/ath10k/spectral.c |  561 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/spectral.h |   90 ++++
 drivers/net/wireless/ath/ath10k/wmi.c      |  105 +++++
 drivers/net/wireless/ath/ath10k/wmi.h      |   97 +++++
 drivers/net/wireless/ath/ath9k/spectral.h  |   71 ----
 drivers/net/wireless/ath/spectral_common.h |  113 ++++++
 11 files changed, 998 insertions(+), 70 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
 create mode 100644 drivers/net/wireless/ath/spectral_common.h

