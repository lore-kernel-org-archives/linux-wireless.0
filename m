Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD19C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31D220861
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 10:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="1LNFFrkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfAWKn1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:43:27 -0500
Received: from mail-eopbgr790042.outbound.protection.outlook.com ([40.107.79.42]:29739
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbfAWKn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 05:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkTcje2AuCBJcEY0IUe6mP4i4x6QaO/F1CNoqYF5n7k=;
 b=1LNFFrkHIBS5oVz46B8XGxY88oDRtYPuJuGjKohMXJ4cDAhSKJshwQ0YcaXvfSfTOQVnkTU8UFOmXkyDdmQHssLci2Ivi8ppPP30j/i4TMIIAcExoF/VsTx+FAsvCGdOkS4ScQjtI8HPSzqGVudRJgRFNqPW9IRWvWy9C0czXn8=
Received: from CY4PR0501MB3810.namprd05.prod.outlook.com (52.132.99.163) by
 CY4PR0501MB3809.namprd05.prod.outlook.com (52.132.98.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.10; Wed, 23 Jan 2019 10:43:10 +0000
Received: from CY4PR0501MB3810.namprd05.prod.outlook.com
 ([fe80::593:975a:57d0:3aed]) by CY4PR0501MB3810.namprd05.prod.outlook.com
 ([fe80::593:975a:57d0:3aed%4]) with mapi id 15.20.1558.016; Wed, 23 Jan 2019
 10:43:10 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4686.namprd05.prod.outlook.com (52.135.114.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.14; Wed, 23 Jan 2019 10:42:58 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1558.016; Wed, 23 Jan 2019
 10:42:58 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] quantenna: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH] quantenna: no need to check return value of
 debugfs_create functions
Thread-Index: AQHUsmatnrp0f5JDRUupfvH3Mcca4qW8q/uA
Date:   Wed, 23 Jan 2019 10:42:58 +0000
Message-ID: <20190123104251.yqzq2zutofia5kyn@bars>
References: <20190122152151.16139-36-gregkh@linuxfoundation.org>
In-Reply-To: <20190122152151.16139-36-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:40::19) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;CY4PR0501MB3809;6:VRBTdNjJjiAL6dCqausqiA65hIg0YJgFVi1wdS86y/x5tNwOI+oH77GAReO+lGFrkMoM+MTn30hHyJVaFQUvu38GT5wFJ3KVDGh7wncKdY7S6oQ6jZAgxug12UehlGLC3TQkkRf6fPkUVLUnpMAoEvMcV2Bf44/kJFhN7O4sL4CCs5K5IOs3kL1N44tnrLEawwUnwA8h+rGBEv4VOMuRgF26wIGwF5iGOGu3bW75ChjM58b0stPxGXIsnxuWK57eJ/IAiElkdsiDL5jdV/QO2yz78B2a45zQMd9SxIwraja4Q3NBCKsuJVmpiMMTBpGBKXfDd8H/sOfJmOs4KnUe9RWaLJysW8CIh4TvKS4cLEF/ZaJ+iWQRUCZgQdIiArp0HdfMZMol2QKpi5k7xOijpK1H8grzeXLfKdw9YFfrx7l9/aC+wYXqJ44ClrE7fINE0iKNZrJPpGbBGslP9WoMLw==;5:/N60u739MZ3XTwAXcZaVhbQWozTwvI3Q1XMTtHSWOat32+nCDAkg3m5nf4T6cLdo0tT5lSAt5SwgS4fwk6rKjCKya9fdmelNnFwnHAdWlKpz0XlZV/w/wco9v83bHJUu6alvJvrhK1vPLC7wBMDzz7xVSXGlwbteSnHH03cSch/EzoFuDsiT+neuN+mKADDz9wV2LZOAspj7eGP9QrMUGw==;7:AsfyHsXP4/gezXvS/uz+gPnF4vNlxCmEJSQK47Qt8pKiOuciOtTUB47fYDuerEwuSm248PxWStuomEGzF+rKoXH+wCeDrzJuKzjhcokeLpDRGc6EmwA4Dk4oc1+b2pK4Ib7N9vZo3h0mfF77+K4ilA==
x-ms-office365-filtering-correlation-id: b32ce88b-bffc-4b24-5efc-08d6811f8a0e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4686;
x-ms-traffictypediagnostic: SN6PR05MB4686:|CY4PR0501MB3809:
x-moderation-data: 1/23/2019 10:43:08 AM
x-microsoft-antispam-prvs: <CY4PR0501MB380906936EBFB4D51AE7F73DA3990@CY4PR0501MB3809.namprd05.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(376002)(396003)(346002)(39840400004)(366004)(199004)(189003)(14454004)(66066001)(229853002)(6506007)(8676002)(71200400001)(386003)(436003)(478600001)(6916009)(8936002)(81166006)(186003)(26005)(81156014)(2906002)(6512007)(68736007)(9686003)(71190400001)(305945005)(33716001)(7736002)(76176011)(52116002)(53936002)(97736004)(25786009)(256004)(1076003)(6246003)(6486002)(476003)(105586002)(106356001)(486006)(33896004)(11346002)(4326008)(86362001)(316002)(54906003)(4744005)(6436002)(102836004)(99286004)(6116002)(3846002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0501MB3809;H:CY4PR0501MB3810.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3Zj8It/BzZZkrb0sgk0nYTfVcKuAW96Kv+CnhkXbK9GT6E72CBvzmqlxfr0J8VmRdddHWswhtxt6OsoFBD905Pr56u4f+gjBmMqLaM63L3eUtNm2gfHSM4rmHRamUoB8veJgtmaOu6xsufgN4tI+63uXtO+NVBCBYHXoZmr3bpxuk426WRDHUbvAyH3hvVnQ18EjnG8sDZtnGbEGSLLhzV08F5axXP7CanIAOzW9/JBgPZV93XJI+XObR/UcEl/6QhPw266h78uBrCDp8yAw+z3FifPAKisuD9rhv2l9rgiDL2yxf43FU02LcUvozfdAUI2WwFNoVId807YRUqyCIqTMtg8PYKNY7cb0foPZCeblL8VDHfuj9/v8EPd+/vd08EDtRO9pUbUFWZ2M3Q+HS6SvL/mfkWw8OcGfl5ySfPk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <48181188C185BB43AB6C00F2EE829123@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32ce88b-bffc-4b24-5efc-08d6811f8a0e
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 10:43:10.1480
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3809
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
>=20
> Cc: Igor Mitsyanko <imitsyanko@quantenna.com>
> Cc: Avinash Patil <avinashp@quantenna.com>
> Cc: Sergey Matyukevich <smatyukevich@quantenna.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/debug.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
