Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F65C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4480621527
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="dOKZGRGs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4480621527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbeKLPhR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:37:17 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32674 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbeKLPhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:37:17 -0500
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="23150826"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Nov 2018 22:45:37 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 11 Nov 2018 22:45:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2GCIzDd1uS1OW5hZ2UOHNKzLjQRsn0vIn+K9GW10mQ=;
 b=dOKZGRGsivQp0HzMtZ+8xKj1WWaFyGYjNVU+BF5XJxH4aPd8/1cK8gd01D7T42DSPt4R2SF5/XNLrWgZKn37eynVIV74h0OZciaI7ynq2VyJpApprZM8uu6iJXFG2wQK9MZK2AjyUlym2RC+Dwa2+T3zZmyuaaA61bqiqwof6gI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2599.namprd11.prod.outlook.com (52.135.227.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Mon, 12 Nov 2018 05:45:35 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 05:45:35 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 12/12] staging: wilc1000: rename tsf_hi element of
 network_info struct
Thread-Topic: [PATCH 12/12] staging: wilc1000: rename tsf_hi element of
 network_info struct
Thread-Index: AQHUekruXCjAPZ0O50yLjLnc3p2keQ==
Date:   Mon, 12 Nov 2018 05:45:35 +0000
Message-ID: <1542001458-20217-13-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2599;6:x3sWrTtN7Ifv9N+kyPlQNM5qUFrVdSq1p+Cf31wMAjT8/t5ewTBm0f1bJVCFlO8S2SP+fAzwlLG19XAtM9XWz800nzZrBM/4Lv2QpXh7Wq1YoDEByUX/aLR76lQ9V/NwpW7sKtiHoXUtAl71JT55lDRt0FQAcxCI5fzVVmAtCC79Pl5lvRIpZ7pqBjKCaObggZI1bh54J1sdNQGGqvWBgd8G0fAjKLaWLz2tRrNDsX8/1Bs1GQxYXY5xFZO7bW+0VYd3+avYrQjFXw0bCAxOVCGq2NncSe0n+j1OAjts6z/d/uAhr69DxRFRdgd7g9MsLkf2Rm1mi3C5kpjS7HOdiGrkMS8Ta7scij+/SFSYH7ok0ERvF8PPGJ+I965wdzZFb/cgx8Zx9Ozc16B8ygHzNWN/0khqKezM+IKA6q8AP7ihHP9PgP8X+63r9BbrWmZCSla1ukroYaQicW4/syL9aw==;5:+GgAXuOG4EnwIgutEwTVgjPMN6DVmTUeDT7tyS4N/Iw6fxSlkx9sW9CzTJZfg438x2FsOCUeXuH33dzdJigghMeOyfFtgEeG1FNvFGuyenJBDb0BU0UVVosKarc/DkRb9F4Wc3M/1CNH7BfO/3UirT9ECZPG/Y06YzBmYSBR040=;7:H0vu6wLjQgyo5Y1KbCZkr+dvERUerWlQa4UEGVpIDDUsgdUch4GoODrDiViRNuhkF8xIwP9SEvAK0CxH4TmV/9ge9vcD/6cYIoFZivwdWdXTvyQMl5DyuPvvYKleUxy2dNgCBQBWX4ZkXiatjcbptA==
x-ms-office365-filtering-correlation-id: bc94f3cc-69eb-40c3-53bc-08d648621113
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2599;
x-ms-traffictypediagnostic: BYAPR11MB2599:
x-microsoft-antispam-prvs: <BYAPR11MB259915F40EFCB2252750F27FE3C10@BYAPR11MB2599.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(3231402)(944501410)(52105112)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2599;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2599;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(2906002)(6116002)(3846002)(72206003)(26005)(2351001)(14454004)(86362001)(186003)(6436002)(478600001)(6486002)(105586002)(76176011)(106356001)(2501003)(107886003)(5640700003)(54906003)(52116002)(99286004)(102836004)(53936002)(256004)(6506007)(386003)(316002)(36756003)(486006)(8936002)(6916009)(11346002)(7736002)(305945005)(476003)(2616005)(68736007)(8676002)(71200400001)(97736004)(5660300001)(66066001)(446003)(81156014)(81166006)(6512007)(71190400001)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2599;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: iHr1DOW5U69wcKKN783gmetoi6QU/e+OhlEG4f/KlYUzMDq4FBbulSjj+p0ohogyDLucmOjYQ72YcPcNEKbgCyML8i+Gz83G7RSLUfsT95tCV5CkZ4fm0ZaDy8K0xUjnWfF4tivrJ+LZ3hIuB6OrkXiFRAK9s6Fp4mqh/MyEPC1cwY0+YCXa4+dIShwoSf66TGql85vwIbM4KJpTlSDNTxFB77crcYVhW+luqk9cmhHQoFnCZWyNCycvNXAZwGRO4F2vFDqsXGV08OPWqWXRq556Z0y9XKaqe3/QiF20zBF9bb/i04snOU5lWAYFI6TRR2FrHbzgVBuRHOo811ObX250Z8B+voXqUeU77ctPvEY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc94f3cc-69eb-40c3-53bc-08d648621113
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 05:45:35.2599
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

