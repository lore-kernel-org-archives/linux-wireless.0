Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12ACEC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B797E205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="3YmZpiOV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B797E205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbeKBBs7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:48:59 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22172 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbeKBBs6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 21:48:58 -0400
X-IronPort-AV: E=Sophos;i="5.54,452,1534834800"; 
   d="scan'208";a="19785001"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Nov 2018 09:45:14 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 1 Nov 2018 09:45:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvCRvykrNwBX/ZIdEejwFaOE3YrKTn+xHf72ftvNij4=;
 b=3YmZpiOVh+VV8iNay5UliQa6D/3LnL8tilcVif7chvAawxyY0gQj3AZgU5Kxhpn9yP+9ga1h2FQuxJPyoF5T8dUrCs3l2Ed9cGAJNE2E+bZEIVxV0Es4/EJqwevBVTN/nx79gn9ngpiTh48ZOP7uYqpZ1dJ8+6If2Ka+/gzi3tU=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3463.namprd11.prod.outlook.com (20.177.187.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Thu, 1 Nov 2018 16:45:08 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::b548:a8e4:b647:5b7%6]) with mapi id 15.20.1273.027; Thu, 1 Nov 2018
 16:45:08 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 2/8] staging: wilc1000: remove unused code in coreconfigurator
Thread-Topic: [PATCH 2/8] staging: wilc1000: remove unused code in
 coreconfigurator
Thread-Index: AQHUcgI/Twuk2wmbMEWdKuIkyuBZyw==
Date:   Thu, 1 Nov 2018 16:45:08 +0000
Message-ID: <1541090691-31928-3-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3463;6:S+B0nRPu42HlEf4qj5mZTYCKQZ/ySLlsDWTa3bjVKR86AyZz8ws+d+VInEPHSGZc/nRgeHZ4yFxVwI0jz+nDJs5byNLaeBD+Qhym+U5+vuiEa1JNVUqoC1UVlvtCGm1PAh9Le9BFb/PmzPmZfzCgNwQdQGPaUTOKZA7BwJyrViBXo3fces3bIbmdqOHOsuNK/+ydfxwRwggSGvlRs/X7CrediOoD/1Gwr7a89KiyyVRSkXPIYxYwLN/ImsPIJJ4wK69HTYG5s92GMvgZ83Igbr1kjFFerJyxO+THJ/eRU6TcD2OL/3LpnmhUdDAYaZ2UtwjoU/FbHKhN9mtkzI5k+T6craqlh31jePq8WJcFVzPR/jLltdLk3vLoh11NrLkQtzryU+zP9O6UYniStsVGVs8fbzWZ7PbOGBEk7ePXJP7xmHe4T0tNE9Yzn9gFk9dPkz4IoMKaBiyVojAmBMccKQ==;5:03S6Gb5K/ox29zQg+96wKyP1chHjfF5s5kDJRc9Pp20OiMfOHjsmpvIJle/3AN29Yr9ls6fuHF1T/IXamShAGl5VuzBVlubCSW709JzdhXhgNYt2il26PdtwRI21Uce5zTde22sLnA5NXaTr5Frbejjt1PpL5ouW9Xv6MQxT07k=;7:Oes2Rx72Xyb3zgEVPwoIhTxKjCusTYD6ifXnRvk4rHeWOn1dJ6g8A5EKHiB9f9ek2Rtorvr5+5bwRklI/TMs9H2OrTsvU6nDsz5NADViQo2ncinOVzt8eTB6vMtgIpQBsIg5ergVy0KTrBJOiGHi1g==
x-ms-office365-filtering-correlation-id: aba20ca7-2b46-4b1e-24ab-08d6401961ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3463;
x-ms-traffictypediagnostic: BYAPR11MB3463:
x-microsoft-antispam-prvs: <BYAPR11MB34637A75A668D2872AA024F6E3CE0@BYAPR11MB3463.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3463;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3463;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(346002)(136003)(396003)(199004)(189003)(71190400001)(4326008)(5660300001)(305945005)(2351001)(6512007)(25786009)(97736004)(68736007)(53936002)(2906002)(71200400001)(6116002)(6436002)(3846002)(6486002)(78486014)(106356001)(478600001)(256004)(76176011)(107886003)(5250100002)(105586002)(7736002)(2501003)(8676002)(72206003)(54906003)(81166006)(14454004)(81156014)(486006)(8936002)(86362001)(2900100001)(52116002)(476003)(316002)(386003)(6506007)(5640700003)(66066001)(2616005)(26005)(446003)(36756003)(102836004)(11346002)(99286004)(186003)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3463;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eNtZUuM43W4FwMVQKgDsZLh9bZj6mLJgEovV+OCXgJz7rHXD7WLhH8MytaS0BsO+tgVzXzMCJDUobblURiDiH5RnNECo+HT8oazI2dsu+j03fHeGgCl+7vPDSzvJnOId1eq1Idf9wrmQDRc2XA5ZmltEQpm7CJAdzcUNVIN6HaXOTjRU6ZUnqigoI4fTWjJ8g/sWSReKX8EX3oC6mpDQkCWyWJ2o7wSZWaZYBozbYFmczzdzLeks3Vb2LFp9y/M0isRNGi/K1xD2q/D1sfV7LAsdrJ2J113i6CLjU2HeWs1ls1bx9xz3RI/YIMn99TjjmqZrJZj8HqRErA8vtf65qdB7P1SjC6IwT7f3czAcQJA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aba20ca7-2b46-4b1e-24ab-08d6401961ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 16:45:08.1099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3463
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

