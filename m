Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:8598 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752670AbdATO3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:29:52 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [RFC 1/2] ath9k: Add tx descriptor flag to corrupt frame fcs
Date: Fri, 20 Jan 2017 15:29:29 +0100
Message-Id: <1484922570-23659-2-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20170120_153007_320787_123701FB)
In-Reply-To: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this flag is present the transmitted frame fcs field
bits are inverted in hardware so the frame is being treated
as corrupted on the recevieng node.
It's used by frame corruption simulator coming on the following
patch.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 3 ++-
 drivers/net/wireless/ath/ath9k/mac.h        | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index da84b70..0b7fbfd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -114,7 +114,8 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 		| SM(i->type, AR_FrameType)
 		| (i->flags & ATH9K_TXDESC_NOACK ? AR_NoAck : 0)
 		| (i->flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
-		| (i->flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
+		| (i->flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0)
+		| (i->flags & ATH9K_TXDESC_CORRUPT_FCS ? AR_CorruptFCS : 0);
 
 	ctl17 |= (i->flags & ATH9K_TXDESC_LDPC ? AR_LDPC : 0);
 	switch (i->aggr) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 3bab014..1c30dfd 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -265,6 +265,8 @@ struct ath_desc {
 #define ATH9K_TXDESC_PAPRD		0x70000
 #define ATH9K_TXDESC_PAPRD_S		16
 
+#define ATH9K_TXDESC_CORRUPT_FCS	0x80000
+
 #define ATH9K_RXDESC_INTREQ		0x0020
 
 struct ar5416_desc {
-- 
2.7.4
