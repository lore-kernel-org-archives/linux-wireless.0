Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DCEECDE44
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C0320827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="KfarLEw/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57C0320827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbeKEPJr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 10:09:47 -0500
Received: from mail-sn1nam02on0092.outbound.protection.outlook.com ([104.47.36.92]:15632
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbeKEPJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 10:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFIdDBAXsbNFGENak1h1g1PvprCLTizr8Oyox2DVYaE=;
 b=KfarLEw/s6rr5//HwpjEcZN+HsImJyYtxB0KhmAHZ9F1ZWNXFutdWmF3PT+VTCRApM0B/wnxr4X4PLpV38KsLUsR/Tdfb4Z1pWBnKLMGnrlcT0yL154bMGGmrWn7QSvYK8ymwkz9AfSv3/ZEL9z1H4fK3XSCavEo0Xgbf5uHvRg=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4231.namprd06.prod.outlook.com (52.135.238.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 5 Nov 2018 05:51:47 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 05:51:47 +0000
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
Subject: [PATCH v3 0/3] brcmfmac: throughput enhancement for flow control mode
Thread-Topic: [PATCH v3 0/3] brcmfmac: throughput enhancement for flow control
 mode
Thread-Index: AQHUdMujrbwUEA/B7ESKW7mUz9ot+w==
Date:   Mon, 5 Nov 2018 05:51:47 +0000
Message-ID: <20181105055137.13333-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0165.jpnprd01.prod.outlook.com
 (2603:1096:604:d::33) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4231;6:7a8KH3GUtcxaN6eeC3dsCdsfvXwz4TdjD+APZYuft9noB/doMZkj4L4O2zrs6CSvVengY7stqU7xayeqoitVU7MIWlWvFCz6AlskmgSMTMWdWTiCt+cNgMpXHLfC3M+4KtRjV/uqmJEhCl2X7DxHorY8M8y5sqE/IYUEG1RqnUnLKpF269sjpSN3V/zBbN5wS1cAy/xw3MOSOD1AetIh3BtTkP2d3cVoq98fUkSpS9TVNugYkhuMGhIhPgosXSrhYY3YoLVBag0FcTlqcNDUyHNdcx+tn72mHByenTTVMIeqOrbEsZTCrQK/ludyUIdr1TIqStNjsdrUoSJa+iqvP4tqbYowTkgDDkOqwrpgmi5SmyJ/Gt8DkSYXz5xMUJ5hDU4Gtn+dbYV4Wo85dIurMlWHPRYWy4gIXJPJEdeDjV1+eaavYttKjIXK1t2nd8wr7cjBSSchgxmUjqmkJd0y7g==;5:mVPFlOPaYrCNOGtjKWLtQ6k4Rr84RhdfjwS2uNBg6/jBhwDRoP8mcmAhguhzYk42TOPHReNXylRh1Kjtd7RP8a2Z+jGCXpSWLW3HwGypWy6Ubr+wp3vMkjfii5Qy8MJqcnNuIv0cmueAkj79uprEASzBFdfW322OlawXf0rI0tA=;7:jUmViZ2jpPkbHWPwYgqt4xUJJzoAs4psoWak3Ps6IKBOgh7Bi0w+NdyRRk4I7viiG2dl87bcOU+ZzlSWYrGKLTTYdFYJhfnDUmJs2tUWYOkBR8J5t8LITot6Gl9w+wFDD3Jd1NO+goyhtzIJr7IbvQ==
x-ms-office365-filtering-correlation-id: 81458ee2-e059-4fc1-1363-08d642e2c604
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4231;
x-ms-traffictypediagnostic: BYAPR06MB4231:
x-microsoft-antispam-prvs: <BYAPR06MB42318A453691B536C06BB1A0FBCA0@BYAPR06MB4231.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4231;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4231;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(366004)(199004)(189003)(6116002)(3846002)(97736004)(99286004)(1076002)(4326008)(102836004)(71190400001)(71200400001)(68736007)(6506007)(386003)(106356001)(36756003)(105586002)(2351001)(6436002)(5640700003)(5660300001)(2906002)(2900100001)(2501003)(53936002)(6486002)(6512007)(72206003)(478600001)(14454004)(6916009)(54906003)(186003)(52116002)(26005)(7736002)(316002)(476003)(8936002)(81156014)(81166006)(305945005)(66066001)(256004)(2616005)(25786009)(44832011)(486006)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4231;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ATi9WOCbpOkU2nc6L5P9Seswu+GsrT2zcvVKIPzYT7yg4i9wGclkWn8FLdoXyljIwR8ddhNOv3oqLIq8LoigXIbAlZxaFIq8YY7juaWJmGV4Hua6rQATNm52Zc9wFSWFwiLGMXqffYzaI4dKVmdP64KieEo/Q3U/BAehQjZVKRxzC7YxcvXbvqQX5O9p58v63LRxJuAT3ZNodtknGyP+8bG4TbKIY8ELtlyBMdtLKc3MHqwnFBGh7MIghBukLKxhcC610e92bBGpA5gBSS0qn9PjmcdjDzrrGcfLTw8inHJ+w6u3ZksEpw5MEqfMa3td65G0rmtz0taHGXAO0Jnhw8CBPVXHeyAWgxSJfWgL2KI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81458ee2-e059-4fc1-1363-08d642e2c604
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 05:51:47.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4231
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The patches are for throughput enhancement with flow control mode enabled
and introduce a new module parameter to enhance TX throughput as well.

Changes since v2:
- Add "brcmfmac: handle compressed tx status signal" in this series.
- Enable frameburst mode in default instead of being a module parameter

Changes since v1:
- Remove the patch "calling skb_orphan before sending skb to SDIO bus"
- Revise the patch "brcmfmac: add credit numbers updating support"

Chung-Hsien Hsu (1):
  brcmfmac: handle compressed tx status signal

Wright Feng (2):
  brcmfmac: add credit numbers updating support
  brcmfmac: enable frameburst mode in default firmware setting

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |   4 +
 .../broadcom/brcm80211/brcmfmac/fwil.h        |   1 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 144 +++++++++++-------
 3 files changed, 91 insertions(+), 58 deletions(-)

--=20
2.19.1

