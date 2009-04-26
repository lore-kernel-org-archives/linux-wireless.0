Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:57020 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbZDZMlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 08:41:03 -0400
Received: by ey-out-2122.google.com with SMTP id 9so446780eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 05:41:00 -0700 (PDT)
Message-ID: <49F4565B.2000201@gmail.com> (sfid-20090426_144116_257682_AD1F33C8)
Date: Sun, 26 Apr 2009 14:40:59 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: chunkeey@web.de
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170: wrong test on outlen in ar9170_usb_exec_cmd() ?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove redundant test: outlen is unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe you want to test outlen < MAX, but what should MAX be?

diff --git a/drivers/net/wireless/ar9170/usb.c b/drivers/net/wireless/ar9170/usb.c
index fddda47..dfd39e9 100644
--- a/drivers/net/wireless/ar9170/usb.c
+++ b/drivers/net/wireless/ar9170/usb.c
@@ -350,7 +350,7 @@ static int ar9170_usb_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
 		goto err_unbuf;
 	}
 
-	if (outlen >= 0 && aru->readlen != outlen) {
+	if (aru->readlen != outlen) {
 		err = -EMSGSIZE;
 		goto err_unbuf;
 	}
