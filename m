Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F62C65BA9
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA7B20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="xXYXQUoh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA7B20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbeJERJx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:53 -0400
Received: from mail-eopbgr730079.outbound.protection.outlook.com ([40.107.73.79]:1696
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWNcrcZGMxXagv5p8mieH+yUzC6JS575msfJJpBHBGA=;
 b=xXYXQUohdMgIT1uF7eGEu5mLibn322+05BCqkH0tZCcyk1vdV4qolXmFEz7P1S12vXe14lJcP+NsbnUZmRN+BgW9rf5Z9gNK/CjxhKqsn75rkBcjsuHLLix+LVP3DZxRr2Ez2/FJv25upKvO0JexuSoic6U77UfweuU7uMCgGf8=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:42 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:41 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 10/13] qtnfmac: add support for scan flush
Thread-Topic: [PATCH v2 10/13] qtnfmac: add support for scan flush
Thread-Index: AQHUXJPPPivQXcDrdEWD0AOO6N3x0g==
Date:   Fri, 5 Oct 2018 10:11:41 +0000
Message-ID: <20181005101114.3013-11-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:+AwZFoaYAwjQ8Hqr0QwtkEqeoH4Ui78GtK31nTaUbw0YbqBD/Hl3bJ4mITz8tBwDosPPP8RFk9FphaFp6GbKPh2KpGixgbdcvFeTpZzptYNfWM8E/uphRk9mWd0ssEKU/QZYVxRXe0CHlA2BcOoe9/fe/afich3pF5z+0XVhZfD0YXTO9MzGC6conwy7PWaNiqINOZYhqET/RrJCFHaePaZpVcY0r6Y2rH2SN6NVpnpJN+ihOUr/uH1vqhhrfKcw50gY3U50FbTqGwFcu1NhNjU7NcdK1uQzwnYT1NFhX2KfpdImgtmyUfIl9WxsCHG2gafIulTqjToiUHHNX3tqWhVGUEI2iyvNB8Bfyog+O7H//Rlg15y0Apd5xlRcBzt1i2HoX2G2mTpr1+fAwj+n9CRd28eeQrERbytohX30QYZHULRzZ9Mdf+LwhdBlI6tbzFmu4ITdfYJCwUehf84PyQ==;5:2WNry/4OTma8wagEiuqo8wt/gjzu91YkRFloMPQBODX8epjLJIr+oEmXNuVg6ptj9wygE0AOdXnQ6onzD0kg6a0W9+BS2+pBJEkZog1ls+c0uX/1az/k3pFbfdToA1sL9T2Z+usIHd3kwt3a6thhMOKb2KN8dJIaDZHYFuqsIN8=;7:NSq/9IlZKBZipqGYWIg1UQ01pmaT/pywjdL/FJyq+jsJsA49Ju2m6fu4UpMhIqLozvKXFje5XMFKQedUem7iAixmCqGgshUsiRjBOH4AexQDMtsjqDa6GrKSc0LmoIhPI2LoxzkvurHcS5GziXFY1pF2unqcCFZVB6k+1BSAblClQsJ5YHZepl3Qjcbb2fpx8Kecw4ZEfkQgg6HcEcjTNASMhc4maCMpMlvFl23Yua5nUnBl3pfggVpJsR8HthB2
x-ms-office365-filtering-correlation-id: 4e79ee3e-307f-4495-c1ba-08d62aaaf228
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB44390949718A645C7FD3FA59A3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(86362001)(476003)(11346002)(446003)(14454004)(486006)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: AgeRe30lYAqY6mjd0H2rMxRdIbBE0NfT25PxWY8gQ1xlcs5u/d/oQDdf4LZYTV7MwoOY8OQNusPVzxXWvx8N8gz5Zvle2srqiXpBGzb5swYhoZ965Lfqqb31rkpbAPWAieH08YZ/HMpYQSHizsaX4Ly5DmE3j7OwZyNpeV6QoiLJXDZgVKqkuVViEHskAKA2mVjiOw2SAoBFDF5vNhn/Wocr1i5t8TeZjfOg+o7Q9bTR+E1WlDoCbIL4oRsJwfxXxE3AvH2seZIhwV/ZZLI+cR+NsJyBRRpfjDbwznQ+FafUnffdweeB/RsxCQGjFatSNUo0IcjJjahOtyW6iC1xtPpLDg5puaoooiwONDzjU2U=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e79ee3e-307f-4495-c1ba-08d62aaaf228
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:41.8050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
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

