Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44457 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab0LGXNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:13:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:13:18 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 4/5] ath9k: skip ATH9K_INT_TIM_TIMER when we are idle
Date: Tue, 7 Dec 2010 15:13:22 -0800
Message-ID: <1291763603-26546-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
References: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not be idle when we get the ATH9K_INT_TIM_TIMER,
otherwise its a sign of something broken in our design with
our idle state machine and mac80211. Skip these and WARN once
just in case this is triggerable.

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 669fe6c..5d31eca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -765,6 +765,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		if (status & ATH9K_INT_TIM_TIMER) {
+			if (ATH_DBG_WARN_ON_ONCE(sc->ps_idle))
+				goto chip_reset;
 			/* Clear RxAbort bit so that we can
 			 * receive frames */
 			ath9k_setpower(sc, ATH9K_PM_AWAKE);
-- 
1.7.3.2.90.gd4c43

