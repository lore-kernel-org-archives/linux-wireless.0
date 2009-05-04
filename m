Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53667 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZEDPUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:20:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] airo: airo_get_encode{,ext} potential buffer overflow
Date: Mon,  4 May 2009 11:18:57 -0400
Message-Id: <1241450337-17644-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Feeding the return code of get_wep_key directly to the length parameter
of memcpy is a bad idea since it could be -1...

Reported-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/airo.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index c36d3a3..d734757 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6501,7 +6501,10 @@ static int airo_get_encode(struct net_device *dev,
 
 	/* Copy the key to the user buffer */
 	dwrq->length = get_wep_key(local, index, &buf[0], sizeof(buf));
-	memcpy(extra, buf, dwrq->length);
+	if (dwrq->length != -1)
+		memcpy(extra, buf, dwrq->length);
+	else
+		dwrq->length = 0;
 
 	return 0;
 }
@@ -6659,7 +6662,10 @@ static int airo_get_encodeext(struct net_device *dev,
 	
 	/* Copy the key to the user buffer */
 	ext->key_len = get_wep_key(local, idx, &buf[0], sizeof(buf));
-	memcpy(extra, buf, ext->key_len);
+	if (ext->key_len != -1)
+		memcpy(extra, buf, ext->key_len);
+	else
+		ext->key_len = 0;
 
 	return 0;
 }
-- 
1.6.0.6

