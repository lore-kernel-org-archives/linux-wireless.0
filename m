Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547A7C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D75222D1
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 19:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="Cmq5Nofs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbfBMTD2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 14:03:28 -0500
Received: from mail-eopbgr740071.outbound.protection.outlook.com ([40.107.74.71]:7632
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfBMTD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 14:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5fv2qFiYf9VbwLLuOR6KD1mwtuy2eL8wd9m9pPdmwY=;
 b=Cmq5NofsCtR3ltdQcYucfupcQCaDYDPZon5V+6umDwYi3rgp09k8L7X8p804oQHiB50VXczJzr1AYLEijiePyqV26fhzKo8Xktmx4JgFzLhGqQFl9CY820FxJoJQMLhMnJinLNBeD+fEpGadQdn7WAlryJwpwUzcJq6FHDrS8As=
Received: from MWHPR0501MB3817.namprd05.prod.outlook.com (10.167.163.165) by
 MWHPR0501MB3786.namprd05.prod.outlook.com (10.167.163.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.7; Wed, 13 Feb 2019 19:02:56 +0000
Received: from MWHPR0501MB3817.namprd05.prod.outlook.com
 ([fe80::c020:291b:4f81:1dcc]) by MWHPR0501MB3817.namprd05.prod.outlook.com
 ([fe80::c020:291b:4f81:1dcc%3]) with mapi id 15.20.1622.016; Wed, 13 Feb 2019
 19:02:56 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5390.namprd05.prod.outlook.com (52.135.111.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.11; Wed, 13 Feb 2019 19:01:37 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620%4]) with mapi id 15.20.1622.016; Wed, 13 Feb 2019
 19:01:37 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Topic: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Index: AQHUajCNfhztlx3c70SkOeCvblyRP6XeyLQA
Date:   Wed, 13 Feb 2019 19:01:37 +0000
Message-ID: <20190213190135.lp3sg3u3b4mmve7l@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:40::14) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a0a0030-56e4-4074-1ffd-08d691e5ae23
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5390;
x-ms-traffictypediagnostic: SN6PR05MB5390:|MWHPR0501MB3786:
x-moderation-data: 2/13/2019 7:02:54 PM
x-microsoft-antispam-prvs: <MWHPR0501MB37868CA4DE8728E0FFB89A30A3660@MWHPR0501MB3786.namprd05.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39840400004)(136003)(346002)(376002)(396003)(366004)(199004)(189003)(4326008)(256004)(386003)(26005)(102836004)(105586002)(106356001)(14454004)(186003)(33896004)(6506007)(86362001)(6246003)(33716001)(25786009)(2906002)(316002)(53936002)(54906003)(6512007)(1076003)(9686003)(8936002)(446003)(7736002)(476003)(305945005)(229853002)(11346002)(478600001)(52116002)(6916009)(66066001)(8676002)(436003)(81166006)(81156014)(6486002)(6436002)(76176011)(97736004)(71200400001)(71190400001)(3846002)(6116002)(68736007)(486006)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3786;H:MWHPR0501MB3817.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;MWHPR0501MB3786;23:HBsfZKORe9/EgYHE+9MZmamgLDVsk0Xj0QedWO0?=
 =?us-ascii?Q?KpkIbjIB9I/ZZQu5pxFwMkUFo3x+Y820Sp9pYHbq6hZxxdNPlB7MoZGxg/0/?=
 =?us-ascii?Q?fEdk2HCKecSNBEaAEulzBkYrVO9/+jEEzOd1sblFzq+RK+hEcxVBk7wrD9NR?=
 =?us-ascii?Q?ElcLIJC+trIdRu0rkHFEYnNDeHdXTCNGM8ID7sPClBM4Q5RIsunpzMslmzv6?=
 =?us-ascii?Q?e5EMlP51nsxUb3StXlLybnhvw0/5mhObM6TX+4OXNuWsHaPcc+cyslnabSPT?=
 =?us-ascii?Q?Van22zXjXb9BR0S1zMPI1idNHiAW5qaFqQFxoWpKeLSJVBgwKqpLVx34+w/m?=
 =?us-ascii?Q?dmo6/MJu9AwGpviJpM7boSh8ZgROHp+43wqBUY35hnXZE0WPofIpvWGCIJNm?=
 =?us-ascii?Q?FTaSgmlQksTAVVfRqdGpD7bx9BD/DgLBYZMxnNh3BL2KC4PR1AVSsGIGP2ga?=
 =?us-ascii?Q?4fKNGWeHwZ3jgijvInmhqCuq4QL7rD8eue8mNctPuMoDSE7jssEUbjjSEyos?=
 =?us-ascii?Q?Ih1Z3nwtmI9eowwRApmABBvK6x8GKU/0sbnOlMfWspkygTzc/+fV6EbU7The?=
 =?us-ascii?Q?QvQ/b90/kByiSBACFrgotC883buFeB/MUX2HTXc5uNBiZKJzrODRXOMnSoEB?=
 =?us-ascii?Q?UbOU7hmWeQZhXWn/QtNDSLyn88gMmTUGsFsyHtGBvfzz0K5D6ySlt+g60yxv?=
 =?us-ascii?Q?qenphGrIRisT3PnIl13YA/1Pmq5/ZRpGr5vOXWva8Z1boVlE8K2zgEbU+1lw?=
 =?us-ascii?Q?3jELrZIQs/ey9p8Xv+3VL2O4/fJfC2P7+jaPG2MrPL9VQ+PoDMaJgr0dpJMh?=
 =?us-ascii?Q?6Af2mVFXQZs7Oq4z0IOipxp9ev2aUdXTe0J9LZej9D3iBQDdlmi7gQSpYmcr?=
 =?us-ascii?Q?SfG4DrtF6tECxkEkQ0FSqDkAf9yQsarEAkW0guwt4/BlEZWbdNi8JRPF2uA9?=
 =?us-ascii?Q?KGeiwrdmbSQoOhC8iEdBXGUKmrA7xFb6NhFaDQKKeyfYv5o83llC8OPOsNiR?=
 =?us-ascii?Q?nZWON+jdB2n5ozNWr3Asz+jtlx2H6GbzOvqQ/iDg3/CTWot6L4hBTM4I+lJs?=
 =?us-ascii?Q?Hm3Q9W53N2/874bfD7i/DafFfPFTrFUhFF70XONXVRf8SwiwrTUgdBCUDBLm?=
 =?us-ascii?Q?diipG5jgXAhG0XdzsJ4MY0chOUVDNOQAq3/5a6f+k6xQPmYxKJP8D5398dTy?=
 =?us-ascii?Q?TZHWgdfdVS82JvfOy8XgAw0hy0zIntovwKYyeojRaSF4iCfz55EfXBLKqCUs?=
 =?us-ascii?Q?Cm8TDV5KJ2ck7REerMj8=3D?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qvj1i5kZKjs07ithk/c2Fs7UuN8FIAHNahIEVY0oWqitFBvPuuaT91pse/tWvqp75UzQjSm4wCMdOzSAErWYxGQuMi9znqTi0M2WEQI318PvCuyzb0LQh5vuIuOL9tGNNfOmAmaOu/PC87oIuhbIequkkFWwTzdFhyu5UhKmrQw+/dTeO82loqOPO7DM7vyyHHqqStU4K8F3pTKxxzIR5OPtdhLJuJTeUNPYRDBAyqOfJ3BIr/vPcBv2Q1HhYqR0Kpl5OQQfuijmPXVy/xNnbPANyaPkTtjrrsd8ycAOdYbpazgT2BrCKTQkh+mQWRWGlDMr3ARH1ZCrwup634RT8oyUcuyoagKTZiIXYO+BE2Y8OfwyT1lj4xuWdc4nSG6jOG1FyslkuadzE+UJHntaX3xmrHkIaExBnW3guZyZcIQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F55AE922EAA0C4EBE12CA6A61A77011@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0a0030-56e4-4074-1ffd-08d691e5ae23
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 19:02:56.3708
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3786
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

> Add infrastructure for per TID aggregation/retry count configurations
> such as retry count and AMPDU aggregation control(disable/enable).
> In some scenario reducing the number of retry count for a specific data
> traffic can reduce the latency by proceeding with the next packet
> instead of retrying the same packet more time. This will be useful
> where the next packet can resume the operation without an issue.
> Here added NL80211_CMD_SET_TID_CONFIG to support this operation by
> accepting retry count and AMPDU aggregation control.
> This command can accept STA mac addreess to make the configuration
> station specific rather than applying to all the connected stations
> to the netdev.
>=20
> Tamizh chelvam (3):
>   nl80211: Add netlink attribute for AMPDU aggregation enable/disable
>   tid conf 3
>   ath10k: Add support to configure TID specific configuration
>=20
> Vasanthakumar Thiagarajan (1):
>   New netlink command for TID specific configuration

Could you please share your further plans regarding this patch series ?
Do you plan to send next revision in the forseable future ?
Or have you decided to abandon this approach ?

Regards,
Sergey
