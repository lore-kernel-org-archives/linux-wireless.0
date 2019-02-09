Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335CBC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1ADA20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="11YcpWiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfBIHM1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:27 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14131 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfBIHM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:26 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610411"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 09 Feb 2019 00:12:25 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QO9hQzNTra/i/I9hbTUTzkhayNv8HaTwfXR2boHk+U0=;
 b=11YcpWiNy0sjDgN2m4E3sU3bdk0dG+ajuI64HcJEX+2wmgL041dPmv9mA7glvlBbNVxfeYZpOQZklEvXAnKdal5MKSVKqE5fokdHCKA+Ezqj5G8xrRXCuHdE8uAxTzQigGYdXtKgJ2a+pz07olOStUPWS6YW+eLyY+o8+Kj9lkI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:24 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:24 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/16] wilc1000: add wilc_wlan_cfg.c
Thread-Topic: [PATCH 05/16] wilc1000: add wilc_wlan_cfg.c
Thread-Index: AQHUwEbOPNkMFo32S0K2ZhMPfgRNzA==
Date:   Sat, 9 Feb 2019 07:12:23 +0000
Message-ID: <1549696298-9795-6-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:2tZdE6xMn1YFUDbEPNylK5npGnv+aaZ2WfZ5qaNDAS6mCe98TxsVWNCcQByV91ljRjYSE1HboXBOTj1D7YSxtu7dmT2IThV3PAZ+RUpBnMHQt75uUXDP1jLSlg98TODLoEpArfRQGMv4+lfveBGEXTrLDsSXYS6sJklqW5eW2cgTzLGPWg0fTKrO18UEyYakEILs8HVqr0/uMABoRcwpU5gcOXGcA/kdVaJ+9rCvZ0waEPqhmQHOOdu69Rm36geIiikntJT+RJZi9IIjhYnQDSAHSaXNCK/KacASOkmwLEkQNIEKsguH6cs2gIVUV/GtlmLhppA8MfSOnCKgLVMlMdQcVWZ/ZFOqvDpD/T661tsaFNqKtq3zXnqNXo5YQ1MVp9GwCrkrB09v33+pkvDPYw07En7xh8jm9RwdRHymIx6yJs/40hN5ytLjEgeybxs/uuR4nGEl+jGt7MTk2wA8uQ==;5:VOhHZOiRAsdJ44Numvc6H2UYtt95Z8xu4w6BebJAGx6q7dytSaxTQ5JWkAFCJQMUHTUwlE7S38T7zYHp7XL9gyblBQEkJzY8VBmMSunQHWns249r0xiOr2F5WUxpe59vXY/tbPqplpKcGBqVcmI51+f1YomXSE9OmIjVUyn/+BQO//FECxFnwKglfl4zx7l76t9O0OP6lEgPbEGtbYUGZA==;7:R99NnSomuT/WUeqcppqNy/qXI53B3HP8M8xlDsaX14aYwFKpzwM1bIsaxNIH25fmtYJg1pfuyWOWMkMrfgmTTd9juTyrLpalkvHLVSv49JId0rOfahOaw0lfckAQ9pIoUF6Ukm/3WQqGnG8eVw2gMw==
x-ms-office365-filtering-correlation-id: 66eb0512-2b89-4d5f-a0d1-08d68e5df04d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128ED0A01F8BD53BC55070CE36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(189003)(199004)(78486014)(71200400001)(25786009)(256004)(2906002)(14454004)(3846002)(71190400001)(86362001)(6116002)(316002)(486006)(72206003)(54906003)(53936002)(52116002)(76176011)(305945005)(2501003)(2616005)(26005)(68736007)(6486002)(7736002)(66066001)(2351001)(11346002)(4326008)(8936002)(476003)(50226002)(81156014)(8676002)(81166006)(6512007)(97736004)(107886003)(478600001)(186003)(446003)(106356001)(6916009)(105586002)(6436002)(5640700003)(102836004)(36756003)(99286004)(386003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vRAb9KT/jgtmSDDSJt78M6rcU0iyjPMsP238gpj7hsA0/e2y2UgltsSbEPhEKHVRfoFl20ppEyg0sxgf6uYGuWfPEa0r+w6JHTg9jPQxH9J2cIpKIAops81AhJVkAzaKZyHtseyUIxElpsrz+iA6rXgG9Xgh7ojjD/FzlwhZIxVu1tJxUM1QpRUkn+llnon4ui5ccAGaMSoeAL6AjqmA983TeFnAc9GGgMIEiXQmK9fABX+5quintyTDzxBceSwccIduLo8NmuORgUt04tPqEz52t008w/3oEvPxywwp6NqkooU9zu58zw3iabMwuH4s9ApAHJeZT8AqhsOMV9wmtasVkbJtCV6G4B7DmAO0Mw/axGarLqoH/gtU0hQW+iPWXeGJbiOTRas2F+KAjr74CMCwOzVwYoeSA6Hd+SFR6/Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66eb0512-2b89-4d5f-a0d1-08d68e5df04d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:20.2774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved '/driver/staging/wilc1000/wilc_wlan_cfg.c' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../wireless/microchip/wilc1000/wilc_wlan_cfg.c    | 495 +++++++++++++++++=
++++
 1 file changed, 495 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.c

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.c b/driv=
ers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.c
new file mode 100644
index 0000000..9dc5de4
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#include "wilc_wlan_if.h"
+#include "wilc_wlan.h"
+#include "wilc_wlan_cfg.h"
+#include "wilc_wfi_netdevice.h"
+
+enum cfg_cmd_type {
+	CFG_BYTE_CMD	=3D 0,
+	CFG_HWORD_CMD	=3D 1,
+	CFG_WORD_CMD	=3D 2,
+	CFG_STR_CMD	=3D 3,
+	CFG_BIN_CMD	=3D 4
+};
+
+static const struct wilc_cfg_byte g_cfg_byte[] =3D {
+	{WID_STATUS, 0},
+	{WID_RSSI, 0},
+	{WID_LINKSPEED, 0},
+	{WID_NIL, 0}
+};
+
+static const struct wilc_cfg_hword g_cfg_hword[] =3D {
+	{WID_NIL, 0}
+};
+
+static const struct wilc_cfg_word g_cfg_word[] =3D {
+	{WID_FAILED_COUNT, 0},
+	{WID_RECEIVED_FRAGMENT_COUNT, 0},
+	{WID_SUCCESS_FRAME_COUNT, 0},
+	{WID_GET_INACTIVE_TIME, 0},
+	{WID_NIL, 0}
+
+};
+
+static const struct wilc_cfg_str g_cfg_str[] =3D {
+	{WID_FIRMWARE_VERSION, NULL},
+	{WID_MAC_ADDR, NULL},
+	{WID_ASSOC_RES_INFO, NULL},
+	{WID_NIL, NULL}
+};
+
+/********************************************
+ *
+ *      Configuration Functions
+ *
+ ********************************************/
+
+static int wilc_wlan_cfg_set_byte(u8 *frame, u32 offset, u16 id, u8 val8)
+{
+	u8 *buf;
+
+	if ((offset + 4) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+	buf[2] =3D 1;
+	buf[3] =3D 0;
+	buf[4] =3D val8;
+	return 5;
+}
+
+static int wilc_wlan_cfg_set_hword(u8 *frame, u32 offset, u16 id, u16 val1=
6)
+{
+	u8 *buf;
+
+	if ((offset + 5) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+	buf[2] =3D 2;
+	buf[3] =3D 0;
+	buf[4] =3D (u8)val16;
+	buf[5] =3D (u8)(val16 >> 8);
+
+	return 6;
+}
+
+static int wilc_wlan_cfg_set_word(u8 *frame, u32 offset, u16 id, u32 val32=
)
+{
+	u8 *buf;
+
+	if ((offset + 7) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+	buf[2] =3D 4;
+	buf[3] =3D 0;
+	buf[4] =3D (u8)val32;
+	buf[5] =3D (u8)(val32 >> 8);
+	buf[6] =3D (u8)(val32 >> 16);
+	buf[7] =3D (u8)(val32 >> 24);
+
+	return 8;
+}
+
+static int wilc_wlan_cfg_set_str(u8 *frame, u32 offset, u16 id, u8 *str,
+				 u32 size)
+{
+	u8 *buf;
+
+	if ((offset + size + 4) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+	buf[2] =3D (u8)size;
+	buf[3] =3D (u8)(size >> 8);
+
+	if (str && size !=3D 0)
+		memcpy(&buf[4], str, size);
+
+	return (size + 4);
+}
+
+static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32=
 size)
+{
+	u8 *buf;
+	u32 i;
+	u8 checksum =3D 0;
+
+	if ((offset + size + 5) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+	buf[2] =3D (u8)size;
+	buf[3] =3D (u8)(size >> 8);
+
+	if ((b) && size !=3D 0) {
+		memcpy(&buf[4], b, size);
+		for (i =3D 0; i < size; i++)
+			checksum +=3D buf[i + 4];
+	}
+
+	buf[size + 4] =3D checksum;
+
+	return (size + 5);
+}
+
+/********************************************
+ *
+ *      Configuration Response Functions
+ *
+ ********************************************/
+
+#define GET_WID_TYPE(wid)		(((wid) >> 12) & 0x7)
+static void wilc_wlan_parse_response_frame(struct wilc *wl, u8 *info, int =
size)
+{
+	u16 wid;
+	u32 len =3D 0, i =3D 0;
+
+	while (size > 0) {
+		i =3D 0;
+		wid =3D get_unaligned_le16(info);
+
+		switch (GET_WID_TYPE(wid)) {
+		case WID_CHAR:
+			do {
+				if (wl->cfg.b[i].id =3D=3D WID_NIL)
+					break;
+
+				if (wl->cfg.b[i].id =3D=3D wid) {
+					wl->cfg.b[i].val =3D info[4];
+					break;
+				}
+				i++;
+			} while (1);
+			len =3D 3;
+			break;
+
+		case WID_SHORT:
+			do {
+				struct wilc_cfg_hword *hw =3D &wl->cfg.hw[i];
+
+				if (hw->id =3D=3D WID_NIL)
+					break;
+
+				if (hw->id =3D=3D wid) {
+					hw->val =3D get_unaligned_le16(&info[4]);
+					break;
+				}
+				i++;
+			} while (1);
+			len =3D 4;
+			break;
+
+		case WID_INT:
+			do {
+				struct wilc_cfg_word *w =3D &wl->cfg.w[i];
+
+				if (w->id =3D=3D WID_NIL)
+					break;
+
+				if (w->id =3D=3D wid) {
+					w->val =3D get_unaligned_le32(&info[4]);
+					break;
+				}
+				i++;
+			} while (1);
+			len =3D 6;
+			break;
+
+		case WID_STR:
+			do {
+				if (wl->cfg.s[i].id =3D=3D WID_NIL)
+					break;
+
+				if (wl->cfg.s[i].id =3D=3D wid) {
+					memcpy(wl->cfg.s[i].str, &info[2],
+					       (info[2] + 2));
+					break;
+				}
+				i++;
+			} while (1);
+			len =3D 2 + info[2];
+			break;
+
+		default:
+			break;
+		}
+		size -=3D (2 + len);
+		info +=3D (2 + len);
+	}
+}
+
+static void wilc_wlan_parse_info_frame(struct wilc *wl, u8 *info)
+{
+	u32 wid, len;
+
+	wid =3D get_unaligned_le16(info);
+
+	len =3D info[2];
+
+	if (len =3D=3D 1 && wid =3D=3D WID_STATUS) {
+		int i =3D 0;
+
+		do {
+			if (wl->cfg.b[i].id =3D=3D WID_NIL)
+				break;
+
+			if (wl->cfg.b[i].id =3D=3D wid) {
+				wl->cfg.b[i].val =3D info[3];
+				break;
+			}
+			i++;
+		} while (1);
+	}
+}
+
+/********************************************
+ *
+ *      Configuration Exported Functions
+ *
+ ********************************************/
+
+int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size=
)
+{
+	u8 type =3D (id >> 12) & 0xf;
+	int ret =3D 0;
+
+	switch (type) {
+	case CFG_BYTE_CMD:
+		if (size >=3D 1)
+			ret =3D wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
+		break;
+
+	case CFG_HWORD_CMD:
+		if (size >=3D 2)
+			ret =3D wilc_wlan_cfg_set_hword(frame, offset, id,
+						      *((u16 *)buf));
+		break;
+
+	case CFG_WORD_CMD:
+		if (size >=3D 4)
+			ret =3D wilc_wlan_cfg_set_word(frame, offset, id,
+						     *((u32 *)buf));
+		break;
+
+	case CFG_STR_CMD:
+		ret =3D wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
+		break;
+
+	case CFG_BIN_CMD:
+		ret =3D wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
+		break;
+	}
+
+	return ret;
+}
+
+int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
+{
+	u8 *buf;
+
+	if ((offset + 2) >=3D WILC_MAX_CFG_FRAME_SIZE)
+		return 0;
+
+	buf =3D &frame[offset];
+
+	buf[0] =3D (u8)id;
+	buf[1] =3D (u8)(id >> 8);
+
+	return 2;
+}
+
+int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wid, u8 *buffer,
+				u32 buffer_size)
+{
+	u32 type =3D (wid >> 12) & 0xf;
+	int i, ret =3D 0;
+
+	i =3D 0;
+	if (type =3D=3D CFG_BYTE_CMD) {
+		do {
+			if (wl->cfg.b[i].id =3D=3D WID_NIL)
+				break;
+
+			if (wl->cfg.b[i].id =3D=3D wid) {
+				memcpy(buffer, &wl->cfg.b[i].val, 1);
+				ret =3D 1;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type =3D=3D CFG_HWORD_CMD) {
+		do {
+			if (wl->cfg.hw[i].id =3D=3D WID_NIL)
+				break;
+
+			if (wl->cfg.hw[i].id =3D=3D wid) {
+				memcpy(buffer, &wl->cfg.hw[i].val, 2);
+				ret =3D 2;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type =3D=3D CFG_WORD_CMD) {
+		do {
+			if (wl->cfg.w[i].id =3D=3D WID_NIL)
+				break;
+
+			if (wl->cfg.w[i].id =3D=3D wid) {
+				memcpy(buffer, &wl->cfg.w[i].val, 4);
+				ret =3D 4;
+				break;
+			}
+			i++;
+		} while (1);
+	} else if (type =3D=3D CFG_STR_CMD) {
+		do {
+			u32 id =3D wl->cfg.s[i].id;
+
+			if (id =3D=3D WID_NIL)
+				break;
+
+			if (id =3D=3D wid) {
+				u16 size =3D get_unaligned_le16(wl->cfg.s[i].str);
+
+				if (buffer_size >=3D size) {
+					memcpy(buffer, &wl->cfg.s[i].str[2],
+					       size);
+					ret =3D size;
+				}
+				break;
+			}
+			i++;
+		} while (1);
+	}
+	return ret;
+}
+
+void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			       struct wilc_cfg_rsp *rsp)
+{
+	u8 msg_type;
+	u8 msg_id;
+
+	msg_type =3D frame[0];
+	msg_id =3D frame[1];      /* seq no */
+	frame +=3D 4;
+	size -=3D 4;
+	rsp->type =3D 0;
+
+	/*
+	 * The valid types of response messages are
+	 * 'R' (Response),
+	 * 'I' (Information), and
+	 * 'N' (Network Information)
+	 */
+
+	switch (msg_type) {
+	case 'R':
+		wilc_wlan_parse_response_frame(wilc, frame, size);
+		rsp->type =3D WILC_CFG_RSP;
+		rsp->seq_no =3D msg_id;
+		break;
+
+	case 'I':
+		wilc_wlan_parse_info_frame(wilc, frame);
+		rsp->type =3D WILC_CFG_RSP_STATUS;
+		rsp->seq_no =3D msg_id;
+		/*call host interface info parse as well*/
+		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
+		break;
+
+	case 'N':
+		wilc_network_info_received(wilc, frame - 4, size + 4);
+		break;
+
+	case 'S':
+		wilc_scan_complete_received(wilc, frame - 4, size + 4);
+		break;
+
+	default:
+		rsp->seq_no =3D msg_id;
+		break;
+	}
+}
+
+int wilc_wlan_cfg_init(struct wilc *wl)
+{
+	struct wilc_cfg_str_vals *str_vals;
+	int i =3D 0;
+
+	wl->cfg.b =3D kmemdup(g_cfg_byte, sizeof(g_cfg_byte), GFP_KERNEL);
+	if (!wl->cfg.b)
+		return -ENOMEM;
+
+	wl->cfg.hw =3D kmemdup(g_cfg_hword, sizeof(g_cfg_hword), GFP_KERNEL);
+	if (!wl->cfg.hw)
+		goto out_b;
+
+	wl->cfg.w =3D kmemdup(g_cfg_word, sizeof(g_cfg_word), GFP_KERNEL);
+	if (!wl->cfg.w)
+		goto out_hw;
+
+	wl->cfg.s =3D kmemdup(g_cfg_str, sizeof(g_cfg_str), GFP_KERNEL);
+	if (!wl->cfg.s)
+		goto out_w;
+
+	str_vals =3D kzalloc(sizeof(*str_vals), GFP_KERNEL);
+	if (!str_vals)
+		goto out_s;
+
+	wl->cfg.str_vals =3D str_vals;
+	/* store the string cfg parameters */
+	wl->cfg.s[i].id =3D WID_FIRMWARE_VERSION;
+	wl->cfg.s[i].str =3D str_vals->firmware_version;
+	i++;
+	wl->cfg.s[i].id =3D WID_MAC_ADDR;
+	wl->cfg.s[i].str =3D str_vals->mac_address;
+	i++;
+	wl->cfg.s[i].id =3D WID_ASSOC_RES_INFO;
+	wl->cfg.s[i].str =3D str_vals->assoc_rsp;
+	i++;
+	wl->cfg.s[i].id =3D WID_NIL;
+	wl->cfg.s[i].str =3D NULL;
+	return 0;
+
+out_s:
+	kfree(wl->cfg.s);
+out_w:
+	kfree(wl->cfg.w);
+out_hw:
+	kfree(wl->cfg.hw);
+out_b:
+	kfree(wl->cfg.b);
+	return -ENOMEM;
+}
+
+void wilc_wlan_cfg_deinit(struct wilc *wl)
+{
+	kfree(wl->cfg.b);
+	kfree(wl->cfg.hw);
+	kfree(wl->cfg.w);
+	kfree(wl->cfg.s);
+	kfree(wl->cfg.str_vals);
+}
--=20
2.7.4

