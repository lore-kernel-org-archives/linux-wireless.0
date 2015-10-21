Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52488 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbbJUVx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 17:53:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath6k:  fix firmware version assignment.
Date: Wed, 21 Oct 2015 14:53:21 -0700
Message-Id: <1445464401-13826-3-git-send-email-greearb@candelatech.com> (sfid-20151021_235338_803988_ACB0B501)
In-Reply-To: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
References: <1445464401-13826-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Improper use of strlcpy caused garbage to be appended to the
firmware version string.  Fix this by paying attention to the
ie_lenth.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6e473fa..e3f3a6a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -994,7 +994,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 		switch (ie_id) {
 		case ATH6KL_FW_IE_FW_VERSION:
 			strlcpy(ar->wiphy->fw_version, data,
-				sizeof(ar->wiphy->fw_version));
+				min(sizeof(ar->wiphy->fw_version), ie_len+1));
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found fw version %s\n",
-- 
2.4.3

