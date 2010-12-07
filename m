Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44431 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab0LGXN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:13:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:13:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 0/5] ath9k: few power save / suspend fixes
Date: Tue, 7 Dec 2010 15:13:18 -0800
Message-ID: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon further review with Johannes on the semantics of mac80211's
idle notifications we decided its best to leave it up to the drivers
to ensure idle state after mac80211 issues a stop() callback to
the drivers. This means if you are relying on the IDLE notification
you should not expect it after a stop() callback to disable your
radio. The implications of this means you need to ensure you keep
your 802.11 device idle after stop() and anything in between.

The other patches are a few debug warn once messages which will
only be enabled when you have debugging turned on, I also
integrated Ben's patch into the series as it added the Atheros
debug WARN_ON_ONCE() which I reuse in my other patches..

Ben Greear (1):
  ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.

Luis R. Rodriguez (4):
  ath9k: Fix power save count imbalance on ath_radio_enable()
  ath9k: fix assumptions for idle calls on suspend/resume
  ath9k: skip ATH9K_INT_TIM_TIMER when we are idle
  ath9k_hw: warn if we cannot change the power to the chip

 drivers/net/wireless/ath/ath9k/hw.c   |    7 +++
 drivers/net/wireless/ath/ath9k/main.c |   10 ++--
 drivers/net/wireless/ath/ath9k/pci.c  |    3 +
 drivers/net/wireless/ath/debug.h      |   94 +++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/debug.h

-- 
1.7.3.2.90.gd4c43

