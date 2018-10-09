Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E6DC64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1505620858
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JoHRf1Yn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1505620858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbeJJDoD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:44:03 -0400
Received: from mail-eopbgr720087.outbound.protection.outlook.com ([40.107.72.87]:60768
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbeJJDoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 23:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bi7GQpfP9etKxjvaj0qNMKEVjVnXe1Xw2kIqtYyUQGM=;
 b=JoHRf1YnCWG4aFgZyOKRiRCxkxDv8+us0nhmAtzpH4IXoArm97c8R9DIOXugyUiacRvPksdj3rnviwiPV85POaOP2GY014i3OUnFe38i0tuoor2/rXupmHSygt11Mkx+pQ0EHWXGY6BjCEP9yqvh8c/IhvHDG0X6B+azGnleiZY=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5587.namprd05.prod.outlook.com (10.167.240.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.17; Tue, 9 Oct 2018 20:25:16 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::e4b8:995b:1c73:657a%3]) with mapi id 15.20.1228.020; Tue, 9 Oct 2018
 20:25:16 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Igor Mitsyanko <imitsyanko@quantenna.com>,
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
Thread-Index: AQHUX+jnp2KFQYnOUkemVRD5pFrmUqUXXIUA
Date:   Tue, 9 Oct 2018 20:25:16 +0000
Message-ID: <20181009202507.xs5bcaq5pi4zcps3@bars>
References: <20181009155757.494212-1-arnd@arndb.de>
In-Reply-To: <20181009155757.494212-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0602CA0024.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::34) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5587;6:pEVS9a08vEcnSaFBNcyoIHiu5FwloeQU1GxmzLhF1LD48NE0c/jDJZCZqNZZvominpWXR8HRESzW9rgQaww4GUTsXsqXPFm13a3v30AuqsoiwiMco9zm8ID/lyhVUcFM3DjCWP/QIPKu8PmKQ7NVRksaGLstYJ1a0CeaVteUmFsCBl29mV8RbJrmW14CLh3MMe+I0vEeg0t4gHN0gXvask6P29JnmGkhv5DTK+QEGfCVZZFVU6BkIsdcgEQlWU6Ye8xdT3xwx78wZIvq3/a8FV+SCkDXU7890t3CtRHcuB8o4v0+8W5Xq2CsZdg2kdRSTuostcQQA3mlvi6UglbBWsbBmgvgaCaoSMX+UO9GqNpYPFl69OmvrOLAMGqM6s/kZr81Qjn5Z5Nsqy9RERGLhp4sDcRpJg5ABtVLop/G2KEmrGJ0SuA+c1RmoFkk3EagrWmIpYHPQzTq0XWQPUqndw==;5:Qj7+LAiRQmwnLk2nBEiDKXpr5oYwuiFTXdlr9FCPjQX/nZ7eAon+/oYe5v/9k9npLIsF481u0jAmrjzlYFQcFGszdSRou7FZ0HIJe74MQPZSIXiXqTS8ccofU8QpTjNLfcH6ap9FEKlcNBk/jGtdwy6D+Jy5w7KYY3+QeaLcSGA=;7:K+ApbkcsmWra1C0vCi3NqwG7/57SC/4waX1YHPwh1ED8o1CTVs4e+xkQFt3ZUDSwzeugYcTypOQpZz6YrMIiRXx0C2FzUeQ25Y1t925KVsLw05VdU9ttIFMcBrI6VH6RPC9SQi/JDvSIkrlG0Ysw4wU35Qyyw5LUpA1GyEbH389nPnK8pyKULcCtNEHPTd/1XfHAr7Jy9Hbtc3TOhoNvc7FiYlEhmv8xyXOI7ssfKM8sa7k1FdgaD52D1dkGJEpz
x-ms-office365-filtering-correlation-id: 003d62d6-d24c-4b77-d732-08d62e25528d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5587;
x-ms-traffictypediagnostic: BL0PR05MB5587:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB5587500BBF57AACBFE5899ABA3E70@BL0PR05MB5587.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991055);SRVR:BL0PR05MB5587;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5587;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(376002)(39850400004)(396003)(136003)(366004)(51914003)(199004)(189003)(26005)(6916009)(86362001)(14444005)(256004)(71190400001)(14454004)(1076002)(5250100002)(25786009)(5660300001)(6436002)(186003)(71200400001)(6486002)(66066001)(6116002)(3846002)(33716001)(102836004)(6506007)(53936002)(229853002)(6246003)(7736002)(476003)(81166006)(54906003)(99286004)(97736004)(105586002)(2906002)(486006)(106356001)(386003)(81156014)(305945005)(52116002)(33896004)(11346002)(8936002)(446003)(9686003)(68736007)(76176011)(2900100001)(6512007)(316002)(4326008)(8676002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5587;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: HsXHvLARwRHvvAft6jLmJiCWQRgk8wTp07bQUXTsYDaRDvVhqeFim4ZaFidVUW08zT5hLJuB/c2X6ERy31vNJ1+BeNqujv3UwfZKr0ffF5mU4VyFOpNq2fq++l6jG8COaol0ZDCBwtNTK3pvi3vbfjMTIh8tytmgQv6hpS7N72SoOPCTkCz8bTyXcqh6BZYlhuydwXNS/mgk6aDat1uzfF5MNlAZFawNc+fcAvFaovsfv/rY2/nT5ePyVHVZOI/L0w9jpr6uCYOd9Eb2S8ul0jr66xu6GR0U9OtPqsABsyiQPu8EUqgg3KxaVjOwI7maaDVzFVuo4Ru9MRHRQ+de5tM+jVkTZAb9QduVXQNZT0s=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BE33C0069B6D084499AED69A69147970@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003d62d6-d24c-4b77-d732-08d62e25528d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 20:25:16.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5587
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Arnd,

> When qtnf_trans_send_cmd_with_resp() fails, we have not yet initialized
> 'resp', as pointed out by a valid gcc warning:
>=20
> drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cmd_=
send_with_reply':
> drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp' m=
ay be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
>=20
> Since 'resp_skb' is also not set here, we can skip all further
> processing and just print the warning and return the failure code.
>=20
> Fixes: c6ed298ffe09 ("qtnfmac: cleanup and unify command error handling")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch! And for reminding me that I forgot to enable
gcc warnings in CI builds in addition to sparse checks.

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
