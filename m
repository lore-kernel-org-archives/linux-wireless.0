Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F94C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 862F6206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="v0L5b92R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbfAIQSd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:18:33 -0500
Received: from mail-eopbgr730074.outbound.protection.outlook.com ([40.107.73.74]:41411
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731100AbfAIQSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:18:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEoLJJjeET7YVkkVmrU75AfN8ifqCZbwbdPtWBe7uQA=;
 b=v0L5b92RTgaLeeYB9wCYUs4QfvJ3CGE3DwxzJIzh8/TFSR/gOs/eW9l+XQimmms8xYU9DyZXoPXJgex3E0S1h2rkDjjjKPWREYGKQGTOz49nOVNLbWBJwOXnBVNpX1yAO/FO5jrfZRPYDH9ek7Uf8HpQzWl+WSobbde4u314Z8A=
Received: from DM6PR05MB6348.namprd05.prod.outlook.com (20.178.224.143) by
 DM6PR05MB5227.namprd05.prod.outlook.com (20.177.223.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.3; Wed, 9 Jan 2019 16:18:27 +0000
Received: from DM6PR05MB6348.namprd05.prod.outlook.com
 ([fe80::1509:cc07:d728:69df]) by DM6PR05MB6348.namprd05.prod.outlook.com
 ([fe80::1509:cc07:d728:69df%4]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:18:27 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:09:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:09:00 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 4/7] qtnfmac: switch to 32bit values for RTS/FRAG thresholds
Thread-Topic: [PATCH 4/7] qtnfmac: switch to 32bit values for RTS/FRAG
 thresholds
Thread-Index: AQHUqDWhN1AXDTY7LkCpTe4y+lKMQA==
Date:   Wed, 9 Jan 2019 16:09:00 +0000
Message-ID: <20190109160843.14832-5-sergey.matyukevich.os@quantenna.com>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB5227;6:rZIjjygB7zYKSJ3Ih9qVIo6iLwDzILBz4jhNxwAa6sUwfvlepHkrjftyMQ1yeqFmrcuQnH2J0LPaXe4+a6Cq8XwZIkAbVsfdJSyxgSzv0zkGIqve4fsHQlhaTgCnKeepYSQg2N45GGzkLTLbsoKrmMN9iuqIwCLeW6evcmghGlGztYEtGjkRgzpvrDbSEvz0JgkzyAsdMdCLOEYF+DcFXZ/pLXx3aNGOpE/uGQpVQp8Wz7eIroKJC3rq4kzlQGwmbpGdEDY9H2dpjzwDIlwjuG8F2KECviTLNjKTxw3RW6rxmyIkNUgdswV+PfLmzrMIfPItyO7USRwe9ChDySNOCs5SAFPtBzO5WaTjBqWne/uhRSOL+cw1v1wJPGUejUqileOf9rPY92h2NLZA9fFmtcrT/j1sTDZiS3oSDL8Fdutz/N61L4ANUiKt36n4SAwdhCksVK7bcEOsMEz/rk6d3g==;5:I5/hRkyThgKVGJDw/SqjgZVv2+Q+fSVOstYB+lV1iaZATsdZl4SnHXa6GTcSJ8mIjiPfnpFd0ZaPxhBuM55/zy1P1uzsqOVV5YA2x4LIjx4E8mxEZKvvcnK1LGdAZUeRPD6LfYPhOO9Fs0+uJyhLaMK0BxkP+sm4URCnFp+UYVgbDzY1S9cx+a7nkI8jvVUsv1MbY3vPi0A2OlPuegbuHg==;7:KOxQ27Yv4Up6wCcCQwxWB4QPG3loAiLksPjMv3nRY51NJCd6vGsLXKfggHHSOzr7Im441tZUQtxZGR+s+iZdRsMcIPNWGB5onlhkNTeWPxVEBDwTx+09VLbG/tsWBXJXev1/KyrK5i9ocadsNROVTg==
x-ms-office365-filtering-correlation-id: a1641de5-84c9-4510-a738-08d6764cc41f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|DM6PR05MB5227:
x-moderation-data: 1/9/2019 4:18:24 PM
x-microsoft-antispam-prvs: <DM6PR05MB5227089DE0326290A8BBF493A38B0@DM6PR05MB5227.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(1076003)(76176011)(36756003)(486006)(476003)(11346002)(5640700003)(446003)(7736002)(6486002)(81166006)(256004)(2616005)(81156014)(8676002)(6436002)(14454004)(14444005)(71190400001)(71200400001)(3846002)(6116002)(4326008)(99286004)(305945005)(436003)(2906002)(8936002)(5660300001)(53936002)(105586002)(2501003)(66066001)(316002)(107886003)(86362001)(575784001)(186003)(68736007)(54906003)(478600001)(6346003)(26005)(386003)(2351001)(103116003)(102836004)(106356001)(6512007)(6506007)(52116002)(6916009)(97736004)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB5227;H:DM6PR05MB6348.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 81Kr+YLr2kUsY0KdnNP26xMR1PW6UsbKkruHtDAxu/GDlcIYqcJtV7uef0F2DznCldN2wPFoAS0Kz8d36o3Gk4jKS8/z7qOD2BVxUus9P2kVPib1aHSZawT1jpJ1SO29zThmiVXNnrGQ6VGj7KlJvwgCo8UhQ+TvyCNMg0zHm97zvxECX96QG7eaJauMl0SgRtQlVEwo9LLtTzfPLVDCNhiiol3LUwHKvf64EG9diKw5QBjez/3TBXzE4s65Am7E/oA6KGeNK/a1MQtAQaI/BUdjoaQ4qtJBb4r6itJPfeOXNlmg2xFSaeeZu0JF2G9Z
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1641de5-84c9-4510-a738-08d6764cc41f
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:18:27.2624
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB5227
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Host wireless stack uses u32 type for RTS/FRAG threshold values.
Switch to u32 in driver: pass u32 values to firmware and let
firmware properly adapt these values according to its
internal representation.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c   |  8 ++++----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h      |  4 ++--
 drivers/net/wireless/quantenna/qtnfmac/qlink_util.h | 11 +++++++++++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 0748a756cc1c..66cb05dfdba5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1564,11 +1564,11 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtn=
f_wmac *mac,
 		switch (tlv_type) {
 		case QTN_TLV_ID_FRAG_THRESH:
 			phy_thr =3D (void *)tlv;
-			mac_info->frag_thr =3D (u32)le16_to_cpu(phy_thr->thr);
+			mac_info->frag_thr =3D le32_to_cpu(phy_thr->thr);
 			break;
 		case QTN_TLV_ID_RTS_THRESH:
 			phy_thr =3D (void *)tlv;
-			mac_info->rts_thr =3D (u32)le16_to_cpu(phy_thr->thr);
+			mac_info->rts_thr =3D le32_to_cpu(phy_thr->thr);
 			break;
 		case QTN_TLV_ID_SRETRY_LIMIT:
 			limit =3D (void *)tlv;
@@ -1816,10 +1816,10 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wma=
c *mac, u32 changed)
 	qtnf_bus_lock(mac->bus);
=20
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
-		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_FRAG_THRESH,
+		qtnf_cmd_skb_put_tlv_u32(cmd_skb, QTN_TLV_ID_FRAG_THRESH,
 					 wiphy->frag_threshold);
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD)
-		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_RTS_THRESH,
+		qtnf_cmd_skb_put_tlv_u32(cmd_skb, QTN_TLV_ID_RTS_THRESH,
 					 wiphy->rts_threshold);
 	if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index a78cb9e05068..ace52e9d421d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
=20
 #include <linux/ieee80211.h>
=20
-#define QLINK_PROTO_VER		11
+#define QLINK_PROTO_VER		12
=20
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -1184,7 +1184,7 @@ struct qlink_iface_limit_record {
=20
 struct qlink_tlv_frag_rts_thr {
 	struct qlink_tlv_hdr hdr;
-	__le16 thr;
+	__le32 thr;
 } __packed;
=20
 struct qlink_tlv_rlimit {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.h
index 960d5d97492f..fc87827cb49c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -69,6 +69,17 @@ static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_bu=
ff *skb,
 	memcpy(hdr->val, &tmp, sizeof(tmp));
 }
=20
+static inline void qtnf_cmd_skb_put_tlv_u32(struct sk_buff *skb,
+					    u16 tlv_id, u32 value)
+{
+	struct qlink_tlv_hdr *hdr =3D skb_put(skb, sizeof(*hdr) + sizeof(value));
+	__le32 tmp =3D cpu_to_le32(value);
+
+	hdr->type =3D cpu_to_le16(tlv_id);
+	hdr->len =3D cpu_to_le16(sizeof(value));
+	memcpy(hdr->val, &tmp, sizeof(tmp));
+}
+
 u16 qlink_iface_type_to_nl_mask(u16 qlink_type);
 u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
 void qlink_chandef_q2cfg(struct wiphy *wiphy,
--=20
2.11.0

