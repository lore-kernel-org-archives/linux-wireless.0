Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab2KLV7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:01 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:00 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 07/17] Removed unused module parameters and fixed module description
Date: Mon, 12 Nov 2012 23:58:21 +0200
Message-Id: <1352757511-26957-8-git-send-email-maxtram95@gmail.com> (sfid-20121112_225906_807562_A2BD500F)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/r8180_core.c b/r8180_core.c
index e04bb04..203e546 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -61,28 +61,18 @@ static struct pci_device_id rtl8180_pci_id_tbl[] __devinitdata = {
 	}
 };
 
-
 static char ifname[IFNAMSIZ] = "wlan%d";
-static int hwseqnum = 0;
 static int hwwep = 0;
-static int channels = 0x3fff;
 
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, rtl8180_pci_id_tbl);
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
-MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
-
+MODULE_DESCRIPTION("Linux driver for Realtek RTL8187SE WiFi cards");
 
 module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
-module_param(hwseqnum, int, S_IRUGO|S_IWUSR);
 module_param(hwwep, int, S_IRUGO|S_IWUSR);
-module_param(channels, int, S_IRUGO|S_IWUSR);
 
-MODULE_PARM_DESC(devname, " Net interface name, wlan%d=default");
-MODULE_PARM_DESC(hwseqnum, " Try to use hardware 802.11 header sequence numbers. Zero=default");
 MODULE_PARM_DESC(hwwep, " Try to use hardware WEP support. Still broken and not available on all cards");
-MODULE_PARM_DESC(channels, " Channel bitmask for specific locales. NYI");
-
 
 static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *id);
-- 
1.7.10.4

