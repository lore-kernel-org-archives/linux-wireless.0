Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FA3C65BA9
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B7E820645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="js0lQrR7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B7E820645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbeJERJv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:51 -0400
Received: from mail-eopbgr730079.outbound.protection.outlook.com ([40.107.73.79]:1696
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HtwuiLSFeh6ZzZ4VbSPoHHMfXM469h2WV3bSuE9J60=;
 b=js0lQrR7VP5ge5DTOomi6aVuuzsok++6xEKk3HhJZ6m0LVQz1+37bTaYI2T2zVy8EdcVGdk/UmFhRchkpwoR6c7jjSTw+6RnR4REMv1vi3kMa5kgTrk+H+cO5xWDLW7+GXUmgLfsNSaJ4CRKnWCmERfHi/GXR5tMkuyGsmZkOmc=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:38 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:38 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 08/13] qtnfmac: inform wireless core about supported
 extended capabilities
Thread-Topic: [PATCH v2 08/13] qtnfmac: inform wireless core about supported
 extended capabilities
Thread-Index: AQHUXJPNsx8U2c+pmUeer29m9bkaFA==
Date:   Fri, 5 Oct 2018 10:11:38 +0000
Message-ID: <20181005101114.3013-9-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:QXzyd8xJXztXYod3dZoIhJNXGwyB/mnPLk+8w7O/V9dISqHD45i8OS1QmLV/eFnjcAgEy6niqJrLeVrRuNHBQLQOPvL6hdm6VsMj7xcK+JBMkWG4wHY+PoYzHg+F+Ga69Fuulfk/pGuFHXWjt6tZvYWVeBkHjBZ79xMPxd6c+hUxUlido0vSsl/+NnknVR48AJ+7iol2LP/AXdKE8MRG27IloJuF56ej/8n+ulC2EPrGHlkXpg9VMIfW8JJ00PyxOzW+TSS63bb1zjZ9IGvPJBGjktdr7GHNLH/wKO0uzYMLGWOMfSjIfZDObGbkDe2mhFJFlf6ts4Y+B9jpIa7mjauH4V1DDIKYRs4fld9cuaRJKdhASDLvVaRiX2T/8zaDWGoKPC2X/LNUJRb0XqUTp9jZYfEMUZJsWNOWiwa5EwbjXXvaVQf1Lf6NpHOnpcH+G5l9qub8NJgmjqoKD7mgIQ==;5:ED7FTTaDq5ldBLI2FRkXfnYnFX3+B1Kr95pwRMWElz62jsJozNpTOnuk+wvP4rT/CmLi5Fe82FOZ47hsFgf1dHrNVSJQJkCUkc4EaWTvCKaF0glmzwkWXQeIY6Tk4AZYB9zE1Iq37KeAuth7V/I2xiYjzBDzQErH7HlknfJlDDM=;7:+0UGfhOcpcGZfkr213tmn3FlWRwoPFlnzAOaqPTvKjx6ZZF7psuXHvDR0Mb509C3IkkDlVzzSNCY8uPOgg6ux148f8Hwa/c5Soofz6iLqiO2sX9kyhuhPn3lg8UOs21B/gx6+W9+9Q516k0Lm9VVGwcaSY4NCiHujX6sRFceYEFTEfbVhV3nmYSkGFJDIy07fJpBiDxfoq7e7oIwrBacyboZEDCUfXxFo6NkhR8+soW3aV6eVtaZg+iP5VcVz/X8
x-ms-office365-filtering-correlation-id: ba84e5f1-9174-488c-047a-08d62aaaf026
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB443957EF3AE0FBA1B786EB29A3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(5024004)(14444005)(86362001)(476003)(11346002)(446003)(14454004)(486006)(575784001)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: n2g7MjlXLI9m8fil5boyP/9iuUOjQXycqE+L2mjYtI7wkze0RyhIm7yirYTRYF3zDwyC67DRdNG0tvAVZSFA7z3y/6RESClXAhg1KzoHSRXTh0R1wAK99/IjpCe6XwNvCQpQTOEGQfyUOiOHKOoYqKSytbIwOgBbASLyQhUQQaY7DnQDu+AeaKBn3GtR9b784QMaMyKu4eaJbOIp/eRJPh0o92FxFcM6HJH2CMhCFwLm8hsaxVvM/gv3OTnMjoG2TH2jDcO8cTQspYfoJ0tsqCCpeBX3Wg2kd8ByNu5YKFaM6Zb+DQLSOPGXn1iUOHVh3OESs6wc7mI2AIGJYz2NpcEJaIT7nLyKb/AwxKJGcIU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba84e5f1-9174-488c-047a-08d62aaaf026
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:38.4966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
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

