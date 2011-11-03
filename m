Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:44593 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab1KCN4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 09:56:11 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC v2 0/2] ath9k: DFS radar detection
Date: Thu,  3 Nov 2011 14:55:51 +0100
Message-Id: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111103_145615_673698_8ACC509B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series proposes DFS radar pulse detection for ath9k.

Updates
 * use DFS HW capability flag instead of #ifdefs
 * disable feature by default
 * moved DFS debugfs into own file
 * reverted BIT() debug flags to hex
 * limited DFS support to AR_SREV_9280_20_OR_LATER (TBC)
 * minor changes considering feedback


Zefir Kurtisi (2):
  ath9k: add DFS radar pulse processing
  ath9k: integrate initial DFS module

 drivers/net/wireless/ath/ath.h             |    2 +
 drivers/net/wireless/ath/ath9k/Makefile    |    2 +
 drivers/net/wireless/ath/ath9k/debug.c     |    3 +
 drivers/net/wireless/ath/ath9k/debug.h     |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c       |  192 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h       |   24 ++++
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   89 +++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.h |   59 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   12 ++
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 drivers/net/wireless/ath/ath9k/main.c      |   17 +++
 drivers/net/wireless/ath/ath9k/recv.c      |   18 ++-
 12 files changed, 416 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h

-- 
1.7.4.1

