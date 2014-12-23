Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:47:51 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 00/22] wil6210 patches
Date: Tue, 23 Dec 2014 09:47:02 +0200
Message-Id: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084800_871135_AC0D7BA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several topics:
- block ack with secure and insecure connection
- MTU
- some infrastructure fixes
- some debugfs changes

Vladimir Kondratiev (22):
  wil6210: ADDBA/DELBA flows
  wil6210: simple ADDBA on originator (Tx) side
  wil6210: allow to configure ADDBA request
  wil6210: improve debugfs for reorder buffer
  wil6210: fix disconnect 1 STA in AP
  wil6210: improve debugfs for VRING
  wil6210: control AMSDU on Tx side of Block Ack
  wil6210: delba for responder
  wil6210: fix max. MPDU size
  wil6210: consider SNAP header in MTU calculations
  wil6210: Increase number of associated stations
  wil6210: use bitmap API for "status"
  wil6210: fix Tx VRING for STA mode
  wil6210: rework debugfs for BACK
  wil6210: detect HW capabilities
  wil6210: use HW capabilities mask in reset
  wil6210: add advanced interrupt moderation
  wil6210: RX high threshold interrupt configuration
  wil6210: fix reordering for MCAST
  wil6210: Tx/Rx descriptors documentation
  wil6210: workaround for BACK establishment race
  wil6210: relax spinlocks in rx reorder

 drivers/net/wireless/ath/wil6210/cfg80211.c   |  12 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    | 160 +++++++++++++--
 drivers/net/wireless/ath/wil6210/ethtool.c    |  46 +++--
 drivers/net/wireless/ath/wil6210/interrupt.c  | 109 ++++++++--
 drivers/net/wireless/ath/wil6210/main.c       | 194 ++++++++++--------
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  65 ++++--
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 275 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.c       |  70 +++++--
 drivers/net/wireless/ath/wil6210/txrx.h       | 158 ++++++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h    | 161 +++++++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c        | 221 +++++++++++++++++----
 drivers/net/wireless/ath/wil6210/wmi.h        |  12 +-
 12 files changed, 1199 insertions(+), 284 deletions(-)

-- 
2.1.0

