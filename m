Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA91C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B13820878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Usn6b3TV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B13820878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbeJBQIW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:22 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbeJBQIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iIMcYyWK629rso8WbwMXe6QPffSLlpGQvKmeWbL40Y=;
 b=Usn6b3TVFvSnYJQoaVt8ByJd6l/+ZHTShZenojjrvy98js3ZXjwq7ZkxoXAYb7SlhTrBqQ/SVT5BBZ8eog/9u+5kdtQbAzcQEAIhOsbhmzwqf7mDPX10eXGs+RdotzuZzr1sK4WxAFxks1qJTduYnVUzKA+CGyTEtbed0q5yg5A=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:25:57 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:25:57 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 02/13] qtnfmac: generate local disconnect event in disconnect
 callback
Thread-Topic: [PATCH 02/13] qtnfmac: generate local disconnect event in
 disconnect callback
Thread-Index: AQHUWjHsgBpkfSfE0UKqHH+U7rIgbg==
Date:   Tue, 2 Oct 2018 09:25:57 +0000
Message-ID: <20181002092542.18966-3-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:hBomA597bMKPO9z+smHQH83Pq/fXegpBpogb/c8Cv0hn3wbwI6IKMoSRMBAiW22c3UZj2L2FDFx6e/PFRFaNS+KVKOhte+azpZgeuKvve1YIx3Rs7oh5Y/JOiwaMWu2hdVE7uY/QZoL6wTo4ZKX4rAkmCRTKBIjRJIQWKRRUk15VmRN/8jQWtehfDhWayIpqdJFwwANzFAtLHsW5I9qWiBhY2ohwkDK+I4r+1p+1qiWazoqeuEk5h1sPlME+3PyWfi5Wgxybz8N39U/M9cQXCEKgSXnYdtq2ne/0p6rD8Vrfh39Cwb33Rwa6FThhdRJjbOstEk5yWfQT8Wc4mwNaeT0MQPhexvmOnFaRs5sQkQui7pb9n0+YsTHi6qzjSsq468/xMy7DCGgCJJjogAdcSyOBEnSp6jJXgGZxJBPRY/i2eQ7YgYPbZ33DubXSezhG/qfo8LxePgmUrLIt/bMy2A==;5:MlGKKcjKzTitEU+hY9A6abP/1Geoh82IMqM+GJ3x1nsh26rkOJP+y6DNIPYCieLCDNNoAxE11/t/yyLuZTPq7ZNL3/oM687JzgY9lHWt1O3wD4BNr7fJDmEq2AjqW4L8SdSqiOqwL/p75MsN6351n4sWEir/T3ITw4flw8DLWlI=;7:9sSh7333Hs25vwwC/eFO6zhCECRv4Tvb/GFMo7k3Px/ds8B8y3vL81ZrUth7kBxs/HU0MKFeMoGfk01SDCmscm/ASGfwzdQC6RjKiXzIAzkKk6r3KTx+d2iG0kwm6NAHywD4V3Cu7HZBxlrdYcyA4jmjHX4j4SZRrOGvJaahgbJKjikv/yFE75FKlWjb6eLjfNbG5L/6RJouHt2ZYvCgiTY8C7Es+wQNISH5Ou7du5OM5RVXAkQ+V7OH7N8A+PIN
x-ms-office365-filtering-correlation-id: 65902bcc-4a44-4fe3-5ce6-08d628490ee5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB509284BC8A968CE1C8E896B3A3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(8676002)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(76176011)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(446003)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(11346002)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: CWXJtMTjC5MobAc/4lXokqevEaZytelGyUQh8lcljHifRaSxNbsRCqFX96JAwaKiaO37ui+s7I7f5Ayl2ZXOdiST9GCOHXAwW1LSp3T2dmrTDWb8VHeR5O/k7hhrEvotPLwq+XyQlkmqavA5xk1AjBzOIEzj7Mwas5Xk/0Sv0V8XUlq9uJtC79W5+oll72MjuJDet7JDG+OX5B1bRqf36bsL9UvUJrnEAqio4FBzG5GyJE7sAR2GUDLeGnEQB7KO/FfeV/QVIE7aP9uryNYHJ9qPMzDyV5haLOOR5PhWnX3ylGzqIIhW7l44ennFcBS6cFEgaQ/LdAULZDQCqeAfQvexmDKSCmSJ+afdIsW25+w=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65902bcc-4a44-4fe3-5ce6-08d628490ee5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:25:57.1272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
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

