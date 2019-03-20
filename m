Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C0AC10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2641E2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="MvS2/8JY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfCTKFl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:41 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:27568
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727606AbfCTKFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wojoG+LX2pNLZGHaRRVMVg+yBy+uxOOzuqBjcm1qiw=;
 b=MvS2/8JYCyU8Lqoh92BE7LJhyABv3PIJqR0efJ3rHkfllceWVnZr1/sRtrEbEzMLGElxHNB+aS1LXqZBaqngENANK/nWUezeWaTWevAB+jLC9PtEN8Xl8Rkvmiwd4Iu7nw0x6eh2+yoVK2DyvsPhYThJB7ZBQgKoyxE5Vr1YqGI=
Received: from BYAPR05MB6102.namprd05.prod.outlook.com (20.178.54.155) by
 BYAPR05MB5400.namprd05.prod.outlook.com (20.177.184.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Wed, 20 Mar 2019 10:05:24 +0000
Received: from BYAPR05MB6102.namprd05.prod.outlook.com
 ([fe80::9ca0:7dd:9457:a7b8]) by BYAPR05MB6102.namprd05.prod.outlook.com
 ([fe80::9ca0:7dd:9457:a7b8%5]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 10:05:24 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:11 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:11 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 14/14] qtnfmac: use scan duration param for different scan
 types
Thread-Topic: [PATCH 14/14] qtnfmac: use scan duration param for different
 scan types
Thread-Index: AQHU3wRDm2OHCHUsXE+fPKDxuoHk8w==
Date:   Wed, 20 Mar 2019 10:04:11 +0000
Message-ID: <20190320100340.14168-15-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc432bb5-7f7c-4989-107a-08d6ad1b660a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|BYAPR05MB5400:
x-moderation-data: 3/20/2019 10:05:22 AM
x-microsoft-antispam-prvs: <BYAPR05MB5400DA5A72B9D00884FACDDAA3410@BYAPR05MB5400.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39850400004)(366004)(346002)(136003)(396003)(199004)(189003)(107886003)(52116002)(478600001)(71190400001)(8936002)(71200400001)(81166006)(8676002)(6116002)(99286004)(3846002)(50226002)(5660300002)(26005)(68736007)(316002)(6506007)(102836004)(54906003)(14454004)(86362001)(256004)(14444005)(386003)(97736004)(1076003)(7736002)(53936002)(486006)(76176011)(81156014)(103116003)(476003)(2616005)(36756003)(6916009)(446003)(436003)(11346002)(6512007)(66066001)(2906002)(2501003)(186003)(106356001)(4326008)(2351001)(6436002)(6486002)(5640700003)(305945005)(25786009)(105586002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5400;H:BYAPR05MB6102.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T3Uhotb8xbM8srQKRMccW+6Ht5lUnBF7abM3SeCq1NA6RwH8GFQAa4Y6NSXL/i38TgFQWgO/J3dyu2pFD+l8I0xSgK8OsO/IPgYA9nQIl0lb3Zg7vPNwqbkKiWPQ2LPbdACR1hVlmezdG7Sf4yFfMdUXs3Jb8ZGH1/9YIOJaXTc77eXMZUmBrZQJ8eCv/rURptmoiJ5yEz4aOIhY+8tMuXuxvAl8jHjfpR+VBdbPngv0I4utlZFq3qUfGdvtFEH1vXZh+lYwJHpU2fXCxgb7C1T3B8UUamuCQfESVOTGtNr3B4MDDDm9aHmoqMXRHj1AEI0qgDZFe1wdNEmLatM92Tl0RoxEDzZ2qUHB9e3xvy1WVJtLYu4I4T9kvRqybdMh8vq0cO8RXakqUb6gFt1dku/9nMMvXbdmKRkelPBR3Yw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc432bb5-7f7c-4989-107a-08d6ad1b660a
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:24.2800
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5400
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Use scan duration param for both active and passive scan dwell times.
Document what different types of dwell times are used for. Explicitly
specify that if unset, automatic selection by device firmware
will be used.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 49 ++++++++++++++++++-=
----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 ++++-
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 62edddb8551e..e58495403dde 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -11,6 +11,13 @@
 #include "bus.h"
 #include "commands.h"
=20
+#define QTNF_SCAN_TIME_AUTO	0
+
+/* Let device itself to select best values for current conditions */
+#define QTNF_SCAN_DWELL_ACTIVE_DEFAULT		QTNF_SCAN_TIME_AUTO
+#define QTNF_SCAN_DWELL_PASSIVE_DEFAULT		QTNF_SCAN_TIME_AUTO
+#define QTNF_SCAN_SAMPLE_DURATION_DEFAULT	QTNF_SCAN_TIME_AUTO
+
 static int qtnf_cmd_check_reply_header(const struct qlink_resp *resp,
 				       u16 cmd_id, u8 mac_id, u8 vif_id,
 				       size_t resp_size)
@@ -938,7 +945,7 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		"\nHardware ID:           %s"  \
 		"\nCalibration version:   %s"  \
 		"\nU-Boot version:        %s"  \
-		"\nHardware version:      0x%08x",
+		"\nHardware version:      0x%08x\n",
 		bld_name, bld_rev, bld_type, bld_label,
 		(unsigned long)bld_tmstamp,
 		(unsigned long)plat_id,
@@ -2082,6 +2089,35 @@ static void qtnf_cmd_randmac_tlv_add(struct sk_buff =
*cmd_skb,
 	memcpy(randmac->mac_addr_mask, mac_addr_mask, ETH_ALEN);
 }
=20
+static void qtnf_cmd_scan_set_dwell(struct qtnf_wmac *mac,
+				    struct sk_buff *cmd_skb)
+{
+	struct cfg80211_scan_request *scan_req =3D mac->scan_req;
+	u16 dwell_active =3D QTNF_SCAN_DWELL_ACTIVE_DEFAULT;
+	u16 dwell_passive =3D QTNF_SCAN_DWELL_PASSIVE_DEFAULT;
+	u16 duration =3D QTNF_SCAN_SAMPLE_DURATION_DEFAULT;
+
+	if (scan_req->duration) {
+		dwell_active =3D scan_req->duration;
+		dwell_passive =3D scan_req->duration;
+	}
+
+	pr_debug("MAC%u: %s scan dwell active=3D%u, passive=3D%u, duration=3D%u\n=
",
+		 mac->macid,
+		 scan_req->duration_mandatory ? "mandatory" : "max",
+		 dwell_active, dwell_passive, duration);
+
+	qtnf_cmd_skb_put_tlv_u16(cmd_skb,
+				 QTN_TLV_ID_SCAN_DWELL_ACTIVE,
+				 dwell_active);
+	qtnf_cmd_skb_put_tlv_u16(cmd_skb,
+				 QTN_TLV_ID_SCAN_DWELL_PASSIVE,
+				 dwell_passive);
+	qtnf_cmd_skb_put_tlv_u16(cmd_skb,
+				 QTN_TLV_ID_SCAN_SAMPLE_DURATION,
+				 duration);
+}
+
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb;
@@ -2133,6 +2169,8 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 		}
 	}
