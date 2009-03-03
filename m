Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35466 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbZCCRZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:31 -0500
Message-Id: <20090303172523.733425743@atheros.com> (sfid-20090303_182927_492948_FD57DC19)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:36 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 11/15] ath9k: Check virtual wiphy state on tx()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 should not be requesting us to transmit frames on paused
wiphys since we stop the TX queues. Just in case, add debug code to
make sure we catch if this were to happen.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:00.000000000 +0200
@@ -2075,6 +2075,12 @@ static int ath9k_tx(struct ieee80211_hw 
 	struct ath_tx_control txctl;
 	int hdrlen, padsize;
 
+	if (aphy->state != ATH_WIPHY_ACTIVE) {
+		printk(KERN_DEBUG "ath9k: %s: TX in unexpected wiphy state "
+		       "%d\n", wiphy_name(hw->wiphy), aphy->state);
+		goto exit;
+	}
+
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 
 	/*

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
