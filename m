Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39184 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932199AbdBHL2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:48 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:12 +0200
Message-Id: <20170208112322.29413-8-luca@coelho.fi> (sfid-20170208_122900_803983_429C1029)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 07/17] iwlwifi: mvm: fix reorder timer re-arming
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When NSSN is behind the reorder buffer due to timeout
the reorder timer isn't getting re-armed until NSSN
catches up. Fix it.

Fixes: 0690405fef29 ("iwlwifi: mvm: add reorder timeout per frame")

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c154ab42c80d..d79e9c2a2654 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -418,7 +418,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 
 	/* ignore nssn smaller than head sn - this can happen due to timeout */
 	if (iwl_mvm_is_sn_less(nssn, ssn, reorder_buf->buf_size))
-		return;
+		goto set_timer;
 
 	while (iwl_mvm_is_sn_less(ssn, nssn, reorder_buf->buf_size)) {
 		int index = ssn % reorder_buf->buf_size;
@@ -441,6 +441,7 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 	}
 	reorder_buf->head_sn = nssn;
 
+set_timer:
 	if (reorder_buf->num_stored && !reorder_buf->removed) {
 		u16 index = reorder_buf->head_sn % reorder_buf->buf_size;
 
-- 
2.11.0
