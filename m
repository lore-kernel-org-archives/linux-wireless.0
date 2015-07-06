Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbGFHkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 03:40:22 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 00/13] wil6210 patches
Date: Mon,  6 Jul 2015 10:39:36 +0300
Message-Id: <1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150706_094026_404620_06BB31F0)
In-Reply-To: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several new features introduced:
- TSO improves throughput on Tx side on systems with weak CPU
- ACS chooses best channel automatically when starting AP
- support for the new boot loader

Bug fixes:
- "wait for del_station to complete"
- "hold wil->mutex while managing vrings"

The rest are small fixes and improvements

V2: found bug in the commit for TSO - by mistake, reported was
NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Re-sending whole series
to avoid confusion

Dedy Lansky (1):
  wil6210: treat "unhandled event" as warning instead of error

Vladimir Kondratiev (12):
  wil6210: support boot loader struct v0 & v1
  wil6210: ACS implementation using QCA vendor command
  wil6210: debugfs for channel survey
  wil6210: count drops in Rx block ack reorder
  wil6210: print "ulong" fields in hex format in the debugfs
  wil6210: use <> vs. "" for global include
  wil6210: wait for del_station to complete
  wil6210: hold wil->mutex while managing vrings
  wil6210: use wil_fw_error_recovery()
  wil6210: skip HW version check for chip debugging
  wil6210: TSO implementation
  wil6210: improve mgmt frame handling

 drivers/net/wireless/ath/wil6210/boot_loader.h  |  57 ++++
 drivers/net/wireless/ath/wil6210/cfg80211.c     | 389 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c      |  64 +++-
 drivers/net/wireless/ath/wil6210/main.c         | 112 +++++--
 drivers/net/wireless/ath/wil6210/netdev.c       |   4 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c   |   2 +
 drivers/net/wireless/ath/wil6210/txrx.c         | 383 ++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.h         |   8 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  18 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c          | 129 ++++++--
 drivers/net/wireless/ath/wil6210/wmi.h          |  38 ++-
 12 files changed, 1128 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/boot_loader.h

-- 
2.1.4

