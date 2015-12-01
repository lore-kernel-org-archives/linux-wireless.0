Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbbLAKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:05 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/41] iwlwifi: mvm: rs: fix a warning message
Date: Tue,  1 Dec 2015 11:59:03 +0200
Message-Id: <1448963947-24302-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110045_323872_D556B0D1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

WARN_ON_ONCE() doesn't take a message, it only takes a condition.  I
have changed this to WARN(1, ...).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 37c2db1..54789bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1827,7 +1827,7 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 		rate->type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
 		rate_mask = lq_sta->active_mimo2_rate;
 	} else {
-		WARN_ON_ONCE("Bad column mode");
+		WARN_ONCE(1, "Bad column mode");
 	}
 
 	if (column->mode != RS_LEGACY) {
-- 
2.5.0

