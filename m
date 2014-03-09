Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39222 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaCIK2C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 06:28:02 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: clean up and enhance ANI debugfs file
Date: Sun,  9 Mar 2014 11:27:49 +0100
Message-Id: <1394360869-17373-1-git-send-email-nbd@openwrt.org> (sfid-20140309_112808_703082_2DA591AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify scnprintf calls and include the current OFDM/CCK immunity level.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 58 ++++++++++++++++------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f8924ef..86abb34 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -139,43 +139,41 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 	const unsigned int size = 1024;
 	ssize_t retval = 0;
 	char *buf;
+	int i;
+	struct {
+		const char *name;
+		unsigned int val;
+	} ani_info[] = {
+		{ "ANI RESET", ah->stats.ast_ani_reset },
+		{ "OFDM LEVEL", ah->ani.ofdmNoiseImmunityLevel },
+		{ "CCK LEVEL", ah->ani.cckNoiseImmunityLevel },
+		{ "SPUR UP", ah->stats.ast_ani_spurup },
+		{ "SPUR DOWN", ah->stats.ast_ani_spurup },
+		{ "OFDM WS-DET ON", ah->stats.ast_ani_ofdmon },
+		{ "OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff },
+		{ "MRC-CCK ON", ah->stats.ast_ani_ccklow },
+		{ "MRC-CCK OFF", ah->stats.ast_ani_cckhigh },
+		{ "FIR-STEP UP", ah->stats.ast_ani_stepup },
+		{ "FIR-STEP DOWN", ah->stats.ast_ani_stepdown },
+		{ "INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero },
+		{ "OFDM ERRORS", ah->stats.ast_ani_ofdmerrs },
+		{ "CCK ERRORS", ah->stats.ast_ani_cckerrs },
+	};
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
-	if (common->disable_ani) {
-		len += scnprintf(buf + len, size - len, "%s: %s\n",
-				 "ANI", "DISABLED");
+	len += scnprintf(buf + len, size - len, "%15s: %s\n", "ANI",
+			 common->disable_ani ? "DISABLED" : "ENABLED");
+
+	if (common->disable_ani)
 		goto exit;
-	}
 
-	len += scnprintf(buf + len, size - len, "%15s: %s\n",
-			 "ANI", "ENABLED");
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "ANI RESET", ah->stats.ast_ani_reset);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "SPUR UP", ah->stats.ast_ani_spurup);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "SPUR DOWN", ah->stats.ast_ani_spurup);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "OFDM WS-DET ON", ah->stats.ast_ani_ofdmon);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "MRC-CCK ON", ah->stats.ast_ani_ccklow);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "MRC-CCK OFF", ah->stats.ast_ani_cckhigh);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "FIR-STEP UP", ah->stats.ast_ani_stepup);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "FIR-STEP DOWN", ah->stats.ast_ani_stepdown);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "OFDM ERRORS", ah->stats.ast_ani_ofdmerrs);
-	len += scnprintf(buf + len, size - len, "%15s: %u\n",
-			 "CCK ERRORS", ah->stats.ast_ani_cckerrs);
+	for (i = 0; i < ARRAY_SIZE(ani_info); i++)
+		len += scnprintf(buf + len, size - len, "%15s: %u\n",
+				 ani_info[i].name, ani_info[i].val);
+
 exit:
 	if (len > size)
 		len = size;
-- 
1.8.3.4 (Apple Git-47)

