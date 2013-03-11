Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CKUia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 16:38:30 -0400
Date: Mon, 11 Mar 2013 15:38:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: [PATCH] ssb: pci: Fix flipping of MAC address
Message-ID: <513e40c2.MDaC+Q82iTl9PpIZ%Larry.Finger@lwfinger.net> (sfid-20130311_213839_980106_4FD10354)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e565275 entitled "ssb: pci: Standardize a function to get mac
address", the SPROM readout of the MAC has had the values flipped so that
00:11:22:33:44:55 became 11:00:33:22:55:44. The fix has been tested on both
little- and big-endian architectures.

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This bug was introduced in 3.9, and should be fixed there.

Thanks,

Larry
---

Index: wireless-testing-new/drivers/ssb/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/ssb/pci.c
+++ wireless-testing-new/drivers/ssb/pci.c
@@ -234,8 +234,8 @@ static void sprom_get_mac(char *mac, con
 {
 	int i;
 	for (i = 0; i < 3; i++) {
-		*mac++ = in[i];
 		*mac++ = in[i] >> 8;
+		*mac++ = in[i];
 	}
 }
 
