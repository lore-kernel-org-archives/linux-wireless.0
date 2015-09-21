Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45794 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932659AbbIUVBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:56 +0300
Message-Id: <1442869141-31637-16-git-send-email-luca@coelho.fi> (sfid-20150921_231005_510793_58C34238)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 16/21] iwlwifi: mvm: remove useless debug message from RX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This message is useless - it's in the good case that always
happens so enabling it doesn't really help. Just remove it.
There are other ways to debug this (e.g. tracing) so there's
no need to add a message in the bad case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index c203a1b..623c219 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -202,7 +202,6 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 			return -1;
 
 		stats->flag |= RX_FLAG_DECRYPTED;
-		IWL_DEBUG_WEP(mvm, "hw decrypted CCMP successfully\n");
 		*crypt_len = IEEE80211_CCMP_HDR_LEN;
 		return 0;
 
-- 
2.5.1

