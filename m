Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3HPLHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 03/20] iwlwifi: pcie: Refactor iwl_queue_space
Date: Fri, 16 Aug 2013 13:06:53 +0200
Message-Id: <1376651230-1060-3-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130722_818373_B33B60B3)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Reduce the ambiguity spares to a single element if the window size is not
smaller than the queue size. If smaller, no spares are required at all.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 36 ++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 011167c..12c9c00 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -65,18 +65,30 @@
  ***************************************************/
 static int iwl_queue_space(const struct iwl_queue *q)
 {
-	int s = q->read_ptr - q->write_ptr;
-
-	if (q->read_ptr > q->write_ptr)
-		s -= q->n_bd;
-
-	if (s <= 0)
-		s += q->n_window;
-	/* keep some reserve to not confuse empty and full situations */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
+	unsigned int max;
+	unsigned int used;
+
+	/*
+	 * To avoid ambiguity between empty and completely full queues, there
+	 * should always be less than q->n_bd elements in the queue.
+	 * If q->n_window is smaller than q->n_bd, there is no need to reserve
+	 * any queue entries for this purpose.
+	 */
+	if (q->n_window < q->n_bd)
+		max = q->n_window;
+	else
+		max = q->n_bd - 1;
+
+	/*
+	 * q->n_bd is a power of 2, so the following is equivalent to modulo by
+	 * q->n_bd and is well defined for negative dividends.
+	 */
+	used = (q->write_ptr - q->read_ptr) & (q->n_bd - 1);
+
+	if (WARN_ON(used > max))
+		return 0;
+
+	return max - used;
 }
 
 /*
-- 
1.8.4.rc2

