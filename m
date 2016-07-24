Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:59148 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbcGXUXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2016 16:23:36 -0400
Subject: [PATCH 3/3] staging: wilc1000: Reduce scope for a few variables in
 mac_ioctl()
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
Message-ID: <702302e0-0056-9fff-7bb4-f54d4a0b0afc@users.sourceforge.net> (sfid-20160724_222355_603451_39220E70)
Date: Sun, 24 Jul 2016 22:23:22 +0200
MIME-Version: 1.0
In-Reply-To: <dbc8c4f3-a234-9b6a-b6a4-9c7ef45d5d31@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Jul 2016 21:45:37 +0200

Three local variables were used only within a single case branch.

* Thus move the data type definition for "rssi" and "size" into the
  corresponding code block.

* The variable "length" was not modified after its initialisation.
  Thus pass a constant value in the affected function call instead.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7b1ebcc..173be16 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1094,8 +1094,6 @@ int wilc_mac_close(struct net_device *ndev)
 static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
 	u8 *buff = NULL;
-	s8 rssi;
-	u32 size = 0, length = 0;
 	struct wilc_vif *vif;
 	s32 ret = 0;
 	struct wilc *wilc;
@@ -1110,8 +1108,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 	case SIOCSIWPRIV:
 	{
 		struct iwreq *wrq = (struct iwreq *)req;
-
-		size = wrq->u.data.length;
+		u32 size = wrq->u.data.length;
 
 		if (size && wrq->u.data.pointer) {
 			buff = memdup_user(wrq->u.data.pointer,
@@ -1119,7 +1116,9 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 			if (IS_ERR(buff))
 				return PTR_ERR(buff);
 
-			if (strncasecmp(buff, "RSSI", length) == 0) {
+			if (strncasecmp(buff, "RSSI", 0) == 0) {
+				s8 rssi;
+
 				ret = wilc_get_rssi(vif, &rssi);
 				netdev_info(ndev, "RSSI :%d\n", rssi);
 
-- 
2.9.2

