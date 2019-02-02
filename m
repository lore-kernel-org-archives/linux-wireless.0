Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22E2C282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D8D92082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="SNBSJdu1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfBBTRN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:17:13 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:13178 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfBBTRN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:17:13 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="24160773"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Feb 2019 12:17:13 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:17:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuZm38XjAIJa1U3CtiEen0JGVox+w39IAh8UT7FahIg=;
 b=SNBSJdu1DtoUrk3nPqSOPQ3/Kaevm93/67dEwFrin8qL68VZtU2ChHUEgziyPytze56czCKAPTg8cZtmcyW9BHkWA0hH6Tks+z5hXNIp8Z3jONT+rZMCzWyOLspOmqAfFh04nF0qp44KbBEfkejGsPoC6KT+rnwssusSAz74EdQ=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:17:10 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:17:10 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/15] staging: wilc1000: refactor scan() cfg80211 ops
 callback
Thread-Topic: [PATCH 07/15] staging: wilc1000: refactor scan() cfg80211 ops
 callback
Thread-Index: AQHUuyvlJ6DL9tLBCEKIKxEqObc91g==
Date:   Sat, 2 Feb 2019 19:17:10 +0000
Message-ID: <1549134974-5545-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:i1b+wz3bSWuSLci5ldnPRSkG7qs73zMutHQ5NBWRwHSzVLDrgvGUGaCrLsgA2qu3KEaIIUcARQVHX2JtgMd6iOMGxJaCbOMvcitf4Zw+muyNlM9KhUaSvsKx2feyGmqa7qN3PE1n2vpVTzLxyLpMHiPmo1ZrSovi9x9MpweBWInDpSZ1hYWbYrwBHs0pawUE3Y1Br6Jzu9bEyAA2p53c7489V4Cf6GrHiNVpLEQ9LzOk2XFYvOsslHHd96RiVhs+GZJpBPlCFr+BEu5wyNYEff2azTOGhC7ziX1+p2/1iFgl4d4EOCTX2bMDFAKIW9NsRf+8Qnszl2rem8QFerSbeN5ecI/2ydlRWt9suG7E0DECWXFKksSlpjuye+t/2X0UXIwrl4sVqjKlYULJ6BChUs8e0Swhq51vfvY2LseD1+tDZSNWYaYN5VpLkrUfw3h7FPXFdvxHyP7c7jNypX6X9w==;5:S34oAyB8BsRtOimyUG4LFNeaULc/Bc6lgYQliJnNrJEcxyZY4hOn1F2/EjXqGT6lyb4EG1FuMWyzSdjtsX+zH23+F6g9eYLdrZm3VNRa8/AQYU3z6qTMbsWEOBscKyFSr7XLcgDpCN2YjMIbg+EyIkz3+GQYIrUudGHKzGh90WuKyOcCq+Ly61AQYIuLakY0SsaZCpvSTdLTa8mA9FQEgQ==;7:/NzFiCkq+HM16B1XzkgswV10is6apiSo4An732LkCh5o7agutZc8xSzE0Sc18lJInSCHsbM9RyZMC4dsh2gbTk1+WjvnkEpBk4GCuz9QPHPGcxsMkKPPmJhwRyctM5hmUI6B5m90bB5sOSqS2TqMkw==
x-ms-office365-filtering-correlation-id: a790b9e1-3bad-4ee1-ad8f-08d6894307a9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB299822900578EC2D62348B75E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hSQJOObh2Z4xDM08ITlYXscETcxj9coePIvi4T7rV2thZ/NvmWFyU4r8nfbh7PP33fQ5kwmA94TEeKOMCzbV33CPCALUqLBIPsaWGjkGduNhbLqkCjxGnMXc4ciGokxruqIMecE9ZQxTfnflFXhg5FTT36ieNaY9C0lFfvl6oHeTIHhnMBclqQLpyUPqT7VApE/Fgn1XeThQ84ShcXBZ6Vl3/yYScnc7ioDqAtsuyfMB9HFQh2sqrR6BGdk8Rkn+ZidzfVpJSObLToID1BhnDFMqb9vfvnLoXu5aVEg0DzD2CRZ9mWQsuAJLt8ebeTp3oTnArig6z5onczqlmqyduNMrL4F5gFS5Cs9bRj83stG+yoy18d0fGUMLtGyCJo4KxH3wwCgZoBdJTcXoHRqR6l/eOYaSZC2LfV+BXX/YDbA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a790b9e1-3bad-4ee1-ad8f-08d6894307a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:17:08.3133
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

