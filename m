Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056C2C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B262081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="iUb/hMGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfBEHPp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:45 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40017 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfBEHPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:44 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="25864245"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 05 Feb 2019 00:15:43 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z96Q4nbyeiUbKc7ZDmGyrWqQr36PYnqfQ8P2r7fNAm0=;
 b=iUb/hMGOa61jHrOQzWR7ptfG9D8iv2oiveZz/jxYNqZwUMpBywxQb0LD3DSHtJeWNM1TlSmiPOD+l+sZMSyqJGFzSuUITkw/cCUTc4NFarP2ao5m9ChBREvjF/10X0CqXqNkHc9OAU/q6dOVmnL4/yXrQaPeZGdODmhb6W8sj9c=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:42 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:42 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/12] staging: wilc1000: use random number for cookie instead
 of pointer
Thread-Topic: [PATCH 04/12] staging: wilc1000: use random number for cookie
 instead of pointer
Thread-Index: AQHUvSKaS6hHkVYN8km/dpl7QS87GA==
Date:   Tue, 5 Feb 2019 07:15:42 +0000
Message-ID: <1549350913-645-5-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:M6GzKijTA9GmsYlGXYBq201gcfjcqz5i8JtgBmuOj5m+yRoWMaPIlsnVF4+L4qheSOoxoP3Kbf6tXCrcpcAyhB7abxiY0qUKF4uIJaVwXg7gR6qk8P7pItWsyYKjJ4i7QtDDcsZLR0X4o2V1cHPz/8fiM6mRJzm+0/YmIs3SSVmcPU+nKeYg6hbacIqmKNKYw72tYDaV8zr4BeDGLIPpUj0JKkUjEXVCNu6RGvXQpBDJJyOSAvCYaWx9n3Pnw1oftAhalnF48t+9nqauT08S8xgbPnkQ1A2NJuywLTS3LLrgzmh/9rQIR50MFMnkE6bnA6oEgpmzBHiiu2tFpRYH+b/8DZlcDHn40qBPkFEsmKNuIZhqnNDn2VkedM7WuDAlwfj0nXRsglhCMzqNK4BCjocSsjKMypZvRBvO+SO12PhWsBvS5520tHoMuXNnmkujpC2o3CcR4ToVr/iXkYw7QA==;5:CGjGEjGH303V/0vpT6kPr30OZCYqknNImviI5SlMVOMQIUFkbYhvimq6BGK1dMHf2sZTJKXQJfiICUnC69oOtcBgy7ypdMgwNVTgBdWCfKxnY3Q0DF+ZZT4h8lN2m1AxTUlpYT3oVL4c5iGKVzB4NADA5tr9WoE9t1rBdmoHUj3iVI04ebaj+rNW68yBVksAtCyOYeOMFGgdxO+y6zfT/g==;7:A2WA+RQ7HqbAvNvNMdRASdjP2q+3AuCok7MBz9wBeNp4/edzZIj1sfiv168Qo7J2XNpJEath+pfOD7oanR28fMCZ7kN2NQ0s+G14qYjSmzoNtCOwNFzumTVMqr7KdZgpViuhHD1K17ncX+WjBTenkQ==
x-ms-office365-filtering-correlation-id: d702bcee-bddf-4aab-2944-08d68b39bcc0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB298221C04AD40ABF084AA1EFE36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(4744005)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xFXDPA6VNtzNQ6GDD3k94IehhWctQwbutSJvi+2+4jbVBVka7AWsvoBrEkRbVgGTtnlDpYRaLNG0KHoUiw4FlIBZLysADlsdvsdx9Jtvqe/wiMAP5uWHXEqrc6g0oyOOuuIrRpQGFZG1txtzfHTH4LDxx6UjNPI4kFFhoZAzbjRXuhVDYHGKvzFEwybLpShXvRx6iKCe5SbOzQdFjNn1g53g0uuAuD7BHjbmJwousK3p28+HuYmRhDrUsfFFklbS1VfdM0pk1o6pALNJwmTCdUAdswClDznz6jn83uMIglsktErzQsKSHQypVfaUTbUqRRm2yg/QEZSNdH8UDa7huMw0lx+WPs381FUA+2zi9jzWT1hgp0QQgjl/0T7cp//B6jdV1vYmUsBT7XzceGUkx+6qU/E+szH/LU/SLuKuMdY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d702bcee-bddf-4aab-2944-08d68b39bcc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:39.7098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2982
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

