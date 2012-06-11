Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2FKJyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:54:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/13] iwlwifi: don't modify the timer if we don't Tx
Date: Mon, 11 Jun 2012 11:53:12 +0200
Message-Id: <1339408392-19425-14-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115424_329391_D34A4F2B)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In fragmentation we don't update the write pointer of the
HW immediately. So we shouldn't modify the timer in that
case.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d426e3d..6a30cce 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1353,7 +1353,8 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			     skb->data + hdr_len, secondlen);
 
 	/* start timer if queue currently empty */
-	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
+	if (txq->need_update && q->read_ptr == q->write_ptr &&
+	    trans_pcie->wd_timeout)
 		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
 
 	/* Tell device the write index *just past* this latest filled TFD */
-- 
1.7.10

