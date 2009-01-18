Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:53919 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZARW4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 17:56:18 -0500
Received: by ug-out-1314.google.com with SMTP id 39so161378ugf.37
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 14:56:16 -0800 (PST)
Message-ID: <4973B233.9040902@gmail.com> (sfid-20090118_235624_851438_1667F541)
Date: Sun, 18 Jan 2009 23:50:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mickflemm@gmail.com
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: notice a negative keytype
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To notice a negative keytype

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index 75eb9f4..5bb8a02 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -1041,7 +1041,7 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 	__le32 key_v[5] = {};
 	__le32 key0 = 0, key1 = 0;
 	__le32 *rxmic, *txmic;
-	u32 keytype;
+	int keytype;
 	u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
 	bool is_tkip;
 	const u8 *key_ptr;
