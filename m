Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302A2C65BA9
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBC1420645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="otKWk9ZO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBC1420645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbeJERK1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:10:27 -0400
Received: from mail-sn1nam01on0065.outbound.protection.outlook.com ([104.47.32.65]:3040
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727540AbeJERK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z55vT5yGx+eQN7rDevT1J0sznBZHKneYLK7QeZxXS9M=;
 b=otKWk9ZODZ3CH0m715p9GjW8txAeUJRHpbP8oLpEUbM8VxfQv7VRSkgPInqBUJLmo6w/I2fBt7TC+Tj87miQDa9nHn31ZxfLCh9WKZ3Ljbw4ty3aD9wPlqH94q5Za85BJtKE5mkGFutJFJ+BUzU+GC1+oNU1NNENklyUUsX+HN8=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:47 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:47 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 13/13] qtnfmac: implement dump_station support for STA mode
Thread-Topic: [PATCH v2 13/13] qtnfmac: implement dump_station support for STA
 mode
Thread-Index: AQHUXJPSJoNlwT9x60Wk/e/d1iUu3Q==
Date:   Fri, 5 Oct 2018 10:11:46 +0000
Message-ID: <20181005101114.3013-14-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:mRBOsPX+m/03n+zJgXS3sqJjAbgRn2s3VzKgy2PMYvXmJzXz08CkHLvqikceYHAwJJtxZIQAQdR96fTiP9dVbSF3Y/nKdKJ2yzXr7yT+W11o421gE6iWIgxTAUP6HKuRSts/pB3Y7gu9/f7iKh25H6anZLLnFdlL/qPIVMr5jJ384v3760rdsDmmdnzK2/+Zqln6ZxLO8632yvv4ryYMONex3xEDUX6RvoCryKV3n1PO5XSSKb+qscHVRbLK414qV4DCKxXncuSXr7PCJoIV8R2jWA/9IYowe9VFtp71OKvawn0R1F/rrdMQUsGlGQIYveh5gmGMh7eBkXhHnrmRFNcxIARfrcaxM0suVuvr4mbXiBNO3DsJ7/3c/KxvbhFjdW9cTuOooyCNejbLIiuaCx7LOeDxu3rLugXOm0HY9rbWToK7oUZKLrpVQHFCI+jqJMcpP3UH9fDLrKp6yziYKg==;5:FQjzz3IxpEky9mndmS2wztGCbLmr/GEWs7vUOtnvkj6+QvrOUYzHEOfIAnUOj3g8McKYngKZ60imSfK9qXYDEcjPEXKYe5n/MEPuJhkXf9fYLsxEvTd8f60K4HB2A3MLy7rA6QLb8NUhYkOVK2jlwBA4fea6YtXujNf2ttMcUGs=;7:sHZvE7ugfNrOELQkw9CrUvOiDcFTFhYsXxgDd1iDV4G5KzKAEQ0avwDUGavBrcRzWucDTsCt27yFMZYHekjv0cgAR9AwPVIJkpbIizUK5/yhMAOWp/TI5sNc/0COVcnKikeu0Gc4DlTvEgruBiEhBoE1yejC6+/NqCqLKvV+FShhzZAvHvoZm5kz8R299AEEuECXbMAEkr8DEjJ5U00VUEfwxjY+YdCTXTWJCxyPeNYJi2nNm9UEXyNXtJsrdqyd
x-ms-office365-filtering-correlation-id: 02330baf-f96e-4392-871e-08d62aaaf526
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB44397AAA82CB6967D4F11037A3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(86362001)(476003)(11346002)(446003)(14454004)(486006)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: S+NzgmVAkZTZB7gQmrW2b6CnwuxVP/JhhzHAFFaHSlbRQN5rhZHCHiEMtz5Q7bNFeKgt0scgb67CZy2cGxEWfpBrd622eksgycXcBNGCfkRLbZkkJtDbpAZqKIrpI6iMgRIkgSQjQo9ixTlTw1sKn8kstwc/whj9UxnQ9WgTL8lD+j4xzszQVzTzlttt0os7d3nv0mtUL+x38JuFOSxzhjLTlhbTu7Cp4fwuJSeM5Uwf74XaynY4a6ZCG44VOracxYzfupN4eLdOZeMN5ZBtW3S9cRvFH945hMOUkDysbonpFfT2rYSAFMlHnxZ6aOweArfJP65RxE/BQEJh8qtXw25ZZrSjmR6zWK7O7N4NSJw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02330baf-f96e-4392-871e-08d62aaaf526
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:46.8155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Current implementation of dump_station cfg80211 callback supports
AP mode only. Add support for STA mode as well: by default in STA
mode this callback is supposed to return AP on managed interface.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 30 ++++++++++++++++---=
----
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 18179965bd38..51b33ec78fac 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -480,19 +480,31 @@ qtnf_dump_station(struct wiphy *wiphy, struct net_dev=
ice *dev,
 	const struct qtnf_sta_node *sta_node;
 	int ret;
=20
-	sta_node =3D qtnf_sta_list_lookup_index(&vif->sta_list, idx);
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (idx !=3D 0 || !vif->wdev.current_bss)
+			return -ENOENT;
=20
-	if (unlikely(!sta_node))
-		return -ENOENT;
+		ether_addr_copy(mac, vif->bssid);
+		break;
+	case NL80211_IFTYPE_AP:
+		sta_node =3D qtnf_sta_list_lookup_index(&vif->sta_list, idx);
+		if (unlikely(!sta_node))
+			return -ENOENT;
=20
-	ether_addr_copy(mac, sta_node->mac_addr);
+		ether_addr_copy(mac, sta_node->mac_addr);
+		break;
+	default:
+		return -ENOTSUPP;
+	}
=20
-	ret =3D qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
+	ret =3D qtnf_cmd_get_sta_info(vif, mac, sinfo);
=20
-	if (unlikely(ret =3D=3D -ENOENT)) {
-		qtnf_sta_list_del(vif, mac);
-		cfg80211_del_sta(vif->netdev, mac, GFP_KERNEL);
-		sinfo->filled =3D 0;
+	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_AP) {
+		if (ret =3D=3D -ENOENT) {
+			cfg80211_del_sta(vif->netdev, mac, GFP_KERNEL);
+			sinfo->filled =3D 0;
+		}
 	}
=20
 	sinfo->generation =3D vif->generation;
--=20
2.11.0

