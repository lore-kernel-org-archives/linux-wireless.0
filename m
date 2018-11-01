Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C67BC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14B1205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="1zmSXPne"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F14B1205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbeKBBtW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:49:22 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:23527 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbeKBBtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:49:21 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="22518412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:36 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uy9sptyMJYFTT0S9XX9moaq1Qs6LT/UqQ2MpJAOEerI=;
 b=1zmSXPne6pKTvbQD/dIaF2wkgSppzMi4tnG0pg9GH3YvNDjS2heqK7JvBIwm2lQE4xGpmIMsHMbLAgloVI9WuTBmOhDUZefPJVMk7EsciuRRkJALsg/srXoGLf6t2OKG9YcIyj+2VNvk3pTo3NrycRAnzodrjJiKnx2riASI5S8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3286.namprd11.prod.outlook.com (20.177.185.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.21; Thu, 1 Nov 2018 16:45:26 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:26 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 8/8] staging: wilc1000: remove coreconfigurator.h file
Thread-Topic: [PATCH 8/8] staging: wilc1000: remove coreconfigurator.h file
Thread-Index: AQHUcgJKrJ6AhFhOzkqqkkcb4c2a7A==
Date:   Thu, 1 Nov 2018 16:45:26 +0000
Message-ID: <1541090691-31928-9-git-send-email-ajay.kathat@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0138.apcprd06.prod.outlook.com
 (2603:1096:1:1f::16) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.219.12]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3286;6:vlptNQxt2xlxZnJjbrBf8Xyq6QrT+jOOGsm0SRH10ENus02lsAbmxEmhG28k8TjVBHS4+yuDhPJGi2s8a1l9uNt479oTgD1JpeKLq3WUS1Vgg7yFkufKKEng9OO0UnG5cYwBGCs/JSWxxs0cgvC7HrJs3OZITRSDFLq6Bt5gUFDl36ccLni1pfp+ZjkwLu9ThEaiv1Lp60itPXu5r/9OFd+TBAXGjTiqu4/oR1rdmtUOUzow4bKoqG9g1DsUK00yUP/SdruG2vKyg6JSpABu9kvZyDMra8DCrt7/slBeNcKrATEMkvpKqGwxS52baKmiYWfZohgZMLGu8K+xSCtM2PL9dotwafOz2vKZokZaRRvIdpl7UIhcGFKvZRR9UdXBpjipGRywGWoLKuo8W9RywEm90LXuvRHE0TuC4tmtOtJyobDKDk431WHAnMx2ysr7M8V5KxSvXjcju9LR/ZYb8w==;5:3wVmbYZxwsYXvyhgzphSfP9NpRKcmNrurfKyi2CaVpzrT739/snyt4x3ioBzXpxvmy/9Ua7LW78kDSnDK4RjLPKm7nDoIAe1XZXOtycaHGxXzM8YgcQAsFlpnSDHUOePjVfLbfrrx8bbcHn31kmhRLcRRUq/ZE6lm8YxcPOeSL4=;7:0E+cFM528b8bkmgptI1Ek7c66K/ENwnE1QGIrL+J5aK3slaxbjk/S+ZvJcU8Qdu2g88zG5gRp0k/F4sZYQHg3HM9h/QzkBn1NTSgBpaVZe0snz2BcG0WbQ3WkNZ7TT8FBUrcFRltDyweEzlPcCpeJQ==
