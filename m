Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192AAC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA073206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="OcLQqGGj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbfAIQSN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:18:13 -0500
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:16105
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731100AbfAIQSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTFsucJB0eEaua9mqU1n9S2aN5yM0k8/UZ5dbfKQ+lo=;
 b=OcLQqGGj2R4WrgtL9WncH2WVEhZLMz7wENZ6sywBPDAMSt+dglkcR94vxC4YHbrejersETLRcs9hOmFac+HTHF9DiAQ2A78W/MJvAixqshqpoOeHkbUvByZbXNBB4mTIZaNaRUEjVAmMfxu1Sr3DOMCdE1e7SENkOYFXYOrVVrg=
Received: from MWHPR05MB3567.namprd05.prod.outlook.com (10.174.250.158) by
 MWHPR05MB3229.namprd05.prod.outlook.com (10.173.229.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.10; Wed, 9 Jan 2019 16:17:59 +0000
Received: from MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::edd7:b7bf:920:e463]) by MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::edd7:b7bf:920:e463%2]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:17:58 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:08:54 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:08:54 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 1/7] qtnfmac: support EBUSY errcode for QLINK protocol
Thread-Topic: [PATCH 1/7] qtnfmac: support EBUSY errcode for QLINK protocol
Thread-Index: AQHUqDWe8TkZgrsN6kmLNUszhkMh7g==
Date:   Wed, 9 Jan 2019 16:08:54 +0000
Message-ID: <20190109160843.14832-2-sergey.matyukevich.os@quantenna.com>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3229;6:1QioEcHtTG7BW4QTRJzrw6GXsso911BHCzUfC/+vYvNRFgNbPFJc3nePXzXwJreNYNdTtdlreZC1UuHsLTeMaanBhsaP6Fi0Xw+DiTUzofKemoHU59ocTrY6GqpUE4JHb8/YBUST76IYG6T45IAMfMH07pGq/ZJWpm0rvnEFkqi8yY2Jy8siEOH/caidbgtQWP6MSbk0juGsNtsSEuJyZ722cZB9Mjlu37hxHbzmFzMV6WBpma+Pmk029Ov7wfqvtu+u9xlh0f2YKNSF4AkoG1XOnaUfFRudvUvOAep9BoqQ7gHy25Tuim5VxE5wY//U+A6wZFw3Hpl0Hh/VTyPtQoBtDLPCO0SjCjp0Ao8DxNSg5TixWmNONhQyqToOGcTYfBesrsBeIrC4dJqVgxKF7vjS0/Z+SBMunVOP7qxFS5kogP7DCr66kgacVFByN1Z6qqnUy57EVlgUv12xs+FTfQ==;5:lQRX8EbHUnVe2qYMLsBdwpKELu0sjYSOCY/1oapot2wfXLi4zsfHO0LcS63LcRJKuxafyU4MkNiDDVdaJK1JQieXZ0ZIsZ7ZJ8nwnDg9PJf2fG9HetS02PDBlUm06KhQv9LA5zJ78QdeTTszSpw6Du9GfTvuykKQEkttyoFYPb0EhFPdxD8QQKvIJfcjeNKpfFtUQeboacJIXSFkLcH78A==;7:hutcZKZ4W3l4Qu33eMT47IP1veOcpKm3Sa8wWz53KJTvkZTWZgLuZxCiBww1rE694A/Nb5UFh1tLOZJzg9Vi2jsAzRjrSsuTZucViMN+4gz36GSBclSAqlf8TAdvtY8TGX91GRS0SltdZCgssn+0Sg==
x-ms-office365-filtering-correlation-id: e6b22f87-2d3d-4c6a-2d45-08d6764cc09f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|MWHPR05MB3229:
x-moderation-data: 1/9/2019 4:17:55 PM
x-microsoft-antispam-prvs: <MWHPR05MB32291E38B520A6BE8AD8B81BA38B0@MWHPR05MB3229.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(25786009)(68736007)(478600001)(14454004)(316002)(7736002)(54906003)(4326008)(11346002)(446003)(99286004)(107886003)(6512007)(186003)(76176011)(52116002)(26005)(106356001)(6346003)(305945005)(6506007)(105586002)(386003)(71190400001)(2351001)(71200400001)(102836004)(53936002)(103116003)(36756003)(486006)(2616005)(476003)(1076003)(81156014)(8936002)(3846002)(6116002)(8676002)(81166006)(2501003)(5660300001)(66066001)(256004)(6436002)(6486002)(97736004)(436003)(86362001)(2906002)(6916009)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3229;H:MWHPR05MB3567.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5dX5KGM4tTTIGcyHl8sg+Yys7fvA5FdzQCUvX2QAX1qT3XZ5SyReF9Me/9pRvQoV1//J4/lCVCHLKiIHlrR/Cbsb9vnYDHpDqstCD83VJTBXmtT99VLRJ/N4/z3H5oBJxXJXaG4Zb5C/8KU7kpJtlC44NvdQbssRx/bdGSGQjhHthE0/IbHY6zTyU49s91c+FKu2fvr31dwhzvupKu0Esx0HFcXhZRV3uNU6oYOQemwIVK5N65P1vIM+j3FSNxjSEohQhh3Q16hAT3Pr6KLEUVW8ZC9FYQl3QtmOvSB9X+gdXyPdCrtaxbVqcaLg7RIR
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b22f87-2d3d-4c6a-2d45-08d6764cc09f
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:17:58.9653
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3229
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Add support of EBUSY error code for remote procedures over QLINK protocol.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 2 ++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 659e7649fe22..c2f085589f54 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -72,6 +72,8 @@ static int qtnf_cmd_resp_result_decode(enum qlink_cmd_res=
ult qcode)
 		return -EADDRINUSE;
 	case QLINK_CMD_RESULT_EADDRNOTAVAIL:
 		return -EADDRNOTAVAIL;
+	case QLINK_CMD_RESULT_EBUSY:
+		return -EBUSY;
 	default:
 		return -EFAULT;
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 8d62addea895..f9c7f87afaf8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -733,6 +733,7 @@ enum qlink_cmd_result {
 	QLINK_CMD_RESULT_EALREADY,
 	QLINK_CMD_RESULT_EADDRINUSE,
 	QLINK_CMD_RESULT_EADDRNOTAVAIL,
+	QLINK_CMD_RESULT_EBUSY,
 };
=20
 /**
--=20
2.11.0

