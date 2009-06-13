Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45033 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZFMJ0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 05:26:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 02:26:43 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/3] Porting to cfg80211 rfkill 
Date: Sat, 13 Jun 2009 14:50:23 +0530
Message-ID: <1244884826-3009-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly has Johannes' rfkill porting and other two patches
to allow wiphy_rfkill_polling to be done at attach time instead of at the
time when the interface is brought up which used to be done before.
With this series a kernel panic, which is a regression, during module
unload disappears.

Johannes Berg (1):
  ath9k: port to cfg80211 rfkill

Vasanthakumar Thiagarajan (2):
  ath9k: Add helper to get ath9k specific current channel
  ath9k: Make sure we have current channel in ah_curchan before rf
    disable/enable

 drivers/net/wireless/ath/ath9k/Kconfig |    1 -
 drivers/net/wireless/ath/ath9k/ath9k.h |    9 ---
 drivers/net/wireless/ath/ath9k/hw.c    |   29 ++++----
 drivers/net/wireless/ath/ath9k/hw.h    |    3 -
 drivers/net/wireless/ath/ath9k/main.c  |  120 +++++++++----------------------
 5 files changed, 48 insertions(+), 114 deletions(-)

