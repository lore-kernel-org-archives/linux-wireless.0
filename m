Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36823 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbCWTIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 15:08:18 -0400
Received: by obdfc2 with SMTP id fc2so130719493obd.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 12:08:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH] iwlwifi: Fix memory leak in iwl_req_fw_callback()
Date: Mon, 23 Mar 2015 14:07:57 -0500
Message-Id: <1427137677-2879-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150323_200821_976864_7CA03FC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this routine, kzalloc allocates a memory block. This allocation is
freed in the error paths, but not in the normal exit, thus the allocation
is leaked.

The kmemleak facility was used to find the leak.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 66ca000..aefdd9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1319,6 +1319,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+	kfree(pieces);
 	return;
 
  try_again:
-- 
2.1.4

