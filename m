Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35518 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbJTGq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:29 -0400
Received: by lffy185 with SMTP id y185so720508lff.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:27 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 11/16] rtl8xxxu: Make efuse content length a parameter
Date: Tue, 20 Oct 2015 08:45:41 +0200
Message-Id: <1445323546-12807-12-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084632_706024_19B99F88)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a preparatory step for adding support for RTL8188EU chips
which have different efuse length.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d48db87..a7d172a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1930,6 +1930,7 @@ rtl8xxxu_read_efuse8(struct rtl8xxxu_priv *priv, u16 offset, u8 *data)
 static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
+	int efuse_len = priv->fops->efuse_len;
 	int i, ret = 0;
 	u8 val8, word_mask, header, extheader;
 	u16 val16, efuse_addr, offset;
@@ -1978,7 +1979,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 	memset(priv->efuse_wifi.raw, 0xff, EFUSE_MAP_LEN_8723A);
 
 	efuse_addr = 0;
-	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
+	while (efuse_addr < efuse_len) {
 		u16 map_addr;
 
 		ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &header);
@@ -5780,6 +5781,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.parse_efuse = rtl8723au_parse_efuse,
 	.load_firmware = rtl8723au_load_firmware,
 	.power_on = rtl8723au_power_on,
+	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
 	.writeN_block_size = 1024,
 };
 
@@ -5787,6 +5789,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_efuse = rtl8192cu_parse_efuse,
 	.load_firmware = rtl8192cu_load_firmware,
 	.power_on = rtl8192cu_power_on,
+	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
 	.writeN_block_size = 128,
 };
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2f5f903..ccfbc10 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -677,5 +677,6 @@ struct rtl8xxxu_fileops {
 	int (*parse_efuse) (struct rtl8xxxu_priv *priv);
 	int (*load_firmware) (struct rtl8xxxu_priv *priv);
 	int (*power_on) (struct rtl8xxxu_priv *priv);
+	int efuse_len;
 	int writeN_block_size;
 };
-- 
2.1.0

