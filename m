Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16357 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaB0OaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:30:19 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 00/16] wil6210: various patches
Date: Thu, 27 Feb 2014 16:20:39 +0200
Message-ID: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_153022_970729_C6D14976)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the patches are related to support for multiple connections.

Other includes:
- Tx management frame
- Provide signal strength indication
- use ether_addr_equal

Vladimir Kondratiev (16):
  wil6210: Tx management frame
  wil6210: [DEBUG] allow to query Rx and all Tx VRING descriptors
  wil6210: [DEBUG] Improve Vring printing
  wil6210: multiple connect - initial support
  wil6210: Block ACK
  wil6210: Find free vring for Tx
  wil6210: broadcast Tx
  wil6210: fix BACK status processing
  wil6210: dump_station initial support
  wil6210: per-connection statistics
  wil6210: disconnect only requested peer
  wil6210: Fill vring2cid_tid table early
  wil6210: Provide signal strength indication
  wil6210: use ether_addr_equal
  wil6210: single station disconnect
  wil6210: do not reorder groupcast Rx

 drivers/net/wireless/ath/wil6210/Makefile     |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c   | 202 +++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/debugfs.c    | 119 +++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c       | 119 ++++++++++++---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 177 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       | 125 ++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.h       |   7 +
 drivers/net/wireless/ath/wil6210/wil6210.h    |  82 ++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c        | 116 +++++++++++++--
 9 files changed, 874 insertions(+), 74 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/rx_reorder.c

-- 
1.8.3.2

