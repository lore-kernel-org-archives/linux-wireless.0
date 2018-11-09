Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B66CC0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA81E20855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bkkM00kI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA81E20855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbeKJECD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:02:03 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:59961 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbeKJECC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 23:02:02 -0500
X-IronPort-AV: E=Sophos;i="5.54,484,1534834800"; 
   d="scan'208";a="22615794"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Nov 2018 11:20:18 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 9 Nov 2018 11:20:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwYCMsnyjyNtuCKX3djKXmiWxH12KND11OArhXtXNOk=;
 b=bkkM00kIajBH2mUWP5st40u+KwXB8nm1QWCjRXSXtJIvupDMyNMyt7e8TkA9dja0YGLHLbGe7szi+hRNpS86qYUM2P3V/7kGvg4T4b3RDA/YY36z0DpxVJ+OTFccTGnCDbCh36oMXZG4EVRDp0YhlzC4Eq94Ea4M0npS7yoTu9U=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3392.namprd11.prod.outlook.com (52.135.111.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 9 Nov 2018 18:20:16 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 18:20:16 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v5 2/3] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Topic: [PATCH v5 2/3] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Index: AQHUeFjdAXf0QM8tu02vMmwkEhGbJA==
Date:   Fri, 9 Nov 2018 18:20:16 +0000
Message-ID: <20181109182008.4328-3-adham.abozaeid@microchip.com>
References: <20181109182008.4328-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181109182008.4328-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3392;6:SjLZeEovTmAfNyXxdMTUMIQk2SslzdMJgkRajZ743Kg9ATnAIvOkecSAPXYVGifm/hYD7H+VYbrfsmNw8QjzMFTkauQtE89VJ+XItAHEipEiTeUcm5MmjqqBMcgykXNeprPJYNVblLHpgE+QE+B3NQuw1+q94KPTTVZ3CQlPgREjXcD0EaaWmdabl7+ogYBaA61p2SkynUmhQyArA2EE5Ayxa7mSeTXnIrB9hp5yZwPADmkhZwpUVJErb48P0+yofJ/axOOCpVljCyVTw4v2zsvIWKgVLfzoPxeOcqqHsc8XnOxwja0uydQN3cacGm1DeUSpMfQwEZEfVAidRN8GsrPhRNZRdMpYgbAwse2NtvypuxknGhfd86yT+nwCe37nVn76MydugO30XlBdzg1urgD6yiri9nC+012amz0k4zdYyxJsc65JCURHadzaWEs7wEb74BxRKs7hm+AmgMUtrg==;5:kgqCsa3M8jhGQfc3Ueq/f0OZQwQWDpr8SvbZ3c0QRU6kGzzx8NvJXnzN2q4iHrmGjWjCuR6raubiq4IBwAYMBkj8PGznYREC2Nw2NQylyuYnfIHH49o34ot/PZp1Y6e0VrSMr9oOAuF1mPIvXavBFkIg1uYV/OPhhC5Ixgk7d5c=;7:UjB4qYNELEZ+1EF1keXgkThKfuMN5D9aiR3qW7jNKWpm4mjQtjdXtA8Nmt7zMTaXLE7g9rVL4DZxyCGQihc0ltANVZ0XCEH65ldHwGcMtyeQabH+hoByGKczfGYQOW0KMfMGsi2GTGJqFIV4vq5WAQ==
x-ms-office365-filtering-correlation-id: 736cfe6d-44dd-46f9-11fc-08d6466fffa6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3392;
x-ms-traffictypediagnostic: SN6PR11MB3392:
x-microsoft-antispam-prvs: <SN6PR11MB33926B69DE473007D9B8326C8DC60@SN6PR11MB3392.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3392;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3392;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(14454004)(5640700003)(6436002)(386003)(52116002)(102836004)(76176011)(14444005)(53936002)(256004)(2900100001)(81166006)(2351001)(6512007)(81156014)(6506007)(4326008)(72206003)(36756003)(25786009)(6486002)(8936002)(8676002)(71200400001)(478600001)(68736007)(2906002)(1076002)(86362001)(5660300001)(6116002)(6916009)(3846002)(71190400001)(66066001)(476003)(2616005)(105586002)(11346002)(446003)(26005)(106356001)(99286004)(486006)(305945005)(54906003)(2501003)(316002)(97736004)(186003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3392;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: sXiTumJfIJW2o44U4NbNCI3543wpgFPTOYL13cPsBISJJSVHbr9HOsVXpMEPZ23TYMrRU/HMHBMXyXOqoZR6xWqjeMCyAQEwkitpSG6N38lHHISb4KrktYOSrgiJabbIrPnnWJnwOxYvgHfck3dmhaA68IItK/g3gvXVqI/+7aHH9CCgkY1qTbMTUUenKyl7odJQDDalTif5Bgj0lu67zU9ZNAHYDFzGbja0cGEFnvBVdXpLAHQ2kSJdKRboz/8mYOkRVf6bfZTfaN/T9exAB5u1HIRNVdUm7B6+kITrQVRGE/1U7ueX9iTpVdK/sfKQGffU/SxUPeqgCtzDJvCrlqWWdLRvSSiqHxkayO4dUao=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 736cfe6d-44dd-46f9-11fc-08d6466fffa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 18:20:16.5766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3392
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

host_if_drv.cfg_values is a write only member, and can be removed

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 -------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index c1215c194907..8d1142776310 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -375,43 +375,31 @@ static void handle_cfg_param(struct work_struct *work=
)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	if (param->flag & RETRY_SHORT) {
-		u16 retry_limit =3D param->short_retry_limit;
-
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.short_retry_limit =3D retry_limit;
 		i++;
 	}
 	if (param->flag & RETRY_LONG) {
-		u16 limit =3D param->long_retry_limit;
-
 		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.long_retry_limit =3D limit;
 		i++;
 	}
 	if (param->flag & FRAG_THRESHOLD) {
-		u16 frag_th =3D param->frag_threshold;
-
 		wid_list[i].id =3D WID_FRAG_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->frag_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.frag_threshold =3D frag_th;
 		i++;
 	}
 	if (param->flag & RTS_THRESHOLD) {
-		u16 rts_th =3D param->rts_threshold;
-
 		wid_list[i].id =3D WID_RTS_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->rts_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.rts_threshold =3D rts_th;
 		i++;
 	}
=20
@@ -3256,7 +3244,6 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
-	hif_drv->cfg_values.scan_source =3D DEFAULT_SCAN;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index df9fc33be094..1e2e50e91f76 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,7 +293,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_attr cfg_values;
 	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
=20
--=20
2.17.1

