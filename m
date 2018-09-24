Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E84C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECAE521486
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="iHuFBY9r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECAE521486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbeIXLNu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:13:50 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeIXLNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cQ8b3MVCbFgXC/Pf7gZKHGzI3yyMUe2HIyiwFlu3Jw=;
 b=iHuFBY9rIUcfIS81p/MpDcAjlhmcNeOITrJDSZ/drTNPOKhcOoRmj9yscP5s/mywysLq/ucYTVZexAQx/bDsrUheDfBCQbI9l6smvNdYjGjFtztXMGCZdjySJ3D+5dH6Oj9heAYFnEMzTmQqXxWnwlYemFR3WhSHz7A7WAsm7i0=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:25 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:25 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 02/11] qtnfmac_pcie: move Pearl pcie sources to pcie-specific
 directory
Thread-Topic: [PATCH 02/11] qtnfmac_pcie: move Pearl pcie sources to
 pcie-specific directory
Thread-Index: AQHUU8VSIOYs3NbPOkGZdPwOyFcrfA==
Date:   Mon, 24 Sep 2018 05:13:25 +0000
Message-ID: <20180924051246.13371-3-igor.mitsyanko.os@quantenna.com>
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:K7ZAK/uIUk304idbWlHHe1eZqSoVdpZ4qMOxxVMNWzchG1W6nzjbkf6pwU8ueMTlZqoFaHUgnJttxK6mgTcoR/WF+g6r+x0zr/ETJadC5i4Ua0RWVP6BhRQclRD/7RbYuOA7MveVNKYJnr8RvrCubWwvWHNPDMkL5vKz+MNClH7zBle25sJSic4bY5SvKuTZ3V5iKDvRZcBj5gEVS7lm6kC5LrINb9YOzXJUYpYG4eTFYBo+qur8umY/vq9hMQsrBvE9LgnVYm2sq12pBuPsMtpzwhBrHEbx2jgsIg7Fq5fE964jSzsbahgPJZ384NTEde0DbOiooFFYvIYIe+DrX7dBi4PDZyH2YKM5oiBofQIfqgXX2s1NCrJqCghITjy98Mcbiu50Hc+bM61cqipBkblbkgHJEt1qP5mB1m5jOhLV6dwkpDh3/o1VhRsluJgGd7QEez7UBoeT85p+mB3RuQ==;5:a7lW2XfjUA2B2GrFwzdbjHVXxxdkwA5QJKHIMutuDZnYFvNVMx/uadgrEvAl1f5kJk7MKSyrAyrL96nGthTTkknbZb90gWL4AKjOtHc7khKNWXGPfkVVOBEHPW55r3mwJwwr533eS77C1fVrcL8VG8a+FkiH+BNjx1cVbS1iBrU=;7:vNy0OnEQoFJ5x+Yqm9L6UxdZLoOb3MSKBuOwsaFferP3V2A+5oDi4v7MUKIri1+jkdZUjJYan/j0bXzAbBrbg1buu/BUed2W9FSZl3lQWmMUDJst3sfQ4JMpWjVkYSvN1eioiVNqKXlPhzz8EFWeAB/tdLHY1SpZyIV73z/icBJQdKJHT63DBvtXZmprq400Zyn8VHSf5Yi9p7nCfgbsDps/7OmkJ/oDOHELq9hB/pfhqrgzeILgrrTCCO1/Niul
x-ms-office365-filtering-correlation-id: 7e62ff94-8e92-4c97-1f5a-08d621dc7497
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB29750AF5B6638F981EF87A7BB0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: uE6f2XnUmv1P14JQrEXmUiLzbD5U+8/0Hh78WXjKip8iwg6Eo42DXrPKBvD2ozwevVHdU5bEX2aBcad32Q5rGzCf3wYJQZUX8NnQZguNWciEqNnWpEd5mmh04Eq8DAtiT3bFJKRp1pILHB16JTwyhSTEUtSDbYJwpJ/rLr7yRiIBLtCcKTET7ASrEyE8oAIm3RIGdGFy1MqIdMdUElRTMt8huTjlVbYMOY8um5Kkr71osKX3aZUHiCqYc1X7/jWqwJwqYYknKf7l5fDOLa264Jj7BNCRofMrw5+fhdZnXRp329v7sjd8Cj3eRHt51+J4IQy8Mol9/Fd3jd0cw3UMBhyaf7/jggoeD5P9zX7dEik=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e62ff94-8e92-4c97-1f5a-08d621dc7497
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:25.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051325.2AvB2B5kUHaYLRGd8nx3POz5cBMghSKiBrXIUw4cvAo@z>

In preparation to extract common qtnfmac PCIe driver sources into a
separate file, move existing Pearl-specific pcie driver sources to pcie/
directory.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile                       | 2 =
+-
 .../wireless/quantenna/qtnfmac/{pearl/pcie.c =3D> pcie/pearl_pcie.c}    | =
2 +-
 .../qtnfmac/{pearl/pcie_bus_priv.h =3D> pcie/pearl_pcie_bus_priv.h}     | =
4 ++--
 .../quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/pearl_pcie_ipc.h}     | =
0
 .../qtnfmac/{pearl/pcie_regs_pearl.h =3D> pcie/pearl_pcie_regs.h}       | =
0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie.c =3D> pcie/pear=
l_pcie.c} (99%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_bus_priv.h =3D> =
pcie/pearl_pcie_bus_priv.h} (97%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/=
pearl_pcie_ipc.h} (100%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h =3D=
> pcie/pearl_pcie_regs.h} (100%)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/=
wireless/quantenna/qtnfmac/Makefile
index 97f760a..9eeddea 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -23,6 +23,6 @@ obj-$(CONFIG_QTNFMAC_PEARL_PCIE) +=3D qtnfmac_pearl_pcie.=
o
=20
 qtnfmac_pearl_pcie-objs +=3D \
 	shm_ipc.o \
-	pearl/pcie.o
+	pcie/pearl_pcie.o
=20
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/=
net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
similarity index 99%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 97cc7f2..269a6e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -29,7 +29,7 @@
 #include <linux/log2.h>
=20
 #include "qtn_hw_ids.h"
-#include "pcie_bus_priv.h"
+#include "pearl_pcie_bus_priv.h"
 #include "core.h"
 #include "bus.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
similarity index 97%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
index 397875a..986b957 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
@@ -20,8 +20,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
=20
-#include "pcie_regs_pearl.h"
-#include "pcie_ipc.h"
+#include "pearl_pcie_regs.h"
+#include "pearl_pcie_ipc.h"
 #include "shm_ipc.h"
=20
 struct bus;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h=
 b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
--=20
2.9.5

