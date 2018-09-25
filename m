Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A7FC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A9B21480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5A9B21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbeIYMab (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:31 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:31 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543195"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:32 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:31 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 11/29] staging: wilc1000: refactor wilc_wlan_parse_info_frame() function
Date:   Tue, 25 Sep 2018 11:53:26 +0530
Message-ID: <1537856624-22157-12-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Return 'void' from wilc_wlan_parse_info_frame() as same constant value
is returned always. Also removed the 'size' from input parameter as its
not used in the function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 42c64ed..2b5471b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -350,22 +350,17 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 	}
 }
 
-static int wilc_wlan_parse_info_frame(u8 *info, int size)
+static void wilc_wlan_parse_info_frame(u8 *info)
 {
 	struct wilc_mac_cfg *pd = &g_mac;
 	u32 wid, len;
-	int type = WILC_CFG_RSP_STATUS;
 
 	wid = info[0] | (info[1] << 8);
 
 	len = info[2];
 
-	if (len == 1 && wid == WID_STATUS) {
+	if (len == 1 && wid == WID_STATUS)
 		pd->mac_status = info[3];
-		type = WILC_CFG_RSP_STATUS;
-	}
-
-	return type;
 }
 
 /********************************************
@@ -528,7 +523,8 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 		break;
 
 	case 'I':
-		rsp->type = wilc_wlan_parse_info_frame(frame, size);
+		wilc_wlan_parse_info_frame(frame);
+		rsp->type = WILC_CFG_RSP_STATUS;
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
 		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
-- 
2.7.4

