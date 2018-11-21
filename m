Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F375AC04EBA
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFB372145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="TZjbRe/h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFB372145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbeKUS10 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:26 -0500
Received: from mail-eopbgr730138.outbound.protection.outlook.com ([40.107.73.138]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728220AbeKUS1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOT1SZp1bYYEHLxo+tH5HO0Yy0OR2YwVVbYONHjrNEg=;
 b=TZjbRe/hJSziUROm3uqLtOFgoqMUVv9gsChhPQDHSUVKo6KMkbkPhVv3/GDs6PtHp+2O59UyrT5lWe5/obJtoOseYh5KyBwZueIEN8pJoXVSbgYxUhizSh2yAdDAXsFmPe/3uTmW57km8ZPhyJ3F6hHQAV0d0xtCn3cLeexDH5E=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:42 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:42 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <Winnie.Chang@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V4 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Topic: [PATCH V4 1/8] brcmfmac: add 4354 raw pcie device id
Thread-Index: AQHUgW9Szxi/FYy50UGPfWD2uOV+dg==
Date:   Wed, 21 Nov 2018 07:53:42 +0000
Message-ID: <1542786800-146083-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:FNQ3b1WMprEhsPQ+vtc/Xarj5sr0X0HFldJQLUgJ5RjkxTYvAbbiUkCdZTHOaG4PNYIxdnkI/5Oq+KMc0SPxrq0YQE+tmFpkQyX7+IQIxHlfPmYZhpyZT0/4kkVUivqw0ytbz5UIFBlb0eyvyUc6zXxr3Ng1QmtfCKIWxMHRkTLU6tnjd5fCWW3eiMXTnml61tHTwZ19WJ+suu6GqpXQsTporCvodpR8nmhc52kZ/7kqTIXlgGPu1BZYmrdlBKCsgvsZ6kdk948IXnd07dhm+4l6R0mqqkKkHa8uv+U5l6dgUiqyZ6DdxIBmNxvy/kOkLStAg0GdYxqgFSXIZQIaQo/VIXSeiTjn/t6qFlnSgbslmX54ZKpGcmnvmymGpU1HZWhZAX3uC1ZeXVxH1ANYtXu8RYwfcxSCEKv62kGeJpFeeKChEA/mEsajR47i+DJhMHA5Y9skNpaWZaZZlfuGTQ==;5:nI42cogP9Q+/B70n+XiufctNWD2VflGU4VmHDTBFlvT7i9y6qyQNZfMrqB/H0PAM1jevfG9P5fxK1AGHphJ76c6cjPgYX1WA2eOMyqvfAZ2eag5UjFYYFUtPECqfF0kaYvqyp4EocooFz3NRnyvX+aC/e0ZAETi49OvkV4+raXE=;7:zLdGrKEhtQwCoL/nsqQZCAAfihf57gj6aGdK9aBTiNP+tV1fc+ANU1f30L0ZSg4NMnykS7uNjmiVqhWqQEKcZr8HNSZFiAN8dZbc2sLsPREAR/Gv58/CJpuRd+Xd2+XcVso8j2UQNte2p0W+K6oFzg==
x-ms-office365-filtering-correlation-id: 93300cb8-3efc-43dc-eff8-08d64f8674c9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11748512653A5E212D81377FBBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 3XkVdaLhdhGzClB0+vSx2tIvF0eJC4vW6u49R0i7ac8pVmbMZTb5J5aivAH3JUlV0iiisv4ILTIBAmdW5AsUtLvN42aE/ExrsvXZOFEnW5pKYIvFDaPODyJV5jemrgOvNGiThwjCiIoEiz9bAzK38bIo1x4Dc02T26dgNij3rFvK0orl//UHGp2eq7L94x+hrc0ZPRijMEx6tWU7H1/IEJ3Ud4sBepx0Q++5MytX5h1ITiwHpHRdE5oJwSZhNqLZZWenG4jX3GBqKpGq9fDVTwHJekQBz62LrteFpn0VRqOmcc0csT/YSphgA0BOwNf99BaFTPTu1PFaNe9AkYDXTyzsUC3iC/aJU6x2H3TSQtU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93300cb8-3efc-43dc-eff8-08d64f8674c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:42.8888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Winnie Chang <winnie.chang@cypress.com>

Add the raw 4354 PCIe device ID for unprogrammed Cypress boards.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 1 +
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 956a8b236836..16d7dda965d8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2019,6 +2019,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm =3D =
{
 static const struct pci_device_id brcmf_pcie_devid_table[] =3D {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
 	BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_RAW_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h =
b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 686f7a85a045..acb87238922f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -74,6 +74,7 @@
 /* PCIE Device IDs */
 #define BRCM_PCIE_4350_DEVICE_ID	0x43a3
 #define BRCM_PCIE_4354_DEVICE_ID	0x43df
+#define BRCM_PCIE_4354_RAW_DEVICE_ID	0x4354
 #define BRCM_PCIE_4356_DEVICE_ID	0x43ec
 #define BRCM_PCIE_43567_DEVICE_ID	0x43d3
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
--=20
2.1.0

