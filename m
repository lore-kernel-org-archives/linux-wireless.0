Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32601C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC86205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="PvnI5wJV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFC86205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbeKBBs7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:48:59 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:23507 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbeKBBs6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:48:58 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="22518393"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:14 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4ahWR0oTWmFX3Q1w8REDz7RGjjMiMQrDZGb+UACxg8=;
 b=PvnI5wJVYIgaaLlkL9qxaB2AC0iOmLDtIvQNfxIZ3IE/SsOkksAB0miiGJxgdoEOPrlJIyMmqq5KtrMUU0GQ1L4WZElr6zHpnf0nW9NEUJAMk8vBTDMy3RTtd/9b4FkWcRe1vXDXqmRUMLCMJDrTZ6ImX7E6l6DxnQENXMTijx8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3157.namprd11.prod.outlook.com (20.177.126.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Thu, 1 Nov 2018 16:45:12 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:12 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 3/8] staging: wilc1000: refactor get_bssid() function
Thread-Topic: [PATCH 3/8] staging: wilc1000: refactor get_bssid() function
Thread-Index: AQHUcgJBTVV1S6Dic0ela26+KMVh9A==
Date:   Thu, 1 Nov 2018 16:45:11 +0000
Message-ID: <1541090691-31928-4-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3157;6:OPygXMqEsGvV0WKieyzIHqI2uSjKM/9GVScC7WJvdfefFhy6cM1eMSGBlE9pTQF4y8raU0gKbVFU50zCLDoQcLjMTAcvXKGn8qOEFy/3JAqy9VyNh4A7urorgey1dK1wKckBDNM35v3ZaWyR9Ww5vF0+cuWoToTjiam5ZUCFxB6io7H9brRC1XjMvpTzpzoW5T+c0k9CTIL1Rk3x2vOZv7zsJ1/cIDjlOV7slfZW6AfDilgX2kJzEFeIwFNQmnIjlR4oqiTRg245Hz0XDTIsnITo2WDz3SjJu+Pb2s5tEhOV4lEqaY/UdfqZb+/l5p4YPKcDHaWmIm4E1hk5PeON+uQzdu9BhcDUU5bC8MRdn/MQ/amH9V4Ky2HYfBxH8UQ7aaWZzrkdjGXCqvsDarZv6CHLCBcssSFbbKq4yENiOJai0zm5+uJ3DFID/hl5r4QwVbcFSBJtDTlLhKQDcQXCeg==;5:K0R8spka6I8YVrJUUjTdEPI6FzSn3mcWpbJaYkUzFMxFn0I6XDUbTh/byrftuBXIWm/JJ8mcz3BKQW7gG1/7QMhDt7NaZisowfnW0MSp2pwbholOxYMT1IeVQHkjJdU/Nn1swN1ZnXPocx66/ipM4rQgQ2lASesJfNeWi+6Pbd8=;7:LWvm1jsPNvgWx9YS0CB6J4K/oOiB0SWu1NuRkzH8dxj3PsX6gOlVoNi8pSfJnvO6YwtbMov106dmQTWVWbGsqaRA3MKFlKl8f8Zo0qBZtV/F3mQ1UdfIWsdJpjZTKScSgxf5J+z3qfzLaEp8ggua/A==
x-ms-office365-filtering-correlation-id: 72fc9195-874c-4589-16cf-08d640196374
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3157;
x-ms-traffictypediagnostic: BYAPR11MB3157:
x-microsoft-antispam-prvs: <BYAPR11MB31577409A627B75D70A2FA7DE3CE0@BYAPR11MB3157.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3157;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3157;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39860400002)(136003)(376002)(199004)(189003)(6436002)(14454004)(26005)(71190400001)(68736007)(5660300001)(71200400001)(107886003)(2501003)(5250100002)(5640700003)(36756003)(102836004)(97736004)(53936002)(486006)(6512007)(6916009)(478600001)(2900100001)(2351001)(305945005)(476003)(76176011)(2906002)(86362001)(66066001)(11346002)(99286004)(2616005)(72206003)(256004)(52116002)(446003)(106356001)(105586002)(316002)(54906003)(6486002)(81156014)(8676002)(3846002)(81166006)(8936002)(186003)(25786009)(4326008)(6506007)(6116002)(386003)(7736002)(78486014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3157;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: OGN5S9e2tWj0B5d1LDxKl1T6Ku9U2V6kKcIk2PqG1zpixhtg2IMUpZRzrCUR+cKh/OBd73seM7QHXNV+d4lYCKw+2IPH6uzi+fVYrlsfYbmuuO2hVuLi3ZiIX4tQ1vxPNA98ZqMOb8hhwxTcF2ZOqrUv8tDuVCjzHpYIW3Y6HmyHN5Jg2ihurdPVnkfFzZnNV17bo+nPeT/kaO9vmrritbeTCwWKLpB1jNJl9ck2gVC0Hx+gmIAYyJ6bItP11KAP3uNh00fl7jkVLRaJTaSkhpiGgIkrSYHQLbfw1F5ySu9m50O8ke+PrdR9hBTe9j4qAhdNGwhEq02V1jUMsYc9XtkcsDpD0jGJsOn2eeaUtvQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72fc9195-874c-4589-16cf-08d640196374
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:11.2300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3157
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor get_bssid() by making use of 'ieee80211_mgmt' struct. Instead
of passing the memory offset now using structure element to fetch the
bssid information.
Returning the pointer to bssid from get_bssid() instead of filing the
input argument.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 29 +++++++------------------=
----
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
index 166443d..ac44846 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -8,29 +8,14 @@
=20
 #include "coreconfigurator.h"
=20
-static inline void get_address1(u8 *msa, u8 *addr)
+static inline u8 *get_bssid(struct ieee80211_mgmt *mgmt)
 {
-	memcpy(addr, msa + 4, 6);
-}
-
-static inline void get_address2(u8 *msa, u8 *addr)
-{
-	memcpy(addr, msa + 10, 6);
-}
-
-static inline void get_address3(u8 *msa, u8 *addr)
-{
-	memcpy(addr, msa + 16, 6);
-}
-
-static inline void get_bssid(__le16 fc, u8 *data, u8 *bssid)
-{
-	if (ieee80211_has_fromds(fc))
-		get_address2(data, bssid);
-	else if (ieee80211_has_tods(fc))
-		get_address1(data, bssid);
+	if (ieee80211_has_fromds(mgmt->frame_control))
+		return mgmt->sa;
+	else if (ieee80211_has_tods(mgmt->frame_control))
+		return mgmt->da;
 	else
-		get_address3(data, bssid);
+		return mgmt->bssid;
 }
=20
 static inline u16 get_asoc_status(u8 *data)
@@ -87,7 +72,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 		return -EIO;
 	}
=20
-	get_bssid(mgt->frame_control, msa, network_info->bssid);
+	ether_addr_copy(network_info->bssid, get_bssid(mgt));
=20
 	ies =3D mgt->u.beacon.variable;
 	ies_len =3D rx_len - offset;
--=20
2.7.4

