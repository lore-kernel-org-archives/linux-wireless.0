Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30766C0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFBC8205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="rlgB+5FA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFBC8205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbeKBBtE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:49:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19769 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbeKBBtD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:49:03 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="22208926"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:18 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eefh+zwZpaJLvk//k7a5ZFH5GL8tPXx1xsCoJgURr7o=;
 b=rlgB+5FAlFUGXy8w0d2b5BBhBmjYwSDmGdtiIR9YJcmq6MJbN5+0Bl5p01CNCEm0WqnllCd+RJafq6patfw69xULoYX/9a+8x4Q19tt6iOuuZAN3mWBg5jGwE6FAYhkEW4Di/HC/g+6ub0aArH27qNY2qhGpsbYVxp7QkspHhS0=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2582.namprd11.prod.outlook.com (52.135.227.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Thu, 1 Nov 2018 16:45:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 5/8] staging: wilc1000: refactor wilc_parse_assoc_resp_info()
Thread-Topic: [PATCH 5/8] staging: wilc1000: refactor
 wilc_parse_assoc_resp_info()
Thread-Index: AQHUcgJE/ENI2Pb1Z0W0rDNFVbNqvA==
Date:   Thu, 1 Nov 2018 16:45:17 +0000
Message-ID: <1541090691-31928-6-git-send-email-ajay.kathat@microchip.com>
References: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1541090691-31928-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0138.apcprd06.prod.outlook.com
 (2603:1096:1:1f::16) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [49.205.219.12]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2582;6:WlXfGMErROiRYpcXXhv0P+4DLIE2IPLoTyz6sAV9HWLXX21P3ZPdq15xh+LrjvUnlXXTVXprpIJ9cPqoUJlAXJWlDL93TEYW1cLclCH5t5fwhAFQuGGF2GnJ/Men+WSK4iMUn9RpfIm+Lagka5gvW9Zdv/tnPJ3h3qoJ9jQLvBPJly09CtL9yKMgMed0uJZpqY4k4ZNw2qj2lRbtK558nZXrnb1dsEoVmj+/S9MkK5Zk6QseleiyNgIiGhEUV73ikG3FjD5sEXIf1HGm1kosQWDYk+4Nml2simsRAOhD/7Ze6qEcZkObanUoz8VkOy7bseYkK4Gk+qbAfNOBM6n8LwLosH1Xu+XPvrzgW+Fnm1pUQIKBT18PcNFbn/meS0HeKb97OgQZzfVs8nME6XGBy/sZIL3kr+pjgtSER2U3DCgVvSkqVYfq+dbBTUGuoHVDXWTM/Fx474212lgNBzV6Hw==;5:ukqoWBsGHF4UHQ7FusZEgd+JsnJP8q2TFpdsJowi4xOCv2GfiATLCyUdXLDDfdbK6AZoEzGkPtUb8LCgWtMblqIxZhBhHuklNGieCDhtB0g8pOAxVpKQCHkJF68dHX78VGToiIDaMdMSVm6dKzB8x+aktlOtt2HTuKFI4cQACgE=;7:qONH0xHca7GUe0ycpW0fmUm1WsTlmgYtfM2hed9qN9+y6h7ZTLhs+7lDD1ebyNsCHss8JO7mCcS+nbwy3yrZxDItf4RxsgeFx49P+1aHf2xQljzze7I8gqJphtH7/8UAM+4Mx99SdaH+oxdO5WLffw==
x-ms-office365-filtering-correlation-id: 299a9401-74e5-49a2-e5da-08d640196714
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2582;
x-ms-traffictypediagnostic: BYAPR11MB2582:
x-microsoft-antispam-prvs: <BYAPR11MB25827BF927AD5ADADA7A9870E3CE0@BYAPR11MB2582.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2582;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2582;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(366004)(39860400002)(199004)(189003)(68736007)(6916009)(8936002)(7736002)(2906002)(81166006)(81156014)(186003)(3846002)(6116002)(4326008)(5660300001)(54906003)(26005)(316002)(86362001)(2900100001)(476003)(36756003)(107886003)(25786009)(446003)(11346002)(66066001)(486006)(8676002)(305945005)(78486014)(5250100002)(2616005)(386003)(6506007)(102836004)(2351001)(53936002)(97736004)(72206003)(14454004)(478600001)(6486002)(71200400001)(71190400001)(6436002)(52116002)(106356001)(105586002)(5640700003)(256004)(76176011)(6512007)(99286004)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2582;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nNkgOW5Cal022HPDbkZrlJzlcjJWjMBtcJOU/DFOfz9T3RK0cE46FA2XTCy1v+VoQp+oTS0owdDPqPYYKi+lpLjIK7Xx1603nRVHJ32c60l9E2epnbvRGjZbBx44jA5Hf797WDCy7/aX6zHuxQ4bHPWJGINc0nTG0A/UBEeMRIJr9lWN5ZdaRWgIOpkwraRK0cC4u1zYcOJPDpxzFiuPhv+RvalhBfXlZxFSBBhj2kbqzlDC66EWCzDAnWk1Xuvj4VVAceIil5/FAhjxiST5rVK+UnAVYH7+nmNVTTdVPZFxyNoZTazyV9exttbBwBN9uyjH4VNUaxm/uGrJUt8O5+alyF6NLoc7hXhZYVqETK0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 299a9401-74e5-49a2-e5da-08d640196714
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:17.0779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2582
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor wilc_parse_assoc_resp_info() function by removing the use of
get_asoc_status() API. For parsing assoc response use the struct and
avoided the use of offset macros to extract the ies information.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 16 ++++------------
 drivers/staging/wilc1000/coreconfigurator.h | 10 ++++++----
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
index 2c77e5a..2bd62fd 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -18,14 +18,6 @@ static inline u8 *get_bssid(struct ieee80211_mgmt *mgmt)
 		return mgmt->bssid;
 }
=20
-static inline u16 get_asoc_status(u8 *data)
-{
-	u16 asoc_status;
-
-	asoc_status =3D data[3];
-	return (asoc_status << 8) | data[2];
-}
-
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info)
 {
@@ -116,12 +108,12 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer=
_len,
 {
 	u8 *ies;
 	u16 ies_len;
+	struct assoc_resp *res =3D (struct assoc_resp *)buffer;
=20
-	ret_conn_info->status =3D get_asoc_status(buffer);
+	ret_conn_info->status =3D le16_to_cpu(res->status_code);
 	if (ret_conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
-		ies =3D &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
-		ies_len =3D buffer_len - (CAP_INFO_LEN + STATUS_CODE_LEN +
-					AID_LEN);
+		ies =3D &buffer[sizeof(*res)];
+		ies_len =3D buffer_len - sizeof(*res);
=20
 		ret_conn_info->resp_ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
 		if (!ret_conn_info->resp_ies)
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/=
wilc1000/coreconfigurator.h
index 0d40c77..71a9f27 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -11,10 +11,6 @@
=20
 #define NUM_RSSI                5
=20
-#define CAP_INFO_LEN            2
-#define STATUS_CODE_LEN         2
-#define AID_LEN                 2
-
 #define SET_CFG              0
 #define GET_CFG              1
=20
@@ -63,6 +59,12 @@ struct disconnect_info {
 	size_t ie_len;
 };
=20
+struct assoc_resp {
+	__le16 capab_info;
+	__le16 status_code;
+	__le16 aid;
+} __packed;
+
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
--=20
2.7.4

