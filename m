Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:56994 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaICT4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:36 -0400
Received: by mail-we0-f182.google.com with SMTP id w62so9224272wes.27
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/36] iwlwifi: mvm: force protection for P2P
Date: Wed,  3 Sep 2014 22:55:53 +0300
Message-Id: <1409774184-24665-5-git-send-email-egrumbach@gmail.com> (sfid-20140903_215641_414123_0D65B518)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Performance is less an issue in P2P and reliability
is critical. Enable protection always for P2P.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 51fa571..b7a1efc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2858,6 +2858,9 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	if (iwl_mvm_vif_low_latency(mvmvif))
 		lq_cmd->agg_frame_cnt_limit--;
 
+	if (mvmsta->vif->p2p)
+		lq_cmd->flags |= LQ_FLAG_USE_RTS_MSK;
+
 	lq_cmd->agg_time_limit =
 			cpu_to_le16(iwl_mvm_coex_agg_time_limit(mvm, sta));
 }
-- 
1.9.1

