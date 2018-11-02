Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0BFC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44402081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="TlWq+BJ8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A44402081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbeKBRau (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 13:30:50 -0400
Received: from mail-eopbgr700130.outbound.protection.outlook.com ([40.107.70.130]:45456
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbeKBRau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 13:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdWDVCILpSaBa9QamQ9PuJCDRirN9R33E5PiloMBZIE=;
 b=TlWq+BJ8vkw8mcweOjaCkz13PPCC3+PZAG2AaAdjTzqi08ZlJt3FqpED3eFu/zS/7hlZKp0RQbg7j4kPCNL41TLbzDcNhHU5koCx9L7Q/sdPWv17NDWlg7W2d6SGUnEH545fnPfdiebq8GWhsnFaDkrmWj+QrSafieWSrXUlNGg=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5062.namprd06.prod.outlook.com (20.177.186.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 2 Nov 2018 08:24:27 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 08:24:27 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH v2 0/2] brcmfmac: throughput enhancement for flow control mode
Thread-Topic: [PATCH v2 0/2] brcmfmac: throughput enhancement for flow control
 mode
Thread-Index: AQHUcoV4aN5hoL1pfk6zLS/68kZOFA==
Date:   Fri, 2 Nov 2018 08:24:27 +0000
Message-ID: <20181102082403.11676-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0153.jpnprd01.prod.outlook.com
 (2603:1096:604:d::21) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5062;6:c/Aa11Kh5p0kSwVwTnsYlmrdf1/tPqynupw9dHTb4Ohhhc+n0DVaSHLAP9LreFDbzRJu1Qth16/oWo56Mwz4YzJGklRSTsDXoWhnxuLW6UoX1jL2zV0IwZ4CGM+nb3NGO73KYAfvafh92DkLLT5Xk3cbCSmwTfKVDrFji5K3uIgi4usyQ9wiouRRcnmIjHzXAIndvwTYqbZvaLXcoZ/+egC2/n2W39Zl1xRqbI3ak3PLn9smSPM3b+8q5azs7+UUQ3jws8auk1+EISz+El5sM0C2cZNjXYq9AatcM2bYIbE26+B5buTUfR5CBuhSbwtsaRl6Lxto2Gio32QxSWFt4jGFqMPEzmNqc+eQAp1ZG8ExwgOmjs/D7/TAbwRDQQx7rJWh8C5VL/0WjnLB2SPlp3Q8C3X32bLIwfzTXs1Y06e8Tu3ofm1ERQpslAvo2UJtwTLdVowOiGKpg91k7GQF1A==;5:H7pd07IsISp9mq2qRZe94UofMyh+55pgPWFMuh2GJ6ZL44H7Fs6R9fyilT0FU2dGulFf9Dd0Ch9cgNLjWokMgPw/bX2TN2az13FukBV1AeSDkN1oK9ACxgIrgoa1OEcEeLvnmH/0WuY4uhZVD3qYSt2rxnkpVngPKwkBDvzKjHc=;7:UqZj/7tscxh06AQ30GRXMHzk6zK0dryHkao8MYnDck/lkfdzBurlIo0JHmRP4ZfkrU/ECA4qtdFJ6rrKOQVsMZeZPGB4Tjqr/VfeJCwXc8S1Y4BVE2sho7VgKFzOG9aUx+W0cur53igw03UaEeDfIw==
x-ms-office365-filtering-correlation-id: cf3a2808-3925-419b-13e2-08d6409c9a52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5062;
x-ms-traffictypediagnostic: BYAPR06MB5062:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-microsoft-antispam-prvs: <BYAPR06MB506245B1845E4AF7B2E8C20BFBCF0@BYAPR06MB5062.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231382)(944501410)(52105095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5062;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5062;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(7736002)(6436002)(256004)(71200400001)(8936002)(71190400001)(97736004)(66066001)(316002)(3846002)(81156014)(5660300001)(81166006)(6116002)(25786009)(8676002)(476003)(102836004)(478600001)(99286004)(2501003)(26005)(106356001)(2351001)(105586002)(44832011)(6506007)(386003)(4326008)(52116002)(2900100001)(54906003)(305945005)(2616005)(486006)(2906002)(6486002)(86362001)(72206003)(5640700003)(186003)(14454004)(36756003)(1076002)(53936002)(68736007)(6916009)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5062;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: PsN7nqb2ZJz2O/hlmBE1e0BBbcsRbS2RvxWSufaD2nVd/3cOqXS1nZvJrt/SL0g0aKcNLGzcfyPpZxw2kh09Hp8774rbZM9WeOls6rJByFcWxfINbGKkv9zAN3yuf6o9TlhKXOydC9iTcpmrx0HkVdBv6pgDzD3Sb9jugHfWlm38xzxKFAna4Pvm2sTd4wptRK6VsYbp41vJjQ5EhAzqcH2JnFwPp4Jz5/XIZzOCg4pdfNMgd/RLMhhjzCZl2H5M/jRH3CwvjPrk6Tiu8xmzBcBVpL437JpPEnNwxC5N6tHoormhvWT+i/yXkWQ2xZ5G2hOs2uHkyofP0lvwitD0kNWa0eNGMmYD7iz+ziEdv3I=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3a2808-3925-419b-13e2-08d6409c9a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 08:24:27.0306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5062
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The patches are for throughput enhancement with flow control mode enabled
and introduce a new module parameter to enhance TX throughput as well.

Changes since v1:
   Remove the patch "calling skb_orphan before sending skb to SDIO bus"
   Revise the patch "brcmfmac: add credit numbers updating support"

Wright Feng (2):
  brcmfmac: add credit numbers updating support
  brcmfmac: make firmware frameburst mode a module parameter

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |  7 ++++++
 .../broadcom/brcm80211/brcmfmac/common.c      |  5 ++++
 .../broadcom/brcm80211/brcmfmac/common.h      |  2 ++
 .../broadcom/brcm80211/brcmfmac/fwil.h        |  1 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 23 ++++++++++++-------
 5 files changed, 30 insertions(+), 8 deletions(-)

--=20
2.19.1

