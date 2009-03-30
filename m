Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12734 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbZC3KC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:26 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38830.285708.842901@gargle.gargle.HOWL> (sfid-20090330_120229_839901_241912CE)
Date: Mon, 30 Mar 2009 15:28:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 00/17] Driver cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of cleanups and a few fixes.
Please apply.

Sujith

Sujith (17):
  ath9k: Remove a few unused flags
  ath9k: Remove redundant chainmask check
  ath9k: Cleanup debug messages
  ath9k: Change return value of ath9k_hw_fill_cap_info
  ath9k: Remove redundant variable for Interrupt Mitigation
  ath9k: Avoid unneeded casts
  ath9k: Cleanup buffer status handling
  ath9k: Remove a couple of unused variables in descriptor handling
  ath9k: Remove unused structures
  ath9k: Check for root debugfs file
  ath9k: Remove TIM from the interrupt mask
  ath9k: Remove the useless do..while loops
  ath9k: Initialize values when setting up the queue parameters
  ath9k: Trivial fix to handle AMPDU params properly
  ath9k: Clean Interrupt handling routine
  ath9k: Determine number of streams from HT capabilities
  ath9k: Fix bug in determining HT40 mode

 drivers/net/wireless/ath9k/ani.c    |    8 +-
 drivers/net/wireless/ath9k/ath9k.h  |   65 +++-------
 drivers/net/wireless/ath9k/beacon.c |   17 +--
 drivers/net/wireless/ath9k/debug.c  |    3 +
 drivers/net/wireless/ath9k/debug.h  |   24 ++--
 drivers/net/wireless/ath9k/eeprom.c |   24 ++--
 drivers/net/wireless/ath9k/hw.c     |  154 ++++++++---------------
 drivers/net/wireless/ath9k/hw.h     |   57 +++------
 drivers/net/wireless/ath9k/mac.c    |   63 ++++++----
 drivers/net/wireless/ath9k/main.c   |  239 ++++++++++++++++-------------------
 drivers/net/wireless/ath9k/phy.c    |    4 +-
 drivers/net/wireless/ath9k/phy.h    |    3 -
 drivers/net/wireless/ath9k/rc.c     |   24 ++--
 drivers/net/wireless/ath9k/rc.h     |    4 -
 drivers/net/wireless/ath9k/recv.c   |   85 ++++++-------
 drivers/net/wireless/ath9k/xmit.c   |   59 ++++-----
 16 files changed, 350 insertions(+), 483 deletions(-)

