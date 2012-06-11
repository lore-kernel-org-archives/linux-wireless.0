Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2FKUgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 16:36:17 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: fix fw capability parsing
Date: Mon, 11 Jun 2012 13:36:12 -0700
Message-ID: <1339446972-3793-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120611_223654_779472_4A4BF646)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug where no capabilites are parsed when the number
of firmware capability bits translate into fewer bytes than the host has
knowledge of. Instead just process number of capability bytes as
reported by the firmware.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index daf24ee..0a13425 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -996,9 +996,6 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 				   ar->hw.reserved_ram_size);
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
-			if (ie_len < DIV_ROUND_UP(ATH6KL_FW_CAPABILITY_MAX, 8))
-				break;
-
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found firmware capabilities ie (%zd B)\n",
 				   ie_len);
@@ -1007,6 +1004,9 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 				index = i / 8;
 				bit = i % 8;
 
+				if (index == ie_len)
+					break;
+
 				if (data[index] & (1 << bit))
 					__set_bit(i, ar->fw_capabilities);
 			}
-- 
1.7.4.1

