Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F656C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42DF62184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="fgeAv2IQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfCTKFV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:21 -0400
Received: from mail-eopbgr730067.outbound.protection.outlook.com ([40.107.73.67]:6912
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfCTKFU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzlCMgMzKeU/f6GLkqIhLqWQK7ldDxF1BjiVgIvaMhA=;
 b=fgeAv2IQ78i2ptJegQ+VMCnZBPQIMzDNj5FNjNJWsQGC71+q2QcTwBAjAMeX4nJuwie10V7kAH7WU+dsr03vsX4azFwvvbFCRgxSkFaEVoF3O7NO1lt+if8m/mRFVm8Wt3BV+tHeUdu9XBb7Fx/jOKOIywbbqLTaomVHWZBSrmk=
Received: from MWHPR05MB3406.namprd05.prod.outlook.com (10.174.175.155) by
 MWHPR05MB3103.namprd05.prod.outlook.com (10.173.228.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.9; Wed, 20 Mar 2019 10:05:00 +0000
Received: from MWHPR05MB3406.namprd05.prod.outlook.com
 ([fe80::d101:1b20:b050:4a7b]) by MWHPR05MB3406.namprd05.prod.outlook.com
 ([fe80::d101:1b20:b050:4a7b%2]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:05:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:00 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 08/14] qtnfmac: update bands information on CHANGE_INTF
 command
Thread-Topic: [PATCH 08/14] qtnfmac: update bands information on CHANGE_INTF
 command
Thread-Index: AQHU3wQ9Z0X/yrDRJU+EohBTQKyVyg==
Date:   Wed, 20 Mar 2019 10:04:00 +0000
Message-ID: <20190320100340.14168-9-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3dff51-faea-48f6-68fd-08d6ad1b5fc8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|MWHPR05MB3103:
x-moderation-data: 3/20/2019 10:04:58 AM
x-microsoft-antispam-prvs: <MWHPR05MB3103F0BC6990D3666A35E99BA3410@MWHPR05MB3103.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(346002)(376002)(39850400004)(199004)(189003)(107886003)(316002)(53936002)(6512007)(478600001)(6486002)(5660300002)(256004)(6436002)(71190400001)(71200400001)(5640700003)(102836004)(26005)(6506007)(2501003)(186003)(86362001)(4326008)(6916009)(52116002)(14454004)(25786009)(99286004)(386003)(1076003)(15650500001)(36756003)(11346002)(81166006)(305945005)(7736002)(8676002)(103116003)(106356001)(97736004)(2616005)(3846002)(446003)(6116002)(76176011)(476003)(14444005)(486006)(436003)(105586002)(54906003)(66066001)(2351001)(8936002)(68736007)(50226002)(2906002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3103;H:MWHPR05MB3406.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OFyJA4+bUkLG83GuRYFHsJmOMVUFLERQ7uMDyzNKBsnDTUxJ4feT7jmB8rDoSzgoQQUKAWLh257Xaxca6iQThDMKEyJhZO+g40zlVYWdHei/AN3vEc0fC/9DDt7SL7KL35XpvDHRNWFCj7+RgfDpQ5HTGCS98U7zP168/qGlnpgVo1LG8+/6KPCnqtiwKiIELxFVXmHrGgD2fPYqY81kfDK7mYgxAlBFpcyr2hiseOBxWm7BtOmE1TmLC1kAgVUu82t1GIGepfBwHpz173ko41d20QFFH8bI38TzVzlCqmO9Lf1VNrZ3hTl9Rjjae/ZRcMtKjgxG0BSvs96Zk/UffUuCvijK3ksiqSQzF6acHqmbam6OVwec0fq15KGr6nif55d7Ov9mLnWzxkQ/AP1EmNL5pzozPPk0wEa/2KVL+Ao=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3dff51-faea-48f6-68fd-08d6ad1b5fc8
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:00.3587
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3103
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

In some regions, different regulatory limits (like max Tx power) may be
defined for different operating modes. As an example: in ETSI regions
DFS master devices may use higher transmit powers compared to DFS slave
devices. Update bands information in CHANGE_INTF command if mode of
operation changes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 21 +++++++++++++++++++=
--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index cc7f74333f48..2e658e394dc6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -786,8 +786,25 @@ int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vi=
f,
 				   int use4addr,
 				   u8 *mac_addr)
 {
-	return qtnf_cmd_send_add_change_intf(vif, iftype, use4addr, mac_addr,
-					     QLINK_CMD_CHANGE_INTF);
+	int ret;
+
+	ret =3D qtnf_cmd_send_add_change_intf(vif, iftype, use4addr, mac_addr,
+					    QLINK_CMD_CHANGE_INTF);
+
+	/* Regulatory settings may be different for different interface types */
+	if (ret =3D=3D 0 && vif->wdev.iftype !=3D iftype) {
+		enum nl80211_band band;
+		struct wiphy *wiphy =3D priv_to_wiphy(vif->mac);
+
+		for (band =3D 0; band < NUM_NL80211_BANDS; ++band) {
+			if (!wiphy->bands[band])
+				continue;
+
+			qtnf_cmd_band_info_get(vif->mac, wiphy->bands[band]);
+		}
+	}
+
+	return ret;
 }
=20
 int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
--=20
2.11.0

