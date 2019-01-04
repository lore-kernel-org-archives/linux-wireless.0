Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB07C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D93ED2070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Vi6nfZP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfADGL3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:29 -0500
Received: from mail-eopbgr750094.outbound.protection.outlook.com ([40.107.75.94]:53664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726169AbfADGL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo20cT9uBmi5WiMkDVf47YjRkVTaINQIz7rePoLCzlI=;
 b=Vi6nfZP6t4QaiV+SqZQtgqkfU4I2dH+zNpbK4IIT9DWuXo4e8BRtOA7YMOuWxgFPDojZr6YJC/oqH2TJefR7vhp4G1IyIGeevr658RUzTNS5ibLKhgJCACcbNBMlf0NYTrbSDswnXdGtSuBiPGx2P0kn+Ct/PQ+i7/6zXBi9BXs=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:15 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:15 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 5/6] cfg80211: add support for SAE authentication offload
Thread-Topic: [PATCH 5/6] cfg80211: add support for SAE authentication offload
Thread-Index: AQHUo/RMRC05NzPT/kyxMDRO+33gwg==
Date:   Fri, 4 Jan 2019 06:11:14 +0000
Message-ID: <1546582221-143220-5-git-send-email-chi-hsien.lin@cypress.com>
References: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:74::15) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:d9cqy3QFfooYF5Q8JUBUVKcXgId7+lzUXNudwpe+8tHnR4MMG7Y2v2s4hzwPE78LAI1ILniS4xNo8xSDRNXIhiKsTKj5IucvvhOpeHA3mCiuU4YXahuatCbHbiKuP7w42WHsMk1KWSy7UvYYPdx99cfyvVEeCfZdGVIUcUv+7nS3dZo5OOLdP/QpLZkcsuTV+qAJ0eUD5Bb1n92z6oWoa88F2zkh9QZseZpwlCImGt8IUWU+z9YA56RAxWCDFFGAGEraBKxA+EGZK0u2LI0zEHjSpgKiL60cPBN62Y7X1RADo/bYcgBj9IjGzl7RgAS5+IF0fE4mmneVRxBQWMXsOqq4fywD29uK9xqWDvetVVvnYRDo+2V1HdiN+t7y8+hd0qtKoJmopSxPxb6YASKAK/S3wX5XUPX65p5drD3/zXFLiEEEa8RjNXTnOAwcHtVmD97zcAiuoDDhW6RgnOIotw==;5:pvil5wjahilrpupL5TFYc7he8kp44ol3MZKrjnGCZsVlmjtaFswqIFJp/uatuFDvdqwMo6INLfEbbKT8aru4pK3HVLfoq0qAvtU5fjNBS9dJBzHN3KFcQKa6ZRqPmEWX9cPTOk0pkOtKLjcq/y+Jj1NfDYFvapHTzC6h3gGjVk+2cjg6iCHtj8xUwa9VHtpMDC9A9KJAQNmrjGz1wj0xOQ==;7:P2ZIHyfS0P8NxeCFo8rtplDJKInl9J1HuCpPh7ehKJ7HGd6kyhgVpB68QkOwsyhcuL5Qf/agRO0olPn+K2Jivtx54M0Doy40gQ/QT6Sb3Qr/Zc9FpmH3tAPzaTQpZqObhqpfPVD3LtV3H8+qiHySGA==
x-ms-office365-filtering-correlation-id: cb2bbcdb-8fdb-489f-6212-08d6720b6e95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB5577D459F437BE10B57D1145BB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(15594002)(189003)(54906003)(6436002)(446003)(106356001)(186003)(26005)(105586002)(102836004)(11346002)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(575784001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(551544002)(14444005)(76176011)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5e1QgvEBeY8MnDXqdERDa78pLiQVMtNw8Bv2Uz6fM5TIEaBTn+mX4S8WTZiG1nuXkexjwWNqTR3rI5QShC1kIjvaopmJlqlDIdeiikRlDfTyg/n8Lx4SJP/A2m7YxgVjg0d/LRHJfhD5XItjrLhWAHq5VdMZ2aH5of1x0xCbCOl7MOOQOZV23D6jfwpafUEY5niHuh0nfVlW1N7P6+7MHEjamu/jgEActkYB5+r8HKeeJ+m0Pa8pppty12ekisRfk5zdPAU3bERYcQ2s/S9Ivc376eor0nv8NnJTKn4/OVkoA/4VqA53Jjz57Equ1hGg
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2bbcdb-8fdb-489f-6212-08d6720b6e95
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:14.9517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Let drivers advertise support for station-mode SAE authentication
offload with a new NL80211_EXT_FEATURE_SAE_OFFLOAD flag.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 include/linux/ieee80211.h    |  1 +
 include/net/cfg80211.h       |  5 +++++
 include/uapi/linux/nl80211.h | 16 ++++++++++++++++
 net/wireless/nl80211.c       | 14 ++++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3b04e72315e1..37d3e655e547 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2596,6 +2596,7 @@ enum ieee80211_key_len {
 #define FILS_ERP_MAX_RRK_LEN		64
=20
 #define PMK_MAX_LEN			64
+#define SAE_PASSWORD_MAX_LEN		128
=20
 /* Public action codes (IEEE Std 802.11-2016, 9.6.8.1, Table 9-307) */
 enum ieee80211_pub_actioncode {
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb1c860..5809dac97b33 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -740,6 +740,9 @@ struct survey_info {
  *	CFG80211_MAX_WEP_KEYS WEP keys
  * @wep_tx_key: key index (0..3) of the default TX static WEP key
  * @psk: PSK (for devices supporting 4-way-handshake offload)
+ * @sae_pwd: password for SAE authentication (for devices supporting SAE
+ *	offload)
+ * @sae_pwd_len: length of SAE password (for devices supporting SAE offloa=
d)
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
@@ -755,6 +758,8 @@ struct cfg80211_crypto_settings {
 	struct key_params *wep_keys;
 	int wep_tx_key;
 	const u8 *psk;
+	const u8 *sae_pwd;
+	u16 sae_pwd_len;
 };
=20
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 12762afb3a07..4840aaed39ba 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -235,6 +235,15 @@
  */
=20
 /**
+ * DOC: SAE authentication offload
+ *
+ * By setting @NL80211_EXT_FEATURE_SAE_OFFLOAD flag drivers can indicate t=
hey
+ * support offloading SAE authentication for WPA3-Personal networks. In
+ * %NL80211_CMD_CONNECT the password for SAE should be specified using
+ * %NL80211_ATTR_SAE_PASSWORD.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -2288,6 +2297,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
+ * @NL80211_ATTR_SAE_PASSWORD: attribute for passing SAE password material=
. It
+ *	is used with %NL80211_CMD_CONNECT to provide password for offloading
+ *	SAE authentication for WPA3-Personal networks.
  *
  * @NL80211_ATTR_TIMEOUT: Timeout for the given operation in milliseconds =
(u32),
  *	if the attribute is not given no timeout is requested. Note that 0 is a=
n
@@ -2743,6 +2755,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_FTM_RESPONDER,
=20
 	NL80211_ATTR_FTM_RESPONDER_STATS,
+	NL80211_ATTR_SAE_PASSWORD,
=20
 	NL80211_ATTR_TIMEOUT,
=20
@@ -5316,6 +5329,8 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PT=
K keys
  *      if this flag is not set. Ignoring this can leak clear text packets=
 and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_SAE_OFFLOAD: Device wants to do SAE authentication=
 in
+ *	station mode (SAE password is passed as part of the connect command).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5356,6 +5371,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_SAE_OFFLOAD,
=20
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c464ce8bc248..d1ebc93d5d56 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -557,6 +557,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR=
] =3D {
 	[NL80211_ATTR_PEER_MEASUREMENTS] =3D
 		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
 				  nl80211_pmsr_attr_policy),
+	[NL80211_ATTR_SAE_PASSWORD] =3D { .type =3D NLA_BINARY,
+					.len =3D SAE_PASSWORD_MAX_LEN },
 };
=20
 /* policy for the key attributes */
@@ -4348,6 +4350,8 @@ static bool nl80211_valid_auth_type(struct cfg80211_r=
egistered_device *rdev,
 		return true;
 	case NL80211_CMD_CONNECT:
 		if (!(rdev->wiphy.features & NL80211_FEATURE_SAE) &&
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SAE_OFFLOAD) &&
 		    auth_type =3D=3D NL80211_AUTHTYPE_SAE)
 			return false;
=20
@@ -8769,6 +8773,16 @@ static int nl80211_crypto_settings(struct cfg80211_r=
egistered_device *rdev,
 		settings->psk =3D nla_data(info->attrs[NL80211_ATTR_PMK]);
 	}
=20
+	if (info->attrs[NL80211_ATTR_SAE_PASSWORD]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_SAE_OFFLOAD))
+			return -EINVAL;
+		settings->sae_pwd =3D
+			nla_data(info->attrs[NL80211_ATTR_SAE_PASSWORD]);
+		settings->sae_pwd_len =3D
+			nla_len(info->attrs[NL80211_ATTR_SAE_PASSWORD]);
+	}
+
 	return 0;
 }
=20
--=20
2.1.0

