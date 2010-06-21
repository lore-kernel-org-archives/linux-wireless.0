Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] ath9K_hw: few ASPM fixes for AR9003
Date: Mon, 21 Jun 2010 18:38:46 -0400
Message-Id: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few ASPM fixes for the AR9003 family. With it
I now have L0s and L1 enabled on my AR9003. I threw an
unrelated but super small patch at the end of the series
as it was the only one left on my queue.

Luis R. Rodriguez (5):
  ath9k_hw: fix ASPM setting for AR9003
  ath9k_hw: move LowPower array writes to
    ar9003_hw_configpcipowersave()
  ath9k_hw: add pcieSerDesWrite to disable SERDES ASPM tweaks
  ath9k_hw: dynamically choose the SERDES array for low power
  ath9k_hw: add an extra delay when reseting AR_RTC_RESET

 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   20 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   55 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/hw.h        |    7 ++++
 drivers/net/wireless/ath/ath9k/reg.h       |    5 +++
 4 files changed, 70 insertions(+), 17 deletions(-)

