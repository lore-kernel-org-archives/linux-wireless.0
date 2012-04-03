Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:37773 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2DCPQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 11:16:03 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 0/3] ath9k: DFS pattern detector
Date: Tue,  3 Apr 2012 17:15:48 +0200
Message-Id: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120403_171614_252948_3C8AB47A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a re-post of the RFCv2 posted in [1] with non-functional
changes (like typos, naming, formatting).

The first patch adds a DFS pattern detector that detects single
and multi-PRI pulse sequences and currently covers the radar
types as defined by ETSI 1.5.1.

The second patch adds an instance of the pattern detector to
ath_softc and the last one adapts the interface of the existing
DFS pulse detection module for the added detector.

Note that DFS detection is not activated with this patch, due
to pending DFS master support in the upper layers and the lack
of tested and DFS certified Atheros devices (see kernel config
option ATH9K_DFS_CERTIFIED).


[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/87859/

Zefir Kurtisi (3):
  ath9k: add DFS pattern detector
  ath9k: add DFS pattern detector instance to ath_softc
  ath9k: update to DFS pattern detector interface

 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c               |   80 ++---
 drivers/net/wireless/ath/ath9k/dfs.h               |    8 +-
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |  300 +++++++++++++++
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |  104 ++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |  390 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h  |   52 +++
 drivers/net/wireless/ath/ath9k/init.c              |    4 +
 9 files changed, 892 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h

-- 
1.7.4.1

