Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86899C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460942082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="2mbOfTV7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 460942082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbeLBSC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:58 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52847 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:58 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23451102"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:56 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gr/UOchA/6cX6lKR/aDDCabcWwWqdOSZ4rDf0sE36o0=;
 b=2mbOfTV7b9lfVcQz9fBzEWX1mS+0QR5GWwRfDUY2ixzXWO/66AJ3FHBZ5chYrhREsx7Q7eMjD9r0yiyXNA9DXkTMDl95wtES7yerJfGIMUOf9+pS6kSMrpMOtkgoUxKhLVEIFcbOYMJb4CHhbw+zmdiDlFeGKVuHMwZvhXfyEPQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:54 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:54 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 14/29] staging: wilc1000: refactor wilc_set_mac_chnl_num() to
 avoid deferred handling
Thread-Topic: [PATCH 14/29] staging: wilc1000: refactor
 wilc_set_mac_chnl_num() to avoid deferred handling
Thread-Index: AQHUimk/hR+BjAyON0Gq/ufNAKnx8g==
Date:   Sun, 2 Dec 2018 18:02:54 +0000
Message-ID: <1543773663-20561-15-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:HcURBxqAr65GPnkMoJzLD+1DGXQz+AhFOEKdONnVU3d+pRqTDLQ0UCxMlnfJRbxtjmA6McD4iKcU94UpsX1hRrLI79exfjwrIoTIAmooeutxZtmBE0m+7bpYgOFzMGVjeiyOMATFtV1sC9k30k12e+51izYBc0o8mVaXQAeYV2i4c9y7Kkh9sY1+iPOCPXayCRcbdnfG+neUdXnPQ+21KvlhvwDLzeginLWDxJ8m5imL6bQzZe3c/pI2P5/Up4f+Mv3Id5/MGYw63skF2/1KDygC7OybOWudFMRuGQleJ2n2uSVPyWfD7I2osgIg6TfQz7MeyrzRXoLkZRc5ibbt9Mbih3hbet5eJxZ1m8eSXtT1WbZ2a1MitkWcmXJAldd2U0O1wnEZqHGtR1Nt6ajSD7HY71W1Mf6SEoYg9femqkkyXfl5dU5BSlz52oQOmIQW/02207ss3kIYma2d4a0qww==;5:nHLXupSbr6IgIje+xfsqMhSR8w2vxgZfJcuGrO13nxAlJC6+QU168JtDqkbGSFyKm0piXYND6BKvDPN6qtisYn0o8ZiCwUuAQVziDQbb3e6+eX/GvdP3ete2+0IzBdP6shh3XObzY2djTJabrE4xhLkJmkJJ1T3uge/FODrfbZw=;7:OD1olfA9mvgrmG52VG0YPrndzaK9h8qROVkoogpFAk2rY3oJQaoOnr/NxbcRaXNgDlBIV63wgytHiy1N/oCJG8zBwmoDTG9OmSZ12RK/t9dNBxGdJ2hFPnPJQU8l+/9A7Nn8hOvgXQwmWhDzMsgj5g==
x-ms-office365-filtering-correlation-id: 49b592ae-7862-4920-577b-08d658806207
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB280662C8CCB31CBA46C47DF8E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: m63kmp4bfHsPJV6JP1UytSW0CA36DDYeFFzQjw2mnu4x7zsLfivqyE2FOIJNRNGFjZyE8G8ipZzA/JgetF0jhO5YkAaS+A77RN92EVMCLIPmihATZV0NdRcraHiV2qbmednLUYquBoOHWo8PWCVtUA2vzV5yVZduovmCQmlAC2qLKg0TDBCsJ0Z112ChUuHxAyGiUE6XMMjj12EZ4hq1vpqaYF3DgqkM7pTSylylA8qEC7HHeHwGJWye11MtxbD8B/+pJRpwX4DzRf0EzlI97sn1IMVaF3QeKbq5LtmOj1+57x+VXDxCRnO2BOxD3/meBEGiJ+CYbxK7JUuBXqbj6gvp0HCGviR+CW83egAU4wc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b592ae-7862-4920-577b-08d658806207
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:54.5692
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
Instead of posting the wid to workqueue now handle directly from the
caller context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 46 ++++++---------------------=
----
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 4d1fa4a..f6bd76c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -74,10 +74,6 @@ struct rcvd_async_info {
 	u32 len;
 };
=20
-struct channel_attr {
-	u8 set_ch;
-};
-
 struct set_multicast {
 	bool enabled;
 	u32 cnt;
@@ -112,7 +108,6 @@ union message_body {
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
-	struct channel_attr channel_info;
 	struct sta_inactive_t mac_info;
 	struct set_ip_addr ip_info;
 	struct drv_handler drv;
@@ -224,27 +219,6 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct w=
ilc *wilc, int idx)
 	return wilc->vif[index];
 }
=20
-static void handle_set_channel(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	struct channel_attr *hif_set_ch =3D &msg->body.channel_info;
-	int ret;
-	struct wid wid;
-
-	wid.id =3D WID_CURRENT_CHANNEL;
-	wid.type =3D WID_CHAR;
-	wid.val =3D (char *)&hif_set_ch->set_ch;
-	wid.size =3D sizeof(char);
-
-	ret =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				   wilc_get_vif_idx(vif));
-
-	if (ret)
-		netdev_err(vif->ndev, "Failed to set channel\n");
-	kfree(msg);
-}
-
 static void handle_set_wfi_drv_handler(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2600,20 +2574,18 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reaso=
n_code)
=20
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
+	struct wid wid;
 	int result;
-	struct host_if_msg *msg;
=20
-	msg =3D wilc_alloc_work(vif, handle_set_channel, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->body.channel_info.set_ch =3D channel;
+	wid.id =3D WID_CURRENT_CHANNEL;
+	wid.type =3D WID_CHAR;
+	wid.size =3D sizeof(char);
+	wid.val =3D &channel;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to set channel\n");
=20
 	return result;
 }
--=20
2.7.4

