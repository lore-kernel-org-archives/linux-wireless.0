Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3HPLHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 04/20] iwlwifi: pcie: Refactor iwl_rxq_space
Date: Fri, 16 Aug 2013 13:06:54 +0200
Message-Id: <1376651230-1060-4-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130726_995833_E0BFF375)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Simplify iwl_rxq_space to improve readability and reduce
the ambiguity spares to a single element.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 5fdb4ee..8c9641b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -112,15 +112,16 @@
  */
 static int iwl_rxq_space(const struct iwl_rxq *rxq)
 {
-	int s = rxq->read - rxq->write;
-
-	if (s <= 0)
-		s += RX_QUEUE_SIZE;
-	/* keep some buffer to not confuse full and empty queue */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
+	/* Make sure RX_QUEUE_SIZE is a power of 2 */
+	BUILD_BUG_ON(RX_QUEUE_SIZE & (RX_QUEUE_SIZE - 1));
+
+	/*
+	 * There can be up to (RX_QUEUE_SIZE - 1) free slots, to avoid ambiguity
+	 * between empty and completely full queues.
+	 * The following is equivalent to modulo by RX_QUEUE_SIZE and is well
+	 * defined for negative dividends.
+	 */
+	return (rxq->read - rxq->write - 1) & (RX_QUEUE_SIZE - 1);
 }
 
 /*
-- 
1.8.4.rc2

