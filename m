Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60929 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZETPDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 11:03:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Teo <eugeneteo@kernel.sg>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] airo: fix airo_get_encode{,ext} buffer overflow like I mean it...
Date: Wed, 20 May 2009 11:02:43 -0400
Message-Id: <1242831763-15478-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"airo: airo_get_encode{,ext} potential buffer overflow" was actually a
no-op, due to an unrecognized type overflow in an assignment.  Oddly,
gcc only seems to tell me about it when using -Wextra...grrr...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/airo.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index d734757..9eabf4d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6467,6 +6467,7 @@ static int airo_get_encode(struct net_device *dev,
 {
 	struct airo_info *local = dev->ml_priv;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+	int wep_key_len;
 	u8 buf[16];
 
 	if (!local->wep_capable)
@@ -6500,11 +6501,13 @@ static int airo_get_encode(struct net_device *dev,
 	dwrq->flags |= index + 1;
 
 	/* Copy the key to the user buffer */
-	dwrq->length = get_wep_key(local, index, &buf[0], sizeof(buf));
-	if (dwrq->length != -1)
-		memcpy(extra, buf, dwrq->length);
-	else
+	wep_key_len = get_wep_key(local, index, &buf[0], sizeof(buf));
+	if (wep_key_len < 0) {
 		dwrq->length = 0;
+	} else {
+		dwrq->length = wep_key_len;
+		memcpy(extra, buf, dwrq->length);
+	}
 
 	return 0;
 }
@@ -6617,7 +6620,7 @@ static int airo_get_encodeext(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int idx, max_key_len;
+	int idx, max_key_len, wep_key_len;
 	u8 buf[16];
 
 	if (!local->wep_capable)
@@ -6661,11 +6664,13 @@ static int airo_get_encodeext(struct net_device *dev,
 	memset(extra, 0, 16);
 	
 	/* Copy the key to the user buffer */
-	ext->key_len = get_wep_key(local, idx, &buf[0], sizeof(buf));
-	if (ext->key_len != -1)
-		memcpy(extra, buf, ext->key_len);
-	else
+	wep_key_len = get_wep_key(local, idx, &buf[0], sizeof(buf));
+	if (wep_key_len < 0) {
 		ext->key_len = 0;
+	} else {
+		ext->key_len = wep_key_len;
+		memcpy(extra, buf, ext->key_len);
+	}
 
 	return 0;
 }
-- 
1.6.0.6

