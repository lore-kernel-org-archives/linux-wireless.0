Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ED1C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90C2620863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="FsSjrVSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBIHMW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:22 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9332 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfBIHMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:22 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="26492089"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:21 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SPHzp6Iug5iuLh5+0nrcHpnArFd7iVo7drmV2Oyma0=;
 b=FsSjrVSYBFn12yjkN4x42jbWVv3mFHURGcnZ87fIA8pt179WTVSy0umzv63Y+a+8hynNWIdWZ3BRhRYDhPnMauCrk+oMkRu+Omjkstwt9gXYASkUpEM4puzWH3nPBZmQhTsOId7ZrWHlKgu/CJR8OmjtaelTzWGPtsgAg7ZmF9o=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:20 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:20 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/16] wilc1000: add wilc_wlan_cfg.h
Thread-Topic: [PATCH 04/16] wilc1000: add wilc_wlan_cfg.h
Thread-Index: AQHUwEbLepjjs44QTku9p0Wvgh0eLQ==
Date:   Sat, 9 Feb 2019 07:12:19 +0000
Message-ID: <1549696298-9795-5-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:FmhUCDHE6iVXejvrtv21I7Lp4CYYCnEUjwF1K5DWDCefF0HFHrgT+tQMFkr1U4NI6s27PQqXYEdcQyt0ssPK8xJYY+4arS/6TCxS2kyHP/dh7nUL81TocHO8YVJWGZR9TdURBzb4iCCfsZROW/BbYwlSSAjYN8zOJM2P1TnzIesA9L9ICg7klkplkp0yxFqrPWbtA5kcrSWUe/HzAvWSaHIhQUk/LgUEYm7dQwpSzCCkuwZGeeGri9L87cU4y+lN08wtBMs4ZPtNf8uB4Vtg8wQERkz1rvhSBsscV8xJgOzUhPNSSZXQ2yMCM4EuQMtLYythsT+ju+G/jTqsHDBP3vxdbGOZs5kaXxG7csoicMXqmzC6/OI3i6fjLQpYfVJxkGsBjhn4VQrfFnKDqy48tt8zBGBn3JKqDOc44kl+nGBZKkYatLEyXlc6rrU7nBva9l8tz4NrllLHooLU8Fgtsg==;5:m+DsNEXpmktAG6zkMYDB4krAN4CV5BGllX5iX7dzh63Wi0WLSX1z76eL33UB4kY5brbHc6LadwXS3O9WusqHV97hcex3l9IzfYieH6P0f/KYPD0Kzjuh55sAwlBahukZrK9XaYEMIDXtip9OLiiuaQAuwQs66yxG6pp5lxF4XxZsa2ljMrbOdtlwV1OuPNZ63jHWIOh7pBtlU0LHY16dvg==;7:QpOTYFIpY6XN0rdRMkFL351rNeKFNeL6jF8KRkCaRQaG+drWbnOhvvTKxxgluupjWcoS03fFFqJlvQmHy6WX1nCNq7ZLg9bo1n1vq/cmNj/NFawVews6e1iDokrMnQ0serIYeh+iLfKZSkuovlv4Fg==
x-ms-office365-filtering-correlation-id: f70d7b7d-605f-4b6f-e721-08d68e5dee03
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB312822231F9E79ECA25882B5E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(366004)(346002)(189003)(199004)(78486014)(71200400001)(25786009)(256004)(2906002)(14454004)(3846002)(71190400001)(86362001)(6116002)(316002)(486006)(72206003)(54906003)(53936002)(52116002)(76176011)(305945005)(2501003)(2616005)(26005)(68736007)(6486002)(7736002)(66066001)(2351001)(11346002)(4326008)(8936002)(476003)(50226002)(81156014)(8676002)(81166006)(6512007)(97736004)(107886003)(478600001)(186003)(446003)(106356001)(6916009)(105586002)(6436002)(5640700003)(102836004)(36756003)(99286004)(386003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eWitk3ksqd0LBuoX9Sw5JxZs3hhTauLQGznI2EZRtat/lv5/izvQed4FA+tKcAerM2dGBcX/oxg7HiwzFxsgPNf59G/Ph43DklRrMcApeUQFodwP5kb5TchzUAKolQS4w0D5AvsgwO+b0WJD3x9gcOaIfl9f0rKYh7bYFyRoJZCQ/kGYCpEKZGyTOD3LaCnVsOEU13TO/MExpUpqR78RpmDaedtz6/rbH4lqXvrG8yLSq5Zwe+BcRjIoWoqbCTUqDkbBbIeTPsOTAYTN0XdS/LBgzOwz2IVZfy07gY2MwI7jVhen7wjArhl4l3UVxl6OqQGpE8lcWF6duk4eg8ZsDaIcYvgBe78+TV3N5HJ0lLAhrK1aFgh4WQ98ww3ldQNqZUilYmV/0D2tbxGZ02ubcgzpLHhziAsYnp79m1jzH+w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f70d7b7d-605f-4b6f-e721-08d68e5dee03
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:16.7490
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

Moved '/driver/staging/wilc1000/wilc_wlan_cfg.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../wireless/microchip/wilc1000/wilc_wlan_cfg.h    | 54 ++++++++++++++++++=
++++
 1 file changed, 54 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.h

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.h b/driv=
ers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.h
new file mode 100644
index 0000000..e5ca6ce
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wlan_cfg.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#ifndef WILC_WLAN_CFG_H
+#define WILC_WLAN_CFG_H
+
+struct wilc_cfg_byte {
+	u16 id;
+	u8 val;
+};
+
+struct wilc_cfg_hword {
+	u16 id;
+	u16 val;
+};
+
+struct wilc_cfg_word {
+	u16 id;
+	u32 val;
+};
+
+struct wilc_cfg_str {
+	u16 id;
+	u8 *str;
+};
+
+struct wilc_cfg_str_vals {
+	u8 mac_address[7];
+	u8 firmware_version[129];
+	u8 assoc_rsp[256];
+};
+
+struct wilc_cfg {
+	struct wilc_cfg_byte *b;
+	struct wilc_cfg_hword *hw;
+	struct wilc_cfg_word *w;
+	struct wilc_cfg_str *s;
+	struct wilc_cfg_str_vals *str_vals;
+};
+
+struct wilc;
+int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size=
);
+int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
+int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wid, u8 *buffer,
+				u32 buffer_size);
+void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			       struct wilc_cfg_rsp *rsp);
+int wilc_wlan_cfg_init(struct wilc *wl);
+void wilc_wlan_cfg_deinit(struct wilc *wl);
+
+#endif
--=20
2.7.4