Rename 'tsf_hi' element in network_info struct as it's not used to store
only the higher 32-bit value but the complete 64-bit tsf value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 5ab426c..3f3b013 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1098,14 +1098,14 @@ static s32 wilc_parse_network_info(u8 *msg_buffer,
 	if (ieee80211_is_probe_resp(mgt->frame_control)) {
 		info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
 		info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int);
-		info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
-		info->tsf_lo =3D (u32)info->tsf_hi;
+		info->tsf =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
+		info->tsf_lo =3D (u32)info->tsf;
 		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
 	} else if (ieee80211_is_beacon(mgt->frame_control)) {
 		info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
 		info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
-		info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
-		info->tsf_lo =3D (u32)info->tsf_hi;
+		info->tsf =3D le64_to_cpu(mgt->u.beacon.timestamp);
+		info->tsf_lo =3D (u32)info->tsf;
 		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	} else {
 		/* only process probe response and beacon frame */
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 606e80a..8279345 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -76,7 +76,7 @@ struct network_info {
 	u16 ies_len;
 	void *join_params;
 	struct rssi_history_buffer rssi_history;
-	u64 tsf_hi;
+	u64 tsf;
 };
=20
 struct connect_info {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 9906a9f7..1dec6bb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -193,7 +193,7 @@ static void refresh_scan(struct wilc_priv *priv, bool d=
irect_scan)
 					  channel,
 					  CFG80211_BSS_FTYPE_UNKNOWN,
 					  network_info->bssid,
-					  network_info->tsf_hi,
+					  network_info->tsf,
 					  network_info->cap_info,
 					  network_info->beacon_period,
 					  (const u8 *)network_info->ies,
@@ -308,7 +308,7 @@ static void add_network_to_shadow(struct network_info *=
nw_info,
 	shadow_nw_info->beacon_period =3D nw_info->beacon_period;
 	shadow_nw_info->dtim_period =3D nw_info->dtim_period;
 	shadow_nw_info->ch =3D nw_info->ch;
-	shadow_nw_info->tsf_hi =3D nw_info->tsf_hi;
+	shadow_nw_info->tsf =3D nw_info->tsf;
 	if (ap_found !=3D -1)
 		kfree(shadow_nw_info->ies);
 	shadow_nw_info->ies =3D kmemdup(nw_info->ies, nw_info->ies_len,
@@ -372,7 +372,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 						  channel,
 						  CFG80211_BSS_FTYPE_UNKNOWN,
 						  network_info->bssid,
-						  network_info->tsf_hi,
+						  network_info->tsf,
 						  network_info->cap_info,
 						  network_info->beacon_period,
 						  (const u8 *)network_info->ies,
--=20
2.7.4

