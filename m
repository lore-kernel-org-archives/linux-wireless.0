Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752634AbdIHJNp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:56 +0300
Message-Id: <20170908091256.25279-11-luca@coelho.fi> (sfid-20170908_111348_601856_C2D1FFC4)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: mvm: fix reorder buffer for 9000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The condition to check if reorder buffer ran out of
space is faulty, as it takes into account only the
NSSN.
In case the head SN was too far behind the reorder
buffer should move forward, regardless of the NSSN
status.
This caused the driver to release packets out of order
in some scenarios.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 67ffd9774712..77f77bc5d083 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -672,11 +672,12 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	 * If there was a significant jump in the nssn - adjust.
 	 * If the SN is smaller than the NSSN it might need to first go into
 	 * the reorder buffer, in which case we just release up to it and the
-	 * rest of the function will take of storing it and releasing up to the
-	 * nssn
+	 * rest of the function will take care of storing it and releasing up to
+	 * the nssn
 	 */
 	if (!iwl_mvm_is_sn_less(nssn, buffer->head_sn + buffer->buf_size,
-				buffer->buf_size)) {
+				buffer->buf_size) ||
+	    !ieee80211_sn_less(sn, buffer->head_sn + buffer->buf_size)) {
 		u16 min_sn = ieee80211_sn_less(sn, nssn) ? sn : nssn;
 
 		iwl_mvm_release_frames(mvm, sta, napi, buffer, min_sn);
-- 
2.14.1
