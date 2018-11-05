Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC04EC46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CCB2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Mjwa2F8E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9CCB2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbeKEXvP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:51:15 -0500
Received: from mail-eopbgr720050.outbound.protection.outlook.com ([40.107.72.50]:31870
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbeKEXvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:51:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Po/52WKOMBlUayrKF3x6lyf06FuUfL45LPo6WJ0MURw=;
 b=Mjwa2F8ESKcSmz8vmw56eadh22O8kha8VDZVtoqnq+56+z6mT2b5U1n5zBGmkwIUi+sakK2OoT3IQXJjL3sZCijUfkwAWOh77Pz+6hjN6TJN7q3v8B9AAz1BmVo7jJiPQ8AQCZp/FY0arwdZKcC2hQ7RsM13GDbFLFLLQaOYL3c=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5364.namprd05.prod.outlook.com (10.167.233.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.9; Mon, 5 Nov 2018 14:30:40 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.028; Mon, 5 Nov 2018
 14:30:40 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     Jouni Malinen <j@w1.fi>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC 3/3] qtnfmac: add support for basic aggregation control
Thread-Topic: [RFC 3/3] qtnfmac: add support for basic aggregation control
Thread-Index: AQHUdRQgXc5hPkh5qEWDRDb/jMQ85w==
Date:   Mon, 5 Nov 2018 14:30:40 +0000
Message-ID: <20181105143027.17570-4-sergey.matyukevich.os@quantenna.com>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0090.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::31) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5364;6:k49rChojMfkKWQPbPqNx823+lAgXBVTIAmqTZanV8fzRE0H/GOZUrj1nWW9AI3XS29GIvlBAWYCzMgVLkrgW5qaZTyloc+p0Chg7ift9HqDpFIQbQOb7R6Vevv1XCgnyIu2wZs95IrWZH+mVCV+wXh/Ff5eJEIVb4TAqvZsxkjxqW95SAea47m/PP8vjb/p0AiDCRKX5926v90yR+bcCUOYavFlqBZ3YSr8cBuhdsq7X2+mcv3ze6FZCwgRmlm7+MmiI47dwhTadBMNS958mzhpjtwhLn/EH2LL8nLl66ptx0+RcgFTVt0CxVimjd8iuYFM1rpFJHWx/+dlf4PQwsYLmjL4yj2Cj7zfZYnQ8EKcZf3TnzghDgNoxQnogpjG1duOaDh6mmxbWjTNczroMnErpJKsSGn5r7FGNo+tdYkgsqj7ClkZLxYqwmoA18qqs4N6qicLR1mpg9XK9MT8pow==;5:2hCa6at2ozhBwCTDpGeycQLt506v4vQf0udtwi+g3DMnMHHvO9CHySRGBuI0tY9uGLtWuMbsbCvHOHVQbcAgN+N8QhNtu+PwL23Ow6Dt0FvqFjRSnc72uicsBirhOeY1DbZnPcwq6Lqil5xiseBC3K0HWS+qVHIgRUSQ+nBIDQw=;7:1DKSOGa0uyQwVvaUcmbvzhRVg7klRsKoTcJAGLsTZSy/VNLAlmwNBngpK3LPb4s7zWdGC2BbRjMmUAeLIvAjB/mjHQVaHS+QHJKzUKWd9lkfXdA+rQ1qPU1wAjz7qS9wDCMoY08nnicR9LR9lkqeow==
x-ms-office365-filtering-correlation-id: b3948216-ab4a-464d-c99f-08d6432b42bc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5364;
x-ms-traffictypediagnostic: BL0PR05MB5364:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB5364A52EFB6035CAF6B3CD0FA3CA0@BL0PR05MB5364.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5364;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5364;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39840400004)(366004)(346002)(189003)(199004)(14454004)(386003)(6506007)(36756003)(5660300001)(102836004)(186003)(2906002)(8936002)(54906003)(110136005)(103116003)(476003)(26005)(81156014)(8676002)(486006)(2616005)(105586002)(446003)(97736004)(11346002)(81166006)(106356001)(6436002)(6512007)(1076002)(6486002)(256004)(14444005)(68736007)(7736002)(6116002)(3846002)(99286004)(4326008)(53936002)(76176011)(305945005)(66066001)(86362001)(316002)(2501003)(575784001)(107886003)(71190400001)(71200400001)(478600001)(25786009)(52116002)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5364;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: M9+Cxh4Rh2rchpcIdiCtejGo3VYOmFgBergaN0JnK4GAKx4zJTTiikOXeLcTHoFAoucTODhPzApHCv12DTj5TdEcOAA1AeaFID9khOz4qFYHL6grh6XeDcaTEK3Um41i0FVxll8XvQM8bQj05W8CUFNneJE5Y//WYcxgtmAlzyqOuo7Cy6FwPqceXyHPaz2OX3BNsmQz3DaHGP4r0hUTnXfV3FVkg5tpbeqgKHIkzD3AM977oqdACrUEcnOcCIPVRQVD0fhliUWUrH+1VNb37lEfYa/6WM0uf5FLiGnEx7cY9ksnKXW+AnMwJAs87rtXiEP2vWZhI1CizwwxfcWHLKWHX/0yzycY5aoiN4RPehw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3948216-ab4a-464d-c99f-08d6432b42bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 14:30:40.4979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5364
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for basic AMPDU/AMSDU aggregation control:
- report initial aggregation configuration to cfg80211 core
- pass AMPDU/AMSDU aggregation changes to wireless card
  using set_wiphy_params cfg80211 callback

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  2 ++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 17 +++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  2 ++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  7 +++++++
 4 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 51b33ec78fac..98bd0a3d29db 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1087,6 +1087,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 	wiphy->retry_short =3D macinfo->sretry_limit;
 	wiphy->retry_long =3D macinfo->lretry_limit;
 	wiphy->coverage_class =3D macinfo->coverage_class;
