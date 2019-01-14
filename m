Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0429DC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7DF20659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="kk/izEhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfANJky (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:54 -0500
Received: from mail-eopbgr690063.outbound.protection.outlook.com ([40.107.69.63]:62152
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726553AbfANJkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEoLJJjeET7YVkkVmrU75AfN8ifqCZbwbdPtWBe7uQA=;
 b=kk/izEhxGiPZrDXMsOY3q6ffoLeEqPLyWYeX8J0gezAB8HJ8j8uzGap9mJvpfr1YOPTKNrmW1FNVkweHl0JgghXJZ3hj8kMoPMbpOJXUVZcqO3/ygY2i12NpODW2f5mUYLcODgDNjCfx9YIvl/8sQFZlzm5SeFsm6aywk2JxuKQ=
Received: from BYAPR05MB5352.namprd05.prod.outlook.com (20.177.127.161) by
 BYAPR05MB6631.namprd05.prod.outlook.com (20.179.60.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Mon, 14 Jan 2019 09:40:44 +0000
Received: from BYAPR05MB5352.namprd05.prod.outlook.com
 ([fe80::7923:9302:1418:e431]) by BYAPR05MB5352.namprd05.prod.outlook.com
 ([fe80::7923:9302:1418:e431%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:44 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:41 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:41 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 4/9] qtnfmac: switch to 32bit values for RTS/FRAG
 thresholds
Thread-Topic: [PATCH v2 4/9] qtnfmac: switch to 32bit values for RTS/FRAG
 thresholds
Thread-Index: AQHUq+0S3v7o9/ZvQEWFbYwTc8bZSA==
Date:   Mon, 14 Jan 2019 09:39:40 +0000
Message-ID: <20190114093925.9061-5-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB6631;6:DAEa5WijXChE7y+X/N4nQOmRFVB5VIzf7q+tk1/NE+rpaF+nD5gNJm3JRx+SqLiEpr6XNEDPVxYF8LnpcGmKTnx6f27CPzv1HmIAM0K0nNmRM2mmpYS3dTSbpweUf0msTal7SmBNiRHLci2R9oPNqaSJRPKx/IqCbOsh8CJgboVHE3iSVJaowXqZpZ7D8jAJQtSBynnS4w8zC1//kDfXqpRx+xW7Kd7rsix1CC40iYHTTYuIdnBKvn3u8VPCJToB9wU+4PgdTb7mi1+BzW8SbipXSHotQE6UrgFZHL3cOp5tREY4ZSQApoIpVSFDlTGXx8OR6F2VsJSbUKAkN6NSsHUpUNbDwQim09UUQIf80G6SjWNDDnPt6jLvT2Y0ruqSdis2JBjzNBQjsUM/w8D8lb48SVRBKF/pKPfi57ai4wET4hfNsUYhS5d7Y6cShlFXCDGtd+AhND50wNXYyloPDg==;5:GaeaX+0BSV6cPBp+opwy9X0gap2MpE+zGGlr5ExlWUM9J5mmzS5zgDQp7wavFcljDy1upz9LulW8BlL7uXmZIm8dJeE/HVGrpgK5wMN8lh4J5H3Zizfqgdk/cl9Yydjxl5jAAUrFbMkKKUzorbl9vCmg5KOaQqmKV+AHw3iXSJJwo3EMSV+xlM+5guQqbsLsYvkhiIv8XIsA2fsj9vWq1Q==;7:2teu0wBojy+VlgqsDQ3yCUfkC/t9yyPqPQzp8vJyhI0O5qIOPAlV1rmD4zqmjCiFBNo3QCp8WAwbLdFue1t/fz+2xvi/yH62ApDYdAfxAyqMnm7E9Z7ZSZe4CMN4L8d7CKM5mC9HVcUMgb5tXZbdyQ==
x-ms-office365-filtering-correlation-id: 7edf2816-7a7b-4d25-74db-08d67a0434db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|BYAPR05MB6631:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:41 AM
x-microsoft-antispam-prvs: <BYAPR05MB663128072174FA3569FAB0FBA3800@BYAPR05MB6631.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(346002)(396003)(39840400004)(189003)(199004)(14454004)(14444005)(7736002)(2501003)(8936002)(2616005)(256004)(6916009)(107886003)(11346002)(3846002)(66066001)(6436002)(97736004)(103116003)(476003)(4326008)(446003)(81166006)(53936002)(6486002)(486006)(6116002)(36756003)(8676002)(81156014)(305945005)(5660300001)(6512007)(76176011)(52116002)(186003)(26005)(25786009)(54906003)(2906002)(105586002)(99286004)(575784001)(68736007)(5640700003)(316002)(6506007)(386003)(86362001)(106356001)(71190400001)(102836004)(2351001)(478600001)(71200400001)(436003)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6631;H:BYAPR05MB5352.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fgpJWtkxX3Ffv0hFATi2crmRYghXXXy53l7NPsGL6jJOveu2/56k8jL+wBeabATUqZadksm2NI3wEAXeNfApCaUFcGnO9yT90pwcc/V75O8h0OH6toh13CJijW5xRJCIdTvDdenN7eugwksr8fjU6xKyW7miCAtpyTD0oh5dEEAxUAxgbCKPXGcF8xUbZTMd4oea6PTRWwiGRl4Jg5mlEjYCJo+sifE5Bzur5kpA+W2U0Ex4vvVFM6c0iHX+CGoXpZQi6BEtEywZqfkaPNphX1FUYTmRuDF1xWqphZsPKuFlNtmEabTj+f2ob8D7+8v7ObKERT+0845HYPzmNZsZlGPOdAjel8MfwqKAh5DRVAeOUT+IahQKS8K2FmIG/RUbRJjYKqlCXFz/mV3uMHdzdjInFWDT8kSb8fVo1iitC9o=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edf2816-7a7b-4d25-74db-08d67a0434db
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:44.3282
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6631
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

