Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69DAC43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878B3206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="1FyOnpK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbfAIQTK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:19:10 -0500
Received: from mail-eopbgr810057.outbound.protection.outlook.com ([40.107.81.57]:2452
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732277AbfAIQTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ncLF8/hV1dbHT0MFF0+NPdpLzh53yPYLgsYVzN/RRg=;
 b=1FyOnpK6Xp8D45jBdQ6pQQEuIUtAMxenP/ulkcskGKrgB/2umg8OmtcolAAK0lWvgjm5IfyzeLzaCD8aZWrycnP46XBQvVwvtnZK+rHSSFEqUA/SIE6nymSg6TR1MCDFvy1/zRPg4S1aZLnFbyXyvxS2S3QoXL+VKYODqta3oAI=
Received: from SN6PR05MB4703.namprd05.prod.outlook.com (52.135.114.213) by
 SN6PR05MB5583.namprd05.prod.outlook.com (52.135.110.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:18:59 +0000
Received: from SN6PR05MB4703.namprd05.prod.outlook.com
 ([fe80::f973:9029:e692:6817]) by SN6PR05MB4703.namprd05.prod.outlook.com
 ([fe80::f973:9029:e692:6817%3]) with mapi id 15.20.1537.005; Wed, 9 Jan 2019
 16:18:59 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:09:02 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:09:02 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 5/7] qtnfmac: do not reject retry changes in driver
Thread-Topic: [PATCH 5/7] qtnfmac: do not reject retry changes in driver
Thread-Index: AQHUqDWj+LuSpi6aQE6CwhLKGHgqPA==
Date:   Wed, 9 Jan 2019 16:09:02 +0000
Message-ID: <20190109160843.14832-6-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;SN6PR05MB5583;6:ujUAFbKhvCEH5tcl17VyhiDH0W88gI37tkNiuANLx5nQQHrfyrtviJfdTyOz5mTy2JYvK3F3V4DTTw31bqqSvok0xAbcbOL30rp9vZy/nQ24faBvUisBfImLdoYxTfo84EuIRRIITvEoWdzSUsMR1bhWNSdmarYhwqpD3WnWl7jt2ZFB5WebrtWUGuDwbbw3SvBVizawTuPBMomIHAXIhTdzlfVo2hQ5373TIwtYovJIUsVEUsti8DvRhfy2rJRMMNkdu0GTnQPhDZvYv0+lQEvypqdQerOxE6ucue7gKtwnXuCcqq2gxkzYkgcQlpCP7j3dCeFUwhEcGgQKRzD/wYaT/zBnyXK42oxwwTwPW2/8ROXiZRw+6ZoF5lVyv7H9RxOUTOeWyuQeF/qqchPrMiKkFYW+HXuV48In7Pz8tVSPNvsLimTvNCR4F3RDbQArIeAfYM9N+d60mmIyegBP5w==;5:xeXfn3PQFUJ+FWekjcgYdJKTmgtSJfwF3k+i2sEKLv/k9wdSyYFC9kH/mg+yPLum8ISRLklNQ5ED/qG0+Nx4KJy5KhwoeVyG83NBjhEafK3uOeLRbCqaFJlLKiAHfRxE8tRG1bEPjfSj544BuL2pGmWaidvDYHHpP4YuR5dDUY0/Rp/JIXmeqVS1zjcVUtMHIeL9cib9YzIlYL9roupQyw==;7:/QqAgjT4o4gbRK2/a6DtsvySe7r92vkmWy2GJaQ06FiK0bf4P+TnbOOV09TRNtYBlIAmsVExIjSofIFfnfa0FnuVdptf9ds9JDdU2qxpwUtSmJs8dkQYUcV4Wiq+XphwziH2EGCclh+qMseYhrPPew==
x-ms-office365-filtering-correlation-id: 723ad69b-3c8d-4ff3-ebfc-08d6764cc54c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|SN6PR05MB5583:
x-moderation-data: 1/9/2019 4:18:56 PM
x-microsoft-antispam-prvs: <SN6PR05MB5583587BC75CD6D152D6A066A38B0@SN6PR05MB5583.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39850400004)(136003)(376002)(189003)(199004)(305945005)(446003)(1076003)(486006)(316002)(186003)(36756003)(105586002)(99286004)(7736002)(26005)(2501003)(106356001)(6346003)(575784001)(66066001)(102836004)(6916009)(53936002)(86362001)(54906003)(6512007)(5640700003)(8936002)(256004)(14444005)(97736004)(436003)(103116003)(3846002)(25786009)(386003)(6506007)(107886003)(2616005)(478600001)(476003)(11346002)(6116002)(2906002)(4326008)(76176011)(8676002)(71190400001)(14454004)(71200400001)(52116002)(2351001)(81166006)(68736007)(6486002)(6436002)(5660300001)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB5583;H:SN6PR05MB4703.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8w+LHMRnktZRoy9E6Wmjq/JCdBPSooTdTz50Yoe1/K9TWKYmjp89VKvZkDexFv3899N0JqdoHuGGb8426Xvz9xgGfwVSyiJ+zZH1aEhW3czjbVCb+Vh8CEiqt1ZCxfgHRQyEkUhUngky43cIDUc09HiS//CKevRSo/vuKEnSa/DXTNuzwu7Wt3PeFvWxNFs9GqwYbG3a2V8F3+wNQh7WD/a6kC7UOJhP9VruMd7V63K1Xf+IlRIdCEvlbJXQ/WPCjSSFYYKHFQUzzJ0T9EWL76Zt0nOzj2k9reouGEh/73vHTztrV0Liv2qk6PBhOVIC
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723ad69b-3c8d-4ff3-ebfc-08d6764cc54c
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:18:59.5353
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5583
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not reject RETRY changes in driver. This decision
should belong to firmware.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 5 -----
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 8 ++++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 9e0ac1744be7..422b79a5b98d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -360,11 +360,6 @@ static int qtnf_set_wiphy_params(struct wiphy *wiphy, =
u32 changed)
 		return -EFAULT;
 	}
=20
-	if (changed & (WIPHY_PARAM_RETRY_LONG | WIPHY_PARAM_RETRY_SHORT)) {
-		pr_err("MAC%u: can't modify retry params\n", mac->macid);
-		return -EOPNOTSUPP;
-	}
-
 	ret =3D qtnf_cmd_send_update_phy_params(mac, changed);
 	if (ret)
 		pr_err("MAC%u: failed to update PHY params\n", mac->macid);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 66cb05dfdba5..3f0a0b6abf01 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1825,6 +1825,14 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac=
 *mac, u32 changed)
 		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
 					wiphy->coverage_class);
=20
+	if (changed & WIPHY_PARAM_RETRY_LONG)
+		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_LRETRY_LIMIT,
+					wiphy->retry_long);
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT)
+		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_SRETRY_LIMIT,
+					wiphy->retry_short);
+
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
--=20
2.11.0

