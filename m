Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40442 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaGFJg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:29 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so14459643wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:28 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/40] iwlwifi: mvm: update layout of firmware error dump
Date: Sun,  6 Jul 2014 12:35:41 +0300
Message-Id: <1404639376-3792-5-git-send-email-egrumbach@gmail.com> (sfid-20140706_113634_498037_BB9E9CC6)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The memory was not zeroed - fix that. Also update the
iwl_fw_error_dump_info structure.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9661a52..5e425d3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -686,7 +686,7 @@ static void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (trans_len)
 		file_len += trans_len;
 
-	dump_file = vmalloc(file_len);
+	dump_file = vzalloc(file_len);
 	if (!dump_file)
 		return;
 
-- 
1.8.3.2

