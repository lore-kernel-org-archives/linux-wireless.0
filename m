Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57721 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbbF0OgU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 10:36:20 -0400
Message-ID: <558EB4DE.3080406@users.sourceforge.net> (sfid-20150627_163644_117105_658C554B)
Date: Sat, 27 Jun 2015 16:36:14 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Chris Park <chris.park@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/2] staging: wilc1000: Delete unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
In-Reply-To: <558EB32E.6090003@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jun 2015 15:56:57 +0200

The functions kfree() and release_firmware() test whether their argument
is NULL and then return immediately.
Thus the test around the calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b352c50..2aa8d9b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2421,11 +2421,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	}
 
 done:
-
-	if (buff != NULL) {
-		kfree(buff);
-	}
-
+	kfree(buff);
 	return s32Error;
 }
 
@@ -2707,8 +2703,7 @@ static void __exit exit_wilc_driver(void)
 		}
 	}
 
-
-	if ((g_linux_wlan != NULL) && g_linux_wlan->wilc_firmware != NULL) {
+	if (g_linux_wlan) {
 		release_firmware(g_linux_wlan->wilc_firmware);
 		g_linux_wlan->wilc_firmware = NULL;
 	}
-- 
2.4.4

