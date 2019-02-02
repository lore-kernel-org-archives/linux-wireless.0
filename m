Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7833AC282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AEC02082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="INBZmxmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfBBTRR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:17 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36467 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:17 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="25789181"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:15 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWFsvsxw1NnZLOePfqvjArizv27M9uT1uDq5pl8heYI=;
 b=INBZmxmC9xpQTQUaNgXgg93RDljq6zYrbFS97xC1YqdmkTo0puBrX81nvEp4Pti7S+Lj/jDvCr2vWIs4IX4mSfyJJ9yxwlCIQO8ykV2/y1HSEHUbDgkxquuTgRPsjWGqOTySXsIeJeItnkdn0LJRIscFXVPd63J2GmclEpYQee0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:13 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:13 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/15] staging: wilc1000: use correct condition in loops for
 'vif_num' count
Thread-Topic: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Thread-Index: AQHUuyvnTipBfoysokuAty4Jr8EL5Q==
Date:   Sat, 2 Feb 2019 19:17:13 +0000
Message-ID: <1549134974-5545-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:nnvFX8gFy8A5qKX4Y93maDO1MEZBqBW706cy8rDWPke+Wg6wjuS4naWA8npIrv5w4wh4lYUWTkjmIX3Eks9CCeE+4dFOXKeXR2hVySRfDR5eQAGCPYQkRGyv7C5vebiv06/P7vlStBY6eRmJ8NXeArHSNXit37XBXtD8RfSkW6iGv4RTilPa+HoUVqgR6hqdNNAvbUVb0fFexPM74yGckHuoCXn2JoOkYKR5ngdGeinoeX3S/fRG5cQmZGSFe16L3Q1ITIFpcQjQt/74e3a6OTaAZsubnm3GMlhH2xWk49Gp96pd3IB3hyLYDLY3Tx0kaX5nMWEyK9iga4pePoyqo3heXIWWxkze1BvB3eH9gBfFEwHB/zgtQ91S2w6BGw2ZsXZzFcEnr0dUir0RboCjHcw4k1MBK2/p8hW97CQ+q1Aduo5kSKAfoMQtX8g/2xXGeu8FlU7s/zHGAWsP/t2JuQ==;5:GFU0iymLEL2H+xNSv4fC+LYXsT2RECDH6rw1I0FagGjg44lp8ncYwbXQSoFSmD9hkmzCiLamI4CW65lmLpOtnb+rY2GTVp+MCb3faLjGnlOhxV7WR9aRIKincq9wKasO+0YvgNjPNguDTKePZd/rmLVyZ0Ahne5TRLDcPTjIg2dXYOX7aR4aUgbW+vZdjf0pSOGeSmb5BoJj9w4OQHlhSw==;7:7ANu8/aKfL6wRZv4t0ggWhoymcXhy62RxFkYAJx99b/1G95Gd70wZBM345l5TBnr8RSJATmuT0RnbDxpCSLl3zDr5xI5z0YwfmVGA4jfkcfVbiKU/1qJKNnYNTc1p6YDk2DBdDHi/NeViKySGsfRZA==
x-ms-office365-filtering-correlation-id: 649ccaf1-5286-42db-0075-08d689430940
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998229FBFC8295FE4A774D8E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lNMq+MrV4hJ+3Ii+bK5uZczPvN1va1aU2zmdhyiN1TcqeXgKR1vD+uXCbd1hEVqDoDaVZXDOK2t3UEpm5UIGekmVAFenVQ203oNBsZAI07yYOtPmPGb0szdoELYBJYZ7JjInycL3H4FsgL9vYSygDIDwtt0kP9gKpClkiaY+T9zUV9Ilx9C3t8Be+sw1o7ZSwBpIONScRu2ffL2uFAJbrpZdPHFeULh0mN3HsZIqfolFmiAdHNIEvGyjHJa19+zghOZgMSAVP2jj0AKwRFJXTbjaY2+rKh6dfODv8BmGKFh9xF1qcAk1S+0XGrJgXM0I2aTDsWwEdsfx9B0X6ZBq50IbVLUwipYH/kOVjE7cLpHnlxAROlmXrB1cgRtIeeramGg9spTcmxI5pTiFuvq/yW/e/dT61iNZkTrpDZhFCx0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 649ccaf1-5286-42db-0075-08d689430940
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:11.1373
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

The value of 'vif_num'(interface count) starts with 0, so modified the
loop conditions to execute for all interface.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/linux_wlan.c     | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 3576834..fde236a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1659,7 +1659,7 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 		return -ENOMEM;
=20
 	*hif_drv_handler =3D hif_drv;
-	for (i =3D 0; i < wilc->vif_num; i++)
+	for (i =3D 0; i <=3D wilc->vif_num; i++)
 		if (dev =3D=3D wilc->vif[i]->ndev) {
 			wilc->vif[i]->hif_drv =3D hif_drv;
 			hif_drv->driver_handler_id =3D i + 1;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 81472d2..466a1fa 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -164,7 +164,7 @@ static struct net_device *get_if_handler(struct wilc *w=
ilc, u8 *mac_header)
 	bssid =3D mac_header + 10;
 	bssid1 =3D mac_header + 4;
=20
-	for (i =3D 0; i < wilc->vif_num; i++) {
+	for (i =3D 0; i <=3D wilc->vif_num; i++) {
 		if (wilc->vif[i]->mode =3D=3D WILC_STATION_MODE)
 			if (ether_addr_equal_unaligned(bssid,
 						       wilc->vif[i]->bssid))
@@ -195,7 +195,7 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 	u8 i =3D 0;
 	u8 ret_val =3D 0;
=20
-	for (i =3D 0; i < wilc->vif_num; i++)
+	for (i =3D 0; i <=3D wilc->vif_num; i++)
 		if (!is_zero_ether_addr(wilc->vif[i]->bssid))
 			ret_val++;
=20
@@ -739,7 +739,7 @@ static int wilc_mac_open(struct net_device *ndev)
 		return ret;
 	}
=20
-	for (i =3D 0; i < wl->vif_num; i++) {
+	for (i =3D 0; i <=3D wl->vif_num; i++) {
 		if (ndev =3D=3D wl->vif[i]->ndev) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
 						 vif->iftype, vif->ifc_id);
@@ -941,7 +941,7 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 =
size)
 	int i =3D 0;
 	struct wilc_vif *vif;
=20
-	for (i =3D 0; i < wilc->vif_num; i++) {
+	for (i =3D 0; i <=3D wilc->vif_num; i++) {
 		vif =3D netdev_priv(wilc->vif[i]->ndev);
 		if (vif->monitor_flag) {
 			wilc_wfi_monitor_rx(wilc->monitor_dev, buff, size);
--=20
2.7.4

