Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D65C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE9221872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="nSFfOIYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfBGL3H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:07 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:42837 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfBGL3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:07 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="24333090"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:06 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgeGgqSdT1khBY1KKXGd0ooR8KDTF49fMuOi/EyqgH0=;
 b=nSFfOIYR+TBosda19Ajju0OjJ33iRNTmyHEJ2/aZKFWKIzYZCX2KWatHaBigY2tIpCHVO0s0OCfCRkALB67EEg+hemNmkA50wJkiBzg9hxAwaWmNHRUJFbSL3/C8qrknLMifsCJnq/szZko4ef9b7QbKn7IcFiU4YkzsYuEb1hM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:29:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:29:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 3/8] staging: wilc1000: move macro and function prototype
 from wilc_wlan_if.h file
Thread-Topic: [PATCH v2 3/8] staging: wilc1000: move macro and function
 prototype from wilc_wlan_if.h file
Thread-Index: AQHUvthVLu7U4pnwZ0OQawe5Ky0Axg==
Date:   Thu, 7 Feb 2019 11:29:04 +0000
Message-ID: <1549538913-17463-4-git-send-email-ajay.kathat@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:yGSkJXTK5BrDBOi2iJyh8qKlTVERvNpHP3W4eQFZW4WssM5KpMEC4NlSme38y+jePkMAWIBYVppYr5w5NDDZF7mpEoYz3RGmowRXK8TozTx68S/aJd39/dKi0Zu1I12diTYt27tun0l+zdcSJfug3W9scdaYAr3RAs3ieOwGT9u9afooixAXlqH1t8Mq3qzvRADAdF5ko728uvTIwdQhvjotfHcPImlfz7IrEWYjaNdGnTGJWK/kq3sUJU42E9SlbYDbHkRCB6yVC6zx3DL6BFczdk5xFIQpeSUFIhO2h0wwK6h+E+CgBoN7uWJUclBxeonlqetWEPZnMbgIPJ4VOC1O3HeI2WLkFpJzrdMSEsiZ2yYTXC4/G7v7eyIDzn+pfNvgFBkSKOuzqxfRaYr3fv2f+dquOPf4UEQMZi1dfvRgxiylbkazKScTh3lMIZdzoWVkspQX7jyOMf4VH8bfwA==;5:MMRNTWvmyD/i2FNhE1TpR7kw6SGvAsnpQZoK6eJqD4+jBMg2NIiMKfnikTT48bP8r1q8qGMVishG7/fLKjYGXkvjzEMvXHEe6alaDpatOQYaKTQtMR1jOU/CHBLynfVLfkjmcCADCvizPykywpFW85Q2r6ZM+nFNR9gQtZdGUbLWPV0TLjg1u9O9LCJB7uHTX9HcDWOeuBTNX3SseluVlA==;7:JmmUEkJjSeq+BakaC+2dK3dLXhRLs64PhbQwC9GirnF00hgPQycXDtj/Z/me3tWeSs+9pjyxdpQ1P91cSLNdEKJ02iTQCvuj3N+PWWmbULF4X5E0Qkvn4wLA6OeeFGsmlnZ/16W3Cj1Js6m0JMUggA==
x-ms-office365-filtering-correlation-id: 4408ac6d-4787-4516-27bb-08d68cef7753
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB2792823E00B01F538B646307E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(14444005)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UiM4WKVdq+t2bP4kCTGSsN+LY7SJrHw8onQ20DMz9rtvZ/FNyLUgB45JPtMkENqFLpcqTPdL0g154z+K4Pqwbc9O07AC+hJ+1BYxf6pgnhB0imD5BumXMysY0gd6EICam3ThnSnZmmVhckwiGo2CjUsPTkbEJZW95eF7tnZ9a1uifG6zvXOr6nI2690x99DlRbvugVEIeAgXctXaIEogr4jaHjJQ/nWq/ntw0G65F0rxfCoRAePusLyzBBQfgFGEKAt8M3xduRub7Z+1B/z/r4dKUQhKq/QgZ+ZOlKTbE8X+ZrgZV5g1I47ltdwuFvGZhRyVpnAEJUHR3MlqYXhasMg31S/AuC7l4wtg4+b+L2KmAEk+FN81TAFxEwXEzWRaPqgHHiziw8rcubE4PjJVC+GrFm+2lIVdgDd9wzNf0mg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4408ac6d-4787-4516-27bb-08d68cef7753
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:29:02.3078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Move data structure and function prototype from 'wilc_wlan_if.h file.
Now, this file contains constant specific to the firmware.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c |  1 +
 drivers/staging/wilc1000/host_interface.h | 11 ++++++++++
 drivers/staging/wilc1000/linux_wlan.c     |  2 ++
 drivers/staging/wilc1000/wilc_wlan.h      |  9 ++++++++
 drivers/staging/wilc1000/wilc_wlan_if.h   | 36 ---------------------------=
