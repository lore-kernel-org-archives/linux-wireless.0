Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE10C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03DAA21527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="0VpBND9l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03DAA21527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbeKLPg5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:57 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20234 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:56 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255111"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:17 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5vSsWAqoGgYwYuyiTFUZsPviJaXVqiOHUohCrJHtRY=;
 b=0VpBND9lHrQss8zHEsEY+2yfx30lwzxiX0IcKor3AF7IKLW0AAUMczUcesxi5U605JRKqAHUNl4YTbigGrUV8u7p1TDF3pBXfZ1aYvIWvADq2/vyphPSfhgDXDsGn55LnLBA1muHiXFPUDHuBjp0fFPpxMEXRdzo+qEUXtkkqFg=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:14 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:14 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/12] staging: wilc1000: use enum contants for mac status &
 added 'WILC_' prefix
Thread-Topic: [PATCH 05/12] staging: wilc1000: use enum contants for mac
 status & added 'WILC_' prefix
Thread-Index: AQHUekrilosVAR7mhkyLeKdcYAQjqg==
Date:   Mon, 12 Nov 2018 05:45:14 +0000
Message-ID: <1542001458-20217-6-git-send-email-ajay.kathat@microchip.com>
References: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1542001458-20217-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::29) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [27.59.94.109]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:CM1/6KR4Dpczwu65w0YT7r7C+3FLnauSHxU5SAxMMlJtMhvbdxCtWqukwT2ta9nd/r7dyXzpiRRWRYGzW/V3eP92KQn/0u1Kjkg2e1CNpelg3sFyQ0hTAQ2pvCOu9Vs1Cb4yMFqYbEYN3wQeoJdUtdp3zTEhCeEkmfMknCfBw1+BEhxZdC89luncwRzjchmlAChkyaN5XHT3bbzalpITad62dike+aS/RpqIcjl81itv34cDzM6FnH1G/4Jt3zEznX45+3MwEANv/Q7FIFGUgAdrDdMcLsX9XhGtbhyDsgd3HMI5aEFq/VZGytzOifmP4emHR9riPq5qvXWv62DxxwMdNnRrSaYCV5GRw92Ch9QpmHh0xYxsYFS4s3NGBnpbZHHXlcS/qTofsLty2Yst7UgeVhRj6pmGgFZNRDMaaxjBj0hCzObsm+QO3oQFT+0eWazeboJubNxp0NQpzACSmQ==;5:tSsVHHTCFEvcJGv48X5HzsGctBPTqQ6IgfZLDpwpx4De3ynOqf33gCd3PbirQYTwWmFUAGOBUDbePdGPKhf836kVUn/KMRCHmkTMl4RQy6smcpu9Ni6r6f1fU1ByMuqT/sXcuV8h/AzFEF0AgHoiC6tZED925vh3E6z2wAha8w4=;7:xHZvqWI/P6oi2AVr3axESI/2gweJDnaIgk/Wp9gToD8q2OIsvS6qDJe7+enM5snFJ58QmsJZdxQKgrtXqllwwEcCz5fIdqzesrre4HF06RPd1EzlPywu4ZJWi9l95L30NMhO9C7ZsCsPNbcPdkclkQ==
x-ms-office365-filtering-correlation-id: 2a4b14c3-f591-4f40-a742-08d6486204cf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599A4B578906B5908EA009BE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(17755550239193)(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Y53uBMX/DQT6qqoN+GZbLuWXtJOc0knJ2kBBFyVMuwJm9DtptACmBboXKoDDVNq9NJmKh+l/k7d/o7KaK1wrK8RrLHBkv7R5KXPSHpcMhkQuzMe2132uulY0ZnEAgXfGINUjBqr+QAyk7KFaXbqV+NfYfcZO/xPWUWe1KMuX2qPi+TBd8Fup14fo0HTBj+BryespcLHCGWLrPPNuOcXtfvucp6lj+BlUQO13SDh8qf0h48HWznrlFLOKJkxjH6Lo9wAJz4miJ8YX72WSoHQzDt/CKBZv7KjcgfeEOFZzYkQrJ4NqZVnZTyQ3dzTJqRQ7aq4xI0xC9CFnQ3kdZm1HY5Y8c8ilNCtJTlmTStEnFo0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4b14c3-f591-4f40-a742-08d6486204cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:14.6367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2599
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Clubbed mac status constants inside the enum constant and also added
'WILC_' prefix to have better namespace.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 15 ++++++++-------
 drivers/staging/wilc1000/linux_wlan.c             |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  8 +++++---
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index c200d90..46b1a00 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -797,7 +797,8 @@ static void handle_connect(struct work_struct *work)
 			}
=20
 			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
