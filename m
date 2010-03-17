Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 12/20] ath9k_hw: add documentation for the TPC register
Date: Wed, 17 Mar 2010 18:28:05 -0400
Message-Id: <1268864893-11428-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 198e41d..ce94e99 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1435,6 +1435,20 @@ enum {
 #define AR_SLEEP2_BEACON_TIMEOUT    0xFFE00000
 #define AR_SLEEP2_BEACON_TIMEOUT_S  21
 
+/*
+ * 0x80e8   Transmit Power Control
+ * (Int Addr: 0x3A, Access: R/W, Clock: system clk)
+ * TPC             21:0    'h3F    bit 5:0:   ACK_PWR
+ *                                'h3F    bit 13:8:  CTS_PWR
+ *                                'h3F    bit 21:16: CHIRP_PWR
+ * Transmit Power Control Description:
+ *
+ * The 6 bit transmit power control sent from the MAC to the baseband
+ * is typically controlled by using the transmit descriptor field.  But
+ * self generated response frames such as ACK, CTS, and chirp which
+ * do not have a transmit descriptor use the values in the transmit power
+ * control register instead.
+ */
 #define AR_TPC                 0x80e8
 #define AR_TPC_ACK             0x0000003f
 #define AR_TPC_ACK_S           0x00
-- 
1.6.3.3