After refactoring of wilc_parse_network_info(), some of the functions and
macro are not required, so removed the unused code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 157 ------------------------=
----
 drivers/staging/wilc1000/coreconfigurator.h |   8 --
 2 files changed, 165 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/=
wilc1000/coreconfigurator.c
index 4dfa658..166443d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -8,99 +8,6 @@
=20
 #include "coreconfigurator.h"
=20
-#define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
-				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)
-
-enum sub_frame_type {
-	ASSOC_REQ             =3D 0x00,
-	ASSOC_RSP             =3D 0x10,
-	REASSOC_REQ           =3D 0x20,
-	REASSOC_RSP           =3D 0x30,
-	PROBE_REQ             =3D 0x40,
-	PROBE_RSP             =3D 0x50,
-	BEACON                =3D 0x80,
-	ATIM                  =3D 0x90,
-	DISASOC               =3D 0xA0,
-	AUTH                  =3D 0xB0,
-	DEAUTH                =3D 0xC0,
-	ACTION                =3D 0xD0,
-	PS_POLL               =3D 0xA4,
-	RTS                   =3D 0xB4,
-	CTS                   =3D 0xC4,
-	ACK                   =3D 0xD4,
-	CFEND                 =3D 0xE4,
-	CFEND_ACK             =3D 0xF4,
-	DATA                  =3D 0x08,
-	DATA_ACK              =3D 0x18,
-	DATA_POLL             =3D 0x28,
-	DATA_POLL_ACK         =3D 0x38,
-	NULL_FRAME            =3D 0x48,
-	CFACK                 =3D 0x58,
-	CFPOLL                =3D 0x68,
-	CFPOLL_ACK            =3D 0x78,
-	QOS_DATA              =3D 0x88,
-	QOS_DATA_ACK          =3D 0x98,
-	QOS_DATA_POLL         =3D 0xA8,
-	QOS_DATA_POLL_ACK     =3D 0xB8,
-	QOS_NULL_FRAME        =3D 0xC8,
-	QOS_CFPOLL            =3D 0xE8,
-	QOS_CFPOLL_ACK        =3D 0xF8,
-	BLOCKACK_REQ          =3D 0x84,
-	BLOCKACK              =3D 0x94,
-	FRAME_SUBTYPE_FORCE_32BIT  =3D 0xFFFFFFFF
-};
-
-static inline u16 get_beacon_period(u8 *data)
-{
-	u16 bcn_per;
-
-	bcn_per  =3D data[0];
-	bcn_per |=3D (data[1] << 8);
-
-	return bcn_per;
-}
-
-static inline u32 get_beacon_timestamp_lo(u8 *data)
-{
-	u32 time_stamp =3D 0;
-	u32 index    =3D MAC_HDR_LEN;
-
-	time_stamp |=3D data[index++];
-	time_stamp |=3D (data[index++] << 8);
-	time_stamp |=3D (data[index++] << 16);
-	time_stamp |=3D (data[index]   << 24);
-
-	return time_stamp;
-}
-
-static inline u32 get_beacon_timestamp_hi(u8 *data)
-{
-	u32 time_stamp =3D 0;
-	u32 index    =3D (MAC_HDR_LEN + 4);
-
-	time_stamp |=3D data[index++];
-	time_stamp |=3D (data[index++] << 8);
-	time_stamp |=3D (data[index++] << 16);
-	time_stamp |=3D (data[index]   << 24);
-
-	return time_stamp;
-}
-
-static inline enum sub_frame_type get_sub_type(u8 *header)
-{
-	return ((enum sub_frame_type)(header[0] & 0xFC));
-}
-
-static inline u8 get_to_ds(u8 *header)
-{
-	return (header[1] & 0x01);
-}
-
-static inline u8 get_from_ds(u8 *header)
-{
-	return ((header[1] & 0x02) >> 1);
-}
-
 static inline void get_address1(u8 *msa, u8 *addr)
 {
 	memcpy(addr, msa + 4, 6);
@@ -126,41 +33,6 @@ static inline void get_bssid(__le16 fc, u8 *data, u8 *b=
ssid)
 		get_address3(data, bssid);
 }
