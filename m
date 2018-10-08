Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE29BC677D4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA11A20841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="e0ZyEUL7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA11A20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbeJHUr6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:47:58 -0400
Received: from mail-eopbgr720059.outbound.protection.outlook.com ([40.107.72.59]:65376
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbeJHUr6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHHTcoGIiMUNlGHv2iP7DfZcDVB8Jzb1BX1VOQbI0e4=;
 b=e0ZyEUL7myG6b/5uDwj9tTXuIiFY0pTK6Klw+DyI/t96FXEmwWyQncgAQyXgwpKCqCAi6IDuHE9mjksQjR8iMcuHqQ2OTk5LJBCfCBup5fa34VuPLQmWeltIdgOz0QUUq73PJL5w7Sp9B2O/RlaV/SqcEFQwCtuh80SPo4MH1nk=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4184.namprd05.prod.outlook.com (52.135.200.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.20; Mon, 8 Oct 2018 13:36:09 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1228.020; Mon, 8 Oct 2018
 13:36:09 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Topic: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
Thread-Index: AQHUXu0hlRwXnCwvVUWmMHb83zLAMaUVOHc0gAAhYIA=
Date:   Mon, 8 Oct 2018 13:36:07 +0000
Message-ID: <20181008133558.3jjmbwjl7n2rigpw@bars>
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
 <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
 <87in2cr7pj.fsf@purkki.adurom.net>
In-Reply-To: <87in2cr7pj.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0601CA0033.eurprd06.prod.outlook.com
 (2603:10a6:203:68::19) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4184;6:3oQyQ2o7km9i9QnIt0zO2ZEesfUL8mSIIiS4yZkHiQ2nJyKSBCeXpAqMRqCy23wjMe0+dDb424h8EIsadBcIGqu9jpMa3/FivIMcAeI04Z+nGIvlx/znVucJveuseM21upbh3WhZU+DpnIE4xsGy5sjNK1OwphZEj976S4ri/TRnOdYFT2/9Q8s5uozU/SlWId35OYNWQ44HMTZaBbCx56U8EE82lhJeZst7x56KXNU67wDnvOuSzu/nudwUE1TcPlDN3zmajRG+vlhbtJU2u4xciE4B7DuB7UNeY3fwxDZJoDLT4sYl9y35ilk+Om0Hf3LWdMC7UuqIFUggdPoqkhVdo4YkOTOg5za1eGhmqAKNKLtp4eMDwBwF5yGrjeuCBMNfcyfVQ7qOq+QQbx6vb50/YwtKik5orr2DZ632DFEUGao+NPQ5gmcHn1tfxzihsf1MjfK8rndadrqLAux9nA==;5:wEH6HJbWmeh5aTbUHEIs/cUYzsgqZli5wUtgGCKrglWMXjgSlDvgJ1Y1yDDgrJ0Iu+OQT3LMVQhIN8Xwavfsv1voey5qgtnY1FAyYe9bfxWk4KZlApb1HKI2z8dSuCVybS1oxWFDwboawc0/A+VAjpNAtjxCZPLfMqE2tJ98AvY=;7:fiECtSyaKstRp+Frka4/5dbsz4sH/EyuqV3xYR9y1Is/xrmXjs5OOrtB+Oeo6FQYRNbKsIzpoCJ08vVG+343HzQiVEs5gEakwyi0Zi82G9HJbXWoBS+2hik7oWcZn8iup5qbe0hLYfkjD+pWR5Mw0K/ffl3VO0kFFs9vVCj938uKVxc28HrJh7yydKA0Qd1OLGleOx6VhUoAMvlpvDQl5elq/1ZYgmFStNGBLlAZLpjOngLnpgWHmWx5c9QDf84t
x-ms-office365-filtering-correlation-id: 7396a122-8bfa-457a-695c-08d62d22fffb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4184;
x-ms-traffictypediagnostic: BYAPR05MB4184:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BYAPR05MB4184512DC73B2A787FC808F5A3E60@BYAPR05MB4184.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991055);SRVR:BYAPR05MB4184;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4184;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(136003)(376002)(346002)(396003)(39840400004)(199004)(189003)(316002)(8936002)(33716001)(6436002)(107886003)(6246003)(5250100002)(6486002)(68736007)(66066001)(2906002)(5660300001)(1076002)(6916009)(6116002)(3846002)(229853002)(71190400001)(71200400001)(97736004)(106356001)(86362001)(14454004)(105586002)(7736002)(9686003)(486006)(256004)(6512007)(186003)(33896004)(305945005)(102836004)(99286004)(26005)(76176011)(2900100001)(53936002)(52116002)(54906003)(476003)(478600001)(4326008)(6506007)(11346002)(386003)(81166006)(8676002)(81156014)(25786009)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4184;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: tbk1yZBXJYn8hRCvYv4UuoYYhhscHUllX91DbLsN15KuPsDE+p6Q8ygw4jjb0PxnKYGa6VE7JFYp3MtLxU40OIBvfWi64dQhu1aJgk7k/wOZx4fi2MxQe1PTa9M4UQXBJh8Bw5N4OU1PJUP5uH6RqoZfFfqbqfvR4g0rU/roh8qxc531cq5DOntuDLg9h7gMgnNsTNVju2qW9JDLH7DmVwxz838mYxUc5uerGdvnRwQ6nq2v1uofO8OAuh7zhFRMk/uHyXuibgH/H5NxYB4+sdY87lFOFhMg1eVuAex6F+xCccz61+y+e+sxwp8mrBxAt/mwBx8GIFj4CLeRLAPPTa8qiHBEDBrGI0oIp1xXGT0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67F09B21E8F49649973CBA0E4231C41F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7396a122-8bfa-457a-695c-08d62d22fffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 13:36:08.6832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4184
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > This patch adds support for QSR1000/QSR2000 family of chipsets
> > to qtnfmac_pcie platform driver.
> >
> > QSR1000/QSR2000 (aka Topaz) is a family of 80MHz, 11ac Wave2,
> > 4x4/2x4/2x2 chips, including single and dual band devices.
> > Depending on specific chip model and firmware in use, either
> > STA or both STA and AP modes are supported.
> >
> > Patch adds Topaz support to qtnfmac_pcie driver. It is possible
> > to enable both Topaz and Pearl support in kernel configuration.
> > In that case proper platform bus will be selected on probing
> > based on chip ID.
> >
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> > Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
>=20
> [...]
>=20
> > --- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
> > +++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
> > @@ -24,6 +24,7 @@
> >  /* PCIE Device IDs */
> >
> >  #define      PCIE_DEVICE_ID_QTN_PEARL        (0x0008)
> > +#define      PCIE_DEVICE_ID_QTN_TOPAZ        (0x0008)
>=20
> Same ids for both, is this really correct?

Yes, that is correct. This is one of the reasons why we switched
to chip ID for card identification. In fact, it can be configured
in firmware, but default PCI ID values are the same for both chipsets.

Regards,
Sergey
