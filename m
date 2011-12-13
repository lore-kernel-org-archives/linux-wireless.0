Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58206 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1LMMwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:52:04 -0500
Subject: [PATCH v2 5/6] ath6kl: fix reading of FW IE capabilities
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2011 14:51:58 +0200
Message-ID: <20111213125158.10834.22898.stgit@localhost6.localdomain6> (sfid-20111213_135207_311559_E0DC7EF5)
In-Reply-To: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
References: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
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

