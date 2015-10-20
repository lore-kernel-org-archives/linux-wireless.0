Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33150 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbJTGqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:32 -0400
Received: by lffv3 with SMTP id v3so713738lff.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:31 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 14/16] rtl8xxxu: Introduce a device agnostic constant for efuse map length
Date: Tue, 20 Oct 2015 08:45:44 +0200
Message-Id: <1445323546-12807-15-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084654_700603_1C957E64)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparatory step for adding support for RTL8188EU devices.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---

Notes:
    An alternative approach to keeping a buffer that is big enough to hold
    the efuse map of any of the supported chips would be to allocate the
    efuse map on-the-go to pass it between read_efuse() and parse_efuse().
    
    This would also reduce the memory footprint of struct rtl8xxxu_priv.

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ecda799..cf3aad7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1976,7 +1976,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 	}
 
 	/* Default value is 0xff */
-	memset(priv->efuse_wifi.raw, 0xff, EFUSE_MAP_LEN_8723A);
+	memset(priv->efuse_wifi.raw, 0xff, EFUSE_MAP_LEN);
 
 	efuse_addr = 0;
 	while (efuse_addr < efuse_len) {
@@ -2008,7 +2008,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 		/* We have 8 bits to indicate validity */
 		map_addr = offset * 8;
-		if (map_addr >= EFUSE_MAP_LEN_8723A) {
+		if (map_addr >= EFUSE_MAP_LEN) {
 			dev_warn(dev,
 				 "%s: Illegal map_addr (%04x), efuse corrupt!\n",
 				 __func__, map_addr);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 427eb7e..e55d843 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -59,6 +59,9 @@
 #define EFUSE_MAX_SECTION_8723A		32
 #define EFUSE_REAL_CONTENT_LEN_8723A	512
 #define EFUSE_BT_MAP_LEN_8723A		1024
+
+/* One size fits all, that is use the highest value */
+#define EFUSE_MAP_LEN			EFUSE_MAP_LEN_8723A
 #define EFUSE_MAX_WORD_UNIT		4
 
 struct rtl8xxxu_rx_desc {
@@ -649,7 +652,7 @@ struct rtl8xxxu_priv {
 		u8 val8;
 	} usb_buf;
 	union {
-		u8 raw[EFUSE_MAP_LEN_8723A];
+		u8 raw[EFUSE_MAP_LEN];
 		struct rtl8723au_efuse efuse8723;
 		struct rtl8192cu_efuse efuse8192;
 	} efuse_wifi;
-- 
2.1.0

