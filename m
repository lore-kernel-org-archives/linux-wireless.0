Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1614CC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBF120870
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCBF120870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbeIYMbW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:31:22 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12212 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbeIYMbW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:31:22 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543252"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:25:23 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:25:22 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 26/29] staging: wilc1000: remove unnecessary option used with ccflags-y in Makefile
Date:   Tue, 25 Sep 2018 11:53:41 +0530
Message-ID: <1537856624-22157-27-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cleanup patch to remove -I(src) and -DWILC_ASIC_A0 option used in
ccflag-y in Makefile.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 5718bc4..37e8560 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,8 +4,6 @@ obj-$(CONFIG_WILC1000) += wilc1000.o
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
-ccflags-y += -I$(src)/ -DWILC_ASIC_A0
-
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			coreconfigurator.o host_interface.o \
 			wilc_wlan_cfg.o wilc_wlan.o
-- 
2.7.4

