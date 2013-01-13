Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3AMUDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 15:03:53 -0500
Date: Sun, 13 Jan 2013 23:03:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] prism54: bug in getting auth type
Message-ID: <20130113200342.GC5907@elgon.mountain> (sfid-20130113_210357_325380_6FEF9C10)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a missing break statement so SHARED_KEY authentication doesn't
work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static checker fix.  Untested.

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 4e44b1a..1c22b81 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1503,6 +1503,7 @@ static int prism54_get_auth(struct net_device *ndev,
 			case DOT11_AUTH_BOTH:
 			case DOT11_AUTH_SK:
 				param->value = IW_AUTH_ALG_SHARED_KEY;
+				break;
 			case DOT11_AUTH_NONE:
 			default:
 				param->value = 0;
