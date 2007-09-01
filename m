Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36283 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXIAEgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:05 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id CF14C618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:03 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 19/35] Improve output of the regdomain id
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:03 -0400
Message-ID: <20070901043603.2498.28752.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 2fc6084..4a86b48 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5502,8 +5502,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	printk(KERN_INFO "%s: firmware version %d.%d.%d-%d\n", netdev->name,
 	       priv->fw_version.major, priv->fw_version.minor,
 	       priv->fw_version.patch, priv->fw_version.build);
-	printk(KERN_INFO "%s: regulatory domain %s (id %d)\n", netdev->name,
-	       priv->domain->name, priv->regulatory_domain);
+	printk(KERN_INFO "%s: regulatory domain 0x%02x: %s\n", netdev->name,
+	       priv->regulatory_domain, priv->domain->name);
 
 	/* we let this timer run the whole time this driver instance lives */
 	mod_timer(&priv->bss_list_timer, jiffies + BSS_LIST_TIMEOUT);
