Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50526 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFHmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 02:42:07 -0500
Date: Wed, 6 Nov 2013 10:41:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] wcn36xx: harmless memory corruption bug in debugfs
Message-ID: <20131106074128.GA13475@elgon.mountain> (sfid-20131106_084212_306959_3BC22A3A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 64 bit systems we write past the end of the arg[] array.

Fixes: 8e84c2582169 ('wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 5b84f7a..ef44a2da 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -126,7 +126,7 @@ static ssize_t write_file_dump(struct file *file,
 		if (begin == NULL)
 			break;
 
-		if (kstrtoul(begin, 0, (unsigned long *)(arg + i)) != 0)
+		if (kstrtou32(begin, 0, &arg[i]) != 0)
 			break;
 	}
 
