Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE99C282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5712F2082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="r8sNke+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfBBTRS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:18 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36467 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="25789183"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:17 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmYVSEFVHMQ8wj0BMWT4fIOD2T6R9K6/L+cy47oS9Ss=;
 b=r8sNke+9+bxYit2KEhe8sygjx0fxFmSsSPFdqoN6bkcY8C+Vwz8lE3chZDLFRrPWQtR94Okgyp21GZaG0zcCvh7dFUqc786/PJQqNeR+Pr4Jo0bZUWBRZtTS39roqDK5fLCzq0zzSkjgj5nRucCR4KMAo1WgZRjQQTMdFXheMvk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:16 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:16 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/15] staging: wilc1000: remove use of 'terminated_handle'
 static variable
Thread-Topic: [PATCH 09/15] staging: wilc1000: remove use of
 'terminated_handle' static variable
Thread-Index: AQHUuyvooNbvePrjR0+z4StROIk53Q==
Date:   Sat, 2 Feb 2019 19:17:16 +0000
Message-ID: <1549134974-5545-10-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:3ZARpvO0NeKowoZ14+87b4CXdJ+FpVYVBpb/9pxxGFfPR9795T6sL7/qv4+MNGLzKXzXC/QzKaHSYAsbveoAh/GD826PBczcVaBhrma5UQygICQL0o7abD4ibO50U3d2K7x7y53PngZwU5W5tnBuetoj3yyXWXkbFAKiAkpxAER2NPN39aWt+nFwtwpfIJKcbCRUBTG3FitGwA33fZPiEqJ3PD6nw0FhhMNwi0juL/H/lSnRDI/Hnq9nL/86RT8kk8t02FDDvsgSFI3Tm+sEjA0ifyRM8eNoB9Q1ZYzuh9U524Bd5tBmm1kXp7yFtKtKZ3REW3wmh96HmAu+0awvwwjLltoqapUjjZVTelARIxyoOzARPk9Xv1xSa4MBuMU/NPChYRYWBxiSbHma4XROSuJe0ZBCOC20Y9OE4FW3dq6v1kX98l9ieHx+as0QQ3mzXVM6XHS/bsR/Ivln8qYM7g==;5:jfTEZJE8xQlzlEoeo5+yDNf0ma2g0Es3LkPR4g86lVJr4XpI+oHOjKKHVH3FXrLHkvjO1rluWIBHTgSQa6cAXlmvt+eW0oHGjet7CGH8ddj3fT5BkoLfm+690AD3fHNCToHDuHDa88G0+kzi4kRyS/uR8XCag6/MER7YNHOO0naCY3N3UjqaDD6CE2sFc6a03CLluFJFQWvh/WGZpPUKAw==;7:sc/hLLXplWZR1NSCJjMelmpKPGtQiX14vyXqi8e6cUYZLJipWcOE8n8DHP3JT/fMiX0d+YOkIvy45dZ0hzfx7hp9UNGgGvbnSPl2xZmHUvqT+sfKCmVAqfmcNlXwneFGQVQ7DkHIY0xoodqlnsukSA==
x-ms-office365-filtering-correlation-id: d857303e-1c58-47d8-39dc-08d689430b0c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998C443CBF0694DE73002BEE3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hE1bvh4Xx2AIDs3zraI0EUONoZMtF5mrranKoi24Z4rb/wg1aFRekD/118VyEJsB5svk7VBuCrCgomQJp+0gi19F8U+E7aKPlFSEqSM0msIHijcknFFPrEJHXS9Acl0FsQkZOebMBDgwPx2vJvT0q2pVTiaRhRI7u0yORL9Xw7UKE9jruwVvjZa0BINycD1g+XsnLKFMWQ6lptwxtG/vrV3iyZbbk8nvE8MZaPjGCJCh4ECaiiz2AA2vnQsBiP0VxqUOkbCiRAnV788XvaoMCstD2DpDW68elYSrL68Ry475XStjq+rsCt9Mv2fQ3zc72gkNu0rgmuZF7yzLMISMY40AuTrs9DnXzknrCqjNE4XszhP9ZnpnadvIa9L1quO7A1pZbdAGKbicMOv8oclQPxC0VXKobBNgzkc2gxzAj+E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d857303e-1c58-47d8-39dc-08d689430b0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:13.8402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove use of 'terminated_handle' variable and set the 'hif_drv' to
NULL once it's free.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index fde236a..4598920 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -130,7 +130,6 @@ struct wilc_join_bss_param {
 	};
 } __packed;
=20
-static struct host_if_drv *terminated_handle;
 static struct mutex hif_deinit_lock;
=20
 /* 'msg' should be free by the caller for syc */
@@ -1478,6 +1477,9 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, in=
t index, u8 mode,
 	int result;
 	struct wilc_drv_handler drv;
=20
+	if (!hif_drv)
+		return -EFAULT;
+
 	wid.id =3D WID_SET_DRV_HANDLER;
 	wid.type =3D WID_STR;
 	wid.size =3D sizeof(drv);
@@ -1699,8 +1701,6 @@ int wilc_deinit(struct wilc_vif *vif)
=20
 	mutex_lock(&hif_deinit_lock);
=20
-	terminated_handle =3D hif_drv;
-
 	del_timer_sync(&hif_drv->scan_timer);
 	del_timer_sync(&hif_drv->connect_timer);
 	del_timer_sync(&vif->periodic_rssi);
@@ -1717,9 +1717,8 @@ int wilc_deinit(struct wilc_vif *vif)
 	hif_drv->hif_state =3D HOST_IF_IDLE;
=20
 	kfree(hif_drv);
-
+	vif->hif_drv =3D NULL;
 	vif->wilc->clients_count--;
-	terminated_handle =3D NULL;
 	mutex_unlock(&hif_deinit_lock);
 	return result;
 }
@@ -1738,7 +1737,7 @@ void wilc_network_info_received(struct wilc *wilc, u8=
 *buffer, u32 length)
 		return;
 	hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv || hif_drv =3D=3D terminated_handle) {
+	if (!hif_drv) {
 		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
 		return;
 	}
@@ -1784,7 +1783,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc,=
 u8 *buffer, u32 length)
=20
 	hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv || hif_drv =3D=3D terminated_handle) {
+	if (!hif_drv) {
 		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
@@ -1824,7 +1823,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u=
8 *buffer, u32 length)
 		return;
 	hif_drv =3D vif->hif_drv;
=20
-	if (!hif_drv || hif_drv =3D=3D terminated_handle)
+	if (!hif_drv)
 		return;
=20
 	if (hif_drv->usr_scan_req.scan_result) {
--=20
2.7.4

