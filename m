Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64553 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbbF0Ohg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 10:37:36 -0400
Message-ID: <558EB524.1050609@users.sourceforge.net> (sfid-20150627_163755_283960_5B6F0A4F)
Date: Sat, 27 Jun 2015 16:37:24 +0200
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
Subject: [PATCH 2/2] staging: wilc1000: One function call less in mac_ioctl()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
In-Reply-To: <558EB32E.6090003@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jun 2015 16:00:59 +0200

The kfree() function was called in two cases by the mac_ioctl() function
during error handling even if the passed variable did not contain a pointer
for a valid data item.

* This implementation detail could be improved by the introduction
  of another jump label.

* Drop an unnecessary initialisation for the variable "buff" then.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2aa8d9b..f492310 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2351,16 +2351,13 @@ int mac_close(struct net_device *ndev)
 
 int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
-
-	u8 *buff = NULL;
+	u8 *buff;
 	s8 rssi;
 	u32 size = 0, length = 0;
 	perInterface_wlan_t *nic;
 	struct WILC_WFI_priv *priv;
 	s32 s32Error = WILC_SUCCESS;
 
-
-
 	/* struct iwreq *wrq = (struct iwreq *) req;	// tony moved to case SIOCSIWPRIV */
 	#ifdef USE_WIRELESS
 	nic = netdev_priv(ndev);
@@ -2405,7 +2402,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
 					PRINT_ER("%s: failed to copy data to user buffer\n", __func__);
 					s32Error = -EFAULT;
-					goto done;
+					goto free_buffer;
 				}
 			}
 		}
@@ -2420,8 +2417,9 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	}
 	}
 
-done:
+free_buffer:
 	kfree(buff);
+done:
 	return s32Error;
 }
 
-- 
2.4.4

