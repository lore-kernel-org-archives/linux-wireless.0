Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbbAYIxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:23 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 00/10] wil6210 patches
Date: Sun, 25 Jan 2015 10:52:41 +0200
Message-Id: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095333_115202_D75473CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Performance tuning; some AP features; some small fixes

Dedy Lansky (2):
  wil6210: fix timing of netif_carrier_on indication
  wil6210: ignore firmware failure to gracefully stop AP

Vladimir Kondratiev (4):
  wil6210: sync WMI with firmware
  wil6210: Tx status
  wil6210: probe_client
  wil6210: move Rx reorder buffer allocation out of spinlock

Vladimir Shulman (4):
  wil6210: Add Tx queue len configuration
  wil6210: tuning rings size
  wil6210: interrupt moderation configuration update
  wil6210: remove unnecessary interrupt moderation module parameters

 drivers/net/wireless/ath/wil6210/cfg80211.c   | 112 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c       |  73 ++++-------------
 drivers/net/wireless/ath/wil6210/netdev.c     |  15 ++--
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   8 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  19 ++++-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  25 ++++--
 drivers/net/wireless/ath/wil6210/wmi.c        |  17 ++--
 drivers/net/wireless/ath/wil6210/wmi.h        |  58 +++++++++++--
 8 files changed, 227 insertions(+), 100 deletions(-)

-- 
2.1.0

