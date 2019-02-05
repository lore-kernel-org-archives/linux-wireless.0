Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A37C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 126622081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="iNMi6ybn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfBEHPi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:15:38 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:26915 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfBEHPi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:15:38 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26323434"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:15:36 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:15:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1WWZYGDmRKXz3PeI8SMpZsWBdDRoH9uwZ21MP/Xryo=;
 b=iNMi6ybnLe36d63IynbK9S7rKtagPsYzGVd8UHOP4FWYoEPvb042WV8ba2TF/istUQbDoHRPzTCl+p9NThpBE0O0I1W2QcNy8pFJcWBXraGkCT0wVoclFzBAtx9VstJux2T2Ui/3pedjjkjhhkRJ29QuKGmZD16A7R7pgSkZoRM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2982.namprd11.prod.outlook.com (20.177.224.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:15:34 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:15:34 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 02/12] staging: wilc1000: refactor
 linux_wlan_init_test_config()
Thread-Topic: [PATCH 02/12] staging: wilc1000: refactor
 linux_wlan_init_test_config()
Thread-Index: AQHUvSKWR872PpjXs0GEuJlT8N3L4w==
Date:   Tue, 5 Feb 2019 07:15:34 +0000
Message-ID: <1549350913-645-3-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2982;6:v2FbyrZa3YjDDCyIm9r1pKohNBQ1APiHL1Uz4Guf6ouZIyH76w1BqKjdEm9OYEeayJYDzGCGb11iikkfy5LoFW7dM3oGv7bjNeKnIgBEk208fACiEKOZnKNYlvDTKw9VIzPBaql/qCTD6S12TOfG5SJuJDLPnAqVS+ck1QNxPcdfWlQR+d02ewNN6zJ3UxwkLNqCfvVF2lQRg3TVwFdg4tcyTm3zwRhRRJuPGF206XbS2r6ykdgiDO/twzNcaasahCYluxDcLNOM3b7tXobaOgpXhHlxo+QHNN0wSX//7AZXS87BWuzb/e+KzCqJHETCpCEq4XICEVYZUVqwQnlIx1WqLhBofHVggq0MOJ1CnEqD4KiD3R+DyJ8a2As+dmnc0MoAEcKlUJ363qtcTA1Zk3OjvcgxDRvwaw9OYT8ulV5SfC6D5XbsmFYkWLwpeEbclRD3hqVmD2kHojoz0qZqbA==;5:BCY5C0IWYHzzUlcm/CNHYGrJLarkTM1UCX/B0nFkBb6Ivtrv33UzJOKZifER4oEMvDyl9xOdnMR/kCEcEvuAfLkXSm3IyXzGULC7a1f1R2pw/gAEoTRUrK6a5n5l1fa6kpFidp1TtiUgTwO6Udk18F/T9L9DlM7E3ARVWBEHwhofggNxtbPnKfzwIGn6QY7ypO0ZpvVpagyOmAx8DZXerQ==;7:BXRskpuT/1p0UpeCJrme1yRvDi8B7Z0qzqsxaG731vYnwtahAJZonyxPgMa8IkIK/txl/q6mtiIrcXcif/6lhqXIxL/1qixS7oFWarUZ4XFNgwaeelt1qs+sYJgZFCSbFx0kJEl1KdF3OMA72rerkQ==
x-ms-office365-filtering-correlation-id: b5a58acc-b717-4507-3321-08d68b39b865
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2982;
x-ms-traffictypediagnostic: BYAPR11MB2982:
x-microsoft-antispam-prvs: <BYAPR11MB2982A8C49AE1FEF0CCC134A4E36E0@BYAPR11MB2982.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(478600001)(36756003)(305945005)(102836004)(6486002)(81156014)(76176011)(81166006)(71190400001)(5640700003)(6436002)(186003)(14454004)(99286004)(52116002)(11346002)(386003)(446003)(26005)(2616005)(476003)(256004)(8676002)(6512007)(14444005)(316002)(6506007)(2906002)(53936002)(54906003)(3846002)(4326008)(25786009)(2351001)(106356001)(6116002)(7736002)(486006)(86362001)(2501003)(68736007)(50226002)(66066001)(97736004)(107886003)(105586002)(72206003)(78486014)(71200400001)(8936002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2982;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vtal9o9tQvkP8HQok3wboPVBK+ikpqhWsVDJHUApD8OrRS5lf2qbUriqOMUY7gWX7irlY/pP0xh0BD9LFGeGF752QyRflP5RjgOD5ix7PWlGFZbEA2iHpEMzvDJndgjboJy5mmbS4iGaemCeEJKL9uSp8xATClPcJmq1xo/7F3x34ipyOGZ/R1il9QkAeQCgKOhZ+/QKDBfIu0L9UNoRbA89c/sgXlwVpeBZQIQpg4bdCprJxaroXsjtKFUTalMM/ppTDQ+1RGdYOB4I9WYk1Jg/tYtFB4SHnHbi5POjf/69u+hsPZz1C5lwSXj3k+wQB8TLFkSlglSpU2iE2q+yZs59IIo6epOHeAg7pY/9GfFhUF1ByVKWiJYi+Gtp64cJ/+KdlxbJ4gzviNwXnW+PJkX8mrJsJFjL4tseG+U0ngM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a58acc-b717-4507-3321-08d68b39b865
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:15:32.2917
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

Refactor linux_wlan_init_test_config() to use correct endianness for wid
values and remove unnecessary code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 200 +++++++++++++---------------=
----
 drivers/staging/wilc1000/wilc_wlan_if.h |   1 -
 2 files changed, 83 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 81472d2..86a38f1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -304,204 +304,170 @@ static int wilc1000_firmware_download(struct net_de=
vice *dev)
 	return 0;
 }
