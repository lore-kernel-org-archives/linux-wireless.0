Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZJFDx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 23:53:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: vasanth@atheros.com, linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 0/4] ath9k: fix oops during driver unload
Date: Mon,  5 Oct 2009 23:53:17 -0400
Message-Id: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix an oops reported by Vasanth.
Vasanth my rc3 poos out, can you let me know if this
fixes the issue you saw?

Luis R. Rodriguez (4):
  ath9k: move common->debug_mask setting to ath_init_softc()
  ath9k: fix oops during unload -- initialize hw prior to debugfs
  ath9k: add helper to un-init the hw properly
  ath9k: rename ath_beaconq_setup() to ath9k_hw_beaconq_setup()

 drivers/net/wireless/ath/ath.h          |    6 ++++
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   12 -------
 drivers/net/wireless/ath/ath9k/debug.c  |    5 ---
 drivers/net/wireless/ath/ath9k/hw.c     |   11 ++++++-
 drivers/net/wireless/ath/ath9k/mac.c    |   13 ++++++++
 drivers/net/wireless/ath/ath9k/mac.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   50 ++++++++++++++++++------------
 8 files changed, 60 insertions(+), 39 deletions(-)

