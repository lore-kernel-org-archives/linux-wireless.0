Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27113 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1FWIJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 04:09:26 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 01:08:50 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Use PS wrappers in beacon tasklet
Date: Thu, 23 Jun 2011 13:39:14 +0530
Message-ID: <1308816554-2910-2-git-send-email-rmanoharan@atheros.com> (sfid-20110623_100930_534696_5F83DE46)
In-Reply-To: <1308816554-2910-1-git-send-email-rmanoharan@atheros.com>
References: <1308816554-2910-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Ensure that hw is awake before accessing registers during
beacon generation.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 0b6e3b6..4abadc6 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -364,6 +364,7 @@ void ath_beacon_tasklet(unsigned long data)
 	int slot;
 	u32 bfaddr, bc = 0;
 
+	ath9k_ps_wakeup(sc);
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not don't try to post another, skip this period
@@ -388,6 +389,7 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_reset(sc, true);
 		}
 
+		ath9k_ps_restore(sc);
 		return;
 	}
 
@@ -471,6 +473,7 @@ void ath_beacon_tasklet(unsigned long data)
 			spin_unlock_bh(&sc->sc_pcu_lock);
 		}
 	}
+	ath9k_ps_restore(sc);
 }
 
 static void ath9k_beacon_init(struct ath_softc *sc,
-- 
1.7.5.2