=20
-static int linux_wlan_init_test_config(struct net_device *dev,
-				       struct wilc_vif *vif)
+static int linux_wlan_init_fw_config(struct net_device *dev,
+				     struct wilc_vif *vif)
 {
-	unsigned char c_val[64];
-	struct wilc *wilc =3D vif->wilc;
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
+	u8 b;
+	u16 hw;
+	u32 w;
=20
 	netdev_dbg(dev, "Start configuring Firmware\n");
 	priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
 	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
 	netdev_dbg(dev, "Host =3D %p\n", hif_drv);
-	wilc_get_chipid(wilc, false);
-
-	*(int *)c_val =3D 1;
-
-	if (!wilc_wlan_cfg_set(vif, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
-		goto fail;
-
-	c_val[0] =3D 0;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
-		goto fail;
-
-	c_val[0] =3D WILC_FW_BSS_TYPE_INFRA;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
-		goto fail;
-
-	c_val[0] =3D WILC_FW_TX_RATE_AUTO;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
-		goto fail;
-
-	c_val[0] =3D WILC_FW_OPER_MODE_G_MIXED_11B_2;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
-			       0))
-		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
-		goto fail;
-
-	c_val[0] =3D WILC_FW_PREAMBLE_SHORT;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, c_val, 1, 0, 0))
+	w =3D vif->iftype;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 1, WID_SET_OPERATION_MODE, (u8 *)&w, 4,
+			       0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_11N_PROT_AUTO;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	b =3D WILC_FW_BSS_TYPE_INFRA;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_ACTIVE_SCAN;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	b =3D WILC_FW_TX_RATE_AUTO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_SITE_SURVEY_OFF;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	b =3D WILC_FW_OPER_MODE_G_MIXED_11B_2;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, &b, 1, 0, 0))
 		goto fail;
=20
-	*((int *)c_val) =3D 0xffff;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	b =3D WILC_FW_PREAMBLE_SHORT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, &b, 1, 0, 0))
 		goto fail;
=20
-	*((int *)c_val) =3D 2346;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	b =3D WILC_FW_11N_PROT_AUTO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 0;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	b =3D WILC_FW_ACTIVE_SCAN;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	b =3D WILC_FW_SITE_SURVEY_OFF;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_NO_POWERSAVE;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	hw =3D 0xffff;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_RTS_THRESHOLD, (u8 *)&hw, 2, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_SEC_NO;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, c_val, 1, 0, 0))
+	hw =3D 2346;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_FRAG_THRESHOLD, (u8 *)&hw, 2, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_AUTH_OPEN_SYSTEM;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BCAST_SSID, &b, 1, 0, 0))
 		goto fail;
