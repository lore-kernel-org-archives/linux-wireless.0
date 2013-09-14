Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42763 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab3INNqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 09:46:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: fix stale flag handling on buffer clone
Date: Sat, 14 Sep 2013 15:46:33 +0200
Message-Id: <1379166393-31285-1-git-send-email-nbd@openwrt.org> (sfid-20130914_154655_650796_07E44D89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a regression from commit
"ath9k: shrink a few data structures by reordering fields"

When cloning a buffer, the stale flag (part of bf_state now) needs to be
reset after copying the state to prevent tx processing hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 35b515f..a749e0f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -399,6 +399,7 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	tbf->bf_buf_addr = bf->bf_buf_addr;
 	memcpy(tbf->bf_desc, bf->bf_desc, sc->sc_ah->caps.tx_desc_len);
 	tbf->bf_state = bf->bf_state;
+	tbf->bf_state.stale = false;
 
 	return tbf;
 }
-- 
1.8.0.2

