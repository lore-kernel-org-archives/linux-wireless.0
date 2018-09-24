Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD78CECE561
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8808621486
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JwHW6xw3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8808621486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbeIXLOM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:12 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbeIXLOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R0PEZU+qRTnIGOtmJ6hfp7/2DKnl9bsywXcFYWm9rQ=;
 b=JwHW6xw3f6CJ+EbilQvY8EauTW5Ud8zdDvQIXCNusLiSE0pqlSipvqWNg5MJ5EQBKZkO1L7SBja3waaw7UMCIB7Oe2ro9ZMX5G+iutGcUQDb6UK13WAI5Dz8NBAnEONrALvYXi+KUPHj1fMrqNUvxxAEqKaLF5yuNZE+49eJAto=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:31 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:31 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 08/11] qtnfmac: add missing header includes to bus.h
Thread-Topic: [PATCH 08/11] qtnfmac: add missing header includes to bus.h
Thread-Index: AQHUU8VVIbzAj/vKg0asN2ODPOlZ0w==
Date:   Mon, 24 Sep 2018 05:13:31 +0000
Message-ID: <20180924051246.13371-9-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:CL+N8mwxz2VBnbzQ0OXCOkgbsqmQ1BiR5cVPjI8Q3XjWqS8JECUAlPJf05bXfJ9avSHfOTf+Be8Tb+PZ5Ql5ez9UPQR8K1mMe9/FkyqrTiqs2KjJb9i+2NDLiNIJoMhO6nfJi3hrineuUr6B67tzLy5f7C2djmnozPkCG99FNzrkNiRAHuMYrDh9kf+/JCUESU/Xvabo1qudQFLe2cODsfigJatz7IlC7OVtiOYj1qtRg1G6kPdgwfByJZvT2jjOQka0CN/pQKYsAqpI+5QQDoPcrUCJpQDD5N5ciEJDOKAoR82KMZjtBbKw6h3xirqs2FEJ+FwaYvty4ljJiUxcoReg+uasuW8pHxZ3GBbsdrXUnwMuSCgsr7qjXiWAFXMfknryCTSrmkUY8Qhf2KnIVAkiMWF1peV5tjt9obc26U0sNAy+QnC0s+S9XA3xBbHNs+knKc2rZSvIfatJaMDv+g==;5:beRr+Q9MNxs1cq2YOVtiXJ856YPDUGfM4+ZrKCuQrim1wxJnYcT0bwpim/hMIOYnLvJNwyZyhp9gCSR/nS2ICu/tkNToKFnt7h6+YSmZ4JT5GDrVIwp45GP+m9KX2hAFrHeABT22jb3oTBjKRrpazrsH5x5lZCyocDOcF0LtpZk=;7:HM+P0WFP1/anGbjqb+tIX57upUESz4XW+PuWYsxntWD2mtSFIFDYP1TecPB2qdh6I7/+K0qzVnaimEb6o1JPizD8CWOdxUzM4apvXsP5Nu5kR0bPgpwYs8yGuvp4eUcX3rXuMENuLEtWavq2xODqtCAnqtuXl4WUxVJmeyaPp8iKg+aY/chQeBINKqb+uQE0yz6UDRh1VH6Fa7uA3QsLPKa+qbbTribjm5NIV2u97V31mlKwxXwo2R0IwBqyp9oM
x-ms-office365-filtering-correlation-id: d90f716f-31d4-4bec-6f29-08d621dc77e6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB29750B2F299CBACD9F634079B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: dPAh5T1JJ8dr9X7c/a1tA1AOf8B0U5p3ey4PJ79CFKORhzrgtBc+cP4Ry+I2CldAZkGh6faa4CRazp4ywqf15QDgCkg1VEtInfE9wNXfb182qv2BJ1NggH8hewkGGPsT8fG6vLRvcmQ4gcgpmPV9KnM9emCJA+iaQqiPO32VQOJ4EMfIhluMzFn3qR+m3/1QR4r/gPZ63/Jd91e9oZ/iop+mEtazK/EoV7KxAJpJ3wyahGIkvuKsXnMECGsZW9BV9VCezKN/ZKUEj4hXDTm/xpHSl39hFxDYXlAByRYtSSccxuuyoRiLtpxn6yRipm59hQEVGW2YVPHmAn/vceKvqQqOC/wTtdwicmRv6l0dyIk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90f716f-31d4-4bec-6f29-08d621dc77e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:31.0898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051331.WxiyrSMK_Qe1LuvQR_7Cj37z2DGArL95dPLEnc2_x_0@z>

A few include directives were missing in bus.h resulting in dependency
of include order in other modules. Add missing includes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 2beca5b..7c4f856 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -20,6 +20,9 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
=20
+#include "trans.h"
+#include "core.h"
+
 #define QTNF_MAX_MAC		3
=20
 enum qtnf_fw_state {
--=20
2.9.5

