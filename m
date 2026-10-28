Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793181099;
	b=cExLPfPI2X+YBUIXij8ywaAcmFhfr/u177eFn0w+GqYh26azhgoLSRT6BPqJwlsJ+OSG
	 ZcLi1lmF1mYGxVFIvkFcRj5PYh5x2zhZ1qOASJfiEZwwZs4bPFq8cFyDYlVR2qp97psVa
	 RD0ZDHrQ8FhbXFHdl6g9p/gKMw3oXlYoxh3ivGcUZ7izcBFgDbVE8HUJAw0Nl3sFcUzCo
	 dzIeDj27UDDZV8FA5Nbu4awODQRUd8qBOiBZ74rvowZTjrRCfQRBw2q60cE2TdXZ5qlLh
	 nqcbGIaH8KXUUdHKVgDP8ZXE9+K5Wnw8Pf1Ggct3Fgh7RMx2Fnap1uQg1zZZqo6MKGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793181099;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=hFMJ7dH1rfQ/UlwBFdU0RWv06Fgl8XZnMnIU8Pb0hqI=;
	b=vVBElYnbIa8ek749E9tJYu9+PWQt7B+eM3XeJKL/KWYQQLBtOEVNLDUFSLJXjIUhqbbh
	 W4HDh+/YG2/HMCivYEi/szHd4cRrcnuMKCdsNDaMSDlGwbNcJI/pIXESte4jd5Qj3D75S
	 VglbQ+2/HTjpVScmKLQ3LHF0czA71YFC57WnxjD5GCZyIUl4mHS7zG5+tPDsAzdLHH0nM
	 +m7oZZYxm/KSY5OsUOy/nR9VcHgmI++pSrx7hMxj/mru6vrRAubYzw+0e2gLPsib0bIMv
	 vKZ7nu366wfI4WkHO95bU5H9FeNlooRvFcagBkL5+EmD1Kx1441z8DXRjo2tecjYAuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ALCK9GGi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.32
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013032.outbound.protection.outlook.com [52.101.72.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE09C606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE09C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=ALCK9GGi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DswhluWoufcyaa6Y7XAaVhPNqM2uijpwBmABviohSBe6EDiVg+3AdYYa2xdPz1iYZhLcwRyqH+G43S95L4G7wHcQ4OAN/O6nrMHCxduVO1+3WNI1Y1K0pemQA8nizAlUGnYU/GyXGH27IsizUdSGV8r6u+E/ZwGvYbJ3w3dMSTlp10zRX6Vm1gJAE+x8lPGFxu8RJf1RCjaRJ/RhIUs+b6YFJu6lC0TzVxl6w5OwlwaCUOr1/X0EJjnqgq3BE6SEWgGHvM0Qnb5je080gQlNinYviB3rf9/sFxzjFhUTxBrwIs25fI3a4vDulugvANCo4M+l0+NLqPGsROzie3NTEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFMJ7dH1rfQ/UlwBFdU0RWv06Fgl8XZnMnIU8Pb0hqI=;
 b=Znj9DihLylsRHQzgoSdUDNJzJctLI7cPKQ53XglVp8dpZmWTh91/bBXjvT4Rx+QfKmDQH7a91k1IVJXhuz/5Ua6FW4vPGj6kg6hDktmAah6k3HAyB9/Pg+oHRtfs39/nZ1r4+dBcwhgwWC43aEPfBzUpHx2wDuqnbm2x53spmQuDxcoxQqCozv/Bu+0xIk7yBOzgiFOLc18NGcZTpXBGTNWotFj2RzTyF0D+sCr+H/yNQ1J7rvDJv1MZsKvqT+Oae8Jrf9+OGsiJzTmeqmCA5czp36fOGeIISJ5a9SAUJnT7sYq+vlJuQB0pWMsK7cMfXlBixUQT09wlAi0rK7/MhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFMJ7dH1rfQ/UlwBFdU0RWv06Fgl8XZnMnIU8Pb0hqI=;
 b=ALCK9GGiZP5nfmHlcv1gN2+VhdHBWjgXIbZMQx0lPHMTrVkDkgGXVGDpkQA/X2vXaTnGDS6j/QMjmE2rvXbGLue7RY11LKIZL1s7wk7bkCeShWAEwvnSV3jJU9y1ugle1/G4GzRxP+P3tSVQDAnIR2vX8h60+HTFgtQQVFVtonO8uCjVKVy+G19X2LpGpjyqiYBmrgvW1AWOb8VB6iqqShlvsJvnWcdJdYbsVRL5bSOgaAZvv2qDjki/+9f8lP4yR/wgQwH3ig/bmB91tM8aSDiT1Lr9obt0Yb44shGFCtIYKXa0KJ2bnSbmWcYijJ5C8E4pzrjHZDGGP3nhhSCIhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DU2PR04MB8757.eurprd04.prod.outlook.com (2603:10a6:10:2e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 09:51:36 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 09:51:35 +0000
From: jeff.chen_1@oss.nxp.com
To: Tristan Madani <tristmd@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	linux-wireless@vger.kernel.org,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: Re: [PATCH v2 wireless] wifi: nxpwifi: validate scan response TLV sizes before indexed access
Date: Wed, 28 Oct 2026 17:50:59 +0800
Message-Id: <20261028095059.3874733-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261028012620.3762590-1-tristan@talencesecurity.com>
References: <20261025181531.3744345-1-tristan@talencesecurity.com> <20261028012620.3762590-1-tristan@talencesecurity.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::13) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DU2PR04MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: d4dcb5ed-4241-4eb8-cdd6-08df34d90dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|23010399003|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|10067099003|261026140227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AlizbpPGD06VGm5sVOnCh7eanDNrQG6dPZj40fjKUTO6nDl1AXlL7jBc1S2/W2QhATnYCy3vx6Y+nVHdMSYINxP8kZh8w89MRwTxm3WLvMXUCsmfoEeila175r7v4Esjl2/axw2sGcZfTdq6yb4CM9foKJ9D0XgoOlJ4CiU7+0p7UpPKh2VcsljL/4lPqxMHJaFNak51KEEYlef3Je8U3v3CjcZWz0CM6UTdSibrFJuMg6I1xRE5E8KaYm5H3UXjgfIgtoFvTzyqy4XztqPtBMm+E/SO2/oj2YxkTiaJuTajAWiEZ9rqpNj5dETcpaNUX7PAO9beWW7iwnBwwgStUZXzObR6UYNJXkjJ31e3cR9dQ8F9T/2gUx4zJlX78MpkHSR8vVd1IJDTn9qkIsMrUaidFkFgA+03nyD022DYlNn01dpHbCIIAqllquzpNk/N2ABjXM6clwStvO7TBRw/VqU/KipiAjPXz2gsj3QERiNhEIE43EJ4BgPHH6HnR0KTiI+xGYERsNI7N2PNiP7oQrD9/ARiz/uvBMw9n4Ikq5tOu18oN7dD8Jo4r6/RVDyRG9xuU3h9OTNU+uhVCEOLC0OJNbnH4FGDITZUCsUe6zGrcQD9a6ewowGlX5FZUG1T6GzmwzwgNQCqdLb+gW3iuJKGACbWqD7vXC/j4l5QXJA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(23010399003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(10067099003)(261026140227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cH1a5zCKZ+WZA0UQsQwPSh7O309nrZuSyi1ObdXTZ52wvpOHLop1W4AmNKG+?=
 =?us-ascii?Q?2K7kpdH1JV4mZxKJFKtlWEMnm4vNvzyeP59L69riNP7QcNy7NC2tK7WIPWlQ?=
 =?us-ascii?Q?xjw46kU8BjM2+y9zCZqyxqNYMNKD5yB2XKdh4U2eqECfnSsDfr9DW31rZtAZ?=
 =?us-ascii?Q?guc3DnbM7nevRNUG4EyKCTw3iUu6XfyL1NiSNwnhZGF/GfCgX5XyK5tFTeZJ?=
 =?us-ascii?Q?XCrbOZRtFxb5IGB6JmOsaPObjxLlIiG6XCIRwL84cxYo10dedrhdoG3uI596?=
 =?us-ascii?Q?7q2jjzMmrQ+tdoko2AHm491ADsL2HdOTJK7spjjDnguysqU7dZVNiZlBL5IZ?=
 =?us-ascii?Q?0vL9yYrITsYrUTEFr/OEHqBoNzltrRt+lFSgiPKJA7uwpP9nPZz3lGlMMkmv?=
 =?us-ascii?Q?CL+pf7W92jMBu5FtW7v2hR30x0iwc2v2Tf2wwoh0bvCa6to02thSVS3+isqx?=
 =?us-ascii?Q?EHnx5RraLDKn9j29oWxJ+7LrMofz0tdN9+xBRwKZWdyW6OByF1g6ksn4+CO9?=
 =?us-ascii?Q?1R++OQUhms7ZqnB2GiWW9rB6s+6ahu6G543WFbDQnDqInX11Ok/6Kk6HWZ2a?=
 =?us-ascii?Q?6Ig8XL7f5yOFmzL86cuKbNG5kd2c4dheZSO6o0P6fJTMpp1E+UYXUlsgx9IA?=
 =?us-ascii?Q?V/YFZp3j3xw5aL1T3PgaNp8I9b384/PY3/ItKlcHApWBqWCjPPiGqcujukQB?=
 =?us-ascii?Q?YNcn7HmopInz31M9hd8tTZ/u+cZrYzsfhhcZZobIRKTW7n/jAEsVeNQb7an/?=
 =?us-ascii?Q?2RAPeZJhvSD9P7/hwB/JCMsh0dRluqKRGuey/2cvwgHSDIlZeDCXFB/Gggds?=
 =?us-ascii?Q?1O2Gc45n0MZGCUaZolpRVOFuOTHqucN26xg7Mp3CTAjekK1lkFvmo2qHr6HD?=
 =?us-ascii?Q?ruwzMZI6ci90ZRjS3WHjA/uUdRAhfHahFAjPwEXqzaB7HjeSlZOhgE2bUcVv?=
 =?us-ascii?Q?FUgQzHKZiodqS3VjN+OgLsv4HtOQyyNnsnahdcHMomyp8ZhCoF4OE8JG8Lho?=
 =?us-ascii?Q?SQvc6Lv3v9BqJcz+Lf39Qy17kEj+ARrVfPB8KWqrWrgxlufiuClKpsyFNPg9?=
 =?us-ascii?Q?BSqVjp7LdN8nObeH15uaC2P6q2yxzzkFb51yMtwzPthQVG+IH18JtIzLd76O?=
 =?us-ascii?Q?JYB6duJouKd96MkR05MOXLNsoDRec8llD6lcwcj0qrhv6nF+0oFwTbX2PgXh?=
 =?us-ascii?Q?1lMCxPGZWeoeYHRaXC03pE3OcnbrBJ3r/NXe6CWVVsw+Y/H7Xja5Z9KLPFyM?=
 =?us-ascii?Q?WOdvdXhjnqC2c/UNfv77Wn/Cw4dr/a4/0HYDt7+5WSOYQZgD0K/q/E6XScp+?=
 =?us-ascii?Q?7G3TmP1hfuFmRlEKpZRMyWwL4Jo8Z81O1eFC3GSFTcCR4eaz5OZhJzhRwMMn?=
 =?us-ascii?Q?YRKrXSFW2717djtkshM5RPq6VHLKKc2PHi3/A2H9zULAn+Tj7BiUdt2JE/Cy?=
 =?us-ascii?Q?3iZXwBrcD60LE5VFNyAbvDy5BasAkr5aSgIEMnOja0hxJ7MIZ6FRpbCQaq1R?=
 =?us-ascii?Q?Ivt5WovlmeIvqwgsdLJLlRMZ3EwijGVbDtSFpTF4her/OoxP8G0SQT95jZd5?=
 =?us-ascii?Q?3ItPYIJ28I73HaoO2xHlVGAj0lTN/3HpxwIi0V/D+2i3UaEzf6QFJ+ccWiQq?=
 =?us-ascii?Q?r9fO3NNvxqwKM2bi5btdaJMu+C1OvYNWalz6otHk6eNYBz/wiXFSaU2PkDKt?=
 =?us-ascii?Q?rFXmY5+/pRyqNERMwV1Ipw6nmCMpZYOEhJpeeRcIkx2FuiduX2zNeLQ3/7q1?=
 =?us-ascii?Q?LNOckhBaFb2GPjXqP079vhtCcZ8rtLOirMK9sCUxqduXePlz8p8e?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4dcb5ed-4241-4eb8-cdd6-08df34d90dde
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 09:51:35.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqHSrWGs/i8P2y0JUx8qipj5pQiH4gxpPY6YBeRbCj2cpR7mDOIEiAMgN+iv7XT/8bUKdzqIo2PcbzPP+6TQNW++SbWWvTKVcGqlzDAZrdtK6cPU3RopgkZUjVWIZBNO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8757

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Wed, Oct 28, 2026 at 01:26:20 AM +0000, Tristan Madani wrote:
> The scan response handler indexes into TSF and channel-band TLV arrays
> using a loop counter derived from the number of BSS entries, but never
> checks whether the TLV data is large enough. A firmware response with
> fewer TLV entries than BSS entries leads to reads past the TLV buffer.

Hi Tristan,

The checkpatch warning is still present:

  From: Tristan Madani <tristmd@gmail.com>
  Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

I ran into the same issue before. If you're sending through Gmail while
using a different author address, try sending with:

  git send-email --from="Tristan Madani <tristmd@gmail.com>"

git send-email will add the patch author's address separately, which
should avoid the warning.

Thanks,
Jeff

