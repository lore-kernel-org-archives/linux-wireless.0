Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93B7C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9F82070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ip5SsQOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfADGLY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:24 -0500
Received: from mail-eopbgr750094.outbound.protection.outlook.com ([40.107.75.94]:53664
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbfADGLY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jIXDJGCKjcuQUKwukNE5UOBkSUpo7C+x0oIQbx8dA8=;
 b=ip5SsQOytu47uC05Rdlu0NTT+B2g2HbLfto4a8N/Ea6zG5i1bQgTeCFBdM7fHbjP5UhLGrdFu3+/ASMpE3hBd7wlC0FWcAvbMvQmmF5OsQUBhx6QZeCQ/jRd1rDO8vaVScuW+TNyF6VFpJ3joAcQ1/TeOpxOLbAt62R7dnK1YEs=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:08 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:08 +0000
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
Subject: [PATCH 1/6] nl80211: add NL80211_ATTR_IFINDEX to port authorized
 event
Thread-Topic: [PATCH 1/6] nl80211: add NL80211_ATTR_IFINDEX to port authorized
 event
Thread-Index: AQHUo/RIrwg9QxtW2Uu4Zr8hlj6YTQ==
Date:   Fri, 4 Jan 2019 06:11:07 +0000
Message-ID: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:6Kj3lBp/iraA0yQHPOQjjlLIYYeK+IJQIg4SFJNOflUj43fTsDFi00bB4+W1k8zyaQ4tTYHOHdxvOcOTAyYifMp/WesF7zaor3nBzHIKNKoKjf3z46F41wOiL5zZIYQoLl6cy1IfnKnqxnnHn745b0xk04AEktYzuWIGYY3zXtagZrebt0rlOWYzSBvE8A/3b5lzH8nlDvGScglCslvheVSZZrVhrwkopeSUTgx4fkngDmDVLVFf/5FSn4dkhgtj8UeQPR02WlLUgpAD/fh4lRu2a0UcODhOx9m30U6qeari5ymQ37f+k6EiLNASS3nQWznMlqEf/AmpDksv0SFxucR4tDDEMSwdNcgic2kscs0/Q8U87mD46A9SBujMXCMYUWBN/znxEy500E6wCTIQqXlt6idkpGUhYixtOSIjYbwCw19wzznLnsQXrV6YkzC03TEzTmGT5QyF0hOCQ/q2Lw==;5:A7q0xCcOfjorMxTmcw0VHzRJk/IY961VXU+N0bjktpkHfLcufhlEeI5YuzO49e5+EAdXrBcBzjeqBMtijEDdIQ13Bzx5Dc6/EjKliU81jfzFR7H3lFsa8T+F9CsS11USDxC40E5copMGmP9tzvpiPg7Wt6+GjphrS4O0tizJh6DmJwycmTF5WizQtlkB48wA236RbcmlVun/uaBFdGg/hw==;7:8vTn2tY8ERHwzu5KzRYZM7ZseALhVEJsm3cUEdt/JFLt5tcYFBHB7YM9+kd3h3Xz5YzIlkz67P7P2KErug+T/XjS6pj7EGi97/1hLXhH9xlBfgEb46lpkwVUbwW6c7KxqZvebikhtFgUzC5S1YrZGQ==
x-ms-office365-filtering-correlation-id: 7c6b6f0d-43fa-4855-dd9f-08d6720b6a76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB55778086B78F0CAAC8103657BB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(54906003)(6436002)(106356001)(186003)(26005)(105586002)(102836004)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(14444005)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PI3122LoKLwjoQktxzL7yy7GNSkLJj8uyJPQALLXXC8jw9u6ziRbXzoEZOLBqMiWXR92HunIhtJorLCBT5xeenIqRz8MLpN49fjhB8bKKoIK8JzJ1bFfUgbjU4nWAUu2PAN/+0+x+TGrkeZSN3OWHJMQ7kxo2jB1kaOHKa/7/qqhAU+Exk9EGen7Nw7G6PvzWS8wRcCeaJBusFu3AvNh0xlOLQUyCurqfSGGpOmlh6DUJhK08nNvn2dXWfukQpk0lQ28P36hIT5zLVtLhlIK9zq5ShTsOfC8xUSZqHG3L/gmDekAdg7XfS8hKQm5hbo1
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6b6f0d-43fa-4855-dd9f-08d6720b6a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:08.0268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Add NL80211_ATTR_IFINDEX attribute to port authorized event to indicate
the operating interface of the device.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5e49492d5911..594aeba2982a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14727,7 +14727,8 @@ void nl80211_send_port_authorized(struct cfg80211_r=
egistered_device *rdev,
 		return;
 	}
=20
-	if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
 		goto nla_put_failure;
=20
 	genlmsg_end(msg, hdr);
--=20
2.1.0

