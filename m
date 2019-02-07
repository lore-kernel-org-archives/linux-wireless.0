Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A9AC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335B42075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YVwHoVaa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfBGHWY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:24 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26476 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGHWY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:24 -0500
X-IronPort-AV: E=Sophos;i="5.58,342,1544511600"; 
   d="scan'208";a="26238598"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:23 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjcfACrWn7JdOdFv22iPruF8IolT/3cXElYMoZ6cAUA=;
 b=YVwHoVaaqjusjN1BBorGPl8zS5ouLT/kDEziClmMUR8fvz4Q8d1C6fz05nOlgMxpNPFSiur+24+EPmBPS7dHbPReoio3zR1VwLZaPPThIt1/iGBrUbukUrDqCmAuvRtbi8ayL5H/angbaikVjtzgP7+Msohi3q28H7dZ2LS01iQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:21 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:21 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Thread-Topic: [PATCH 1/9] staging: wilc1000: revert fix related to vif index
Thread-Index: AQHUvrXdfdwvmGoLAEustPic2coPHQ==
Date:   Thu, 7 Feb 2019 07:22:21 +0000
Message-ID: <1549519927-2651-2-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:MiyZ/mIMz5VDQ0JsBt9uZw1S3mSHITqMgYiWkSklpjr5p6e+FqIvwDu0aB+vw6f3JZ7FFabxRyGylLlpVRfLHQSendASpabmKfZbOmBz4wLCy4i8gW7XwTdavy3EhttIc+oAIhQASMS1EnfSpw021HQCMGlSeUSFdHuNMQAZh6QV6PLSZwudxb2oZg8ZuECzLindnnKLcLbOo6EF45ClVaWp4hzA6wq9PbWArF2ZxdO7eutU9z1XnYIYrql+ZVOT6NAiLiZfayVbp1tK00thUQ0e5M/7pEVZsgrYofEYg6Rm4kq70dR4LkhTZvrqBCeaC9eiAy/JCd4f4OrzcDbkevbnl/OtYPE2gpHUIb/gRoHYTlbKYfWedrnQLO9Si/aQ9LF1R4uQZRlf/Oh9tQ4CSme0+legMYtPnrfLEw1lQvAsyLN3mAthN1yhSO2XjSxyI/tN8s9413pZU46bin+eZA==;5:QYTVUidkpH41KNr3z3/LcvjuDoFnStILbKsW/w0sHSUguTWchvvi80wxd1PcCDbBFDU/tJUVVM4i7xaS4FT3QfIaW7I72q/MuamF4Yj9PDoAlwOKzAli1bBM/Q0GMY0W+yF0h+ibMhDMc30O4V8xHAKjDKF19UvdxKDMN3br+U0dYhgT9/Dl2Iab+ih0Y6hyO2LVBysROc8ifcJKegenTg==;7:Wn/ieZAGqpcuUpFXPVzgzH8ZBJzr2VjuNFfY0cOyAZiC2DHwgPqKz+8VNIbDDHTkcJp7+aFEn56EpsvLrZhGp7Z2hP2/QLclrICLpgL5o9GJue6B/C9Cp6T1BrkEzGTNjm1Dk3jWvq/K77UnDEgbFg==
x-ms-office365-filtering-correlation-id: a436d0c0-050e-4858-9042-08d68cccff89
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB3415E49AB1DE0CC24CA489E9E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(52116002)(50226002)(53936002)(256004)(6916009)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HliQEl4pI6steCJl6YmnGtdyIIAbnhgD3t+QR8B1BSnZf75uMrJHauLEaz5s5QFVDyCbxWl6yfe6paAYJTdskgVUmmmZ0+p61rI0GK5/UPR8k+3H3cVc9jWFSZLLLLZJekz95K21uZD1p6oqEeGWJg/+W+HF7jPJ6nH2xhAiV7w6/Hgn8ctzyjDeu0eVnwJAwtB1GIhI2uWO83RghX/n4T2pY82x+fgNRGtdUmjtHngMiAN6kObMtkF+mwKhc/b7lGvauQn74O7nYjNg+orLiWXR9JxJUTH48Eb6uamTuwZkmBXro+7zd4ThayJmWZzaLqILkOSOgMvOT9vtUldH8VhcQMxjk8j1c1HrXSkL+tJV5/tV9+Hd7UkodhvvyqbpLUeyH5GU48o7IZLqvcUN9kKjpdhf+IxBlMidmRyr4k4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a436d0c0-050e-4858-9042-08d68cccff89
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:18.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

This patch reverts 0e490657c721 ("staging: wilc1000: Fix problem with
wrong vif index") commit.

The issue was not completely fixed with the above commit.
After 'for' loop completion, '->idx' value is correct but '->vif_num'
still contains incorrect interface count.

Fixes: 0e490657c721 ("staging: wilc1000: Fix problem with wrong vif index")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index f096f9e..648b658 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1017,12 +1017,11 @@ int wilc_netdev_init(struct wilc **wilc, struct dev=
ice *dev, int io_type,
 			strcpy(ndev->name, "p2p%d");
 			vif->ifc_id =3D 0;
 		}
+		vif->idx =3D wl->vif_num;
 		vif->wilc =3D *wilc;
 		vif->ndev =3D ndev;
 		wl->vif[i] =3D vif;
 		wl->vif_num =3D i;
-		vif->idx =3D wl->vif_num;
-
 		ndev->netdev_ops =3D &wilc_netdev_ops;
=20
 		wdev =3D wilc_create_wiphy(ndev, dev);
--=20
2.7.4

