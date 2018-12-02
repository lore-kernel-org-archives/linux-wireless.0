Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F070AC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD5512082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YoSITCAS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD5512082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbeLBSD4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:56 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23471 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbeLBSD4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:56 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23899284"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:03:53 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G01il5MTiHF4rDgZ2CofhslZdSaD+T5c4UlkLPaJtb4=;
 b=YoSITCAS+hdY+pLZ/gcrEKEVormDk52s+iNlFpwCeC6Xs/OQj3KtN2S4N1o1nKZykDpmpN5lf+mCR4gsp4A3HH1CxIWEEfs/R4HL+0crdenravYdhlweb9fVhquCpxIbuUinweo6cuJoDVZx0T/SNbwwIOJnG116svp9VmLqgJA=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:14 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:14 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 21/29] staging: wilc1000: delete the unused code after code
 refactor
Thread-Topic: [PATCH 21/29] staging: wilc1000: delete the unused code after
 code refactor
Thread-Index: AQHUimlLpYbIxmT/EUygrz4NS2LMoA==
Date:   Sun, 2 Dec 2018 18:03:14 +0000
Message-ID: <1543773663-20561-22-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:ntwgnGmPbbsKmi14R1js/0Tycakhsnwuz2pCvU+/NC34lnfE2cnkCXhhT6cGgC/gA8hBVxaTFm0fZ1nP+hiSi1CdNlfdgilUg7ohnS+y35DCcb4p5KYA5TB2YzKNiKFuiMqWDsi4gXmA3ev7L5x9aJyblrtDhaDdKfnmRr0KdQK+nG2HbCpXBle6wMmCMuDk8QTh2yo5WItsX7ZpKSgJSgsnHgShH4ieoAjYKT0S7g6eN1qWKvYyhFdYZloO4SzS5zrOy0uZaAKTUDXM+1WQ9yle9S9UsiMCUoN6olfB5uU0yXNYW7m4ZwOdbtceHKzmYeMHWent+I7gZTPgOLjmIJ1net1B1M0nxRTahHaJfKOIyOsSmgjW8Czrt+9V4ZtBxoHLaMWl8Cbt3brscC+fbU0+a1QsZw4oDJTLTxMwZDOi0umNOEetkEB/Rgzi0phjfLSvYQQheNHfsm97G+RQMw==;5:cV7p2Z03YWx1LvjqKx15xrY7ZNPZMmOsvV5pMpc3dhc0+vYeP3HGT+eN6rWB1iso9D1zabxnD4UwvkAnQFOPjOn31Y2Cl+2QCLz2MJWk2D1MzerVEpxYC1UvEdGrUWhow+DgLRQor3eQ/5IInomPbBw9LKfyX3uKL/L8LWKT6NY=;7:NWadZwxwbXTU7/ZT+hGqt9nJ2Ko+9bPFu3hoKY87HzbFSCjo+2oka8fCG8LDKVyZvoFHv83JM35JMg0c7+vz7E7omt6OQ6Q7gxO4DBC5wSNECN5PrzySHWMyNS1IUeF2dwYb7ExJ3jktk+7P4vlYfw==
x-ms-office365-filtering-correlation-id: 867849b0-689a-48f4-12f2-08d658806db6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB280694BACC871EC9D469BC38E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: B3G2ZAyQ3bRRdHIG9e1bjtHtL1XKvFDJtmVimKG6ho0e8n7OCrLxKqkz3c7a0icW3kg8uhiId40ccbH2W4vyLhadACRcP9mXdZtXwxL9wV+NiCOU9K7FmEilTrZdVAKPYMiLgs02kNXLnlNs4qQsftLqyt06Ppkc0uC/jirQSH2RDXibydkXt7jCvrTzVNE7ZiaDR1zX4iLXR9vxL41n7brbdimh1BTlpg8SJkeUPM7F73DeAVot/41TI11lQpckUcBHRpk341+CrT2UTVlECuozWRN6g9cGYEospnS7dauepRlsHJdS18TwFIJb2Vdstr+0769J3Awx9d27Kjys1PZuIhQ01s5Uv5P86Es27+s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 867849b0-689a-48f4-12f2-08d658806db6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:14.3844
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

After code refactor some of the macro and variables are not required any
more, so deleted the unused code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 31 ---------------------------=
----
 drivers/staging/wilc1000/host_interface.h | 27 ---------------------------
 2 files changed, 58 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 596a321..71395d8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -13,30 +13,6 @@
=20
 #define REAL_JOIN_REQ				0
=20
-struct host_if_wpa_attr {
-	u8 *key;
-	const u8 *mac_addr;
-	u8 *seq;
-	u8 seq_len;
-	u8 index;
-	u8 key_len;
-	u8 mode;
-};
-
-struct host_if_wep_attr {
-	u8 *key;
-	u8 key_len;
-	u8 index;
-	u8 mode;
-	enum authtype auth_type;
-};
-
-union host_if_key_attr {
-	struct host_if_wep_attr wep;
-	struct host_if_wpa_attr wpa;
-	struct host_if_pmkid_attr pmkid;
-};
-
 struct scan_attr {
 	u8 src;
 	u8 type;
@@ -121,20 +97,13 @@ struct wilc_gtk_key {
 	u8 key[0];
 } __packed;
=20
-struct set_ip_addr {
-	u8 *ip_addr;
-	u8 idx;
-};
-
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
-	struct set_ip_addr ip_info;
 	struct set_multicast multicast_info;
 	struct get_mac_addr get_mac_info;
-	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
 	char *data;
 };
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 477372b..d2f29ea 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -17,13 +17,6 @@ enum {
 	WILC_CLIENT_MODE =3D 0x4
 };
=20
-enum {
-	WILC_ADD_KEY =3D 0x1,
-	WILC_REMOVE_KEY =3D 0x2,
-	WILC_DEFAULT_KEY =3D 0x4,
-	WILC_ADD_KEY_AP =3D 0x8
-};
-
 #define WILC_MAX_NUM_STA			9
 #define MAX_NUM_SCANNED_NETWORKS		100
 #define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
@@ -31,16 +24,10 @@ enum {
=20
 #define TX_MIC_KEY_LEN				8
 #define RX_MIC_KEY_LEN				8
-#define PTK_KEY_LEN				16
=20
-#define RX_MIC_KEY_MSG_LEN			48
-#define PTK_KEY_MSG_LEN				39
-
-#define PMKSA_KEY_LEN				22
 #define WILC_MAX_NUM_PMKIDS			16
 #define WILC_ADD_STA_LENGTH			40
 #define WILC_NUM_CONCURRENT_IFC			2
-#define WILC_DRV_HANDLER_SIZE			5
=20
 #define NUM_RSSI                5
=20
@@ -160,13 +147,6 @@ enum conn_event {
 	CONN_DISCONN_EVENT_FORCE_32BIT		=3D 0xFFFFFFFF
 };
=20
-enum KEY_TYPE {
-	WILC_KEY_TYPE_WEP,
-	WILC_KEY_TYPE_WPA_RX_GTK,
-	WILC_KEY_TYPE_WPA_PTK,
-	WILC_KEY_TYPE_PMKSA,
-};
-
 typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
 				 void *, void *);
=20
@@ -218,13 +198,6 @@ struct get_mac_addr {
 	u8 *mac_addr;
 };
=20
-struct ba_session_info {
-	u8 bssid[ETH_ALEN];
-	u8 tid;
-	u16 buf_size;
-	u16 time_out;
-};
-
 struct remain_ch {
 	u16 ch;
 	u32 duration;
--=20
2.7.4

