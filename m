Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24965C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE71C20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="00kq4K7w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE71C20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbeJERJh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:37 -0400
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:30496
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbeJERJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iIMcYyWK629rso8WbwMXe6QPffSLlpGQvKmeWbL40Y=;
 b=00kq4K7w3SiQ4ustcLa+wIctho0G3oxTNqoZCpipJCdrZfxEEMfIz/ABKaNS1tucz6pBRAXOiJiF5FVjrvWaOoe5ez7gjDHh8/TaGi05wAnTfEPVdCcSfjzkBl4FgiCwRuMFavRhe3tBDA3WijdnzgPguF6B8d2Q2hulueDhyCs=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4375.namprd05.prod.outlook.com (52.135.202.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:28 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:28 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH v2 02/13] qtnfmac: generate local disconnect event in
 disconnect callback
Thread-Topic: [PATCH v2 02/13] qtnfmac: generate local disconnect event in
 disconnect callback
Thread-Index: AQHUXJPIoEyU+ziYJkS9h6eyAhf4MA==
Date:   Fri, 5 Oct 2018 10:11:28 +0000
Message-ID: <20181005101114.3013-3-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4375;6:rIrFvkLOhTK7li8BqKsRSOU31amTa+SjosYTX64R2wh9LpDz8bVOUtdtOiXdl97uque2gp14tZbsCtftUE0vHvwt4Qs5XGpoNnGnVC/vl/vIqLYq1UmZkhaYgIHeAkXb4E5WgtJn1eVzi3Sxj/THcXS9uaFLA5rBsYio+pgBIRjp0UPQx0fG9DsZBhujaSFd5QoJMIysTV/0Xt9yHKfrwF2sDTkX4xQ6KRBbenYH+FnbyCYY+sCqrKCynQqBdiL5dSx/7fWJ4Qtm1qitjl0X8+GK7W/udIKol/4EeeFPMeaPpi8YqHc0BNGRR3RzpbnKBNCWD5Ij0B4hJDZDpcsCULLtg3aPeO/cdEE4d8DbmDsHfJIDgRrg4nMIT/T5XMRr4J9HNBK/RC1cMT8KuBO9QIAJHCY0xTCSvfNL1wOg5dpS7bDYfFxllzfPLhgogsSnS1WRh97qru7Fnv4ReaaT/w==;5:rxoHkCe1f6XK1eyfTW3Q6CbhWGP0Pypa6H/vEIT0srdlilZnfk3MdndsfTBs17BV+gXV21McXhwcbQSymEDDN+wrWrENiECkImetkrfS3lIm11NrErUPnAXhXfvUVvCc4Bjk3SyIHofm28lWy6JJTG5M1LH7ZHrg3FE4//u1sCE=;7:7Tb+NkZfNQoDWnoABFubKnuLnXz8vkYjSbuxCuWB69ciriXSD+r5oP/8WOaIwMvD2fF8EQTMSurP0JGelAUPeuX1FKmOASg0U7LDyX60QuHsX/4sHNAoAFgaFpMCR39h/ayxrQc5ZFGJjTGv9rhyrX8AgntKbKoPsYDr1fvjYbf1C9/DIqugyoPa8EHqc0DhsMPP3v8Y5vdyA37TbPEb7U5FDegHVHpbv0wF6JTSW15BdxwLEYVUYuj4nej40Ll8
x-ms-office365-filtering-correlation-id: 88fea22a-7d39-4be6-4b06-08d62aaaea61
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4375;
x-ms-traffictypediagnostic: BYAPR05MB4375:
x-microsoft-antispam-prvs: <BYAPR05MB43754AD9E6D55C449354E5FDA3EB0@BYAPR05MB4375.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051);SRVR:BYAPR05MB4375;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4375;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(366004)(376002)(346002)(189003)(199004)(6916009)(478600001)(6506007)(386003)(106356001)(105586002)(99286004)(6512007)(2900100001)(97736004)(2351001)(4326008)(25786009)(76176011)(36756003)(53936002)(2906002)(103116003)(107886003)(2501003)(52116002)(486006)(5660300001)(5250100002)(2616005)(446003)(476003)(305945005)(8676002)(8936002)(102836004)(26005)(11346002)(3846002)(71190400001)(71200400001)(1076002)(6116002)(14454004)(68736007)(6436002)(6486002)(5640700003)(7736002)(186003)(86362001)(316002)(256004)(66066001)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4375;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: k8s2RYrRj1JeVtALvZklP/8R+t4ZAGROZdBj4tbDI+PS2U5tHJy6sau+RGv1ycoxLZT7c/l5cjlySG1mWPB7Cys0m94wGFwvyUOuaZTLf0t5sbGi6vXkcVfQ4VC3R/3rwbkluiEFi68ZnLay+M3fJR2mH5hPNwUCxHlAYxMwvyW+3WFYdLnPenfjHghHk0ZtywjE91OTOX+5aabKmkUbLsYUel/bjOYBFepcA48nTvCgVVhQqeVnmv90QbFzvFkjw//JZ4SkL0u64t+rzl35kzX1hEmUrjTUgs8yP9+9Tm6kDaceizNsOUz/0jW84DPLnucR+2STWoJ1MrhsD4YV6npfwOHOPRJxAjkAh2BF038=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fea22a-7d39-4be6-4b06-08d62aaaea61
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:28.8068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4375
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

When cfg80211 disconnect callback is triggered and command is
processed by firmware, disconnect event with local parameter
set must be sent immediately. Indicating that it's a "local"
event (not from AP) will help upper layers to process this
event correctly.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 776cfba7396e..87f48b7fb673 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -660,10 +660,14 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_devic=
e *dev,
 	qtnf_scan_done(mac, true);
=20
 	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
 		       vif->vifid);
-		goto out;
+
+	if (vif->wdev.current_bss) {
+		netif_carrier_off(vif->netdev);
+		cfg80211_disconnected(vif->netdev, reason_code,
+				      NULL, 0, true, GFP_KERNEL);
 	}
=20
 out:
@@ -1140,12 +1144,9 @@ void qtnf_virtual_intf_cleanup(struct net_device *nd=
ev)
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(ndev);
 	struct qtnf_wmac *mac =3D wiphy_priv(vif->wdev.wiphy);
=20
-	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION) {
-		cfg80211_disconnected(vif->netdev, WLAN_REASON_DEAUTH_LEAVING,
-				      NULL, 0, 1, GFP_KERNEL);
+	if (vif->wdev.iftype =3D=3D NL80211_IFTYPE_STATION)
 		qtnf_disconnect(vif->wdev.wiphy, ndev,
 				WLAN_REASON_DEAUTH_LEAVING);
-	}
=20
 	qtnf_scan_done(mac, true);
 }
--=20
2.11.0

