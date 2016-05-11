Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53939 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbcEKRCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:45 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 01/21] ath10k:  Fix crash related to printing features.
Date: Wed, 11 May 2016 10:02:13 -0700
Message-Id: <1462986153-16318-2-git-send-email-greearb@candelatech.com> (sfid-20160511_190254_571973_FBFE9716)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This looks like a regression from
c4cdf753 (move fw_features to struct ath10k_fw_file)

Signed-off-by:  Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e94cb87..b7318b8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1078,7 +1078,7 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 			}
 
 			ath10k_dbg_dump(ar, ATH10K_DBG_BOOT, "features", "",
-					ar->running_fw->fw_file.fw_features,
+					fw_file->fw_features,
 					sizeof(fw_file->fw_features));
 			break;
 		case ATH10K_FW_IE_FW_IMAGE:
-- 
2.4.3

