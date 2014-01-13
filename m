Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63514 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaAMUWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:17 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3558109ead.34
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:16 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/18] iwlwifi: mvm: use array indexing instead of treating it as a pointer
Date: Mon, 13 Jan 2014 22:21:50 +0200
Message-Id: <1389644517-22807-11-git-send-email-egrumbach@gmail.com> (sfid-20140113_212226_486955_FC7882B1)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's a bit strange to treat an array as a pointer, so use proper
array indexing instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 208771a..797b4d9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -262,9 +262,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 	/* currently FW API supports only one optional cipher scheme */
-	if (mvm->fw->cs->cipher) {
+	if (mvm->fw->cs[0].cipher) {
 		mvm->hw->n_cipher_schemes = 1;
-		mvm->hw->cipher_schemes = mvm->fw->cs;
+		mvm->hw->cipher_schemes = &mvm->fw->cs[0];
 	}
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.9.5

