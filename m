Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54947 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbcAMPq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:46:56 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 0/7] Add support for Per STA Rx duration
Date: Wed, 13 Jan 2016 21:16:27 +0530
Message-ID: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164700_137771_47300B59)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

*Enable parsing of rx_duration as part of peer stats support
 by the new 10.2.4 firmware
*Add support to dump per STA rx_duration  (usecs)
*Pre-requisite cleanups
*For calculating total rx-duration in host, enable provision to
 support periodic peer stats update.
*Also enable mac80211 debugfs entry to track per STA rx duration(usecs)

Mohammed Shafi Shajakhan (7):
  ath10k: Add support for parsing per STA rx_duration for 10.2.4
  ath10k: Fix naming Peer stats rssi_changed field in 10.2.4
  ath10k: Cleanup setting pdev paramaters
  ath10k: Rename few function names of firmware stats
  ath10k: Provision to support periodic peer stats update
  ath10k: Enable periodic peer stats update
  ath10k: Add debugfs support for Per STA total rx duration

 drivers/net/wireless/ath/ath10k/core.h        |    2 ++
 drivers/net/wireless/ath/ath10k/debug.c       |   28 ++++++++++-------
 drivers/net/wireless/ath/ath10k/debug.h       |    6 ++++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   41 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |   32 +++++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.c         |   22 +++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h         |   14 ++++++++-
 7 files changed, 122 insertions(+), 23 deletions(-)

-- 
1.7.9.5

