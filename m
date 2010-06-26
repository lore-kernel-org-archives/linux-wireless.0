Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59188 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0FZWv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 18:51:28 -0400
Received: by bwz10 with SMTP id 10so232053bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jun 2010 15:51:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: fix ampdu spacing & max amsdu length reporting
Date: Sun, 27 Jun 2010 00:51:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006270051.24299.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/scan.c b/scan.c
index 09b1047..cd58290 100644
--- a/scan.c
+++ b/scan.c
@@ -497,7 +497,7 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf("\n");
 	print_ht_capability(data[0] | (data[1] << 8));
 	print_ampdu_length(data[2] & 3);
-	print_ampdu_spacing((data[2] >> 2) & 3);
+	print_ampdu_spacing((data[2] >> 2) & 7);
 	print_ht_mcs(data + 3);
 }
 
diff --git a/util.c b/util.c
index 0c6d978..80d5402 100644
--- a/util.c
+++ b/util.c
@@ -457,8 +457,8 @@ void print_ht_capability(__u16 cap)
 
 	PRINT_HT_CAP((cap & BIT(10)), "HT Delayed Block Ack");
 
-	PRINT_HT_CAP((cap & BIT(11)), "Max AMSDU length: 3839 bytes");
-        PRINT_HT_CAP(!(cap & BIT(11)), "Max AMSDU length: 7935 bytes");
+	PRINT_HT_CAP(!(cap & BIT(11)), "Max AMSDU length: 3839 bytes");
+	PRINT_HT_CAP((cap & BIT(11)), "Max AMSDU length: 7935 bytes");
 
 	/*
 	 * For beacons and probe response this would mean the BSS
