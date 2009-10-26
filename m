Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZJZOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:38:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] ath9k_hw: modify hw identification message
Date: Mon, 26 Oct 2009 10:38:57 -0400
Message-Id: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While reviewing ar9271 radio revisions I determined the radio revision
does not apply although it can be populated in the EEPROM. This changes
the hw probe print to reflect this for single chips and throws the code
into hw code to be shared with ath9k_htc.

Luis R. Rodriguez (4):
  ath9k_hw: move mac name and rf name helpers to hw code
  ath9k_hw: distinguish single-chip solutions on initial probe print
  ath9k_hw: add AR9271 single chip name mapping
  ath9k_hw: add some debug print for hw initialization

 drivers/net/wireless/ath/ath9k/ahb.c   |   10 ++--
 drivers/net/wireless/ath/ath9k/calib.c |    3 +
 drivers/net/wireless/ath/ath9k/hw.c    |   90 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +
 drivers/net/wireless/ath/ath9k/main.c  |   58 --------------------
 drivers/net/wireless/ath/ath9k/pci.c   |   10 ++--
 6 files changed, 103 insertions(+), 70 deletions(-)

