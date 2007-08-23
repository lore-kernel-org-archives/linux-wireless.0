Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55215
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764694AbXHWW1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:04 -0400
Message-Id: <20070823222154.849018000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:55 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [patch 2/7] b43: Fix oops when firmware not found
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a return statement.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-23 23:41:27.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-23 23:41:34.000000000 +0200
@@ -1601,6 +1601,7 @@ static int do_request_fw(struct b43_wlde
 	if (err) {
 		b43err(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
+		return err;
 	}
 	if ((*fw)->size < sizeof(struct b43_fw_header))
 		goto err_format;

-- 

