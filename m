Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D85C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51FF20868
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 15:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=camlinlimited.onmicrosoft.com header.i=@camlinlimited.onmicrosoft.com header.b="W69ap3BM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCHPZF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:25:05 -0500
Received: from mail-eopbgr100075.outbound.protection.outlook.com ([40.107.10.75]:15584
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbfCHPZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 10:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=camlinlimited.onmicrosoft.com; s=selector1-camlintechnologies-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ui5X4HluDPXYSIiMh2B/We/mifgWIfnaS380GY7J8s=;
 b=W69ap3BMS7hIZnEYMsoWj/7D4qc/4qsdIOTvQ1VYu0PqpyarDNnl0PHZwk9Jb6Pm0tTIdl3wFbKYxHe+GmumbshRyAiz2T9lOjFYcsl9k3ky46OkTaDwXO/qrnLlmUgG9nztjiQSP1WiT53/dqECrA5xlc/swCpcFpwKdSBOoMw=
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM (20.179.129.83) by
 LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM (20.179.129.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1686.18; Fri, 8 Mar 2019 15:25:01 +0000
Received: from LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0]) by LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 ([fe80::396a:e27e:d5dd:6bf0%5]) with mapi id 15.20.1686.018; Fri, 8 Mar 2019
 15:25:01 +0000
From:   Piotr Figiel <p.figiel@camlintechnologies.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        =?iso-8859-2?Q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
Subject: [PATCH 0/3] brcmfmac: fix race during USB disconnect
Thread-Topic: [PATCH 0/3] brcmfmac: fix race during USB disconnect
Thread-Index: AQHU1cMYu1K1F6tlb0+neZWsLyV6+A==
Date:   Fri, 8 Mar 2019 15:25:01 +0000
Message-ID: <1552058658-23250-1-git-send-email-p.figiel@camlintechnologies.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.143.242.242]
x-clientproxiedby: DB6PR07CA0010.eurprd07.prod.outlook.com
 (2603:10a6:6:2d::20) To LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:dc::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=p.figiel@camlintechnologies.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3c66f16-9f75-41f8-1c6b-08d6a3da3b29
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:LNXP123MB2106;
x-ms-traffictypediagnostic: LNXP123MB2106:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;LNXP123MB2106;23:2E58gCVu+SMKMWGQmMr3jU1VKwqDGQjrACvfUZz?=
 =?iso-8859-2?Q?xSa20B6ypVI7V3RNrkSs8AAiFYASlLoZTKlSDxsPaXLMrKgumbe6Qq/aZ1?=
 =?iso-8859-2?Q?y5XfdYwo5b7gd27JZHl1jIksd4Q4umN4zSMCDg9rw+0t16q9Qc4OJnFWyt?=
 =?iso-8859-2?Q?SXSX9bqNo2JBo60wGD+IJqpzgO5ErURzlA4BION4mCDGBRULY38bswBabt?=
 =?iso-8859-2?Q?81GGmVueeVXy/GvB9G+TV7uy5298/QtsR99DaHKTKCKDiCpjmL8QyUO9K7?=
 =?iso-8859-2?Q?Z/wm1mh7u8LoM64pxJnBBzgu+Bqsa4OwdNgX4guTyABs0yZocAlPmM8Ysh?=
 =?iso-8859-2?Q?p/36giKKr5jQYCF2fXV3P5VQiQlVbxaUSD4zK0ncjRjiu9bfvYxfXV9HJy?=
 =?iso-8859-2?Q?VlJzFDDPPoYPnOW9fqfhykZ5CdnNKqIjeUyvT4Q4yt/tgDirqCRbtEQ5sg?=
 =?iso-8859-2?Q?nlbSN/uyDIWaqFPr/HdvcDbxVUk4a9Gofi+KUxoWR581JWZdx/Y9yJYU6Y?=
 =?iso-8859-2?Q?n0KwHYmrRt65lTETQLsbtHyJ7o8s4wjtupx+/urRzYE3MoI3/DF14p/VhM?=
 =?iso-8859-2?Q?/RE1yx1v1yGG0b5SSAlfY4b/DUljhcHArIL927RXCGMHJHbwvnb/kt8zdx?=
 =?iso-8859-2?Q?2VxSUKCoEXdz302Ivawv3iTVVsyWmOaz+ZN9G9z4L7BtxKY8CWf/5nenwZ?=
 =?iso-8859-2?Q?3PF9h644HTX0wQKLrWIZQeKm9BkVoh0Pyy4kcXYakEoc5UKAPE30LY3ERf?=
 =?iso-8859-2?Q?LCOEKMtR8yVdAjMycM3Y314UTDI0Jz6be2woOrwcF/miiEvJnOCR+6RR3y?=
 =?iso-8859-2?Q?go7CMgbogoEBkgIXHF3f7TKdF6Xop+U8TAyHB9yXJ3KzDoWf3ULvETvWRv?=
 =?iso-8859-2?Q?CRjqAxuDrWC1+7XZ7PX22zJFJohZy3AW3Ia6YUGo4cEuAvNkJYodV8m6Ts?=
 =?iso-8859-2?Q?fgZih7X593ST3GTVs4vtSmPilc8yqpYvXyV59DlhauL1mSfyyuSObELusG?=
 =?iso-8859-2?Q?Dl4IvFuTPc2ih4rbOD50X+yK8mhxom1ZDpRozBoaFofimq4FBM/U0Hcw2x?=
 =?iso-8859-2?Q?aNdQ/C0voIPGoj/WqLHeAiJJ5Iy6BIa+15T9RCtJm9rAkSpwE1BRg+VYll?=
 =?iso-8859-2?Q?WzBG5/m5+y26Om9Hyj5O4jMqv6A/6HRCpwJr0ka2IQCloMNoGicpUbDN2e?=
 =?iso-8859-2?Q?x0r8INUzH2ypMnkxLmpyZR2GqDZKZEOSbJiW3pft3gEBcicKo3udWz4hjQ?=
 =?iso-8859-2?Q?qWA4lC2ZT3j1qRbCc6HtcwiHFhCQK4iQ+8QE65CK5RStz0QqCI12RubbBt?=
 =?iso-8859-2?Q?8KaVjdxYoXQMM1VPixLiByNum4E2q9WxYu4gHc+MIi+wTQDRij2xl9L1Uw?=
 =?iso-8859-2?Q?GEobfgArh+9+gQqHB42oBzBaMA+Hv?=
