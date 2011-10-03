Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:49719 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1JCKLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:11:47 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: zefir.kurtisi@neratec.com, kgiori@qca.qualcomm.com,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: [RFC 0/6] ath9k: DFS pattern detection
Date: Mon,  3 Oct 2011 12:11:17 +0200
Message-Id: <1317636683-11632-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_121150_737055_9C744AA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series proposes DFS pattern detection for ath9k.

With the source code for the proprietary wireless driver provided by
Atheros, the basic functionality to inspect radar pulses detected by
the HW and to post-filter false pulses has been re-implemented
for ath9k.



Zefir Kurtisi (6):
  ath9k: add DFS statistics to debugfs
  ath9k: add DFS debug flag
  ath9k: initial radar pulse detection for DFS
  ath9k: add DFS build parameter
  ath9k: enable DFS pulse detection
  ath9k: handle pulse data reported by DFS HW

 drivers/net/wireless/ath/ath.h          |   34 +++---
 drivers/net/wireless/ath/ath9k/Kconfig  |    7 +
 drivers/net/wireless/ath/ath9k/Makefile |    2 +
 drivers/net/wireless/ath/ath9k/debug.c  |   51 ++++++++
 drivers/net/wireless/ath/ath9k/debug.h  |   29 +++++
 drivers/net/wireless/ath/ath9k/dfs.c    |  192 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h    |   24 ++++
 drivers/net/wireless/ath/ath9k/main.c   |   12 ++
 drivers/net/wireless/ath/ath9k/recv.c   |   22 +++-
 9 files changed, 352 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h

-- 
1.7.4.1

