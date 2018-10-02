Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D51C64EB5
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8182D2089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Y8/Q8yWC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8182D2089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbeJBQIb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:31 -0400
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:16160
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbeJBQIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWNcrcZGMxXagv5p8mieH+yUzC6JS575msfJJpBHBGA=;
 b=Y8/Q8yWCedrvG3yIwQsOllWzd6AOT6lL9DHbHreFKiULWtOXM5xnjB8op3s5/sGcagIqSAj4DMYX55tMcOknpWgbaHr9sUNTB4TODPVbF3ihIS4U1JaZnXNV6UW3SHtXziyUi5jb/Tzw6BqFcXv1vFXLiQ6Menxafi1g5HhzE8c=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Tue, 2 Oct 2018 09:26:06 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:06 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 10/13] qtnfmac: add support for scan flush
Thread-Topic: [PATCH 10/13] qtnfmac: add support for scan flush
Thread-Index: AQHUWjHyAGTyPrqvaESE9MWOaau7Dg==
Date:   Tue, 2 Oct 2018 09:26:06 +0000
Message-ID: <20181002092542.18966-11-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:6/mgrPex4WyzZrWWOBHrdepi82ra+q8pYjGA3jVlnQwRuQjCKJF9gVXs+eEMYBimMkK7dWROsVbJxtRSJqlvNpl2h4ez7YAWWPRYHSuBpLN2fBuOL8RHqU+U+IRZm1Zvw6dHq/G2OXv/grhk7dJudB0RWHUG+wrhPsZlop6hFgThB6/Y0+f2dBzZmJhcDqrnW83sGw88YBRxhrpmbCRGanamEONTL2Blfdk9p9TfCN9Vs/P/I0mDCeZUweUBiBB7xhKVMTBTVF12N+Ih/y4Rv/mVBI/ZWFvz55thXtTG3M8QgVPhdx1PD6HxLx3Ab/6DgLZtauPRPYqeMvRDTgTKU2qQe1BFB9ZHpFJy4T4MsIevqgJJpjveJXh3GO3o4a7C9OHFFA8FArvMTiEeOZPo/vL8JIAkj6bY9+ULAW345brGgnVDOLvj2F/KRaN6K3QeH6pRhKGKkLjppnP2k0QFlw==;5:WURq8OZvBuI6alwLhYqHhTq7QKVotWDIHRYYBVm0UNyrriRjLK5p+ai+BY6YmgMG2JLerQw1sble4fFzRKHVNA4DO6Uu1hF776G4thywqE3RBOkMPbANDm8V9g78SmTLC+p995bBNevr79MtaXF47nswXI1jLHwXFV44eRgqiLw=;7:47bxvSxGgKSvhJptuBnrd+2Ko6hQ+UTKyGTpGpgCEkYwXgO/k1PVWIdPjXDzG/M0j6rlhkOJzwVKuUck7xIex893TBwQBmFUKSm3uJRvzrlsQYSkQbTzlyupAwMn4nDyqvzsYBiDqQAEjmP1TTTDFgKcf+sCOGiHumPn2jOQrV5sMweNFHk919bW2/RqCy43A2jWxdAv3EIs2pUE6Hn5/a3Wvz0F2o/XiLoXn/FNObVjr6uqzpgE/Kx8LR90M9bW
x-ms-office365-filtering-correlation-id: 8fc3b26e-1fd6-49d4-cfb7-08d628491486
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB5266233E036D56575F95F609A3E80@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39850400004)(136003)(396003)(199004)(189003)(1076002)(316002)(105586002)(186003)(305945005)(11346002)(3846002)(486006)(5640700003)(256004)(6512007)(6436002)(8936002)(14454004)(476003)(36756003)(2351001)(106356001)(2616005)(81156014)(66066001)(81166006)(86362001)(54906003)(446003)(68736007)(6116002)(5250100002)(107886003)(5660300001)(25786009)(71190400001)(6916009)(99286004)(2906002)(71200400001)(26005)(102836004)(2501003)(6506007)(386003)(52116002)(76176011)(478600001)(97736004)(103116003)(8676002)(6486002)(2900100001)(7736002)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Fb0KPS5TZc/IRo6KJMHkV9HEK2jcTekqs1JVuEa/UCA8wSv+6eDqO43tnpm5VCmA9aLexOgnvnA6Z6h8fxzhPsfQbgniNeQw5syBfdaX3wVWhMeSsxwZb9zJGOvrN05UVsGfG3YKfmQEs210ibRJ+eUcbUKNikUFwbxB04PSTLLRCtvfx1j7rb41n0ysGCk9bSG3pAjlrA+BfktuGiOTtBbO/s3ahwzJFfj6upPsUM1Ngas9hHO+s2sf4FT0MeQi+Ii48OymbalYy7+vYVUZO8dnXUx67q+pONxyLSlIue22QtaBwPZLFhOGEToZ89VNBWGL13lbPPSiRihEXBuCscSVfMxOHjYbQsd+8q+u0fY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc3b26e-1fd6-49d4-cfb7-08d628491486
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:06.5499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Notify firmware to flush cache before scanning when needed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c   | 6 ++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h      | 1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 8dbd6c45c233..8fb15cbf5005 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2197,6 +2197,12 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 					 scan_req->mac_addr_mask);
 	}
=20
+	if (scan_req->flags & NL80211_SCAN_FLAG_FLUSH) {
+		pr_debug("MAC%u: flush cache before scan\n", mac->macid);
+
+		qtnf_cmd_skb_put_tlv_tag(cmd_skb, QTN_TLV_ID_SCAN_FLUSH);
+	}
+
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index c5ae4ea9a47a..699157100309 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1151,6 +1151,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_MAX_SCAN_SSIDS	=3D 0x0409,
 	QTN_TLV_ID_WOWLAN_CAPAB		=3D 0x0410,
 	QTN_TLV_ID_WOWLAN_PATTERN	=3D 0x0411,
+	QTN_TLV_ID_SCAN_FLUSH		=3D 0x0412,
 };
=20
 struct qlink_tlv_hdr {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.h
index 54caeb38917c..960d5d97492f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -40,6 +40,14 @@ static inline void qtnf_cmd_skb_put_tlv_arr(struct sk_bu=
ff *skb,
 	memcpy(hdr->val, arr, arr_len);
 }
=20
+static inline void qtnf_cmd_skb_put_tlv_tag(struct sk_buff *skb, u16 tlv_i=
d)
+{
+	struct qlink_tlv_hdr *hdr =3D skb_put(skb, sizeof(*hdr));
+
+	hdr->type =3D cpu_to_le16(tlv_id);
+	hdr->len =3D cpu_to_le16(0);
+}
+
 static inline void qtnf_cmd_skb_put_tlv_u8(struct sk_buff *skb, u16 tlv_id=
,
 					   u8 value)
 {
--=20
2.11.0

