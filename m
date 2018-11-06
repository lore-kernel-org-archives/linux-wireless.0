Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34642C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD06A2083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="i146Dh+o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD06A2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbeKFUKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 15:10:31 -0500
Received: from mail-eopbgr710061.outbound.protection.outlook.com ([40.107.71.61]:39418
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387404AbeKFUKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 15:10:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOipvn4BJo9rxl1dTCiXLrUJsfif10EGwz4AbQ019Ew=;
 b=i146Dh+oEPVgWm3e2Ub6yaDeTFzLLtJnAcExXxhXwbEX4A0c6W/Et0Y83TCqFgddCcmwFQG20CGWVJoPPoBPgqYWYvPvMutAcIaNzgQkZ8zkbFlV/vFuLlfSuKFzs/NNp6gYjitR00HUUPFs4x98ZIQ53x+Gp4xy+BiUDsAPiTo=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5441.namprd05.prod.outlook.com (10.167.235.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.14; Tue, 6 Nov 2018 10:45:53 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 10:45:53 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Tamizh chelvam <tamizhr@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Topic: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Index: AQHUajCNfhztlx3c70SkOeCvblyRP6VBvB8AgADrQIA=
Date:   Tue, 6 Nov 2018 10:45:53 +0000
Message-ID: <20181106104547.5mnbymn4peuhgng3@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <b833d8c0987e838759dbf00d97d4989a267a10fb.camel@sipsolutions.net>
In-Reply-To: <b833d8c0987e838759dbf00d97d4989a267a10fb.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0202CA0010.eurprd02.prod.outlook.com
 (2603:10a6:203:69::20) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5441;6:f8kUfO8BZ84D4buP7D4ubGaBJVic8/yFmXTo799b9W1cgYe1NDJzQhOV2F8mbpuCjEQp2ifaYskgc0vh7xnwEjM+oEMcnUd274g67zHaGALJcuAtYSIri+nWbmW29ywJhAk4EsSKzcT5VZDBQMdfsvXGa7dnqJXNVykOgVQWkNYxmE1h7Yws1bgL5t2Z+j3L2rVf1SimGKC/WeX8rgHm02CKgwuPAW1xpFc+7hZjUCwND6D7Yi4gs0rDYu8Arm6mFxFesOR3pxuyEkwaBsaz22NZ8cLOemEt3sVvZMgfCUtJagoLQMbqEk8/uP8xU9aImgQOEcW0rr5crQVvzHhcV8mvlGWEARQ70GsTOhAb8CwZQmu4r/8EFUa3I1iSSomrvdwo8bOfKFn87ecL5Bc/c8BhH0oGI9j+Zvl2oVlqwxCGWmVT0/hSIFpkoKXc00u5Wr9ML30Bg5uJvqsXf3RzHA==;5:RT75yV0hGGo5jy3SSc5IAK7aUifK5VwseYU+h9cKZ7KTnfE96Kq8Gy+SL4m5j03aB1Gahxm/0ZvWSxkw4HkQTg8PLLxsO9CmdpXB0cl9OqQSIRsSU9HzPG+Vp+VNpL7P4bk7zIDYQa/GLpjS18xXLuU4dGsZFsLUmJCeZsCz+wI=;7:Xj9B7Kj5GJqCYk4xu7WyFZ+yeTrorma6j0NhFbYyDfykYOoRHFqSeheafPfr2NiXzpQPYvZcL9l9bnOkRAGpnUZclDrjkek8MfO3WviqVJb3Q1WigliOLVm32HXSDYx9ljOSU3LbWGOsnGx1pK74+w==
x-ms-office365-filtering-correlation-id: a88e52d6-e961-4be3-472b-08d643d5065b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5441;
x-ms-traffictypediagnostic: BL0PR05MB5441:
x-microsoft-antispam-prvs: <BL0PR05MB5441C9DAA47DF08E736DA9D2A3CB0@BL0PR05MB5441.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5441;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5441;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(346002)(376002)(39850400004)(366004)(136003)(189003)(199004)(2906002)(26005)(102836004)(386003)(6506007)(5660300001)(316002)(478600001)(33716001)(99286004)(25786009)(52116002)(66066001)(76176011)(33896004)(105586002)(106356001)(256004)(186003)(71200400001)(476003)(11346002)(446003)(54906003)(486006)(14454004)(71190400001)(2900100001)(6436002)(6486002)(6512007)(9686003)(53936002)(81156014)(8936002)(6246003)(68736007)(81166006)(8676002)(4001150100001)(3846002)(1076002)(6116002)(7736002)(4326008)(305945005)(97736004)(6916009)(229853002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5441;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ChBNGCN0nO9cCvKCiMNR5O5ohNcRgQuBWnjhjdFfbU6xh8GVE9L/wgPY1zgEtYGbABe5TxNlFz0wPIVRmrIhorHof7yZESJePk9n3Z4Jjb8Rl4kpYLNbAtQngUpBOUL9ewtO6FeBOgVFi3l5t3JFnFSdGgUqXJGFDFOTrR1isPVmSMLTAKmq3gyaOxsAu+SFewK7jPw/VMgMD4xzrtxVoaLKjTvWBx3mIU5Q73HiFl/ELPSOypWepHI1BVNpqXwi0CYvtbhsMuGN9jYuTDkrJ50LdGhMTMjVBTCU2BBvUVxB7pKqY0qLKtKBr+nl0BelIl+iePo4HwOxmpj974QpE90cNYIjOASvotYGwx1E9LE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BBCEC7EFDE58F40AE39EAAFAFA0B3B8@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88e52d6-e961-4be3-472b-08d643d5065b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 10:45:53.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5441
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Mon, 2018-10-22 at 23:25 +0530, Tamizh chelvam wrote:
> > Add infrastructure for per TID aggregation/retry count configurations
> > such as retry count and AMPDU aggregation control(disable/enable).
> > In some scenario reducing the number of retry count for a specific data
> > traffic can reduce the latency by proceeding with the next packet
> > instead of retrying the same packet more time. This will be useful
> > where the next packet can resume the operation without an issue.
>=20
> Not sure I understand this, how can you expect to control something on a
> per-packet basis using this?
>=20
> Sergey, looks like your A-MPDU control is already in here per RA/TID,
> and A-MSDU could be added easily?

Hello Johannes,

Thanks for pointing me at this patch series. Indeed, it looks like an
exact match for proper RA/TID aware implementation of AMPDU control.
AMSDU can be added following the same approach.

Regards,
Sergey
