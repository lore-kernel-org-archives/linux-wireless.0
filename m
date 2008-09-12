Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:23141 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYILV2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 17:28:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so544591nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 14:28:52 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: Fix compile warnings
Date: Fri, 12 Sep 2008 22:28:18 +0100
Message-Id: <1221254898-10820-1-git-send-email-kilroyd@googlemail.com> (sfid-20080912_232858_791895_93F87245)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use min_t to avoid warnings when the typesafe version is used.

Explicitly cast u64s to unsigned long long when being passed to printk.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
This should fix the following warnings reported by David Miller (though I couldn't reproduce them).

drivers/net/wireless/orinoco.c: In function 'orinoco_ioctl_get_encodeext':
drivers/net/wireless/orinoco.c:4780: warning: comparison of distinct pointer types lacks a cast
drivers/net/wireless/orinoco.c: In function 'orinoco_translate_ext_scan':
drivers/net/wireless/orinoco.c:5691: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'

---
 drivers/net/wireless/orinoco.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index ec0451c..9a2fcc0 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -4777,14 +4777,14 @@ static int orinoco_ioctl_get_encodeext(struct net_device *dev,
 		encoding->flags |= IW_ENCODE_DISABLED;
 		break;
 	case IW_ENCODE_ALG_WEP:
-		ext->key_len = min(le16_to_cpu(priv->keys[idx].len),
-				   (u16) max_key_len);
+		ext->key_len = min_t(u16, le16_to_cpu(priv->keys[idx].len),
+				     max_key_len);
 		memcpy(ext->key, priv->keys[idx].data, ext->key_len);
 		encoding->flags |= IW_ENCODE_ENABLED;
 		break;
 	case IW_ENCODE_ALG_TKIP:
-		ext->key_len = min((u16) sizeof(struct orinoco_tkip_key),
-				   (u16) max_key_len);
+		ext->key_len = min_t(u16, sizeof(struct orinoco_tkip_key),
+				     max_key_len);
 		memcpy(ext->key, &priv->tkip_key[idx], ext->key_len);
 		encoding->flags |= IW_ENCODE_ENABLED;
 		break;
@@ -5686,9 +5686,9 @@ static inline char *orinoco_translate_ext_scan(struct net_device *dev,
 
 	/* Timestamp */
 	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     "tsf=%016llx",
-				     le64_to_cpu(bss->timestamp));
+	iwe.u.data.length =
+		snprintf(custom, MAX_CUSTOM_LEN, "tsf=%016llx",
+			 (unsigned long long) le64_to_cpu(bss->timestamp));
 	if (iwe.u.data.length)
 		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 						  &iwe, custom);
-- 
1.5.6.4

