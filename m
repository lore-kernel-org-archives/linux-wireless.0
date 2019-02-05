Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00935C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A11572073D
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="eh+4Pthw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfBEJtZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:49:25 -0500
Received: from mail-eopbgr690082.outbound.protection.outlook.com ([40.107.69.82]:60086
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfBEJtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 04:49:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJzrsQtz8F3KQYYeGxm4oydm8SjJOqZa9tLI9OplI1s=;
 b=eh+4Pthw0AnswD6GvhofxipGQlyHBiTl3tDW04ZlO3A3MNAHv7dcR67sb5iZtSmFZyWxQLBC71CS5YwpcsliWJF9UT4vcORmHSt1itLb2s/v45RNEzMUXaxRfx+gTcfILIz5MSFCEfO34iO5Ak/gox73N561mrGeilbBz6/Y2Ro=
Received: from BYAPR05MB6102.namprd05.prod.outlook.com (20.178.54.155) by
 BYAPR05MB4805.namprd05.prod.outlook.com (52.135.235.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.15; Tue, 5 Feb 2019 09:49:13 +0000
Received: from BYAPR05MB6102.namprd05.prod.outlook.com
 ([fe80::2496:f495:6788:b38f]) by BYAPR05MB6102.namprd05.prod.outlook.com
 ([fe80::2496:f495:6788:b38f%2]) with mapi id 15.20.1601.016; Tue, 5 Feb 2019
 09:49:13 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5616.namprd05.prod.outlook.com (52.135.111.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.16; Tue, 5 Feb 2019 09:48:53 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620%4]) with mapi id 15.20.1601.016; Tue, 5 Feb 2019
 09:48:53 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 0/2] qtnfmac: enable WPA3 SAE/OWE support
Thread-Topic: [PATCH 0/2] qtnfmac: enable WPA3 SAE/OWE support
Thread-Index: AQHUvTgANL1yC5WgyEmEHwGuXPQocw==
Date:   Tue, 5 Feb 2019 09:48:52 +0000
Message-ID: <20190205094842.31568-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4805;6:Df+eez6g+9fcefZEdzLW2QnEXJThLzFx3iUCaP3m3er0D4LwHYE/qUwTEha0gt9d/QqQ2PBxPVZINBcnMR8BWGMi3Ci7+HsXZykhTbygsZTbmQbQRMPOBeIxt5ZuBLBwaTeknEjKa7onnpPMs+lDE+G5Nydn2BgcTgUtAlcz3i2fvbltPpN21uIdi8P3oaCu+RY7Ixbs4OuxyQLWPgkFbpH0fSdxKDCE7IGEGMdIjncQeK307QJiak3uPu+PKrbwfMAtRb46/ybtquGrNX6GgD4QGyOo3wasvmPTiNOaWFIZ7BTuNk2m93ECT3Lsv7AQtO9Y5YzOgD7pZRzIzWFSbzJ/nNu8/IoxAm46j5XEFBRwmxuDCyeAreGgmMsJMEFQ6c5Hl9gaz79fDa5JESg1NyqvNDQXTn2u40OiwdPjFRIlsGMIc8DVSA8a1e1d/PxQdApBOTkpNx4dayG0GjruOQ==;5:pgRSfOPxX9kJa+OitrKSRFOLKZBbblWM6OgNeA+22PluedgfZP74FF14VCTFyZlqSawmEKJlagc6GRjV44xQJGXHNwpdktz9hHk0oNROBVyHvbrGuDq2/GRf6w8yPSzp2cO2FA9J4on6tT8Bcb0HD6Z5V86xHIAAvNrveuDMdQDaC4Uit3mMgRT5Nwq24CwdO1rV9RUuayuLIUuPLUvvww==;7:295g25qAhNXfKda8dgBknhBWFNXG5ePGlgS899Lw3DZcqrLV6Nz6vJ4srHaHd0xkH7acduj+IY3Mzjgoqj7yLWOXbWlnGe/Ot5cZnDTYk6ZFqwKJHHGEmPxjTrJq3e73J33UMnT/sZ/2GQo1DuY9OQ==
x-ms-office365-filtering-correlation-id: cc5ddb3a-71ad-48c7-6a76-08d68b4f20e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5616;
x-ms-traffictypediagnostic: SN6PR05MB5616:|BYAPR05MB4805:
x-moderation-data: 2/5/2019 9:49:12 AM
x-microsoft-antispam-prvs: <BYAPR05MB4805D21D7D537B764AB44F43A36E0@BYAPR05MB4805.namprd05.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(39840400004)(366004)(136003)(189003)(199004)(86362001)(107886003)(476003)(2616005)(81166006)(81156014)(186003)(6436002)(2351001)(7736002)(8676002)(71190400001)(103116003)(71200400001)(8936002)(436003)(4326008)(486006)(2906002)(36756003)(54906003)(256004)(52116002)(14454004)(99286004)(25786009)(2501003)(6116002)(3846002)(105586002)(53936002)(478600001)(6512007)(1076003)(316002)(66066001)(6916009)(68736007)(106356001)(102836004)(5640700003)(26005)(50226002)(4744005)(386003)(6506007)(6486002)(305945005)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4805;H:BYAPR05MB6102.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vx4CD50ZOnzgIu3a+MIEQj0BaZnujtEhKsYlNb4C8xt+fLp9wCiHpIUK4WNsUUQQIwgsim11L2Xc4qQKE5OV0g1b2FRuy7jFhFzy1ZHtpKAriFGpt04cKb0i9mejVA56Ua1tbxkv60jfuYJaMCyJIevnLIjyYHCqWKZOyZiPXgjaabA6jsoC+VIrwAB0/MP1C9OyY8R/OeXL+IJ5NqHPzPdkiwEDPr1CGDx0F6w5c2IGIpRuHYDx+pesha+/8Tu3m4h42k8FYMnCDFWuGnayk3qQQfLSD9v+FBngS1BUJk5fAnpvwFfurxVKbFsSSska4F0Lo0hk+x6xkd9RwNM4Xhgn6svE7qMRqnQh1TrrbKt9pmpUFya6yaT/wq8yXTwg+Mdks8vdbPjQEUcrzqxYhuS9k3DPIL7OaAHKUb6afiE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5ddb3a-71ad-48c7-6a76-08d68b4f20e7
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 09:49:13.7360
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4805
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Kalle and all,

These two patches enable WPA3 support for qtnfmac driver including
SAE, OWE, as well as their transition modes.

Sergey Matyukevich (2):
  qtnfmac: enable WPA3 OWE support
  qtnfmac: enable WPA3 SAE support

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  40 ++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  29 ++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   2 +
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 185 +++++++++++++++++-=
----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  36 +++++
 5 files changed, 247 insertions(+), 45 deletions(-)

--=20
2.11.0

