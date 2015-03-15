Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbCOOAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:42 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 0/7] wil6210 patches
Date: Sun, 15 Mar 2015 16:00:14 +0200
Message-Id: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150052_629896_98E82AB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- real broadcast, in DMG networks it is not that trivial...
- found approach to achieve 4*n+2 alignment of Rx frames
- small fixes here and there

Vladimir Kondratiev (7):
  wil6210: optimize index manipulation in wil_vring_reap_rx
  wil6210: fix check for FW responsiveness
  wil6210: Align Rx frames on 4*n+2 by having SNAP
  wil6210: Prefer ether_addr_copy() over memcpy()
  wil6210: add bcast structures to WMI
  wil6210: implement broadcast/multicast data
  wil6210: fall back to pseudo-DMS mcast for secure link and PBSS

 drivers/net/wireless/ath/wil6210/cfg80211.c |  18 ++-
 drivers/net/wireless/ath/wil6210/debugfs.c  |  18 ++-
 drivers/net/wireless/ath/wil6210/main.c     |  35 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   2 -
 drivers/net/wireless/ath/wil6210/txrx.c     | 230 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/wil6210/wil6210.h  |   7 +
 drivers/net/wireless/ath/wil6210/wmi.c      |  16 +-
 drivers/net/wireless/ath/wil6210/wmi.h      |  23 ++-
 8 files changed, 296 insertions(+), 53 deletions(-)

-- 
2.1.0

