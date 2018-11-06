Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050BFC46465
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1CA220818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Tt+yngCT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1CA220818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbeKFNOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:14:03 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387399AbeKFNOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:14:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tthAy8Pvr2uBpo7utpUevQyzxJgDW3O8p+NULyC2Nk8=;
 b=Tt+yngCTjgt8iHYEBjTPeos+XMcb4rwrZffUhiccWtWrgWWBVQGQErryU07K7b8dTdrqIqXNV9aKsKE/EwzacGbDjLNVP4exnGcLFiYMYHtDmrwIcaWCCGOuQe25/UNoO0MhJkh93Pys3FdNRfDRIZLolLcagFhzVKAYoypi080=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:31 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:31 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 11/11] brcmfmac: disable command decode in sdio_aos for 4373
Thread-Topic: [PATCH 11/11] brcmfmac: disable command decode in sdio_aos for
 4373
Thread-Index: AQHUdYPcAa2eRkQ2iEuwGIRBoR8eFA==
Date:   Tue, 6 Nov 2018 03:50:30 +0000
Message-ID: <1541476188-75475-12-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:ZaeHJGDIDkhVTDdFgJbXsPJ6iLX9SWg39bd7b3SamBmKNaobLdNJJn8zoNl0L7O2/5EC9eEaZyxt1SdYbVvOx34sXt3t+55kmiRpxVqR+0Y6zc7icosBngR3wA3FkdSOoTHvyXfCpnsfQ8LxfnaQjCaaFV5UgN5WRAmdoE+9s/4mzFBMfBsFRT9Vllfj8F4Fiyew37FSrmbx0aaFpFFmQn713dn0x5V8rAOn8M3f0FGWV6/SZgvwapcwjZwcGIds5/rFMbvqMXYPoWnEPGjmyn7+7wSKv8iQjju/O6XDM7prEARcUiklUA6Hx6ZK1+9W82aL1jWF0YKQ9be9Ix2Thhibp6/WoJvgAgcKtIG4SFyd5Lu0k/Hxu7cZVVzwrHa8PfbBnkymDt6eaAcxvyeiRk6Uz71NfgRLKG0sHLynQK/inrZRby6oj+nv3niKtBW4iKx9FlwJdN/8uPgtR0XCOw==;5:PBV25Kq4W/8M6qfDScfZf73dvyACh460uXYzM6gFFlgKHCI/4McayYhMlu4PJquUIUvCtuQiCgeEPikZz5IqmEZiRZiglvJeaqdGKMbC2QcHNi4Oun7tSE1yj8vf7K624tI7VIE94FKYqZd/jZiKfyNiIqQ3nyMi/mlDPQD9LTM=;7:fjeIR10Z4NgsWMH8xs7k7akFH2cwablcmbzk09KqiTpoKQRQKWM4Lfm8qAxiMIpQYIaYGX52YlZZjyYMrwciI+BL2UOqCNH2RvVQbsVKSXQyA/J7TQSN1mGjKRh0l351mE+Yottfif7MnwRiBru8CA==
x-ms-office365-filtering-correlation-id: 36174a38-3fd6-4dbb-ddc7-08d6439aff30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142FCBE9C80D56B30B4B263BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(14444005)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: cRZ7EsOaXecaLVcrnUT4SH9z6/bt+gRFfgKgh+xqGWJOy6eUXewwDdSQnhtHXTpw0UD2vFre2Uvy2oYpgtngEToFdJDqd7t4uuhyovAGD2VLedXYhMy/+x+nO8Vxt7eKts7FJMzVsgHVh5Cn+yoluQcg+6bT/7VENFjfitnPlHntOfEJ/PQ5h4ItBr/oXwulFWWl3piPLhuC+90xZ+yExKGSCn7ivjkK8AXjV6hbAURWM0XCu6ccI8fqFvRjKvUFUZVHVU8StLEtIET5VQpbtzrjiJHKcphWpqJMNHS+MGnoLlEJxIeb8NQQQz8k92HJULu1/M4u/8KU4ab2HTyEYw/NGKCtvmqACmVPvXmPAwM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36174a38-3fd6-4dbb-ddc7-08d6439aff30
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:31.0485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhan Mohan R <madhanmohan.r@cypress.com>

By disabling command decode, sdiod_aos module supports
the detection of sdio command line toggle only and
generates a wakeup request to PMU and to sdiod core.
It does not decode any sdio command and generates no
response to any command.

Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 337e72b7787c..e8a8037be82c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3370,6 +3370,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
)
 	}
=20
 	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID ||
+	    bus->ci->chip =3D=3D CY_CC_4373_CHIP_ID ||
 	    bus->ci->chip =3D=3D BRCM_CC_4339_CHIP_ID ||
 	    bus->ci->chip =3D=3D BRCM_CC_4345_CHIP_ID ||
 	    bus->ci->chip =3D=3D BRCM_CC_4354_CHIP_ID) {
--=20
2.1.0

