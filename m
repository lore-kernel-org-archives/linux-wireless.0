Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18354 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1KUOrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 09:47:42 -0500
Date: Mon, 21 Nov 2011 17:47:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] prism54: potential memory corruption in prism54_get_essid()
Message-ID: <20111121144713.GA19092@elgon.mountain> (sfid-20111121_154746_551249_AB0F8FB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"dwrq->length" is the capped version of "essid->length".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index d97a2ca..bc2ba80 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -778,7 +778,7 @@ prism54_get_essid(struct net_device *ndev, struct iw_request_info *info,
 		dwrq->flags = 0;
 		dwrq->length = 0;
 	}
-	essid->octets[essid->length] = '\0';
+	essid->octets[dwrq->length] = '\0';
 	memcpy(extra, essid->octets, dwrq->length);
 	kfree(essid);
 
