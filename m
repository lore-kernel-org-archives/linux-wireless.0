Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32175 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBJrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:47:00 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 00/10] wil6210 fixes, reroll
Date: Tue, 2 Dec 2014 11:46:28 +0200
Message-ID: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_104715_984944_D369D11C)
In-Reply-To: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assorted fixes

V2: split single commit into 2, accordingly to input by
Joe Perches.

re-sending whole series to avoid mis-interpretation.

Vladimir Kondratiev (10):
  wil6210: propagate disconnect reason
  wil6210: introduce wil_err_ratelimited()
  wil6210: add handling of RX HTRSH interrupt
  wil6210: fix recovery after scan timeout
  wil6210: remove wil_to_pcie_dev()
  wil6210: configurable vring sizes
  wil6210: fix warning in pointer arithmetic
  wil6210: Rate limit "ring full" error message
  wil6210: reset flow update
  wil6210: remove TODO wrt buffer alignment

 drivers/net/wireless/ath/wil6210/cfg80211.c  |  2 +-
 drivers/net/wireless/ath/wil6210/debug.c     | 17 ++++++++
 drivers/net/wireless/ath/wil6210/fw.c        |  1 -
 drivers/net/wireless/ath/wil6210/fw_inc.c    |  4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c | 30 +++++++++++--
 drivers/net/wireless/ath/wil6210/main.c      | 63 +++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/txrx.c      | 11 +++--
 drivers/net/wireless/ath/wil6210/wil6210.h   | 15 ++++---
 drivers/net/wireless/ath/wil6210/wmi.c       |  8 ++--
 9 files changed, 114 insertions(+), 37 deletions(-)

-- 
2.1.0

