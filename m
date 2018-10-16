Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB359C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C4632083C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 10:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="AgZDfQqF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C4632083C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbeJPSNn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:13:43 -0400
Received: from mail-sn1nam02on0067.outbound.protection.outlook.com ([104.47.36.67]:10160
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPSNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 14:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NqeA5qnLfTbo+KY+mGAYrAO+LeXL0/BwXJ2e9PRQs8=;
 b=AgZDfQqFEUM23QJnBkYRq7EoPqU32Fg71tghPYWpf2VnQa6+F+V88QEY6a6IbBB+gn8y2fnk0Nz76+zcu4XPwcoXABPbW5Mb247TIS/JMYxh0/33yDRCcZWCPOXSWA/I3t34yrhpWjpQD18JIyqr8c/jn5BWCC1Qrg8hKBOtWJ4=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5379.namprd05.prod.outlook.com (10.167.233.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.18; Tue, 16 Oct 2018 10:23:55 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.020; Tue, 16 Oct 2018
 10:23:55 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH v2 0/2] qtnfmac: add support for QSR1000/QSR2000 (aka Topaz)
 chipsets
Thread-Topic: [PATCH v2 0/2] qtnfmac: add support for QSR1000/QSR2000 (aka
 Topaz) chipsets
Thread-Index: AQHUZTpXD/LwfkFnoUOo9IBmzF3Kww==
Date:   Tue, 16 Oct 2018 10:23:55 +0000
Message-ID: <20181016102349.26544-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0037.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::14) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5379;6:ucQVAix/Fr/z+lO76aUN7oSPOFwBGz2lbQ41mvtVQ19utDDIUKTv4IfeCqvq3Nw8wXFz01bcnTHEKtvfwQuBb1ycSTpNlRgcMDDH2JoxCtfEzGa5O4WTzyZTya024Zawht6FcZac9AV8ISG7GsnQTwFgKQCdkovRy0Pgv80bl0vi8Yq3RnVHX0iT+G1ngd9HNtvWARG4zejE2GXIQ5T2ttAMdYHMaqBvFdlKrWYW9F4b7dk5xKA8iM9IWSk5eLl+Uh9n1DAKeZvh2olSRfWbCiGxN6BZW+/l8aKP0s5HPHKnetxv9EmhaPLOfY3P6eiGS/ExlZxT8NjboR4MwcKOwEIuFdEnFX5AIZEoDsi3/zlu6rTiUoVmlH2Izfc7w7/vt9Z64ZONn7qVS/2ScA3pqLUHC7QSTZwmRLxG2kixC/QF4JKpIcbr3C582G2Yb87Syv/kzccSMuu/IIS46096Pg==;5:njh+zQsXq73AF+wbcp2DoEIogxzkKlv5NTjTXrPt1UQrNGPryuuL/3YsgHeDLt9Gw9OsZgo+9OMB4R6C8pEXJ8JyFbkRF10eRecrZTQ89l/aqiprZT2qCwRj0uoc/a4539/XYOnJzCUx7mFPZih2fxCFzCNp7XW9XK+6idPL7zI=;7:lEiinPOXX7bNfIfVH7skHKWXS4G0upDoCMHUnF7qQNF+RMNeTCjzjzrObJUa3lX1/GA++kLmYWtP394x0aRRyWcBxAwdkfHumtfJ1vtQ68tLlNAvkZ1VsrTRLGqQg6O9wtudTuaP8GTkJJ8HL1HjmGv/31siXfnDBC6hQskMcDUHLUNfZFlg9flzL15RZjoDYuRkw2OppkQ3xpoaf/Bof+au4uRUX4mG9xPJ4j9tSY8V+gIIg4wEVPp4Rpk9H/jy
x-ms-office365-filtering-correlation-id: e90ba3ae-e24b-4a4a-539c-08d6335179ef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5379;
x-ms-traffictypediagnostic: BL0PR05MB5379:
x-microsoft-antispam-prvs: <BL0PR05MB5379B7953F8B9ADC28D28233A3FE0@BL0PR05MB5379.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5379;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5379;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39850400004)(396003)(189003)(199004)(53936002)(68736007)(1076002)(52116002)(3846002)(478600001)(6116002)(86362001)(305945005)(107886003)(14444005)(25786009)(54906003)(36756003)(99286004)(71190400001)(6486002)(71200400001)(6436002)(5640700003)(6512007)(4326008)(7736002)(81166006)(2900100001)(103116003)(26005)(8676002)(186003)(476003)(102836004)(81156014)(8936002)(2616005)(2906002)(386003)(486006)(14454004)(316002)(66066001)(2501003)(6916009)(97736004)(105586002)(6506007)(106356001)(5660300001)(256004)(5250100002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5379;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1mDd/lYS9rteGPBa4VUmd1/RW/OaSVcOKn2NtghpacSddvj+RmbfhxyWnS38hilAvr002FpvDIBKXscfdH1q5DyHkB8whA9EWvaCt5AVUtVyXNM+T7Ki203bMzoD8h2ZNUMEjtRPBM5eS2sWk02e9OgbJm/uIsiwrdgbkxfPJvy1MOMdEAVw+I8FIZJtQUbAxYM/HbC4NjDoXjVaoDR03N7hPbYM991/3MG4c6QUFoLGSOqjzc8x8VorOJWoFEr60KOnp3qfx823A76oKudQueW6e8bQuSFT+o+0EK2bnkMuxgeFvutu6RuvibmgPZbjNU0ERN05VehEVfnqsIiaXg640xUVA7fbOJ0jeDnJXr0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90ba3ae-e24b-4a4a-539c-08d6335179ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 10:23:55.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5379
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,=20

Here is the next update for qtnfmac driver. This patchset adds support
for the previous generation of Quantenna wireless cards,
namely QSR1000/QSR2000 family of PCIe devices.

The summary of changes is as follows:
- the last bits of pcie layer unification work:
  -- extract remaining code that can be shared across various PCIe chips
  -- cleanup/rename: get ready to support another chipset
- add support for QSR1000/QSR2000 devices

Regards,
Sergey

Changes v1 -> v2
- simplify Kconfig options for PCIe backend driver

 Kconfig                |   15=20
 Makefile               |    9=20
 pcie/pcie.c            |  282 +++++++----
 pcie/pcie_priv.h       |   20=20
 pcie/pearl_pcie.c      |  211 ++------
 pcie/topaz_pcie.c      | 1219 ++++++++++++++++++++++++++++++++++++++++++++=
+++++
 pcie/topaz_pcie_ipc.h  |   94 +++
 pcie/topaz_pcie_regs.h |   45 +
 qtn_hw_ids.h           |    4=20
 util.c                 |   18=20
 util.h                 |    2=20
 11 files changed, 1664 insertions(+), 255 deletions(-)
