Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C58C43610
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A28321527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Ndx3c4uz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A28321527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbeKLPhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:05 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20241 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:05 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="20255117"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:25 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rtk/jJxbqZeEVvgYuNk/7RkZRjGzoGb1PngjnBTR8Dg=;
 b=Ndx3c4uzXsLcrh3gaXDQHDLq2N5u0h4XGzwPa8g35xTF5RtHl2WzDBLNxZE5Z30N6JQXTMYGQk/tpdgt6YYRRWwjkPj2k9/zPEyDbBYczWSSL01zDK6Ah+qEzJ21AXLlZ8XUuhTseZIxJ4c0qJMCQ5E1yLtv0KVcQclGwKsVeXs=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:23 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:23 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 08/12] staging: wilc1000: move current_tx_rate enum to
 wilc_wlan_if.h file
Thread-Topic: [PATCH 08/12] staging: wilc1000: move current_tx_rate enum to
 wilc_wlan_if.h file
Thread-Index: AQHUekrnIwzI7H2ssEWuH+WDdGOmLw==
Date:   Mon, 12 Nov 2018 05:45:23 +0000
Message-ID: <1542001458-20217-9-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:MDYrfXve7+9y3UT72gNoVYLXRmyqiEwPzw/z7Xw8ni/XrfdgeVsRK5XgoHS5qqpvHK90FphKzuXxE83snusWucZy66EN7ru7i9Ylmv9SV99H7Fhv6XRYQTh0BbyBPzlC58pI/JUojmjz4NT11BxQl/MBb2voOVDR+6fCkdI0QaCnJ+IotRxtZ3xspCZPIE2KYURT+OKdAbOjJi7UknKoBFp8Pjbk/iyQ8/plWUjKfHzZ8PpWrGh2nh7N9uxvNmk6OP4M7QC2VZXcqB3UG1VRBJGAXluGtw5aP8yjDEpZ6m7Lz3x36H88yV+hSp3SVyipKEBus4yZ2y008cp4YZ83SeowHHj77PTzHOWalXepQMtMhyZX0qYE3wH8JFJX90t45bEzPLay1xguGCctgrXMKU4GtVGXz3OPVvZ815c4Yj8dsncq7L6US/fFvHz+9Wa/SwFV0Imt2K2lU3MdMhM2WA==;5:nnLDN8axx7SeRLTk7fWy1RM4gXOiHF/Mnepe/VIfK6NOGhkBdG0trTJc+4iusYafDxKYYlZJODLGHqjGQuIaUxiD2d9OPNhtfHAtg9QnBYjad/1C7oBODjycgWqVv7ADP2lc0x95fswiXKnRDP1WvGYaivImVrfq2DCl4ILV1ko=;7:d69S7eSeoPfGg83iYWLCuHAHNQ2fhYBlN1OnjNQMxUSTMmUjdAo1b06PLeWYMJ/Ffeznv06PjXYyla3Foix/rVYOMuZxDE1YksK8dofjPGEwjAHy3i5V0lEfFEIvLjLnhNivlezasBiG+y80zTqyDA==
x-ms-office365-filtering-correlation-id: ae660515-3e52-4e0a-b63f-08d648620a16
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599819DCB99FB4881C4993DE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: WeL3SQR9Ll+bsRbMiSlxGoM0ae9XJWKwNxRT6VzrFOENIuKZDFKyDT0gMCduRuloZSeJzn91lQEsVSYUIamVuZTOm8wLcHXMrSmF+AvtDxThxcJnbJGoBYHTjYLioXClWam6rv01UEh4PDbh1EdR6FJnougu+6M+4LFJpAWAWjsZF3tigx702mzr1lmFSAF4d8duVdw4pNQQmePQG1oDFtir8LRbcw7XKVKtwLOmy3nfhYKhjA4HGWRvMpq/NCvvK9708Sy96tiO4XnUPrVbtci47KhWXgu9Wy73PvAxU/90ZzBPvqlA2nDgPauA4hpHqzAO39+DgjDHEfKa5JiaT7QrdKwsC1CbAx7y+G5Q2o0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ae660515-3e52-4e0a-b63f-08d648620a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:23.5050
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

Move 'current_tx_rate' enum to wilc_wlan_if.h, to have it along with the
other FW related to constants. Also added prefix to have a better
namespace.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h | 16 ----------------
 drivers/staging/wilc1000/linux_wlan.c     |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 16 ++++++++++++++++
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index fefbce6..91e60e3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -127,22 +127,6 @@ struct host_if_pmkid_attr {
 	struct host_if_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
 };
=20
-enum current_tx_rate {
-	AUTORATE	=3D 0,
-	MBPS_1		=3D 1,
-	MBPS_2		=3D 2,
-	MBPS_5_5	=3D 5,
-	MBPS_11		=3D 11,
-	MBPS_6		=3D 6,
-	MBPS_9		=3D 9,
-	MBPS_12		=3D 12,
-	MBPS_18		=3D 18,
-	MBPS_24		=3D 24,
-	MBPS_36		=3D 36,
-	MBPS_48		=3D 48,
-	MBPS_54		=3D 54
-};
-
 struct cfg_param_attr {
 	u32 flag;
 	u16 short_retry_limit;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index c4787bb..faf97df 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -342,7 +342,7 @@ static int linux_wlan_init_test_config(struct net_devic=
e *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto fail;
=20
-	c_val[0] =3D AUTORATE;
+	c_val[0] =3D WILC_FW_TX_RATE_AUTO;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto fail;
=20
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index c7e745d..36d6905 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -193,6 +193,22 @@ enum {
 	WILC_FW_SMPS_MODE_MIMO =3D 3,	/* power save disable */
 };
=20
+enum {
+	WILC_FW_TX_RATE_AUTO =3D 0,
+	WILC_FW_TX_RATE_MBPS_1 =3D 1,
+	WILC_FW_TX_RATE_MBPS_2 =3D 2,
+	WILC_FW_TX_RATE_MBPS_5_5 =3D 5,
+	WILC_FW_TX_RATE_MBPS_11 =3D 11,
+	WILC_FW_TX_RATE_MBPS_6 =3D 6,
+	WILC_FW_TX_RATE_MBPS_9 =3D 9,
+	WILC_FW_TX_RATE_MBPS_12 =3D 12,
+	WILC_FW_TX_RATE_MBPS_18 =3D 18,
+	WILC_FW_TX_RATE_MBPS_24 =3D 24,
+	WILC_FW_TX_RATE_MBPS_36 =3D 36,
+	WILC_FW_TX_RATE_MBPS_48 =3D 48,
+	WILC_FW_TX_RATE_MBPS_54 =3D 54
+};
+
 enum wid_type {
 	WID_CHAR		=3D 0,
 	WID_SHORT		=3D 1,
--=20
2.7.4

