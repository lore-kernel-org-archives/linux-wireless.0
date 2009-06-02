Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:55931 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZFBUd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:33:26 -0400
Received: by fg-out-1718.google.com with SMTP id d23so943354fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 13:33:27 -0700 (PDT)
Message-ID: <4A25A8B8.1000502@gmail.com>
Date: Wed, 03 Jun 2009 00:33:28 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: chunkeey@web.de
CC: linux-wireless@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] ar9170usb: unsigned is always greater than 0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

outlen is unsigned so always greater than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe you want to test `outlen < MAX', but what should MAX be?

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
