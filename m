Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924E4C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 521B421527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="tvrPq8p3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 521B421527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbeKLPgv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:36:51 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32655 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPgu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:36:50 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Nov 2018 22:45:11 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHLqIoPDWBLYmP2O4cCE4rqGBwtC6Atzd4HtL/q6tmQ=;
 b=tvrPq8p3Hjsbtju0ZW3c/M0lQOWVUi4yyZTPGxsyW63hn+feiQJNcE8Y+Z9kWlkNZwaxHcuyMbMbE+TDsF5cqNfDfstse1Gu4R2bXvhmz2FedyzpLuGFcytk8KzNielsdbfYOgjXpZpcIkLHopGxgIUV+tpy4Bbn2sSp6IQqQcM=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:08 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:08 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 03/12] staging: wilc1000: remove unused macros and struct
 members in host_interface.h
Thread-Topic: [PATCH 03/12] staging: wilc1000: remove unused macros and struct
 members in host_interface.h
Thread-Index: AQHUekrevzFGmTKp4UCaOE3ezU/3MQ==
Date:   Mon, 12 Nov 2018 05:45:08 +0000
Message-ID: <1542001458-20217-4-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:tB8FLW1E9s9N2agIZ2PFew4rVSa8IvvlF409BiRX0OGsdHNaW3TyyB3HWBcdUXb0pIBJWTt+vD+wkBEQJgeXdNeSw4dL8eLgm1AK5sd9sl22BUmOy+OPoEIHTOxssELJu/4gAjkwwtnRmfuzGnmdxO8DtydZiiz3U/NX69gVOiT+Hic8tNRMjNkMfQyDLjRkPegFJOWxKu/BTcOychtYgX23rJnHA45naNZjqB9gcyCOslm5sQEtamHhHdkedNYS23cu/9BCnazcM56C7z45+i1SdbzTYias7PFNqddTFqX0a4FXHqlEOnoCJMTmt/WS8zegW1JQBUGkgFGo9YqCC99o8HDvC1akYL3bENsWiuRP/F2wHmqAMEqyynHXf6+jNZkjpy7BL26my702YwXHevM/9DMM5vk8Pa3+79Cnj99UgVfA1IRtX7iRKp0ZlPgBcasAPG+wLZseh2unWiwJBQ==;5:Tm+n0Y3oC7MaXq5zZWSrhrWZ8YypRCOpXpYABRI4pa9DQfWvWAGQ/CKI2S9AzaI0f9/12ATa6l8o6L47lCqKDntRSM+mseE0QqN6ccEh7k1qC5Wg3lT7ZQi74I0QZJ8/gAXkQy4NKWylYruBFXeCpo7/4n/vfxcbW9fH+4icgaE=;7:U+AE3u+WOSCv8uD+SkB+ubNryW5J9BJ9Luz5xs5E1+idUtmA1TsvG3BRVgyMsn0TmPbOcR1KQt1Y54bfWzhcDRY3iOS0BagaPTTp+e6Sn/Odr1tjbozRaCtPmO+/kksK+lFGRj859/83SsR6bRVQoA==
x-ms-office365-filtering-correlation-id: ee6a4f6c-65d7-466c-1e41-08d64862014c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB2599121D40A5F9362FA7C00CE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(575784001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(14444005)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 4c6TkopcNT/yshsY971GiT948xXmn59n6F18dT6OV7wMjbJ/UXukNtkLjVReco3Qgg5zbDNkbQO+86tN6TNvO3KsFXs1ITuGY5vitdMjaIzEzXZJZgG618NWZ3w2ocsMkWsqMIOlScl3UoDW5h+gX5dvvTTGcCxmpHN4ch/Qjtv1DRN74ms3MFr4KITAIcVSAmAmiLeGootqL/aqMC9EwRCTBg7fi0l47FHJzZtiDiQA4GVXcUIzSgWf9x8hGzwF8fPLdK7y/TiJQyIsZg2GlFgRlTaTcQw+RaQoe6XBFSPu1baj+nm0r5m/Dclo4plU4A3BXVuHniVXjQuQP35XUDS6XkzLld7qIK4gswvY3iM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6a4f6c-65d7-466c-1e41-08d64862014c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:08.7435
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

Cleanup patch to remove the unused macros and struct members in
host_interface.h header file.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 3d31153..fefbce6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -18,15 +18,10 @@
 #define ACTION_FRM_IDX				0
 #define PROBE_REQ_IDX				1
 #define MAX_NUM_STA				9
-#define ACTIVE_SCAN_TIME			10
-#define PASSIVE_SCAN_TIME			1200
-#define MIN_SCAN_TIME				10
-#define MAX_SCAN_TIME				1200
 #define DEFAULT_SCAN				0
 #define USER_SCAN				BIT(0)
 #define OBSS_PERIODIC_SCAN			BIT(1)
 #define OBSS_ONETIME_SCAN			BIT(2)
-#define GTK_RX_KEY_BUFF_LEN			24
 #define ADDKEY					0x1
 #define REMOVEKEY				0x2
 #define DEFAULTKEY				0x4
@@ -34,18 +29,15 @@
 #define MAX_NUM_SCANNED_NETWORKS		100
 #define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
 #define MAX_NUM_PROBED_SSID			10
-#define CHANNEL_SCAN_TIME			250
=20
 #define TX_MIC_KEY_LEN				8
 #define RX_MIC_KEY_LEN				8
 #define PTK_KEY_LEN				16
=20
-#define TX_MIC_KEY_MSG_LEN			26
 #define RX_MIC_KEY_MSG_LEN			48
 #define PTK_KEY_MSG_LEN				39
=20
 #define PMKSA_KEY_LEN				22
-#define ETH_ALEN				6
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
 #define NUM_CONCURRENT_IFC			2
@@ -153,12 +145,10 @@ enum current_tx_rate {
=20
 struct cfg_param_attr {
 	u32 flag;
-	u8 ht_enable;
 	u16 short_retry_limit;
 	u16 long_retry_limit;
 	u16 frag_threshold;
 	u16 rts_threshold;
-	u8 scan_source;
 };
=20
 enum cfg_param {
@@ -166,7 +156,6 @@ enum cfg_param {
 	RETRY_LONG		=3D BIT(1),
 	FRAG_THRESHOLD		=3D BIT(2),
 	RTS_THRESHOLD		=3D BIT(3),
-	HT_ENABLE		=3D BIT(18),
 };
=20
 struct found_net_info {
--=20
2.7.4

