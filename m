Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73565C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383902089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Ic6F0XVM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 383902089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbeJBQIZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:25 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbeJBQIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtJNtii34ZuJVEMEiHis1hfOgzYteHUaD4WOQk8CioA=;
 b=Ic6F0XVMvjf25LGA6elNDsgKb/LzXEiA4XzQlmpkNWZOD1zkoOydir4hKyg63K+sYNnuTfUdA+vvPOk27elPjdy2z1KZ587aAEZ7aFUJnobjRLJgXCvchYYeVN1Il/Y7JT2BG7MbyKhx1lWfNUtILEOdhigpqTnCEHfrW/wfnyI=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:26:03 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:03 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 07/13] qtnfmac: pass sgi rate info flag to wireless core
Thread-Topic: [PATCH 07/13] qtnfmac: pass sgi rate info flag to wireless core
Thread-Index: AQHUWjHwedxbihpVDU6MrFDz+9egeg==
Date:   Tue, 2 Oct 2018 09:26:02 +0000
Message-ID: <20181002092542.18966-8-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:3qR92lLQQaYj2U+M3AdQ/4g1RGJLdjv4Nnf3JUMw0RPm/HY6oxzwJoZOe6s+VM6kpgeSA3nmhw4U7fDQLK2yoA//vly6VQ5+k+XeF8b4GTmvcZ//k4pOCgeFvwaPh6tGWlI9CWPp8JENGfUmyNsv3isiof+nLt5qBfAPxBCxAXM4Z7YVm5yqayXxUw5kuxYua3OGV9vqNKXkoLWhZ4wTgsYENtvZq2fhkoGgrdGIrzi7GcA0yqYOT5VGeEKEwBt5z6PZjHrq6xs/5wPZ68yOwSRiqoLcvhYIyCJj7Hemj7KDuRZbOv1pAvH2sslOMmymqdLdbU+VB3gYqgHEeFANe+bVatZZYQzKK/zHY9eVAeR4GxykAOA280EAzl9JYOqRECZs0t28Cd9INpKlP4pupdKxA+IlyACaV4/b0k00itxZEAu6JvHHWi7o5ko11k7v8DiC+Nsdn3mxwFbNveDujw==;5:XwGTj9iBCkBquAc+xGCMTG1+HGpwnQiTRFDwqcl6vOIlu+d82L4XeTcO4NccOKh4hBnQpxAx39XKee5NVw9Z8c03m5JgCECdAayNBuw5M0rICHNuAJ8U0Kd6zIzMR+q/sg0D5ihnqNCxj5JIhUBnxFXxY5cwLAkNRdM+USCnnbI=;7:8U77/p3T3OK5DJZZkWVVNtCafOTP5u4XrMlZtc8U3Tyi2oa49X3naK6Q4Wl/dCFvRGPnidriBsRxgzuGzRMGnX8zpufgCR5sa9cFuvWws+EiFTQiDaRQLPY89ehbDed3d+KjMdqIvQcXRgkh+8QtBxkwticGgUz/8sISqzkctau+b8BLCGHrIn+iuwaXL+1+w3s0DWrd+MOHKRgn74ay6FvFnjLsqNZYVdEU9BEcJaoKRNd54FROKnlbm9hOqjT1
x-ms-office365-filtering-correlation-id: 0ab01d7d-e601-455d-8438-08d628491253
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB50928D294C0C63B1370EFABCA3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(54906003)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(575784001)(8676002)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(76176011)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(446003)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(11346002)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: kJE30anWJiHKbSkq8wI/AULauFBjbXglWQK61TKT26CklCRJ6/VXBr4/qhadxVbXLO1V5gwvdKwvAyrUnEmmt6wFu6xtCLKFBq70BkQzF9JLYwbY+hmNE3CmToqtk0sHRlntbf1uvQi+3r/g6X9unky5t45i0pp7CZsFmwY2VraQRzkBMICJtY7SlWd9E1qhrxkLw03BZ11extpNkkKfYxp0zzreJAgSmnsc6rn5uuZlrwaA8anB4RboYzpFJ2i6JXrQgDMCKc1Ps8kgx1ImsVEVUm0q6dRcWX2GGc6GUywNFkcdiwCAImJUyP+xqeD+lGrDDuoERZ8BR5QyBsTeJNjOnGOyn2SJUq4K4fjDZbk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab01d7d-e601-455d-8438-08d628491253
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:02.8733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
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

