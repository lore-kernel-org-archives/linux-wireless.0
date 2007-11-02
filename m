Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58786
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXKBRhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 13:37:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: debugfs SHM read buffer overrun fix
Date: Fri, 2 Nov 2007 18:35:02 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200711021835.02371.mb@bu3sch.de> (sfid-20071102_173728_147528_61DC3108)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix possible buffer overrun.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

We are searching a new b43legacy maintainer.
So if someone is interested in this job, please start with porting
this easy patch to b43legacy. ;)

Index: wireless-2.6/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/debugfs.c	2007-11-02 18:26:55.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/debugfs.c	2007-11-02 18:28:24.000000000 +0100
@@ -128,7 +128,7 @@ static ssize_t shm_read_file(struct b43_
 	__le16 *le16buf = (__le16 *)buf;
 
 	for (i = 0; i < 0x1000; i++) {
-		if (bufsize <= 0)
+		if (bufsize < sizeof(tmp))
 			break;
 		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 2 * i);
 		le16buf[i] = cpu_to_le16(tmp);
