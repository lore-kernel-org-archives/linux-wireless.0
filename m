Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D67C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCE2120645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="kn8ZkQNo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCE2120645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbeJERJw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:52 -0400
Received: from mail-eopbgr730079.outbound.protection.outlook.com ([40.107.73.79]:1696
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728129AbeJERJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt/lgleD8/5SijlzkJyFoeSzS1Tc7zK72G9fiWAOQoY=;
 b=kn8ZkQNo8XE1oehBCDBi5fMuMxoB53VHpXvaoRqFD70osSPSr6YuRbfk0gVk/TfuoRfuxHsRBYvPLamPj5C/MSzECVQdpxT0Cx1RTs11uPxaeB864tkcr+uJs4Pq6H+a+ziaP9+OHgNof525Sl9RVXQWw0WxmKTazuBMJOc+Inc=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:40 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:40 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 09/13] qtnfmac: drop error reports for out-of-bounds key
 indexes
Thread-Topic: [PATCH v2 09/13] qtnfmac: drop error reports for out-of-bounds
 key indexes
Thread-Index: AQHUXJPOb1piPpjLFk2QAy7vE7U1nQ==
Date:   Fri, 5 Oct 2018 10:11:40 +0000
Message-ID: <20181005101114.3013-10-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:sDt5D8STjw5edCzyrojx0jUSW2wn8FNJENW+nNeXZpEZENsPaE7Jt5KfR/LwhdGNjoVjPwS5keQCSfRQJ76s0P/AFewvET1LNGDYozlvKrJQ0Hs2+mge3BChOhgtbVOjMyZLMsXMqFyos8yWur0AqnpZwfxXpTBtsSoRo3PwsPoZ9RxWc0qQZSrrDv02eof+xYua/vLYyJGMUV5hO6dURsRWagIHBnbKhnxmRpddrZ0YLY5qC/LjmQQFeSICL8dfpgnRciQgUTGRfxtZrYLJm7ohCeZbbGMiPyrFC+ih+vzU1E/sThPA3UHSX97/rkgY2etBmu8moBkRzKKJgyohiRlpYHdS01XdxgyOGa4s7q8g2wNE/caGt9+MIT4LQzGAULnBXW5GrzutRGA76kz7P5he/H/FUNu1KhXTJIJfRfwsoU3xeUSnvb2UMwrSGq8VQdygHIuR5no51CukZpBpwg==;5:A8MEW0cRIfcV5dMyJWZaGfO+tEUs7Bs4AShoHmEDc1fxi8pgfb6abIH/8tEyEw/H1wzQ3nozwxQs2kCBmnYIYmWiQwwiGem5Dg0JFz/SMBg+50vNXtrqU484O/CgofRtABSnaA7u0jEmTEbJY4LFzraJpEbWflw5Abn4yz0IfT0=;7:D0Krb/3kXbtgYFBcOC6O9GmXS3oA8aJyoj6eidxi6cSgUcivEwM9I0iKuasBm3Q/aZjrFKE5Qjh8K77vV57bRxXK9M3XIJyjJ/9mqEIDkMdFIBzm7+Luw8hvsTNq/huYJWptht5RQbz64kn6MFyBiSwDe7xf5vXe5RiXk/Uywb29I7ZiEQxyfIknh/oZz1c63qC3dcW91Sinm97tB+Gfdv93b/XIJuVQ8px+y4cd0Ijoifs1NKQaxAOn+mTU3DgZ
x-ms-office365-filtering-correlation-id: 2af5bcf1-9871-4404-2dcd-08d62aaaf11a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB4439A0BABF0F720544B5E6CBA3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(14444005)(86362001)(476003)(11346002)(446003)(14454004)(486006)(575784001)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CA9YheWSss33cZ7t9dFjGJv4MvRBS/ZrUa7QkdfUZw3y2cJJ7VOf3cQ9K6f+kN4onLw3jF06JK3TGEdVzxcuNIH/wcH8KaSkrgwD9BRCkgh5qqw+z7Qu8p80GUjMxDDnw/H5XEBocpW8nZuA1tW/HKABQmJH4ZsbYSewa9acLJsTdG0iUK2fG91Z0Uam7P5y7KGmgHbDVMSzlUWKd7ntGssiM2LDHX4k4PRUFahF9INP2hO19cru+Flfy8s+fyW226z/N9gIVcCwt30qSGQ//yENjksD6xwOt6mDVe/7FdaPzMCtHnlZ/7vfAVhBWRGYj7SnyAGeQzemhiWDuoeFL5jJgMVcpIja06ZeNDnUv3c=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af5bcf1-9871-4404-2dcd-08d62aaaf11a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:40.2669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On disconnect wireless core attempts to remove all the supported keys.
Following cfg80211_ops conventions, firmware returns -ENOENT code
for the out-of-bound key indexes. This is a normal behavior,
so no need to report errors for this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 8ecd37ddc0f9..9845cf287118 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -523,9 +523,16 @@ static int qtnf_del_key(struct wiphy *wiphy, struct ne=
t_device *dev,
 	int ret;
=20
 	ret =3D qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
-	if (ret)
-		pr_err("VIF%u.%u: failed to delete key: idx=3D%u pw=3D%u\n",
-		       vif->mac->macid, vif->vifid, key_index, pairwise);
+	if (ret) {
+		if (ret =3D=3D -ENOENT) {
+			pr_debug("VIF%u.%u: key index %d out of bounds\n",
+				 vif->mac->macid, vif->vifid, key_index);
+		} else {
+			pr_err("VIF%u.%u: failed to delete key: idx=3D%u pw=3D%u\n",
+			       vif->mac->macid, vif->vifid,
+			       key_index, pairwise);
+		}
+	}
=20
 	return ret;
 }
--=20
2.11.0

