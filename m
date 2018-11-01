Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C32C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9D6205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TFAz2CCx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F9D6205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbeKBBsw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:48:52 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22166 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbeKBBsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:48:52 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="19784996"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:07 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAf/hwDnxTI6/5yTp255TBRUKtQD+1arIqXfWawfjTw=;
 b=TFAz2CCxWWYj/pMTLogUUNbmTXIp8x237s20ChNvU01SKyvLJIpE97gC7obGBhtW6STiCiz4R+fyYgfdwJlZD6C2A1hZxiQY9dv0xaz8TklfyzM6VH8b/M/baM9tk1r6oaU3BEteq3dQMQVnIr2ZKO0brU88p8b8956886cG2Yo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Thu, 1 Nov 2018 16:45:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 1/8] staging: wilc1000: refactor wilc_parse_network_info()
 using kernel framework api's
Thread-Topic: [PATCH 1/8] staging: wilc1000: refactor
 wilc_parse_network_info() using kernel framework api's
Thread-Index: AQHUcgI9+KAAgLN1y0ueG6DieJ/uhw==
Date:   Thu, 1 Nov 2018 16:45:05 +0000
Message-ID: <1541090691-31928-2-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:3yjNK+F2v5KxyIC04T5tjthVd4oiftaPH1JMVnchMgq4dfc4iWkfG+cAauSdVZXcPGgiagcxlGi5+qVQSDan9hphmcClRCrdoQ9vNEbVjG+hrE9mVwsTBFX/ALD27GrSISd1u47iyiEm91UUKK4tYMLxPv2FkcDvXbCwc80JdKfWsaqAc+R7wplNWBSCsI+D8ZL0AAQ1XUPpaM2ubmXRQgnoOrd0A4txb/thBOdQuH/whLQhT+T/Kn0VPsaSUnYXpnMBK3ATpKclZK9h1VwhNFmEjbOuQUbQp0GSkx52+DjvEQT335lqBG7Zz1oXva3HlicZqlo1ewWmuyTVsO3Bvsg+6pXn80MtvTBWN0MqioSa2jFbK+Uwc8ZJmQqBtzpwHP7V0TE6ArmAMg1WdytcOZta6+mgczURtLrZB1ANBMTXvse+aS0SKfaaryuH8oYR1xmxcNbcHJWasNh1JWW7WA==;5:hW3gKDEGkv/n8ETEtjUbRKsqAgs7I1xTbDWbyZjclM5a5nye1TwT2M//RqFaFRfRlyDQSGQ+Q8JzBuMg6XjpQGXw/kfxmfQRrFhx/TPtibMzlmnTh7C6aKoqGe+icTfrotADSs/IGDS16JbJh7FsNQyW3lYpZDtzZajsRbmlo8s=;7:EU1B2lwbltmEKIC+hrsWVtGbXbEKEzdIYudtE7p8X/LkAatxL5XWKDu+Am3I8fJX3hNv/e2NxkvlrNjH7oklNy5yUKrZzr8lNhfbbZ3S+nWZin0nLKhRpDZuWDd0bDODc0QQc5fVZiv4R5/J5cUfqQ==
x-ms-office365-filtering-correlation-id: 0bc926f6-a97c-4479-120e-08d640195fbc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB3077402D0314DC1CC999FE4EE3CE0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(20161123558120)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3077;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3077;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(39860400002)(346002)(396003)(189003)(199004)(26005)(486006)(6486002)(86362001)(2906002)(71190400001)(2351001)(53936002)(71200400001)(256004)(6512007)(14454004)(66066001)(106356001)(6116002)(105586002)(3846002)(6436002)(107886003)(2900100001)(68736007)(81166006)(8676002)(5640700003)(11346002)(6506007)(36756003)(72206003)(7736002)(54906003)(316002)(8936002)(4326008)(5660300001)(52116002)(81156014)(25786009)(102836004)(2616005)(186003)(476003)(6916009)(76176011)(386003)(305945005)(5250100002)(478600001)(97736004)(446003)(99286004)(2501003)(78486014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aCsHY9EqDnbL3UYt5jzBtF0cmRzWn+rM0kSIAbgN4WVaA0webCKjyE1HzIqeMDn3+kBHoZa0FypwtOJIJSYwGRBe+3quJXgLBg29q7HaoUOI2H6ybjRAFZWcCNv+j29rTAkV8It20Un2FCGHLfLd+TRfPR/GEeQBjmWlCVwyqPKdCiQk0b6YKu/gyHQSW3RkrBIjg3UROD5L6Ewa5eiN31ctCMnHiwErpmxgouamdS2HOeWEZvT0HhJGQ/XPFadM2z47qiXRxvLDkkIqThM2Zi/KTNo3jiCmgqtbBa2ajBoCPgLuajkQV81m+7jQLDyJWz8G//V5h8kdmNVafwf/4MxSHUWevrZxLjtnAxBJSIg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc926f6-a97c-4479-120e-08d640195fbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:05.1289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3077
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor wilc_parse_network_info() by making use of cfg80211.h provided
API.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 90 ++++++++++++++++++-------=
----
 1 file changed, 55 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
index d6d3a97..4dfa658 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -4,7 +4,7 @@
  * All rights reserved.
  */
=20
-#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
=20
 #include "coreconfigurator.h"
=20
@@ -116,11 +116,11 @@ static inline void get_address3(u8 *msa, u8 *addr)
 	memcpy(addr, msa + 16, 6);
 }
