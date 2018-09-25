Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A49C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FC920685
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95FC920685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbeIYMb3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:31:29 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12212 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbeIYMb3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:31:29 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543259"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:25:30 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:25:29 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 28/29] staging: wilc1000: refactor wilc_set_multicast_list() function
Date:   Tue, 25 Sep 2018 11:53:43 +0530
Message-ID: <1537856624-22157-29-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Refactor wilc_set_multicast_list() by making below changes:
o use kmalloc_array
o remove unnecessary res
o add u8 *cur_mc
o use i as index
o use '%pM' extension in netdev_dbg()

The below checkpatch issue is also resolved after code refactor.
'spaces preferred around that '/' (ctx:VxV)'

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 695d5b2..3ac82a1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -799,9 +799,9 @@ static void wilc_set_multicast_list(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
 	struct wilc_vif *vif = netdev_priv(dev);
-	int i = 0;
+	int i;
 	u8 *mc_list;
-	int res;
+	u8 *cur_mc;
 
 	if (dev->flags & IFF_PROMISC)
 		return;
@@ -817,20 +817,20 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		return;
 	}
 
-	mc_list = kmalloc(dev->mc.count * ETH_ALEN, GFP_KERNEL);
+	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_KERNEL);
 	if (!mc_list)
 		return;
 
+	cur_mc = mc_list;
+	i = 0;
 	netdev_for_each_mc_addr(ha, dev) {
-		memcpy(mc_list + i, ha->addr, ETH_ALEN);
-		netdev_dbg(dev, "Entry[%d]: %x:%x:%x:%x:%x:%x\n", i/ETH_ALEN,
-			   mc_list[i], mc_list[i + 1], mc_list[i + 2],
-			   mc_list[i + 3], mc_list[i + 4], mc_list[i + 5]);
-		i += ETH_ALEN;
+		memcpy(cur_mc, ha->addr, ETH_ALEN);
+		netdev_dbg(dev, "Entry[%d]: %pM\n", i, cur_mc);
+		i++;
+		cur_mc += ETH_ALEN;
 	}
 
-	res = wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list);
-	if (res)
+	if (wilc_setup_multicast_filter(vif, true, dev->mc.count, mc_list))
 		kfree(mc_list);
 }
 
-- 
2.7.4

