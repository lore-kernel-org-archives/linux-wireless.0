Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB483C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662B42087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ty9eg7/R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 662B42087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbeJJWTM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 18:19:12 -0400
Received: from mail-eopbgr730043.outbound.protection.outlook.com ([40.107.73.43]:20208
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbeJJWTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 18:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gE8oNH7+pBDIQx4+8gJidoEtDGhdBaWAy1KPn6xPVg=;
 b=ty9eg7/RfBYpecwUp3VBHYx+lUZoJ/a/sw+XpUu312LoIGSglIYKyXbwvj7SVO/fDwyALubTbyUdZUEnuJMlYao2tShlaBr63OjGpV8GZWyVnwu7Zgo0RE4MNGsgam9GENYr9beOi/RAAyfxaDXpLhUlhnrEaqOfwC6qdX0LP8M=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4772.namprd05.prod.outlook.com (20.177.145.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.13; Wed, 10 Oct 2018 14:56:33 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Wed, 10 Oct 2018
 14:56:33 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qtnfmac: avoid uninitialized variable access
Thread-Topic: [PATCH] qtnfmac: avoid uninitialized variable access
Thread-Index: AQHUX+jnp2KFQYnOUkemVRD5pFrmUqUXjs+AgAEENQA=
Date:   Wed, 10 Oct 2018 14:56:33 +0000
Message-ID: <20181010145625.fn2dy2np7e6xxdci@bars>
References: <20181009155757.494212-1-arnd@arndb.de>
 <20181009202507.xs5bcaq5pi4zcps3@bars>
In-Reply-To: <20181009202507.xs5bcaq5pi4zcps3@bars>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0106.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::47) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4772;6:CjliB6dEPfMEYutoSMEizxbDSsgrnLtsxYlkbtU3H4FYRkuqOno/C+cVrFNErW6LugYNFvZm1r6nyiaLARzQCGil6jsfr7I9L/+e88uJANjx/29ZE3GVnn5ekzOQg2GEYurM6Y2hcC4tt76i7aYJjOAy+UbXP53CSXXBxNs/BAVSYWyt1BEqdSoAX6z1quSxXnh7rcLNhZ4YRlMmkr8zpAPgyUCZKd1m48Rc8Oo8cGCI+Xk+F1J5A5Vb10L6llpp/9y5XqvjjGskLLtujI+FRSgm7zOizMmpzVUbC40mPuFWv4YGXz+iIM0/6jHOj8R9Cnq2Lks6H9AKku6kjbM9C4NVgVgsxqtBiost9+qE0MZ+r/ZgoBB3UvugoD7hEVtzF8Z74hdrGCwi2MOcFfk44CyO9GRP7nJeXZswVV2HAuz3rzvSMouudzhMLV9u6xtVQUPuTvL2hl0MrotSNnRt+A==;5:waxVVprCe19Zop4gHwY3H+X2IVyWfZiSQ7eTnMYKbEK1qBq3spKbGzl5d3BM1EBlXecJqvNXLXKODLhkZeZsmImLNQJIU4Ec3JHAWs+xsw/cy3oKrZ6kQ5+uOlWYfNAkZzkScuK0KPxTlkLOLANFMXLcn32SQT+AjA8QHxwxGJ4=;7:dtUbSjvBDWdaq3hQuivob3QLt/iq7m+2OrDC3ILy2UuWlU8NoGdCBbol/u7EyAA+qOFD/suS/PpAhXYW03GVlBz79ccpwxh2ltgcFAMzZvjIyB7m+LHVe53LSWDQJxbf22yFw2eqGMTSwcacIw9AHTFtxBfece2PI8JQOlqGnrUjrldfebl2fDw0tItrwugoMVQoXz5QWub9DWZYc9Oj4ncy7VrlHdrjl/2Gw/Wro81hNFjPF5ZKQvxkbOixNhzE
x-ms-office365-filtering-correlation-id: 2874bf3f-b4b4-4641-2ea6-08d62ec091a8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4772;
x-ms-traffictypediagnostic: BL0PR05MB4772:
x-microsoft-antispam-prvs: <BL0PR05MB4772D4595A455981EDA8502DA3E00@BL0PR05MB4772.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(201708071742011)(7699051);SRVR:BL0PR05MB4772;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4772;
x-forefront-prvs: 08213D42D3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(396003)(376002)(136003)(346002)(366004)(51914003)(189003)(199004)(1076002)(53936002)(4326008)(5250100002)(76176011)(25786009)(229853002)(2900100001)(106356001)(476003)(33896004)(446003)(11346002)(52116002)(97736004)(54906003)(256004)(6246003)(9686003)(6512007)(33716001)(6436002)(6486002)(105586002)(14444005)(68736007)(81166006)(7736002)(8676002)(66066001)(486006)(99286004)(5660300001)(102836004)(26005)(8936002)(386003)(6116002)(71200400001)(71190400001)(186003)(81156014)(2906002)(6506007)(6916009)(14454004)(3846002)(478600001)(305945005)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4772;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: TS6fBGUKHajmIBhXHE7PjIlJhem7dij8cT3ckUhNbBwTQyXkxb3/PwX4uvxh5tVeMkKspp14ULxWVIcbT5oWi0KTHc3ocnOzabN3mdsYXEiI8MkcKQKy6rx/zxw+hs2V1CRH6OY/IJLC8nVUIhAEBJO88ZQYUXrEechhea8FGatKSPXBxBrz1ogw97ATQ/+bAw5mSM4iPguQQcogq3797w/19G3p185pzJAuPBuHnEFi2hfPKHPZfCgrTrs1mZqn8hhgWvG2Wy2lYcSeiqEppkU6EQgmLi+bCLZ9Wj5gvd5e3mlY0ncVYPxVcYlximfHnHYV7p1LeOUIB+QdAsqe4W5IyuBeXODld7rFRzgu2po=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <549807F516DFF24A8408BE35071DF484@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2874bf3f-b4b4-4641-2ea6-08d62ec091a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2018 14:56:33.6977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4772
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > When qtnf_trans_send_cmd_with_resp() fails, we have not yet initialized
> > 'resp', as pointed out by a valid gcc warning:
> >
> > drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cm=
d_send_with_reply':
> > drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp'=
 may be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> >
> > Since 'resp_skb' is also not set here, we can skip all further
> > processing and just print the warning and return the failure code.
> >
> > Fixes: c6ed298ffe09 ("qtnfmac: cleanup and unify command error handling=
")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>=20
> Thanks for the patch! And for reminding me that I forgot to enable
> gcc warnings in CI builds in addition to sparse checks.
>=20
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Hi Kalle,

Could you please hold back applying this patch for now. We have got
another report for the same function, this time static analysis tool
warning. It looks like the patch from Arnd does not cover both cases.
So we will take a closer look and send a combined fix later.

Regards,
Sergey
