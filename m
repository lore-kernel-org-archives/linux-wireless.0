Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA483C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 12:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628B8217F4
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 12:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Ih7hkir6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfDKMnJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 08:43:09 -0400
Received: from mail-eopbgr820077.outbound.protection.outlook.com ([40.107.82.77]:60352
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbfDKMme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 08:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM9qe6hIGni/8pvcUZqPMxsnCti21jgUSPGAq34dFoo=;
 b=Ih7hkir65FIjFaKIx7eBdgTBvI3Z199zqIvlimpgPZxR/QTKv9kGLVSSXpM0VoI7AAS71I98dFBKHZf8/961/vSL3NUewX+ZoJwQMkD7A+xkm73iQmHJS8KWweWoqgzkfNXq2Jp/CaqSt5j9A3lLUwjc9Tbn4Pw2jC0m54gtwTg=
Received: from CY4PR0501MB3810.namprd05.prod.outlook.com (52.132.99.163) by
 CY4PR0501MB3793.namprd05.prod.outlook.com (52.132.98.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.11; Thu, 11 Apr 2019 12:42:20 +0000
Received: from CY4PR0501MB3810.namprd05.prod.outlook.com
 ([fe80::9078:df82:3f97:7d5b]) by CY4PR0501MB3810.namprd05.prod.outlook.com
 ([fe80::9078:df82:3f97:7d5b%6]) with mapi id 15.20.1792.007; Thu, 11 Apr 2019
 12:42:20 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4061.namprd05.prod.outlook.com (52.135.66.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.3; Thu, 11 Apr 2019 12:40:36 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1792.009; Thu, 11 Apr 2019
 12:40:36 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: question: crda timeout in cfg80211
Thread-Topic: question: crda timeout in cfg80211
Thread-Index: AQHU49FUZcg4gTfb8k6NNfp7UvpVxKYytK3mgAEUdID//87lgIADZ9aA
Date:   Thu, 11 Apr 2019 12:40:36 +0000
Message-ID: <20190411124030.3epjsukmgwfncz6d@bars>
References: <20190326124209.j6tdk5cz47kc6mdj@bars>
 <07e019232f1720ce70d3353ce73cd32a23e5ed2f.camel@sipsolutions.net>
 <20190409083551.g27qvcxqhfm2x4uq@bars>
 <f6b699b051cd1625da57b224e7cd1a8ac6916e72.camel@sipsolutions.net>
In-Reply-To: <f6b699b051cd1625da57b224e7cd1a8ac6916e72.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db853545-6981-489f-4d06-08d6be7ae50a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR05MB4061;
x-ms-traffictypediagnostic: SN6PR05MB4061:|CY4PR0501MB3793:
x-moderation-data: 4/11/2019 12:42:18 PM
x-microsoft-antispam-prvs: <CY4PR0501MB37933E467C986FF3EA617ACCA32F0@CY4PR0501MB3793.namprd05.prod.outlook.com>
x-forefront-prvs: 00046D390F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(366004)(136003)(39850400004)(396003)(346002)(199004)(189003)(316002)(54906003)(6506007)(386003)(2906002)(478600001)(99286004)(66066001)(6512007)(14454004)(8676002)(8936002)(6436002)(106356001)(7736002)(71190400001)(4326008)(6116002)(6486002)(33716001)(81156014)(68736007)(25786009)(305945005)(105586002)(9686003)(81166006)(71200400001)(97736004)(436003)(107886003)(446003)(11346002)(102836004)(52116002)(186003)(3846002)(256004)(486006)(229853002)(6916009)(476003)(1076003)(86362001)(93886005)(26005)(53936002)(5660300002)(76176011)(14444005)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0501MB3793;H:CY4PR0501MB3810.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7uJOjz1/9f2KoiePEBS2FL/k5qnnaZFR2qrooehRt7p3i3iufMKLDKzuAh8uUBYhQlp+BWhPCDmbfgoXDNgjCHhF6fGYJjVEWlhOg8CynHA371PbUNUL5eeETDuskxueqvumG1jT8rqZ9/VtlqireLCVsItRS+jES8l8uWyPJa4tGGFo3nCH1sXt3RlViX2uPrNT9hJBnCB8HYppE8+lH/BltgVAXHEqxGNxESkE332sOYLsillcli9w4arsbi+Wk9wtDfLMNS5LjImjgUCu+U+sYyMYvuzSOaDgFvv45YgVC57e2TO9NsE6HU8AZRU6vVK3kegcUKiQEh7TcbVuGn8zHVRvRv1M9nHp5mjKjcpbtEYtDNb0iNTdF1b0TVkmvjAFLT/RgZGmVJx4LYYE+/JXhB2IzoD3EMOxIP4YtnQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38C17A048EA34246A4CB383E6227AD27@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db853545-6981-489f-4d06-08d6be7ae50a
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2019 12:42:20.1275
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3793
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > Indeed, it is PI. I should have known. But instead I spent some time
> > digging through 802.11 specs :)
>=20
> Oops :)
>=20
> > Well, as I mentioned in my question, regulatory update/reset operations
> > shall be completed in ~pi seconds for _all_ the wireless cards in the
> > system. In our case, regulatory reset operation may be fairly costly.
> > As a result, we end up with recurring reset timeout, when more than one
> > qtn card is installed in a single pcie host. One option for us is to
> > optimize regulatory reset operations in firmware.
> >
> > But what do you think about converting crda_timeout into a per-wiphy
> > timeout in the case when all wiphy-s are being processed, e.g.
> > in update_all_wiphy_regulatory.
>=20
> Maybe we should parallelize it? But I don't know how easy that would be.
>=20
> I'm a little worried just making it longer will cause users to really be
> wondering what's going on?

Hello Johannes,

Calling regulatory notifiers in parallel sounds like a good idea.
But I haven't yet looked into the details as well. Before fixing
the timeout issue, I was trying to figure out why that regulatory
reset was needed at all.

Here is a simple usecase: Linux distro sets regulatory region to US,
STA is connected to AP. Any STA disconnect (including an attempt to
reconnect to another AP) leads to regulatory reset cycle: US -> 00 -> US.
This reset cycle is not supposed to be done for the wireless cards that
specify REGULATORY_COUNTRY_IE_IGNORE flag. However regulatory reset will
be applied anyway if at least one card in the system does not specify
that flag.

Hence two questions:
Do we really need this kind of reset when we remain
in the same regulatory domain ?=20

Does it make sense to track when restore_regulatory_settings performs
reset, and to skip reset for the cards that specify
REGULATORY_COUNTRY_IE_IGNORE ?

Regards,
Sergey
