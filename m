Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:53319 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbJUVKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 17:10:08 -0400
From: Bruno Randolf <br1@einfach.org>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] rtl8xxxu: Debugging for RXFLTMAP0,1,2
Date: Wed, 21 Oct 2015 22:10:01 +0100
Message-Id: <1445461801-16742-1-git-send-email-br1@einfach.org> (sfid-20151021_231014_067945_45C3BE1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 54 ++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 324ab8a..4d0e121 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5657,7 +5657,58 @@ rtl8xxxu_rcr_read(void *data, u64 *val)
 	return 0;
 }
 
+static int
+rtl8xxxu_RXFLTMAP0_write(void *data, u64 val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	rtl8xxxu_write16(priv, REG_RXFLTMAP0, val);
+	return 0;
+}
+
+static int
+rtl8xxxu_RXFLTMAP0_read(void *data, u64 *val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	*val = rtl8xxxu_read16(priv, REG_RXFLTMAP0);
+	return 0;
+}
+
+static int
+rtl8xxxu_RXFLTMAP1_write(void *data, u64 val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	rtl8xxxu_write16(priv, REG_RXFLTMAP1, val);
+	return 0;
+}
+
+static int
+rtl8xxxu_RXFLTMAP1_read(void *data, u64 *val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	*val = rtl8xxxu_read16(priv, REG_RXFLTMAP1);
+	return 0;
+}
+
+static int
+rtl8xxxu_RXFLTMAP2_write(void *data, u64 val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	rtl8xxxu_write16(priv, REG_RXFLTMAP2, val);
+	return 0;
+}
+
+static int
+rtl8xxxu_RXFLTMAP2_read(void *data, u64 *val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	*val = rtl8xxxu_read16(priv, REG_RXFLTMAP2);
+	return 0;
+}
+
 DEFINE_SIMPLE_ATTRIBUTE(fops_rcr, rtl8xxxu_rcr_read, rtl8xxxu_rcr_write, "0x%08llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_RXFLTMAP0, rtl8xxxu_RXFLTMAP0_read, rtl8xxxu_RXFLTMAP0_write, "0x%08llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_RXFLTMAP1, rtl8xxxu_RXFLTMAP1_read, rtl8xxxu_RXFLTMAP1_write, "0x%08llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_RXFLTMAP2, rtl8xxxu_RXFLTMAP2_read, rtl8xxxu_RXFLTMAP2_write, "0x%08llx\n");
 
 void rtl8xxxu_init_debugfs(struct rtl8xxxu_priv *priv)
 {
@@ -5668,6 +5719,9 @@ void rtl8xxxu_init_debugfs(struct rtl8xxxu_priv *priv)
 		return;
 
 	debugfs_create_file("rcr", S_IRUSR | S_IWUSR, dir, priv, &fops_rcr);
+	debugfs_create_file("RXFLTMAP0", S_IRUSR | S_IWUSR, dir, priv, &fops_RXFLTMAP0);
+	debugfs_create_file("RXFLTMAP1", S_IRUSR | S_IWUSR, dir, priv, &fops_RXFLTMAP1);
+	debugfs_create_file("RXFLTMAP2", S_IRUSR | S_IWUSR, dir, priv, &fops_RXFLTMAP2);
 }
 
 static int rtl8xxxu_probe(struct usb_interface *interface,
-- 
1.9.1

