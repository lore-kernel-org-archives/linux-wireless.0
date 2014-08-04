Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58225 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHDIWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:01 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 00/14] wil6210 misc updates
Date: Mon, 4 Aug 2014 11:20:40 +0300
Message-ID: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102207_496797_9463C9B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some updates and bug fixes for wil6210 driver.

Dedy Lansky (2):
  wil6210: Optimization for Interrupt moderation threshold value
  wil6210: Limit max number of associated stations

Vladimir Kondratiev (12):
  wil6210: map MAC timer for packet lifetime into debugfs
  wil6210: fix race in reset
  wil6210: update copyright year 2014
  wil6210: check error in wil_target_reset()
  wil6210: wait longer for hardware reset completion
  wil6210: Workaround for Sparrow with bad device id
  wil6210: convert debugfs to the table mode
  wil6210: fix beamforming data reporting
  wil6210: fix false "scan timeout"
  wil6210: fix free'd memory access in wil_if_free()
  wil6210: cfg80211_rx_mgmt to use GFP_ATOMIC
  wil6210: fix access after free in wil_pcie_remove()

 drivers/net/wireless/ath/wil6210/cfg80211.c   |   6 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    | 372 ++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/interrupt.c  |  10 +-
 drivers/net/wireless/ath/wil6210/main.c       |  30 ++-
 drivers/net/wireless/ath/wil6210/netdev.c     |   8 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |   7 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  16 ++
 drivers/net/wireless/ath/wil6210/txrx.c       |   3 +-
 drivers/net/wireless/ath/wil6210/txrx.h       |   2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  19 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |  47 ++--
 drivers/net/wireless/ath/wil6210/wmi.h        |   4 +-
 12 files changed, 376 insertions(+), 148 deletions(-)

-- 
1.8.5.2

