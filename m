Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5147C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E9F2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="i+IjFooy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCTKEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:04:38 -0400
Received: from mail-eopbgr800070.outbound.protection.outlook.com ([40.107.80.70]:59840
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHwTVMZj+9lmtiGmpLC/0HFF0mKgC044obqcR71pGKo=;
 b=i+IjFooyCJ+v5Bd9rQGJ+gCdZRkXxFI5l1F3Ve3EGPZPb+a+7UfU3NJyLWFaKyiCpzolziT0sADaVG45lQaypqSZTTbtlM/enONGHLoDqBSuWE5j9Cm7ddWz156v12zw/9HdE+4F1rRwBkdXcpqysdNOOzuMbwU1ONGtzgvmZjo=
Received: from DM6PR05MB4074.namprd05.prod.outlook.com (20.176.71.160) by
 DM6PR05MB4857.namprd05.prod.outlook.com (20.176.112.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.9; Wed, 20 Mar 2019 10:04:25 +0000
Received: from DM6PR05MB4074.namprd05.prod.outlook.com
 ([fe80::5c06:b9ab:6a1a:8657]) by DM6PR05MB4074.namprd05.prod.outlook.com
 ([fe80::5c06:b9ab:6a1a:8657%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:24 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:46 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:46 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 00/14] qtnfmac: regulatory rework and misc fixes
Thread-Topic: [PATCH 00/14] qtnfmac: regulatory rework and misc fixes
Thread-Index: AQHU3wQ1OsK+2dolrUCCM6B0Hq+zZg==
Date:   Wed, 20 Mar 2019 10:03:46 +0000
Message-ID: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfecb750-f2c4-49a8-8bdb-08d6ad1b573c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|DM6PR05MB4857:
x-moderation-data: 3/20/2019 10:04:23 AM
x-microsoft-antispam-prvs: <DM6PR05MB485729F7A9011ED5BB84AA94A3410@DM6PR05MB4857.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(26005)(436003)(103116003)(486006)(68736007)(476003)(2616005)(25786009)(53936002)(316002)(8676002)(106356001)(2351001)(14454004)(105586002)(7736002)(478600001)(305945005)(99286004)(5024004)(81166006)(8936002)(14444005)(50226002)(256004)(52116002)(97736004)(81156014)(4326008)(71200400001)(71190400001)(86362001)(1076003)(6486002)(6512007)(3846002)(6436002)(54906003)(102836004)(66066001)(6116002)(6916009)(107886003)(186003)(5660300002)(2906002)(5640700003)(36756003)(15650500001)(386003)(6506007)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4857;H:DM6PR05MB4074.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ksEbm7+iFqX83Qg/axjBLqP9O101lxIQbmpE2k16rpIXmIBYw2Nfp3zXt6MGTc0PiD1uQ1hOzubFnfBKUCQ8znYZPpLBm+lWrWq8nvg9Qy+iaTRgakfs9ElPypnLjDYQBaWnittNFfcfYUxgPA6ha1HZEi8lKsIoMRnKRt1O7wI8ZayFAzodxTDvLJgXdkBAk4g1YrP58bcK2JIq80zzlioeGqBQMQXa+Wq8A+hoiM3xfiYOj9p5+DA6ZlAxp1+gTSyyxXgzQdLD/ZQiT8R3QG2ae6FUcDzrs2yeCFHMT71V9ysCy2syAiQn8P9lww16O4yiY0I4fLDoYknB/9C+81b5pj6kIHUpIuOmc5egAaKTAq6tmGqKZD5WgvjNtNHdKDp6X/tbs1LxPnDoVS1c71AQvKGCOm+nbM9dT3SNRWs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfecb750-f2c4-49a8-8bdb-08d6ad1b573c
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:24.9817
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4857
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,

Here is the patch set with fixes and enhancements for qtnfmac driver.
The major changes include the following items:
- regulatory rework patches
- use high priority path for EAPOL frames
- fixes to support multiple cards on the same pcie host

Regards,
Sergey

Igor Mitsyanko (10):
  qtnfmac: make regulatory notifier work on per-phy basis
  qtnfmac: simplify error reporting in regulatory notifier
  qtnfmac: include full channels info to regulatory notifier
  qtnfmac: pass complete channel info in regulatory notifier
  qtnfmac: flexible regulatory domain registration logic
  qtnfmac: allow each MAC to specify its own regulatory rules
  qtnfmac: pass DFS region to firmware on region update
  qtnfmac: update bands information on CHANGE_INTF command
  qtnfmac: send EAPOL frames via control path
  qtnfmac: use scan duration param for different scan types

Sergey Matyukevich (4):
  qtnfmac: fix core attach error path in pcie backend
  qtnfmac: simplify firmware state tracking
  qtnfmac: allow changing the netns
  qtnfmac: fix debugfs entries for multiple cards on the same host

 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  25 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  86 +++--
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 362 +++++++++++------=
----
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  56 +++-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  36 +-
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   3 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |  23 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  31 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  85 +++--
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 117 +++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   5 +
 13 files changed, 523 insertions(+), 317 deletions(-)

--=20
2.11.0

