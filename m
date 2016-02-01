Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36359 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:22 -0500
Received: by mail-pf0-f195.google.com with SMTP id n128so7472620pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/11] staging: wilc1000: linux_mon: add braces on all arms of if statement
Date: Mon,  1 Feb 2016 21:26:44 +0900
Message-Id: <1454329607-9486-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132728_088527_3811D4A5)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds braces on all arms of if statement found by
checkpatch.pl
CHECK: braces {} should be used on all arms of this statement

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 53d0caf..255383c 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -278,8 +278,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	if (!(memcmp(srcAdd, bssid, 6))) {
 		mon_mgmt_tx(mon_priv->real_ndev, skb->data, skb->len);
 		dev_kfree_skb(skb);
-	} else
+	} else {
 		ret = wilc_mac_xmit(skb, mon_priv->real_ndev);
+	}
 
 	return ret;
 }
-- 
2.7.0

