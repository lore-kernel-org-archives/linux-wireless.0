Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D87C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157B22082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="K9G01a+h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 157B22082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbeLBSDH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:07 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23448 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSDH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:07 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23899267"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:05 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr8HF2PyKrYRJ6xbHRQsyu557ObUIoREqYqbMezwD0Q=;
 b=K9G01a+hRTdOvgeugFZC67apCgJ3evTswAre2JX852EVFatLaOvXno5+9yKPtn9NcQeJqprUiAGX1MonxJmufIOO9d409SrUcnwyGddDIDQkiYcKcTy3isW+WY9f385EWazAZpliTlLwslBlFJQmvzCezUeOhlavRja584ePhWs=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:03 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:03 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 17/29] staging: wilc1000: refactor wilc_set_operation_mode()
 to avoid deferred handling
Thread-Topic: [PATCH 17/29] staging: wilc1000: refactor
 wilc_set_operation_mode() to avoid deferred handling
Thread-Index: AQHUimlEtbpaTnF9zE6bxpK9SmXI/A==
Date:   Sun, 2 Dec 2018 18:03:03 +0000
Message-ID: <1543773663-20561-18-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:K8WuI5b5uhT1IaJhPPUfZ8BXiimvUeMgrb3PhFrx8KAOcX5sSPbnoBya3HNa/sJZOG2NWVFmRuTpT+tD/BKZ6JRqMXa+ltcPiBEF6hzLgOnZ0A6DYcwXy5hVxOusILgrTODso0/4hiSMpi80bXujOc4bPc/Ydo/YtMzOxmVCltv7cWE1cSyKYp0Lydbdl/kLH8vQQyxvdrdqngTzeAVYkV6e1Kj3CbAHbDyHFpQZyq44LT19s/SU+6xVEf1KfPC4JwUCRaFo4EjQAB3v3O6dWmr/F/4kqQoUSMNbDM0+DVk435KgP/M9i9u7rT9pGMutdALsbzXVPQvbrmHCi/2TVWK1df718YViLCm2A4/5kETn9W0GYFfhPel87bQ1KI1oq6wfbBX4hOLRN+oygSFyOIRarcZdfT/7Nma+HElIdnwHG0Ab/WRVesQMXOvattqXglllqrpBOLxyy4w6RyxmXw==;5:9oJQvbIWaNZhL4PCWhvrGEiB5fZ0tTKz8GOIMpP6WVPN6D4Wc2CZT5UqK7AeGBE1dz2MXH9w/FXacPdIXCSDIGBbHa6KBf1hDOm2/MXOS3h77sWldQ4fuMNycfnc2bpGbd+SbI1nalfvNG6QpYHaNQ9bPdR0xwOl6aSLwKUCvXg=;7:UCjkMBb5Wihm9j2PaM2hbiNLuwbkrYeErPQTpKwDGDoFbLD95oo0GLeK1knuTbf6smdYXZSo87xmMKheHKlhWmHYVseO2YR1EZqdMT7AFZl0cfi7QmA4OIFmRaQBWw0zu+cLdQ3UQNV9GzoEPg/ILw==
x-ms-office365-filtering-correlation-id: 63a84e2f-b484-428a-d8ff-08d658806709
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806A4E982E1434B0DFD8211E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1ZdoupXxFR07S0IDf4IoSbLVwlRcv02p2hJQMv3Hp5oVif+zmD3QNEWc34TDNcDl6VbptcGOVojVTr/c4b7s8Op7Ah3VzPZxzKhW0uF3u9CRk6YRoQUYrKJlg5kzsno4TJBEv0ToJJVlMEGGmAGTB1sU9qFHMkTog/mhCi+caHwATpD3d0OKgaXMDA1e2E3qU925/2G5FID96tmrS8JbK7rGAa4lLixfEYsmmoq2Ou2ZHxb7yXiwOn0GS5RwC9r08D/0NJZO7a8wWg0/meyDG911s8Hyl+dlLxbBhgaYEXVoJnG4L2+MlpycHQBM3xaxOyIG3UU2lDCTC9qtUxiQnnPz2j+2BN4zazm9HvPoc10=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a84e2f-b484-428a-d8ff-08d658806709
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:03.1753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Avoid handling of WID_CURRENT_CHANNEL wid command in deferred approach.
Instead of posting the wid to work queue now handle directly from the
caller context. Use structure to fill in the firmware specific format.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 49 ++++++++++-----------------=
----
 drivers/staging/wilc1000/host_interface.h |  4 ---
 2 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 1910f9a..312c01e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -85,6 +85,10 @@ struct del_all_sta {
 	u8 mac[WILC_MAX_NUM_STA][ETH_ALEN];
 };
=20
+struct wilc_op_mode {
+	__le32 mode;
+};
+
 struct wilc_reg_frame {
 	bool reg;
 	u8 reg_id;
@@ -111,7 +115,6 @@ union message_body {
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
 	struct set_multicast multicast_info;
-	struct op_mode mode;
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
@@ -261,28 +264,6 @@ static void handle_set_wfi_drv_handler(struct work_str=
uct *work)
 	kfree(msg);
 }
=20
-static void handle_set_operation_mode(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct op_mode *hif_op_mode =3D &msg->body.mode;
-	int ret;
-	struct wid wid;
-
-	wid.id =3D WID_SET_OPERATION_MODE;
-	wid.type =3D WID_INT;
-	wid.val =3D (s8 *)&hif_op_mode->mode;
-	wid.size =3D sizeof(u32);
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	if (ret)
-		netdev_err(vif->ndev, "Failed to set operation mode\n");
-
-	kfree(msg);
-}
-
 static void handle_get_mac_address(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2550,19 +2531,21 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, =
int index, u8 mode,
=20
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 {
+	struct wid wid;
+	struct wilc_op_mode op_mode;
 	int result;
-	struct host_if_msg *msg;
=20
-	msg  =3D wilc_alloc_work(vif, handle_set_operation_mode, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_SET_OPERATION_MODE;
+	wid.type =3D WID_INT;
+	wid.size =3D sizeof(op_mode);
+	wid.val =3D (u8 *)&op_mode;
=20
-	msg->body.mode.mode =3D mode;
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	op_mode.mode =3D cpu_to_le32(mode);
+
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to set operation mode\n");
=20
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 10d5627..e958357 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -220,10 +220,6 @@ struct drv_handler {
 	u8 name;
 };
=20
-struct op_mode {
-	u32 mode;
-};
-
 struct get_mac_addr {
 	u8 *mac_addr;
 };
--=20
2.7.4

