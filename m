Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE21EC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DD1E21480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DD1E21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbeIYMaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:00 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:00 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543154"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:02 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:01 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 02/29] staging: wilc1000: change return type to 'void' for wilc_wlan_set_bssid()
Date:   Tue, 25 Sep 2018 11:53:17 +0530
Message-ID: <1537856624-22157-3-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cleanup patch to use 'void' return type for wilc_wlan_set_bssid(),
as its always returns the same value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 4 +---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49afda6..d1d2c64 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -192,14 +192,12 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 	return NULL;
 }
 
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode)
 {
 	struct wilc_vif *vif = netdev_priv(wilc_netdev);
 
 	memcpy(vif->bssid, bssid, 6);
 	vif->mode = mode;
-
-	return 0;
 }
 
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 1837808..30151b2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,6 +215,6 @@ void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     const struct wilc_hif_func *ops);
 void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
 #endif
-- 
2.7.4

