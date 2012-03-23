Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47948 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764Ab2CWPe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 11:34:26 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFCv2 0/3] ath9k: DFS pattern detector
Date: Fri, 23 Mar 2012 16:33:59 +0100
Message-Id: <1332516842-27522-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120323_163433_000220_AA757D70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an update of the initial proposal in [1] considering the
comments received and re-factoring towards integration with the
DFS management component provided by TI.


[1] http://lwn.net/Articles/478096/

Zefir Kurtisi (3):
  ath9k: add DFS pattern detector
  ath9k: add DFS pattern detector instance to ath_softc
  ath9k: update to DFS pattern detector interface

 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c               |   76 ++---
 drivers/net/wireless/ath/ath9k/dfs.h               |    8 +-
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |  300 +++++++++++++++
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |  104 ++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |  390 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h  |   52 +++
 drivers/net/wireless/ath/ath9k/init.c              |    4 +
 9 files changed, 890 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h

-- 
1.7.4.1

