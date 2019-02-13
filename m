Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE1FC4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 22:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CF721872
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 22:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=netorg783571.onmicrosoft.com header.i=@netorg783571.onmicrosoft.com header.b="mR+1iDoo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfBMWMD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 17:12:03 -0500
Received: from mail-eopbgr10125.outbound.protection.outlook.com ([40.107.1.125]:59568
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727190AbfBMWMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 17:12:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netorg783571.onmicrosoft.com; s=selector1-aaronpb-me;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceHR35zpamwowwWPH1IUKgvJ4zzvNkPbIPIH6oJn158=;
 b=mR+1iDooe61Y+4dg+h8VXqWKui+/MKVSrvXpYbvNcLa0+Jl7ckgfkMp3r1Pb97aIXZSwcJDS4FtFzSj5WgB+sx4cNG8h3dHv9TpVqVnNo06RU2dXM4qMyf9xV5JHLXcbtUxQVqiE3ZBXzHnzk3DmD9GtBDCtK726LmIDqREW+kQ=
Received: from VI1PR01MB3024.eurprd01.prod.exchangelabs.com (10.170.228.18) by
 VI1PR01MB5309.eurprd01.prod.exchangelabs.com (20.178.122.31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Wed, 13 Feb 2019 22:11:57 +0000
Received: from VI1PR01MB3024.eurprd01.prod.exchangelabs.com
 ([fe80::144f:2874:660a:8c04]) by VI1PR01MB3024.eurprd01.prod.exchangelabs.com
 ([fe80::144f:2874:660a:8c04%3]) with mapi id 15.20.1622.016; Wed, 13 Feb 2019
 22:11:57 +0000
From:   Aaron Blair <aaron@aaronpb.me>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
CC:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
Subject: Re: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
Thread-Topic: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
Thread-Index: AQHUwpfJXnw6ygRVkUy1zu5ei+CfR6Xds1wAgACZ04A=
Date:   Wed, 13 Feb 2019 22:11:57 +0000
Message-ID: <20190213221219.umjtvsx5aaguqgmj@datkip>
References: <20190212055731.gxy3e3uulztketbf@datkip>
 <43fcfb23-9c35-cdf4-18ea-69212612c460@broadcom.com>
In-Reply-To: <43fcfb23-9c35-cdf4-18ea-69212612c460@broadcom.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MEXPR01CA0116.ausprd01.prod.outlook.com
 (2603:10c6:200:2c::25) To VI1PR01MB3024.eurprd01.prod.exchangelabs.com
 (2603:10a6:802:8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aaron@aaronpb.me; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [123.200.156.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef2b57a0-45cd-4a66-310d-08d6920044a2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600110)(711020)(4605077)(2017052603328)(7153060)(49563074)(7193020);SRVR:VI1PR01MB5309;
x-ms-traffictypediagnostic: VI1PR01MB5309:
x-microsoft-antispam-prvs: <VI1PR01MB5309688E379146EF0C202D29CE660@VI1PR01MB5309.eurprd01.prod.exchangelabs.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(39830400003)(396003)(346002)(366004)(136003)(189003)(199004)(6246003)(106356001)(966005)(229853002)(8936002)(68736007)(476003)(508600001)(6116002)(3846002)(186003)(4326008)(6916009)(316002)(33716001)(33896004)(26005)(6486002)(74482002)(99286004)(6436002)(2906002)(6506007)(114624004)(25786009)(71200400001)(54906003)(76176011)(1076003)(486006)(52116002)(97736004)(66066001)(11346002)(6512007)(305945005)(6306002)(53936002)(99936001)(71190400001)(9686003)(102836004)(14454004)(8676002)(81156014)(446003)(256004)(81166006)(14444005)(7736002)(86362001)(4744005)(386003)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR01MB5309;H:VI1PR01MB3024.eurprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aaronpb.me does not designate
 permitted sender hosts)
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR01MB5309;23:RC5+IftERm0uR5h0jmwXllJ9Qjy3cVFO/raBRbP/8?=
 =?us-ascii?Q?jjjmI/V8E4fl0ZmbWAJRUQHUo5zNteBKOLx5OVSB25ZIN4u/omgvtm0ycQmS?=
 =?us-ascii?Q?qyBaopg31G2RVTD5cw454snGtWp2oGiAAKsNL7Z+4BUXM3zys8mdwcHbh4YJ?=
 =?us-ascii?Q?7M5crImN9Wr/EtvXIJmQdlL6XiiXHVK8J7iUUkdH5wAUwp6O9FpulTDjxu9e?=
 =?us-ascii?Q?4aklPDtsZOymZbSapZL+4BqjbGnrysAibhaTwHGVpeShCM0U/D4zfRDySttu?=
 =?us-ascii?Q?VOWRKhuYEia94tVdGHLA0lLVupzeJb38x0pLDhxRonAaic7M3i1AQO3Rt3EK?=
 =?us-ascii?Q?upBfCAWUBV3YDnUutHs3Dma+PSW/krttgC9z5QaeKzlQYnzGMaLClVCpZyJp?=
 =?us-ascii?Q?K0+B3acST46QmokMt1DHz4IfKJBgWEguSaByX0CZNhh1g1S4Q3T1ooebf27o?=
 =?us-ascii?Q?Lfr6Hg/ZFp1XHnKJ+x0pWyBA93JUIlq1ugJVhvtLsM8V96YRVfrOTdSiWm7Q?=
 =?us-ascii?Q?iyKRDlRJ6v+3g4SxTdAHECTMoYMiR2qurlm1ZWoViW/OqIsrB/Q1BJHQJNC4?=
 =?us-ascii?Q?mrOp93ix/6bcB5mDpEV2f15w9SgY/C01yVH9F5QY6l7tuJiapAWsRATq2M/0?=
 =?us-ascii?Q?ijMPRSCRQg7GxTBZuhtQc5VDrPoOioPsILSfWFuSEmwIqdgPjGMdEX28oCj7?=
 =?us-ascii?Q?24kiuie1M5xhJC4rn+zR5o0Mbq2A7TtOVDHMFfnZVNBvwOhRXhbxBTDKc/9f?=
 =?us-ascii?Q?tI4pF2lfeJTnMhJTZgg/ecQDy8w9QXaoqxtIV9vfCFaM5tcq7AfvTZoeuf+0?=
 =?us-ascii?Q?Lv57ouK/1VUV0rT5JuiEXE0tWNDjFLZWV3oHIzZxWcB7o+neyPcN8Z671B+U?=
 =?us-ascii?Q?U1IWNzaQqsWCxl1A7f/EPEAZir2wQ9Z1SLHYAa+gU+cnhxqL5ZFPvLyZxvya?=
 =?us-ascii?Q?HPGUY647EG68Z/cRLufwd17Dh012YymDhxSnuR4dBr/n0YLbtm/513nuTvQG?=
 =?us-ascii?Q?q0Zl3sHMayIBBeu/Dw4GyKu8vPXu4PdMBVAygl5AdsXHr5jxv7uC144CabIB?=
 =?us-ascii?Q?J51TXOKX7LaSHs4rH6561JrsXH93jBN+JD92k7chz/NnakPFtmqBKXsHTlkF?=
 =?us-ascii?Q?ZdOCtxyDI2Wvm0LiQrotusdDW0mmodBlSOnHOHIMZ74lvz8F0EJPJT+ia1k1?=
 =?us-ascii?Q?xazPFn3OSJXWtzLruZUMzwLohF3AOSshlb7+wb0gVDVISiGqIpXznY1t5mXZ?=
 =?us-ascii?Q?UzuBjbwcYzkZA2dmdDPMOjCMGmyDk3c6cA2UGSm9mpPw9bawnQoOrdz9WIgO?=
 =?us-ascii?Q?iiy4DDda3mMYJfkxhtnMyJhvmh61WtXv8OI1LtjbIpi3HxA2jPamGl5DkJAW?=
 =?us-ascii?Q?cVdwhNdtym4TUeo5DbRamclZ28=3D?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B0en6dkZLWtpkCnX/RFrMEECdJWhzkjooRmrGdFvE63FdEALvyTKJoqaSnLCTECDJt6yLwMG2APStEX1SeVw8RvEcvAyy26zqye+2OiZKKsZXBE3aiWuZVqg+YpzqcbxFRrGRLjfH/GmmXq24HB4uYhOVEp7uY/V3RVMU4/WVAFBbs7vpZypK8pnuqMcWxgVlRmnhvldf+4jI/f9KxbgBrqdRQTnrUwv1aVv8XbA2Kf0dZ45Ot55HdO1XgVm8cVOt6Q4Yy/Q1V9tDfv6bonkIsmPrOnXsiK2FAV+afcjMAU+fCg9KME1FG/ascbgojx+O6ys+/pGFEmL6DnNZmw0exZvNhNJC+eUg7GH2WGjgAXq+yZpJ5q2RIBM5vhNR8iDDr7bpF5wNTKXA0hapojUDjzOT9tUVWzvkdWWvacyzsY=
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ogzxzjyrewixv36b"
MIME-Version: 1.0
X-OriginatorOrg: aaronpb.me
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2b57a0-45cd-4a66-310d-08d6920044a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 22:11:53.1112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 8acfaf70-8168-4fef-8ae0-f16834eb6f43
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR01MB5309
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--ogzxzjyrewixv36b
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

19-02-13 23:01:46 Arend Van Spriel:
>[...]
>The "reserve space" issue has been reported before although I have not=20
>looking into it yet.
No worries, the only reason I included it is that it seems to appear as soo=
n as traffic starts to fail, which then prompts me to `rmmod brcmfmac`, whi=
ch triggers the oops.
>[...]
>I will look into the NULL pointer access.
Great news. Please let me know if you require me to gather any more informa=
tion.

Thank you.
--=20
- Aaron
PGP Key: 0x136159E6
https://pgp.mit.edu/pks/lookup?op=3Dget&search=3D0x0B551238136159E6

--ogzxzjyrewixv36b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElnIuPl3BRN/sHHOzC1USOBNhWeYFAlxklkAACgkQC1USOBNh
WeaBLg/9Ej0KBwludv/ivbFvosIr4igoCoA+1rl9NASB5DMFbfiQx69/ClJum8Mj
SvTTFOnoAezpG0AuRqUX9gyuJtwIWjDK42mHcCpxomywgr8STW8bEbSiTgWkmkAY
+JZAe+d10/hruajnC8BxpwgONGqS4cduOTbPtGoxt7LAMsQpd73YHXIc3cOFQI62
LgElTpMZmhiEIqBufLB2kj9A1vStcoda+lW2xZ9MWYqefj5ZkhwiXDJcWk5lXXPv
atyuo6e2w6awhY2HDphlwUZdHFINwDWLDR9sHMG33tf8HwHoXuVdFKFNXU8Ty5/8
t5KfDjzbnW/QOojXOmZ1igMiYnE89xR5V13O8k/tLFkaubAJ4/ZAc2AWo8LlPyeP
JnA5kqeKb9k3g2sYF4/GI1/tiJ9LheFgeusCS/pOU4YK7DgELFOA+F5Xl1PGGXaE
suJB7xgm0WA/t1ED9ANGD2qFcq6rRZrtRzLjumTtznTTrnkpF+WlOHk6Gvtw65XN
9i1jrxs8Sprh6HUdul9mPWcMh9HR6qUX6ZBZemvlKE3ih88OH0fboZ7OT1OLKtX+
N402MhWZOGKNeC6615j+JcYp1dmvTFkPb4VmO1xSo00xgyInppxj0JT/Jju2sO3u
K67RufXp/eHSIDWfXWXMTp8Oh48g4MjTBFFpTxjWqXVxw70Jw8M=
=/Bkt
-----END PGP SIGNATURE-----

--ogzxzjyrewixv36b--
