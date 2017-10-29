Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750915AbdJ2M2c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:04 +0200
Message-Id: <20171029122816.8802-6-luca@coelho.fi> (sfid-20171029_132851_105289_E10823E0)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 05/17] iwlwifi: mvm: improve latency when there is a reorder timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When there is a reorder timeout, we may get to a situation
where we have the timeout latency for all the next 64 frames.
This happens since NSSN is behind for a while, and the driver
won't release the frames, since it is not allowed by NSSN.
As a result the frame is stored in the reorder buffer although
there is no hole, and released 100 ms later.
Add a direct comparison to the reorder buffer head, and release
immediately if possible.

For example:
Frame 0 is missed. We receive frame 1, and store it in the buffer.
After 100 ms, frame 1 is released and reorder buffer head is 2.
We then receive frame 2, with NSSN 0, and store it instead of
releasing it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b84756dc9d6c..9852a4d62337 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -719,6 +719,22 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 		return false;
 	}
 
+	/*
+	 * release immediately if there are no stored frames, and the sn is
+	 * equal to the head.
+	 * This can happen due to reorder timer, where NSSN is behind head_sn.
+	 * When we released everything, and we got the next frame in the
+	 * sequence, according to the NSSN we can't release immediately,
+	 * while technically there is no hole and we can move forward.
+	 */
+	if (!buffer->num_stored && sn == buffer->head_sn) {
+		if (!amsdu || last_subframe)
+			buffer->head_sn = ieee80211_sn_inc(buffer->head_sn);
+		/* No need to update AMSDU last SN - we are moving the head */
+		spin_unlock_bh(&buffer->lock);
+		return false;
+	}
+
 	index = sn % buffer->buf_size;
 
 	/*
-- 
2.14.2
