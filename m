Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792468880;
	b=aS9IFZqpw1qfXM/j0uXMfXoJ+ElIJRerUG7Rnb+QzYqkbAxyPPL7KtyHK1jgf3poV6yH
	 UYDrWMYnBwp+Czvd6kPees5cSzJMsVyyNJlW/ciHUhvo68HgsBq9wsrF/tCqeD9bkVcv7
	 en3ro9hYogVy625afEQi+o2rv1JC2A3mriMCvwVa9o2/pfhScAbeQ12PyG3oGoSDib9f+
	 2h4Ja0aUGElKvCZQVtknG5+nYFTF03u8GD5zPnpyZMel3DuxmZfZczN2opGxbgB4Vtol5
	 ghhU278LwEOAF/W4ulCjAc/KS4Gl9JZrmuA3pFGVX+fqhGcJSom3f+H9IZ7I7iLPPyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468880;
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
	bh=1q4jQd0dvLOyPktiuQ3yQDAqWH2wLo/N3dXL64oJtjk=;
	b=SINj8lcD1twmXIusdaGu7xkJf/IACdRZvPsOAV4hRxTPS+7PXn4jZQZ7iH2Zy1tcth9W
	 FaLo9AE0irIWjn1NdNMFN5E5/zv0KCza44pm6mgd+DC4AMBq8F+6xHdP1bG95VJm8U8Os
	 FcdyRL5FNMUfEFO8AgExOlIQZg+7kzsgB/TTvmYLo4po3i2PVHvGvh3xve8iSXI2axdJ3
	 8nDB7qDF+0ye22AeWoUgZfd5An7xWQj8pNGChdtZaVa/+AHbIdYL73H0rQ9TP7GIWsckX
	 ktXXLEEqs6Hq8u+qxaNAshqOCzOBSF92XsAeM1g2eBn+Sp8IREag9hbPLTxtyvxv/oA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=knmJRQPm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.56
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010056.outbound.protection.outlook.com [52.101.69.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39027606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 04:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39027606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=knmJRQPm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKqcSTXIQASyprFKfMs4Pso/waZ6H2UXAiLZCH59NpM5u9qGGwqtCGRDeA8KUX3pD+rpbPhTrgY7sHV9+l165moLgmKmUKAdhgmJUy0AjnAKIeON4PY/wtraXDv08wiYqsEq6SwjsCYjpaoPuzKRmFmgnSy0NmkRTD1BmeK88pLi73/et6LMBq0NexOVF9QuOvmBd1wIeb8udslz4m2KcDpGySdCMum4U4kpWX61RnVIHf0r6anCe//lzzhmz+zUrJxSWQS4lCZRicQvAJ5YO4NZVq2/xz6lb4G9q4JaivRjt115ncVuXD/cNn60j+xqaanEnBu6ctHJKINZXdVbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1q4jQd0dvLOyPktiuQ3yQDAqWH2wLo/N3dXL64oJtjk=;
 b=KtMoXL9vbggJGi0XuD9hBKge4d2MbGD7zSwBFMk66NGebS3wDCINiKUdDeaEKmpWyb2u4EzfK1PfdHRlySY7Vczz7zWDnBJe2L7OKdYYSDGWz3Map/JjfTq3D1pl2rsR/KJXp0QFtP9YVOfbxCQdNONhvj31ryn8hdyTv6sV1M0WDDodkCPC1M8bSiVe/xPUoI24Ya9mbtdugC2s5HlSu8hlwSrP5OLukuxCF6RVcxOehLmrx1bUHb1UDINVdhf4F2oCtgPt7KEzdCWXdhSpD68f1f5NyNg/y3l0V41oK40mebsjI2qtBRVJjEkOUD4M7v9B2ze8edgciGdBucGdrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1q4jQd0dvLOyPktiuQ3yQDAqWH2wLo/N3dXL64oJtjk=;
 b=knmJRQPm7jFx4s0l6Tpn+0Xz2IqyXZukF6aleLeP87rpV8Lvq09r13r5UuRlyNddHtBxqZ0EHcVx2ocUu0Xp7/dTaldIPMptl4jDiE0BRnEebgHAgBI9GOmZVXwWh6rte33F/Sy0LWnpVIGZ8/MXQZW24XaoyOvX7kVKbM+Ax4EFk22uF+jnpldiHl7sPCpxm3gfGGzrae3IxmG/NQeQAbl8oBPFXDZVMOORB94uz96opSdCcNUGAB9PUacnMHHw0n4+RX5CJI7AgD4VpoUUMQzYuFZ1T349tO8FWxRkJslFjSagTrwTU3yF+TENBeFvndXBfZzvxZ+1v90SChRx1g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com (2603:10a6:10:1ad::21)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 04:01:17 +0000
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c]) by DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 04:01:17 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 3/3] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Tue, 20 Oct 2026 12:00:47 +0800
Message-Id: <20261020040047.3628606-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020005027.1105121-4-yhlee@isslab.korea.ac.kr>
References: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr> <20261020005027.1105121-4-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::10) To DBAPR04MB7272.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DBAPR04MB7272:EE_|DBAPR04MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d688a1b-5ec8-4993-c61d-08df2e5ecabf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|23010399003|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nWPeKWsd/DG5QjVmId3OYY4yJBM2L6ic+7lnCUzmvSldOkXJXXHCQxLb0oh/Pe1SnNlP/TIehQ70DRW56zuhZqXw68VNjXx4AyMnyojeFYvbBAAB7Bh8wgPceRHEqclcaQAgI8Xp1WsDwgKGqnbZX7X/u6eqwGt5qHyP6mgOKZNeitZPlU0Ri/OVRuPYHkHQ86D3aVPAoxc2rUWu8ABcPCxpFYlvZhXgBjZubIghzAukMOrkeQbcbGUxx3/J431BsIScHEpVTgFwoelErhXg1vOYLBNNxlP3SNegjwUHSkVwN8tdyFRHYH957Kke6P7VNosIpjSTj8dE/1gzRep8Mm8gs+5oPA7M9BP0Hsn1uMm5X30FgsTqc9tbzvGfHUaSrcU38Cm2e4SdfvVVSnfD/yIxZvCtBajyeNjR49iRtPVJVVFBuG7qxkQGUkk7heFQFpu/A5hkVIk4zIETA00CMD6RthyN8m8Rmn0O3OAtosq3QzZQUmlMC6hiusaO9Vel9SCPhuG2S8bTEqeSBuUROP8P+7JeIzG/Ctx9m82M5rONh0Cy3VYCJsUcYzTzFZpnRSSsMk4j2XUr9l4556zBFCpElAvE228UsYS+dOu6Gda78mvxzhlgryvvjqoC2cwP4hHcT1xoG3vt3WdkW8Xb/mbe/h+VR5p+4XdVkyrJdR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR04MB7272.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?viyvWkI6/KczYL2OYOzO9LpWlqP616nkb9Mlm3BA9JLRHm/aYfFAvhQVEEhO?=
 =?us-ascii?Q?S5HicW0TG3p8gI0JhrgEqGBBAwigLU0Op0R12vpQ25/HAzWqpZr4G1VN0MVH?=
 =?us-ascii?Q?fUbKF9DiI6tdxdVIJnUPu7CNBsA1EwVQg97fqioXVpJLqVZcH0usPfeTh9QP?=
 =?us-ascii?Q?w6pAxIljL8jQbzZk+s8RIR0b7uIGgl269sRD0m4vMn561qoWK7pNzqElDlY1?=
 =?us-ascii?Q?lA9YY12IT8I9VCxNMqFg75pMfhFwNHfC66pBPifTaxRv9ZUmOW1yHb9Hcfkr?=
 =?us-ascii?Q?tDARsTOtJxKR7grQOnnAJLsDt/52Q79mmPvb5OHrbhau6P/MApANaz96Pk86?=
 =?us-ascii?Q?21CMuPzx/yLTMQxlAZG2DxSd3RqJXCJjzezxH3tefyIxgwMJOh9zcO5gtRL5?=
 =?us-ascii?Q?cgaUnO3/8jQ8oLKiCYHyfDVQahd21fHeaH9Z65zRILM04WWrVXHz8g9AZEL1?=
 =?us-ascii?Q?StbxRrneBkQmcIpSrUOUG3hIiy7d7dL1S5CFVM81/CafC6HWdh49afaOrQmu?=
 =?us-ascii?Q?+SxnQDsUq9at/cbS/kW1kkH1y2WnDL3ddRnpuv1pB5hi0uvmu8Xlmw1nWAe2?=
 =?us-ascii?Q?gEEAJcuxIstip1WDZJANPB9o2gN/oYpb1b/92lT+xhsmmy5N7iZV7ieliOc5?=
 =?us-ascii?Q?o+fXHPV2uEJPNCws+233RQJnTAUtBKwN/fOdDF/AviPcPtjjv+A3wQhqT9Lv?=
 =?us-ascii?Q?HSj/X6VXXnz1OzBxqFgoTWY56q/yMZj2t5lJa+QUPK3e9wPN6XpSZ1KSRZMC?=
 =?us-ascii?Q?BVwlbbA3KDmfeJFxBfvW2DwAMXu6YO/p3kyyfMt1Bld5l8umElt5imd8yS8O?=
 =?us-ascii?Q?Rl/3puZRno1GlQJK1X6BlrRH5yUTOSukt+cJUZ6pXcVMbzDe+hiM2V2fU193?=
 =?us-ascii?Q?zgVDBGRpClRgyGEu7wj8HWhm/DjYVXqV1O7Nc2zmXZSG98BODcuxbRNQkEPb?=
 =?us-ascii?Q?CPSV4SocZ74cGB6AYRoR4lEH6BAbs/ywkGxxTZyd6C8rkAz4AUavXxDMzwIF?=
 =?us-ascii?Q?K7fqGfm+mjiH80EsR7R/zzD9DlpB/PaEVyXIo0/fISDovxJrv2KdOWVfAlAF?=
 =?us-ascii?Q?g33u55QMmL+IVFIzvoPyhqX03ZzU1Rb/H1USs+TwM3FqjGHO5eGJ98e1bGlM?=
 =?us-ascii?Q?IRVTZyAS+dVQ6+FA76bDR+h+DB6DGEeyV1D9N50Veu171uJs3KXY9XIh2Z24?=
 =?us-ascii?Q?ED/SbFTGwB+ZQ7RdP/y2e4S2mYFLivmBPtECZlAxDlTYMUxQrh6e5g7sQCRG?=
 =?us-ascii?Q?MCmg1rn0wzFap8Q4J2S0BDMYYIpZTfyg1uFlWmSapyoIYW+s9pz9n6SCtb3g?=
 =?us-ascii?Q?j80O+GUambVILBuOrFldAlnLRyAAcTJSSHa/YBUpbD5OfSsPXGMzNNeJNHgJ?=
 =?us-ascii?Q?wdETNqGbHlyu4tfCw8F1SXQa7xvxo72bVUl1GkC1deeaWO1OiShK/2YNubfi?=
 =?us-ascii?Q?s/8wc/qf/hC/92aXC2TmssnvkuR3fWpwn1OYaCksb+9Z0zmAjZ/5HAe4Ir2h?=
 =?us-ascii?Q?qns4FDE+GxohpOOHFxvqEVZZSgUGrNFDmIy38tICkvKhdqHu2+HUVvv703ZK?=
 =?us-ascii?Q?I8cEaE8vhPHyBodLhDvP+Kj21YdaHcevE6BBoOXk5h1nzCu0aE556d27mpX+?=
 =?us-ascii?Q?aakhXE09cMfv8kSD/JouwOxm3nMThI86RVrQfCvuIjLo2nSBag/Oeo2m1LvE?=
 =?us-ascii?Q?g1Z/dYGji0f+MglRr0gM3Ok3RjroQ7jlWWYTEC/aKVuAuTwr+5BmA4WShGjn?=
 =?us-ascii?Q?2dnCVDd1JdxTSRU4APjkJEItus9C8LZCeCPe1D/EJO63IM6rIkox?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d688a1b-5ec8-4993-c61d-08df2e5ecabf
X-MS-Exchange-CrossTenant-AuthSource: DBAPR04MB7272.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 04:01:17.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7SFr8loGo3+z1E4TcBTil6bo5mWbmU2hZdoyv4g6ysA2GaEsEva6QrTDx6kuTI6gFgREoaFgRdoQFAn0Pt5UJ10xMS097QVvLUMpAzWbLdzvdK2aN+w48LgCSpWkMkS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Tue, Oct 20, 2026 at 09:50:27 AM +0900, Yehyeong Lee wrote:
> nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns and copies an
> HE capability into fixed-size buffers without bounding any length. A
> response shorter than the fixed part wraps the u16 walk length, and
> header->len is used as a memcpy length without being checked against the
> destination.

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

