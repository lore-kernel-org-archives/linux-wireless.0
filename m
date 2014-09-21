Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38967 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaIUTWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:42 -0400
Received: by mail-we0-f173.google.com with SMTP id x48so477130wes.18
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:40 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/17] iwlwifi: mvm: limit aggregation size in low latency to 6
Date: Sun, 21 Sep 2014 22:22:11 +0300
Message-Id: <1411327338-23099-10-git-send-email-egrumbach@gmail.com> (sfid-20140921_212302_306666_3249031A)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This is a tradeoff between enabling better throughput for
bursty traffic and low latency. The number 6 was found to be
a good tradeoff for the Miracast use case which is the
major use case for low latency.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 9bf9de7..15aa298 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -422,7 +422,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->first_agg_queue = 12;
 	}
 	mvm->sf_state = SF_UNINIT;
-	mvm->low_latency_agg_frame_limit = 1;
+	mvm->low_latency_agg_frame_limit = 6;
 
 	mutex_init(&mvm->mutex);
 	mutex_init(&mvm->d0i3_suspend_mutex);
-- 
1.9.1

