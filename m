Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB89AC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 903BE206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="D4RfI2H3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbfAIQSD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:18:03 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:37948
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731219AbfAIQSD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:18:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtcRL+VvMygGlA5kFP+UNpI2kGyV2E8X9vAdSlr9YHI=;
 b=D4RfI2H3b0BNrnBYB3laLrJPoN2+XrjoDQgxbeh6+It78qsVPO+4WF3KPsxT8eBLdWubRPajcGcfF9+8N1YNRcTaWkh5MXr6T/LHdtFEIDXq1SWWOlN/D27yXKzDoNUybUOANj4nYwvIuE7WCEhp8sg0TjSGToP2Cwa07Ye0Yos=
Received: from CY4PR0501MB3873.namprd05.prod.outlook.com (52.132.100.150) by
 CY4PR0501MB3748.namprd05.prod.outlook.com (52.132.98.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.7; Wed, 9 Jan 2019 16:17:52 +0000
Received: from CY4PR0501MB3873.namprd05.prod.outlook.com
 ([fe80::f9eb:3f89:1cf3:30f8]) by CY4PR0501MB3873.namprd05.prod.outlook.com
 ([fe80::f9eb:3f89:1cf3:30f8%4]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:17:52 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:08:52 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:08:52 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 0/7] qtnfmac: fixes and minor enhancements
Thread-Topic: [PATCH 0/7] qtnfmac: fixes and minor enhancements
Thread-Index: AQHUqDWdr1yh/viOmkKWVzIkR7l3QQ==
Date:   Wed, 9 Jan 2019 16:08:52 +0000
Message-ID: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR0501MB3748;6:3AebLYlx+q3wL6IA0gnNqKKSKjQP/IN8s8YKkvfpvLHYJ7oU96Lev84aDEPbiS99F1uKSusJrMw0RxZQjQtZpvLBQlwuNWe6OOHzPB+dNZvciTAQ6sRYNaFBrTF7MAru1f2NOp2/UUkKEkDcWrdbRo3ChOmL03w62RIR1lZ5lMjSwrlh0Yd3O872KrW4zhLThJBFU3NWB1NswtTQeRly58M20Xr3bRi6+vRiOFWy2Xo0Tux03dtbICktRxC6b/ElUf0qNZgdDC1dvIYuTA55SSfxyMU+CJ3Z+6HyDpOL692JYoRu+slwr/zuCtHiAmGkYOxW5ree7sOwkMn1VjLSDkgW39vbXB6IP/KtaUOoevKlXX8540fPjbisnPM0npQuB9t5Aaqur1mHhDZ0F5uJscS/44AtNAE69eOAu4GHe/9WCo1A4h7pvrm499vO6amTVRa0y8PvB7evbr/SFyoctA==;5:hFj951i6rhlM01fA8h5idwZF2dH7CBZJyaR/Y6KwzgA5MppAIidnwhZarJvGjTOrnK+jwRdA7XvlVF5vgUWPSv1hWJjL83fTYbeJIr5QZbr+Qhht3tpeUiyM4ypKT8eSscEbY6pS/q+SBY9IRoSgsyErJV6yIphDLbEbu+pxGdl0tQn9c+PBZ5DZ2jg6wnWaqkwDGDvmzX5SDZm8h74Row==;7:iM2ufI4Ipm6A4a0BaqlRPXRCjU4QqwgRKTZuHe8feobVK665LcRifr0jskny9HPQBGltqDmqW7p6weyPg/iYMIsGUdjDSTNeHsbfwW8c4L+Xy3T9jN95AzVVj5AUIWXfXcVP4u/h//seG7m5m2XS6Q==
x-ms-office365-filtering-correlation-id: 4d72aa02-1889-4694-1a61-08d6764cbf8b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|CY4PR0501MB3748:
x-moderation-data: 1/9/2019 4:17:49 PM
x-microsoft-antispam-prvs: <CY4PR0501MB37487A12F7D4FD3B32A6E510A38B0@CY4PR0501MB3748.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(39850400004)(136003)(376002)(189003)(199004)(106356001)(478600001)(5640700003)(52116002)(14454004)(5660300001)(97736004)(81166006)(81156014)(8676002)(6116002)(3846002)(2501003)(105586002)(1076003)(68736007)(25786009)(6346003)(256004)(386003)(6506007)(71190400001)(486006)(71200400001)(86362001)(102836004)(6436002)(6916009)(53936002)(436003)(4326008)(26005)(6512007)(6486002)(186003)(2616005)(103116003)(107886003)(476003)(7736002)(305945005)(2906002)(99286004)(36756003)(2351001)(8936002)(54906003)(66066001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0501MB3748;H:CY4PR0501MB3873.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A0yMDcrdxjRjKvBsts9eZyZJycHDSSZ1wPvcVVWT9e0q0ry1Z4xGBCfOQ+Ns0SgfbATSZWYuRR8fxoU5r8gIi89+3/p4+PoQVCVDsVxNxH3OR27cJU0BkqdZYavaRZOPzcZ8lc5wHKmCAn0wQAIOEddU9YIFlOSaNAp0byPiFwjBw7aHp9AYRtQ1jvDoC65GglvDUj2C+HlrsMedo2aIAQLQZq+lSf7pIyQ1TgNJo1BeSkmzMfxvQh3br2U0npblUa5YtLA4FkAerUEiKc7t4YK6BSMx1X0UlqBwizuPD8k8aomws0Y7hHKqEdO4HrVW
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d72aa02-1889-4694-1a61-08d6764cbf8b
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:17:52.3790
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3748
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,

Here is the patch set with fixes and enhancements for qtnfmac driver.
The major changes include the following items:
- final conversion to SPDX license format
- 4addr mode support
- PCIe INTx fix

Regards,
Sergey


Andrey Shevchenko (1):
  qtnfmac: support EBUSY errcode for QLINK protocol

Sergey Matyukevich (6):
  qtnfmac: fix legacy PCIe interrupt handling
  qtnfmac: add support for 4addr mode
  qtnfmac: switch to 32bit values for RTS/FRAG thresholds
  qtnfmac: do not reject retry changes in driver
  qtnfmac: convert to SPDX license identifiers
  qtnfmac: add missing bss record to host scan cache

 drivers/net/wireless/quantenna/Makefile            |  1 +
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 30 ++-----
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  |  3 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 48 +++++------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  | 22 ++---
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 21 ++---
 drivers/net/wireless/quantenna/qtnfmac/core.h      | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/debug.c     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/debug.h     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/event.c     | 96 +++++++++++++++++-=
----
 drivers/net/wireless/quantenna/qtnfmac/event.h     | 17 +---
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  6 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 27 ++----
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 16 +---
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    | 28 +++----
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   | 17 +---
 .../net/wireless/quantenna/qtnfmac/shm_ipc_defs.h  | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/trans.c     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/trans.h     | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/util.c      | 17 +---
 drivers/net/wireless/quantenna/qtnfmac/util.h      | 17 +---
 24 files changed, 177 insertions(+), 342 deletions(-)

--=20
2.11.0

