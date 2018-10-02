Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18D7C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC192089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JueV2gra"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EC192089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbeJBQI2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:28 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbeJBQI1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HtwuiLSFeh6ZzZ4VbSPoHHMfXM469h2WV3bSuE9J60=;
 b=JueV2graO6LjQXjzKLV+kOGNYG0aIRI7v8OE+DwE3Gx3Q8/gJfTHNLqMXMy/Ee41fXvcMFWwbdahKZAEix55LPbKRPtnarGJSoboYPF+oCiLTrI2QqQUHDNBITultLGYjushe/MuDmfsxxUjGdEy7ivgBfIlzVEtAebGOx1omVw=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:26:04 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:04 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 08/13] qtnfmac: pass supported extended capabilities to wiphy
Thread-Topic: [PATCH 08/13] qtnfmac: pass supported extended capabilities to
 wiphy
Thread-Index: AQHUWjHweUq0IxA1EUmpBLXqawKtaQ==
Date:   Tue, 2 Oct 2018 09:26:04 +0000
Message-ID: <20181002092542.18966-9-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:HjkV/4kBHqLuBTN5TBc/5U3T1WZxsv+jjGhEPuAzJ7Nkgi1Uwt5YLGbgjGeWwZJZVK2ZDKUPDLaippLqLA9FvVTJNkOSf//Cy8UF9rpxMByeMHu9N4vZW5WJ3cKXn8LEYvQ5PmE3rWGBMfS2x77w7QN/FZInzSCz9KOKetE4HxrPOrDoIsuCcOauS96/q6/69yLbFsQYSWQKquFv/EUz0Hrc//mAADlzZ+O3qUK7ZEicGkk6AuHbYA/FW+IA68iKJY3a8d91pxZMgs7QR96bxoair1nt6ZBzE0wN8Kwf8YRhWDvN/J8ATS1gSPXqHMxrLf/3BQWvoboRebkLVtNW4Cq8bZwSgsvxkuYm7GWyk9ipkq/TR7fNLWUoHvhzzzLhtIDuG1MSyNPkil5uBTRLa0Qp24NDJ7gIOAcrPkIwe7zhvBWSyeDfi5CfojJkq0M5tRmKcNWzAalxuyzydb3Eew==;5:LZwHXxY1fSmAq/NukKgZe9JU2q6HUxtDk6JyML7Dspe/ntLn93On7yz9ZiOxzLLTwcy7lJmZHx+gmMavnZ+N/smtkipEVnk4Bjf5YwgArrNTKSgfQVAbAY2NeXncDNgl1hLr2cKdPMhWBmTPkiVv9P/oxF7Y1cDmM9V4T86J8eg=;7:AMasuHlTBzSpCWJObwoe/UiXfgO81BMlJy/A2A1A7RH6BeWYVzqHW3p1LouDmHR/S5yDbaJDgIAtzFaHQs/qIxtt1NEjzAy56q9q6Bw52b4aQDz6zi6SHwOoOvmP0k4e85vhoSA9flc+h4Mq8oCKnUChpSgtAJ1tSOmcEDELG2IfZKmd6go3zhUDdWn5yik8l1V/dxik1FJOc/CU5nqEOCzKQFtG4pohlhI9Ig6PKQ/lJpH/m70a0KjFS+ySMwX/
x-ms-office365-filtering-correlation-id: 41733512-5ee9-4c1f-be11-08d628491301
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB50920079DA7BFBC10BB3BF60A3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(54906003)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(575784001)(5024004)(8676002)(14444005)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(76176011)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(446003)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(11346002)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: qqlTrQy8D8YRAdTclRwADKmwSCpg1lRNZk/pTrFyeq37NMMVuhvh/wNCxHoWK/2crP6FfiHfPffsrQKuvoqRLMf2/ODL4Qfszk2BGiPQwwLqPBf/fs6k6DbMr6tKH1+O9GPy4XE0VmIp/QHmy/oVadtav50THlOHRfnGYhCvnPXaJ0DMRIlX323v5oVsN1dlpmj0jrfdhuknCSzCyB8WLH/W3qO6v2BEAcqTwD7z8JYPcg3ucqCZtt2cwXDNiZLpolY6VpwW+Ckx03tq8jPyzLKUsgrTODHelBoNCc4dmhul2cQh3Kn8Y6eOAD/lNTXMCECiOUOJHd8W1OloyOvmgcS0t0jPgfo91RCI3NGRaeI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41733512-5ee9-4c1f-be11-08d628491301
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:04.1972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Driver retrieves information about supported extended capabilities
from wireless card. However this information is not propagated
further to Linux wireless core. Fix this by setting extended
capabilities fields of wiphy structure.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  9 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  3 +--
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 16 ++++++++++++++--
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 8b30d651cbe3..8ecd37ddc0f9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1129,6 +1129,15 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info=
, struct qtnf_wmac *mac)
 		wiphy->regulatory_flags |=3D REGULATORY_WIPHY_SELF_MANAGED;
 	}
=20
+	if (mac->macinfo.extended_capabilities_len) {
+		wiphy->extended_capabilities =3D
+			mac->macinfo.extended_capabilities;
+		wiphy->extended_capabilities_mask =3D
+			mac->macinfo.extended_capabilities_mask;
+		wiphy->extended_capabilities_len =3D
+			mac->macinfo.extended_capabilities_len;
+	}
+
 	strlcpy(wiphy->fw_version, hw_info->fw_version,
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version =3D hw_info->hw_version;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 74edb5a0ae19..8dbd6c45c233 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1273,8 +1273,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_w=
mac *mac,
 		ext_capa_mask =3D NULL;
 	}
=20
-	kfree(mac->macinfo.extended_capabilities);
-	kfree(mac->macinfo.extended_capabilities_mask);
+	qtnf_mac_ext_caps_free(mac);
 	mac->macinfo.extended_capabilities =3D ext_capa;
 	mac->macinfo.extended_capabilities_mask =3D ext_capa_mask;
 	mac->macinfo.extended_capabilities_len =3D ext_capa_len;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index aaa218eb70c8..5d18a4a917c9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -304,6 +304,19 @@ void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac)
 	}
 }
=20
+void qtnf_mac_ext_caps_free(struct qtnf_wmac *mac)
+{
+	if (mac->macinfo.extended_capabilities_len) {
+		kfree(mac->macinfo.extended_capabilities);
+		mac->macinfo.extended_capabilities =3D NULL;
+
+		kfree(mac->macinfo.extended_capabilities_mask);
+		mac->macinfo.extended_capabilities_mask =3D NULL;
+
+		mac->macinfo.extended_capabilities_len =3D 0;
+	}
+}
+
 static void qtnf_vif_reset_handler(struct work_struct *work)
 {
 	struct qtnf_vif *vif =3D container_of(work, struct qtnf_vif, reset_work);
@@ -496,8 +509,7 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, =
unsigned int macid)
 	}
=20
 	qtnf_mac_iface_comb_free(mac);
-	kfree(mac->macinfo.extended_capabilities);
-	kfree(mac->macinfo.extended_capabilities_mask);
+	qtnf_mac_ext_caps_free(mac);
 	kfree(mac->macinfo.wowlan);
 	wiphy_free(wiphy);
 	bus->mac[macid] =3D NULL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index 1722aecf7633..293055049caa 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -144,6 +144,7 @@ struct qtnf_hw_info {
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
 struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac);
 void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac);
+void qtnf_mac_ext_caps_free(struct qtnf_wmac *mac);
 struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
 			 const char *name, unsigned char name_assign_type);
--=20
2.11.0

