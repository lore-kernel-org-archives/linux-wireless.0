Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2LJVs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] iwlwifi: read the Rx write pointer only once
Date: Mon, 10 Dec 2012 22:49:09 +0100
Message-Id: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224900_482256_E108B542)
In-Reply-To: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The FH (DMA engine) tells the driver the index of the last
ready (closed) Rx buffer. This data is in closed_rb_num.
If we read this data several times we may get inconsistencies
between the code and the debug prints which can make it
harder to debug issues here.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index c81b978..787b9ca 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -698,7 +698,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans)
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
+	r = le16_to_cpu(ACCESS_ONCE(rxq->rb_stts->closed_rb_num)) & 0x0FFF;
 	i = rxq->read;
 
 	/* Rx interrupt, but nothing sent from uCode */
-- 
1.8.0

