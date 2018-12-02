Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5127C65BAE
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E74C2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="m4b3GPDv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E74C2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbeLBSDk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:40 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63046 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbeLBSDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:39 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749618"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:37 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjyqwWPOiuuLFRBJNDxq/oE4kuNBiwitMjwx+bMEI88=;
 b=m4b3GPDvayFOYEsgcZLXNhXrOAOXVcFvNo3ft3mLmUtHpJ2FQeuk2y5t6ZdpyvxZlcgoAG0pqjZLZdwp49BNkVBA2h65lSfOYFFncA7TFU3zcP365YO/Q0H0pUW+MT2S74eiuD6N5Vg/LtPKvxMv+Y/ZWb+y1ttAI2kHF7OiEeo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:28 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 26/29] staging: wilc1000: avoid deferred handling of cfg80211
 disconnect callback
Thread-Topic: [PATCH 26/29] staging: wilc1000: avoid deferred handling of
 cfg80211 disconnect callback
Thread-Index: AQHUimlUWxupk3gNuUem1Bfls51OpA==
Date:   Sun, 2 Dec 2018 18:03:28 +0000
Message-ID: <1543773663-20561-27-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:ujpDzSIUFGUM9ZrdnlV71H1Yys2ggk6cNDQv2nnxVGOmFa2S4ayLgLnLwpd3gRlEOuMNiD/XXXoHoUOeKsEABQU8tomcEkT+3oyxCEuPlEZ1JGpvInDpIxboXWgmh1SEYg+n1Syw6x1PHyzKrYxNgzKWPuQbRdOizF5Nta3FLS3NeuptUP14fPXVP4yIg3Tb8kcb11oj3Az+A6ohw+6Ex/R3sKnL1lex5oubNVuqKofTZkbLhOSiUedWFbdoZkRNbbT8noXK6IRPUY6JwUnCTXcWlR2U1gvRVkiTX5OXwdl2sYIKloge6OdJEAEJi7YxNFfSnkUh3Z4Fv12ElJuV9D78Y79e1z9ERx+gy2owAlEtPhPLhzbASDtaMw7wmA5Oa7tGqdrG5TGablVnPf2HHq7zA5nuN1GxYLhhEJZX2sZPogxZHBc3/XWHI+RiZ7MTZifbEmcpyqEoTUqs2a6ejA==;5:P0v0jQrHiwEpaN/WhP1+PEXbq5Ux6ZVfArA+yDa+M8FjRDxkkEdzVz/zjiAtxRBdO3H5O0cPhomnUR4RK9VWCrdYvUiqEP6lsSjAFf5VOVRgTMf6HfLasl30j8N4yHpAYp4I4uAkfeLywRVAhn9rEzYkfUkd0hAVpGYaZBu0xOA=;7:tku5jsU69blY13AR70fzD0gG/LlpQCHkRnR2eqY6WN9zgHjBm5ZSJsr/ish7WnB5bvSYDtY6SIQDfaFQ4pdCJ8+Ei41ODOoazFVGMV0gtziy2rDfyLHD+AKVoymmBtIEFtzcFa4lP3UU1DtR5dcCmg==
x-ms-office365-filtering-correlation-id: 50e3b2bb-22e6-4cf8-827d-08d65880763b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB280659716C0EC51F62F969C1E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: V7rnt+hK9Ab1/4wGddV9VNTsEX3JHpxRRLquSAvgS61V1QLrT9eZU+aX/X1Obna+2FC1t5ulMqZbiS7u6qIrBqrJMfwgr9lh1C7mLKyxFpst2ebBdsASlE/vXKyawHgXXmwFdrIsi1HQr3gF5DWNt82uZ+4rudXubiTq5aN2Tymh7k3HpXHF5OJpUDGiMmF+dpdO+RdIIT2+9mR6P5XRpJaDDdmumXaYuvskn/NCC7etEvA+lXBdLzhQkMhoRxXcAJSJAQtwmm24gu5fzmKx2fT5EbTnvy4f+bHg9rN+6x7oVJ7TYrYpGVC8cAdS/4K9frIlVwRy2uuLE3uD6L1fS5qL9dldWsUFutPhi2o4BS0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e3b2bb-22e6-4cf8-827d-08d65880763b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:28.6987
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

Refactor disconnect operation callback to handle from the cfg80211
context. The reason code is not required to pass as parameter to the
function, so remove it.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 39 +++----------------=
----
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 3 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 7ab46ef..6a908ea 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1241,10 +1241,8 @@ static void handle_rcvd_gnrl_async_info(struct work_=
struct *work)
 	kfree(msg);
 }
=20
-static void handle_disconnect(struct work_struct *work)
+int wilc_disconnect(struct wilc_vif *vif)
 {
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
 	struct wid wid;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	struct disconnect_info disconn_info;
@@ -1263,10 +1261,9 @@ static void handle_disconnect(struct work_struct *wo=
rk)
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send dissconect\n");
-		goto out;
+		return result;
 	}
=20
 	memset(&disconn_info, 0, sizeof(struct disconnect_info));
@@ -1307,10 +1304,7 @@ static void handle_disconnect(struct work_struct *wo=
rk)
 	kfree(conn_req->ies);
 	conn_req->ies =3D NULL;
=20
-out:
-
-	complete(&msg->work_comp);
-	/* free 'msg' in caller after receiving completion */
+	return 0;
 }
=20
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
@@ -1319,7 +1313,7 @@ void wilc_resolve_disconnect_aberration(struct wilc_v=
if *vif)
 		return;
 	if (vif->hif_drv->hif_state =3D=3D HOST_IF_WAITING_CONN_RESP ||
 	    vif->hif_drv->hif_state =3D=3D HOST_IF_CONNECTING)
-		wilc_disconnect(vif, 1);
+		wilc_disconnect(vif);
 }
=20
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
@@ -2012,31 +2006,6 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssi=
d, const u8 *ssid,
 	return result;
 }
=20
-int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
-{
-	int result;
-	struct host_if_msg *msg;
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
-
-	if (!hif_drv) {
-		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
-		return -EFAULT;
-	}
-
-	msg =3D wilc_alloc_work(vif, handle_disconnect, true);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	result =3D wilc_enqueue_work(msg);
-	if (result)
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-	else
-		wait_for_completion(&msg->work_comp);
-
-	kfree(msg);
-	return result;
-}
-
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 {
 	struct wid wid;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 20af5c4..ac4bdfe 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -264,7 +264,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, =
const u8 *ssid,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum authtype auth_type,
 		      u8 channel, void *join_params);
-int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
+int wilc_disconnect(struct wilc_vif *vif);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 045e365..7cc985e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -760,7 +760,7 @@ static int disconnect(struct wiphy *wiphy, struct net_d=
evice *dev,
 	priv->p2p.is_wilc_ie =3D false;
 	wfi_drv->p2p_timeout =3D 0;
=20
-	ret =3D wilc_disconnect(vif, reason_code);
+	ret =3D wilc_disconnect(vif);
 	if (ret !=3D 0) {
 		netdev_err(priv->dev, "Error in disconnecting\n");
 		ret =3D -EINVAL;
--=20
2.7.4

