Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:65190 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Qcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:32:31 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 00/14] wil6210: assorted fixes
Date: Mon, 28 Jan 2013 18:30:55 +0200
Message-ID: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173243_261353_AA554DFA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following is collection of ready for integration fixes,
tested in the lab.

Vladimir Kondratiev (14):
  wil6210: Detect FW error
  wil6210: rearrange IRQ debug printing
  wil6210: remove raw wil_dbg() calls
  wil6210: Refactor rx init/fini
  wil6210: Count Tx statistics on Tx completion
  wil6210: Fix: Tx stall
  wil6210: Call skb_orphan() right before Rx indication
  wil6210: Fix "don't scan after connect" logic
  wil6210: Separate common code for mbox regs caching to function
  wil6210: Reorder reset preparation sequence
  wil6210: fix checkpatch CamelCase warnings
  wil6210: checkpatch warnings
  wil6210: Never delete Rx chain with firmware
  wil6210: fix wil_vring_init_tx status

 drivers/net/wireless/ath/wil6210/cfg80211.c  |    9 +--
 drivers/net/wireless/ath/wil6210/interrupt.c |   55 ++++++++-----
 drivers/net/wireless/ath/wil6210/main.c      |   63 +++++++--------
 drivers/net/wireless/ath/wil6210/netdev.c    |   31 +-------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |    4 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |  107 ++++++++------------------
 drivers/net/wireless/ath/wil6210/wil6210.h   |   22 +++---
 drivers/net/wireless/ath/wil6210/wmi.c       |  107 +++++++++++++++++++-------
 8 files changed, 199 insertions(+), 199 deletions(-)

-- 
1.7.10.4