x-ms-office365-filtering-correlation-id: f2992e42-9846-4cf0-bbf1-08d640196c66
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3286;
x-ms-traffictypediagnostic: BYAPR11MB3286:
x-microsoft-antispam-prvs: <BYAPR11MB328615D4B4ACC6F706B6B718E3CE0@BYAPR11MB3286.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3286;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3286;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(105586002)(102836004)(2900100001)(5660300001)(106356001)(6916009)(4326008)(186003)(26005)(14444005)(78486014)(2906002)(476003)(446003)(305945005)(6506007)(14454004)(386003)(486006)(2616005)(7736002)(11346002)(575784001)(86362001)(3846002)(6116002)(256004)(52116002)(8936002)(76176011)(478600001)(81156014)(8676002)(71200400001)(68736007)(71190400001)(72206003)(54906003)(316002)(25786009)(99286004)(81166006)(107886003)(66066001)(5250100002)(2501003)(5640700003)(53936002)(6512007)(6436002)(36756003)(6486002)(97736004)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3286;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CNjqtccZmfcyNuXTPa8GWhqVkYBtuD4uQZpiaQ8MTfl0Pe2/zuu2kBMV/guebS0fQ/T7wDR6yaEv94/3/jS0HFp3MQ11/choC3PhtxoM4VBl+a5kYDYa/in1+68jIGHKV9UmplHYLLbcHx+/Sjv0BH3w1z/1c3yR6JSkFF28ONfYM8e/EY5Uc6GYvjWTAzSodIenlqfW3tQYA9HUrD/v5gpAmqBTShw1qHkFoj5AiRuLBVCDEM03OczxvfZ8OGkf4a+CedezqRUTmGsw9PKJp4CU9R1cMIcWfQSbv+oHq74kEEw7U7gn+FdRSXdQVtw1xgY+Oq894R9MbboAprtUch8mToAG1TgukUBDRVmzpWA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2992e42-9846-4cf0-bbf1-08d640196c66
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:26.0318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3286
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove the coreconfigurator header file, as its source file is deleted
after code refactor. Moved the required structure and prototypes to
hostinterface header.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 70 -------------------------=
----
 drivers/staging/wilc1000/host_interface.h   | 61 ++++++++++++++++++++++++-
 drivers/staging/wilc1000/wilc_wlan_cfg.c    |  1 -
 3 files changed, 59 insertions(+), 73 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/coreconfigurator.h

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/=
wilc1000/coreconfigurator.h
deleted file mode 100644
index 67f6855..0000000
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ /dev/null
@@ -1,70 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
- * All rights reserved.
- */
-
-#ifndef CORECONFIGURATOR_H
-#define CORECONFIGURATOR_H
-
-#include "wilc_wlan_if.h"
-
-#define NUM_RSSI                5
-
-#define SET_CFG              0
-#define GET_CFG              1
-
-#define MAX_ASSOC_RESP_FRAME_SIZE   256
-
-struct rssi_history_buffer {
-	bool full;
-	u8 index;
-	s8 samples[NUM_RSSI];
-};
-
-struct network_info {
-	s8 rssi;
-	u16 cap_info;
-	u8 ssid[MAX_SSID_LEN];
-	u8 ssid_len;
-	u8 bssid[6];
-	u16 beacon_period;
-	u8 dtim_period;
-	u8 ch;
-	unsigned long time_scan_cached;
-	unsigned long time_scan;
-	bool new_network;
-	u8 found;
-	u32 tsf_lo;
-	u8 *ies;
-	u16 ies_len;
-	void *join_params;
-	struct rssi_history_buffer rssi_history;
-	u64 tsf_hi;
-};
-
-struct connect_info {
-	u8 bssid[6];
-	u8 *req_ies;
-	size_t req_ies_len;
-	u8 *resp_ies;
-	u16 resp_ies_len;
-	u16 status;
-};
-
-struct disconnect_info {
-	u16 reason;
-	u8 *ie;
-	size_t ie_len;
-};
-
-struct assoc_resp {
-	__le16 capab_info;
-	__le16 status_code;
-	__le16 aid;
-} __packed;
-
-void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
-void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
-void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
-#endif
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 33fb731..5f8d30f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -7,7 +7,7 @@
 #ifndef HOST_INT_H
 #define HOST_INT_H
 #include <linux/ieee80211.h>
-#include "coreconfigurator.h"
+#include "wilc_wlan_if.h"
=20
 #define IDLE_MODE	0x00
 #define AP_MODE		0x01
@@ -56,6 +56,61 @@
 #define DRV_HANDLER_SIZE			5
 #define DRV_HANDLER_MASK			0x000000FF
=20
+#define NUM_RSSI                5
+
+#define SET_CFG              0
+#define GET_CFG              1
+
+#define MAX_ASSOC_RESP_FRAME_SIZE   256
+
+struct rssi_history_buffer {
+	bool full;
+	u8 index;
+	s8 samples[NUM_RSSI];
+};
+
+struct network_info {
+	s8 rssi;
+	u16 cap_info;
+	u8 ssid[MAX_SSID_LEN];
+	u8 ssid_len;
+	u8 bssid[6];
+	u16 beacon_period;
+	u8 dtim_period;
+	u8 ch;
+	unsigned long time_scan_cached;
+	unsigned long time_scan;
+	bool new_network;
+	u8 found;
+	u32 tsf_lo;
+	u8 *ies;
+	u16 ies_len;
+	void *join_params;
+	struct rssi_history_buffer rssi_history;
+	u64 tsf_hi;
+};
+
+struct connect_info {
+	u8 bssid[6];
+	u8 *req_ies;
+	size_t req_ies_len;
+	u8 *resp_ies;
+	u16 resp_ies_len;
+	u16 status;
+};
+
+struct disconnect_info {
+	u16 reason;
+	u8 *ie;
+	size_t ie_len;
+};
+
+struct assoc_resp {
+	__le16 capab_info;
+	__le16 status_code;
+	__le16 aid;
+} __packed;
+
 struct rf_info {
 	u8 link_speed;
 	s8 rssi;
@@ -358,5 +413,7 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif=
 *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
-
+void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
+void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
+void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wil=
c1000/wilc_wlan_cfg.c
index faa001c..8390766 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -7,7 +7,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "wilc_wlan_cfg.h"
-#include "coreconfigurator.h"
 #include "wilc_wfi_netdevice.h"
=20
 enum cfg_cmd_type {
--=20
2.7.4