----
 5 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 9abe341..50dc2dd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -10,6 +10,7 @@
 #define WILC_HIF_CONNECT_TIMEOUT_MS             9500
=20
 #define WILC_FALSE_FRMWR_CHANNEL		100
+#define WILC_MAX_RATES_SUPPORTED		12
=20
 struct wilc_rcvd_mac_info {
 	u8 status;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index a007625..678e623 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -97,6 +97,17 @@ enum conn_event {
 	CONN_DISCONN_EVENT_FORCE_32BIT		=3D 0xFFFFFFFF
 };
=20
+enum {
+	WILC_HIF_SDIO =3D 0,
+	WILC_HIF_SPI =3D BIT(0)
+};
+
+enum {
+	WILC_MAC_STATUS_INIT =3D -1,
+	WILC_MAC_STATUS_DISCONNECTED =3D 0,
+	WILC_MAC_STATUS_CONNECTED =3D 1
+};
+
 struct wilc_rcvd_net_info {
 	s8 rssi;
 	u8 ch;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index f3e52af..1ebf2b8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -12,6 +12,8 @@
=20
 #include "wilc_wfi_cfgoperations.h"
=20
+#define WILC_MULTICAST_TABLE_SIZE	8
+
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
 	struct net_device *dev =3D user_data;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc100=
0/wilc_wlan.h
index d8fabe8..1a27f62 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -250,6 +250,13 @@ struct wilc_hif_func {
=20
 #define WILC_MAX_CFG_FRAME_SIZE		1468
=20
+struct tx_complete_data {
+	int size;
+	void *buff;
+	u8 *bssid;
+	struct sk_buff *skb;
+};
+
 struct wilc_cfg_cmd_hdr {
 	u8 cmd_type;
 	u8 seq_no;
@@ -301,4 +308,6 @@ void chip_allow_sleep(struct wilc *wilc);
 void chip_wakeup(struct wilc *wilc);
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv);
+int wilc_wlan_init(struct net_device *dev);
+u32 wilc_get_chipid(struct wilc *wilc, bool update);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 9b8cce8..b15de36 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -11,41 +11,9 @@
=20
 /********************************************
  *
- *      Host Interface Defines
- *
- ********************************************/
-
-enum {
-	WILC_HIF_SDIO =3D 0,
-	WILC_HIF_SPI =3D BIT(0)
-};
-
-/********************************************
- *
- *      Wlan Interface Defines
- *
- ********************************************/
-
-enum {
-	WILC_MAC_STATUS_INIT =3D -1,
-	WILC_MAC_STATUS_DISCONNECTED =3D 0,
-	WILC_MAC_STATUS_CONNECTED =3D 1
-};
-
-struct tx_complete_data {
-	int size;
-	void *buff;
-	u8 *bssid;
-	struct sk_buff *skb;
-};
-
-/********************************************
- *
  *      Wlan Configuration ID
  *
  ********************************************/
-#define WILC_MULTICAST_TABLE_SIZE	8
-#define WILC_MAX_RATES_SUPPORTED     12
=20
 enum bss_types {
 	WILC_FW_BSS_TYPE_INFRA =3D 0,
@@ -832,8 +800,4 @@ enum {
 	WID_MAX				=3D 0xFFFF
 };
=20
-struct wilc;
-int wilc_wlan_init(struct net_device *dev);
-u32 wilc_get_chipid(struct wilc *wilc, bool update);
-
 #endif
--=20
2.7.4

