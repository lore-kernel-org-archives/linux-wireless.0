Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A51FC32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB65320684
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="GFRbwhR5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB65320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbeKHNVg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:36 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728652AbeKHNVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4+ChptdaYn482F6G1p9utYjPUpQZV+xIIoHAOFk49g=;
 b=GFRbwhR5gkE+xtGWdlG5X8lHTW5lPNfoVrrhzPey4OJXX1Z7kKfDd/ua0lGD8oAlH4O67wO9r6GlZXt4CMLz6TzbE+JVaO4GEOIzjMi8yXGKbTPJ7qZNdI4ku10jx8zy9V+aZy9sBhuSi2VYe5BiD5J2jTb1bL8RgF+VviXIGPs=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:05 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:05 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 1/5] brcmfmac: set apsta to 1 when AP start on primary
 interface.
Thread-Topic: [PATCH 1/5] brcmfmac: set apsta to 1 when AP start on primary
 interface.
Thread-Index: AQHUdxXaYZfqcTceYUWeFeJO2wET2w==
Date:   Thu, 8 Nov 2018 03:48:05 +0000
Message-ID: <1541648845-194984-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:BYaaCiZbdFwJZxnApW/h5rddTKCEQ+b0NiQHjJK2BienDmQwWlHOXurlKKUvKuCJ+0irhyNBCFANyVBLdBknz8bVWd2WoA1o0Ub44xjQ0ORA43ENLBax0j7yz+RR9WoD6pKFkxUJaSx2+Nf2037hWnGIkvPT0hYhaJc0kqLguWXQBGMkUwJsdlj06LAJ7zBStU2OT4bkxIYyjqAR7s0jL05PeuKcQfFhHQnhuaw6rw5dGGdZ1CYnij8WR8N9lbnO+oW9a49hLfq03nfE9+vCgP7OFyOaF++1ypajsMy++to+/J6T1vBajo2xdVEU7EspZTwEejTfLYVyMLPIjv3KElHXNnKCDvgUq9N2rWwlVWESTl4nJ5qmAvMpJFP3XfuiIhiT19yfoej72qGrwHzWo6s5g1lXxQ0z6MU3PkRXOx1PPVnTehCpbhCi6FsbjsMGWx7/QE0+nGwRnaSAxR4o9g==;5:nAIhqz3zNhdDdYwR/tulk97dVLGiDoKCYkOg283OWFwWyPN6UJddD036RLd16cV8lN7x3BpUG5NHKmScDELDbwRkTGY/hbz16qhooXy1LXNiaQAcYz0OIQ7ulwOQrNLheY18eh0ZYU97eoJWZci38972ogGnR02MxZ2OV6TA8Sg=;7:nIxI5ithJt+LGWRDuSS6V4WgY0F1wO1f47ztmsSDGFKxJW52zxUgvpC2m12BZRxbBOzlLfF7Zy1lBH6xgXzC2ZZbFfUD298hOBerUfoyE8kIPWiCRfQSX3rdmJtGevEMLJa711mZsSeg9zI5EdAj2A==
x-ms-office365-filtering-correlation-id: b816ac32-68d8-4e67-c90d-08d6452cfd20
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB1387C0585509A099688118E6BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(446003)(11346002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(76176011)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nBzQSurZjRg5NRJ0vqxLYixm+XXVbxuCRrdgtW98756s0m8XZbV67Z/gPlL2f4V2ojiA7+bYZzg2utqAowTOWygOO97Lds9ckAoDQRPFPLhVabnCWTYxAaKSUZ5GyNj3hiL8CdNIYtf1sh6A1d1xcY0djPWxRFVgQpc6POrF+x/UFWCNzJbfW6kl7XPmEay0Gh1+kQVACO/JvOTGV3O280HT3Up7v0Dley5Vl13BdwBSWT++1eyTGPVy0KAEyXb/ugMxoYF9ZB8cWwgfypk//QLQLyHwmgYtSo15npYVsQ4jH2GgIGl1xtyTkWsCp8sCcAS7RXC06d58YE0otR846k2ZYVtWP+GdtfYLvhAtLhU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b816ac32-68d8-4e67-c90d-08d6452cfd20
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:05.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

APSTA can work on two band concurrently with using VSDB(Virtual
Simultaneous Dual-Band) or RSDB(Real Simultaneous Dual-Band) features.
In this case, we have to keep apsta is 1 in firmware side. However, if
we start wpa_supplicant on wlan0 and then start hostapd on wlan 1, the
apsta will be set to 0, and we will see data stall on wlan0(station)
So that, we only set apsta to 1 when AP start on primary interface.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 230a378c26fc..165ab1a3f943 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4513,9 +4513,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct n=
et_device *ndev,
 			}
 		}
=20
-		if ((dev_role =3D=3D NL80211_IFTYPE_AP) &&
-		    ((ifp->ifidx =3D=3D 0) ||
-		     !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB))) {
+		if (dev_role =3D=3D NL80211_IFTYPE_AP && ifp->ifidx =3D=3D 0) {
 			err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 			if (err < 0) {
 				brcmf_err("BRCMF_C_DOWN error %d\n", err);
--=20
2.1.0

