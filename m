Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49913 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFPQiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:11 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 00/25] wil6210 patches
Date: Mon, 16 Jun 2014 19:36:58 +0300
Message-ID: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183816_152299_E42DF92B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the patches are various debug, tracing and performance
monitoring features. 60G technology overall is not mature yet,
as well as wil6210's firmware, so many debug hooks are needed
for the future work.

Fixes include "fix disconnect handling for AP" and
"fix for unreachable code in wmi_recv_cmd"

Another commit to mention is
"work around for platforms with broken INTx"
where platform with broken BIOS is addressed.

Vladimir Kondratiev (25):
  wil6210: Tx mgmt frame from debugfs
  wil6210: indicate mgmt_tx status
  wil6210: print debug info when starting AP
  wil6210: trace wil->status on debugfs
  wil6210: print more info about BSS found
  wil6210: more debug info for vring
  wil6210: Tx performance monitoring
  wil6210: Allow driver load if FW not ready
  wil6210: BACK: track last dropped SSN
  wil6210: debugfs interface to send raw WMI command
  wil6210: writeable ITR registers
  wil6210: print error when notifying about FW error
  wil6210: debug print when scan request state changes
  wil6210: Use "name = value" format in the debugfs
  wil6210: add 'freq' and 'link' debugfs entries
  wil6210: Debug print GRO Rx result
  wil6210: avoid dmesg pollution by Tx errors
  wil6210: fix disconnect handling for AP
  wil6210: remove unused #include
  wil6210: map additional registers on target
  wil6210: fix for unreachable code in wmi_recv_cmd
  wil6210: work around for platforms with broken INTx
  wil6210: add 'info' debugfs entry
  wil6210: interrupt statistics
  wil6210: track Tx queue state

 drivers/net/wireless/ath/wil6210/cfg80211.c   |  68 +++++-
 drivers/net/wireless/ath/wil6210/debugfs.c    | 304 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/interrupt.c  |   3 +
 drivers/net/wireless/ath/wil6210/main.c       |  22 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  31 ++-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   1 +
 drivers/net/wireless/ath/wil6210/txrx.c       |  33 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  10 +-
 drivers/net/wireless/ath/wil6210/wmi.c        |  40 ++--
 9 files changed, 465 insertions(+), 47 deletions(-)

-- 
1.9.1

