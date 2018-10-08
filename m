Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B429CC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A172086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Pw16QKoY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77A172086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbeJHRGz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:06:55 -0400
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:36736
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbeJHRGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYRI0NZa6q+wZk9NsTs8wkl6KdhZkjsONNdewIw2N1o=;
 b=Pw16QKoYY5Gm6PZwl7krCMnbZum91cYPg+myu9s6K3vLjdKD51YMQD05XW/hICEOX+n28rEZwPzTUL0cZNNoLcEHAumotCyZQxDE3V1IsdVsb1LqsJWrH/GTTghLK2ZlxyFHjS8/gdJDdCRWH2H1IRianweMCv6wgN3pDjTz2to=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4642.namprd05.prod.outlook.com (20.177.144.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.16; Mon, 8 Oct 2018 09:55:59 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 09:55:59 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 0/5] qtnfmac: add support for QSR1000/QSR2000 (aka Topaz)
 chipsets
Thread-Topic: [PATCH 0/5] qtnfmac: add support for QSR1000/QSR2000 (aka Topaz)
 chipsets
Thread-Index: AQHUXu0du+LKs/O9F02tSWX0flsOIw==
Date:   Mon, 8 Oct 2018 09:55:59 +0000
Message-ID: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4642;6:oFYWPqpiyIa5S/yTT06HTrfd/7j8UApr/QIWmcEvhheFWwKHZw1ZxzI9d3wmaUrA/FVhcnQ6R7xii0ymC0P7pcYeXZKYoXHTDDBW8sEvukrlRUeQkk1Awqep4jP6OGTC00Z5BULoCWM9WKzKITegls9gb8n7TbZR0rcQqRxNBEbvJ0ImcJ+gr04NmDa9UAv4kUkH4kT9s/asPq1FeAgsMLMQvS1a6JiWSoszurLnoiIys/SSypOCcebQdaSGGYSQMHs2ftgYIECu8VFpl08AC1dvsnXHTG85jt+0bcCA+W4dvN5DrFNRj/n7ihO7OHk614OkrLZvKSfXerj1LPA/vQpdZlI2EPtFc+ZtIiOUG7+4lfWKXm80kDJoCb5Fo1hI6eGRRevAHuSv4OX66Ij1D/IYndsDk2poEqdpleMcIy07GECg045vrtgrzT9ZPFscQ23t9AmR/ucKOkVLyUL3bg==;5:FBVB5MPUska+JYDiPB7b61zef6BSfrJcvpONbh/LPC5/EVw6GXWeXqjGzcLuxyKa3mvCgQeMPkUiV9UqWIemz2LoeJHrQwcnNz00M11AceGjAUkDhB+HUWuT7DsZdJTKYtNIB7/evCAuLmoGfO35LcHqRVqUXyjwppi2Ip3JmCM=;7:rbPInWymTJ7XmDpCwolV0j5JC8Z4YygNBMNnW6Q+q55ssXCBXcHQk51SIQ9gy5zktdRQ4jCE4HFYPta8Bejn5I6e53ShyV5XSEowLGsRkALISW/C1kC36zesb86rFpCcXjDnpsvM6E76gQFLAvCL+GQ4sqveaOe++zSK2Ix6bo9kBZR4eL8QfvBkAvWDnHYnzkcEbiggj86dALnfm7XkhLSmmZqUiQ8M4wjIRkk9aaxxDNRcQREyO17x0v04xs0l
x-ms-office365-filtering-correlation-id: 37e37e64-a0e6-453b-c74f-08d62d043f4f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4642;
x-ms-traffictypediagnostic: BL0PR05MB4642:
x-microsoft-antispam-prvs: <BL0PR05MB464252197093BFF1A5038C9EA3E60@BL0PR05MB4642.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(3002001)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BL0PR05MB4642;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4642;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(396003)(346002)(366004)(376002)(189003)(199004)(105586002)(486006)(68736007)(2351001)(5250100002)(386003)(316002)(2501003)(2616005)(5660300001)(6916009)(103116003)(186003)(14454004)(14444005)(53936002)(102836004)(3846002)(256004)(305945005)(7736002)(2900100001)(8936002)(106356001)(107886003)(26005)(1076002)(6436002)(54906003)(478600001)(6116002)(6486002)(81156014)(25786009)(99286004)(8676002)(81166006)(476003)(52116002)(5640700003)(6506007)(71200400001)(6512007)(71190400001)(2906002)(66066001)(4326008)(86362001)(36756003)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4642;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vHqvx7g51S6PDMflnZp+Eqy/Lk6nRmUpE0dIrbo8uVlaCS9Pvkehy6HSdxtaosQnlLsE/kp2COwjFduYkKo0DehqOjJTJRmdKhbERvl4gO9+dUVQB5PHb0RwNxOzWvwpi4bG3YGdCgorCfMtJ1TJNdOJe085s9ynBBD3FnEQYrczl0Vgj+dvTrmkNJ/WwFqRX2VWFLJnPO+xbRTFNXi5TsvtQOyl7TZpGGF8NWHzcLoDIV6ScaYlcv41LZAh2tvPN6T7dOh0PKLMJGM8X2/K5sxCWu7Ghqn9b6l7WIvubGY+PVdMV5iJMqMW8yVIXUz5GNqw6rsEzjFVtrkp32TPcSTN7yceNIBqSQAg5bGcsRg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e37e64-a0e6-453b-c74f-08d62d043f4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 09:55:59.2628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4642
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,=20

Here is the next update for qtnfmac driver. This patch set adds
support for the previous generation of Quantenna wireless cards,
namely QSR1000/QSR2000 family of devices.

The summary of changes is as follows:
- the last bits of pcie layer unification work:
  -- extract remaining code that can be shared across various PCIe chips
  -- cleanup/rename: get ready to support another chipset
- add support for QSR1000/QSR2000 devices
- minor cleanups: Kconfig, SPDX, unused register definitions

Regards,
Sergey

 Kconfig                        |    2=20
 qtnfmac/Kconfig                |   31 -
 qtnfmac/Makefile               |   11=20
 qtnfmac/pcie/pcie.c            |  286 ++++++---
 qtnfmac/pcie/pcie_priv.h       |   20=20
 qtnfmac/pcie/pearl_pcie.c      |  228 ++-----
 qtnfmac/pcie/pearl_pcie_ipc.h  |   22=20
 qtnfmac/pcie/pearl_pcie_regs.h |  245 --------
 qtnfmac/pcie/topaz_pcie.c      | 1219 ++++++++++++++++++++++++++++++++++++=
+++++
 qtnfmac/pcie/topaz_pcie_ipc.h  |   94 +++
 qtnfmac/pcie/topaz_pcie_regs.h |   45 +
 qtnfmac/qtn_hw_ids.h           |    3=20
 qtnfmac/util.c                 |   18=20
 qtnfmac/util.h                 |    2=20
 14 files changed, 1697 insertions(+), 529 deletions(-)
