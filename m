Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbaJ1GQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:16:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 7/7] iwlwifi: mvm: update layout of firmware error dump
Date: Tue, 28 Oct 2014 08:11:26 +0200
Message-Id: <1414476686-3407-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141028_071614_907913_B0084173)
In-Reply-To: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 5bfe6f53283de44855ee45a102210abbfac995f9 upstream.

The memory was not zeroed - fix that. Also update the
iwl_fw_error_dump_info structure.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ed10e55..83ab42a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -678,7 +678,7 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (trans_len)
 		file_len += trans_len;
 
-	dump_file = vmalloc(file_len);
+	dump_file = vzalloc(file_len);
 	if (!dump_file)
 		return;
 
-- 
1.9.1

