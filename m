Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A54EC282CC
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C165F20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="fTmIKmTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfBIHMU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:20 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14126 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfBIHMT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:19 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610410"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:18 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ef0gE0J2EhB6HHwVi1/JzEQq+Tk8aNzYuWtKQGTOI0k=;
 b=fTmIKmTCbTUvL5/3itZ4WQdIRxCPSQdT1PlFpEiBG9S+rkKkiMaI7WhxmytLyNv6+w5mordUUkQBuSpQEJohqxdWStNl/KnTqAX1FZwebhfgIi7cPW+zhH90boG2Cl48G6WxYVNKxPUnZ07ldETUI4evdhrLz50MHlYFH5RZhiE=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:16 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:16 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/16] wilc1000: add wilc_wlan_if.h
Thread-Topic: [PATCH 03/16] wilc1000: add wilc_wlan_if.h
Thread-Index: AQHUwEbJgV3JUEHvGEe8+JjKWAxicA==
Date:   Sat, 9 Feb 2019 07:12:16 +0000
Message-ID: <1549696298-9795-4-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:/qwkW35Vt8gYuWPKao0ahF42i1IYI+xEBzDqNqFNdpA2qR4qq2bkXKavqUqpC+DpcifdY0JRojmdtWqlNIwVi5WLy96mVKCZhq3lCX2zb8CwOzrFt+VcwOBDiEgjHhvmrAilNA32HF/rM1uZmRK+qMsccXsMgB2+Qtp/pSbXuLGZFyaaAjnYxMqFdYYJAlGBEB+lhZWFvemY5UnZBuYIJZdyS3PwQnEynMjjwN7kkBO1kc2k37XlXh1b5eTzNrdrFAP5RW3vQVt4oxWe3PE8dPeicq6kq8ryOtvOGRdmOf3sy0T98lQVh1J17YQGUn1KWifmR0lllRYO67b9YzjHVRWt+PBP44AwdHoYJLTHwVtnyUcULZONvAkofzw285roqOukEOb3dhOfjk5xfUyd+1cYTI1HUmxklOnmBC5JEY6zps2m0xIvhXwzs6mx2Boe1+yxanHvmcbfJiI/GJNHZA==;5:P11TWgcGUD05w4TUEZeZllMCcquW0HJxELpmyX/lUZ3c6a4/Kc6MV9r+4xvQ0wPH5OrjZH9rm2xehqsA78vcJ5b3XKEtNT4SUTz0ZMTU0WglrkOxFNeK5/tV++9EurtN/Ye3byiax3Wz4kDfDe+kjAJKDCnUBEy0+m13DNs6BgJ1U62MBWkF/5t9BQ8qepHTACwXEiPFwaRTvLdQ4nnDCA==;7:RO6FLz65F6XAekyFf+4V8gEB/7QTzmHYrSHJTQRNjtn76G1ACluo1pbRJdXCfAbqBlgYIBIzufRCSSCKRSnB/S5/STmJ2Syce1bnZ/oaHNQYBrg2NO+a60LP3YABwM2j2ENIXq+OPPdjjfCfSe/ADg==
x-ms-office365-filtering-correlation-id: 2099728d-3bf8-443b-6e78-08d68e5debcb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB31281FD217862A459EF0AAF1E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(189003)(199004)(78486014)(30864003)(71200400001)(25786009)(14444005)(256004)(2906002)(14454004)(3846002)(71190400001)(86362001)(6116002)(316002)(486006)(72206003)(54906003)(53936002)(52116002)(76176011)(305945005)(2501003)(2616005)(26005)(68736007)(6486002)(7736002)(66066001)(2351001)(11346002)(53946003)(4326008)(8936002)(476003)(50226002)(81156014)(8676002)(81166006)(6512007)(97736004)(107886003)(478600001)(186003)(446003)(106356001)(6916009)(105586002)(6436002)(5640700003)(102836004)(36756003)(99286004)(386003)(6506007)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HeEbquAXRhX+iDQL7k2QSTvoTP9zyCctHBIQcLhB6c23kXebwhdK2b2LlrR49mcA0ge/poXUFYXsXeIOfnIp5ABuYBdluZJ7db3VP2cfsjQOFU3ffyB5M7j4jDK5oUqMXah/F91SWJL1Dqh9XZMeVktfeOjhljo+HQk3mSrL6w6XRYejF51TzNe/GvoxoigowEJ794OZJJCAeL/YIGWBzUA8SxU0z9E+1AwOudV1+7NKHnJrrmgHeixuN3sPDnzPrXEIALLwLfI61cciqdx2x+fiF4gdUe6EeG82G/HbD/t8LqLYqsuMtTYVUp8WA2xDYUt3AYtdlRPiM7w2FpdzeYjTskPw2/4Ji6APnRqeX90j+RhIVJqVb/tlC68q0tXA6xp/SX/Lfzs+N8MBCbPHXfX2eAgyWATu+Uaa++BCPB0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2099728d-3bf8-443b-6e78-08d68e5debcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:13.2186
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

