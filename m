Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbXKFWMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:12:55 -0500
Date: Tue, 6 Nov 2007 22:48:36 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH 3/7] b43legacy: fix possible buffer overrun in debugfs
Message-ID: <20071106224836.0d90cb4c@morte> (sfid-20071106_221304_879784_465117DD)
In-Reply-To: <20071106222313.31e9bcd9@morte>
References: <20071106222313.31e9bcd9@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix possible buffer overrun.

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to
b43legacy.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

----

Index: wireless-2.6/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/debugfs.c
@@ -124,7 +124,7 @@ static ssize_t shm_read_file(struct b43l
 	__le16 *le16buf = (__le16 *)buf;
 
 	for (i = 0; i < 0x1000; i++) {
-		if (bufsize <= 0)
+		if (bufsize < sizeof(tmp))
 			break;
 		tmp = b43legacy_shm_read16(dev, B43legacy_SHM_SHARED, 2 * i);
 		le16buf[i] = cpu_to_le16(tmp);



-- 
Ciao
Stefano

-- 
Ciao
Stefano
