Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38723 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759781Ab3DCQbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:50 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 0/3] ath9k: enable DFS support
Date: Wed,  3 Apr 2013 18:31:28 +0200
Message-Id: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183155_579690_22E4284F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With Simon finalizing DFS master support in mac80211 and hostapd, these are
the remaining patches to enable DFS radar detection in ath9k.

The series includes updated and rebased versions of patches already posted
as RFCs in the past that has been tested with the latest DFS master enabled
hostapd. While they are clean for review, testing DFS functionality requires
tweaks in mac80211 to resolve pending issues that will be addressed in a
separate patch.

Building ath9k with DFS support requires setting CONFIG_ATH9K_DFS_CERTIFIED.
During testing, ensure to have CONFIG_ATH_DEBUG, CONFIG_ATH9K_DEBUGFS, and
CONFIG_ATH9K_DFS_DEBUGFS enabled.

Simon Wunderlich (2):
  ath9k: add interface combinations for DFS master
  ath9k: add debugfs based DFS radar simulation
Zefir Kurtisi (1):
  ath9k: add support for DFS master mode

 drivers/net/wireless/ath/ath9k/dfs.c       |    4 +--
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   20 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |    3 ++
 drivers/net/wireless/ath/ath9k/init.c      |   36 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/main.c      |   25 ++++++++++++++++---
 drivers/net/wireless/ath/ath9k/recv.c      |    7 +++++
 6 files changed, 80 insertions(+), 15 deletions(-)

-- 
1.7.4.1

