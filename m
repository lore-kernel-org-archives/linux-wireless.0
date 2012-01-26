Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48915 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab2AZPeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:34:13 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org, adrian.chadd@gmail.com,
	kgiori@qca.qualcomm.com, shafi.wireless@gmail.com
Subject: [RFC 0/2] ath9k: DFS pattern detector
Date: Thu, 26 Jan 2012 16:34:02 +0100
Message-Id: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120126_163417_887595_49504751)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

D(FS)-day today!

The first patch proposes a generic DFS pattern detector
built into the common ath module to be used by ath9k for
radar detection.

Some DFS components are not yet ready to allow working
integration of the detector into ath9k. To get some hands
on and test the detector (long) before the required
functionalities are available, the second patch proposes
a framework for stand-alone testing the detector from
user space.


Zefir Kurtisi (2):
  ath9k: add DFS pattern detector
  ath9k/dfs_pattern_detector: add standalone testing

 drivers/net/wireless/ath/Makefile                  |   10 +
 .../net/wireless/ath/dfs_pattern_detector/Makefile |    7 +
 .../ath/dfs_pattern_detector/detector_elem.c       |   92 ++++++
 .../ath/dfs_pattern_detector/detector_elem.h       |   45 +++
 .../dfs_pattern_detector/dfs_pattern_detector.h    |   92 ++++++
 .../net/wireless/ath/dfs_pattern_detector/module.c |   20 ++
 .../ath/dfs_pattern_detector/pattern_detector.c    |  294 ++++++++++++++++++++
 .../ath/dfs_pattern_detector/pulse_queue.c         |  168 +++++++++++
 .../ath/dfs_pattern_detector/pulse_queue.h         |   77 +++++
 .../ath/dfs_pattern_detector/pulse_sequence.c      |  280 +++++++++++++++++++
 .../ath/dfs_pattern_detector/pulse_sequence.h      |   89 ++++++
 .../ath/dfs_pattern_detector/radar_types.c         |   52 ++++
 .../ath/dfs_pattern_detector/radar_types.h         |   95 +++++++
 .../ath/dfs_pattern_detector/testing/Makefile      |   44 +++
 .../testing/dfs_netlink_relay.c                    |  115 ++++++++
 .../ath/dfs_pattern_detector/testing/dfs_tester.c  |  101 +++++++
 .../net/wireless/ath/dfs_pattern_detector/utils.c  |   45 +++
 .../net/wireless/ath/dfs_pattern_detector/utils.h  |   30 ++
 18 files changed, 1656 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/Makefile
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/module.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/Makefile
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_netlink_relay.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_tester.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.h

-- 
1.7.4.1

