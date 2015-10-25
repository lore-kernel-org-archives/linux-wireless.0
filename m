Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42596 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbJYQYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 12:24:52 -0400
Received: from potku.com (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id D833A13EF29
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 16:24:50 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: fix unused rtl8192cu_fops compiler warning
Date: Sun, 25 Oct 2015 18:24:38 +0200
Message-Id: <1445790278-32156-1-git-send-email-kvalo@codeaurora.org> (sfid-20151025_172456_164689_E39432B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild reported:

rtl8xxxu.c:5786:32: warning: ‘rtl8192cu_fops’ defined but not used [-Wunused-variable]

Fix it by adding temporary ifdefs around the static functions.

Fixes: 033695bdf6d7 ("rtl8xxxu: move devices supported by rtlwifi under UNTESTED config")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 86d864af3a32..6aed923a709a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1818,6 +1818,8 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+
 static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	int i;
@@ -1885,6 +1887,8 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+#endif
+
 static int
 rtl8xxxu_read_efuse8(struct rtl8xxxu_priv *priv, u16 offset, u8 *data)
 {
@@ -2217,6 +2221,8 @@ static int rtl8723au_load_firmware(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+
 static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
 {
 	char *fw_name;
@@ -2234,6 +2240,8 @@ static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
+#endif
+
 static void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
@@ -3815,6 +3823,8 @@ exit:
 	return ret;
 }
 
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+
 static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -3918,6 +3928,8 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+#endif
+
 static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5783,6 +5795,8 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.writeN_block_size = 1024,
 };
 
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+
 static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_efuse = rtl8192cu_parse_efuse,
 	.load_firmware = rtl8192cu_load_firmware,
@@ -5790,6 +5804,8 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.writeN_block_size = 128,
 };
 
+#endif
+
 static struct usb_device_id dev_table[] = {
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
-- 
1.7.9.5