=20
-	strcpy(c_val, "123456790abcdef1234567890");
-	if (!wilc_wlan_cfg_set(vif, 0, WID_WEP_KEY_VALUE, c_val,
-			       (strlen(c_val) + 1), 0, 0))
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, &b, 1, 0, 0))
 		goto fail;
=20
-	strcpy(c_val, "12345678");
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0,
-			       0))
+	b =3D WILC_FW_NO_POWERSAVE;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, &b, 1, 0, 0))
 		goto fail;
=20
-	strcpy(c_val, "password");
-	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1),
-			       0, 0))
+	b =3D WILC_FW_SEC_NO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 192;
-	c_val[1] =3D 168;
-	c_val[2] =3D 1;
-	c_val[3] =3D 112;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	b =3D WILC_FW_AUTH_OPEN_SYSTEM;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 3;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	b =3D 3;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_LISTEN_INTERVAL, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 3;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	b =3D 3;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_ACK_POLICY_NORMAL;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	b =3D WILC_FW_ACK_POLICY_NORMAL;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 0;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1,
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_USER_CONTROL_ON_TX_POWER, &b, 1,
 			       0, 0))
 		goto fail;
=20
-	c_val[0] =3D 48;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0,
-			       0))
+	b =3D 48;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11A, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 28;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0,
-			       0))
+	b =3D 28;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11B, &b, 1, 0, 0))
 		goto fail;
=20
-	*((int *)c_val) =3D 100;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	hw =3D 100;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, (u8 *)&hw, 2, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_REKEY_POLICY_DISABLE;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	b =3D WILC_FW_REKEY_POLICY_DISABLE;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, &b, 1, 0, 0))
 		goto fail;
=20
-	*((int *)c_val) =3D 84600;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	w =3D 84600;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PERIOD, (u8 *)&w, 4, 0, 0))
 		goto fail;
=20
-	*((int *)c_val) =3D 500;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0,
+	w =3D 500;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PACKET_COUNT, (u8 *)&w, 4, 0,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0,
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SHORT_SLOT_ALLOWED, &b, 1, 0,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_ERP_PROT_SELF_CTS;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	b =3D WILC_FW_ERP_PROT_SELF_CTS;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_11N_OP_MODE_HT_MIXED;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
-			       0))
+	b =3D WILC_FW_11N_OP_MODE_HT_MIXED;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0,
-			       0))
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_TXOP_PROT_DISABLE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
+	b =3D WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, &b, 1,
 			       0, 0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_HT_PROT_RTS_CTS_NONHT;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	b =3D WILC_FW_HT_PROT_RTS_CTS_NONHT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 0;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0,
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_RIFS_PROT_ENABLE, &b, 1, 0,
 			       0))
 		goto fail;
=20
-	c_val[0] =3D WILC_FW_SMPS_MODE_MIMO;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
-		goto fail;
-
-	c_val[0] =3D 7;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0,
-			       0))
+	b =3D 7;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_CURRENT_TX_MCS, &b, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D 1;
-	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1,
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_IMMEDIATE_BA_ENABLED, &b, 1,
 			       1, 1))
 		goto fail;
=20
@@ -671,7 +637,7 @@ static int wilc_wlan_initialize(struct net_device *dev,=
 struct wilc_vif *vif)
 			firmware_ver[size] =3D '\0';
 			netdev_dbg(dev, "Firmware Ver =3D %s\n", firmware_ver);
 		}
-		ret =3D linux_wlan_init_test_config(dev, vif);
+		ret =3D linux_wlan_init_fw_config(dev, vif);
=20
 		if (ret < 0) {
 			netdev_err(dev, "Failed to configure firmware\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index 9370caa..26aad49 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -686,7 +686,6 @@ enum {
 	WID_TX_POWER_LEVEL_11N		=3D 0x00B1,
=20
 	/* Custom Character WID list */
-	WID_PC_TEST_MODE		=3D 0x00C8,
 	/* SCAN Complete notification WID*/
 	WID_SCAN_COMPLETE		=3D 0x00C9,
=20
--=20
2.7.4

