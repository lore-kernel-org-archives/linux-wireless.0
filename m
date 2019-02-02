Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86C1C282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1D92082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="3uwJHmFx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfBBTRH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:07 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24928 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:07 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="27205811"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:06 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2hqm+zttknyBndraW8EuqEof201oREous2KQ2UKNXw=;
 b=3uwJHmFxoY5xcvZ958qagRQIVp43V2kS2lDHRBq0B35GCfGPp6471ONEnkJXx6DIOCon1ZcnXJYircxYl2l3dnHbFfnkUBLmu1Rilr6vgSKCO8rYN4i9E2qovR+tVTTad+UbPDaWBVc2mWb7ilttSw3euboLScMqeMsmoC9g9A0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 05/15] staging: wilc1000: rename timeout related macros
Thread-Topic: [PATCH 05/15] staging: wilc1000: rename timeout related macros
Thread-Index: AQHUuyvh43ZAN6bCzUudObYJa32wsg==
Date:   Sat, 2 Feb 2019 19:17:05 +0000
Message-ID: <1549134974-5545-6-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:xhe9ZkM6uIa3/DYEUNdL8wVlBBO9Vj1fE0YumL2pV81Osvv5Oa5XJviOMK9I9NSXvxdtxtPIn7Tjb9bOcWh9a+tqkNCE0RY9W0LGkVMf9WID2Pm/4lavlqweYPWnIF5Wd0Zggt5qdpROFbk2fd3e7IkOSQTu/53NHdtPiOSTzwq//umDEHuQbQriSTVuxlZRDORPoaw78EL/Soi5NUJHwhgfuvpbWbP5wUz7nm3Xitx0GPoq8FgzkIT8SCeQLdf9GfM3mPzpPq7Su0lrxcucVVO4PSVM/+JoA5bx5COUAj6GAVP8wTWvcucUEYky+tmz13DHrZAxHDpJJLij3iLNIdrI0hq6dfkK1nZPQ+EbzYtgJZbVnDfAE0C2mbDY4VTqSGljLAjNX201efeegUhCK2CDtk3KV6SDR8xPzbFYsCGju0lC5DDAlmlU4Yhs9QjB/8v4Zj9uxtxUZY2UMssRSg==;5:0SobPl0hTsZJJRQ81vaM+s7s+FJk/F6H4ijdussgmuUXfEDiuzetqTqW6j6AStK5xGepqmlnyOG11T6SbxTGqy6RynkEaMGB0Q7ygpULdJQ/qww4DxDAvpj+MUQy7d/OUQc2vZPAFGDOM/IwzfOppX/JryUnaXwxrA7NaRtrhDsfzhScbluw5gURTIm/BY4VvmTGYf83mQPy7wPsV2AggA==;7:01WYJ5iXCw+rKpwAKEyQmgEZ5fxxj/BdEquusLFSIVnvYP4qtvrnYW1IV0JitS5FVO1PI4jvG/yIKWi85cHLKPHfNptRR8SCZ7hR7t7Rnwc3bliHT+U/oupWIjrnpQbqrFcCDcrfC9FYJvqE8yyqqQ==
x-ms-office365-filtering-correlation-id: 1d85a612-3ff4-42fb-8207-08d689430429
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998B0828B64922C9B8A912EE3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ucj7kPWclol5llhr33NbQs0ydrP+l/Rpy93zEsgrcsdjLgvLpT0tyFKw4iQikivTY4Eo9ndVT/IaqRylbX3lxBVRteN3urFXai8yPeLSELSjdnkyyBxxWJ/0dqtcZPTqIR4DBrxNA8jhml2Dux1xs2bR8NyFw1vHSTKeWQMZRppcnzghAqutCxetLAek6NRzLpNyCRhqkdLiyux/WsSk1UaI+JG+wTvqMN6qbvg0EOy2nvbQl0mjLAkTXg/TK2Oxf3R1rrWevzwo8qbNVNk01ZbCVTJjYKobmoxRtVrErOLWdvE3yrnx2ConEgIj+j04blgeVJVaQtzcccm325+ZDLZFOtKEx2lh+6prBqOyGRPAOPjNfDiy4YhWBOF5kspdBWhj5xjpgUP6R8Oih4JRZo2ZDUGUxQI2f3V1uXO7AE8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d85a612-3ff4-42fb-8207-08d689430429
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:02.4912
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

