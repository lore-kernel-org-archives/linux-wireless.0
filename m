Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:42511 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab1KDRTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 13:19:45 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org,
	shafi.wireless@gmail.com, chunkeey@googlemail.com, peter@stuge.se,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC v3 0/2] ath9k: DFS radar detection
Date: Fri,  4 Nov 2011 18:19:17 +0100
Message-Id: <1320427159-18509-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111104_181948_662790_00A47753)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series proposes DFS radar pulse detection for ath9k.

Updates to v2
 * use DFS opmode to handle RX filter configuration
 * remove dead code
 * wrap call to private function
 * fix naming convention issues
 * add comments

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

