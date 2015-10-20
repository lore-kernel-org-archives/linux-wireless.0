Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35231 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbbJTGqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:33 -0400
Received: by lbbes7 with SMTP id es7so7769484lbb.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:32 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 15/16] rtl8xxxu: rtl8188eu: Add stubbed fileops and chip-specific constants
Date: Tue, 20 Oct 2015 08:45:45 +0200
Message-Id: <1445323546-12807-16-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084654_824969_46AC6F2F)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 32 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  6 ++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cf3aad7..344161b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1597,6 +1597,12 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	}
 }
 
+static void rtl8188eu_set_tx_power(struct rtl8xxxu_priv *priv,
+				   int channel, bool ht40)
+{
+	return; /* Not implemented */
+}
+
 static void rtl8xxxu_set_linktype(struct rtl8xxxu_priv *priv,
 				  enum nl80211_iftype linktype)
 {
@@ -1892,6 +1898,11 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+static int rtl8188eu_parse_efuse(struct rtl8xxxu_priv *priv)
+{
+	return -EOPNOTSUPP; /* Not implemented */
+}
+
 static int
 rtl8xxxu_read_efuse8(struct rtl8xxxu_priv *priv, u16 offset, u8 *data)
 {
@@ -2235,6 +2246,11 @@ static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
+static int rtl8188eu_load_firmware(struct rtl8xxxu_priv *priv)
+{
+	return -EOPNOTSUPP; /* Not implemented */
+}
+
 static void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
@@ -3919,6 +3935,11 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+static int rtl8188eu_power_on(struct rtl8xxxu_priv *priv)
+{
+	return -EOPNOTSUPP; /* Not implemented */
+}
+
 static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5795,6 +5816,15 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.writeN_block_size = 128,
 };
 
+static struct rtl8xxxu_fileops rtl8188eu_fops = {
+	.parse_efuse = rtl8188eu_parse_efuse,
+	.load_firmware = rtl8188eu_load_firmware,
+	.power_on = rtl8188eu_power_on,
+	.set_tx_power = rtl8188eu_set_tx_power,
+	.efuse_len = EFUSE_REAL_CONTENT_LEN_88E,
+	.writeN_block_size = 4,
+};
+
 static struct usb_device_id dev_table[] = {
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
@@ -5895,6 +5925,8 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0x1201, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8179), /* RTL8188EUS */
+	.driver_info = (unsigned long)&rtl8188eu_fops},
 /* Currently untested 8192 series devices */
 {USB_DEVICE_AND_INTERFACE_INFO(0x04bb, 0x0950, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index e55d843..79f47e3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -60,8 +60,12 @@
 #define EFUSE_REAL_CONTENT_LEN_8723A	512
 #define EFUSE_BT_MAP_LEN_8723A		1024
 
+#define EFUSE_MAP_LEN_88E		512
+#define EFUSE_MAX_SECTION_88E		64
+#define EFUSE_REAL_CONTENT_LEN_88E	256
+
 /* One size fits all, that is use the highest value */
-#define EFUSE_MAP_LEN			EFUSE_MAP_LEN_8723A
+#define EFUSE_MAP_LEN			EFUSE_MAP_LEN_88E
 #define EFUSE_MAX_WORD_UNIT		4
 
 struct rtl8xxxu_rx_desc {
-- 
2.1.0

