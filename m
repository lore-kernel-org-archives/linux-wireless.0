Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99C0C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A483020684
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="s+SLyBxx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A483020684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbeKHNVv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:51 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728652AbeKHNVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z99AfVk8jXlT6RaRe2WzXh/q8rQeaJ8QlaNjcy8p074=;
 b=s+SLyBxxep3UA3cmzXLodClVhbnICPa2W33mxg1/kPamqih3xdr1NnZ131KYuWbyTKw5mpw3tlMh5/mIGS2nO6taoGcCS6g3LouSvYsf0X32jdYV4RdcQ2wGbn8IaQ4Yn5gpLaejFaNgiJmpJAFAIHJcidPtIr8Ac2zggE/XKoQ=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:07 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:07 +0000
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
Subject: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from
 "brcmf_netdev_stop"
Thread-Topic: [PATCH 2/5] brcmfmac: remove "arp_hostip_clear" from
 "brcmf_netdev_stop"
Thread-Index: AQHUdxXbBfDep3bQw0uZVaWVgYrWog==
Date:   Thu, 8 Nov 2018 03:48:06 +0000
Message-ID: <1541648845-194984-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:xvaU0EZrRLO4BGEYQpZV1w2rFLIV5k6s9jyGV030kLge1StFKuYCQWx70S0AkIoO3CnhYnMfmlYOyuXYk4Bn3hSzbPW6hG2QHl/9pz7GBTZYMSwFGxYes5rXRNrjy81jsrA1GYupivGSrnmwBgtGkMYdnuDWUrreYWqCQlL/t+XG5EcEmbI8dnq1Ob8LQo5ofAO8ndAAikMT3vKY7T5VabJUUhCfG2Q3dk0llpIZMlHFc5qBE74BIiJvzDt6wx/+kaaCB5eOHvW+0lfG2tsPY5TtplkWzhxqS4t4X2vYm0dVouRbbZm9/oSHGNDGeubgqlhgSncKTyvC5+R0eHRNWl2cU7sm1rIWr2bnMs25TkRh4MZgkPUwD1Ai6wcaBTdq7M7QtHN7q5WKIf0+qmd7YkgPzDwUZn1K1FSPa1uK7muGA/eWoauBoZy/dhZ7AllzaMUo2KTrJZBdM0wwctnyKg==;5:roCkv6QZkJV9/6ce1tB4OWKSExVl6camrxHdqKzyAw9SzxrknYvtPz6E963TuHJftqT/AAUdgnTdZdIIAcal0Jsw3xhGz9xFmFiOgxjsfZMTdQlUHAQT3uyztINhNAPfXrfZlJBplvqcZ/9LpSeSoRkOI3iIrB9STGMGBJaTptU=;7:CH+KdQTMSZb5F3pYxPPsSYVdAwwjdRnxNRYySKSjKkET6njm1Hw2kA6/nj8dMhFJCHI2aTAYAq/zA1uomchHXz83NMCuUFxTjoSQW5B99OkbexsSgrWcSp/c+CvvZmqV9wA2FJ8de/zBfR4Qo+KYCw==
x-ms-office365-filtering-correlation-id: 969c551f-2530-4378-3b29-08d6452cfe1b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB13878AAEFBDB79375B35E8C8BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(14444005)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(446003)(11346002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(76176011)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: m4vXni3k+p4VT31+J0cbbHoO5T7n97Q8FDu5fuEqeogsoXc2Jd4urMTOSxZ3Tjhyx13EVN09WeoNVYMeVTl1Mh2Hkk3UMpKlX4a2KvV6RrJPHehpwE9q1WcAA7zNyFXCPcqLRT/JRodLb4Iuiyv8T/HdcIgmU4gFdhJzKOtGtgMWN/9HL3n/EkJ9/qE5DrcxX5/4su6ZPrwEC+ymYVBeh2zfxuPMefkruQ3Jzq9UeAXjjzHt9qkjDT4xTk/Rs3JsLNWE+ugxG4A6XXSMXTp9zEdT0DMFvJxtEKB9CEx1gBRWwhV1gJkIuWUIlTVsWxY5GlJZ7KOS1dgS5RjHX2LmgBwIbPmHkgDTAM1SBwzJSDo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 969c551f-2530-4378-3b29-08d6452cfe1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:06.8933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

The firmware does not respond ARP request and causes ping failure with
following steps:

1. Bring up interface
   ifconfig wlan0 up or start wpa_supplicant
2. Set the IP address
   ifconfig wlan0 192.168.100.10
3. Bring down interface or
   ifconfig wlan0 down or kill wpa_supplicant
4. Bring up interface again and set the same IP address
5. Connect to AP(192.168.100.1) and ping to AP will be failed.

FMAC clears arp_hostip when bringing down the interface, but not set it
back if setting the same IP address. We are able to see the IP address
in interface info(inconfig wlan0) but the ping still cannot work because
the firmware ARP offload does not respond the ARP request.
Because of that, we remove "arp_hostip_clear" from function
"brcmf_netdev_stop"

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b1f702faff4f..e1666cf3801c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -533,8 +533,6 @@ static int brcmf_netdev_stop(struct net_device *ndev)
=20
 	brcmf_cfg80211_down(ndev);
=20
-	brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear", NULL, 0);
-
 	brcmf_net_setcarrier(ifp, false);
=20
 	return 0;
--=20
2.1.0

