Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbeEOJKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:10:04 -0400
From: Sriram R <srirrama@codeaurora.org>
To: kvalo@codeaurora.org, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCHv2 0/2]  ath/ath10k: DFS Host Confirmation 
Date: Tue, 15 May 2018 14:39:47 +0530
Message-Id: <1526375389-7106-1-git-send-email-srirrama@codeaurora.org> (sfid-20180515_111025_822037_ECC0F771)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature adds support for the ath10k host to send information
about the specifications of the detected radar to the firmware for validation.
A New WMI interface is added for enabling this communication
of this information between the host and the firmware.

v2:

 * Modified firmware confirmation timeout value to less than 200ms
 * Updated PATCH 2/2  commit log.

Sriram R (2):
  ath: Add support to get the detected radar specifications
  ath10k: DFS Host Confirmation

 drivers/net/wireless/ath/ath10k/core.h          |  21 +++
 drivers/net/wireless/ath/ath10k/mac.c           |  12 ++
 drivers/net/wireless/ath/ath10k/wmi-ops.h       |  32 ++++
 drivers/net/wireless/ath/ath10k/wmi.c           | 186 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h           |  32 ++++
 drivers/net/wireless/ath/ath9k/dfs.c            |   2 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c |   5 +-
 drivers/net/wireless/ath/dfs_pattern_detector.h |   3 +-
 drivers/net/wireless/ath/dfs_pri_detector.h     |   3 +-
 9 files changed, 282 insertions(+), 14 deletions(-)

-- 
2.7.4