Rename timeout related macros to have their unit clear from their name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c              | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h              | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index e958f9b..3576834 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6,8 +6,8 @@
=20
 #include "wilc_wfi_netdevice.h"
=20
-#define HOST_IF_SCAN_TIMEOUT                    4000
-#define HOST_IF_CONNECT_TIMEOUT                 9500
+#define WILC_HIF_SCAN_TIMEOUT_MS                4000
+#define WILC_HIF_CONNECT_TIMEOUT_MS             9500
=20
 #define FALSE_FRMWR_CHANNEL			100
=20
@@ -327,7 +327,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 =
scan_type,
 	hif_drv->usr_scan_req.arg =3D user_arg;
 	hif_drv->scan_timer_vif =3D vif;
 	mod_timer(&hif_drv->scan_timer,
-		  jiffies + msecs_to_jiffies(HOST_IF_SCAN_TIMEOUT));
+		  jiffies + msecs_to_jiffies(WILC_HIF_SCAN_TIMEOUT_MS));
=20
 error:
 	if (search) {
@@ -1442,7 +1442,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid=
, const u8 *ies,
=20
 	hif_drv->connect_timer_vif =3D vif;
 	mod_timer(&hif_drv->connect_timer,
-		  jiffies + msecs_to_jiffies(HOST_IF_CONNECT_TIMEOUT));
+		  jiffies + msecs_to_jiffies(WILC_HIF_CONNECT_TIMEOUT_MS));
=20
 	return 0;
=20
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index cd3df42..95230d7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -72,7 +72,7 @@ static u8 curr_channel;
 static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
=20
-#define DURING_IP_TIME_OUT	15000
+#define WILC_IP_TIMEOUT_MS		15000
=20
 static void clear_during_ip(struct timer_list *t)
 {
@@ -1489,7 +1489,7 @@ static int change_virtual_intf(struct wiphy *wiphy, s=
truct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 		vif->obtaining_ip =3D true;
 		mod_timer(&vif->during_ip_timer,
-			  jiffies + msecs_to_jiffies(DURING_IP_TIME_OUT));
+			  jiffies + msecs_to_jiffies(WILC_IP_TIMEOUT_MS));
 		wilc_set_operation_mode(vif, WILC_AP_MODE);
 		dev->ieee80211_ptr->iftype =3D type;
 		priv->wdev->iftype =3D type;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index 58bcdc1..7a757c9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1141,7 +1141,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start=
, u16 wid, u8 *buffer,
 		ret_size =3D 0;
=20
 	if (!wait_for_completion_timeout(&wilc->cfg_event,
-					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+					 WILC_CFG_PKTS_TIMEOUT)) {
 		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
 		ret_size =3D 0;
 	}
@@ -1179,7 +1179,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start=
, u16 wid, int commit,
 		ret_size =3D 0;
=20
 	if (!wait_for_completion_timeout(&wilc->cfg_event,
-					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+					 WILC_CFG_PKTS_TIMEOUT)) {
 		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
 		ret_size =3D 0;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc100=
0/wilc_wlan.h
index 3880452..1d61e20 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -196,7 +196,7 @@
 #define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
 #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
 /*time for expiring the completion of cfg packets*/
-#define CFG_PKTS_TIMEOUT	2000
+#define WILC_CFG_PKTS_TIMEOUT	msecs_to_jiffies(2000)
=20
 #define IS_MANAGMEMENT		0x100
 #define IS_MANAGMEMENT_CALLBACK	0x080
--=20
2.7.4

