Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17654 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0LGCtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:49:03 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:48:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<amod.bodas@atheros.com>, <pstew@google.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/5] ath9k: warn when we get a ATH9K_INT_TIM_TIMER and are idle
Date: Mon, 6 Dec 2010 18:48:51 -0800
Message-ID: <1291690135-4535-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not be idle when we get the ATH9K_INT_TIM_TIMER,
otherwise we wake up the chip and that throws off the idle
state, the driver needs to be in full sleep when idle and
nothing should turn it awake without turning it back to
full sleep again. If we leave the chip idle and suspend,
upon resume the device will become unusable and we get:

ath: Starting driver with initial channel: 5745 MHz
ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f026a03..fd27ec9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -770,6 +770,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		if (status & ATH9K_INT_TIM_TIMER) {
 			/* Clear RxAbort bit so that we can
 			 * receive frames */
+			WARN_ON(sc->ps_idle);
 			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			ath9k_hw_setrxabort(sc->sc_ah, 0);
 			sc->ps_flags |= PS_WAIT_FOR_BEACON;
-- 
1.7.3.2.90.gd4c43

