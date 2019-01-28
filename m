Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99E4C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 22:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92A6C2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 22:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="HpjFc0iT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfA1WiW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 17:38:22 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:61055 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfA1WiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 17:38:22 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539673200"; 
   d="scan'208";a="23948858"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 28 Jan 2019 15:38:22 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 28 Jan 2019 15:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pdDp4ESYLVtfEpmKFvsYFYyJ18aDzefw2SzFode9kw=;
 b=HpjFc0iTbffINa4/Z1rsJrd5NLaCxuxaDNh3Cg02rxWL6P75otvjjs3mhHUGQWp3h1pKHzbrxXLNnlIz0TnQeqRK3RL7Bq3x1BYRLey+5x05ho8WkN6LVWf6X9m0UKKmwdYJBSvi5cHtvw1nRv7BrURndtZMfNw29MVNi1TR+Jc=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1407.namprd11.prod.outlook.com (10.169.234.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Mon, 28 Jan 2019 22:38:20 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea%6]) with mapi id 15.20.1558.021; Mon, 28 Jan 2019
 22:38:20 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 1/1] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Topic: [PATCH 1/1] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Index: AQHUt1orshEXRJwd4U+dDCEbtFaKDw==
Date:   Mon, 28 Jan 2019 22:38:20 +0000
Message-ID: <20190128223111.19400-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:a03:54::15) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB1407;6:D4D2s8Ycn4ORjugZd5hVCuRkuYvNwr4xwuLPO/xIaKiQs1KoJOQriZ4Zi3H+fgzujyDab7sl7SGNyqd9YQlEIq0gsWnya0Xnglq3L9tIhjLOaTqI60TcRNhuHi9d/3Pv57p+NLEEEqvGZXJzsSkZwKtgWwy2nXXf+x6VPYfiZJQhhtskkYymGaaQIKkR4KpYHcoY0dohpfOLPUncoLJJJc1hoThXWkn5mXYAoixawQ++CkkgCFESFoAS1GfLbYy7wsvGmUhmmIuo4hOUt60MdQDEh4YFmvvHOogOuc8TOGw9jyYpa83WiizF0Q/UhuXMNQhV/WenuifciyB9mS5qfyv3BtatezbDBYjXDD5WI2MJ1kUVIMFyQFQVmYf7F8zYJ38zBPaFB+qGvywkBNlKoegeOaLupmcAkHsvHmb4mW7b6xpb18J4AVak0QHK5+ogwTPKw5CQzZmvKN8C0omKZg==;5:JfVZj8kw74GDelgFrjx6WDRz3a8JfL96DHa8y30dsnNW5CJ269+ePTgydS8Mcp3fl8NC8U6WCl8fdg7wURHQU2o7dGOVUmIl+fCAqiKsQUurhmDhnnodmFUxsLGjGG6Sa3fAVAfFt6pBxml3u716m9VRIM1HAw31SjMkKg248ePwdK3GvoiwkWBAspfMF0mxg6rC3qSaldPd2iAy8P/rdA==;7:49q9gNtPZ0geEdbYT3VlxWAipuAgDC9yiiRlNjqIcXXNI8UJWq5CG0Wi4Rmn6sa/Zs7bNThDI6P6SfBUQdrjFi6s+FNsaz9B5IL+dIuPUj5Od2bVBD0+NFUqWCoDj0IaRVotZOC8eWESagjN1IhuSw==
x-ms-office365-filtering-correlation-id: 9806197c-5cef-4a40-36ef-08d685714da2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1407;
x-ms-traffictypediagnostic: MWHPR11MB1407:
x-microsoft-antispam-prvs: <MWHPR11MB140747F9AC75DC0EE9FDA0748D960@MWHPR11MB1407.namprd11.prod.outlook.com>
x-forefront-prvs: 0931CB1479
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(1076003)(256004)(71200400001)(71190400001)(2501003)(36756003)(316002)(6436002)(476003)(2616005)(99286004)(72206003)(14454004)(52116002)(66066001)(478600001)(97736004)(486006)(105586002)(5640700003)(54906003)(6486002)(86362001)(305945005)(6116002)(3846002)(53936002)(106356001)(25786009)(8936002)(2351001)(81156014)(4326008)(81166006)(186003)(26005)(8676002)(50226002)(6512007)(6916009)(6506007)(386003)(102836004)(68736007)(2906002)(107886003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1407;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qhSX3EN1Itdn7RqaOWNtrC0Yu0EJ9sTeMqrBmr39gNXnGNaBXVIibnBsxNTIiJ9x3kBdWN6Qh1wodki8XqlG+CugsVxr6hwsD5OLNTgw+gjHx0oxSBC4FSuQrMX8NfcRVYrqh+FcH6t+uqeHUcndGn8HthV8KoZZdXPUUdkL6VwC9pYO4t4NpwulF0sJXhMAZ5H5dkOgESYG2PK0pggEQkoiOdkTyxPwVIinvnUQOqEyatzcM4WuIli4/tIqdcLdH4FpvxOz2jfvDRXOg0yIqULom71n2HjihH897UrefYQi7mHVebYkf+mzZQUeBD270sr6S3PUvlqKWyazt3hJ5lkVsFnHwijZyecea0T5MdKlaegMJ3WUfVvTwSInO5Ta7DwdQNAG0jzqs5b27fgQAEyuW0fsgOLJUzxMbcOwXLI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9806197c-5cef-4a40-36ef-08d685714da2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2019 22:38:19.6654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1407
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

Driver sends configuration wids to reset connection statistics in the
device, but the device already resets it when starting a new connection

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index fbb61de20304..286685e426c1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -342,29 +342,11 @@ static int wilc_send_connect_wid(struct wilc_vif *vif=
)
 {
 	int result =3D 0;
 	struct wid wid_list[8];
-	u32 wid_cnt =3D 0, dummyval =3D 0;
+	u32 wid_cnt =3D 0;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	struct wilc_conn_info *conn_attr =3D &hif_drv->conn_info;
 	struct wilc_join_bss_param *bss_param =3D conn_attr->param;
=20
-	wid_list[wid_cnt].id =3D WID_SUCCESS_FRAME_COUNT;
-	wid_list[wid_cnt].type =3D WID_INT;
-	wid_list[wid_cnt].size =3D sizeof(u32);
-	wid_list[wid_cnt].val =3D (s8 *)(&(dummyval));
-	wid_cnt++;
-
-	wid_list[wid_cnt].id =3D WID_RECEIVED_FRAGMENT_COUNT;
-	wid_list[wid_cnt].type =3D WID_INT;
-	wid_list[wid_cnt].size =3D sizeof(u32);
-	wid_list[wid_cnt].val =3D (s8 *)(&(dummyval));
-	wid_cnt++;
-
-	wid_list[wid_cnt].id =3D WID_FAILED_COUNT;
-	wid_list[wid_cnt].type =3D WID_INT;
-	wid_list[wid_cnt].size =3D sizeof(u32);
-	wid_list[wid_cnt].val =3D (s8 *)(&(dummyval));
-	wid_cnt++;
-
 	wid_list[wid_cnt].id =3D WID_INFO_ELEMENT_ASSOCIATE;
 	wid_list[wid_cnt].type =3D WID_BIN_DATA;
 	wid_list[wid_cnt].val =3D conn_attr->req_ies;
--=20
2.17.1

