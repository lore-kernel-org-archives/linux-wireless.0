Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D95BC64EB5
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54AAE20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="KSNNZvyE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54AAE20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbeJBQIg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:36 -0400
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:22848
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbeJBQIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ktRmOIn04oT6E8rlxJnxDUbuJUAXYLinJCi7mc42k=;
 b=KSNNZvyEP03ziENMHuuXBXnhyKz7gBKa6CFvC3jVkF+hbeTq7CktxEyHrzSmpa8vPPfMXEhRBhA6fmUX+49NI7WtlA+uRJVqQbnRX/ih8JY3JujQYWhwCOlAV8oY0y0b2A/tysuD/TpOvR6EUynYbRmkheGgpienuH+zheXDqNg=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4849.namprd05.prod.outlook.com (52.132.15.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.17; Tue, 2 Oct 2018 09:25:59 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:25:59 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 04/13] qtnfmac: do not initialize per-MAC data multiple times
Thread-Topic: [PATCH 04/13] qtnfmac: do not initialize per-MAC data multiple
 times
Thread-Index: AQHUWjHtE34ZEwk6y0O6QsP6gkMWjA==
Date:   Tue, 2 Oct 2018 09:25:59 +0000
Message-ID: <20181002092542.18966-5-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4849;6:DykkOeH4RiCB2v2fGq+FlOI33Q1doWxP/yOSBYMOJG890HdaTQJ2fUZlP6s0RnOtLcP4BLJ+69mVRlSEbPE8IA6Vr+wgKic5gWGVNWeZtilMIgXLxmlIkxg4wV4yMnwrcwQj85hyhf2hhHIkZqheeSITKOv7yFW1S1cDLZIxj8o2Xi1LjDYUieceBHmVfLDTaGfle3+HCuK4cmYHp5HwvvnPFq6Uqt73mwdc0FIdDqww1hoP9ulWLtSf2O3HrjsJG9kPDqaymh6j3MonZIYgkIgoIQEjFsWgShG3Tha3tb9E6Bnj1N9ptGirnapIEOChHsdp5cFDWbAf9cfrCGNbo7NZM4XW0UcZkMw86xYYrMw1BqlV6sN6IdD6OLMIklY0wCu1/TaIIaUvFgRFA8BbUPUlG0UvBvHqxHabsbSb2z+NsVYfGyzGCAaNAsAWcyEJTSYtloPlYz3aK7rG276NDw==;5:JZow1oV6fI5UDd8hhLC7wX6dwAWL9OgJl07Ln2DcX210DDrNzdz5uaK8t3mNEevlG8Kng6GcPTV3NXvvRX011qHdWO6EdNgoWJWAD8V2RJ4SBJsZjsOxhosfIwDpXeC/vU60AcKzA4lMhyNY6NW9R+A0taXyjRZNeKC2kIykaqk=;7:HhBLC4fEWfbO/M2RUkOrcQ/hUxeztEjy41ag3dyT++y/lxnefoQZ4axZy1xia6ukr+ndbUBP6Hh6CZ22uTIivxldp9vNGjPMkIFfpN4ut8tGutstBA3OBaZ/yjaJC5YMLVLQF4ya6TA1KnSrK1JXza8vKJNrpSS1JkVgOhjZe01/6xJzj38rCO5CdB/KYFpkP7vUino8/B584W1OBAG5fnKxRFOqRqcOtY8e+bos9qK5z1VCqA8UFVcTqm55Trzy
x-ms-office365-filtering-correlation-id: c56f4171-0b0c-4093-311b-08d628491024
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4849;
x-ms-traffictypediagnostic: BL0PR05MB4849:
x-microsoft-antispam-prvs: <BL0PR05MB4849F7DB7B49433928649644A3E80@BL0PR05MB4849.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB4849;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4849;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39840400004)(136003)(396003)(366004)(199004)(189003)(11346002)(106356001)(14454004)(446003)(66066001)(486006)(5660300001)(14444005)(6916009)(478600001)(2616005)(476003)(256004)(68736007)(105586002)(26005)(186003)(305945005)(103116003)(8936002)(102836004)(8676002)(81156014)(81166006)(316002)(6346003)(2906002)(7736002)(2351001)(25786009)(4326008)(36756003)(5640700003)(107886003)(86362001)(53936002)(6436002)(6486002)(99286004)(6512007)(97736004)(6506007)(52116002)(386003)(71200400001)(76176011)(2501003)(71190400001)(5250100002)(1076002)(3846002)(6116002)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4849;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: hfshqKNEoU0zQzev2oPlBO1ltIt5Xrb1+fsxJ6JWbPt1/69geia1PqbSggN9RrqTE6v3J5llwKOQn2gIpTinDUnOgMHpdUKcSGacHQLK83+BUYcMI/1ZIInGtm5Usx8lHftNFQ8a9sJRqGNp77Ay4ayqmV4nBXyu5m/JA2Z04V9Ld19EHkMbePjkRIJliWTgTd2IrvcZ1aqsOW56wSKYPihio5MXK/Cew8KAhaT2L6ZraACNMPPv8G/ak8tMiQN/r1Kr98hhdKPe8y5SIJYeI4QCkEBkH2XeH2tt/NKY9XgbSdyh17wkgBe9NL1NgsEZV6+GEPFrMQYd0HlA6iYNXS1bqoYHMsjn8VLadJA1nL4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56f4171-0b0c-4093-311b-08d628491024
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:25:59.1557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4849
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Several members of pwr-MAC structure are re-initialized several times
together with per-VIF initialization. Fix that and simplify the code.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index 19abbc4e23e0..aaa218eb70c8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -370,6 +370,7 @@ static void qtnf_mac_scan_timeout(struct work_struct *w=
ork)
 static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 					     unsigned int macid)
 {
+	struct qtnf_vif *vif;
 	struct wiphy *wiphy;
 	struct qtnf_wmac *mac;
 	unsigned int i;
@@ -382,18 +383,20 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct q=
tnf_bus *bus,
=20
 	mac->macid =3D macid;
 	mac->bus =3D bus;
+	mutex_init(&mac->mac_lock);
+	INIT_DELAYED_WORK(&mac->scan_timeout, qtnf_mac_scan_timeout);
=20
 	for (i =3D 0; i < QTNF_MAX_INTF; i++) {
-		memset(&mac->iflist[i], 0, sizeof(struct qtnf_vif));
-		mac->iflist[i].wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
-		mac->iflist[i].mac =3D mac;
-		mac->iflist[i].vifid =3D i;
-		qtnf_sta_list_init(&mac->iflist[i].sta_list);
-		mutex_init(&mac->mac_lock);
-		INIT_DELAYED_WORK(&mac->scan_timeout, qtnf_mac_scan_timeout);
-		mac->iflist[i].stats64 =3D
-			netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-		if (!mac->iflist[i].stats64)
+		vif =3D &mac->iflist[i];
+
+		memset(vif, 0, sizeof(*vif));
+		vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
+		vif->mac =3D mac;
+		vif->vifid =3D i;
+		qtnf_sta_list_init(&vif->sta_list);
+
+		vif->stats64 =3D netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+		if (!vif->stats64)
 			pr_warn("VIF%u.%u: per cpu stats allocation failed\n",
 				macid, i);
 	}
--=20
2.11.0

