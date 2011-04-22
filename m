Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36541 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1DVHma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 03:42:30 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 00:42:04 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: remove the unlikely check for autosleep
Date: Fri, 22 Apr 2011 13:12:23 +0530
Message-ID: <1303458143-17117-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

newer chipsets support auto sleep feature, so remove the
unlikely check which does not seems to help anything

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f69dcdf..1896464 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1743,7 +1743,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if ((sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					      PS_WAIT_FOR_CAB |
 					      PS_WAIT_FOR_PSPOLL_DATA)) ||
-					unlikely(ath9k_check_auto_sleep(sc)))
+						ath9k_check_auto_sleep(sc))
 			ath_rx_ps(sc, skb);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-- 
1.7.0.4

