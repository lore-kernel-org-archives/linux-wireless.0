Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F39C43612
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67CA32070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="evkyujJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfADGL1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:27 -0500
Received: from mail-eopbgr750094.outbound.protection.outlook.com ([40.107.75.94]:53664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbfADGL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah5qceGdQnsyDzCNKhPwb6Nf5TP1bqbPejrOHFIWl/E=;
 b=evkyujJJkJIcHRyrhrg2k7z+XxbNlhVS0aF/YVdCUKtexxJzDxGd4/iQKKSUc4LFHMsKnaXfUHne7cu1MlvAyEuJShBDb5KT9VNP3ulWIeuf5tIFyyNjyYw3FvId83SeVq7yjBjXxHiWFGMJcieWSE+JcHcdhK26JtI33QHSGqs=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:13 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:13 +0000
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
Subject: [PATCH 4/6] nl80211: add WPA3 definition for SAE authentication
Thread-Topic: [PATCH 4/6] nl80211: add WPA3 definition for SAE authentication
Thread-Index: AQHUo/RLIIrF9aSUO0K1919WZUjA7g==
Date:   Fri, 4 Jan 2019 06:11:13 +0000
Message-ID: <1546582221-143220-4-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:dQv6Z9Xh6d5X418GcJz+Wkr++CaV0gwPzQvCYn/L2j1iChz12a7aylutTMjg9fB+sLeAygEGkIvWX3Qtm3TBk0nDrX/ji7wpupnlciqs7D3ZehVXA5e3BtZuFH6hU5ZZdHhMLdCWpmj37lQm0zbt67aGZBFad4M/eNOQ75ASTvkLhQor8RPyjxLLbdAOhri61mBqSBWV9dmb1Bi456MAUZuJLM2Uy9S9+RueLrhRV3sAqN0qdbo7OzWgE/2CvJEDY1F9R+iBTOlINP7RQrghZXtCxYqRVpVJtmxMw35rcuJpu8y1LBidemlSLMQWKpcNth38eBrUvJcBfrGZwiJSNh0eIa0Ojbxh8GG3fzB60KfsTrUVlEjtAJSGvlV15/sqQ8QjaKIz5GZCep9jt9dPpf92+jBHyRqKKcYXjc25EOfmhpwasXj+DluZ8WeZX6vdVPqzPZ5vDNXFYTSu49GJNA==;5:sZqMgZGaXcVy0PCX4qFriw7MYc64KWNIqLUhInAy4TxPewpCVAofyhB7We9aIPKZTREobqH/aa4rTniKBWBPHlNlMk+evq7J3XOKXZNhV097eq5vI78aM8n9z2N1N6+uDEFnNsnc8yDLgg0Sgu0l2GAiIXwGz1/rRJ8LBbrGpQWHF37+Rf9S067jyDHxpZKnunWsLGlj9cESDxWt18rGOA==;7:mkCCNgDpvcg2j4Mke++RVYhR4+0OrvoIGVtsoMcgScpNFY3Y+Csbm6JEEz8xYWoetJ9mBTKke8P98WuiyfyqZtRn4nz1r4EOzP8H8sDuAH1nbnpyKZGIBHot1e+FHiTPo1+BAeqB6uWTOUV7PN2eKA==
x-ms-office365-filtering-correlation-id: 24bca594-fc33-43eb-416f-08d6720b6db1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB5577C0DE63780197EE942979BB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(54906003)(6436002)(446003)(106356001)(186003)(26005)(105586002)(102836004)(11346002)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(14444005)(76176011)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 82PK6SORtidYIUOnpYrL6MGASRFJ9RV7ZjmXSacdxdZkA/T2Z3myQ/0FA1nfp9SZr6GEycyUXcemS1tnnSpIVZ6zGre7dV0uVpypaaQ5PErFjTLhdTDm4idhnifdDM28z3F9EThWV6GuwfiiyKI7gOEKLDHdnTX7xSsbVvT/pnHR9Suwo4GUtZlTg1zKiOe3fZEQ/zK/ZZ8VnBpjMnTPEjbACWB6vReyJbwGQQfd24Ab6Q+1btQYPxSdfLJid4qs+EEVdbajAgmoXeQUXZ2+nN+YH4Jt29JidTuoiVYpqwzkUDLqT8YOLjLA/p6TNPGX
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bca594-fc33-43eb-416f-08d6720b6db1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:13.3696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Add definition of WPA version 3 for SAE authentication.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 include/uapi/linux/nl80211.h | 1 +
 net/wireless/nl80211.c       | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31ae5c7f10e3..12762afb3a07 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4319,6 +4319,7 @@ enum nl80211_mfp {
 enum nl80211_wpa_versions {
 	NL80211_WPA_VERSION_1 =3D 1 << 0,
 	NL80211_WPA_VERSION_2 =3D 1 << 1,
+	NL80211_WPA_VERSION_3 =3D 1 << 2,
 };
=20
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 594aeba2982a..c464ce8bc248 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8532,7 +8532,8 @@ static int nl80211_dump_survey(struct sk_buff *skb, s=
truct netlink_callback *cb)
 static bool nl80211_valid_wpa_versions(u32 wpa_versions)
 {
 	return !(wpa_versions & ~(NL80211_WPA_VERSION_1 |
-				  NL80211_WPA_VERSION_2));
+				  NL80211_WPA_VERSION_2 |
+				  NL80211_WPA_VERSION_3));
 }
=20
 static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *inf=
o)
--=20
2.1.0

