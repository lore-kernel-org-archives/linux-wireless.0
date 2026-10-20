Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792468396;
	b=N5u1eTWJWKS2QmAbpqIF6v022oUEkgNwMYZRqKYw0ZlB1qowelpyDdnJYwvzNtLY+aYq
	 JUPFJGpU16oQfHbF33Jxjut5IEBM1/qmxp2+9qQD3ZtxZXJcjvGwhTtb8NYEyZGEEgsNd
	 EHYSBZjBkhjd2w3gHWJ+t8A3G1dZ0eOTFWRFoTjmEu24krHoN+7f7921HprtMXoKlhfDN
	 alJFSbjydPwUifoDFjKBV7rWD2ldgE2EcCN7MFTmxBC+XZwlD2C5v7tnmACrsUr/k5eq4
	 4ibPKCZp2JuPvXw2EmWtLRGOZ1geKad844kvwBjKicEDJTOAa6L3xVruRUFjaQ57g3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468396;
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
	bh=r7GutrnHEhtW9PC/vvLSHT8ARQcNR8ERTe0Z4KPAduk=;
	b=aG2RwWgD9SZUEmVO44H6+BetSZ4ufgp9syTFMLNNgAqMr6Rb5Y/4Sb1nqybVVd7hEbyx
	 eR6jl11GctkefBt2udmX1pMROx721cQJ0Ugy+B01jGOkUFzESMC3qC6UTY48fOCBY3ibL
	 ANSJb2ctuzKZ8YFXs+9QYqRd+Tjlr1dX7pScAxO8caPje1Tq5MPRRbCJfdSZYKRSvZq9z
	 xGe0NP1bTqWQqf8C2HrhPj7Uw1WX/vTDaQNSX2MFy8llY/fuVxmIdv+m2md7A7YeZpZMC
	 wFfT+wGZ0m5AqboKhbOEO4z5Jl2GYf+HH+0SSs0kQyzu4JLOffrN6nPiW/ghhDYpdBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=l11Z1Oem;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.14
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011014.outbound.protection.outlook.com [52.101.70.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B96606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:53:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43B96606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=l11Z1Oem
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jw1iIZo+4EHBGaF77bbTNUnmjzpb6NRHuLjq6H+zGbStg41ks15Se4R3pA82du9ZUeP0BuQhl5aeOeNqHMi3WLZFngTBXwwa32ipM47/cyc7l/g2w0acaezVVI4SOmRH5ozF8vA5NShwdoEYMZR+/Zw/N0tE6dOKWSs4iLeHg5e/YfYD44jTOfVq7xvrq/9W41nCMhl9N1BrK65E14YjBEyrqtfX/JZJ/nGih7t36yY8YK7bA3GpdgaCXfDwHKWUZLi1AeWRaohFHpau2bDtOwBQmCEfxu0hmgFZrzkeEakadiaokkwCTLG1yJ7DWLXr5ZiINKZjDs0NpC1BVnkMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7GutrnHEhtW9PC/vvLSHT8ARQcNR8ERTe0Z4KPAduk=;
 b=TrOWLq96fJLN0Nf2mv49Nvx63q445HCDXOjAg/jHOAFIjeipf50c5VWIPR8MFrMSsUMamkIZrRNTL6NgVrrFcESUMzHAJCF06pHzs2/dKUoQJbuOtuTeDHfWCcm8YG+zCN4m+T0Wn6QbFJ4jm2h5CyUqDILdHtvF+uwSYdCUuo0HSeqy8qOgaf4lwWStrP+/DSTfcCAp0fcaJzirnqpCTOQOsASUV4uhkFLGHR6vOkSS9TokscSLs4demOszFewwMO8xt1aEORg5sx/zpnVkk0OQTMlaedi/xRsEE4QJanUh/udDawhfHQm8mn1k4yMKhep9Un9V+Q5oSSGEFZQMjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7GutrnHEhtW9PC/vvLSHT8ARQcNR8ERTe0Z4KPAduk=;
 b=l11Z1Oemuf52x2PKgPbTGTtW5l64zMLTXuRpTGiquRW0j3IOp0HEzmf5tJG/MVMPu8ne7ep4LqwhtnPMyUi0O8jltXW+lFkcuuYBsGkzdByFGlkL92/0SUag3sOUn0lFF8YjdfzgwB+i2Bgchy5OfTs04fq5ChoOfkjSb1gON8kJA7MPzmeIGo/LQFqANdzoJ7EMClsaaoEg1brFXiuHWNMcKyHj4qXKKDSX3IC1ZBVAZyT/7a3ESLTF09EEoinKRrLGRWe4HCYqTHqNJdgbvOrvNaH9JSrqy2C3oMs9zzVJgUIDVPzFW2B5J7g3qHTYlI2UAKaoy5ung2nD8p2Qbg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com (2603:10a6:10:1ad::21)
 by GV1PR04MB127854.eurprd04.prod.outlook.com (2603:10a6:150:802::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 03:53:11 +0000
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c]) by DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 03:53:11 +0000
From: jeff.chen_1@oss.nxp.com
To: Vishal Gupta <vishal.gupta_1@philips.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	jeff.chen_1@nxp.com,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: nxpwifi: synchronize scan cancellation state
Date: Tue, 20 Oct 2026 11:52:07 +0800
Message-Id: <20261020035207.3628227-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019161357.84150-1-vishal.gupta_1@philips.com>
References: <20261015113433.2312077-1-vishal.gupta_1@philips.com> <20261019161357.84150-1-vishal.gupta_1@philips.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::8) To DBAPR04MB7272.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6bcae45b-be2b-4ba4-4394-08df2e5da824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|19092799006|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gx/GGI42BSQKxgK9/6ADZjphgovsCYtBWlw/SHsVUVstjv6T8VwN5DtY9r4DSoAI+p3VKvqhaSyo32A72kTMhAKlzJrBMl+xDioG/uoMw4gG5Pr0fL5hzDmbXQIQ7zcLaUgcxPl/kD3A29+G4v/pDqfqRDy7C4qXI2e1qpB/FZB41jGmnXa3cokAynPJQUA0nZvhEgJ9omlee4xrZcNs6+VFMW91ct/8+1vBZ3I1kIBLY51syetPET/77b9PlUCzJTE4o7GwdwHs1J2UworfO2ozi1NZ8hl6Wy7mv7CcIput/wgjtQf+dA0AsERGarnyFxb99iOVqeKXr6onApXUqHEOWvqZuWaoz0fbiLTVcJBUi9qzCVL3K4FzaXKEZ0w30d/edHdZ6TF8TMnUzwxWfXsuTri8NiDh/gFmrcVfe5FXbGrwDj9l0/UeTIxaGtIHVkhoGMHde8Ixhc2DpEGq4JKAWl49doF/1osL4BDW6FB/VZ0BJObCKzNHXDxeuzt8t/GhYa4HW6knzapL2b8+iGid4hBkRHQzJ/11aXZEpTXBs+h/PefTECnSbfnZPegwz64E0d1l6bKLGHcU9WauUWMIdjeLlOblPxbyzPKgRXtuzDfwQel8aEzdidWulAz8ANYEqqriqlnCp1SAtzQ+ym8FS3ZNgfbQOPKXgIiZ6Xc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR04MB7272.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(19092799006)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VwkKH7E0BhlyZ4xKY5QlhOQe0MyP226CYdQXOOdqN0ASpMXy1jlCmcOBsR5b?=
 =?us-ascii?Q?ZzLRWCBmFXlIghQm0ZuzhHC5JqMg2Dp1zR1uB9Ow0a3T3CSJHwbOV+XhGAdQ?=
 =?us-ascii?Q?GqUtMNVR9hZE4JKByB+HmNm9ccQO9QMi/oDbEYaItGJBp2ueym0I5GBX2jvK?=
 =?us-ascii?Q?0AtY9pt8rKFzTKgBia5EFqy72RWWT3O/F4FrUX61/JOqFwNoU7F9p5oUznds?=
 =?us-ascii?Q?bOnKOPqyQn57TNt4bWkNQ9uPAg6txRerJQfTlbQWtl0x2pSjBVfR4zgsrDVY?=
 =?us-ascii?Q?A7etjMkv5qgc0Kty3GRL5J5Jfzm4PWbj88nU6Ii4pcj8IzcO7dOguidIqpYF?=
 =?us-ascii?Q?Qkvvnjk84I5a8HBk4oHjZBfYtLCUsNBeilx7H5p9N4Tj7Tkfe8b1hy4dKNI7?=
 =?us-ascii?Q?kyT8hOlmp1/GFQblV7Fm01FJm1CAJf3pRVFKvMdMX/zKtegPaJNWeObltc10?=
 =?us-ascii?Q?QN2qpsfxtyJSjH3Z+0zM5/e133DU4z4eZd7Lx8DIjC52HABwc/ZFDe+Ot+E5?=
 =?us-ascii?Q?pFakpGh/hErKBLVvS9Y9p9Wl8q0j1DmXRIfpHIEQVK0bavlPuXZSxopXij1u?=
 =?us-ascii?Q?xdhgb4upYWqjGPwbrmWbJjmzIloEVy0ypBVZiyloAueI10FSGllyvDFzVmp4?=
 =?us-ascii?Q?7EGrlHaIQOrV7cVbwvkA8E0E5DI7MJgjAo5/z+QmsN1osJcTASn/JtpE7TiM?=
 =?us-ascii?Q?7tZDW1RWNZ1ZS1aBTSbR9ssm0jt1Fmx3Fp0FZmdQnk6LMKvtZlmk3rpNhKct?=
 =?us-ascii?Q?PApi0P/GHiYnLMAYqodu9GBAa0o7Kl+kx8lZarZTfKnjrXA0gaxCGOd0tccb?=
 =?us-ascii?Q?t+NqtmyS36PcpbT5M9jAIE/fvjSakrfmehzc2FSF4Ws9J0SfsWZ76i85r0yG?=
 =?us-ascii?Q?kD3+hV3i3YMmtrAFOvmZATtZkJzoSJrxwT1TTD8+OQsFzy2NprqtknyxwJt8?=
 =?us-ascii?Q?P8JsIvi8ApyycNUMKNXlGuKSympo0901EVbUl1mS5v1vx3ekxGGiUkivTBBG?=
 =?us-ascii?Q?BGLkAl85worgdPbqEH39GvicYKsI9mjmv+8sFOtdcbP6H6pkz5lVX36eLGkX?=
 =?us-ascii?Q?JR9Crd9HwIlz2QxlHOrA/fHHqwxQVHAk4O9TVbzsBYcHJWcOFXXOCxEMSAgi?=
 =?us-ascii?Q?RygDSMvlGc8sS8FPV6hJZZpN3FDfVW9ZTKHfb0i54OREzlbJva91ElTHjcQs?=
 =?us-ascii?Q?FwoQcEBLeiX0u16NLsDMaN7oK+o7wIA4p9yCKaSVpcCHsfYWw4En8Yk6KZVO?=
 =?us-ascii?Q?GshdXOaVZl6g8v3AFQ9CqGIpbGDfjFHWgwue+/HnFgljPV75qI5d7zcgUBUB?=
 =?us-ascii?Q?/ywfVp13+RO0AmmoAFJnA074HxlFFTcmcLvz5cCriI3PiNMEa/qbvcbpkzNw?=
 =?us-ascii?Q?wK+dVBAHd1RMe5ls8s9zVkbK5ZNkL55TPKg6t8wgv4QwFjqvexumYsm8VDnu?=
 =?us-ascii?Q?kBdbHL2zCSLwrdweC9wVWfwB0hzyDfN7kMHg3U7ZrNrLM9oflILo62XCBcYV?=
 =?us-ascii?Q?vS0AKO/oT8w20C0BDQ5/hf0E/o3eqxA94wrSibeXP0dluM0jBzHDROjbk0Bk?=
 =?us-ascii?Q?BoOkvJt99eVPP8Ve5mKX9jhfwa5P4BJZMkYblEhUUJBB39ZPBB4TzHaR0B9J?=
 =?us-ascii?Q?h38c3kid6yce8Ghh+dorCI5y9/YwT7p5+yBQHSOlyFpU6CpAqELHZgq16Av9?=
 =?us-ascii?Q?cb0kieu7hc6mIybrwg5/c0bYKcUbCvY8gxBHzcVk0kpm/uJxth9DX46U9EcB?=
 =?us-ascii?Q?iqk95EAYi5f82VHjSTFC1Lp5cYacKN0BlGPWi07WHjg8nl8X0kHM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcae45b-be2b-4ba4-4394-08df2e5da824
X-MS-Exchange-CrossTenant-AuthSource: DBAPR04MB7272.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 03:53:11.0171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/gA41CnFs5rOaXmRS2vn2aVK+fvXMS3vXYU1Vk141caTOuexU5dJpRKlyZQQ5HocysnkbiMgCkrBUtqWgWyQFdJzD87OcLt/7lTk9IqOaBOJOKCisW7DgCA+A+iyR5P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB127854

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Mon, Oct 19, 2026 at 06:13:57 PM +0200, Vishal Gupta wrote:
> Before the change, nxpwifi_cancel_scan() checked scan_processing outside
> the lock, then acquired nxpwifi_cmd_lock only to clear it. That left a
> gap where another path could change the scan state between the check and
> the clear. Read and update scan_processing variable under nxpwifi_cmd_lock
> so cancellation cannot race with scan state changes and skip scan completion
> when no scan was active.
> 
> Signed-off-by: Vishal Gupta <vishal.gupta_1@philips.com>

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

