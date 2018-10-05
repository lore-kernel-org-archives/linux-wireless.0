Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF476C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79E7A20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="cC1Kiilx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79E7A20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbeJERJo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:44 -0400
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:36694
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbeJERJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJNtii34ZuJVEMEiHis1hfOgzYteHUaD4WOQk8CioA=;
 b=cC1KiilxykvmrHCOMeJ7B5xV7muSVbM2uu4mQYheNNw0kKjnoqEYIZaZsC0B15eJQwOQwVWMDRFLnexFIAwOyCu4OopCzqjQesoUX4zXpLPLgJ4XaRtXAn9dcdxto8PJajfYe5PXfoSz8IVhMhWC5CU8TJQcLjmbK6e3z5s0Ftg=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB5110.namprd05.prod.outlook.com (20.177.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.14; Fri, 5 Oct 2018 10:11:37 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:37 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 07/13] qtnfmac: pass sgi rate info flag to wireless core
Thread-Topic: [PATCH v2 07/13] qtnfmac: pass sgi rate info flag to wireless
 core
Thread-Index: AQHUXJPMUjd3FKIZ6EuO9jkF2zJsAA==
Date:   Fri, 5 Oct 2018 10:11:36 +0000
Message-ID: <20181005101114.3013-8-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5110;6:ldyG5kBwIqs56zayXWYeyeb2c6XOkMbi8cm7pdTr6lbQBVNegha/VHG2O3Yp3BLSNAJal33yJ6E0/rSACaRREllieP54zYczQMH7kqguozr3XHxUXiKWk6Oxcnwmp39lFfpXyvyaEas3PW3h6+HVJfBfHMrpaGFUiQcIHdssjig/N1dUVqFe7pZARwYUOAETLI9d/mES0Vc2g35zbMriGyaO4p8wGy7gCrkXrt6tMg88uV9YyTzUWLkCsANkxEq2WV+ZUJkhxA1JrLqlui3pgocoMLPThqXk10qUTWdGmVJPSLfCNzKAyPhZ2kZuHyM6jGKb9lV0VSn1fCCi5WJfm0fkcDIi+V8kAhzqLio9big1JdQWMaZS+kTvFk7KUU11xwWBjvm3TKOUOeaVwq5tls/TLxBosyicLLXcJIluZEdb3nJst0ovnuP+egphyLdsMVFBOOypj25W+46BkxDrIQ==;5:qxZp7y/0lIU6ssiyHpUSN++A0BSGM8+nAMHIiqD4A31JnP9oyQttUjSlF1a0yFLQgae2G7uRsbFFOpnN9FPXWHbocCepqpV4RYzGajiDBKoWsTnFOgSCoJwiuwMMMLSN9j6cr9AbYPE50Wx+oZsyuL8biSLIdaurfF4a/Pz4N7c=;7:seWZWdO4/COXoPjjPYfqgoOp3mNnshYwTjgC9f0/LqAwRoFq8SEf4fB6D49mxbvcdCWvoxVqJFm9XSuGv1KVkSmdRvN7A+PJQrVecS0zcbqT9BbFkWxEYUGa2Aw+yrf3K31Qpx/UJg2aQTYrTN6lpJII+gZS12ECINqmeakhm6ps0idZN7ZUOpEB4YvFkL5ILNNZ7f5//gXurZJu7tBBIxochB+fCDTLfejr26k2b+MP4FoP55f4CFGQWBr+d646
x-ms-office365-filtering-correlation-id: 1341351b-5fa0-4478-5ff0-08d62aaaef2a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5110;
x-ms-traffictypediagnostic: BYAPR05MB5110:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BYAPR05MB51103EEF35AACAC14434B2C9A3EB0@BYAPR05MB5110.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991048);SRVR:BYAPR05MB5110;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB5110;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(136003)(39850400004)(366004)(199004)(189003)(52116002)(76176011)(11346002)(2900100001)(6916009)(2906002)(5640700003)(99286004)(478600001)(476003)(2616005)(5250100002)(8936002)(6512007)(6116002)(3846002)(68736007)(1076002)(53936002)(486006)(7736002)(305945005)(71200400001)(71190400001)(81166006)(81156014)(8676002)(103116003)(2501003)(86362001)(6486002)(102836004)(6506007)(386003)(36756003)(2351001)(14454004)(256004)(186003)(66066001)(26005)(106356001)(5660300001)(4326008)(107886003)(54906003)(446003)(97736004)(316002)(105586002)(6436002)(575784001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5110;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fOuY5rxC3gfP6TWNh9KM+Y+i5depn6Eoj+eSz7YPWvhljUos1KA6L169QNHUMpZHblHaqmJOkkGCsPK76bDvLNsOTck1f4SmgKZ3+0I+ukJKQshcWLQ5uYTb57sJdYIjiWiPEEG6vw+j+D8y3UvYpR1KkmW38ixfNrlLhnS1ouvawNt2uefeYfhPf+PJhpQOopV5MiaAv99TJlm34+vpVh3yu8aMS/cAbNRjpw3fUcelNnoCsdreyjwlUV7SaPbNkQAA7ooeT5BDukKOmHZH3KIfoHI/nmB1FXaplpVRU4WYbai7T3BycNbuTBKWJGz8pSwylIeGm+uXvb6mmMAFU1uSiIj4ib/3dkH9b9vstVI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1341351b-5fa0-4478-5ff0-08d62aaaef2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:36.8955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5110
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGI should be passed to wireless core as a part of rate structure.
Otherwise wireless core performs incorrect rate calculation when
SGI is enabled in hardware but not reported to host.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 63d93cf3ace0..74edb5a0ae19 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -498,6 +498,9 @@ qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
 		rate_dst->flags |=3D RATE_INFO_FLAGS_MCS;
 	else if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_VHT_MCS)
 		rate_dst->flags |=3D RATE_INFO_FLAGS_VHT_MCS;
+
+	if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_SHORT_GI)
+		rate_dst->flags |=3D RATE_INFO_FLAGS_SHORT_GI;
 }
=20
 static void
--=20
2.11.0