=20
+	qtnf_cmd_scan_set_dwell(mac, cmd_skb);
+
 	if (scan_req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
 		pr_debug("MAC%u: scan with random addr=3D%pM, mask=3D%pM\n",
 			 mac->macid,
@@ -2148,15 +2186,6 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 		qtnf_cmd_skb_put_tlv_tag(cmd_skb, QTN_TLV_ID_SCAN_FLUSH);
 	}
=20
-	if (scan_req->duration) {
-		pr_debug("MAC%u: %s scan duration %u\n", mac->macid,
-			 scan_req->duration_mandatory ? "mandatory" : "max",
-			 scan_req->duration);
-
-		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_SCAN_DWELL,
-					 scan_req->duration);
-	}
-
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 2fe71adc221a..158c9eba20ef 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1162,6 +1162,13 @@ struct qlink_event_external_auth {
  *	carried by QTN_TLV_ID_STA_STATS_MAP.
  * @QTN_TLV_ID_MAX_SCAN_SSIDS: maximum number of SSIDs the device can scan
  *	for in any given scan.
+ * @QTN_TLV_ID_SCAN_DWELL_ACTIVE: time spent on a single channel for an ac=
tive
+ *	scan.
+ * @QTN_TLV_ID_SCAN_DWELL_PASSIVE: time spent on a single channel for a pa=
ssive
+ *	scan.
+ * @QTN_TLV_ID_SCAN_SAMPLE_DURATION: total duration of sampling a single c=
hannel
+ *	during a scan including off-channel dwell time and operating channel
+ *	time.
  */
 enum qlink_tlv_id {
 	QTN_TLV_ID_FRAG_THRESH		=3D 0x0201,
@@ -1194,7 +1201,9 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_WOWLAN_CAPAB		=3D 0x0410,
 	QTN_TLV_ID_WOWLAN_PATTERN	=3D 0x0411,
 	QTN_TLV_ID_SCAN_FLUSH		=3D 0x0412,
-	QTN_TLV_ID_SCAN_DWELL		=3D 0x0413,
+	QTN_TLV_ID_SCAN_DWELL_ACTIVE	=3D 0x0413,
+	QTN_TLV_ID_SCAN_DWELL_PASSIVE	=3D 0x0416,
+	QTN_TLV_ID_SCAN_SAMPLE_DURATION	=3D 0x0417,
 };
=20
 struct qlink_tlv_hdr {
--=20
2.11.0

