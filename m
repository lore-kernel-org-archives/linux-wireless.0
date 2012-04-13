Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36618 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2DMLNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 07:13:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k: fix beacon descriptor
Date: Fri, 13 Apr 2012 16:44:22 +0530
Message-ID: <1334315662-5017-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_131411_898945_32C5362B)
In-Reply-To: <1334315662-5017-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1334315662-5017-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx interrupt for beacon queue is configured only for edma chips.
As the edma chip does not support per descriptor interrupt, no need to
set INTREQ for every beacon descriptor. And also clear ps filter for
beacon frame.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index c7f012a..8874bb5 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -91,7 +91,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	info.txpower = MAX_RATE_POWER;
 	info.keyix = ATH9K_TXKEYIX_INVALID;
 	info.keytype = ATH9K_KEY_TYPE_CLEAR;
-	info.flags = ATH9K_TXDESC_NOACK | ATH9K_TXDESC_INTREQ;
+	info.flags = ATH9K_TXDESC_NOACK | ATH9K_TXDESC_CLRDMASK;
 
 	info.buf_addr[0] = bf->bf_buf_addr;
 	info.buf_len[0] = roundup(skb->len, 4);
-- 
1.7.10

