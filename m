Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F7AC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 182E320659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="osXvXNXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfANJk5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:40:57 -0500
Received: from mail-eopbgr680088.outbound.protection.outlook.com ([40.107.68.88]:11680
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfANJk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMfjMBWZmTnRgh/pwL6kHuAhZWrNwSBQT4sJ7gllZRE=;
 b=osXvXNXFbX8f5IXWagXhV74go/tpxQkOeBibrtLoJG2c4O0RCrXN/IV8Qt4TXZT0I9W2Ctehs/OSekUjXHwnkpskyCKxPN0tyBWa4MFERqj4FzBrO/ZXZdJ248GUlWgBOJp2ypI3+1d9USbqi+6V6mmYZev48W8Ytmc/ugCLqMg=
Received: from DM6PR05MB6298.namprd05.prod.outlook.com (20.178.27.207) by
 DM6PR05MB6683.namprd05.prod.outlook.com (20.178.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.19; Mon, 14 Jan 2019 09:40:46 +0000
Received: from DM6PR05MB6298.namprd05.prod.outlook.com
 ([fe80::2884:6b82:d80a:1be9]) by DM6PR05MB6298.namprd05.prod.outlook.com
 ([fe80::2884:6b82:d80a:1be9%4]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:40:46 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:42 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:42 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 5/9] qtnfmac: do not reject retry changes in driver
Thread-Topic: [PATCH v2 5/9] qtnfmac: do not reject retry changes in driver
Thread-Index: AQHUq+0TLO5F9uwFqk+FFHSXxW2ySw==
Date:   Mon, 14 Jan 2019 09:39:42 +0000
Message-ID: <20190114093925.9061-6-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;DM6PR05MB6683;6:8OACE4sienw8J8dpGKdN1MNW24oCFNxWYeOE5niYrdICkQzcyY/rqViy7SD8sstOFRr/qmR+NC7S+/kELBhQ1fI3THODszSJC98IfW0O1koo8yLgR0vtb9/NOQt82L5PLKmHFfi8hncHj9luqw/lfyAAGx9EiNfj/YdkYGyOIkEKHvozvUwQrHAqrmkXZJ+Qf5t+sPUrGMLE9f3AFpHfJDx/13Rfv5x+3zPzHQaNvBMZfZD+1DbWyf8CSF6NWhlLcnRmmaff1eS+8aPtnOlfrvUR2z2SnPo7uBImRfO5rFV8IzeT8GEKG4SzdGdndjKHr882DFKkuG8aY5yM8yBFeABY9Lv3h8F+1Do1eXTHazGBJQmOYovqR9KSB9KHC1U/9hYNbib4ho030WZr8eSpGvPaIEjUUbjbsfVn/qcqEl7LpcU5JXQM7+nE2RVjbdQZqo1PUl+H9gRoHwWSXBT7oQ==;5:Vysrw5l7CQfL2ElGF5w0Y4//Tx/JgnV4WbQ6PmEC586pCpzxKKVR/CLIdhQiJB1ECR/BTr8Tl97FKIezFttmDTmjvnlafpQ1ahTqz9Qd4OxTRtNnHIrUfp2PhbpW/fbn5I69Jfxky0iEsglzIz8hnoDIZ9V4gdJ9U5Uztsiggcnb1HEZpo5vsvzXF6hfp6fRFemjqeEJrhBHyH/Z7HYpsg==;7:xNZkxD2KnmMwYi1c7Ai8mD/mj8ft0oDyAUfH14kSZe4Als44f+atDTqhKQVA7EFyfbMqFY/jd1pm2+PWHpIvbzwH3/Vos0PWN8LW+GLZRSka8Hh3YTHDQ0aPLtrPgbq+uDhLlIj5DENt9+3JbixuKw==
x-ms-office365-filtering-correlation-id: 3c21d404-75c0-412b-7749-08d67a043602
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|DM6PR05MB6683:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:44 AM
x-microsoft-antispam-prvs: <DM6PR05MB66839E5911774142AC935CCEA3800@DM6PR05MB6683.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(39840400004)(366004)(189003)(199004)(1076003)(25786009)(316002)(6436002)(5660300001)(8676002)(5640700003)(81156014)(81166006)(76176011)(36756003)(14454004)(6916009)(102836004)(6506007)(386003)(2906002)(52116002)(6486002)(71200400001)(71190400001)(97736004)(436003)(54906003)(6512007)(4326008)(476003)(11346002)(105586002)(486006)(2616005)(2351001)(68736007)(446003)(103116003)(478600001)(106356001)(575784001)(86362001)(66066001)(2501003)(99286004)(6116002)(305945005)(8936002)(186003)(26005)(3846002)(7736002)(53936002)(14444005)(256004)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6683;H:DM6PR05MB6298.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: udxxnJdNlQji5q/1vfiyQxLJjH64ys3mBfGjzdT1Ce4lmP3UXl6HGnRwLJqSru8wQRxX1+JYTdtb/sI5SunrnhyQAQq3OkwmLvSQB1qM1yYmvW3U7iNJs0uxf/XQcBhFOtyQAEHvUH534m964aSKAfiCJCCSN+UUT33u1I6LtyMzyxPwLFH+E7WrZb+kR3EcQ9kAbfnizm/yi9v8k/RcDvzFSW6A57CKu+C3Szn5lgvB302BWdx6iP3q0FtQPZKjz1ImgFO+2Bo9stVIEGp0D1hMs0Q+u3+ur2vcFShJJ8gf7yYGOR0DKMvxDcfNLx/2a9Qyyxdaveh5OY0BCWjILi12qgdkLv0/qRdHaRwkvX0P4M9MbRLPyzbUSKimdh2on4JGBrKQ9qvj1ePzQx4CdTvZ1H1EqjflO1Af8KkLnE4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c21d404-75c0-412b-7749-08d67a043602
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:40:46.8663
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6683
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
index a43f8120df3c..1b02096934f8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -363,11 +363,6 @@ static int qtnf_set_wiphy_params(struct wiphy *wiphy, =
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

