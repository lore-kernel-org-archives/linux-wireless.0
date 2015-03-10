Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:23759 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbbCJQti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:49:38 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 0/3] ath9k: add DFS support for HT40
Date: Tue, 10 Mar 2015 17:49:28 +0100
Message-Id: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150310_174947_906427_50388157)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros chipsets certified for DFS (currently AR_SREV_VERSION_9580)
also support HT40 DFS mode. This patch series provides handling of
radar pulses reported for primary and extension channels and
sets small knobs in the detector and interface-combinations to
enable operating on HT40 DFS channels.


Zefir Kurtisi (3):
  ath9k: restart only triggering DFS detector line
  ath9k: add DFS support for extension channel
  ath9k: allow 40MHz radar detection width

 drivers/net/wireless/ath/ath9k/dfs.c            | 44 ++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/init.c           |  3 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c |  2 +-
 3 files changed, 32 insertions(+), 17 deletions(-)

-- 
1.9.1

