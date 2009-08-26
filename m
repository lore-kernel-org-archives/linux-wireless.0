Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45794 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZHZPrB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:03 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/8] ath9k: WLAN-BT coexistence clean up and 3-wire support 
Date: Wed, 26 Aug 2009 21:08:42 +0530
Message-ID: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This series has WLAN-BT coex 3-wire support and clean ups in BT coex
part.

Vasanth

Vasanthakumar Thiagarajan (8):
  ath9k: Split ath9k_hw_btcoex_enable() into two logical pieces
  ath9k: Move btcoex stuff from hw.[ch] to new btcoex.[ch]
  ath9k: Configure btcoex register during every reset
  ath9k: Move btcoex related data to a separate struct
  ath9k: Determine btcoex scheme type based on chip version
  ath9k: Remove hw capability bit meant for btcoex
  ath9k: Add infrastructure for generic hw timers
  ath9k: Add Bluetooth Coexistence 3-wire support

 drivers/net/wireless/ath/ath9k/Makefile |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |    5 +
 drivers/net/wireless/ath/ath9k/btcoex.c |  319 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h |   98 ++++++++++
 drivers/net/wireless/ath/ath9k/debug.h  |    2 +
 drivers/net/wireless/ath/ath9k/hw.c     |  239 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h     |   57 +++++-
 drivers/net/wireless/ath/ath9k/main.c   |   33 +++-
 drivers/net/wireless/ath/ath9k/reg.h    |   64 ++++++-
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 +-
 10 files changed, 795 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/btcoex.c
 create mode 100644 drivers/net/wireless/ath/ath9k/btcoex.h

