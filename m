Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A493FC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C3720685
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66C3720685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbeIYMbd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:31:33 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12212 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbeIYMbd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:31:33 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543261"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:25:33 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:25:32 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 29/29] staging: wilc1000: return exact error of register_netdev() from wilc_netdev_init()
Date:   Tue, 25 Sep 2018 11:53:44 +0530
Message-ID: <1537856624-22157-30-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Refactor wilc_netdev_init() to return the error code received from
register_netdev() during the failure condition.

Earlier discussion link
[1]. https://www.spinics.net/lists/linux-wireless/msg177304.html

Suggested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3ac82a1..9ee04ea 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1065,7 +1065,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
-	if (wilc_wlan_cfg_init(wl))
+	ret = wilc_wlan_cfg_init(wl);
+	if (ret)
 		goto free_wl;
 
 	*wilc = wl;
@@ -1077,8 +1078,10 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
 	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
-	if (!wl->hif_workqueue)
+	if (!wl->hif_workqueue) {
+		ret = -ENOMEM;
 		goto free_cfg;
+	}
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1086,8 +1089,10 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		struct wireless_dev *wdev;
 
 		ndev = alloc_etherdev(sizeof(struct wilc_vif));
-		if (!ndev)
+		if (!ndev) {
+			ret = -ENOMEM;
 			goto free_ndev;
+		}
 
 		vif = netdev_priv(ndev);
 		memset(vif, 0, sizeof(struct wilc_vif));
@@ -1110,6 +1115,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		wdev = wilc_create_wiphy(ndev, dev);
 		if (!wdev) {
 			netdev_err(ndev, "Can't register WILC Wiphy\n");
+			ret = -ENOMEM;
 			goto free_ndev;
 		}
 
@@ -1151,7 +1157,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wilc_wlan_cfg_deinit(wl);
 free_wl:
 	kfree(wl);
-	return -ENOMEM;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
-- 
2.7.4

