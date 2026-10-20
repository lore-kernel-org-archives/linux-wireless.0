Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792468636;
	b=C35VkeMofJ0BWM7rj8o7eBB/lcVKxxEEm8DKVFpl0J18JcPmQV8eFYum5i8+XRA3EB0p
	 mNUcxpisfhtkZEdv4IYHHOjv2DfOQsREtE2vUXCraiZbbJ6mVHSqS3BjK37Cy5NWl1/rU
	 TmfJu2GawBDqWNTplMRCOTuKm3xsNqUe3VO1ApunlnQ9hXUlX+b7RFjIQlyBQoJlyBeHA
	 Eh/sK+Y+StsOEKS4qk+tbzTdZDhY8FIqabX+qGOPjjlP2gbqHKhypKXJK35lDQRvVeodw
	 xzyya6ttTsC8FXBqmI4P9FtrK32xeQTvrEK1p9fSkyI4rGHw1qrIPk9KcFh3WoTDFMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468636;
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
	bh=OQwjg5eYUgBOMXd/MtupFei/mpPvpKnJBKxP+uxxOyQ=;
	b=MbzOtzZM6OjQ4PpwpGpyUmEQWWhcgqUKilSnU1wf9BsrU4Uj36Brdpu9jH865DxsDuIK
	 hH0K+4NWUdWmmVl+hux0uwX1OrYs1YbdirWZHezpTaiAA5jIEWJStGfQg5p0Y0WBL0Rnb
	 q3ernUYQy+27cNLt4rf0hoIEpZfhQ6OZLRhJEUmzXewNRey7gVhe7eMHDdfEdV7fQnO7S
	 DMmLd85OA05AZz5fKdOBPwApKVTKPAnvrLgLd8Fjky1yQzIVYx4QC/AQHCwbZ0fIiTs/C
	 wzPMW8pmr+6xsM+lJZUj0FQUI7kRiA/FAuVYaZ+haK3hQ4Pi01y2QZRM9gggbM7E2VQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=SHkhaOI3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.45
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013045.outbound.protection.outlook.com [52.101.83.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFDA606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:57:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADFDA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=SHkhaOI3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCV2LVjq7Y4yweurFKLb0ispQgqHcjugbQ5hiQEggxSvy1G1HNtjh0uvwJcpi8ehYYeVzZ5kgmFHVWC0p84SMYkjZIJNje2EQTEB3zrIGHvnWZp3U03nCIZ2E166cJWoef4L4seCQPA6X6ouEt7lO9KOjvQZ6EqaaOGZ+GDX0AGvIhKPvyQueKF/AowWEdcAxBGZHgGvH164DT5EppQAyW5sHslh4ReEHLpXhKkuqvoNj3yVvA0hL/w1wj1r755ioMK5BCN5vJrbv/h5LorghxtfEUhPYw8o0GFpcDguFsMEC9UjTHAzMhtLOfmGSCqA2tNvGhS/cNtJwAqpw/VLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQwjg5eYUgBOMXd/MtupFei/mpPvpKnJBKxP+uxxOyQ=;
 b=r9Ts/snvHvdCk6tE2sAfbZ+rcIpmaGy8cvEcXSkTICUZmpG2iY48xSLEqe6SVi2pE4nED5Okd6RHbheX7C0q7y+8jwTPHeVCeJjKK1EEl4WMlhLuM8fUYTX+nkx7KkTXjNwA+1kR49/1B9WJ/UpDPZmTLnVE9xJAmD7IVmYAU86LU9kKWAbpgMhbFUKuhthTzl/6t5BN/0pIW0Mzd/Adn4muZ1yWP3MDiqFJ27EZL7zuPi9gsSGyiTtjAeuisKDg8fnOUMr+JDe8pmqazbGXLNOTSNUICnyLQIQcAgBSo66xPWTCamEbygvpcL0FmgPMQD8bKB8lwf7M2/mQNdch8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQwjg5eYUgBOMXd/MtupFei/mpPvpKnJBKxP+uxxOyQ=;
 b=SHkhaOI3ZFzLFLUGPIvYxS7/S2o+Q/fiRY7liALs5cU4QhydHXyD905I1WivJmAPZcm5uZSFLY12+7x8F/DHWAimyZ82s7BBQWulzEp7J3DyXKDCJfm0W62T00qaRVQzyf0V8OErrKjR2qRRFFCyMRWncNocDk8mxE/Ohypm8U5+txUjOGSg/NMGKs1eb5vsGLik5kyo8DQp3NLTvXzbK1apSBZtRhj2htedi6zg+kLlwPkgSux7rrQhoMIkHqFLRHOh7r3cOl4e1RI8O9E1E+RJdZm+IO+YnEFZ4J9pUZ86073wU+El6D5gzDjWzQk6wpnjhcaUZQciTyJlXMPjeg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com (2603:10a6:10:1ad::21)
 by GV1PR04MB127854.eurprd04.prod.outlook.com (2603:10a6:150:802::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 03:57:12 +0000
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c]) by DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 03:57:12 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] wifi: nxpwifi: guard the 11ax response handlers against a detached command buffer
Date: Tue, 20 Oct 2026 11:56:34 +0800
Message-Id: <20261020035634.3628395-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020005027.1105121-2-yhlee@isslab.korea.ac.kr>
References: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr> <20261020005027.1105121-2-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P189CA0056.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::26) To DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21)
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
X-MS-TrafficTypeDiagnostic: DBAPR04MB7272:EE_|GV1PR04MB127854:EE_
X-MS-Office365-Filtering-Correlation-Id: d2bd766f-c72d-4de2-c9c2-08df2e5e3875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|366016|10067099003|18002099003|22082099003|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	IHYJ1CckGflKLqsxdSlx1V1snqhPkoIHjm8nfxYrWw6UzzyPZ7rsG38Pq4xXH9zmO4k309Lb6IFA8dRNi91630HDg5KIR7noPUz6J+sN0eKTuLLC713mPeG98lX18CtpJjnhVWvzSyVoXQCEEdqn9LQ17JNvhbzQprGfI8swWK1w4kIG9ItTf9LJRGkEqf1UDGTmpGGLUdN18RwKH8/1fEuTbApmbxfKpg4Hnnqopxrbpgdknlc3B/uPa8QW4PvToSgtqeDSuT4O9O5eV36Dd14tMs0X2HBypR0eRkDaijuviSc37gCwfvm7NToxTNRtepUEzSbD72ChzzDQlTzr0DoJbu4TwRRDvvF6EOykw0Rt57xawc3Kaunhe4kBg2t34ckvk/NMrgD3gXUZ0+PtpBVlPNX20XhVBl9sU+aZdFyG2ZnQGeorSRqRht6Sr0DYeDRa8TeZYC7zs+DDjwD5nV0IAoKd6F9A0Sss13tut9Di5iGdu8c25fnae4cTGXlV/TFNeF226bM4CQUgor2nzfYK2YOc+qK1SmzgyZsk3hPkbqiTplpt9mnpfQaCm6/S6/2JftjUdRqADxqisteqQ6/OBMVzwAVKfiAAlcYcFDCt0fcSr2ZqtdlBR91+Yxjd5A+qC6Bpox7JzPKzYR6N+tr1O0OQA1RlUok2ya/7kvU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR04MB7272.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(366016)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0CYEb6HR8pa9f81hDyt3a4Qot4qD9HuiGDVH5wuRrTrby8HqjsB72b+rq8wd?=
 =?us-ascii?Q?WQ7f+DXQ7CAYT7XINtfi5rHWmEHMehtRD6BvBnR3ELhavtFvjFRClafj/fAD?=
 =?us-ascii?Q?mjVo6n4abq/flY2BCui1NgJSQL9E+7ZesaO4AYJLQ2wEX7abHTCF8xpeVyQC?=
 =?us-ascii?Q?XpRAm+scnqvdamSMDqcBC92WbBNsdjfftui9awYTWexZGAGEW7WJXzrHwc11?=
 =?us-ascii?Q?VlzR0WwAVLuakWJsHF7OlgAXY25mbOIVXDCj/VFuWP3Pf90r7wvRPqxNdEVC?=
 =?us-ascii?Q?Hm55u6CVeWcR+w33JB/wx1K5/u5KY7wXufg32kMaqcB18Sm2VXMF9Uvx9p4E?=
 =?us-ascii?Q?ll9B+5NGrzSEsqe9JvI7PpL3i4CSvTI9wwG9yQUzqM1sd60C4mNEjzEyNNDu?=
 =?us-ascii?Q?H2+8Ls3aLJptSapa/fflqovt4aSIBVNktVG3BUQ6eMoWw7dVKa3qMaUd4fPI?=
 =?us-ascii?Q?lAqL7vKb+jNC7VQlLU3gxikdkedq464YDAIJu9xnBILX4IPRl1f/BZEMbymq?=
 =?us-ascii?Q?nzYNN/atQ+P22eyefgDXkPAMqW9aGS7aGw4P1sYJL7cTNHhtcQU+SoCaSeMZ?=
 =?us-ascii?Q?m25fIz7UcSKx3iObJ2OxbfFyT8JunnUer5qWHdXB2qjtjeVNsqpT8k2lAXkB?=
 =?us-ascii?Q?PhlAjwJRKIcWfE29FaQVuRIp0Rj7wCI30kkK2VcUAq25G8WqiJ5sjtB2oy9m?=
 =?us-ascii?Q?oO+glj1MiY5KA8Dl68qAQYiuM6Rcz/vEeMK3me04hdnN/LhZZ0ZH690HpSuK?=
 =?us-ascii?Q?t0is8+AOcbUC+S2nGvtQ5VBAuj4Com+6Zvzu3EvX3YhwpaDjeIs7QWZlYxAT?=
 =?us-ascii?Q?qwVr8JzV2YWntRy24LHEATb+oq5+Ejb396G/QdfE8kV+Vi8flJyizCjbusUm?=
 =?us-ascii?Q?vaeNheu0bk3xeM5qslCyn53XYi9SZGczm7Eg44SKKQSYWXENZC+a1OXoHBH8?=
 =?us-ascii?Q?43dSE7BPETAkKkNxXsOnF4Qd9UWpkVp/f2bWN3UgTSHO7ddTUdLMQGv2uqi+?=
 =?us-ascii?Q?pc09O3PabXHoD44fHhdcPoDZq1eQF1gR0POb+nExURZD/G2thsfxuFjkUKue?=
 =?us-ascii?Q?RJRZ23vqXZOBtdBdzJhmcw0CKYX3jbvbSR/1MvoODBB+9nt1//hB8kh5FZ5L?=
 =?us-ascii?Q?1c2tmVtN2KUy530VbqBl7/3AOtsLBUY5MCgxDoh/6CI878sxe/aoMCPuhwf4?=
 =?us-ascii?Q?Df0Vs+iA5myyZRpKC90FL0IX1Oe/gA6b7oAE/uiITOQVkZjf9rtHlZ69Ckt7?=
 =?us-ascii?Q?lIuFT35CD1zgu8hCaN89dgv4bpT/M5rS+uot2teQmA4FEW8FpbS669Cmz3Bf?=
 =?us-ascii?Q?A7gYrvG4F+q1cy4j8vSJVe/ZBQn07mMHcjyaVZKO5dOfrezwzoWPwtXWYNx5?=
 =?us-ascii?Q?dSC4V8dq2DfYOIOt2sfeCkS9YyygzBLCcCN+tEBjwlk1UZKeVg6+PGKYNLql?=
 =?us-ascii?Q?iIsbTEDqZRGWBgbyNPiNq9BpWbkzFoHpK9FIQpLrlE9i4lUCpbh1QOLVh2mK?=
 =?us-ascii?Q?G+cKmN2Bo/0Sflm871ByfSED2C1FOn5D0rJ/iPiyH4QGcqGquWPxj8vXTd2b?=
 =?us-ascii?Q?1Dqu0Qlw7Nv6IzRO7i2uCgX3SCDZ6NVKSuJy5mOimLCeDmnWrOrKf4e7p1c0?=
 =?us-ascii?Q?CWp1oXFxq0y0pGRyliakM2mpE+iI7gr3O2r52bhFM4cavw24F/p/d6OhpPVq?=
 =?us-ascii?Q?vGqYD4T7Jmxk1uNRRbT2qMV3GLV0s9Bh/V00KwXxYL7teVcyV//MGi6jet2M?=
 =?us-ascii?Q?PrABZBRpQNkAy4S4Nnaz5LdtUaqTURr65eyB2GiaaKg2bN/bFUot?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2bd766f-c72d-4de2-c9c2-08df2e5e3875
X-MS-Exchange-CrossTenant-AuthSource: DBAPR04MB7272.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 03:57:12.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BE58dd6Tqr85MzBv3vXV6CwChBmg8FYm7eOaLKpAoX3z4TX1fOGcsdyeVqpWe5Yz/Ge+qFxm3HG7RMNsw6oVra1nMVR1jaU4xDCT7dAXvGps23qdxem6tdkOvG6FeRhM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB127854

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Tue, Oct 20, 2026 at 09:50:25 AM +0900, Yehyeong Lee wrote:
> nxpwifi_wait_queue_complete() clears curr_cmd->data_buf when a
> synchronous command is interrupted, but nxpwifi_process_cmdresp() still
> hands that field to the response handler. The three handlers in 11ax.c
> store through it without checking, so a late response oopses.

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

