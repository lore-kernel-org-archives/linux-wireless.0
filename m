Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6EFECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 15:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0B02083A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 15:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="eI4D1uFN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C0B02083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbeJSXqx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 19:46:53 -0400
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:52496
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbeJSXqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 19:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QO/2cAVziQjEA/i34dTBouBg/pNCZ78q0qweA6tQxQ0=;
 b=eI4D1uFNnFsOAZ06qKPQSElBprLqfmqxTGlRig8ngTReh7R55uJQ5+7Ua5w4Qr3OIrsb0VF9VpY7XDI/h4deoYuMvZ0oXDOH2RkbEzLG40XclUJAmUAkuDvQGRS9/K4H8HG5j8ggOpd8OH8GMj0ecwFN+uzX3Swmj0RMQdwOtIg=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5521.namprd05.prod.outlook.com (10.167.240.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.15; Fri, 19 Oct 2018 15:40:13 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.024; Fri, 19 Oct 2018
 15:40:13 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] cfg80211: add missing constraint for user-supplied VHT mask
Thread-Topic: [PATCH] cfg80211: add missing constraint for user-supplied VHT
 mask
Thread-Index: AQHUZ8IGxYW3SrqcDkWpp9zdv5cJ5w==
Date:   Fri, 19 Oct 2018 15:40:13 +0000
Message-ID: <20181019154004.28003-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0601CA0034.eurprd06.prod.outlook.com
 (2603:10a6:203:68::20) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5521;6:W5ql3sx5+QVaEq6y+BV27P0CT4AimG43vabnyThy1LovImunrDVsPQmWIf4BIadhK+2l7FasE2qbIMjEiHlbHwxLOAHsUuF2p5aHXmhqJy908iJWNydoJ3RJVV3Kefwow6avvYh8hbgbc6l+XtS9rSxR8EJ9wrd3kTRlkF4CfYRoBY9vpHiesKQ1lKqEn+FlQxImyCpRa+Xq+gSMmEmEZ+nlbEupXfvaNyVu8NFCmIrws0MfJRHthO/SuSEXsGUyOpc0cyCsksBnrAYjtY1Af8no8Gj8j+zdeeOjY45FKA18hEaF+fs9SZbRdusRkqrn7BVvFsF2GIk786NL7N/oakZz60zoerHujdC9L0YcKFQ0A7M1GYoi/D7sAEgUYsMnYeFuRkE2wZEi5TcDILhAHvgJ8zaJkAkz/vWMRXEDgqB8ljckf/9/HmDMg2Ky7o/TBtMiMdeAKHxwZKWKetwTCg==;5:Hhs0KPZw0LopLI+In6CMe8ZtmG6EWgVm4RwX7oFn9k0Nxtlp5+8r6QN6m1SKWD2w6Dm2YzzV95ySvO2n2MIuBXPxmHowDDl1TvSKcn7aGWzRFE00o8DtLZBPgIMS1oReG4AdjLM7T1hJvcIDRL+WeX94Zis+aUBmVlJnUeyHfI8=;7:PS83gNPutenUAj1WezV0S2HqCSLz4g1VNz95U/GR92nD4EzdHRvjuc2+yqVc/WAS8WK1iK5cZbjTGQ0X7MVYmb/GCr/wAjrS3DWQX0hrG6SasVh4NmhtOeSOLbDbmxZCbWnlJDOc9BzsOFsGvb1RhOsW/5FSfhopUptBVnvZ8mGTKvfTTPAg4QCS8AEMBfcYUnqRdwmnGBdog6mSZDoIBz/cevnnyOfkE2G4SFY04O2f35EkgrkAfbPvdeZAjHst
x-ms-office365-filtering-correlation-id: 5060eb11-52db-49c7-9506-08d635d92888
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5521;
x-ms-traffictypediagnostic: BL0PR05MB5521:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB5521FDBAD6C12501CDCE112CA3F90@BL0PR05MB5521.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5521;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5521;
x-forefront-prvs: 0830866D19
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39850400004)(346002)(376002)(199004)(189003)(106356001)(2501003)(1076002)(476003)(486006)(6512007)(6506007)(5660300001)(14454004)(99286004)(386003)(2900100001)(4326008)(68736007)(2616005)(81156014)(478600001)(5250100002)(81166006)(102836004)(6436002)(8936002)(316002)(6486002)(6116002)(3846002)(52116002)(186003)(26005)(107886003)(1857600001)(5640700003)(2351001)(25786009)(6916009)(8676002)(53936002)(256004)(66066001)(105586002)(2906002)(54906003)(305945005)(86362001)(7736002)(36756003)(71190400001)(103116003)(97736004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5521;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: z2RKPsqSV9Zw/pDszbKR+DIPviSpi0UgmROEp32pnxpNNxQDDRAx6ZNzXhOLQBOLaZ9nvSaLeA1A1Ahw0uOQor36Uyv1a1muW3vm9LEVWfDzFyARmNaDR4rFZguC0zzU3woU1L4aYCuWOAWVlwpyK8HJEZc71mGlBgXvr+WEKHAkqgoXq63kGZJQhhj25qROEO39Jm71aimh1L5m1sT5GiYAlZVC+JIMzMpclUWM4mztMa0kqJ0N0CSqAqU49UuENp3nWuZddjiZRZX8k3dPp25Y8thFQNmQGtKiAGv7hfO+0MFFhVgx9O2XvXIJwpbhZbR5EEDT7LzkqMhmE5V+edo+UV1z+vKqvGr0jKzQ0Nk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5060eb11-52db-49c7-9506-08d635d92888
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2018 15:40:13.2312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5521
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do a logical vht_capa &=3D vht_capa_mask of user-supplied VHT mask with
the driver-supplied mask of modifiable VHT capabilities.
Fix whitespaces and comment typos.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 net/wireless/mlme.c | 4 ++--
 net/wireless/sme.c  | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 12b3edf70a7b..1615e503f8e3 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -272,11 +272,11 @@ void cfg80211_oper_and_ht_capa(struct ieee80211_ht_ca=
p *ht_capa,
=20
 	p1 =3D (u8*)(ht_capa);
 	p2 =3D (u8*)(ht_capa_mask);
-	for (i =3D 0; i<sizeof(*ht_capa); i++)
+	for (i =3D 0; i < sizeof(*ht_capa); i++)
 		p1[i] &=3D p2[i];
 }
=20
-/*  Do a logical ht_capa &=3D ht_capa_mask.  */
+/*  Do a logical vht_capa &=3D vht_capa_mask.  */
 void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
 				const struct ieee80211_vht_cap *vht_capa_mask)
 {
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d536b07582f8..1c93412038dc 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1171,6 +1171,8 @@ int cfg80211_connect(struct cfg80211_registered_devic=
e *rdev,
=20
 	cfg80211_oper_and_ht_capa(&connect->ht_capa_mask,
 				  rdev->wiphy.ht_capa_mod_mask);
+	cfg80211_oper_and_vht_capa(&connect->vht_capa_mask,
+				   rdev->wiphy.vht_capa_mod_mask);
=20
 	if (connkeys && connkeys->def >=3D 0) {
 		int idx;
--=20
2.11.0

