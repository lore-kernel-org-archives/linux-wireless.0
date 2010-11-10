Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26511 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0KJNET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:04:06 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 10/11] ath9k: Fix bug in delimiter padding computation
Date: Wed, 10 Nov 2010 05:03:15 -0800
Message-ID: <1289394196-3465-10-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a roundng error in delimiter padding computation
which causes severe throughput drop with some of AR9003.

signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc:stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8a2b04e..a6740b4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -177,8 +177,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 
 /* returns delimiter padding required given the packet length */
 #define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+       (((_len) >= ATH_AGGR_MINPLEN) ? 0 :                             \
+        DIV_ROUND_UP(ATH_AGGR_MINPLEN - (_len), ATH_AGGR_DELIM_SZ))
 
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
-- 
1.7.0.4

