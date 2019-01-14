Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3149BC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37F720659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="CuE5fdhJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfANJkg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:36 -0500
Received: from mail-eopbgr730065.outbound.protection.outlook.com ([40.107.73.65]:18944
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbfANJkf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu2gT5MdPwJszjH78lhun6kjZQjTZJCXGV3b/NvrdxI=;
 b=CuE5fdhJvQfgSuxZHWJo0DCdaKX3+jU+ijkgpYuPuY6PCFl0Si0T9EUcUYBPIWUX+ng85x5tXkSsNcy/AQjADecTaUgzCWRK+13741PyfY2VXkyikagQFMxB2xF6I1NzYEg1SVR9tQmeqC1QJdqNbWjFWLpuxKK/RU50Dq8Tg40=
Received: from BL0PR05MB5124.namprd05.prod.outlook.com (20.177.241.219) by
 BL0PR05MB5572.namprd05.prod.outlook.com (10.167.240.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:40:25 +0000
Received: from BL0PR05MB5124.namprd05.prod.outlook.com
 ([fe80::7d09:3e9b:cc44:74eb]) by BL0PR05MB5124.namprd05.prod.outlook.com
 ([fe80::7d09:3e9b:cc44:74eb%5]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:25 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5838.namprd05.prod.outlook.com (20.177.255.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:37 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:37 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 2/9] qtnfmac: fix INTx interrupt handling
Thread-Topic: [PATCH v2 2/9] qtnfmac: fix INTx interrupt handling
Thread-Index: AQHUq+0QOFED6no0FUSLhZdFY0oslw==
Date:   Mon, 14 Jan 2019 09:39:36 +0000
Message-ID: <20190114093925.9061-3-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5572;6:bGkZQkwqPVT1rO+nD/U9n85EqwEh6vVPfpma1NiX6jVIrNldLuZPvNYLjaU50x64y2dq4Yvq/d0MM4vFVL2yM8MwlcXayofJDa5Ofqf7b4pL+7/y5/PBlT7G5I9jsde+nPpFsUnsG0MGEcrQGksUt6wsP3QrpbJYIK7Q92zuU/A/+nPnMraXOflxbqjrdF8jDazqwpAZA4mqzhSVUXSMONTbkueY6QApVN7YTfaGR0j1YSKyzyaiibn/sq39ss8s3x0SP0FNTPSWKcpJNkUUBNu5GkTN0++Y9+limhI0b6QU8axwauzZNoiwAtlQN1iNSbtMjKdxl9tFNtRLw+mxVSly+UM29hKXOVzRKHds2y5LvfQGq2c0zRfsrgH+UxN7GD7+Qb2FtHpxJJDaNHVfqlVnFEtDnWAZcbd15qkzjrym49ycjtRvPDQNK1NxRgW8Ogtb1GU+WO5YbSMY1Qy+gw==;5:07nx6vSZGRg51agJJgVwzKqOMR9/IgOZKgX/EWC+iVXs5SxeObzcTW/rHK1pPF/Da1JLrWsVmU20tq3xnniPPa4rPGOtbIOOheT1IpRoR7KstxDWZAAIvrhxjPlqh5EF7UAxtwQ0/TRPerpyMsPq0GnoOUrGLVsl1SJdnRgeGvkxinbMX9H0pzPy5DkAjojaUNmGEKVHMsxkpEAluHtEQw==;7:6n86QMcr/5dGVpHod39QJNUp0M3auMqIjS+p/BSI25F5xShBwWbppygCTV7VTYrin74YHuqx6A/9x2Mwas3ojQvIKgBmO5CZadhwnwTcAMCrxd5KB1uG+RkSevSj/OtxrDQ1+WLeEnUMekjABsCN3w==
x-ms-office365-filtering-correlation-id: c2dcfc56-f2e1-461c-6dd0-08d67a043284
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5838;
x-ms-traffictypediagnostic: SN6PR05MB5838:|BL0PR05MB5572:
x-moderation-data: 1/14/2019 9:40:23 AM
x-microsoft-antispam-prvs: <BL0PR05MB5572BB09316BB4DE5ECA4D36A3800@BL0PR05MB5572.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(199004)(189003)(105586002)(106356001)(2906002)(2351001)(6116002)(3846002)(36756003)(1076003)(498600001)(86362001)(14454004)(6916009)(103116003)(71200400001)(71190400001)(5640700003)(6486002)(6436002)(66066001)(5660300001)(26005)(186003)(97736004)(68736007)(7736002)(81156014)(8936002)(81166006)(11346002)(476003)(436003)(446003)(99286004)(2501003)(486006)(52116002)(305945005)(76176011)(256004)(107886003)(4326008)(6512007)(102836004)(386003)(6506007)(53936002)(25786009)(2616005)(8676002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5572;H:BL0PR05MB5124.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kLHkoQtwEb9sTYt82zbXAePx7WylIRRIPXHxvUsE+pWZIqbTou9ZFe2BhDIyhnzPlYGZV81e57nORl5N0Qx324fCIbduDp9cIkZaohMf9WdZkHMS8NLx4+jV6WeYrbIfH8q64l914hLAJa0cnErql/Roh0fOVx1rpPNKO9AkBaVWTAbSVxF0OJWOl2lTl8kQbNul5QzKHsEPeRpy2FBxw424rxUPPtFI+1h17KTEufWZ6gl1uBzmd6LiVCYu4NWlVfmekLaBABnSfTyeZRx8RI0ASAThm0WsaoeYOSaCac7BX6o6o5QNSG6Noadvp19w8CbCJUoRc8TfFFAfJRlBHVUQDs5mnhzyqpsaEZkEOFd6YZOx9KAMQX8rrax8CvsOuyxcpxM+bRi8VqOBbmBrW0OCo/b3JNzomoBqBqYBSLY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dcfc56-f2e1-461c-6dd0-08d67a043284
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:25.7398
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5572
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the current implementation INTx interrupt is deasserted after the
control path processing. However this may lead to missed interrupts
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