+	wiphy->ampdu_enabled =3D macinfo->ampdu_enabled;
+	wiphy->amsdu_enabled =3D macinfo->amsdu_enabled;
=20
 	wiphy->max_scan_ssids =3D
 		(hw_info->max_scan_ssids) ? hw_info->max_scan_ssids : 1;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index bfdc1ad30c13..6ab0a25b917f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1531,6 +1531,7 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtnf_=
wmac *mac,
 	struct qlink_tlv_frag_rts_thr *phy_thr;
 	struct qlink_tlv_rlimit *limit;
 	struct qlink_tlv_cclass *class;
+	struct qlink_tlv_aggr *aggr;
 	u16 tlv_type;
 	u16 tlv_value_len;
 	size_t tlv_full_len;
@@ -1571,6 +1572,14 @@ static int qtnf_cmd_resp_proc_phy_params(struct qtnf=
_wmac *mac,
 			class =3D (void *)tlv;
 			mac_info->coverage_class =3D class->cclass;
 			break;
+		case QTN_TLV_ID_AMPDU_ENABLED:
+			aggr =3D (void *)tlv;
+			mac_info->ampdu_enabled =3D aggr->aggr;
+			break;
+		case QTN_TLV_ID_AMSDU_ENABLED:
+			aggr =3D (void *)tlv;
+			mac_info->amsdu_enabled =3D aggr->aggr;
+			break;
 		default:
 			pr_err("MAC%u: Unknown TLV type: %#x\n", mac->macid,
 			       le16_to_cpu(tlv->type));
@@ -1814,6 +1823,14 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac=
 *mac, u32 changed)
 		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
 					wiphy->coverage_class);
=20
+	if (changed & WIPHY_PARAM_AMPDU_ENABLED)
+		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_AMPDU_ENABLED,
+					wiphy->ampdu_enabled);
+
+	if (changed & WIPHY_PARAM_AMSDU_ENABLED)
+		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_AMSDU_ENABLED,
+					wiphy->amsdu_enabled);
+
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index 293055049caa..e6752faf0f50 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -94,6 +94,8 @@ struct qtnf_mac_info {
 	u8 lretry_limit;
 	u8 sretry_limit;
 	u8 coverage_class;
+	u8 amsdu_enabled;
+	u8 ampdu_enabled;
 	u8 radar_detect_widths;
 	u32 max_acl_mac_addrs;
 	struct ieee80211_ht_cap ht_cap_mod_mask;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 8d62addea895..7dede44c75d7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1154,6 +1154,8 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_WOWLAN_PATTERN	=3D 0x0411,
 	QTN_TLV_ID_SCAN_FLUSH		=3D 0x0412,
 	QTN_TLV_ID_SCAN_DWELL		=3D 0x0413,
+	QTN_TLV_ID_AMPDU_ENABLED	=3D 0x0414,
+	QTN_TLV_ID_AMSDU_ENABLED	=3D 0x0415,
 };
=20
 struct qlink_tlv_hdr {
@@ -1195,6 +1197,11 @@ struct qlink_tlv_cclass {
 	u8 cclass;
 } __packed;
=20
+struct qlink_tlv_aggr {
+	struct qlink_tlv_hdr hdr;
+	u8 aggr;
+} __packed;
+
 /**
  * enum qlink_reg_rule_flags - regulatory rule flags
  *
--=20
2.11.0

