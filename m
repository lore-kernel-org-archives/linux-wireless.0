Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CAFC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A83205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="0zW7jlPk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10A83205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbeKBBtL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:49:11 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5864 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbeKBBtL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:49:11 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="23460615"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:24 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHJLJ5q3ON5iKUPEIynbvGz8/fjxzUEjSDVekuUlQkY=;
 b=0zW7jlPk4y+GlAzvJB9VHA691fhHDzpQoV2AtKnSZnIzs66XoUkiwr7+LtW9bzHWR7caUe/wMyvXoC4ikFJEwgPnLc7LXFByjKeqkjNmSdnVNBDB/MHV6i4+K899Cc/FezwqzM91boXglaxQk7OSlk2dcBeMtvjeyMZl/FT0ceU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3286.namprd11.prod.outlook.com (20.177.185.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.21; Thu, 1 Nov 2018 16:45:23 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:23 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 7/8] staging: wilc1000: remove coreconfigurator.c file
Thread-Topic: [PATCH 7/8] staging: wilc1000: remove coreconfigurator.c file
Thread-Index: AQHUcgJI+n1jXNCkK0+aLkIKHXw5oA==
Date:   Thu, 1 Nov 2018 16:45:23 +0000
Message-ID: <1541090691-31928-8-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3286;6:Wp+TXIRLybuoimMW1IzdXAHsW2XlI+DeVzqULLSL5DMHu6whn1mbgvTD1O/OCE7/KWG/Hl2P+i3JP6YSCKtvLEJePhLM/vSRB1GhP68oBrgsH+oqHSYgJ+4rRjKolq9vwBCWn+Qko6jO8rBaCUpVEQfhQa7BOf7ElBUEmqGD9fwVgAhS/IVi5cDvbLYijdNgeReRtx4P9An1hSlWmdEEIWa4gPf2hBR5Qa3pV9a/QJLq4L1vIj10gFGdLSpoS4HD/NFAYIb/gcbgbIg9BuGa267yrzQAu9DNDqtLb8Z9HlweZsTE05l4UNrE1ZpLXtKiC+gle3IKcIZm3mqBmUdWNXovNkiDbAFuGT4ZJnAGs339QZTjuJPDcRwIMT1toKq+V9L/vez8uhTC9WSq86OpiIn3XnSgYe9nd2PJnXLPstrzvbj0sdBbtVCCE9wroNfAiX1ydTgeHovpLRrMJWVraQ==;5:vrkW4S2HOx4B+5VotTuYd/uAtOMnqBZ5YhM2ALremNdsGjyffBofXO6Pwj0TZ9cacOqC/QPrd5MUXhp4WmGq7soUOXizQTDSAGtwLJHCJY/5ZNK8IiJq4xPF5BFuJmIpyXk0oBoXke+zVJFbrhEuYIR5VpxexVJY9h5WAFabMyA=;7:gP/dzqEdEJ0E6VG0HSf7Gh9OfWAc81VzD6ENglUtRNg/K7VOyWVuBLpJeLa9dVHD7Gjj/OqgudC7+av3wlcgOPJIMI+60SOHGyL7rTUeGRA7e67dB2p9YApAZv4HMPrVg8AqZs2OSMGnt4zNNJI66A==
x-ms-office365-filtering-correlation-id: d3ce6bcc-9487-4952-740c-08d640196aa4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3286;
x-ms-traffictypediagnostic: BYAPR11MB3286:
x-microsoft-antispam-prvs: <BYAPR11MB32862D9552E6FABB2330316BE3CE0@BYAPR11MB3286.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3286;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3286;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(105586002)(102836004)(2900100001)(5660300001)(106356001)(6916009)(4326008)(186003)(26005)(14444005)(78486014)(2906002)(476003)(446003)(305945005)(6506007)(14454004)(386003)(486006)(2616005)(7736002)(11346002)(86362001)(3846002)(6116002)(256004)(52116002)(8936002)(76176011)(478600001)(81156014)(8676002)(71200400001)(68736007)(71190400001)(72206003)(54906003)(316002)(25786009)(99286004)(81166006)(107886003)(66066001)(5250100002)(2501003)(5640700003)(53936002)(6512007)(6436002)(36756003)(6486002)(97736004)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3286;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: diRGW/7ZLJxqSudFNDlk2sKRwqIoZ8twPL0DyIs1zXWftT4YSqVm9qiCKyU+1noWszzUjP0SLTGa6SaTrkfXM33HyJO0r1PBQ/Nwyvgw/OjjEN7ZV9h9IInErOLshUiHl79wIeKMY/ww+UK6STTofptRg0T+CdHG4QzTSrvn+Ddl1XWzcc28OXWK5YcFVAXHRwraSw4ZTpIPkCFjIJk4RAu3Qk4NSKiyE5orzAnTWFgCaMzD70qBHjwz37bN17oKk/IZi3ByWg3b2u9EuZVu8FTR8OWMTIr2l/1+52jLFtfCmJllugOCPN6r8PWpViGvzmKnGfUk8vYa4KGpQEakV82LN6EZd4R9OfOJLCIlcF4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ce6bcc-9487-4952-740c-08d640196aa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:23.1029
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

