Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:57981 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaGFJhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:25 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3126071wes.24
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:24 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/40] iwlwifi: mvm: minor fix in comment
Date: Sun,  6 Jul 2014 12:36:16 +0300
Message-Id: <1404639376-3792-40-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_492798_86D57E23)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The comment was not accurate, we are talking about the frames
*for* the station and not from the station.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index f5c0982..e9ff386 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -722,7 +722,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	/* We can't free more than one frame at once on a shared queue */
 	WARN_ON(skb_freed > 1);
 
-	/* If we have still frames from this STA nothing to do here */
+	/* If we have still frames for this STA nothing to do here */
 	if (!atomic_sub_and_test(skb_freed, &mvm->pending_frames[sta_id]))
 		goto out;
 
-- 
1.8.3.2

