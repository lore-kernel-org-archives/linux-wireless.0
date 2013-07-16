Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46464 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GPHUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:20:08 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infraread.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 00/10] ath10k: device setup refactor
Date: Tue, 16 Jul 2013 09:19:43 +0200
Message-ID: <1373959193-5164-1-git-send-email-michal.kazior@tieto.com> (sfid-20130716_092013_417117_201E3777)
In-Reply-To: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a respin of my patchset that addresses
hibernation issues.

This is also groundwork for proper hw recovery
that I'm going to post too.

v3:
 * update comments in pci logic decoupling
 * add missing commit message for one of the patches
 * update commit message for free_vdev_map patch

Michal Kazior (10):
  ath10k: decouple pci start/stop logic
  ath10k: decouple core start/stop logic
  ath10k: allow deferred regd update
  ath10k: reset BMI state upon init
  ath10k: decouple suspend code
  ath10k: move free_vdev_map initialization
  ath10k: make sure all resources are freed upon ath10k_stop()
  ath10k: defer hw setup to start/stop mac80211 hooks
  ath10k: store firmware files in memory
  ath10k: skip fw stats debugfs interface if device is down

 drivers/net/wireless/ath/ath10k/bmi.c   |    6 +
 drivers/net/wireless/ath/ath10k/bmi.h   |    1 +
 drivers/net/wireless/ath/ath10k/core.c  |  249 +++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/core.h  |   16 +-
 drivers/net/wireless/ath/ath10k/debug.c |   30 ++--
 drivers/net/wireless/ath/ath10k/hif.h   |   39 +++++
 drivers/net/wireless/ath/ath10k/mac.c   |  151 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/pci.c   |  283 +++++++++++++------------------
 8 files changed, 497 insertions(+), 278 deletions(-)

-- 
1.7.9.5

