Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3HIJwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 05:52:53 -0400
Date: Fri, 9 Aug 2013 12:52:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Hostap: copying wrong data prism2_ioctl_giwaplist()
Message-ID: <20130809095231.GD29282@elgon.mountain> (sfid-20130809_115301_164092_C5725459)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want the data stored in "addr" and "qual", but the extra ampersands
mean we are copying stack data instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Untested.  Should probably be applied to -stable
as well.

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index ac07473..e509030 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -523,9 +523,9 @@ static int prism2_ioctl_giwaplist(struct net_device *dev,
 
 	data->length = prism2_ap_get_sta_qual(local, addr, qual, IW_MAX_AP, 1);
 
-	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
+	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
 	data->flags = 1; /* has quality information */
-	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
+	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
 	       sizeof(struct iw_quality) * data->length);
 
 	kfree(addr);
