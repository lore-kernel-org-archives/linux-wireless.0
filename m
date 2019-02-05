Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33671C282CC
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7EE2081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="D6yRDHM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfBEHPf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:35 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40009 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfBEHPe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:34 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="25864234"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:33 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyJElnNE+5EWbsGKipid2rvF6ubpvN6mmr9iIrgLtUA=;
 b=D6yRDHM/z7cQ6MZ/ASh/kezpFIghW7LePfxllMQFVmTep4+DGC2cML1s39AlTQx45RucLj/CsB3LFsQX4J7Xuy8hPRu2jd2tHSdhIiC9wX8/MwvOuwSAlmC1bu4M7MbJc0wDC1TsRf9qXSAgLybede15kNpl7C6fyz4SxtwIdn8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:32 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:32 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 01/12] staging: wilc1000: remove use of 'terminated_handle'
 static variable
Thread-Topic: [PATCH 01/12] staging: wilc1000: remove use of
 'terminated_handle' static variable
Thread-Index: AQHUvSKUmuF7q6pl/UyNs3QCBI6Big==
Date:   Tue, 5 Feb 2019 07:15:31 +0000
Message-ID: <1549350913-645-2-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:hrOQ5M4DqVn6ToonK2euTNkqjNUNpyk2eX29t0n8T+nVSPzG6B12dV09h9xptVxC9k5MUg1anY8Di+Mdneusr7CZYDCHGvZ5BEwL7+dxDOq8j/S7P8wQsx5w6zsnma6EJ7/jSxMZu+lAlEVzjDg19nDmHtOrG+4YrkyDE1e23e9zSEDKPUhO+122etkUIOBojOpKybc8qi6JIobCecUnclI8nB1QPW0MdcwLTF59EuAcJ+U2npxv1VNsK7plHUMdh4Wh/CU2PLynsZGyIl8wysGusl1oIO5EtFVXduB9v0CKNXPg9LM5L6eTq1cCIEq1MdDPiidd80cau0vAE1RsSFoHZHgQbG0OTkDj9DrKlGqYYPIUxUB2M8VsDwSwL9WzaBqdF0tv3s8w5vnCx82qyuB5deFJ7QudeBCQyIhUIA95JYjsEywp89m606b0CrsdS9Dpbt81Q7AIekPSjnkryg==;5:u/8ORY8zr4XhvguOGRSCqMVCbkCvLWoQKsc/QsxCU0Z+eF8v4bVXu4zKiTjTvVyu3vFvlif981oTPRcoVxY15S1SzJXNGrZjtS3mo8cnQGhFoU6Q2pzdoQ8bZDVKPj/Il6afIrfbRTBQjW/JS8vl3xKe4pkQuycUpOgRwcOqG21xH0MUiyn+1bgzrha0ismwxo75wKEDxj3/eDx/Q8rkTQ==;7:vSSGxvizrQf+pkaH+eqseLHQ1hZYadSYgMysPy2Q/GyhD86NdLKlDcw5bWxkZWebRHxl/eF7yVMDnyVfCTAzX09rR1p4lYJct33/u66bUAlyuXhkEJ3uVQhJH8VWrv/ceUHUoKQa45oCcRrQLgHyaw==
x-ms-office365-filtering-correlation-id: 09183276-ccec-4d81-710f-08d68b39b6cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB2982884292C05655B08278E9E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Jv8Qeb1vU3l81t/ioYUEkbfQCZhAE5nDavaGc+Gdh5mLLHQBpvX+D4xhLeMvNxB/oiC8lvEKFWHY/0zgabSLWwwc1J9/Jct99+3LGe7Ta7NI4W2rZ3k99CwQoXumInXK84Wg7KNHLRjtBPrf9fY2uwx0d1rKHReukX16a3JVzWQKP+/ltmd+q5t52i1KME40NcTXJ46u7dygXfmuf5PxPBK+fEGE8GMBNj95CntrVZXBoALj8Bos3ADVmjxRzA9v3jjwRRsLQryuhxnVE6ZlovPxHvbXTvlqPO+O940zAbtvIBC+WJ0NgWJNWDfyJKpBC4nRvHj3Ux/t7bQn620q4/rTIg91PkLohSMRk5+DTcM+E6l6IvUEa8c11ign8faKOJAowjt6uLaF8iV7Ffi12YL8/Jv5PcUfJvs6MLjMKA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 09183276-ccec-4d81-710f-08d68b39b6cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:29.4887
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

Remove use of 'terminated_handle' variable and set the 'hif_drv' to
NULL once it's free.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 3576834..97bf747 100644
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