Moved '/driver/staging/wilc1000/wilc_wlan_if.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc1000/wilc_wlan_if.h | 803 +++++++++++++++++=
++++
 1 file changed, 803 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_if.h

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wlan_if.h b/drive=
rs/net/wireless/microchip/wilc1000/wilc_wlan_if.h
new file mode 100644
index 0000000..b15de36
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wlan_if.h
@@ -0,0 +1,803 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#ifndef WILC_WLAN_IF_H
+#define WILC_WLAN_IF_H
+
+#include <linux/netdevice.h>
+
+/********************************************
+ *
+ *      Wlan Configuration ID
+ *
+ ********************************************/
+
+enum bss_types {
+	WILC_FW_BSS_TYPE_INFRA =3D 0,
+	WILC_FW_BSS_TYPE_INDEPENDENT,
+	WILC_FW_BSS_TYPE_AP,
+};
+
+enum {
+	WILC_FW_OPER_MODE_B_ONLY =3D 0,	 /* 1, 2 M, otherwise 5, 11 M */
+	WILC_FW_OPER_MODE_G_ONLY,	 /* 6,12,24 otherwise 9,18,36,48,54 */
+	WILC_FW_OPER_MODE_G_MIXED_11B_1, /* 1,2,5.5,11 otherwise all on */
+	WILC_FW_OPER_MODE_G_MIXED_11B_2, /* 1,2,5,11,6,12,24 otherwise all on */
+};
+
+enum {
+	WILC_FW_PREAMBLE_SHORT =3D 0,	/* Short Preamble */
+	WILC_FW_PREAMBLE_LONG =3D 1,	/* Long Preamble */
+	WILC_FW_PREAMBLE_AUTO =3D 2,	/* Auto Preamble Selection */
+};
+
+enum {
+	WILC_FW_PASSIVE_SCAN =3D 0,
+	WILC_FW_ACTIVE_SCAN =3D 1,
+};
+
+enum {
+	WILC_FW_NO_POWERSAVE =3D 0,
+	WILC_FW_MIN_FAST_PS =3D 1,
+	WILC_FW_MAX_FAST_PS =3D 2,
+	WILC_FW_MIN_PSPOLL_PS =3D 3,
+	WILC_FW_MAX_PSPOLL_PS =3D 4
+};
+
+enum chip_ps_states {
+	WILC_CHIP_WAKEDUP =3D 0,
+	WILC_CHIP_SLEEPING_AUTO =3D 1,
+	WILC_CHIP_SLEEPING_MANUAL =3D 2
+};
+
+enum bus_acquire {
+	WILC_BUS_ACQUIRE_ONLY =3D 0,
+	WILC_BUS_ACQUIRE_AND_WAKEUP =3D 1,
+};
+
+enum bus_release {
+	WILC_BUS_RELEASE_ONLY =3D 0,
+	WILC_BUS_RELEASE_ALLOW_SLEEP =3D 1,
+};
+
+enum {
+	WILC_FW_NO_ENCRYPT =3D 0,
+	WILC_FW_ENCRYPT_ENABLED =3D BIT(0),
+	WILC_FW_WEP =3D BIT(1),
+	WILC_FW_WEP_EXTENDED =3D BIT(2),
+	WILC_FW_WPA =3D BIT(3),
+	WILC_FW_WPA2 =3D BIT(4),
+	WILC_FW_AES =3D BIT(5),
+	WILC_FW_TKIP =3D BIT(6)
+};
+
+enum {
+	WILC_FW_SEC_NO =3D WILC_FW_NO_ENCRYPT,
+	WILC_FW_SEC_WEP =3D WILC_FW_WEP | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WEP_EXTENDED =3D WILC_FW_WEP_EXTENDED | WILC_FW_SEC_WEP,
+	WILC_FW_SEC_WPA =3D WILC_FW_WPA | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WPA_AES =3D WILC_FW_AES | WILC_FW_SEC_WPA,
+	WILC_FW_SEC_WPA_TKIP =3D WILC_FW_TKIP | WILC_FW_SEC_WPA,
+	WILC_FW_SEC_WPA2 =3D WILC_FW_WPA2 | WILC_FW_ENCRYPT_ENABLED,
+	WILC_FW_SEC_WPA2_AES =3D WILC_FW_AES | WILC_FW_SEC_WPA2,
+	WILC_FW_SEC_WPA2_TKIP =3D WILC_FW_TKIP | WILC_FW_SEC_WPA2
+};
+
+enum authtype {
+	WILC_FW_AUTH_OPEN_SYSTEM =3D 1,
+	WILC_FW_AUTH_SHARED_KEY =3D 2,
+	WILC_FW_AUTH_ANY =3D 3,
+	WILC_FW_AUTH_IEEE8021 =3D 5
+};
+
+enum site_survey {
+	WILC_FW_SITE_SURVEY_1CH =3D 0,
+	WILC_FW_SITE_SURVEY_ALL_CH =3D 1,
+	WILC_FW_SITE_SURVEY_OFF =3D 2
+};
+
+enum {
+	WILC_FW_ACK_POLICY_NORMAL =3D 0,
+	WILC_FW_ACK_NO_POLICY,
+};
+
+enum {
+	WILC_FW_REKEY_POLICY_DISABLE =3D 1,
+	WILC_FW_REKEY_POLICY_TIME_BASE,
+	WILC_FW_REKEY_POLICY_PKT_BASE,
+	WILC_FW_REKEY_POLICY_TIME_PKT_BASE
+};
+
+enum {
+	WILC_FW_FILTER_NO =3D 0x00,
+	WILC_FW_FILTER_AP_ONLY =3D 0x01,
+	WILC_FW_FILTER_STA_ONLY =3D 0x02
+};
+
+enum {
+	WILC_FW_11N_PROT_AUTO =3D 0,	/* Auto */
+	WILC_FW_11N_NO_PROT,		/* Do not use any protection */
+	WILC_FW_11N_PROT_ERP,		/* Protect all ERP frame exchanges */
+	WILC_FW_11N_PROT_HT,		/* Protect all HT frame exchanges  */
+	WILC_FW_11N_PROT_GF		/* Protect all GF frame exchanges  */
+};
+
+enum {
+	WILC_FW_ERP_PROT_SELF_CTS,
+	WILC_FW_ERP_PROT_RTS_CTS,
+};
+
+enum {
+	WILC_FW_11N_OP_MODE_HT_MIXED =3D 1,
+	WILC_FW_11N_OP_MODE_HT_ONLY_20MHZ,
+	WILC_FW_11N_OP_MODE_HT_ONLY_20_40MHZ,
+};
+
+enum {
+	WILC_FW_OBBS_NONHT_NO_DETECT =3D 0,
+	WILC_FW_OBBS_NONHT_DETECT_ONLY =3D 1,
+	WILC_FW_OBBS_NONHT_DETECT_PROTECT =3D 2,
+	WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT =3D 3,
+};
+
+enum {
+	WILC_FW_HT_PROT_RTS_CTS_NONHT =3D 0,  /* RTS-CTS at non-HT rate */
+	WILC_FW_HT_PROT_FIRST_FRAME_NONHT,  /* First frame at non-HT rate */
+	WILC_FW_HT_PROT_LSIG_TXOP,	    /* LSIG TXOP Protection */
+	WILC_FW_HT_PROT_FIRST_FRAME_MIXED,  /* First frame at Mixed format */
+};
+
+enum {
+	WILC_FW_SMPS_MODE_STATIC =3D 1,
+	WILC_FW_SMPS_MODE_DYNAMIC =3D 2,
+	WILC_FW_SMPS_MODE_MIMO =3D 3,	/* power save disable */
+};
+
+enum {
+	WILC_FW_TX_RATE_AUTO =3D 0,
+	WILC_FW_TX_RATE_MBPS_1 =3D 1,
+	WILC_FW_TX_RATE_MBPS_2 =3D 2,
+	WILC_FW_TX_RATE_MBPS_5_5 =3D 5,
+	WILC_FW_TX_RATE_MBPS_11 =3D 11,
+	WILC_FW_TX_RATE_MBPS_6 =3D 6,
+	WILC_FW_TX_RATE_MBPS_9 =3D 9,
+	WILC_FW_TX_RATE_MBPS_12 =3D 12,
+	WILC_FW_TX_RATE_MBPS_18 =3D 18,
+	WILC_FW_TX_RATE_MBPS_24 =3D 24,
+	WILC_FW_TX_RATE_MBPS_36 =3D 36,
+	WILC_FW_TX_RATE_MBPS_48 =3D 48,
+	WILC_FW_TX_RATE_MBPS_54 =3D 54
+};
+
+enum {
+	WILC_FW_DEFAULT_SCAN =3D 0,
+	WILC_FW_USER_SCAN =3D BIT(0),
+	WILC_FW_OBSS_PERIODIC_SCAN =3D BIT(1),
+	WILC_FW_OBSS_ONETIME_SCAN =3D BIT(2)
+};
+
+enum {
+	WILC_FW_ACTION_FRM_IDX =3D 0,
+	WILC_FW_PROBE_REQ_IDX =3D 1
+};
+
+enum wid_type {
+	WID_CHAR		=3D 0,
+	WID_SHORT		=3D 1,
+	WID_INT			=3D 2,
+	WID_STR			=3D 3,
+	WID_BIN_DATA		=3D 4,
+	WID_BIN			=3D 5,
+};
+
+struct wid {
+	u16 id;
+	enum wid_type type;
+	s32 size;
+	s8 *val;
+};
+
+enum {
+	WID_NIL				=3D 0xffff,
+
+	/*
+	 *  BSS Type
+	 *  -----------------------------------------------------------
+	 *  Configuration : Infrastructure   Independent   Access Point
+	 *  Values to set :         0               1            2
+	 *  -----------------------------------------------------------
+	 */
+	WID_BSS_TYPE			=3D 0x0000,
+
+	/*
+	 *  Transmit Rate
+	 *  -----------------------------------------------------------
+	 *  Configuration : 1  2  5.5  11  6  9  12  18  24  36  48  54
+	 *  Values to set : 1  2    5  11  6  9  12  18  24  36  48  54
+	 *  -----------------------------------------------------------
+	 */
+	WID_CURRENT_TX_RATE		=3D 0x0001,
+
+	/*
+	 *  Channel
+	 *  -----------------------------------------------------------
+	 *  Configuration(g) : 1  2  3  4  5  6  7  8  9 10 11 12 13 14
+	 *  Values to set    : 1  2  3  4  5  6  7  8  9 10 11 12 13 14
+	 *  -----------------------------------------------------------
+	 */
+	WID_CURRENT_CHANNEL		=3D 0x0002,
+
+	/*
+	 *  Preamble
+	 *  -----------------------------------------------------------
+	 *  Configuration :    short    long      Auto
+	 *  Values to set :       0       1         2
+	 *  -----------------------------------------------------------
+	 */
+	WID_PREAMBLE			=3D 0x0003,
+
+	/*
+	 * 11g operating mode (ignored if 11g not present)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   HighPerf  Compat(RSet #1) Compat(RSet #2)
+	 *  Values to set :          1               2               3
+	 *  -----------------------------------------------------------
+	 */
+	WID_11G_OPERATING_MODE		=3D 0x0004,
+
+	/*
+	 *  Mac status (response only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   disconnect  connect
+	 *  Values to get :          0       1
+	 *  -----------------------------------------------------------
+	 */
+	WID_STATUS			=3D 0x0005,
+
+	/*
+	 *  Scan type
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Passive Scanning   Active Scanning
+	 *  Values to set :                  0                 1
+	 *  -----------------------------------------------------------
+	 */
+	WID_SCAN_TYPE			=3D 0x0007,
+
+	/*
+	 *  Key Id (WEP default key Id)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 0 to 3
+	 *  Values to set :   Same value. Default is 0
+	 *  -----------------------------------------------------------
+	 */
+	WID_KEY_ID			=3D 0x0009,
+
+	/*
+	 *  QoS Enable
+	 *  -----------------------------------------------------------
+	 *  Configuration :   QoS Disable   WMM Enable
+	 *  Values to set :   0             1
+	 *  -----------------------------------------------------------
+	 */
+	WID_QOS_ENABLE			=3D 0x000A,
+
+	/*
+	 *  Power Management
+	 *  -----------------------------------------------------------
+	 *  Configuration : NO_POWERSAVE MIN_POWERSAVE MAX_POWERSAVE
+	 *  Values to set : 0            1             2
+	 *  -----------------------------------------------------------
+	 */
+	WID_POWER_MANAGEMENT		=3D 0x000B,
+
+	/*
+	 *  WEP/802 11I Configuration
+	 *  -----------------------------------------------------------
+	 *  Configuration:Disable WP40 WP104 WPA-AES WPA-TKIP RSN-AES RSN-TKIP
+	 *  Values (0x)  :   00     03   07     29       49       31      51
+	 *  Configuration:WPA-AES+TKIP RSN-AES+TKIP
+	 *  Values (0x)  :      69        71
+	 *  -----------------------------------------------------------
+	 */
+	WID_11I_MODE			=3D 0x000C,
+
+	/*
+	 *  WEP Configuration: Used in BSS STA mode only when WEP is enabled
+	 *  -----------------------------------------------------------
+	 *  Configuration : Open System Shared Key Any Type | 802.1x Auth
+	 *  Values (0x)   :    01             02         03 |    BIT2
+	 *  -----------------------------------------------------------
+	 */
+	WID_AUTH_TYPE			=3D 0x000D,
+
+	/*
+	 *  Site Survey Type
+	 *  -----------------------------------------------------------
+	 *  Configuration       :  Values to set
+	 *  Survey 1 Channel    :  0
+	 *  survey all Channels :  1
+	 *  Disable Site Survey :  2
+	 *  -----------------------------------------------------------
+	 */
+	WID_SITE_SURVEY			=3D 0x000E,
+
+	/*
+	 *  Listen Interval
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  -----------------------------------------------------------
+	 */
+	WID_LISTEN_INTERVAL		=3D 0x000F,
+
+	/*
+	 *  DTIM Period
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 1 to 255
+	 *  Values to set :   Same value. Default is 3
+	 *  -----------------------------------------------------------
+	 */
+	WID_DTIM_PERIOD			=3D 0x0010,
+
+	/*
+	 *  ACK Policy
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Normal Ack            No Ack
+	 *  Values to set :       0                   1
+	 *  -----------------------------------------------------------
+	 */
+	WID_ACK_POLICY			=3D 0x0011,
+
+	/*
+	 *  Reset MAC (Set only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Don't Reset	Reset	No Request
+	 *  Values to set :       0               1	    2
+	 *  -----------------------------------------------------------
+	 */
+	WID_RESET			=3D 0x0012,
+
+	/*
+	 *  Broadcast SSID Option: Setting this will adhere to "" SSID element
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Enable             Disable
+	 *  Values to set :   1                  0
+	 *  -----------------------------------------------------------
+	 */
+	WID_BCAST_SSID			=3D 0x0015,
+
+	/*
+	 *  Disconnect (Station)
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Association ID
+	 *  Values to set :   Association ID
+	 *  -----------------------------------------------------------
+	 */
+	WID_DISCONNECT			=3D 0x0016,
+
+	/*
+	 *  11a Tx Power Level
+	 *  -----------------------------------------------------------
+	 *  Configuration : Sets TX Power (Higher the value greater the power)
+	 *  Values to set : Any value between 0 and 63 (inclusive Default 48)
+	 *  -----------------------------------------------------------
+	 */
+	WID_TX_POWER_LEVEL_11A		=3D 0x0018,
+
+	/*
+	 *  Group Key Update Policy Selection
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disabled timeBased packetBased timePacketBased
+	 *  Values to set :   1            2          3              4
+	 *  -----------------------------------------------------------
+	 */
+	WID_REKEY_POLICY		=3D 0x0019,
+
+	/*
+	 *  Allow Short Slot
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disallow Short Slot      Allow Short Slot
+	 *          (Enable Only Long Slot) (Enable Short Slot if applicable)
+	 *  Values to set :    0         1
+	 *  -----------------------------------------------------------
+	 */
+	WID_SHORT_SLOT_ALLOWED		=3D 0x001A,
+
+	WID_PHY_ACTIVE_REG		=3D 0x001B,
+
+	/*
+	 *  11b Tx Power Level
+	 *  -----------------------------------------------------------
+	 *  Configuration : Sets TX Power (Higher the value greater the power)
+	 *  Values to set : Any value between 0 and 63 (inclusive Default 48)
+	 *  -----------------------------------------------------------
+	 */
+	WID_TX_POWER_LEVEL_11B		=3D 0x001D,
+
+	/*
+	 *  Scan Request
+	 *  -----------------------------------------------------------
+	 *  Configuration : Request default scan
+	 *  Values to set : 0
+	 *  -----------------------------------------------------------
+	 */
+	WID_START_SCAN_REQ		=3D 0x001E,
+
+	/*
+	 *  Rssi (get only)
+	 *  -----------------------------------------------------------
+	 *  Configuration :
+	 *  Values to get : Rssi value
+	 *  -----------------------------------------------------------
+	 */
+	WID_RSSI			=3D 0x001F,
+
+	/*
+	 * Join Request
+	 *  -----------------------------------------------------------
+	 *  Configuration : Request to join
+	 *  Values to set : index of scan result
+	 *  -----------------------------------------------------------
+	 */
+	WID_JOIN_REQ			=3D 0x0020,
+
+	WID_LINKSPEED			=3D 0x0026,
+
+	/*
+	 *  Enable User Control of TX Power
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
+	WID_USER_CONTROL_ON_TX_POWER	=3D 0x0027,
+
+	WID_MEMORY_ACCESS_8BIT		=3D 0x0029,
+
+	/*
+	 *  Enable Auto RX Sensitivity feature
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
+	WID_AUTO_RX_SENSITIVITY		=3D 0x0032,
+
+	/*
+	 *  Receive Buffer Based Ack
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
+	WID_DATAFLOW_CONTROL		=3D 0x0033,
+
+	/*
+	 *  Scan Filter
+	 *  -----------------------------------------------------------
+	 *  Configuration : Class       No filter   AP only   Station Only
+	 *  Values to set :                0           1           2
+	 *  Configuration : Priority    High Rssi   Low Rssi     Detect
+	 *  Values to set :                0          0x4         0x0
+	 *  Configuration : Channel     filter off  filter on
+	 *  Values to set :                0          0x10
+	 *  -----------------------------------------------------------
+	 */
+	WID_SCAN_FILTER			=3D 0x0036,
+
+	/*
+	 *  Link Loss Threshold (measure in the beacon period)
+	 *  -----------------------------------------------------------
+	 *  Configuration : Any value between 10 and 254(Set to 255 disable)
+	 *  Values to set : Same value. Default is 10
+	 *  -----------------------------------------------------------
+	 */
+	WID_LINK_LOSS_THRESHOLD		=3D 0x0037,
+
+	WID_ABORT_RUNNING_SCAN		=3D 0x003E,
+
+	/* NMAC Character WID list */
+	WID_WPS_START			=3D 0x0043,
+
+	/*
+	 *  Protection mode for MAC
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Auto  No protection  ERP    HT    GF
+	 *  Values to set :  0     1              2      3     4
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_PROT_MECH		=3D 0x0080,
+
+	/*
+	 *  ERP Protection type for MAC
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Self-CTS   RTS-CTS
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_ERP_PROT_TYPE		=3D 0x0081,
+
+	/*
+	 *  HT Option Enable
+	 *  -----------------------------------------------------------
+	 *  Configuration :   HT Enable          HT Disable
+	 *  Values to set :   1                  0
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_ENABLE			=3D 0x0082,
+
+	/*
+	 *  11n Operating mode (Note that 11g operating mode will also be
+	 *  used in addition to this, if this is set to HT Mixed mode)
+	 *  -----------------------------------------------------------
+	 *   Configuration :  HT Mixed  HT Only-20MHz   HT Only-20/40MHz
+	 *  Values to set :     1         2               3
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_OPERATING_MODE		=3D 0x0083,
+
+	/*
+	 *  11n OBSS non-HT STA Detection flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Do not detect
+	 *  Values to set :  0
+	 *  Configuration :  Detect, do not protect or report
+	 *  Values to set :  1
+	 *  Configuration :  Detect, protect and do not report
+	 *  Values to set :  2
+	 *  Configuration :  Detect, protect and report to other BSS
+	 *  Values to set :  3
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_OBSS_NONHT_DETECTION	=3D 0x0084,
+
+	/*
+	 *  11n HT Protection Type
+	 *  -----------------------------------------------------------
+	 *  Configuration :  RTS-CTS   First Frame Exchange at non-HT-rate
+	 *  Values to set :  0         1
+	 *  Configuration :  LSIG TXOP First Frame Exchange in Mixed Fmt
+	 *  Values to set :  2         3
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_HT_PROT_TYPE		=3D 0x0085,
+
+	/*
+	 *  11n RIFS Protection Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_RIFS_PROT_ENABLE	=3D 0x0086,
+
+	/*
+	 *  SMPS Mode
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Static   Dynamic   MIMO (Power Save Disabled)
+	 *  Values to set :  1        2         3
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_SMPS_MODE		=3D 0x0087,
+
+	/*
+	 *  Current transmit MCS
+	 *  -----------------------------------------------------------
+	 *  Configuration :  MCS Index for data rate
+	 *  Values to set :  0 to 7
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_CURRENT_TX_MCS		=3D 0x0088,
+
+	WID_11N_PRINT_STATS		=3D 0x0089,
+
+	/*
+	 *  11n Short GI Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_SHORT_GI_ENABLE		=3D 0x008D,
+
+	/*
+	 *  11n RIFS Enable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable    Enable
+	 *  Values to set :  0          1
+	 *  -----------------------------------------------------------
+	 */
+	WID_RIFS_MODE			=3D 0x0094,
+
+	/*
+	 *  TX Abort Feature
+	 *  -----------------------------------------------------------
+	 *  Configuration :  Disable Self CTS    Enable Self CTS
+	 *  Values to set :             0                      1
+	 *  Configuration :  Disable TX Abort    Enable TX Abort
+	 *  Values to set :             2                      3
+	 *  Configuration :  Enable HW TX Abort Enable SW TX Abort
+	 *  Values to set :             4                      5
+	 *  -----------------------------------------------------------
+	 */
+	WID_TX_ABORT_CONFIG		=3D 0x00A1,
+
+	WID_REG_TSSI_11B_VALUE		=3D 0x00A6,
+	WID_REG_TSSI_11G_VALUE		=3D 0x00A7,
+	WID_REG_TSSI_11N_VALUE		=3D 0x00A8,
+	WID_TX_CALIBRATION		=3D 0x00A9,
+	WID_DSCR_TSSI_11B_VALUE		=3D 0x00AA,
+	WID_DSCR_TSSI_11G_VALUE		=3D 0x00AB,
+	WID_DSCR_TSSI_11N_VALUE		=3D 0x00AC,
+
+	/*
+	 *  Immediate Block-Ack Support
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    0                       1
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_IMMEDIATE_BA_ENABLED	=3D 0x00AF,
+
+	/*
+	 *  TXOP Disable Flag
+	 *  -----------------------------------------------------------
+	 *  Configuration : Disable                  Enable
+	 *  Values to set :    1                        0
+	 *  -----------------------------------------------------------
+	 */
+	WID_11N_TXOP_PROT_DISABLE	=3D 0x00B0,
+
+	WID_TX_POWER_LEVEL_11N		=3D 0x00B1,
+
+	/* Custom Character WID list */
+	/* SCAN Complete notification WID*/
+	WID_SCAN_COMPLETE		=3D 0x00C9,
+
+	WID_DEL_BEACON			=3D 0x00CA,
+
+	WID_LOG_TERMINAL_SWITCH		=3D 0x00CD,
+	WID_TX_POWER			=3D 0x00CE,
+	/*  EMAC Short WID list */
+	/*  RTS Threshold */
+	/*
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 256 to 2347
+	 *  Values to set :   Same value. Default is 2347
+	 *  -----------------------------------------------------------
+	 */
+	WID_RTS_THRESHOLD		=3D 0x1000,
+
+	/*
+	 *  Fragmentation Threshold
+	 *  -----------------------------------------------------------
+	 *  Configuration :   Any value between 256 to 2346
+	 *  Values to set :   Same value. Default is 2346
+	 *  -----------------------------------------------------------
+	 */
+	WID_FRAG_THRESHOLD		=3D 0x1001,
+
+	WID_SHORT_RETRY_LIMIT		=3D 0x1002,
+	WID_LONG_RETRY_LIMIT		=3D 0x1003,
+	WID_BEACON_INTERVAL		=3D 0x1006,
+	WID_MEMORY_ACCESS_16BIT		=3D 0x1008,
+
+	WID_JOIN_START_TIMEOUT		=3D 0x100F,
+	WID_ASOC_TIMEOUT		=3D 0x1011,
+	WID_11I_PROTOCOL_TIMEOUT	=3D 0x1012,
+	WID_EAPOL_RESPONSE_TIMEOUT	=3D 0x1013,
+
+	/* NMAC Short WID list */
+	WID_11N_SIG_QUAL_VAL		=3D 0x1085,
+	WID_CCA_THRESHOLD		=3D 0x1087,
+
+	/* Custom Short WID list */
+
+	/* EMAC Integer WID list */
+	WID_FAILED_COUNT		=3D 0x2000,
+	WID_RETRY_COUNT			=3D 0x2001,
+	WID_MULTIPLE_RETRY_COUNT	=3D 0x2002,
+	WID_FRAME_DUPLICATE_COUNT	=3D 0x2003,
+	WID_ACK_FAILURE_COUNT		=3D 0x2004,
+	WID_RECEIVED_FRAGMENT_COUNT	=3D 0x2005,
+	WID_MCAST_RECEIVED_FRAME_COUNT	=3D 0x2006,
+	WID_FCS_ERROR_COUNT		=3D 0x2007,
+	WID_SUCCESS_FRAME_COUNT		=3D 0x2008,
+	WID_HUT_TX_COUNT		=3D 0x200A,
+	WID_TX_FRAGMENT_COUNT		=3D 0x200B,
+	WID_TX_MULTICAST_FRAME_COUNT	=3D 0x200C,
+	WID_RTS_SUCCESS_COUNT		=3D 0x200D,
+	WID_RTS_FAILURE_COUNT		=3D 0x200E,
+	WID_WEP_UNDECRYPTABLE_COUNT	=3D 0x200F,
+	WID_REKEY_PERIOD		=3D 0x2010,
+	WID_REKEY_PACKET_COUNT		=3D 0x2011,
+	WID_1X_SERV_ADDR		=3D 0x2012,
+	WID_STACK_IP_ADDR		=3D 0x2013,
+	WID_STACK_NETMASK_ADDR		=3D 0x2014,
+	WID_HW_RX_COUNT			=3D 0x2015,
+	WID_MEMORY_ADDRESS		=3D 0x201E,
+	WID_MEMORY_ACCESS_32BIT		=3D 0x201F,
+
+	/* NMAC Integer WID list */
+	/* Custom Integer WID list */
+	WID_GET_INACTIVE_TIME		=3D 0x2084,
+	WID_SET_OPERATION_MODE		=3D 0X2086,
+	/* EMAC String WID list */
+	WID_SSID			=3D 0x3000,
+	WID_FIRMWARE_VERSION		=3D 0x3001,
+	WID_OPERATIONAL_RATE_SET	=3D 0x3002,
+	WID_BSSID			=3D 0x3003,
+	WID_WEP_KEY_VALUE		=3D 0x3004,
+	WID_11I_PSK			=3D 0x3008,
+	WID_11E_P_ACTION_REQ		=3D 0x3009,
+	WID_1X_KEY			=3D 0x300A,
+	WID_HARDWARE_VERSION		=3D 0x300B,
+	WID_MAC_ADDR			=3D 0x300C,
+	WID_HUT_DEST_ADDR		=3D 0x300D,
+	WID_PHY_VERSION			=3D 0x300F,
+	WID_SUPP_USERNAME		=3D 0x3010,
+	WID_SUPP_PASSWORD		=3D 0x3011,
+	WID_SITE_SURVEY_RESULTS		=3D 0x3012,
+	WID_RX_POWER_LEVEL		=3D 0x3013,
+	WID_SET_STA_MAC_INACTIVE_TIME	=3D 0x3017,
+	WID_ADD_WEP_KEY			=3D 0x3019,
+	WID_REMOVE_WEP_KEY		=3D 0x301A,
+	WID_ADD_PTK			=3D 0x301B,
+	WID_ADD_RX_GTK			=3D 0x301C,
+	WID_ADD_TX_GTK			=3D 0x301D,
+	WID_REMOVE_KEY			=3D 0x301E,
+	WID_ASSOC_REQ_INFO		=3D 0x301F,
+	WID_ASSOC_RES_INFO		=3D 0x3020,
+	WID_MANUFACTURER		=3D 0x3026, /*Added for CAPI tool */
+	WID_MODEL_NAME			=3D 0x3027, /*Added for CAPI tool */
+	WID_MODEL_NUM			=3D 0x3028, /*Added for CAPI tool */
+	WID_DEVICE_NAME			=3D 0x3029, /*Added for CAPI tool */
+	WID_SET_DRV_HANDLER		=3D 0x3079,
+
+	/* NMAC String WID list */
+	WID_11N_P_ACTION_REQ		=3D 0x3080,
+	WID_HUT_TEST_ID			=3D 0x3081,
+	WID_PMKID_INFO			=3D 0x3082,
+	WID_FIRMWARE_INFO		=3D 0x3083,
+	WID_REGISTER_FRAME		=3D 0x3084,
+	WID_DEL_ALL_STA			=3D 0x3085,
+	WID_REMAIN_ON_CHAN		=3D 0x3996,
+	WID_SSID_PROBE_REQ		=3D 0x3997,
+	WID_JOIN_REQ_EXTENDED		=3D 0x3998,
+
+	WID_IP_ADDRESS			=3D 0x3999,
+
+	/* Custom String WID list */
+
+	/* EMAC Binary WID list */
+	WID_UAPSD_CONFIG		=3D 0x4001,
+	WID_UAPSD_STATUS		=3D 0x4002,
+	WID_WMM_AP_AC_PARAMS		=3D 0x4003,
+	WID_WMM_STA_AC_PARAMS		=3D 0x4004,
+	WID_NETWORK_INFO		=3D 0x4005,
+	WID_STA_JOIN_INFO		=3D 0x4006,
+	WID_CONNECTED_STA_LIST		=3D 0x4007,
+
+	/* NMAC Binary WID list */
+	WID_11N_AUTORATE_TABLE		=3D 0x4080,
+
+	WID_SCAN_CHANNEL_LIST		=3D 0x4084,
+
+	WID_INFO_ELEMENT_PROBE		=3D 0x4085,
+	WID_INFO_ELEMENT_ASSOCIATE	=3D 0x4086,
+	WID_ADD_STA			=3D 0X4087,
+	WID_REMOVE_STA			=3D 0X4088,
+	WID_EDIT_STA			=3D 0X4089,
+	WID_ADD_BEACON			=3D 0x408a,
+
+	WID_SETUP_MULTICAST_FILTER	=3D 0x408b,
+
+	/* Miscellaneous WIDs */
+	WID_ALL				=3D 0x7FFE,
+	WID_MAX				=3D 0xFFFF
+};
+
+#endif
--=20
2.7.4

