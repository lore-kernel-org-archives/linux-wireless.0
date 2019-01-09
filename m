Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF26AC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0093206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="sIeim4uz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732703AbfAIQST (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:18:19 -0500
Received: from mail-eopbgr750042.outbound.protection.outlook.com ([40.107.75.42]:34736
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732683AbfAIQSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAlhlCgS0POEW2tI3EHE7ZUr4rcC8zREazI/E0ILplc=;
 b=sIeim4uzzkfXcwg61JgdDAZ/YtzpI3Q4ORTIWWmio6+1eJFcB/mM/aKW8FpuRePxclRyv5d9VxxtVyvlK2wi0GdSLZvtpDyKGYNZT5z/QOb4DEMdcNd8ZmeCeL8Rm1GjvWxRo/4DjBKAu7exM/BRAEbE+DzdaZ35GNRcKKKEBJE=
Received: from SN6PR05MB5326.namprd05.prod.outlook.com (52.135.111.214) by
 SN6PR05MB5149.namprd05.prod.outlook.com (20.177.252.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.10; Wed, 9 Jan 2019 16:18:14 +0000
Received: from SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::2d1b:782b:7272:fdcf]) by SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::2d1b:782b:7272:fdcf%5]) with mapi id 15.20.1516.015; Wed, 9 Jan 2019
 16:18:14 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:08:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:08:56 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/7] qtnfmac: fix legacy PCIe interrupt handling
Thread-Topic: [PATCH 2/7] qtnfmac: fix legacy PCIe interrupt handling
Thread-Index: AQHUqDWfiDp1OdNqK0+HLaH82JeJ1Q==
Date:   Wed, 9 Jan 2019 16:08:56 +0000
Message-ID: <20190109160843.14832-3-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;SN6PR05MB5149;6:5nmzEwvyqGsl9MfqiqumwYyCNrFb2anKN3jgf+yWgzSGIpc+yKRIVy1ajFlqRdcOiiWVRRus+ewidk0EAwVsA524+tqxa6VD285v7ky3tASyfpFBxaAn8K5U6BvkxVBGZYkzulBNnqCO5RDrQIkzyfm1yw7N3dJQrHUCszi/fRMCpa96rxEnzAU3cSjk59WDxpE8cy373uvQIDgILwl8ejXiF6ycaESpj6o5HCAqJ2I8irMZDGJhJG8zzrVBee3IwPedFxWDpA54JtZr/yzOvOWELOGSkoLaHbGWbNcQFQllCitPe1RYxWWyr7JPsH4a+tjWRT+FJPWY0DgAcgJyUER+qbU8sxgq/bQM7TBncuFPR2v/VJWbGPuLGElB2ZBQVrWdJkhYVy7vGUNlcdFmkeeHnZfbJ3cIc29X7tnDv3CUjpCfWFVimJPkSDxLmkCvSlKo6HuiYcm96qJXMW0/4Q==;5:vuN0avvvyJcDhtrSCschHqzD4yaCKWLf6cY86CqCzoVCkNxQDqonaAY1kh84CofZuiiHla7SVYDDOc1pJ/bYBhUxNUdzey61rDWU15TbZLQenHTnRevNqpX1mYrZVzEgi1sutdY71js04D3xFWdwLv2qFfVBxyW83eONruuGfsppnB/ViU1Usw+SVc5d2KQBM7Je/JRj12hGrTwqc4Agwg==;7:0Foyd7Ir5IBxRkN8BSWrvqJRWX5rzYPsFU8LYpUjx17U33CXF0aUEEkmNlhkyuFriJ27hMA5y1Km9dS/2Ll3pX55keZ3zkPFUOOogcTK+WFoipEPL8WPICSLn5iXWXQkhsOdkDA5tWXC6mnrDyIUCw==
x-ms-office365-filtering-correlation-id: 23f63de0-3487-4167-6e32-08d6764cc1ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|SN6PR05MB5149:
x-moderation-data: 1/9/2019 4:18:12 PM
x-microsoft-antispam-prvs: <SN6PR05MB5149700F014C7E69D2237C2FA38B0@SN6PR05MB5149.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39850400004)(366004)(136003)(189003)(199004)(6436002)(6916009)(11346002)(6512007)(2906002)(106356001)(105586002)(81156014)(81166006)(8676002)(54906003)(86362001)(4326008)(256004)(102836004)(99286004)(68736007)(6486002)(8936002)(7736002)(3846002)(2351001)(107886003)(316002)(6116002)(446003)(36756003)(5640700003)(53936002)(476003)(103116003)(25786009)(486006)(97736004)(14454004)(1076003)(52116002)(66066001)(478600001)(386003)(2501003)(26005)(436003)(6506007)(76176011)(6346003)(2616005)(71190400001)(305945005)(5660300001)(186003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5149;H:SN6PR05MB5326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RHiBG8u9ooApZXPCwLwSjTIA02xLpTST1rRFC/cXzynxK7MYr0lby63w+8TtbYZmGnu6HIsB0plyG/pRNxkwzD8pu8CrtooBf/v/25a1cdVMAf3ac7B3oyC4i0ZtCaReOwtXWFKbYUlfm3bpmg7VPfQC8LEH9XSUHt2OBJRTW1Qv7v6kIyGuvZgYEs6HBvA5NnJnwLGBPLqNbL1qpUqkLtb+357Em3lXg+hMpZCt/CBXzKSVedC9+qm5OmnWaW3MsljPXzotG2PLOACXcO2z3oTuLqF5xHDOXIbyngbn73/KhY9KTMAhJ66MAXkQAaEk
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f63de0-3487-4167-6e32-08d6764cc1ce
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:18:14.1638
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5149
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the current implementation INTx interrupt is deasserted after the
control path processing. However this leads to missed interrupts
from the wireless card. For instance, this may happen as a result
of control path activity, when another interrupt arrives before
INTx is deasserted.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index 598edb814421..cbcda57105f3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -559,6 +559,9 @@ static irqreturn_t qtnf_pcie_topaz_interrupt(int irq, v=
oid *data)
 	if (!priv->msi_enabled && !qtnf_topaz_intx_asserted(ts))
 		return IRQ_NONE;
=20
+	if (!priv->msi_enabled)
+		qtnf_deassert_intx(ts);
+
 	priv->pcie_irq_count++;
=20
 	qtnf_shm_ipc_irq_handler(&priv->shm_ipc_ep_in);
@@ -571,9 +574,6 @@ static irqreturn_t qtnf_pcie_topaz_interrupt(int irq, v=
oid *data)
=20
 	tasklet_hi_schedule(&priv->reclaim_tq);
=20
-	if (!priv->msi_enabled)
-		qtnf_deassert_intx(ts);
-
 	return IRQ_HANDLED;
 }
=20
--=20
2.11.0