x-microsoft-antispam-prvs: <LNXP123MB2106A56B68037C6648408869E74D0@LNXP123MB2106.GBRP123.PROD.OUTLOOK.COM>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(376002)(136003)(346002)(396003)(366004)(39850400004)(189003)(199004)(8676002)(305945005)(97736004)(105586002)(486006)(99286004)(81166006)(3846002)(14454004)(81156014)(6116002)(476003)(106356001)(102836004)(6506007)(66066001)(186003)(6512007)(36756003)(26005)(110136005)(54906003)(6486002)(5660300002)(52116002)(4744005)(2616005)(386003)(2906002)(53936002)(107886003)(71190400001)(71200400001)(86362001)(2201001)(50226002)(6436002)(316002)(4326008)(68736007)(14444005)(256004)(25786009)(7736002)(2501003)(8936002)(478600001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:LNXP123MB2106;H:LNXP123MB2185.GBRP123.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: camlintechnologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vUPniBz+HMkMounXRpSyBhT/BGsz57LHcw0qzktMIz+bdyXqmCj/dWi4lu4EFUW0Rm7d9CsASwM1pHLo1JCsDi3wBUhzWV5MbCI1ha5jr0Hty0+/0ImyHVmmOYlZE64GhXoKkRitt/Fz6OYmKi4S1I8OH/EUYIbBgUkXDmx97xll89WM3VFFUKkTsMDnSJkLGHHyxATGjergAfeH4Zh3S2wSIUqAZMwzQ35Ck0dWaIbxTULstwSapF0xsPsUi2fU1lF9n1vtEh7kH7zSDWTsn1MEXCGNYgMlUz4TAnF/Gms/uwrqaVOUsGQ53+Sp7dPqY0lnyLkVI65zXcc502KuaFrkogAPBmbPkG9e3bU8AES1qtYt05sgD+1pfECGzEbuzjLb6iOhcgDUdB1ONSbGjvuEhR+39+mnGuukL7+9lgM=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: camlintechnologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c66f16-9f75-41f8-1c6b-08d6a3da3b29
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 15:25:01.4484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB2106
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is an issue in brcmfmac clean-up during USB disconnect which may lead=
 to
usb_hub_wq lock-up and possible memory corruption. With this series fix the
race causing the issue and also do minor clean-up of brcmf_usb_free_q.

Piotr Figiel (3):
  brcmfmac: fix race during disconnect when USB completion is in
    progress
  brcmfmac: remove pending parameter from brcmf_usb_free_q
  brcmfmac: remove unused variable i from brcmf_usb_free_q

 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 27 +++++++++++-------=
----
 1 file changed, 14 insertions(+), 13 deletions(-)

--=20
2.7.4

