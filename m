Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34051 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1LHP3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 10:29:43 -0500
Subject: [PATCH 5/6] ath6kl: fix reading of FW IE capabilities
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 08 Dec 2011 17:29:36 +0200
Message-ID: <20111208152936.16924.88146.stgit@x201> (sfid-20111208_162945_878622_D9CE8BED)
In-Reply-To: <20111208152824.16924.31984.stgit@x201>
References: <20111208152824.16924.31984.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some strange reason I used ALIGN() to calculate index to the
buffer. That is totally bogus and wouldn't work when it tried to read
the second bit. Fix it by removing the ALIGN() altogether.

Also check that ie_len is not too short.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c97f83c..5753f00 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -913,12 +913,15 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 				   ar->hw.reserved_ram_size);
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
+			if (ie_len < DIV_ROUND_UP(ATH6KL_FW_CAPABILITY_MAX, 8))
+				break;
+
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found firmware capabilities ie (%zd B)\n",
 				   ie_len);
 
 			for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
-				index = ALIGN(i, 8) / 8;
+				index = i / 8;
 				bit = i % 8;
 
 				if (data[index] & (1 << bit))

