Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06162C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 12:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCBA2075D
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 12:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="XqmJ5w71"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbfCZMnQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:43:16 -0400
Received: from mail-eopbgr820052.outbound.protection.outlook.com ([40.107.82.52]:61024
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726241AbfCZMnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 08:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uw1JQNLXciSthViCj0xl4bbnVEcJXl+hgqKtq9ZR51Q=;
 b=XqmJ5w71IfF7rCch1Mz1mNLWecvNusHdFccDuPexyA622aE4x+ZryilYCe/8T5zvYj+wU8Qq7mMPTZzbWT1ZK7ub5BFRjm/1OlVp3QtkBtYhdrNUaWQGcfhRIlFgRHvEE/ksd1HG14CeMxxewqoLeSk+3J9cR4CNNWIsPovOTEI=
Received: from BYAPR05MB4039.namprd05.prod.outlook.com (52.135.199.27) by
 BYAPR05MB4792.namprd05.prod.outlook.com (52.135.235.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Tue, 26 Mar 2019 12:43:13 +0000
Received: from BYAPR05MB4039.namprd05.prod.outlook.com
 ([fe80::1957:3d75:4e97:7d3c]) by BYAPR05MB4039.namprd05.prod.outlook.com
 ([fe80::1957:3d75:4e97:7d3c%4]) with mapi id 15.20.1750.014; Tue, 26 Mar 2019
 12:43:13 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB6750.namprd05.prod.outlook.com (52.135.112.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.14; Tue, 26 Mar 2019 12:42:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1750.014; Tue, 26 Mar 2019
 12:42:15 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: question: crda timeout in cfg80211
Thread-Topic: question: crda timeout in cfg80211
Thread-Index: AQHU49FXR0CTE3RHB0aq9jc7wfrsmA==
Date:   Tue, 26 Mar 2019 12:42:15 +0000
Message-ID: <20190326124209.j6tdk5cz47kc6mdj@bars>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To SN6PR05MB4928.namprd05.prod.outlook.com (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507b36fd-5de5-4999-80ce-08d6b1e87976
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB6750;
x-ms-traffictypediagnostic: SN6PR05MB6750:|BYAPR05MB4792:
x-moderation-data: 3/26/2019 12:43:11 PM
x-microsoft-antispam-prvs: <BYAPR05MB47927B21F54510940485F61AA35F0@BYAPR05MB4792.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(366004)(376002)(136003)(39850400004)(346002)(53754006)(199004)(189003)(97736004)(8676002)(68736007)(71200400001)(6436002)(9686003)(5640700003)(99286004)(81166006)(66066001)(33716001)(8936002)(478600001)(6512007)(6116002)(4744005)(3846002)(81156014)(7736002)(6486002)(25786009)(2501003)(2906002)(186003)(486006)(5660300002)(6916009)(256004)(386003)(102836004)(305945005)(107886003)(2351001)(26005)(14454004)(476003)(1076003)(71190400001)(6506007)(52116002)(105586002)(4326008)(14444005)(53936002)(86362001)(316002)(106356001)(436003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4792;H:BYAPR05MB4039.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C0XDr3dbj1DBIRaGdLH+EXeARo/dKJBboNj7yVH9OdIv8RG5VicnEVWuXhnpgPf7W0vBTEHsA/IZKGZP9OFnCXpX+iQimy7arzriQu3IQQ0NwMKJphWS3LhYGSjEoUethxR4/8v9N6wZQrlGTgo/HS9+qpSG4PAdf1WNzcyiri5W6mqsuFw4WWunMYZXqEUF0E9pJjxNo+zoaXudRpIOhWx/P7YA+rVxrH29RRAL2aiBDKGkevpkuGpJf32mzjn+bY5h4dmieVDBNXszXlRdZZBIeHOc90sHTT3friceESOe+BvPUdA7zTaKThjt+fJ9q5hVFpUjkkxgZOr50LhkT0hnZRIU+GsoJyb2JPVTzldDrOw87myHgS/Ra4IADwNf3SOCqxxIj36P+YMFJrE9qtSs+JG+ylI3C6Zs9RyPOaU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1BF3B50A15A3134795D0C90D1FD11D6D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507b36fd-5de5-4999-80ce-08d6b1e87976
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 12:43:13.4869
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4792
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

Linux cfg80211 regulatory subsystem uses CRDA timeout to ensure completion
of regulatory updates, performed by user-space software. See call_crda
functon in net/wireless/reg.c:

static int call_crda(const char *alpha2)
{
	...

	queue_delayed_work(system_power_efficient_wq,
			&crda_timeout, msecs_to_jiffies(3142));
	return 0;
}

So regulatory update/reset operations shall be completed in 3142 msec.
And that includes processing of regulatory notifiers for all the
wireless cards in the system.

It is not quite clear where this specific timeout value came from.
Original commit (a90c7a313a1c5b) doesn't go into details about it.

Any ideas where it could come from ?

Regards,
Sergey
