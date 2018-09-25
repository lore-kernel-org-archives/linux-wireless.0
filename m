Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94247C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0900B21480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0900B21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbeIYMaR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:17 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:17 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543178"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:18 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:17 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 07/29] staging: wilc1000: use 'void' return for wilc_wlan_txq_add_to_head()
Date:   Tue, 25 Sep 2018 11:53:22 +0530
Message-ID: <1537856624-22157-8-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use 'void' return for wilc_wlan_txq_add_to_head() as its always
return '0' value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 590a51c..8057db9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -71,8 +71,8 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	complete(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
-				     struct txq_entry_t *tqe)
+static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
+				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
@@ -87,8 +87,6 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 	complete(&wilc->txq_event);
-
-	return 0;
 }
 
 #define NOT_TCP_ACK			(-1)
@@ -275,10 +273,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	tqe->priv = NULL;
 	tqe->ack_idx = NOT_TCP_ACK;
 
-	if (wilc_wlan_txq_add_to_head(vif, tqe)) {
-		kfree(tqe);
-		return 0;
-	}
+	wilc_wlan_txq_add_to_head(vif, tqe);
 
 	return 1;
 }
-- 
2.7.4

