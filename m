Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1729CC04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 19:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A48208B3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 19:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="AkW4Fc+W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A48208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbeJPDd3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 23:33:29 -0400
Received: from mail-eopbgr730070.outbound.protection.outlook.com ([40.107.73.70]:48188
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726933AbeJPDd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 23:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iKsMhsqlp7MThskLP5PKGq4yUhbukPzUrGCABcehSU=;
 b=AkW4Fc+W6gufdGUHc7T76NTrjmgMLCQXMbkl7H45YyzdXQsYE6UyXFZ20bG9cOP/+MlWPzFyKLcBfB/d/aoSv+kh//d0MGS7O3LNg70BKzePWHR64RAkp8tUpg+jfxTH7rQL0/ef+qVZ+2C9lgIbtvHfdBGFPkM/nzSS0SH5tDo=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5571.namprd05.prod.outlook.com (10.167.240.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.15; Mon, 15 Oct 2018 19:46:44 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.014; Mon, 15 Oct 2018
 19:46:44 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Topic: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Index: AQHUXu0hlRwXnCwvVUWmMHb83zLAMaUdHth3gAOi34A=
Date:   Mon, 15 Oct 2018 19:46:44 +0000
Message-ID: <20181015194636.7ydshvuo2ykqyp3d@bars>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
 <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
 <87murioxft.fsf@purkki.adurom.net>
In-Reply-To: <87murioxft.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0038.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::15) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5571;6:S6C2ol2WSXq/WtfvK/se8iaPZR3/cqLZuLnhrn5kzqPtrklGcI2KX/x12pcgpD9Uu4oZGHSqAncK6nHESs+puXuqMcTFr+JnH0s6L9savjTUUBtKX1qWK47DZp0HVMy7lcqbood/VzdfBBosRX3wmaFQmngzVe08AtcLoDyhI13/iGPLNoesT3vV49vbfp+imoEGldboKVpSLjdPM6ruuiu7nJ2lNsLPRXp694ONAy5ayr4646p3HUFWlCCpZ8UkREGuyOBj3OZnHaMWlUgF9PkPcfOPRfCL4yvQSGKjVMtjtgL7+yMhkCwiiUdqEGZQh3iPKGAaD7LKJBhD3B9UcaJbXrYBLBpKF+ZNBGvIdiCM/kIHAlihj2sllKbAQDgfpyUlONvtRf42HG7JLYVePZrEijdkCnr2L9Ri3pw9KXQ1V2U4jfz2IC+lm0JA0d5EEcbpjJMxN2S7Obx6dAGw5A==;5:BYBBlCxKcxUorRhlOf06I5noXMy7kmajQYt0T91s/hs/+Oem32UZkozr1cAWu82dkAWfCbw9w+dHRSUKoXmuTfVX/B7XxvDc6jpdzDZGem6qxafKyqN+AKxLa0k2cyO4zCkyFM70DB/k1MpexcmEB4A0HSkIazkH5YUecdEM2ZE=;7:TSOokrF3eaDVqHKdpKv7InYiWMwOhBAp3IEM3EpHBrCYfBmVj4TtbnOVU3nB7OsjkVUJLyaMApNtmLJJ2qLRWMtcdt6GLvLkkY1BvRqmtoNQyyUhZBFKoLUePkydc3HKMAt1B9zFc8w86V1wAmZPy3suQoFAwa+u0bfYJ5fgt+yI0WCD3pYsXeOjgxvy/CrrHJxkwmVmAfwGMxJOH2stilbRdBe7dg5LhhOP33Mty6a6MeGoaRUxCrrpshcBYkfa
x-ms-office365-filtering-correlation-id: 1e51b105-9d9c-4e46-0605-08d632d6ef3e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5571;
x-ms-traffictypediagnostic: BL0PR05MB5571:
x-microsoft-antispam-prvs: <BL0PR05MB55719FEAED30F557CE47EA7AA3FD0@BL0PR05MB5571.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991067);SRVR:BL0PR05MB5571;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5571;
x-forefront-prvs: 0826B2F01B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(39840400004)(396003)(366004)(376002)(346002)(199004)(189003)(305945005)(4326008)(7736002)(107886003)(5660300001)(68736007)(6916009)(8936002)(8676002)(81156014)(81166006)(2900100001)(25786009)(11346002)(86362001)(6436002)(446003)(6246003)(53936002)(14454004)(6512007)(9686003)(6486002)(97736004)(486006)(256004)(476003)(33716001)(33896004)(52116002)(99286004)(102836004)(71200400001)(6506007)(71190400001)(386003)(5250100002)(478600001)(26005)(66066001)(186003)(229853002)(6346003)(76176011)(3846002)(6116002)(316002)(105586002)(1076002)(54906003)(106356001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5571;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: UI+wUAbfpTYTLBj7y7gUBkQXcfwFPpcX/ukisaG1/XiBnQDk6ApSZwX0d72MryHW8KmnxKvusDYcT6Yi3ZjYpzo1uAGi5zBrySntrKEVefVMOr6h/zVhU9XXw/CYxChfsE730/pCJiS+PlWgi/oOZdh6cVUik3Ja/n7xEphSETqP3Q1oXPI+GdR3HAGf1hNAxrSnnLoEaRd/Y11DZ3kj7IkANkpou93chMX5SLaas7ce2k59XaXgKrm06DFYlo/Nzpi71kFBIObs+r9IUTZIOGakzjKxpJUMyjPJUVF15QL6sejVMUKz3Ldhi8Benp3cbMF//7+tB3IhFgdeNvqY1eSPIMB8W+mdW1OBIZhfmUg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <475D7ECD76BEE0449C7E7FE95FDAE575@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e51b105-9d9c-4e46-0605-08d632d6ef3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2018 19:46:44.4744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5571
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > +config QTNFMAC_TOPAZ_PCIE
> > +     tristate "Quantenna QSR1000/QSR2000 PCIe support"
> > +     default n
> > +     depends on PCI && CFG80211
> > +     select QTNFMAC
> > +     select FW_LOADER
> > +     select CRC32
> > +     help
> > +       This option adds support for wireless adapters based on Quanten=
na
> > +       802.11ac QSR1000/QSR2000 (aka Topaz) FullMAC chipset
> > +       running over PCIe.
> > +
> > +       If you choose to build it as a module, two modules will be buil=
t:
> > +       qtnfmac.ko and qtnfmac_pcie.ko.

> I'm not really fond of adding a Kconfig option for every supported
> hardware version unless there are very good reasons (memory savings
> etc). So is this really needed?

Yes, the idea was to save some memory building pcie backend for
the requested chip family only.
=20
> A much better approach would be to have a generic QTNFMAC_PCIE option
> which can be used to include or exclude all PCI code.

Ok, sounds reasonable. Three Kconfig options for the single qtnfmac_pcie
module is way too much. We will drop chipset specific Kconfig knobs in
v2, keeping single Kconfig option for qtnfmac_pcie backend as a whole.

Thanks,
Sergey
