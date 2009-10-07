Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/6] ath9k: fix rmmod
Date: Tue,  6 Oct 2009 21:19:05 -0400
Message-Id: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series fixes removing ath9k as a module as reported by
Vasanth. I've now tested these as I was finally able to boot
to 2.6.32-rc3.

Luis R. Rodriguez (6):
  ath9k: move common->debug_mask setting to ath_init_softc()
  ath9k: initialize hw prior to debugfs
  ath9k: add helper to un-init the hw properly
  ath9k: add a helper to clean the core driver upon module unload
  ath9k: move ath_cleanup() below helpers to avoid forward declarations
  ath9k: rename ath_beaconq_setup() to ath9k_hw_beaconq_setup()

 drivers/net/wireless/ath/ath.h          |    6 +++
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   12 -----
 drivers/net/wireless/ath/ath9k/debug.c  |    5 --
 drivers/net/wireless/ath/ath9k/hw.c     |   11 ++++-
 drivers/net/wireless/ath/ath9k/mac.c    |   13 ++++++
 drivers/net/wireless/ath/ath9k/mac.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   72 +++++++++++++++++++------------
 8 files changed, 74 insertions(+), 47 deletions(-)

