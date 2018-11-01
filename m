Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD93C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 542F3205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="w90z8I36"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 542F3205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbeKBBtB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:49:01 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19769 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbeKBBtB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:49:01 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="22208924"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:16 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkfHw2s3HDgMDUaRGb619JU5KSTW83g/h5PUcfWsp8s=;
 b=w90z8I36Jl+ZTNNUQpMZvm3kkZgdwIU2KknSUqkw/R9W9SrxUiuBAuXtjQmGU6HJYqV0POea/j+wE+yYTpjd3WBsh/fLhEgGP2J/Iu2z5JYSpwiKgRREYjDJrOWiJbijSg2JfrWcztlddVpUB+hN+No9x8Gjf5Bk9aHLdMaEUsc=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3286.namprd11.prod.outlook.com (20.177.185.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.21; Thu, 1 Nov 2018 16:45:14 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:14 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Topic: [PATCH 4/8] staging: wilc1000: avoid line over 80 chars in
 wilc_parse_network_info()
Thread-Index: AQHUcgJD9vPPwH1+N0OaOZ3PcNN1Ig==
Date:   Thu, 1 Nov 2018 16:45:14 +0000
Message-ID: <1541090691-31928-5-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3286;6:619ids8eDRT36dCY19A/FdpxelqAp5kYcapmDFB7FFl9UKG1S+Au8IsRZxLoQvC4QKXtS+HHejVVM1HZNZt/o9U0YZAYSR2kNt68bvm7Z4aSOwNA+YLTPj17oBD/23qP9ft7nWrOeY2dK+x76r5Pj9Q1hqG0KLQ/Jxsq2ry9wJsuYDCGqP0LrwZnwbnWzYFiZW+VHcV3u1nfGyJXtDUSURbLqN5TWf11qy4GblnnedbGK6itcaR/dbRLKZQOFZXgec4c1uT36UmyPoPy7KjVgged39UrKJOipzC0Zw4mc7yDZAbE3olxzIq0LFdp6xQMdEOGutEUGa+EIB9P9H/wxXrKri2rjZYvc25fLVf1gJi8fyZ4GN7Zjwt0m/2QiXc/Og8thOWHBjRq4W1KdfZwtnaXcuPg11EMQhiw1SNrClfhDgrI6xPN/zw12EC/52W8GdszcUrUcG2Y2awwC/I6oQ==;5:Mo6aS7swbeLVLVL3c+XDIiMGMWqagYzmEnxGVGOwiQsmK+q8EYAGJ1dQorIcSGiZfqAba+NaPLntVVrVe3rDpTyhvB094zOMpeW8QD864ThPr8Qm7CfV+jWZ/sU8c/e6DTwcL21b2BGxFJsQAWt5u4580nCd9eskSvuG8aMObI8=;7:hNKVahsXIYi9o2n7IW5gdBnFdNPxoRpwjqKVrVuEzmr9cnkW0CNeutHuhW0sDLZRQ4XfopVQmtX5jQ5OrjIiDqGI3yko8RrIUKGQmM4fyTSbq9E3fl3gA2PEDCsT15tPxOEd/xmY1VlDlsCbl8bDpw==
x-ms-office365-filtering-correlation-id: 993b4b3f-6671-4212-6b56-08d640196558
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3286;
x-ms-traffictypediagnostic: BYAPR11MB3286:
x-microsoft-antispam-prvs: <BYAPR11MB3286F78A39342EBE9657EF59E3CE0@BYAPR11MB3286.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3286;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3286;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(105586002)(102836004)(2900100001)(5660300001)(106356001)(6916009)(4326008)(186003)(26005)(78486014)(2906002)(476003)(446003)(305945005)(6506007)(14454004)(386003)(486006)(2616005)(7736002)(11346002)(86362001)(3846002)(6116002)(256004)(52116002)(8936002)(76176011)(478600001)(81156014)(8676002)(71200400001)(68736007)(71190400001)(72206003)(54906003)(316002)(25786009)(99286004)(81166006)(107886003)(66066001)(5250100002)(2501003)(5640700003)(53936002)(6512007)(6436002)(36756003)(6486002)(97736004)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3286;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: w+gpXEAhIiZlLgWfMM63mFany5cRSF0qdYVAsraiCA5eW5UHVkYK7FyxpthMZ2TVuxjS8k5W5mEwOCenLDcagD6Z7W6ixoLK1ljkhrOdPqKzsSrbGAOtinkvUhgF8NsYlXa9EWqkhi9t0uIPlErHBe4iLr1zE/oo7Kql2FX7PLj6DeIk1lM1VoTOFrNmSyytXLUQkdjCTEvhxfHxjrbkZByP492m+tX6ssRQCSvEcjIoBLIN9AWIWMSxCaOD1gSvbC+H06IvpA9kK2b630bYICGMzJpafV/QQ7vdaRvpp9Uwg4GOS1eNrFLpE11OENZbsCdF53RFbPrzjD+wDedHhmGRPLQzO4v1vxIXkTeMWTo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 993b4b3f-6671-4212-6b56-08d640196558
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:14.2039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3286
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use shorter name for 'network_info' variable to avoid line over 80 chars
issue.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 53 ++++++++++++++-----------=
----
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
index ac44846..2c77e5a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -29,7 +29,7 @@ static inline u16 get_asoc_status(u8 *data)
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info)
 {
-	struct network_info *network_info;
+	struct network_info *info;
 	struct ieee80211_mgmt *mgt;
 	u8 *wid_val, *msa, *ies;
 	u16 wid_len, rx_len, ies_len;
@@ -44,70 +44,69 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 	wid_len =3D get_unaligned_le16(&msg_buffer[6]);
 	wid_val =3D &msg_buffer[8];
=20
-	network_info =3D kzalloc(sizeof(*network_info), GFP_KERNEL);
-	if (!network_info)
+	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
 		return -ENOMEM;
=20
-	network_info->rssi =3D wid_val[0];
+	info->rssi =3D wid_val[0];
=20
 	msa =3D &wid_val[1];
 	mgt =3D (struct ieee80211_mgmt *)&wid_val[1];
 	rx_len =3D wid_len - 1;
=20
 	if (ieee80211_is_probe_resp(mgt->frame_control)) {
-		network_info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
-		network_info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int=
);
-		network_info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
-		network_info->tsf_lo =3D (u32)network_info->tsf_hi;
+		info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
+		info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int);
+		info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
+		info->tsf_lo =3D (u32)info->tsf_hi;
 		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
 	} else if (ieee80211_is_beacon(mgt->frame_control)) {
-		network_info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
-		network_info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
-		network_info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
-		network_info->tsf_lo =3D (u32)network_info->tsf_hi;
+		info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
+		info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
+		info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
+		info->tsf_lo =3D (u32)info->tsf_hi;
 		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	} else {
 		/* only process probe response and beacon frame */
-		kfree(network_info);
+		kfree(info);
 		return -EIO;
 	}
