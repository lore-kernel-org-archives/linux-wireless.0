Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A289BC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B33C20659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ji0fuP64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfANJk2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:28 -0500
Received: from mail-eopbgr780088.outbound.protection.outlook.com ([40.107.78.88]:26800
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfANJk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTFsucJB0eEaua9mqU1n9S2aN5yM0k8/UZ5dbfKQ+lo=;
 b=ji0fuP643J5d8FRF14iN811/HqfDTb8HlTrZsj9xiCD2BRiaOgFZt9EeJWnpPDnqQFQV8mPBMGoie4Uzl1jxus/s8ZKhUdCXjtoQjeTzF0USBUYiZtu+JzSzcZ0E/2HQmceCvI0caUD/8Ln406Mk40u+CVFGLusf8YxnrT3UAnI=
Received: from DM6PR05MB6347.namprd05.prod.outlook.com (20.178.224.142) by
 DM6PR05MB6348.namprd05.prod.outlook.com (20.178.224.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.19; Mon, 14 Jan 2019 09:40:18 +0000
Received: from DM6PR05MB6347.namprd05.prod.outlook.com
 ([fe80::242a:b702:f98c:1dea]) by DM6PR05MB6347.namprd05.prod.outlook.com
 ([fe80::242a:b702:f98c:1dea%3]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:18 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5838.namprd05.prod.outlook.com (20.177.255.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:35 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:35 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 1/9] qtnfmac: support EBUSY errcode for QLINK protocol
Thread-Topic: [PATCH v2 1/9] qtnfmac: support EBUSY errcode for QLINK protocol
Thread-Index: AQHUq+0PmRF9JBFGAkmISTg5fGADuA==
Date:   Mon, 14 Jan 2019 09:39:35 +0000
Message-ID: <20190114093925.9061-2-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB6348;6:ZSrkVDAtofzQHu6mgk7j54Zf4W7xsjDqUK5huugpJuXCclC4yNxXnglRi/AsuU0SAStjkSYXIUUb+NDxJcLGX7tUEY/mnNt0bvEek3fkm5IyIEpmveup+xYh9dPrp/T4TXuLyIDceGl8nH4HE8vVSIAcqnZrS1Da7ja/1hliLuEel8PeAfTEMH9yWLK58kviQzgD/zcBACV2ECvC0g07KCHb6vQoBxt4BU9+N5cQ2RLn08Re7SDTiZOn0+Tw9EIEKmQ9uLyxOTIf4ZaQG+DvLlXojD6wAIWAACNFNp58bExqFWj32kLUPHDFUS3jyA+8w2bDzpmLlvzspBg2o+Ru8U0aSqLpgb0/hJ9hOJUo3a1Fx+saM85BB9yFKzlnQ3i1hdZ1u1w3u/lk8LqiO0XyTVGTZb/G1mnZPLtjmwGBkhdV5iRKFrYyIW4MKa824FJqjwt4SmkX5X4CAAFwqMB5zA==;5:I8VitrmmLiS02XrOkBBhxOEkk6tRNeySqHy8ev3cQr0uNTlYdlESmJBTSkBLWOd1+URjyQOriPnRHT1FMfrN+f+GfMYT4UDhbEd/sP57LtvJ33YEqxSYq+sl8WochaWhpmBitwPjjJKMMBGPi+774U8mnclvAPfpMK1/9LYyXiC8gnPaGjrmLW5b4E+f0mZYV7KWoCQT/1MYM9MIMXrB2A==;7:CDfkI7rVmqWv3fzsQH2+EYgXl0LFjHdMlEWsz3367xT1d7l7cOeoF1WQyZifJOedle//hEUS/tkJZjZxkUMijefxJb9IamUmLNOs/E7PZN+uJdCanp0+s2EUGasGZoYKUFuwwgNkYmT7ZicLQJijyg==
x-ms-office365-filtering-correlation-id: 64f696c5-df7c-4f13-c37f-08d67a043162
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5838;
x-ms-traffictypediagnostic: SN6PR05MB5838:|DM6PR05MB6348:
x-moderation-data: 1/14/2019 9:40:16 AM
x-microsoft-antispam-prvs: <DM6PR05MB63483DA7143BFEEBA57470BCA3800@DM6PR05MB6348.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(396003)(366004)(376002)(346002)(136003)(189003)(199004)(107886003)(316002)(6512007)(103116003)(3846002)(53936002)(6916009)(6116002)(5660300001)(105586002)(106356001)(66066001)(7736002)(305945005)(2351001)(68736007)(2501003)(2906002)(97736004)(8676002)(81156014)(81166006)(8936002)(436003)(25786009)(6486002)(71190400001)(446003)(71200400001)(5640700003)(11346002)(2616005)(6436002)(76176011)(52116002)(99286004)(86362001)(186003)(14454004)(478600001)(36756003)(1076003)(54906003)(256004)(102836004)(4326008)(486006)(6506007)(26005)(476003)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6348;H:DM6PR05MB6347.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cKWy9gsUJFDG3ye4swvq1jYFA3clFFI+YV+eg2D/bdbDtaS+Gc554fmrO+j7aN89dY2PY5cxx0U5N8pjANriGg7CWfQtoC3tkXCcFp3oizBJxC6P4GDVhRgWI+2jM3Qw2xcKGTgbMx25NXAFEbDylnzrx+eeQNqatehSten0BDLAa784PfnparG5dSHJr9wepChJvVrwmRA02CREZuW68k8HwmLzbN/aHvD5IQw+HJ2tAOuSlevYkzzOBCs0Es5N6vd0caQ73cA4ERxvl6WC5uNl0XpWhQ+3Q5L3jDu+EG7tdWapu8HVBc+2V4h2MpyMGlVYJ2GhVubSkvOGtaTF+InYIkVJU7iGfuqyIBu/GFVHdf9FLSSK8VEFLHaAFXqSjTHRRaOp1yIWbvWoLRr+ogZbdMcXNz7cN3QP4W3OFyM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f696c5-df7c-4f13-c37f-08d67a043162
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:18.7322
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6348
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

