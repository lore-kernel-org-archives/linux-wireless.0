Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:34581 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbbKYNNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:13:06 -0500
From: Geliang Tang <geliangtang@163.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] iwlwifi: fix a problematic usage of WARN_ON_ONCE()
Date: Wed, 25 Nov 2015 21:12:17 +0800
Message-Id: <7701ed112cc71a9a17ba5b3022166011a98d0dca.1448456395.git.geliangtang@163.com> (sfid-20151125_141452_534186_9A64EAFF)
In-Reply-To: <86c73f180d3054c1bf17bdac8c89026209167c9b.1448456395.git.geliangtang@163.com>
References: <86c73f180d3054c1bf17bdac8c89026209167c9b.1448456395.git.geliangtang@163.com>
In-Reply-To: <582529c23f77af64373f59fa92e29186df700d79.1448456395.git.geliangtang@163.com>
References: <86c73f180d3054c1bf17bdac8c89026209167c9b.1448456395.git.geliangtang@163.com> <8bb789c0803579a01e1ee977ed67408c422acd79.1448456395.git.geliangtang@163.com> <582529c23f77af64373f59fa92e29186df700d79.1448456395.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARN_ON_ONCE() takes a condition rather than a format string. This
patch converted WARN_ON_ONCE() to WARN_ONCE() instead.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d1ad103..58d7bee 100644
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


