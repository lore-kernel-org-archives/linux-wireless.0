Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EBCC64EB5
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E164D20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="TfnFCJ+F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E164D20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbeJBQIe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:34 -0400
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:16160
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726933AbeJBQId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z55vT5yGx+eQN7rDevT1J0sznBZHKneYLK7QeZxXS9M=;
 b=TfnFCJ+FYaRV4dqU2tBK878Vv/A9SPw8wJIS5wBZuCn4+gY/SXQ+1C3q6gAhYu+Vct4hnUZdTctW3mRZ0v8n5v4Z88qP9BQHoKvBkftyjbDXF6mnXDfJ+DXX2RdFcMLOZnr/NIHCJokQInvf6ROGu1KZ26mrA2ck/DVSZntlrwQ=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Tue, 2 Oct 2018 09:26:10 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:10 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 13/13] qtnfmac: implement dump_station support for STA mode
Thread-Topic: [PATCH 13/13] qtnfmac: implement dump_station support for STA
 mode
Thread-Index: AQHUWjH0j57TQDSMmE+hbqpZ3F905g==
Date:   Tue, 2 Oct 2018 09:26:10 +0000
Message-ID: <20181002092542.18966-14-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:3nhEuZVcLbNVRjpQl4ap0UChXhCSkB9yVOB6F8ldRBkC+Qs9uMF/6NsIEtsjvveDO4Tr7caK4whBvKfF0kRRc85Neo7WSYzfjCAh8p9nNzQSInJfw928Aj5zwOQXQUf19dHcdJIxZEKdxbk/AdwsEHstX2v4t+p11IPjqBnvWMt7UGEBSXM2JspQcGndu5P/i+IBfn1dncbdBzqfvgCQie/IJ62UfpQmRabuiqGEDFfskgDS5iInP/BFXPeWw8aDd/c6iND63kYaAOVkiSDuo6z5OY0cdr+p3thoZtroTZtKqmN0S9XJciIG0qdvW01xp5/sazjp8CkzR/wN1AiZ3XwJgw8N1LPbH+WJWHabGLrKhwqDYE4cClumBTu/X/95qQ5TSP7/EizRGHtdrQeMyBz1Zwg3l2+27EF3OUXFIkvVGTnHRtogeD+VEnkNmI95V2lBUPxvWVhIu+J7epB07A==;5:Y25ia0r/+L5R+XGojVqzltnVt7OsI+bCxY8XvxdtpVhFaVuuY9/+a60dm9/GDbHhO0CVcL4uk4tjbphcnOzwOi70XeTlQUCY9GVY1Eu3zN9+AF3jJMHomr4dCtZGElMo9eNHeiORO5XXDAXgMG3LbOubd+vn+xh+x2aoC/tEPAQ=;7:uZEzyvXGMk9CUJIyRtsAS29GIwtzBfNBlmjtPrtGBSmzI1o0kvjfKIh+ZFm3RMpqp3/1YNsT9f3f1XA23ZOwduSwNcYszoZJkbKwbzi6jJAL+uFBdVrPOqT56XGOz4K0xHZBJF/0/V8frjM6+84aDzLn7EaCSf0ZkLVSU+jwA/pLouUh6UQkh/4vb+K2xm1yu4OBTTVvDB2Wo2KgcmB4q7OQXMf0A1uikUD9GvzIlR/Wm8802mgV/8Nl7RyYdeRb
x-ms-office365-filtering-correlation-id: d9fe1314-7969-4540-277c-08d6284916c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB5266838460EE90E2C61DCE8EA3E80@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39850400004)(136003)(396003)(199004)(189003)(1076002)(316002)(105586002)(186003)(305945005)(11346002)(3846002)(486006)(5640700003)(256004)(6512007)(6436002)(8936002)(14454004)(476003)(36756003)(2351001)(106356001)(2616005)(81156014)(66066001)(81166006)(86362001)(54906003)(446003)(68736007)(6116002)(5250100002)(107886003)(5660300001)(25786009)(71190400001)(6916009)(99286004)(2906002)(71200400001)(26005)(102836004)(2501003)(6506007)(386003)(52116002)(76176011)(478600001)(97736004)(103116003)(8676002)(6486002)(2900100001)(7736002)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 6qU32MJfVnH/SlS690zU01uyTagc4Lp8LX6SWp20KX/Qcr3U2Vn3LdjS2rbneo+ceszgjhbCiMq7RLHuzghN9QhcJD/NiveTVRYnXDZ9gWqc36bkyeSFRIBxacat4wMFhcB6l9LMK2cyTF4zyNSEn36bJsmcsyP96YdIiH/iFwqsm503freNFqfBeQJaIyidbb2YKBEBUvs29gCo4vCfviWzPcYMKRaf7c6xwRA61XWgdtiW8SjaIkPkcYRs3KlM4gal0zenn2q6Gu+U8RcsW9kt9DbhX3e6PeRZRv9PtZlVUhP+T+y3gNOS80RhOMGXRYa0jm02lW7QmpSzkmk2tlNRe5aSS4UM+388d4X+3jQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fe1314-7969-4540-277c-08d6284916c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:10.2695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
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

