Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A87C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DD821480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4DD821480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbeIYMas (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:48 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMas (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:48 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543216"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:49 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:48 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 16/29] staging: wilc1000: refactor code to remove 'mac_status' from 'wilc_mac_cfg' struct
Date:   Tue, 25 Sep 2018 11:53:31 +0530
Message-ID: <1537856624-22157-17-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Refactor the code by removing use of 'mac_status' from 'wilc_mac_cfg'
and only have the string type configuration values in 'wilc_mac_cfg'
struct. Now fetch the value 'WID_STATUS' configuration from 'g_cfg_byte'
array.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c      | 23 ++++++++++++++---------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e2669b9..d9f927e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -159,9 +159,9 @@ static void deinit_irq(struct net_device *dev)
 
 void wilc_mac_indicate(struct wilc *wilc)
 {
-	int status;
+	s8 status;
 
-	wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
+	wilc_wlan_cfg_get_val(WID_STATUS, &status, 1);
 	if (wilc->mac_status == MAC_STATUS_INIT) {
 		wilc->mac_status = status;
 		complete(&wilc->sync_event);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 30151b2..70bae3a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -155,7 +155,7 @@ struct wilc_vif {
 struct wilc {
 	const struct wilc_hif_func *hif_func;
 	int io_type;
-	int mac_status;
+	s8 mac_status;
 	struct gpio_desc *gpio_irq;
 	bool initialized;
 	int dev_irq_num;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 541251b..4434976 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -18,7 +18,6 @@ enum cfg_cmd_type {
 };
 
 struct wilc_mac_cfg {
-	int mac_status;
 	u8 mac_address[7];
 	u8 firmware_version[129];
 	u8 assoc_rsp[256];
@@ -251,15 +250,26 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 
 static void wilc_wlan_parse_info_frame(u8 *info)
 {
-	struct wilc_mac_cfg *pd = &g_mac;
 	u32 wid, len;
 
 	wid = info[0] | (info[1] << 8);
 
 	len = info[2];
 
-	if (len == 1 && wid == WID_STATUS)
-		pd->mac_status = info[3];
+	if (len == 1 && wid == WID_STATUS) {
+		int i = 0;
+
+		do {
+			if (g_cfg_byte[i].id == WID_NIL)
+				break;
+
+			if (g_cfg_byte[i].id == wid) {
+				g_cfg_byte[i].val = info[3];
+				break;
+			}
+			i++;
+		} while (1);
+	}
 }
 
 /********************************************
@@ -323,11 +333,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	u32 type = (wid >> 12) & 0xf;
 	int i, ret = 0;
 
-	if (wid == WID_STATUS) {
-		*((u32 *)buffer) = g_mac.mac_status;
-		return 4;
-	}
-
 	i = 0;
 	if (type == CFG_BYTE_CMD) {
 		do {
-- 
2.7.4

