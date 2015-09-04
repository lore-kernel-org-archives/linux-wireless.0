Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35754 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbbIDKE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 06:04:27 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] staging: wilc1000: fix freeing of ERR_PTR
Date: Fri,  4 Sep 2015 15:34:15 +0530
Message-Id: <1441361055-30957-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20150904_120442_718715_E2BE3EC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If memdup_user() fails then it will return the error code in ERR_PTR. We
were checking it with IS_ERR but then again trying to free it on the
error path.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c90c459..020ed03 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2116,10 +2116,8 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 		if (size && wrq->u.data.pointer) {
 
 			buff = memdup_user(wrq->u.data.pointer, wrq->u.data.length);
-			if (IS_ERR(buff)) {
-				s32Error = PTR_ERR(buff);
-				goto done;
-			}
+			if (IS_ERR(buff))
+				return PTR_ERR(buff);
 
 			if (strncasecmp(buff, "RSSI", length) == 0) {
 
-- 
1.9.1

