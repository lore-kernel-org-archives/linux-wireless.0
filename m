Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9819DC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 493CD20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="o1Xq5Ooc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 493CD20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbeJERJl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:41 -0400
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:13887
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ktRmOIn04oT6E8rlxJnxDUbuJUAXYLinJCi7mc42k=;
 b=o1Xq5OocHwojXLkLZiYn5UqEOy+RGKIquaaRbGIoySQNEK2FjIqFYCRrQspqRzvaszAN0LMmAceeZrQTqMq/Fdi0IhXVYXGGiIFfry+64jbouXXWbjpR7inRfxne2XdmCe/3+NethLTjk6n8OvE/sRdg3+5Al1WEvuLxIwNqIUg=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB5110.namprd05.prod.outlook.com (20.177.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.14; Fri, 5 Oct 2018 10:11:31 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:31 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH v2 04/13] qtnfmac: do not initialize per-MAC data multiple
 times
Thread-Topic: [PATCH v2 04/13] qtnfmac: do not initialize per-MAC data
 multiple times
Thread-Index: AQHUXJPJFY0xRx2MVky4wCPMnQ91+Q==
Date:   Fri, 5 Oct 2018 10:11:31 +0000
Message-ID: <20181005101114.3013-5-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB5110;6:LJUxSoI8e8WrXJsOaVL2146km6sLAQW304lDvDUxue9cUYlDfJVbdcJSW4+CpufgmOb2ZNI7DYtOA6QGzFBTBHANTKrBYlrfzAiJkWVM5l/1Q0mi+9NIaY2qp8IyRwqbFPSKoUdk/AD5VW9rzSq11ParA5Md6ja20PTG4lIKWaPQf2dvPJHa7Hkl9dZHV4AlvTMbdNOs5zRU7QTHJ/wSVTtIpqc27yNrgK/vRDvyC/v5dysqpgvsqtOajaXaHV12vjH1I6+FmnkOSXhPFzT2zrTdUlLPHslMjosAtc1+eNjaHCBETjHNOFKZx5m+weULhh0chQDjoJ9fcsl61DnwkSxoxRIyM2W3XcwX8noB9UhB5wgPGYOeoLSe3+De/eo0aDJXtAliiesr9XznmOukgVEduVF8WCOfZ62Yw44yROPt0uVVzfcam0/x7naDRCCTP17+nZoO8SBVIgaSZpFt9w==;5:Wj79ln8w3sJLmH9POA3hkvga0P2P+6u+IgYuK/rSMsVG72yf+P0P8EZ3sbimI3q50N7+rrh1ew5cegdiSgne51uJbkysh87Gnmmr6lv1OqSv+bxBj91kdQ8AjYdBYvgTyjSTPWEhP5LeT9TVDn8WGzgtEp2JwQc7+sgUjIpjlR8=;7:JlJbF7b+mgl6Bm/yUkgBtcvRzIElaEjFToOu9PbdGeSYW6qTXnIIrSEZ/6tXYSjPB4JVxxw/ibRVkco/9FqSpl7ZPn//ZsKtqjXN7h5OOLG/yYHjhJauzQstkMm2/pcUQAmC1Ny62Yqk6PQsEyhD5hbCC4M1vUO+ECkLAeqMC0DS6iEsafjAXWSXBkMQeUz0mkTwihKgp/rYebD1stHijN6+RE0rbVt3g9L553wzXyWedPEeO/SfjkbGz2BmVBHb
x-ms-office365-filtering-correlation-id: 222fd542-7a42-461b-587b-08d62aaaec07
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB5110;
x-ms-traffictypediagnostic: BYAPR05MB5110:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BYAPR05MB511002EC0A033818965F5B8DA3EB0@BYAPR05MB5110.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991048);SRVR:BYAPR05MB5110;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB5110;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(396003)(346002)(376002)(136003)(39850400004)(366004)(199004)(189003)(52116002)(76176011)(11346002)(2900100001)(6916009)(2906002)(5640700003)(99286004)(478600001)(476003)(2616005)(5250100002)(8936002)(6512007)(6116002)(3846002)(68736007)(1076002)(53936002)(486006)(7736002)(305945005)(71200400001)(71190400001)(81166006)(81156014)(8676002)(103116003)(2501003)(86362001)(6486002)(102836004)(6506007)(386003)(36756003)(2351001)(14454004)(256004)(14444005)(186003)(66066001)(26005)(106356001)(5660300001)(4326008)(107886003)(446003)(97736004)(316002)(105586002)(6436002)(25786009)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5110;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: R4ZWFkRpYGl3U0/nlnkZBZLoEiZwSFesLPAWcRZDeO57BIVLdORHPXB/DBIO+yyzmjq/lAIRYMKDw1F2IaJ6LD51JPNLnFTPYRd9UytDZ03niTxmOQYY4WO0IKyD8NCHhggUfFxiwJITmT/HFNCYxPAD036VGptuWUkxHBDhqDSPbTYSUa5/wRPJUPTrCMASVU6J2P0ykUcMPSS0vJvZm7QA95cZyx7gepJXWc2XCSdgciJAD07zKa4SIGeeAAT5oPYnLXJ7g1c3hdkCzOIb7FacdvbasNFvewbP8NNjvmo6FI35UFVV4J1Aaa+vhb2fw9EK17wuZe8ta85RrwklHocv60D0479MGoXbNIdXuZA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222fd542-7a42-461b-587b-08d62aaaec07
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:31.5277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5110
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

