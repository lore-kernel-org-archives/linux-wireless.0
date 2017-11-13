Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40034 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdKMJj7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:39:59 -0500
From: <pkshih@realtek.com>
To: <Larry.Finger@lwfinger.net>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <steventing@realtek.com>,
        <yhchuang@realtek.com>
Subject: [PATCH 0/3] rtlwifi: Refactor TX/RX flow to improve throughput
Date: Mon, 13 Nov 2017 17:39:32 +0800
Message-ID: <20171113093935.20431-1-pkshih@realtek.com> (sfid-20171113_104017_216995_8A0B2736)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This patchset is aim to reduce IO to improve TX/RX performance, and also I
cleanup the code to make it easier and simpler.

Ping-Ke Shih (3):
  rtlwifi: Reduce IO in RX interrupt to boost throughput
  rtlwifi: fix the wrong size to calculate fifo space
  rtlwifi: cleanup the code that check whether TX ring is available

 drivers/net/wireless/realtek/rtlwifi/pci.c         | 13 ++---
 drivers/net/wireless/realtek/rtlwifi/pci.h         |  5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   | 57 ++++------------------
 3 files changed, 15 insertions(+), 60 deletions(-)

-- 
2.14.1
