Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:44939 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbJTLwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 07:52:04 -0400
From: Bruno Randolf <br1@einfach.org>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 2/2] rtl8xxxu: Add debugfs for RCR register
Date: Tue, 20 Oct 2015 12:51:49 +0100
Message-Id: <1445341909-28053-2-git-send-email-br1@einfach.org> (sfid-20151020_135210_374200_F8DAB0E1)
In-Reply-To: <1445341909-28053-1-git-send-email-br1@einfach.org>
References: <1445341909-28053-1-git-send-email-br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3b5a885..b9b779b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -37,6 +37,7 @@
 #include <linux/firmware.h>
 #include <linux/moduleparam.h>
 #include <net/mac80211.h>
+#include <linux/debugfs.h>
 #include "rtl8xxxu.h"
 #include "rtl8xxxu_regs.h"
 
@@ -5640,6 +5641,35 @@ exit:
 	return ret;
 }
 
+static int
+rtl8xxxu_rcr_write(void *data, u64 val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	rtl8xxxu_write32(priv, REG_RCR, val);
+	return 0;
+}
+
+static int
+rtl8xxxu_rcr_read(void *data, u64 *val)
+{
+	struct rtl8xxxu_priv *priv = data;
+	*val = rtl8xxxu_read32(priv, REG_RCR);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_rcr, rtl8xxxu_rcr_read, rtl8xxxu_rcr_write, "0x%08llx\n");
+
+void rtl8xxxu_init_debugfs(struct rtl8xxxu_priv *priv)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("rtl8xxxu", priv->hw->wiphy->debugfsdir);
+	if (!dir)
+		return;
+
+	debugfs_create_file("rcr", S_IRUSR | S_IWUSR, dir, priv, &fops_rcr);
+}
+
 static int rtl8xxxu_probe(struct usb_interface *interface,
 			  const struct usb_device_id *id)
 {
@@ -5781,6 +5811,8 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		goto exit;
 	}
 
+	rtl8xxxu_init_debugfs(priv);
+
 exit:
 	if (ret < 0)
 		usb_put_dev(udev);
-- 
1.9.1