=20
-static inline void get_bssid(u8 *data, u8 *bssid)
+static inline void get_bssid(__le16 fc, u8 *data, u8 *bssid)
 {
-	if (get_from_ds(data) =3D=3D 1)
+	if (ieee80211_has_fromds(fc))
 		get_address2(data, bssid);
-	else if (get_to_ds(data) =3D=3D 1)
+	else if (ieee80211_has_tods(fc))
 		get_address1(data, bssid);
 	else
 		get_address3(data, bssid);
@@ -202,17 +202,18 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info)
 {
 	struct network_info *network_info;
-	u8 *wid_val, *msa, *tim_elm, *ies;
-	u32 tsf_lo, tsf_hi;
+	struct ieee80211_mgmt *mgt;
+	u8 *wid_val, *msa, *ies;
 	u16 wid_len, rx_len, ies_len;
-	u8 msg_type, index;
+	u8 msg_type;
+	size_t offset;
+	const u8 *ch_elm, *tim_elm, *ssid_elm;
=20
 	msg_type =3D msg_buffer[0];
-
 	if ('N' !=3D msg_type)
 		return -EFAULT;
=20
-	wid_len =3D MAKE_WORD16(msg_buffer[6], msg_buffer[7]);
+	wid_len =3D get_unaligned_le16(&msg_buffer[6]);
 	wid_val =3D &msg_buffer[8];
=20
 	network_info =3D kzalloc(sizeof(*network_info), GFP_KERNEL);
@@ -222,42 +223,61 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	network_info->rssi =3D wid_val[0];
=20
 	msa =3D &wid_val[1];
-
+	mgt =3D (struct ieee80211_mgmt *)&wid_val[1];
 	rx_len =3D wid_len - 1;
-	network_info->cap_info =3D get_cap_info(msa);
-	network_info->tsf_lo =3D get_beacon_timestamp_lo(msa);
=20
-	tsf_lo =3D get_beacon_timestamp_lo(msa);
-	tsf_hi =3D get_beacon_timestamp_hi(msa);
+	if (ieee80211_is_probe_resp(mgt->frame_control)) {
+		network_info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
+		network_info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int=
);
+		network_info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
+		network_info->tsf_lo =3D (u32)network_info->tsf_hi;
+		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	} else if (ieee80211_is_beacon(mgt->frame_control)) {
+		network_info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
+		network_info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
+		network_info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
+		network_info->tsf_lo =3D (u32)network_info->tsf_hi;
+		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	} else {
+		/* only process probe response and beacon frame */
+		kfree(network_info);
+		return -EIO;
+	}
=20
-	network_info->tsf_hi =3D tsf_lo | ((u64)tsf_hi << 32);
+	get_bssid(mgt->frame_control, msa, network_info->bssid);
=20
-	get_ssid(msa, network_info->ssid, &network_info->ssid_len);
-	get_bssid(msa, network_info->bssid);
+	ies =3D mgt->u.beacon.variable;
+	ies_len =3D rx_len - offset;
+	if (ies_len <=3D 0) {
+		kfree(network_info);
+		return -EIO;
+	}
=20
-	network_info->ch =3D get_current_channel_802_11n(msa, rx_len
-						       + FCS_LEN);
+	network_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+	if (!network_info->ies) {
+		kfree(network_info);
+		return -ENOMEM;
+	}
=20
-	index =3D MAC_HDR_LEN + TIME_STAMP_LEN;
+	network_info->ies_len =3D ies_len;
=20
-	network_info->beacon_period =3D get_beacon_period(msa + index);
+	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies, ies_len);
+	if (ssid_elm) {
+		network_info->ssid_len =3D ssid_elm[1];
+		if (network_info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
+			memcpy(network_info->ssid, ssid_elm + 2,
+			       network_info->ssid_len);
+		else
+			network_info->ssid_len =3D 0;
+	}
=20
-	index +=3D BEACON_INTERVAL_LEN + CAP_INFO_LEN;
+	ch_elm =3D cfg80211_find_ie(WLAN_EID_DS_PARAMS, ies, ies_len);
+	if (ch_elm && ch_elm[1] > 0)
+		network_info->ch =3D ch_elm[2];
=20
-	tim_elm =3D get_tim_elm(msa, rx_len + FCS_LEN, index);
-	if (tim_elm)
+	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
+	if (tim_elm && tim_elm[1] >=3D 2)
 		network_info->dtim_period =3D tim_elm[3];
-	ies =3D &msa[TAG_PARAM_OFFSET];
-	ies_len =3D rx_len - TAG_PARAM_OFFSET;
-
-	if (ies_len > 0) {
-		network_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!network_info->ies) {
-			kfree(network_info);
-			return -ENOMEM;
-		}
-	}
-	network_info->ies_len =3D ies_len;
=20
 	*ret_network_info =3D network_info;
=20
--=20
2.7.4

