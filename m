Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaCQNej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:39 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 00/21] wil6210: misc updates
Date: Mon, 17 Mar 2014 15:34:04 +0200
Message-ID: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143450_891891_31898404)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- HW optimization support: SG, GRO
- few updates for the card reset flow
- assorted bug fixes

Vladimir Kondratiev (21):
  wil6210: Helpers to deal with 'cidxtid' fields
  wil6210: Block data till "data port open" reported
  wil6210: enable scan while connected
  wil6210: add scatter-gather support
  wil6210: generalize tx desc mapping
  wil6210: update target reset to support new HW
  wil6210: reduce dmesg pollution after FW crash
  wil6210: report reset time
  wil6210: fix for HW bug in interrupt setup logic
  wil6210: sort HW registers definitions
  wil6210: reset on power good
  wil6210: reduce printing
  wil6210: fix memory leak in the AP flow
  wil6210: Fix kernel oops in reset flow
  wil6210: fw error recovery
  wil6210: fix secondary connect
  wil6210: serialize fw_recovery and start_ap
  wil6210: use GRO
  wil6210: target reset flow update
  wil6210: add memory barriers for the reset flow
  wil6210: fix race between disconnect and Tx NAPI

 drivers/net/wireless/ath/wil6210/cfg80211.c  |  43 ++++--
 drivers/net/wireless/ath/wil6210/debugfs.c   |  64 +++++---
 drivers/net/wireless/ath/wil6210/interrupt.c |  33 +++-
 drivers/net/wireless/ath/wil6210/main.c      | 119 +++++++++++++-
 drivers/net/wireless/ath/wil6210/netdev.c    |   5 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |   5 +
 drivers/net/wireless/ath/wil6210/txrx.c      | 223 +++++++++++++++++----------
 drivers/net/wireless/ath/wil6210/wil6210.h   |  82 ++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c       |  20 ++-
 9 files changed, 454 insertions(+), 140 deletions(-)

-- 
1.8.3.2

