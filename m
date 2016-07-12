Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:33671 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcGLLlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 07:41:16 -0400
From: weiyj_lk@163.com
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sara Sharon <sara.sharon@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] iwlwifi: mvm: use setup_timer instead of init_timer and data fields
Date: Tue, 12 Jul 2016 11:40:57 +0000
Message-Id: <1468323657-5909-1-git-send-email-weiyj_lk@163.com> (sfid-20160712_134120_290992_0328BFB8)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use setup_timer function instead of initializing timer with the function
and data fields

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f449ef9..7caad55 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1351,11 +1351,9 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		baid_data->baid = baid;
 		baid_data->timeout = timeout;
 		baid_data->last_rx = jiffies;
-		init_timer(&baid_data->session_timer);
-		baid_data->session_timer.function =
-			iwl_mvm_rx_agg_session_expired;
-		baid_data->session_timer.data =
-			(unsigned long)&mvm->baid_map[baid];
+		setup_timer(&baid_data->session_timer,
+			    iwl_mvm_rx_agg_session_expired,
+			    (unsigned long)&mvm->baid_map[baid]);
 		baid_data->mvm = mvm;
 		baid_data->tid = tid;
 		baid_data->sta_id = mvm_sta->sta_id;