=20
-static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
-{
-	u8 i, j, len;
-
-	len =3D data[TAG_PARAM_OFFSET + 1];
-	j   =3D TAG_PARAM_OFFSET + 2;
-
-	if (len >=3D MAX_SSID_LEN)
-		len =3D 0;
-
-	for (i =3D 0; i < len; i++, j++)
-		ssid[i] =3D data[j];
-
-	ssid[len] =3D '\0';
-
-	*p_ssid_len =3D len;
-}
-
-static inline u16 get_cap_info(u8 *data)
-{
-	u16 cap_info =3D 0;
-	u16 index    =3D MAC_HDR_LEN;
-	enum sub_frame_type st;
-
-	st =3D get_sub_type(data);
-
-	if (st =3D=3D BEACON || st =3D=3D PROBE_RSP)
-		index +=3D TIME_STAMP_LEN + BEACON_INTERVAL_LEN;
-
-	cap_info  =3D data[index];
-	cap_info |=3D (data[index + 1] << 8);
-
-	return cap_info;
-}
-
 static inline u16 get_asoc_status(u8 *data)
 {
 	u16 asoc_status;
@@ -169,35 +41,6 @@ static inline u16 get_asoc_status(u8 *data)
 	return (asoc_status << 8) | data[2];
 }
=20
-static u8 *get_tim_elm(u8 *msa, u16 rx_len, u16 tag_param_offset)
-{
-	u16 index;
-
-	index =3D tag_param_offset;
-
-	while (index < (rx_len - FCS_LEN)) {
-		if (msa[index] =3D=3D WLAN_EID_TIM)
-			return &msa[index];
-		index +=3D (IE_HDR_LEN + msa[index + 1]);
-	}
-
-	return NULL;
-}
-
-static u8 get_current_channel_802_11n(u8 *msa, u16 rx_len)
-{
-	u16 index;
-
-	index =3D TAG_PARAM_OFFSET;
-	while (index < (rx_len - FCS_LEN)) {
-		if (msa[index] =3D=3D WLAN_EID_DS_PARAMS)
-			return msa[index + 2];
-		index +=3D msa[index + 1] + IE_HDR_LEN;
-	}
-
-	return 0;
-}
-
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info)
 {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/=
wilc1000/coreconfigurator.h
index b62acb4..0d40c77 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -11,14 +11,9 @@
=20
 #define NUM_RSSI                5
=20
-#define MAC_HDR_LEN             24
-#define FCS_LEN                 4
-#define TIME_STAMP_LEN          8
-#define BEACON_INTERVAL_LEN     2
 #define CAP_INFO_LEN            2
 #define STATUS_CODE_LEN         2
 #define AID_LEN                 2
-#define IE_HDR_LEN              2
=20
 #define SET_CFG              0
 #define GET_CFG              1
@@ -26,9 +21,6 @@
 #define MAX_STRING_LEN               256
 #define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
=20
-#define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
-#define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
-
 struct rssi_history_buffer {
 	bool full;
 	u8 index;
--=20
2.7.4