-					  &conn_info, MAC_STATUS_DISCONNECTED,
+					  &conn_info,
+					  WILC_MAC_STATUS_DISCONNECTED,
 					  NULL, conn_attr->arg);
 			hif_drv->hif_state =3D HOST_IF_IDLE;
 			kfree(conn_info.req_ies);
@@ -857,7 +858,7 @@ static void handle_connect_timeout(struct work_struct *=
work)
=20
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
 						  &info,
-						  MAC_STATUS_DISCONNECTED,
+						  WILC_MAC_STATUS_DISCONNECTED,
 						  NULL,
 						  hif_drv->usr_conn_req.arg);
=20
@@ -1286,7 +1287,7 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
=20
 	memset(&conn_info, 0, sizeof(struct connect_info));
=20
-	if (mac_status =3D=3D MAC_STATUS_CONNECTED) {
+	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED) {
 		u32 assoc_resp_info_len;
=20
 		memset(hif_drv->assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
@@ -1311,7 +1312,7 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
 	if (hif_drv->usr_conn_req.bssid) {
 		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
=20
-		if (mac_status =3D=3D MAC_STATUS_CONNECTED &&
+		if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED &&
 		    conn_info.status =3D=3D WLAN_STATUS_SUCCESS) {
 			memcpy(hif_drv->assoc_bssid,
 			       hif_drv->usr_conn_req.bssid, ETH_ALEN);
@@ -1331,7 +1332,7 @@ static inline void host_int_parse_assoc_resp_info(str=
uct wilc_vif *vif,
 					  &conn_info, mac_status, NULL,
 					  hif_drv->usr_conn_req.arg);
=20
-	if (mac_status =3D=3D MAC_STATUS_CONNECTED &&
+	if (mac_status =3D=3D WILC_MAC_STATUS_CONNECTED &&
 	    conn_info.status =3D=3D WLAN_STATUS_SUCCESS) {
 		wilc_set_power_mgmt(vif, 0, 0);
=20
@@ -1423,10 +1424,10 @@ static void handle_rcvd_gnrl_async_info(struct work=
_struct *work)
 		mac_status  =3D rcvd_info->buffer[7];
 		if (hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP) {
 			host_int_parse_assoc_resp_info(vif, mac_status);
-		} else if ((mac_status =3D=3D MAC_STATUS_DISCONNECTED) &&
+		} else if ((mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED) &&
 			   (hif_drv->hif_state =3D=3D HOST_IF_CONNECTED)) {
 			host_int_handle_disconnect(vif);
-		} else if ((mac_status =3D=3D MAC_STATUS_DISCONNECTED) &&
+		} else if ((mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED) &&
 			   (hif_drv->usr_scan_req.scan_result)) {
 			del_timer(&hif_drv->scan_timer);
 			if (hif_drv->usr_scan_req.scan_result)
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 76c9012..274c4f6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -162,7 +162,7 @@ void wilc_mac_indicate(struct wilc *wilc)
 	s8 status;
=20
 	wilc_wlan_cfg_get_val(wilc, WID_STATUS, &status, 1);
-	if (wilc->mac_status =3D=3D MAC_STATUS_INIT) {
+	if (wilc->mac_status =3D=3D WILC_MAC_STATUS_INIT) {
 		wilc->mac_status =3D status;
 		complete(&wilc->sync_event);
 	} else {
@@ -624,7 +624,7 @@ static int wilc_wlan_initialize(struct net_device *dev,=
 struct wilc_vif *vif)
 	struct wilc *wl =3D vif->wilc;
=20
 	if (!wl->initialized) {
-		wl->mac_status =3D MAC_STATUS_INIT;
+		wl->mac_status =3D WILC_MAC_STATUS_INIT;
 		wl->close =3D 0;
=20
 		wlan_init_locks(dev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 7b753c1..9038f8c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -470,7 +470,7 @@ static void cfg_connect_result(enum conn_event conn_dis=
conn_evt,
=20
 		connect_status =3D conn_info->status;
=20
-		if (mac_status =3D=3D MAC_STATUS_DISCONNECTED &&
+		if (mac_status =3D=3D WILC_MAC_STATUS_DISCONNECTED &&
 		    conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
 			connect_status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index dc40743..923b07c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -24,9 +24,11 @@
  *
  ********************************************/
=20
-#define MAC_STATUS_INIT			-1
-#define MAC_STATUS_CONNECTED		1
-#define MAC_STATUS_DISCONNECTED		0
+enum {
+	WILC_MAC_STATUS_INIT =3D -1,
+	WILC_MAC_STATUS_DISCONNECTED =3D 0,
+	WILC_MAC_STATUS_CONNECTED =3D 1
+};
=20
 struct tx_complete_data {
 	int size;
--=20
2.7.4

