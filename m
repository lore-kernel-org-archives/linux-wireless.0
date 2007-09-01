Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXIAEfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:18 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 27186618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:18 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 11/35] Simplify logic in at76_get_reg_domain()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:17 -0400
Message-ID: <20070901043517.2498.56777.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 206fa90..6ad6248 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -664,6 +664,7 @@ exit:
 
 static struct reg_domain const *at76_get_reg_domain(u16 code)
 {
+	int i;
 	static struct reg_domain const fd_tab[] = {
 		{0x10, "FCC (USA)", 0x7ff},	/* ch 1-11 */
 		{0x20, "IC (Canada)", 0x7ff},	/* ch 1-11 */
@@ -673,19 +674,15 @@ static struct reg_domain const *at76_get_reg_domain(u16 code)
 		{0x40, "MKK (Japan)", 0x2000},	/* ch 14 */
 		{0x41, "MKK1 (Japan)", 0x3fff},	/* ch 1-14 */
 		{0x50, "Israel", 0x3fc},	/* ch 3-9 */
+		{0x00, "<unknown>", 0xffffffff}	/* ch 1-32 */
 	};
-	static int const tab_len = ARRAY_SIZE(fd_tab);
-
-	/* use this if an unknown code comes in */
-	static struct reg_domain const unknown = { 0, "<unknown>", 0xffffffff };
-
-	int i;
 
-	for (i = 0; i < tab_len; i++)
+	/* Last entry is fallback for unknown domain code */
+	for (i = 0; i < ARRAY_SIZE(fd_tab) - 1; i++)
 		if (code == fd_tab[i].code)
 			break;
 
-	return (i >= tab_len) ? &unknown : &fd_tab[i];
+	return &fd_tab[i];
 }
 
 static inline int at76_get_mib(struct usb_device *udev, u16 mib, void *buf,
