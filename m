Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CC5C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C83432082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Y0l0Gyjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfBBTR2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:28 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:13192 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfBBTR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:27 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="24160779"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:28 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z96Q4nbyeiUbKc7ZDmGyrWqQr36PYnqfQ8P2r7fNAm0=;
 b=Y0l0Gyjx84eNOC96ncYC3lkCeVquQwIAYZp1KIWe+bIDyxyFd+ILaNEGKqBi5A7JuJrD8d57l22zlnKj2P+Cy0TQOiLSu8LOrlzgqnMiZ8J9D82FH3+g9t12zspLlSPOr+aHDYY3VwtcDxpgmb5XgwR+nesjZ+1DJD1JIQO7SUU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3638.namprd11.prod.outlook.com (20.178.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Sat, 2 Feb 2019 19:17:25 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:25 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 12/15] staging: wilc1000: use random number for cookie instead
 of pointer
Thread-Topic: [PATCH 12/15] staging: wilc1000: use random number for cookie
 instead of pointer
Thread-Index: AQHUuyvuUyuDXFekH0Km19Razzos3Q==
Date:   Sat, 2 Feb 2019 19:17:25 +0000
Message-ID: <1549134974-5545-13-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3638;6:49QCvn8orcRLjOgpyvw5TNmP3mLcDsJb0xdKc1/Cg/n1k/zxb70fc51iXKMAVW9VgHNkcYky5VaAASMdBrdrdXJ69bTKlO/9h9W+6gOWXhvBMko/U114SqoR6tfOhX67/lqE/GJAz8vTU4YpiMZm0IuxpZqX0Tg29hkVrrGG04TEzoYjb1F3wdb/5L5oDPY2smDyFyRq7ISpLFjLWVORQA7Z+GOOiLZwTHwTElKP/e3Suhe69NW9SETAj8u6fL7jMioP4gg78ETUyQ15ngFOudWCAVWibxFFBN44Wj7CH6uGYkEaqiDrbr1K3jMVKFup2tGE/IXwQkVcGRQsMlKC6dY87YA43O5bVVyAdoumJdPWvyExABz6SOJpGcJP6D5ZsX6iMF4wCtyTCCWWFgnkFIXOfMICjumgh642Uj0QYuTrN5+p0hc1GuygWABgYcd+adg/1CPKRqLY7F9VZOn4kA==;5:gS4fpURWqQY0wkmEbFaJEJvqwxi9YE3QQuHBy/Aw+c7y2o3SpyPaXW/ZcQviPvJhofJDM575HtrMQzg4eL1cue6Jz5hwDF9xeGZFegg9+5qHsc8bGJna8upOJp+6wVjt+kx94R3nlZZ8f3lIImynMthDcB1xYfgyDsCnXfsvrdvR1Ur5N7DTP66oPlfiEAYYlObVEVl/wSTJIVDC6Q3YiA==;7:c5PuCiOrS+zx8vfewn0XlUUyD2AM4Hj9YUdBESWllHKNWf+oSmuZadW6ly3NfvnfUINmlunJcrVYElRcJGQtwAobFHSUtFY/bnx0DpsVM/2EPPC1P72l1r7F6X4/xac98CuRuFSfm/7PZ25NJN1rsA==
x-ms-office365-filtering-correlation-id: c368110d-0681-4d10-d38a-08d68943105b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3638;
x-ms-traffictypediagnostic: BYAPR11MB3638:
x-microsoft-antispam-prvs: <BYAPR11MB36383C48763A849723334DCEE3930@BYAPR11MB3638.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(26005)(478600001)(7736002)(186003)(105586002)(106356001)(2351001)(476003)(6486002)(446003)(2616005)(486006)(6512007)(66066001)(11346002)(2906002)(14454004)(6436002)(72206003)(71200400001)(71190400001)(386003)(6506007)(5640700003)(2501003)(68736007)(3846002)(97736004)(102836004)(6916009)(36756003)(76176011)(78486014)(25786009)(107886003)(81156014)(81166006)(4326008)(86362001)(52116002)(53936002)(316002)(305945005)(14444005)(99286004)(256004)(8676002)(6116002)(8936002)(50226002)(54906003)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3638;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /lUmjShjolqbD6zpwBhN5pVR1douH43MgGAoQ0E+KtDKb20Ufbx6jPpQYSZiTTKY8bWvmzLDq/NtcmkBvcyt+y/RxS+MKRLAo9p5fHdeL5mk9H7+w3KftS/F6qDjobbJPIolvCMonNre7MHbhxbwPnd52uX9dvo/gME0VGTteeGjW7dlhHtbKB4gvHnNR2Ox+VFgpXJGNnTQed3rQMCLm0umOe3dOvhpuoogNPjqQ5sh+W1CE92lxq/jrgZ9/42vU/oTSRU94K3WX9osu9Y4rwP46wPggF5YMlh+OcWwrBdJA1dPENMjTrPvamTfYP4j9UQOWgjh8pgUxEXUKiA2mrWx9/VCvE6M8NGsWPBGFD+5hNdLtvpiaELCz06Ax1VkqzTUDOHpc/obj7Po/42atbP8vCxQLz52z4Hjx7Kngpg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c368110d-0681-4d10-d38a-08d68943105b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:22.6745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3638
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use random number to assign to cookie value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index f719b74..98121ec 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1252,7 +1252,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	u32 buf_len =3D len + sizeof(p2p_vendor_spec) + sizeof(priv->p2p.local_ra=
ndom);
 	int ret =3D 0;
=20
-	*cookie =3D (unsigned long)buf;
+	*cookie =3D prandom_u32();
 	priv->tx_cookie =3D *cookie;
 	mgmt =3D (const struct ieee80211_mgmt *)buf;
=20
--=20
2.7.4

