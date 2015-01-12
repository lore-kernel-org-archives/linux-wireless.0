Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34686 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbbALTmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:42:09 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 8/8] ath10k:  fix CE_DESC_FLAGS_META_DATA_LSB definition.
Date: Mon, 12 Jan 2015 11:41:49 -0800
Message-Id: <1421091709-19891-8-git-send-email-greearb@candelatech.com> (sfid-20150112_204232_141078_305B055A)
In-Reply-To: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
References: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The value was off by one.  The error probably has no negative
affect on any upstream firmware, but should be fixed anyway
in case it comes into use in the future.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index f4919e9..b92610b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -39,7 +39,7 @@ struct ath10k_ce_pipe;
 #define CE_DESC_FLAGS_GATHER         (1 << 0)
 #define CE_DESC_FLAGS_BYTE_SWAP      (1 << 1)
 #define CE_DESC_FLAGS_META_DATA_MASK 0xFFFC
-#define CE_DESC_FLAGS_META_DATA_LSB  3
+#define CE_DESC_FLAGS_META_DATA_LSB  2
 
 struct ce_desc {
 	__le32 addr;
-- 
1.7.11.7

