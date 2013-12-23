Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33089 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWHTZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:19:25 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 0/9] ath9k patches
Date: Mon, 23 Dec 2013 12:44:17 +0530
Message-Id: <1387782866-19847-1-git-send-email-sujith@msujith.org> (sfid-20131223_081928_794984_8CD14A6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Hi,

This series has a number of fixes for the baseband watchdog
code and the hang signatures have been updated.

The RX poll routine has been removed.

The HW hang check function is simple now and is currently
used only in the beacon transmission patch. For normal transmission,
we already have the TX poll routine, but it would help to
monitor GTT interrupts and check the HW periodically.
We can unify the normal TX poll function and the GTT monitoring
logic.

Right now, beacon transmission doesn't have any fancy logic
for identifying strong interference. We just do a Noise Floor
calibration in case we miss 3 beacons. This can probably be improved
by adjusting the immunity levels.

Code to handle MAC/BB hangs in the AR9002 family is yet to be added.

Please review !

Sujith

Sujith Manoharan (9):
  ath9k: Fix max AMPDU size calculation
  ath9k: Register supported HW hang checks
  ath9k: Add HW callbacks for MAC/BB hang checks
  ath9k: Fix MAC HW hang check for AR9003
  ath9k: Fix PHY restart workaround
  ath9k: Fix baseband watchdog interrupts
  ath9k: Identify baseband watchdog signatures
  ath9k: Fix baseband watchdog reset
  ath9k: Remove RX Poll

 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |  15 ++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  | 113 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  79 ++++++++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   2 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   7 +-
 drivers/net/wireless/ath/ath9k/beacon.c     |  10 ++-
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  15 ++++
 drivers/net/wireless/ath/ath9k/hw.c         |  80 +-------------------
 drivers/net/wireless/ath/ath9k/hw.h         |  26 +++++--
 drivers/net/wireless/ath/ath9k/init.c       |   2 -
 drivers/net/wireless/ath/ath9k/link.c       |  63 ++--------------
 drivers/net/wireless/ath/ath9k/mac.c        |  24 +++++-
 drivers/net/wireless/ath/ath9k/main.c       |  48 ++++++------
 drivers/net/wireless/ath/ath9k/recv.c       |   4 -
 drivers/net/wireless/ath/ath9k/reg.h        |   1 +
 drivers/net/wireless/ath/ath9k/wow.c        |   1 -
 drivers/net/wireless/ath/ath9k/xmit.c       |   9 +--
 17 files changed, 305 insertions(+), 194 deletions(-)

-- 
1.8.5.2

