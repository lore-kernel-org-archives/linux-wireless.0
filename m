Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE4C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAC520878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Xm2s5PJW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEAC520878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbeJBQIf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:35 -0400
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:22848
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbeJBQIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmjHCkuQzwD/ijy5/i2LA5UBofyW/RonqfieindctQM=;
 b=Xm2s5PJW9kt3zas4W+jhEHIatvpvcwOb4NQRHPLATRawR4flcSHG+bHE8ccUv/cRnLHexBt95FmFBZaUjbiaV6VVfa0EpLCRIPxAbM3RCzuULELldnS9SdqndvYuR4zegqC5szzRt5T/3IEE+eMqg+QmXlECltCkOnttLgP13h0=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4849.namprd05.prod.outlook.com (52.132.15.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.17; Tue, 2 Oct 2018 09:26:01 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:01 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 06/13] qtnfmac: do not cancel scan in disconnect callback
Thread-Topic: [PATCH 06/13] qtnfmac: do not cancel scan in disconnect callback
Thread-Index: AQHUWjHvo94LS9EzH0W6/hL9+E1P7w==
Date:   Tue, 2 Oct 2018 09:26:01 +0000
Message-ID: <20181002092542.18966-7-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4849;6:o7Xt8ZSSqKwLnkwFquU2iW7AhRGgXVCMKpEQdQNHU4mOP6ruxo3SbwqPILtPTuDlR5KitbA+cUXpxNFV3/tbUBnhtVrRasWCwBfSqYxh/b05d5AqM1X8eOzVvJRuvykCiUgUVoCYWKe/YgzogReLOSqDWF/eInpLCxRCOVo/WI7e6R8UCkoC7wjjfJNqOoykN2MZ9MLt+PD+Ja+Al+xEuId5wimfWJWnCIaTb1zpg7/VlHPhpltWzq+2ggMV7DIGUYHIOljB+8a5NdypjVgaU7340qDs27+VponYZxWJVMlSuspXFtTI+j0C5PtMNKe3GaAnT4ncAj16Mi3fX9E7pQ4I36GsFo8HX4egsI//8hSWXZir35TBQKdHzHaRCarQ9aVmA3QQISwHS6EtBtxwqRnGeGN3/YgU7rs9rYAxalqGFfy3rspq2/6+Y94agM0FqooRd9Q86jDXVtgqf3gi+A==;5:KTuDWjeeRLEI3li/VcOnLn8VZPArdFiuR3yFeBGf7GiqK84JPRRxjBTFeb+GfpPbjZspG03quyccW4kLqLVNFMUU5KMPq6YWqhwMPPy9rFab0jvNFBBpVfs5WPxXjlX7/y2rYcm8Q82TsXAKLFZGms6pQjPvkm8YuzjA5e91adA=;7:2NYrGa3m6CnJGHLNSLJiOYTNO+qz1XaDA1yHWS2yDCzu/rzZvBnOoD1LmpsR3VLNv/9wxpssilnD6qWdf5MmfmJQ5+UJv2fEbccb47TvaPiGQV1sx/ampwYzxqAqSCWgjZIYnqMCG9qJcWMzk6tdniF6pRESSoHXq+0/LcmvvkwC0mXlcm3R2y/xV0fB2MqVeiPcJJADlncwR6Dm3GH2PUow5AXmSCGyceYapgdz6HCtCPMIr7mAER+5i5jJhnCg
x-ms-office365-filtering-correlation-id: 040233c0-ba96-4618-538f-08d628491196
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4849;
x-ms-traffictypediagnostic: BL0PR05MB4849:
x-microsoft-antispam-prvs: <BL0PR05MB4849D39169218CD9770524F9A3E80@BL0PR05MB4849.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB4849;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4849;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(39840400004)(136003)(396003)(366004)(199004)(189003)(11346002)(106356001)(14454004)(446003)(66066001)(486006)(5660300001)(6916009)(478600001)(2616005)(476003)(256004)(68736007)(105586002)(26005)(186003)(305945005)(103116003)(8936002)(102836004)(8676002)(81156014)(81166006)(316002)(6346003)(2906002)(7736002)(2351001)(25786009)(4326008)(36756003)(5640700003)(107886003)(86362001)(53936002)(6436002)(6486002)(99286004)(6512007)(97736004)(6506007)(52116002)(386003)(71200400001)(76176011)(2501003)(71190400001)(5250100002)(1076002)(3846002)(6116002)(2900100001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4849;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: EQEbvh0WJmE8fIjSpLuV0kVC5marGmKfag2vUzdiEkOPxTzIvav3F1V1t53V3o2Hm715/weUUV9RKcqsROHdcMhYM0rGH536ID/54Pazui23UP7U9yBkhDTvnQ6B0DUg5b32XnMh+U5z+EbAgtdn3t2HhKkrjkmClAVoS0RFS9jpyLe4h3NaW4AGk61UPXF4ONFeYomftFUTxosb69/VX+qKWUJgt/zosAKae0an5m0TFPNR3Z/pPzRTL22ynyWPVVyh1fgo8Op/nRIujCO91P/X/jHmgB68jagRxmMo/SNhZ0UOzgEj+Cm+MVK9envqAwvSivQHm4Sh0WvFHDmYQfP8Ixq87S1l9Bb90zPK3o4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040233c0-ba96-4618-538f-08d628491196
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:01.7045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4849
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Do not cancel scan in disconnect callback. If there is an active scan,
it will be cancelled by firmware, then host driver will be properly
notified by event.

Cancelling scan in disconnect callback occasionally may lead to the
following race issue. Host is able to queue one scan after scan
abort in disconnect callback, and another scan after scan abort
in event handler. As a result, firmware receives second scan
before the first scan completes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 4631277092bf..8b30d651cbe3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -666,8 +666,6 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device =
*dev,
 		goto out;
 	}
=20
-	qtnf_scan_done(mac, true);
-
 	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret)
 		pr_err("VIF%u.%u: failed to disconnect\n",
--=20
2.11.0

