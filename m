Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47215 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab1KHQeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:34:11 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, shafi.wireless@gmail.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 0/2] ath9k: DFS radar detection
Date: Tue,  8 Nov 2011 17:34:02 +0100
Message-Id: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111108_173415_798630_7E0DF632)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series proposes DFS radar pulse detection for ath9k.

The first patch adds a new DFS module, the second turns those
knobs to enable the HW to detect radar pulses and forward them
to the new module.

Here, sanity and plausibility checks that are HW dependent are
performed and resulting radar events are passed to higher level
generic pattern detectors for further processing (spectrum
management, etc.).

DFS support is limited to newer chip-sets (for now 9280 and later).

So far, AP operation on DFS channels is not supported by 
mac80211/hostapd. Testing the proposed pulse detection is done in
monitor mode.

Zefir Kurtisi (2):
  ath9k: add DFS radar pulse processing
  ath9k: integrate initial DFS module

 drivers/net/wireless/ath/ath.h             |    2 +
 drivers/net/wireless/ath/ath9k/Makefile    |    2 +
 drivers/net/wireless/ath/ath9k/ath9k.h     |    1 +
 drivers/net/wireless/ath/ath9k/debug.c     |    3 +
 drivers/net/wireless/ath/ath9k/debug.h     |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c       |  203 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h       |   38 +++++
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   89 ++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.h |   59 ++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 ++
 drivers/net/wireless/ath/ath9k/hw.c        |    7 +
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 drivers/net/wireless/ath/ath9k/main.c      |   16 +++
 drivers/net/wireless/ath/ath9k/recv.c      |   19 ++-
 14 files changed, 446 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h

-- 
1.7.4.1

