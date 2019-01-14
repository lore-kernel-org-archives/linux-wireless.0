Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DEFC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F78020659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JbPgd56Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfANJlF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:41:05 -0500
Received: from mail-eopbgr740078.outbound.protection.outlook.com ([40.107.74.78]:8356
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfANJlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Z/BHPRHajLJg2l1af9elfwbb3SczJ+QaKw9N+cDIys=;
 b=JbPgd56QWizUVA6y2rixzWUOrLyW7Ovvrq3l/SZH9j9zxdJ+iPHpwjlHia81WVdcr4YG1hFgadyeR59pfRDB/4GdFa81a2wmSqvvqZIsVYQjoZMIcs3R6TjqK6oQjSDT8c/4LD7p0+VG3yduMafugoNNjlIFXIAfsv2gOdzfEHM=
Received: from BN6PR05MB3282.namprd05.prod.outlook.com (10.174.95.29) by
 BN6PR05MB3316.namprd05.prod.outlook.com (10.174.95.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.18; Mon, 14 Jan 2019 09:40:56 +0000
Received: from BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::ccd1:be31:d057:fab1]) by BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::ccd1:be31:d057:fab1%4]) with mapi id 15.20.1537.017; Mon, 14 Jan 2019
 09:40:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:51 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:51 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 9/9] qtnfmac: qtnf_cmd_send_with_reply cleanup
Thread-Topic: [PATCH v2 9/9] qtnfmac: qtnf_cmd_send_with_reply cleanup
Thread-Index: AQHUq+0YA6CFUVawY0+2uKx2Ytq5QA==
Date:   Mon, 14 Jan 2019 09:39:51 +0000
Message-ID: <20190114093925.9061-10-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BN6PR05MB3316;6:hFSyzt8A/WM1PDIVIaIOF/NVmDs1PjDNkiZVkQPAWqM3uHmWIHC4JAVYQ5EBBKs/l2i2k2S8PtiB8KCofkpaym26BJZq2ZFlHwcQfuHIhedIGwv2KIZwQpmFW3gpvIklyKaMaurxEJelF61fF8rnBUaY7wIOx2ZU74UQBuEw15rOzGk0LJr3Uwrf3jVN0FANnMP1jvSTj/Yf9hxulCioPa9VJdaLJZfxDLDuqWZILcPSd9zPKw9cVnFWUdPO95y530s48iXh4Y1lvUokTlZv3cigGHkXxom1H9p+VcoyqF5XXbIyba2ZxukZh/kX1hoaeg6NRsO177TAatozI61TWC777Y2xoKA2kNT57eBa40g7WmbywWNPWyhF79PzB3OuIS3nBoEiJ743ops/GNaHYOptY4WAZG4f/zQoTZ1Yp5hSsFzCdpKMGbl8F1hV22AL3w5yrk5MpiAcNhAsJV3lpQ==;5:GwAzWOThswhhERn6y8h6bG3RdvEWJDc3eOoI6hH3era3di9QcFA3rVrwnlSBUQBTq1QMhlMlsNU5XJlubcWxwgM8wYE31XmCpKcsWjw8rnDhKvqnqZaai3BR2RS8Szlop2UcYpx3y7WoJnglr7R9qhtkOC7FySD1ZX3H+O7tUHAuaYNvysJoRJUIMHdfwrMA/jfd1LF6vwTv4kpU3JCB6A==;7:GX43BdvHJnYhurmBxFQRlA0lSd06406YdJgFuLtigLhUv8VmivvEtojRV0qUeqTCX1qu2pI76Zwz1tTRCF8D3Ut/qao1MkMBtRhF2NHf4xT8Fc6V3K3sD3xzCkV0mOJ07VnlIi1j5fGrsjRaYfRCjg==
x-ms-office365-filtering-correlation-id: eaf39c68-b61c-4347-1b84-08d67a043afc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|BN6PR05MB3316:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:52 AM
x-microsoft-antispam-prvs: <BN6PR05MB3316C4970CB53960D65AF12BA3800@BN6PR05MB3316.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(136003)(39840400004)(376002)(199004)(189003)(54906003)(446003)(476003)(103116003)(436003)(106356001)(99286004)(478600001)(105586002)(186003)(1076003)(2616005)(11346002)(6512007)(2351001)(486006)(68736007)(4326008)(316002)(107886003)(53936002)(66066001)(386003)(6506007)(102836004)(2501003)(25786009)(14454004)(26005)(71190400001)(76176011)(71200400001)(3846002)(52116002)(6116002)(81156014)(7736002)(81166006)(6916009)(2906002)(8676002)(5660300001)(36756003)(5640700003)(97736004)(86362001)(8936002)(575784001)(6486002)(305945005)(256004)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR05MB3316;H:BN6PR05MB3282.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QyyBMay0lso0pIwNC+a0rwLZ1JQdYjCQPWBAveD44Uk6U9Q/7QxFUjaqq2+Y9okqWugjMK0u75FCFkGGxk4sIIFn6z+cQebXEmmCa/auHUb8X6L+TD7TQUxOCYEQEosAlEiStuzqIOslMaxmn/Dq0ntyeyyNmlULh6A7ay7tj0SSFXZjgQOApexvPfh4oB3X18p7GPErEYck9jmrLVjqkk7Vvg6CnwhLt89l9ZgutXk33OUUlYYYFGgMjE343xTwVRvjBGOnb2rFbhg5Irsz2COwGpuquO5Kk1xD3EZCxwECoHw1NJ6FKREavwEYOFy2YotSHGgHz873g+hhsPlyB2wfOLcc1axTLndSQ7opnhUA5qbDKkV4xHZioQO3bjbqiOrFxjD5kaRV6YrnVkGyP+v3dhoA+W+Lc4lxfRUEW38=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf39c68-b61c-4347-1b84-08d67a043afc
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:56.0545
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3316
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use existing variable with dereferenced cmd_id field.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 009a4e4f4c7a..9b3019b0f108 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -87,14 +87,12 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bu=
s,
 	vif_id =3D cmd->vifid;
 	cmd->mhdr.len =3D cpu_to_le16(cmd_skb->len);
=20
-	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id,
-		 le16_to_cpu(cmd->cmd_id));
+	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id, cmd_id);
=20
 	if (bus->fw_state !=3D QTNF_FW_STATE_ACTIVE &&
-	    le16_to_cpu(cmd->cmd_id) !=3D QLINK_CMD_FW_INIT) {
+	    cmd_id !=3D QLINK_CMD_FW_INIT) {
 		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
-			mac_id, vif_id, le16_to_cpu(cmd->cmd_id),
-			bus->fw_state);
+			mac_id, vif_id, cmd_id, bus->fw_state);
 		dev_kfree_skb(cmd_skb);
 		return -ENODEV;
 	}
@@ -128,7 +126,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bu=
s,
 		return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
=20
 	pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
-		mac_id, vif_id, le16_to_cpu(cmd->cmd_id), ret);
+		mac_id, vif_id, cmd_id, ret);
=20
 	return ret;
 }
--=20
2.11.0

