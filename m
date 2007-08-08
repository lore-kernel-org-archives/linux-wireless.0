Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826AbXHHHig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 25/28] iwlwifi: remove unused snprint_line
Date: Wed,  8 Aug 2007 15:33:42 +0800
Message-Id: <11865584841976-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584823402-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
 <1186558479530-git-send-email-yi.zhu@intel.com>
 <11865584823402-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-helpers.h |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index 78b536e..e2a8d95 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -252,39 +252,4 @@ static inline unsigned long elapsed_jiffies(unsigned long start,
 	return end + (MAX_JIFFY_OFFSET - start);
 }
 
-static inline int snprint_line(char *buf, size_t count,
-			       const u8 *data, u32 len, u32 ofs)
-{
-	int out, i, j, l;
-	char c;
-
-	out = snprintf(buf, count, "%08X", ofs);
-
-	for (l = 0, i = 0; i < 2; i++) {
-		out += snprintf(buf + out, count - out, " ");
-		for (j = 0; j < 8 && l < len; j++, l++)
-			out +=
-			    snprintf(buf + out, count - out, "%02X ",
-				     data[(i * 8 + j)]);
-		for (; j < 8; j++)
-			out += snprintf(buf + out, count - out, "   ");
-	}
-	out += snprintf(buf + out, count - out, " ");
-	for (l = 0, i = 0; i < 2; i++) {
-		out += snprintf(buf + out, count - out, " ");
-		for (j = 0; j < 8 && l < len; j++, l++) {
-			c = data[(i * 8 + j)];
-			if (!isascii(c) || !isprint(c))
-				c = '.';
-
-			out += snprintf(buf + out, count - out, "%c", c);
-		}
-
-		for (; j < 8; j++)
-			out += snprintf(buf + out, count - out, " ");
-	}
-
-	return out;
-}
-
 #endif				/* __iwl_helpers_h__ */
-- 
1.5.2
