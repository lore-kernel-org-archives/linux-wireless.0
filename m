Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BECC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7E02087F
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 18:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N/Mk3EL9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfA2Sqq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:46:46 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:9878 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfA2Sqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 13:46:46 -0500
X-IronPort-AV: E=Sophos;i="5.56,537,1539673200"; 
   d="scan'208";a="25609111"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Jan 2019 11:46:45 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 29 Jan 2019 11:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXVJDPD6Q1ph9BEepMYvrxpJ7EkNRIBZQBBUIRAfN9g=;
 b=N/Mk3EL9ODY0hI/2ihwj5WhnOeg0DP4Oc2bTTiKKOrcyiSpgj53jmCpariLA0oYyFTHHdtWggByrUziD/4KOTKf0K9/zQgS73YWxdLj/gz/v1QAQGWpq/MB/bh9l4TpK4r56/lrq+D4M4GQ9tXGnOfaNG9IUj+Kust4GLGnnu8c=
Received: from MWHPR11MB1373.namprd11.prod.outlook.com (10.169.234.7) by
 MWHPR11MB1439.namprd11.prod.outlook.com (10.172.53.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.16; Tue, 29 Jan 2019 18:46:42 +0000
Received: from MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea]) by MWHPR11MB1373.namprd11.prod.outlook.com
 ([fe80::58dc:240f:c0ee:37ea%6]) with mapi id 15.20.1558.021; Tue, 29 Jan 2019
 18:46:42 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <johannes@sipsolutions.net>, <Ajay.Kathat@microchip.com>
Subject: [PATCH v2] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Topic: [PATCH v2] staging: wilc1000: remove redundant reset of station
 statistics
Thread-Index: AQHUuAL6ezdvSqCYcUGq9J6ZHYIbVw==
Date:   Tue, 29 Jan 2019 18:46:42 +0000
Message-ID: <20190129182926.21513-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: CO2PR04CA0118.namprd04.prod.outlook.com
 (2603:10b6:104:7::20) To MWHPR11MB1373.namprd11.prod.outlook.com
 (2603:10b6:300:24::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR11MB1439;6:fnEAZwhdKMIdcop/15nG0Hg5LmEx9QJdxrCnVgqE9cMOrmlqAS0hZ4B/Tx5dcZkboVS9agojy77Hm9MtikjbhA7wnjqQv2YgWR9rwkM1mBuCmGrqcLC3pnHbR/cnQ9Oq/gdDO9rvO368pR4cObFQagRek3yjbxuHby7Tc+xzo5I3x+5v/OD8XVMdU7/0n6q/pWAEjYALwOJtsGKVw1+7Obt+/SklU2gNLb9gKabgoopWVkwJQCJKBWvbbtGLQDQ9yxIX+gD3+gfkCVE9ux0Txg9TzO/b+4gI2CtH5pCXuZCBfS1qV8RnhXBVuAP4aS79hNJV8kvT5LgOfFFIqN5XHOtU3nMD08AQBPmogWWuNu/Q/qbqNi9iIv1lO4gmjNLt7FGe90F9B1iJ9QjbIVjcyjNvkqb4jsOSrs5vTFCwWwAqTf9IsMHy3YjqnSZ/6PbQUj02CkKfOxohuBhEME7fDg==;5:eEV7EAmUgBiPwdkjBMG/pcif5a6ixUN2eBCKs3zt8SRUtSqncpMc2fibXBbwsnV83hsNftru+PbvAD3TpYo6VcuHR+2yaKwyEh4eAHrhIT3zE87VQcBnWjfU46uWuMo/tBrxXXYssq+vLpbBiyfGQoWLfAaWq4Y6bPv61PeRlOPOolGgxokIVBFz/Se7m2jdRStMq2PyMRKGCXJxLAcmFQ==;7:oPQXdYeNW9FPKNvVGLO3ueLxqwYaWyhUu1HiowXJ/YFst9IEN4zDWQqSiQBZgATN0OupMIZru6nvd4JpIOYFqPO9grd90HlBKOQdWL46wRN72UPNcOsHhu9pmrznJJyDxSmHPXQt/4hy4pJcFZ0lnA==
x-ms-office365-filtering-correlation-id: 1ef28571-1f5e-4b77-1359-08d6861a1c70
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:MWHPR11MB1439;
x-ms-traffictypediagnostic: MWHPR11MB1439:
x-microsoft-antispam-prvs: <MWHPR11MB143962AF5D83526B039053CB8D970@MWHPR11MB1439.namprd11.prod.outlook.com>
x-forefront-prvs: 093290AD39
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(136003)(396003)(199004)(189003)(52116002)(5640700003)(6436002)(476003)(6512007)(2616005)(54906003)(4326008)(53936002)(2501003)(107886003)(186003)(66066001)(386003)(6506007)(316002)(6486002)(68736007)(50226002)(71190400001)(86362001)(102836004)(25786009)(71200400001)(26005)(106356001)(305945005)(478600001)(97736004)(3846002)(6116002)(8936002)(1076003)(105586002)(14454004)(2906002)(7736002)(36756003)(486006)(2351001)(81166006)(81156014)(256004)(8676002)(72206003)(6916009)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1439;H:MWHPR11MB1373.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: a2qDwU2J10NIeo7AUxnEF05crtPYkHNJ7oppGJQCPmpvZhZ349UdzVJvp1LRO3FkjD3t7U2td0s9MS081oqKaN/Fn+XE5Okt6h82tKMd2GYF7P43GLArZPztIHrcNKlWxoim9XrHjwFEVfu9YS9QNny5K5nbzF5dFfxPnWj+LnXcDWWdonCZ7QPO6u82ne+TjlZsWQhdFPWDp5r1ZBxYIXN7u3gY8zRVZAwEbuRFeC84MRSZfnHC2Oc57RukBMh0TaRj6KK2V9Oi6ux4x1lUCIH0Ra13y298hss1chC/35x2BV1TGk7cnvbfOkwZnQaKvmFe9mmiYh3d6dc5P5rIYNYpu4YdwoZSlrG6K0NYCD7zpp7AlNNhASjhJBAXXfLddjrSvMgG4XAy31RH+uh5kUHkj39MOc5a7E6rUpB1Xiw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef28571-1f5e-4b77-1359-08d6861a1c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2019 18:46:42.0913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1439
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
Changes in v2:
  - Decrease the size of wid_list array

 drivers/staging/wilc1000/host_interface.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index fbb61de20304..e958f9b935cc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -341,30 +341,12 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u=
8 scan_type,
 static int wilc_send_connect_wid(struct wilc_vif *vif)
 {
 	int result =3D 0;
-	struct wid wid_list[8];
-	u32 wid_cnt =3D 0, dummyval =3D 0;
+	struct wid wid_list[4];
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

