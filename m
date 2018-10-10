Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2ADC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15ED2087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 14:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="A8wH+vZK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E15ED2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeJJVlh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 17:41:37 -0400
Received: from mail-eopbgr710055.outbound.protection.outlook.com ([40.107.71.55]:64065
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbeJJVlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 17:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJcP/6PFV8ur7sI6fZGWKtlWHCp0wux9yzMjLOVf6fQ=;
 b=A8wH+vZKgy0iR0ylqTdh4/5j68gC/RrghmjBlRCSzcRRl3CRTJq9vFDbdYPMrADNC0nhtIBDkIt4J/30dOfIBqbLxx0/ZcErE0ZHvC5Uaw6oi16/Epwjus5mpRAFIlRQ2RCXE9tx6q3uBAKI/vk2xWEU99s3X0NE5iZt0ky6c60=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4851.namprd05.prod.outlook.com (52.132.15.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.20; Wed, 10 Oct 2018 14:19:11 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Wed, 10 Oct 2018
 14:19:11 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [bug report] qtnfmac: cleanup and unify command error handling
Thread-Topic: [bug report] qtnfmac: cleanup and unify command error handling
Thread-Index: AQHUYIWez65qmsmG+0eN6mJDhh9N66UYh1uA
Date:   Wed, 10 Oct 2018 14:19:11 +0000
Message-ID: <20181010141904.kplmwifqimdb5fc5@bars>
References: <20181010103952.GA14986@mwanda>
In-Reply-To: <20181010103952.GA14986@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0017.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::27) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4851;6:SiR5yCebWytLkT8+fP138VtE7CiJWXXbBBN3mHiDC+/4GUcwqeAEtqJbKfuVVUlpDZ5Pr2iFBzfP809BRg8cQyiBIWyY6vBRnmbQ1mU8c99ELvkU8+3Ieitjl17GlVk3ZKfJKChJcJM/c7Irv1H5w1jeRybzr9RqdRWtAVQ7/bu2ThBZVvRDHHepMYOuL3Rs1gbqxg6P0nKp7x7b2Zv/+t0tNT/1ScQOvQ1xB6vtD6fPoxdbU0tGgBXbfr0EMtioaM8/r/RXPax0IksNN7YrgNeLOlzOpyOoKivnFtngVE4N2HoMIUxBCRCEfi22e8SwQVR5NceU7KwnmPPk1UFhZ6A3Pq6tlshnuCOH++cF1M96txBu0ZXYc0on32hq7HY3NGen8tLjjZoOFB2He8laliALqGJbr+8XOefkmwdQPFb3uq3hdyDkyN/4GSiCw1X0WCHVvjuid7S6kLHQYIFZrg==;5:FK3kgp9fsyjM7TOnXS3gErthGQeGROHKuNv6LtG766o4SsMNggPYzj2ATo95JqAwXqpdQ2KD3WwXJidX4Aax4b7sidVnXlV/b4ptLi5Xt6D3SomHhX5c7jtuu9mtPjFmXA2o52yIN0enGaYikTASTNWDY9W198oNmh/KYctkYsI=;7:ddgdXtlZZx7Nnj/ykZ8jcNVuhVxUfRHwgb0aJyKEFm+2E1TnKg9OO1wyTt/o/0P7IjjdLMtB75nBb4OF2QJuotRedaSfe80vRA5qnTQl1MzMRlqtwPw570fK1aRHukQIbSATDHMrKakrs+8DKTNKYEP3BvOw3XtaSjdvga7cvDqwZNfxXCPVnI9+kWCds5JZhSi8Hf+POdExAw/inM1ElLbLlzLQs+5K0JLFtFmhrie2YeCKy/LcPjkGPynrNgR2
x-ms-office365-filtering-correlation-id: 0efa5256-c7f6-4e44-735f-08d62ebb5919
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4851;
x-ms-traffictypediagnostic: BL0PR05MB4851:
x-microsoft-antispam-prvs: <BL0PR05MB4851A29CF9DE1E4DA5ED31D3A3E00@BL0PR05MB4851.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231355)(944501410)(52105095)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123558120)(201708071742011)(7699051);SRVR:BL0PR05MB4851;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4851;
x-forefront-prvs: 08213D42D3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(366004)(39850400004)(136003)(376002)(346002)(189003)(199004)(51914003)(26005)(99286004)(476003)(2900100001)(1076002)(486006)(186003)(6486002)(52116002)(53936002)(6116002)(3846002)(6512007)(6436002)(229853002)(86362001)(105586002)(256004)(14444005)(6246003)(9686003)(2906002)(478600001)(5660300001)(25786009)(5250100002)(66066001)(316002)(81166006)(81156014)(102836004)(14454004)(8936002)(33716001)(6506007)(8676002)(386003)(33896004)(76176011)(68736007)(305945005)(446003)(11346002)(71200400001)(4326008)(106356001)(7736002)(71190400001)(97736004)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4851;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CVDZSu6l0HUNYhM4dM4v78yvUg8tsv+R1WBwjkgYDUpRLNnc2tOqW87I0vQw+f/3uVSmwro4hU75TiJjw5FQ9AtOrLHcLYErEuSLbFdMfm20bohSrjXhhWoL4QsC4+EP4Cwpxu3QeSj3GRGYgexm4D89Y24ic7r1m8YdVRsLeHzMXsnPO4urRN91yvaanLcDjFGUAhOfwU+HJ7nEacyvZqqiV24sSkofWhCzcY3XojE6MDxmJ95+ryBFh9JOCBQYMMa+33f1cl0Xx89RQO8YsayyAEKSMEEt9E/jinzoKvq6d/DN2yQNxjM3sJuSrtH6Bv0Vgc+6RWjNIJ6Nylfhc9iZYFZWBrzVDHaaMgtbcWU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <068A704B0837B342B2E98527FC5B6630@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efa5256-c7f6-4e44-735f-08d62ebb5919
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2018 14:19:11.3262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4851
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Dan,

> The patch c6ed298ffe09: "qtnfmac: cleanup and unify command error
> handling" from Oct 5, 2018, leads to the following static checker
> warning:
>=20
>         drivers/net/wireless/quantenna/qtnfmac/commands.c:132 qtnf_cmd_se=
nd_with_reply()
>         warn: variable dereferenced before check 'resp' (see line 117)

Thanks for the report! We will queue a fix into the next patch set.

Regards,
Sergey