Refactor scan() cfg80211 callback function and use correct value for
valid channel number limit.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 55 +++++++++++--------=
----
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 8fa97a7..0feb63f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -18,7 +18,7 @@ enum {
 };
=20
 #define WILC_MAX_NUM_STA			9
-#define MAX_NUM_SCANNED_NETWORKS		100
+#define WILC_MAX_NUM_SCANNED_CH			14
 #define WILC_MAX_NUM_PROBED_SSID		10
=20
 #define TX_MIC_KEY_LEN				8
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index faffcc8..08b60ddd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -266,42 +266,41 @@ static int scan(struct wiphy *wiphy, struct cfg80211_=
scan_request *request)
 	struct wilc_vif *vif =3D netdev_priv(priv->dev);
 	u32 i;
 	int ret =3D 0;
-	u8 scan_ch_list[MAX_NUM_SCANNED_NETWORKS];
+	u8 scan_ch_list[WILC_MAX_NUM_SCANNED_CH];
 	struct wilc_probe_ssid probe_ssid;
=20
-	priv->scan_req =3D request;
+	if (request->n_channels > WILC_MAX_NUM_SCANNED_CH) {
+		netdev_err(priv->dev, "Requested scanned channels over\n");
+		return -EINVAL;
+	}
=20
+	priv->scan_req =3D request;
 	priv->cfg_scanning =3D true;
-	if (request->n_channels <=3D MAX_NUM_SCANNED_NETWORKS) {
-		for (i =3D 0; i < request->n_channels; i++) {
-			u16 freq =3D request->channels[i]->center_freq;
-
-			scan_ch_list[i] =3D ieee80211_frequency_to_channel(freq);
-		}
+	for (i =3D 0; i < request->n_channels; i++) {
+		u16 freq =3D request->channels[i]->center_freq;
=20
-		if (request->n_ssids >=3D 1) {
-			if (wilc_wfi_cfg_alloc_fill_ssid(request,
-							 &probe_ssid)) {
-				ret =3D -ENOMEM;
-				goto out;
-			}
+		scan_ch_list[i] =3D ieee80211_frequency_to_channel(freq);
+	}
=20
-			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
-					WILC_FW_ACTIVE_SCAN, scan_ch_list,
-					request->n_channels,
-					(const u8 *)request->ie,
-					request->ie_len, cfg_scan_result,
-					(void *)priv, &probe_ssid);
-		} else {
-			ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
-					WILC_FW_ACTIVE_SCAN, scan_ch_list,
-					request->n_channels,
-					(const u8 *)request->ie,
-					request->ie_len, cfg_scan_result,
-					(void *)priv, NULL);
+	if (request->n_ssids >=3D 1) {
+		if (wilc_wfi_cfg_alloc_fill_ssid(request, &probe_ssid)) {
+			ret =3D -ENOMEM;
+			goto out;
 		}
+
+		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+				WILC_FW_ACTIVE_SCAN, scan_ch_list,
+				request->n_channels,
+				(const u8 *)request->ie,
+				request->ie_len, cfg_scan_result,
+				(void *)priv, &probe_ssid);
 	} else {
-		netdev_err(priv->dev, "Requested scanned channels over\n");
+		ret =3D wilc_scan(vif, WILC_FW_USER_SCAN,
+				WILC_FW_ACTIVE_SCAN, scan_ch_list,
+				request->n_channels,
+				(const u8 *)request->ie,
+				request->ie_len, cfg_scan_result,
+				(void *)priv, NULL);
 	}
=20
 out:
--=20
2.7.4

