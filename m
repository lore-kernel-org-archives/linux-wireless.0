Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:55873 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcGXUUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2016 16:20:24 -0400
Subject: [PATCH 1/3] staging: wilc1000: Delete an unnecessary check before the
 function call "release_firmware"
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Tony Cho <tony.cho@atmel.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <dbc8c4f3-a234-9b6a-b6a4-9c7ef45d5d31@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <97d9e92f-ae7a-1161-c9a2-cb19fb2f2b55@users.sourceforge.net> (sfid-20160724_222044_776550_786EF504)
Date: Sun, 24 Jul 2016 22:20:08 +0200
MIME-Version: 1.0
In-Reply-To: <dbc8c4f3-a234-9b6a-b6a4-9c7ef45d5d31@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Jul 2016 21:00:20 +0200

The release_firmware() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3a66255..cdef645 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1223,7 +1223,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 			vif[i] = netdev_priv(wilc->vif[i]->ndev);
 	}
 
-	if (wilc && wilc->firmware) {
+	if (wilc) {
 		release_firmware(wilc->firmware);
 		wilc->firmware = NULL;
 	}
-- 
2.9.2

