Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15906C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD38C214C5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:24:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD38C214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbeIYMaz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:30:55 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMaz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:30:55 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543223"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:24:56 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:24:55 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 18/29] staging: wilc1000: rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals'
Date:   Tue, 25 Sep 2018 11:53:33 +0530
Message-ID: <1537856624-22157-19-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals' as its more
appropriate for structure to store the values of string configuration.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 14 +++++++-------
 drivers/staging/wilc1000/wilc_wlan_cfg.h |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 8f1e962..930a389 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -438,7 +438,7 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 
 int wilc_wlan_cfg_init(struct wilc *wl)
 {
-	struct wilc_mac_cfg *mac_cfg;
+	struct wilc_cfg_str_vals *str_vals;
 	int i = 0;
 
 	wl->cfg.b = kmemdup(g_cfg_byte, sizeof(g_cfg_byte), GFP_KERNEL);
@@ -457,20 +457,20 @@ int wilc_wlan_cfg_init(struct wilc *wl)
 	if (!wl->cfg.s)
 		goto out_w;
 
-	mac_cfg = kzalloc(sizeof(mac_cfg), GFP_KERNEL);
-	if (!mac_cfg)
+	str_vals = kzalloc(sizeof(str_vals), GFP_KERNEL);
+	if (!str_vals)
 		goto out_s;
 
-	wl->cfg.str_vals = mac_cfg;
+	wl->cfg.str_vals = str_vals;
 	/* store the string cfg parameters */
 	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
-	wl->cfg.s[i].str = mac_cfg->firmware_version;
+	wl->cfg.s[i].str = str_vals->firmware_version;
 	i++;
 	wl->cfg.s[i].id = WID_MAC_ADDR;
-	wl->cfg.s[i].str = mac_cfg->mac_address;
+	wl->cfg.s[i].str = str_vals->mac_address;
 	i++;
 	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
-	wl->cfg.s[i].str = mac_cfg->assoc_rsp;
+	wl->cfg.s[i].str = str_vals->assoc_rsp;
 	i++;
 	wl->cfg.s[i].id = WID_NIL;
 	wl->cfg.s[i].str = NULL;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 176eef1..e5ca6ce 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -27,7 +27,7 @@ struct wilc_cfg_str {
 	u8 *str;
 };
 
-struct wilc_mac_cfg {
+struct wilc_cfg_str_vals {
 	u8 mac_address[7];
 	u8 firmware_version[129];
 	u8 assoc_rsp[256];
@@ -38,7 +38,7 @@ struct wilc_cfg {
 	struct wilc_cfg_hword *hw;
 	struct wilc_cfg_word *w;
 	struct wilc_cfg_str *s;
-	struct wilc_mac_cfg *str_vals;
+	struct wilc_cfg_str_vals *str_vals;
 };
 
 struct wilc;
-- 
2.7.4