After use of framework API's most of the redundant functions are removed
in coreconfigurator.c file. Now moved left over function to
host_interface file and deleted the coreconfigurator.c file.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile           |   3 +-
 drivers/staging/wilc1000/coreconfigurator.c | 126 ------------------------=
----
 drivers/staging/wilc1000/coreconfigurator.h |   4 -
 drivers/staging/wilc1000/host_interface.c   | 117 ++++++++++++++++++++++++=
++
 4 files changed, 118 insertions(+), 132 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/coreconfigurator.c

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/M=
akefile
index 37e8560..72a4daa 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -5,8 +5,7 @@ ccflags-y +=3D -DFIRMWARE_1002=3D\"atmel/wilc1002_firmware.=
bin\" \
 		-DFIRMWARE_1003=3D\"atmel/wilc1003_firmware.bin\"
=20
 wilc1000-objs :=3D wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
-			coreconfigurator.o host_interface.o \
-			wilc_wlan_cfg.o wilc_wlan.o
+			host_interface.o wilc_wlan_cfg.o wilc_wlan.o
=20
 obj-$(CONFIG_WILC1000_SDIO) +=3D wilc1000-sdio.o
 wilc1000-sdio-objs +=3D wilc_sdio.o
diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
deleted file mode 100644
index 2bd62fd..0000000
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ /dev/null
@@ -1,126 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
- * All rights reserved.
- */
-
-#include <net/cfg80211.h>
-
-#include "coreconfigurator.h"
-
-static inline u8 *get_bssid(struct ieee80211_mgmt *mgmt)
-{
-	if (ieee80211_has_fromds(mgmt->frame_control))
-		return mgmt->sa;
-	else if (ieee80211_has_tods(mgmt->frame_control))
-		return mgmt->da;
-	else
-		return mgmt->bssid;
-}
-
-s32 wilc_parse_network_info(u8 *msg_buffer,
-			    struct network_info **ret_network_info)
-{
-	struct network_info *info;
-	struct ieee80211_mgmt *mgt;
-	u8 *wid_val, *msa, *ies;
-	u16 wid_len, rx_len, ies_len;
-	u8 msg_type;
-	size_t offset;
-	const u8 *ch_elm, *tim_elm, *ssid_elm;
-
-	msg_type =3D msg_buffer[0];
-	if ('N' !=3D msg_type)
-		return -EFAULT;
-
-	wid_len =3D get_unaligned_le16(&msg_buffer[6]);
-	wid_val =3D &msg_buffer[8];
-
-	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info->rssi =3D wid_val[0];
-
-	msa =3D &wid_val[1];
-	mgt =3D (struct ieee80211_mgmt *)&wid_val[1];
-	rx_len =3D wid_len - 1;
-
-	if (ieee80211_is_probe_resp(mgt->frame_control)) {
-		info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
-		info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int);
-		info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
-		info->tsf_lo =3D (u32)info->tsf_hi;
-		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	} else if (ieee80211_is_beacon(mgt->frame_control)) {
-		info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
-		info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
-		info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
-		info->tsf_lo =3D (u32)info->tsf_hi;
-		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
-	} else {
-		/* only process probe response and beacon frame */
-		kfree(info);
-		return -EIO;
-	}
-
-	ether_addr_copy(info->bssid, get_bssid(mgt));
-
-	ies =3D mgt->u.beacon.variable;
-	ies_len =3D rx_len - offset;
-	if (ies_len <=3D 0) {
-		kfree(info);
-		return -EIO;
-	}
-
-	info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!info->ies) {
-		kfree(info);
-		return -ENOMEM;
-	}
-
-	info->ies_len =3D ies_len;
-
-	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies, ies_len);
-	if (ssid_elm) {
-		info->ssid_len =3D ssid_elm[1];
-		if (info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
-			memcpy(info->ssid, ssid_elm + 2, info->ssid_len);
-		else
-			info->ssid_len =3D 0;
-	}
-
-	ch_elm =3D cfg80211_find_ie(WLAN_EID_DS_PARAMS, ies, ies_len);
-	if (ch_elm && ch_elm[1] > 0)
-		info->ch =3D ch_elm[2];
-
-	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
-	if (tim_elm && tim_elm[1] >=3D 2)
-		info->dtim_period =3D tim_elm[3];
-
-	*ret_network_info =3D info;
-
-	return 0;
-}
-
-s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       struct connect_info *ret_conn_info)
-{
-	u8 *ies;
-	u16 ies_len;
-	struct assoc_resp *res =3D (struct assoc_resp *)buffer;
-
-	ret_conn_info->status =3D le16_to_cpu(res->status_code);
-	if (ret_conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
-		ies =3D &buffer[sizeof(*res)];
-		ies_len =3D buffer_len - sizeof(*res);
-
-		ret_conn_info->resp_ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
-		if (!ret_conn_info->resp_ies)
-			return -ENOMEM;
-
-		ret_conn_info->resp_ies_len =3D ies_len;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/=
wilc1000/coreconfigurator.h
index a1347f7..67f6855 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -64,10 +64,6 @@ struct assoc_resp {
 	__le16 aid;
 } __packed;
=20
-s32 wilc_parse_network_info(u8 *msg_buffer,
-			    struct network_info **ret_network_info);
-s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
-			       struct connect_info *ret_conn_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 01db899..c4f858b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1305,6 +1305,101 @@ static void *host_int_parse_join_bss_param(struct n=
etwork_info *info)
 	return (void *)param;
 }
=20
+static inline u8 *get_bssid(struct ieee80211_mgmt *mgmt)
+{
+	if (ieee80211_has_fromds(mgmt->frame_control))
+		return mgmt->sa;
+	else if (ieee80211_has_tods(mgmt->frame_control))
+		return mgmt->da;
+	else
+		return mgmt->bssid;
+}
+
+static s32 wilc_parse_network_info(u8 *msg_buffer,
+				   struct network_info **ret_network_info)
+{
+	struct network_info *info;
+	struct ieee80211_mgmt *mgt;
+	u8 *wid_val, *msa, *ies;
+	u16 wid_len, rx_len, ies_len;
+	u8 msg_type;
+	size_t offset;
+	const u8 *ch_elm, *tim_elm, *ssid_elm;
+
+	msg_type =3D msg_buffer[0];
+	if ('N' !=3D msg_type)
+		return -EFAULT;
+
+	wid_len =3D get_unaligned_le16(&msg_buffer[6]);
+	wid_val =3D &msg_buffer[8];
+
+	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->rssi =3D wid_val[0];
+
+	msa =3D &wid_val[1];
+	mgt =3D (struct ieee80211_mgmt *)&wid_val[1];
+	rx_len =3D wid_len - 1;
+
+	if (ieee80211_is_probe_resp(mgt->frame_control)) {
+		info->cap_info =3D le16_to_cpu(mgt->u.probe_resp.capab_info);
+		info->beacon_period =3D le16_to_cpu(mgt->u.probe_resp.beacon_int);
+		info->tsf_hi =3D le64_to_cpu(mgt->u.probe_resp.timestamp);
+		info->tsf_lo =3D (u32)info->tsf_hi;
+		offset =3D offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	} else if (ieee80211_is_beacon(mgt->frame_control)) {
+		info->cap_info =3D le16_to_cpu(mgt->u.beacon.capab_info);
+		info->beacon_period =3D le16_to_cpu(mgt->u.beacon.beacon_int);
+		info->tsf_hi =3D le64_to_cpu(mgt->u.beacon.timestamp);
+		info->tsf_lo =3D (u32)info->tsf_hi;
+		offset =3D offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	} else {
+		/* only process probe response and beacon frame */
+		kfree(info);
+		return -EIO;
+	}
+
+	ether_addr_copy(info->bssid, get_bssid(mgt));
+
+	ies =3D mgt->u.beacon.variable;
+	ies_len =3D rx_len - offset;
+	if (ies_len <=3D 0) {
+		kfree(info);
+		return -EIO;
+	}
+
+	info->ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+	if (!info->ies) {
+		kfree(info);
+		return -ENOMEM;
+	}
+
+	info->ies_len =3D ies_len;
+
+	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies, ies_len);
+	if (ssid_elm) {
+		info->ssid_len =3D ssid_elm[1];
+		if (info->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
+			memcpy(info->ssid, ssid_elm + 2, info->ssid_len);
+		else
+			info->ssid_len =3D 0;
+	}
+
+	ch_elm =3D cfg80211_find_ie(WLAN_EID_DS_PARAMS, ies, ies_len);
+	if (ch_elm && ch_elm[1] > 0)
+		info->ch =3D ch_elm[2];
+
+	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
+	if (tim_elm && tim_elm[1] >=3D 2)
+		info->dtim_period =3D tim_elm[3];
+
+	*ret_network_info =3D info;
+
+	return 0;
+}
+
 static void handle_rcvd_ntwrk_info(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -1410,6 +1505,28 @@ static inline void host_int_free_user_conn_req(struc=
t host_if_drv *hif_drv)
 	hif_drv->usr_conn_req.ies =3D NULL;
 }
=20
+static s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
+				      struct connect_info *ret_conn_info)
+{
+	u8 *ies;
+	u16 ies_len;
+	struct assoc_resp *res =3D (struct assoc_resp *)buffer;
+
+	ret_conn_info->status =3D le16_to_cpu(res->status_code);
+	if (ret_conn_info->status =3D=3D WLAN_STATUS_SUCCESS) {
+		ies =3D &buffer[sizeof(*res)];
+		ies_len =3D buffer_len - sizeof(*res);
+
+		ret_conn_info->resp_ies =3D kmemdup(ies, ies_len, GFP_KERNEL);
+		if (!ret_conn_info->resp_ies)
+			return -ENOMEM;
+
+		ret_conn_info->resp_ies_len =3D ies_len;
+	}
+
+	return 0;
+}
+
 static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 						  u8 mac_status)
 {
--=20
2.7.4