=20
-	ether_addr_copy(network_info->bssid, get_bssid(mgt));
+	ether_addr_copy(info->bssid, get_bssid(mgt));
=20
 	ies =3D mgt->u.beacon.variable;
 	ies_len =3D rx_len - offset;
 	if (ies_len <=3D 0) {
-		kfree(network_info);
+		kfree(info);
 		return -EIO;
 	}
=20
-	network_info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!network_info->ies) {
-		kfree(network_info);
+	info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+	if (!info->ies) {
+		kfree(info);
 		return -ENOMEM;
 	}
=20
-	network_info->ies_len =3D ies_len;
+	info->ies_len =3D ies_len;
=20
 	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies, ies_len);
 	if (ssid_elm) {
-		network_info->ssid_len =3D ssid_elm[1];
-		if (network_info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
-			memcpy(network_info->ssid, ssid_elm + 2,
-			       network_info->ssid_len);
+		info->ssid_len =3D ssid_elm[1];
+		if (info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
+			memcpy(info->ssid, ssid_elm + 2, info->ssid_len);
 		else
-			network_info->ssid_len =3D 0;
+			info->ssid_len =3D 0;
 	}
=20
 	ch_elm =3D cfg80211_find_ie(WLAN_EID_DS_PARAMS, ies, ies_len);
 	if (ch_elm && ch_elm[1] > 0)
-		network_info->ch =3D ch_elm[2];
+		info->ch =3D ch_elm[2];
=20
 	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
 	if (tim_elm && tim_elm[1] >=3D 2)
-		network_info->dtim_period =3D tim_elm[3];
+		info->dtim_period =3D tim_elm[3];
=20
-	*ret_network_info =3D network_info;
+	*ret_network_info =3D info;
=20
 	return 0;
 }
--=20
2.7.4

