Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab0DODay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 42/97] ath9k: Make bf_desc of ath_buf opaque
Date: Wed, 14 Apr 2010 23:29:56 -0400
Message-Id: <1271302251-9075-43-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 5fd7fe1..e08f7e5 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -77,7 +77,7 @@ struct ath_buf {
 					   an aggregate) */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
 	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
-	struct ath_desc *bf_desc;	/* virtual addr of desc */
+	void *bf_desc;			/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
-- 
1.6.3.3

