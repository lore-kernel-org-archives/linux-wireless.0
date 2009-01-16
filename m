Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46713 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZAPQLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:11:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:11:05 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45259.999815.869498@gargle.gargle.HOWL> (sfid-20090116_171112_805282_0911EB5B)
Date: Fri, 16 Jan 2009 21:37:39 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/9] ath9k driver updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A few driver cleanups/fixes.
This series will apply over the 11 patch series by Gabor Juhos.

Sujith

Sujith (9):
  ath9k: rateCodeToIndex is not used, remove it
  ath9k: Update short guard interval in rate control
  ath9k: Reorganize code in xmit.c
  ath9k: Remove ath_tx_stopdma and call ath9k_hw_stoptxdma directly
  ath9k: Merge queue draining functions
  ath9k: Add a helper function to wake mac80211 queues
  ath9k: Handle holding descriptor in TX completion properly
  ath9k: Revamp TX aggregation
  ath9k: Cleanup buffer type assignment

 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/core.h   |   20 +-
 drivers/net/wireless/ath9k/main.c   |    8 +-
 drivers/net/wireless/ath9k/rc.c     |   17 +-
 drivers/net/wireless/ath9k/rc.h     |    1 -
 drivers/net/wireless/ath9k/xmit.c   | 2859 +++++++++++++++--------------------
 6 files changed, 1260 insertions(+), 1647 deletions(-)

