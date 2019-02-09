Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC32C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E00420863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="C8JLYI/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfBIHMd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:33 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:58332 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfBIHMd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:33 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="26314821"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:32 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/55vOuwNDob/V1b+kIQvdMukLq9uvIP8vAXpvvMsT0=;
 b=C8JLYI/WgRbjBVRe1ABRpSPt1b6B9vtrJ/OCmmtsKSnzTqgrFbC0XIdbe34fdnNdjkV5c4HQJzXNeM3kCEvUrBvsJYwQ55Qro0eQ0Ps6A4q9fIlH1aiVXzAmjkE0/tNpjGmePugEMsmAlVqGlw93y0+bmDkGAi82dKf57YV+Mgk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:31 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:31 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/16] wilc1000: add wilc_wfi_cfgoperations.h
Thread-Topic: [PATCH 07/16] wilc1000: add wilc_wfi_cfgoperations.h
Thread-Index: AQHUwEbSpHTlmZ4gNE2xR6cHrqmMMQ==
Date:   Sat, 9 Feb 2019 07:12:31 +0000
Message-ID: <1549696298-9795-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:+fXcsrrf8hoxGnY036EabEzHYcgUPE11HmTM4rzjn4kBavnysWP4SDbFGdFVUZLa0yQ1/tfLz885tzBXuuj0bPBDEpRcodiZAOADU0js7vL+7nJr8GZfb4f3zGeGfBe5+t1xN5hNRshEzN5O9lbyzUl0+bj3zBn8jTFZGF3wj12MbxEzFeJMcRs64W8O99Gkub1jziIynNdf/BuEWtWTmtCm/kaHpLrdnBkwVGowvch/TgSdtFyGn+r6hJwBwDOOsEGTSLWXWrAHDNvop0Fel3+PyXHtTmybkk2VrAmncBNDM/tKjTJbPAMBKqkM9WzpYJZAjb/NGng8zv0mb5kaN+iJa2cQKvTbMhjmRaYcJa3a7+j5vqNgDe12bdOkBr/5RUNOuTiuuioBfhmm/TOtnc32CDkh+lbv4/lj9sHq1jW++34+2NWsvtoPC1TTuX9ZdB554LwI40l6RfmG/XitkQ==;5:giQNzk/EY5qMS1r5+C4W3jzfue+10Fj4+Gv7X5zh3oagBjWIiAMJjoIYalENqk4g7fQqqloukMa4plLGvOFmYJiaq2uF1uds+T6Jkg53pYtW4N32ZYUd5+W/x2XTOp5MsI28MrDKbaA5OKQIMG5mc9UQkKTsoRJkZdsA5TyBPSnwMlHqBXLrIh6BFT/zBgM3n5kJp91mKpstw00tN+34sw==;7:NXfHP2YOzj6+hkXsWT37Z2Z/K0CqScDUwpMMZUuB2BjiNYJTuYV+ZIv1fKGGHzNyldWOBoRTejiP03ooYXcp61/wLt9SpfNDaa7xZlvxvQ0B9wA4KgxxdbE5KYNIROpsV9itfFRoPxkPtovz/GtEnQ==
x-ms-office365-filtering-correlation-id: 0932e138-19a6-41c3-0e7c-08d68e5df4b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128E05F7C9DD55D501D97C6E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(4326008)(8936002)(50226002)(476003)(52116002)(2616005)(2501003)(76176011)(305945005)(53936002)(6486002)(7736002)(66066001)(11346002)(2351001)(26005)(68736007)(6916009)(36756003)(6506007)(386003)(99286004)(6436002)(105586002)(102836004)(5640700003)(6512007)(8676002)(81156014)(81166006)(186003)(106356001)(446003)(97736004)(107886003)(478600001)(256004)(71200400001)(78486014)(25786009)(316002)(54906003)(72206003)(486006)(14454004)(2906002)(86362001)(3846002)(6116002)(71190400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bx7J+1MD6xpFRGPjRXBNg+fyj/1j40Os8zRJ0vQJNkg5SBq/Y/1ZI2zluEmJosUkQMfRbldkQ3dPubtm7P8/B/cU3gN/T1CGkVD9MUN8LhuAjoRacpIU3dsmr23cP+p1UaMxlpE+0BUfh0MuNWLRmUCjOYm3kUIIciIfA5qw6bU+Kaxq/0gJPN+0v4LQUvEU73+1pg7EtCqFM/4kWk3A4y0ckT6bNHVArTGlKYtYTvlwqN4Ih7CHA4MFrhzQf++xi2BYJOOZN7w9njql8q3MtqO0151CFVBe3Z/AgZAjZK3GjzuSKI76SKW4CvkyfhBeRVqAuhB9ABT64Oj8AgpR9dPahCMoY7YM9BnrcD8f4RTzw6G8X3AuwH7EFiUu+irWmy8+nVhMt6KdUq0k2+AP2+8RtsedOvWcKbJw53ejmm0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0932e138-19a6-41c3-0e7c-08d68e5df4b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:27.7635
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

Moved '/driver/staging/wilc1000/wilc_wfi_cfgoperations.h' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../microchip/wilc1000/wilc_wfi_cfgoperations.h    | 24 ++++++++++++++++++=
++++
 1 file changed, 24 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgope=
rations.h

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations=
.h b/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations.h
new file mode 100644
index 0000000..31dfa1f
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_wfi_cfgoperations.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#ifndef NM_WFI_CFGOPERATIONS
+#define NM_WFI_CFGOPERATIONS
+#include "wilc_wfi_netdevice.h"
+
+struct wireless_dev *wilc_create_wiphy(struct net_device *net,
+				       struct device *dev);
+void wilc_free_wiphy(struct net_device *net);
+void wilc_deinit_host_int(struct net_device *net);
+int wilc_init_host_int(struct net_device *net);
+void wilc_wfi_monitor_rx(struct net_device *mon_dev, u8 *buff, u32 size);
+void wilc_wfi_deinit_mon_interface(struct wilc *wl);
+struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
+					       const char *name,
+					       struct net_device *real_dev);
+void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wd=
ev,
+			      u16 frame_type, bool reg);
+
+#endif
--=20
2.7.4

