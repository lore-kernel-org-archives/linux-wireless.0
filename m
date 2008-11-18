Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26626 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYKRDfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:35:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:35:32 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14164.513269.623545@gargle.gargle.HOWL> (sfid-20081118_043538_261578_1D4FB048)
Date: Tue, 18 Nov 2008 09:02:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 00/18] ath9k: Driver updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of driver updates, mostly rate control cleanup.
This series applies on top of all the pending patches for ath9k.
( The series from Senthil, PCI fixes from Luis, and an antenna fix from Vasanth )

Sujith

Sujith (18):
  ath9k: Merge struct ath_tx_ratectrl with ath_rate_node
  ath9k: Simplify RC alloc/free functions
  ath9k: Remove ath_setup_rates
  ath9k: Remove ath_rate_newassoc()
  ath9k: Remove half/quarter rate tables
  ath9k: Nuke fixed rate handling in driver
  ath9k: Revamp RX handling
  ath9k: We don't support non-HT devices, so remove superfluous code.
  ath9k: Remove rate control reference in VAP
  ath9k: Remove ath_rate_softc
  ath9k: Use rate_driver_data
  ath9k: Remove ath9k_rate_table
  ath9k: General code scrub
  ath9k: Use helpers
  ath9k: Move TX completion routine to xmit.c
  ath9k: Fix bug in deciphering channel flags
  ath9k: Update TX trigger level on a FIFO underrun.
  ath9k: Use straightforward PCI routines to setup the TX buffer.

 drivers/net/wireless/ath9k/ath9k.h  |   47 +-
 drivers/net/wireless/ath9k/beacon.c |    8 +-
 drivers/net/wireless/ath9k/core.c   |   60 +--
 drivers/net/wireless/ath9k/core.h   |  118 +--
 drivers/net/wireless/ath9k/hw.c     |  205 +----
 drivers/net/wireless/ath9k/mac.c    |    4 +-
 drivers/net/wireless/ath9k/main.c   |  148 +---
 drivers/net/wireless/ath9k/rc.c     | 1700 +++++++++++++----------------------
 drivers/net/wireless/ath9k/rc.h     |  218 +----
 drivers/net/wireless/ath9k/recv.c   |  577 +++++--------
 drivers/net/wireless/ath9k/xmit.c   |  443 +++------
 11 files changed, 1124 insertions(+), 2404 deletions(-)

