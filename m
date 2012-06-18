Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35818 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2FRHsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:48:37 -0400
Date: Mon, 18 Jun 2012 10:48:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Frank Seidel <frank@f-seidel.de>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] airo: copying wrong data in airo_get_aplist()
Message-ID: <20120618074814.GA26251@elgon.mountain> (sfid-20120618_094842_128557_764ECDFB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"qual" used to be declared on the stack, but then in 998a5a7d6a ("airo:
reduce stack memory footprint") we made it dynamically allocated.
Unfortunately the memcpy() here was missed and it's still copying stack
memory instead of the data that we want.  In other words, "&qual" should
be "qual".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 252c2c2..f9f15bb 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -7233,8 +7233,8 @@ static int airo_get_aplist(struct net_device *dev,
 		}
 	} else {
 		dwrq->flags = 1; /* Should be define'd */
-		memcpy(extra + sizeof(struct sockaddr)*i,
-		       &qual,  sizeof(struct iw_quality)*i);
+		memcpy(extra + sizeof(struct sockaddr) * i, qual,
+		       sizeof(struct iw_quality) * i);
 	}
 	dwrq->length = i;
 
