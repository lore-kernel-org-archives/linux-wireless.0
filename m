Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:37021
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbaK3Tiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 14:38:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, h.feurstein@gmail.com, sujith@msujith.org,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 2/2] ath9k: fix BE/BK queue order
Date: Sun, 30 Nov 2014 20:38:41 +0100
Message-Id: <1417376321-1906-2-git-send-email-nbd@openwrt.org> (sfid-20141130_203921_357070_592F1E17)
In-Reply-To: <1417376321-1906-1-git-send-email-nbd@openwrt.org>
References: <1417376321-1906-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware queues are ordered by priority. Use queue index 0 for BK, which
has lower priority than BE.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 96c6401..1cbd335 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -217,8 +217,8 @@
 #define AH_WOW_BEACON_MISS		BIT(3)
 
 enum ath_hw_txq_subtype {
-	ATH_TXQ_AC_BE = 0,
-	ATH_TXQ_AC_BK = 1,
+	ATH_TXQ_AC_BK = 0,
+	ATH_TXQ_AC_BE = 1,
 	ATH_TXQ_AC_VI = 2,
 	ATH_TXQ_AC_VO = 3,
 };
-- 
2.1.2

