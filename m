Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40A6C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 888452081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="gBBsF6cG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfBEHP5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:57 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43453 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:57 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="23448477"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:56 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zn5xndLfNGTBiR3+TmhFWF53CClglaWArdwMLOzoXRo=;
 b=gBBsF6cGI4sajYtFEG0n2jIOjVryfltKkBXaeJtaeJGlL8gYe/QzpkfKIZdPOPqKIriXGjg+y5IKaYyYUt5pdOuYIpKEsJzExiNmKdHFVdMaNwQ82hquW48QEXqVaXvskcwC81jAutRMmn03gqHU3T21qhWrf3PC7H5n45BCqps=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:54 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:54 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/12] staging: wilc1000: avoid use of 'hif_deinit_lock'
 static variable
Thread-Topic: [PATCH 08/12] staging: wilc1000: avoid use of 'hif_deinit_lock'
 static variable
Thread-Index: AQHUvSKhAfibxsZJjE2drSj0RpW/gQ==
Date:   Tue, 5 Feb 2019 07:15:54 +0000
Message-ID: <1549350913-645-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:/Wl+TYtFkZc++kVP3dL9oYfj6lOnYKz1k42jrCLPd8U0bsdS1kbJK/MBl1qkRkbPd00gpjh7AQqG5Etu3V7TtwzzXS/n8cr70t4vSpuAW6le2F2EDZvfbaRhHut8Xy4CpWG8okMVcc8VV6hWXUoLRWcSJlMFM+P0vngARYGgrvUXmziY3grgjzBtDa8z8i8sovWTcaA+w0uqylZzb8OW3LtsGJjzWUWpQMA1GCiyJ2bGukQsGdC0IAExfdItZOgAyFNuXq7JzCOsTAJ3TrCLKrBw0UuGtRU/HnkoscboAVOtQqW+O4HgnXIJt+rz2GEcJPAjjQFOeJmt4LLtmJKtNSuh5z63k1OO9XWRbK2NMpy6NDvXTp9nYi9pSSBR/c/qNDBswUl5QqLow2RJfqKHHyndMRpvGZWKNq5QzfPIWDa+jh08kPHalEu4V80fDp074viRKPvJF6XxOs8wmPj20A==;5:X1ybOOKWPuoPwArfaAYlySX2KGAKTZYP2yG/a/POwGKNRKEv+4tmcQo23l5hD7YQSkhariQ7fHkUF8hrbK0p3C5p5iWiugNuAj3xiiW8VdYKcmvtN+M31Je8Z+82bwUqcQWg7E3z2tYeIMpMy25gdyG1eoUblCv5yoiLCkTqVj4WRPYSAUMb2wE6Myc7ImxkHo2CEr0cZwpjN65ZRXJk+w==;7:JFqNVI0dvaHkoNqWA9rLHaPIEW7ddNXX8f1uOoJ3yXaYhjFPRfPyLwUNPfXV9cJivFZpLg0DQ8+C7jpahJTG5p3SH9N2YlCqrBvi2aHgnvxh1wu7uPA+FMbKHWXbt0ImLgVxL+C+V+E0AMCDGv8jSg==
x-ms-office365-filtering-correlation-id: 5f6af578-0f81-48f5-1d90-08d68b39c42c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB2982B5CD3830386F21D019D4E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fyf5kMzhCnFKaZSCXPl/cLsRZFg9OmZ5b7TgHFP3HvIhT7Bul3Fx1B8p05TZ8A3Dgcebb5RWQsD0bWhbxLJr4UE05Yp/KESI7cIIthPNtupd04bnNmnaZ4ezP7gFGQgXb/o7yeGAiuLkUeOStE2MQyQ0x2ZPEXVyItCDwdCnr0phd4ZniOtcFTT4gsspDFEa3ucmPeiKTR3GVCipeEzD3yZV5SDUhUEWZtRHjHiMIGRX/xp5XsifJ1GsW9SMucLWHpK7bmYs+u8otm9KfC9Yg+8DshE9O21ie4ImVJ3kTpGJ0aC9FVevHUYWiXT+WIzOUMyrslPPHUnWKgJhmItEc+X+Eqml8/2CcV0q3zTeSAuV+3yRwj1SjzYv9FkZnEhJRvq0ZgnoB1RQlTkB6gBK/VpDbUpBZjztXMMS/vei/Xk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6af578-0f81-48f5-1d90-08d68b39c42c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:51.9281
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

Avoid use of static variable 'hif_deinit_lock' and move it as part of
wilc struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 20 +++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 ++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 115b6f25..0fb6ca3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -130,8 +130,6 @@ struct wilc_join_bss_param {
 	};
 } __packed;
=20
-static struct mutex hif_deinit_lock;
-
 /* 'msg' should be free by the caller for syc */
 static struct host_if_msg*
 wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct =
*),
@@ -1645,7 +1643,7 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 	vif->obtaining_ip =3D false;
=20
 	if (wilc->clients_count =3D=3D 0)
-		mutex_init(&hif_deinit_lock);
+		mutex_init(&wilc->deinit_lock);
=20
 	timer_setup(&vif->periodic_rssi, get_periodic_rssi, 0);
 	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
@@ -1673,7 +1671,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		return -EFAULT;
 	}
=20
-	mutex_lock(&hif_deinit_lock);
+	mutex_lock(&vif->wilc->deinit_lock);
=20
 	del_timer_sync(&hif_drv->scan_timer);
 	del_timer_sync(&hif_drv->connect_timer);
@@ -1693,7 +1691,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	kfree(hif_drv);
 	vif->hif_drv =3D NULL;
 	vif->wilc->clients_count--;
-	mutex_unlock(&hif_deinit_lock);
+	mutex_unlock(&vif->wilc->deinit_lock);
 	return result;
 }
=20
@@ -1746,31 +1744,31 @@ void wilc_gnrl_async_info_received(struct wilc *wil=
c, u8 *buffer, u32 length)
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
=20
-	mutex_lock(&hif_deinit_lock);
+	mutex_lock(&wilc->deinit_lock);
=20
 	id =3D get_unaligned_le32(&buffer[length - 4]);
 	vif =3D wilc_get_vif_from_idx(wilc, id);
 	if (!vif) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->deinit_lock);
 		return;
 	}
=20
 	hif_drv =3D vif->hif_drv;
=20
 	if (!hif_drv) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->deinit_lock);
 		return;
 	}
=20
 	if (!hif_drv->conn_info.conn_result) {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->deinit_lock);
 		return;
 	}
=20
 	msg =3D wilc_alloc_work(vif, handle_rcvd_gnrl_async_info, false);
 	if (IS_ERR(msg)) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->deinit_lock);
 		return;
 	}
=20
@@ -1781,7 +1779,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc,=
 u8 *buffer, u32 length)
 		kfree(msg);
 	}
=20
-	mutex_unlock(&hif_deinit_lock);
+	mutex_unlock(&wilc->deinit_lock);
 }
=20
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index a06b0c0..3a78ffd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -271,6 +271,8 @@ struct wilc {
 	struct wilc_cfg cfg;
 	void *bus_data;
 	struct net_device *monitor_dev;
+	/* deinit lock */
+	struct mutex deinit_lock;
 };
=20
 struct wilc_wfi_mon_priv {
--=20
2.7.4

