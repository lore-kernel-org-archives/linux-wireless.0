Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012036.outbound.protection.outlook.com [52.101.66.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEA63C4176
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189106; cv=fail; b=htJGK3B5toAEtM39WThllAM/7X9LRLZByWKJ/oOGiTS4FCSa3l95fri666O75d3s4LiVNI9y1K15ufH0m2V4VJ/5uzQvVFF0bepww1EK+LOhAe5qomZdhzZxmdCV51aIyIHn2XBleW3Fvq/47B+WEHZsfXySo9KrrnVzWcTOPcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189106; c=relaxed/simple;
	bh=aO5Jj3o27Uw7SF1euosf4Q5+emJRRyjfQHKPyXWkuBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SKd6rfqSGTL0i2w24jSD7Pm3dS5PSSDkvh1AFfqj8B3nEL7JDUwdY6zmLPG4B2CffUHTsGgVdeqmJGTm+aKLXK/KSaaNddc+7suDcautTj1Mecmp1ol3XeKplV9ZxWH0+Kn4xX/WTLJmG8Ezn+y3MMJMHCnlBMKYHRxOEMgZDf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=nNquOgTD; arc=fail smtp.client-ip=52.101.66.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="nNquOgTD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrDKoGc0YJFd7xgujIUUZ0iCWlYGhyb0H1vs4Xor5x+h5LSIAczw28PVU8kL82HUoE9+GtUHLIWY4ZeZfdc09LgnZDZYvNbNJBygKiQnhvKnNIXmgEzW3yEqla0+cvJw6zFqELhoZLSzIElMdTaWyLFRtfbt1YS+9ZT6HCBN0PKQu2Oh6TkH8T+wEpISrhzQEugIwzJftcLtp99xH/Q0jVW9yd8vyUPnZdgY4MskszeSFkBmfOAB43804ChW3DPHForpEyVD94pvpaB/rNUvTotIvSF6s+L9BSxsFF/aqlWtc8ZFmpf5BGnDGMDULDRBiG3Y8RhSfwXqFNaYw/6x6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzOg86OQafTaG2Nlwo1CrRayY9VjfkrZy5s0wzZli7o=;
 b=HHtN5/R3K4BFemSlQ84A+ExA447oZ+N2ezx4YlbU9qqV+h+9ASi63zcxszdeir5dz+l39DsumrKG/vHkKHhF1SrrYPLUTF4kj8zHBSyUWZElIeO1+NgqfA6R+UiJXmlfh4HPnzB7emTAeb05FUlEmlUIyAUXV1LLdNz7MYH/TmgPKuum8kNcsDCT51pZNZyBZF7tSkolgU4yOvIr4fGNJgX+vZy4Vp4RzCGLNRXhUWlR56YfC/qHBWN0PTcBs2jvFUXKqbWPcjorIuqUYFeS4QQznslY89L8XxRBYvzoPqbKl0Vs7+Zq3YlVK3MaKCYUGg1ARcsrV6SHOmF2+Vn+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzOg86OQafTaG2Nlwo1CrRayY9VjfkrZy5s0wzZli7o=;
 b=nNquOgTD1gLgxpeZHCtaw9eCXUt3wNslw8f0exWlLZphEblCo2mWFZ4DoACsZSUIkn9IxL5Agv58o1kG+ZkU1nF9/uRSTs8xUQUCg4J/WihO2d1xWYLK3tb7FdNE1EmeaW53WXlkBHVHdXKWhTu/2IDaWwgCyFu0LBDZCwnFE17KhTFPvZHdLRc/1SuojhSchqnSQMQp9qOL/cKWWTugjDmrPkP8mtmAeI91gudtaKIFpbNCOyXKf4J/OV+M+FnhoAQKpw6SGlScfwL8Lbt4RGD/nqXd6wkAYh/4dMcTVoB79ZBPLAPHdt6yf+3gh6V5FnLt6x3Mt/RkevkJAG2IcQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AM7PR04MB7174.eurprd04.prod.outlook.com (2603:10a6:20b:11a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 08:31:36 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 08:31:36 +0000
From: jeff.chen_1@oss.nxp.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com
Subject: Re:[PATCH nxpwifi-next v3 1/3] wifi: nl80211: vendor-cmd: add NXP vendor command definitions
Date: Mon,  5 Oct 2026 16:31:21 +0800
Message-Id: <20261005083121.2876637-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261005054414.2874415-2-jeff.chen_1@oss.nxp.com>
References: <20261005054414.2874415-2-jeff.chen_1@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0018.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::28) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AM7PR04MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: a143095c-c06e-402f-49c6-08df22bb11a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|366016|1800799024|6133799003|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	4r0lFwipssf8I3eiG6z2JVvHiMooleF/tyNIneurVQw+ewwE0QkCsPMgeOmaQoXdKnUK4Ur0RRXWjqNYJJ4oS5RwXR7DAgmmXv4Y3sPwwMqdCEbfet5NStukf3CA+Pwzf38td2j4k6GpieZB6+63wP9XCXV3OnfKmz/iF0QUknh9CC+rBciEsrGRDsji8faxBDb8wlnLRFYQK5lEVwYFkQ2BjFgeTMtz/IZyeDSBVGR3MPmTXTojOGWu73cIP2qsdlNjCiaO7lzAF63mtGUeYXhEUXYj0ETI1KNKHByf1akRalabJDsR2GHobDN7pBrW5ctW3XWBqTLtbVrCVPXp5uHfWVJyz1At+Z+yho2Pt463HXp1qhsSwExDC9eHSAiYe5g0HaZ6aL3gPCojKOCmybXVV2rmBjESonBu9gxfIIlxCA17Wkq6qeRNVTiLVagJovCDtMOdocyhMesYMh7oEWVLKmJGju72FnnlXpMvXw+2dVX8rMe9DLIZWTiEaYETxxATkrfx9qsOuKSImEksNOEcY+eRTHH61acQpk8fUA21ePeKi4rnfiUgln4Mf/MfxDphyKrPxuMmv7DhOmO2Pn9tGiJs+IcDAAxD1cvK8lNR1vaUgO0lDFT+qF+hx+aoU2uIgc+WP96bogQbAP4/B7NYOe1Ca2weE1xZ844ikGE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFVnSndRV29uZ3lWY0xrLzZVQUEyZ29VaTk5ZDIrZmkxcDZaWDJUVkFSV25z?=
 =?utf-8?B?NEwvRWc2UWIzdUVWNmgyamZTY2dzeXVTNVJCY0paQ1FvTUFaSGNWeDFIMTdy?=
 =?utf-8?B?ZWVGZXNjRmxBQ1pIc0o5OGk0YmNMd2s1Y2xLRCtoYmNvVlBDcmVXL2tHYnQv?=
 =?utf-8?B?bHEvZWNwbkpjRTdQK2NpWWJNNjkvT3hIc1RXTkc5K1JxNGM0OTIrRy9qcjRv?=
 =?utf-8?B?WHlJWjZnSkY1cmxXWEFhZE12ckFZYmtWWVJlR3JNMS82MEZVcWc4VG4zWmQv?=
 =?utf-8?B?V054WTNzN3d3SWZiYlY2VTJzbTN1Y0d5ajNEeW1UM2E3NVVmMWdpM0EyeEQy?=
 =?utf-8?B?UDZHNm5pZWVTSFc5OHNFbVlvaGZ2YTBqdTRkcHJ4MDYvcnQ1MUVCTnUzUFNB?=
 =?utf-8?B?bGRJYXlHT3lXWC9YZ29EZER1T01qZ1NuT1RvdWMzb2VEQ2pKVEJPYzJUd2p0?=
 =?utf-8?B?UkZ6TmxHaVJoN1ZJSzlxRnBzamFmTVlDcUY2YXhDZXMzVElRZzFrNnZRY0ZQ?=
 =?utf-8?B?MmhrSHJ2aE5yREpLeWI1UFRYaFRrRDhIU2ROOFMraGZFL0VVdGNnQTZENW5F?=
 =?utf-8?B?Y09wUXZ6N1hqeUV3dDd5QlJxejZMb0ZlWjgxS1VJbUxvVWVXZXdDVnA5elIy?=
 =?utf-8?B?Z0NOcHo2OHU5ajBzeUR3TGxPWmhGYi9NNUk3MytXbDZKQXVlT0pDSUM3OGF3?=
 =?utf-8?B?YXREbWRMT3dFM2s2Y2hEUnh5U0NtZUppWHllUGFoNHlOYmNFeC91SEM1bUJj?=
 =?utf-8?B?RjBZWERYRmVQL3BSSS9ZNml6cDNEck1wMU1jRUtkeEhjOGNSM3poRTliZ0N1?=
 =?utf-8?B?aXdESjY0R3lYb0tVZ0tHWVBMRlVWUlZnSUYzZlY4Ly9mSG80ZHdxWVFEaU9E?=
 =?utf-8?B?MkE3RERNLzY1R0pYWHBmQlAvM1ErNzBTNjV5bEdxcXZiUGRxYXdRY3lVbWhY?=
 =?utf-8?B?QTZneVBjemcrSFU5QXNpRmp5Z1lzL0JyK25FR3ZYdXZTQXhlYUdOR1NTaW8r?=
 =?utf-8?B?b3BOU2F3OEZ1MkJDdFJHTzdwOWp0a1l0Y08xRXlyVGU5Q0JTdFZlUktqb0Zm?=
 =?utf-8?B?endWOWJGMW0wQXdwZGRFU0k0TnJPcGtwZCt4YjZOblU1Y0NPcDYzYWhZU0VX?=
 =?utf-8?B?QmdKejhCVUFMSlkrd1VOaWhXSElDOXhGMDV0QXQrT2hldVhtNDEzMVlESml6?=
 =?utf-8?B?THZVKzhWeVFmek91U3N2K3ZKMndwUlRPVVA4bWtOeGhGWEdYaXQ2SllLUVhB?=
 =?utf-8?B?cU43TVRiaFdqMEE1NzNGRFgrc0ZwV3JINDZpTDNPakZvWmt3K28wYTJVamdQ?=
 =?utf-8?B?bDJrMkRYdnFkK3lDN0RxRzk5LzVkY3hlL0t6bWUxVDE5VGJnZmF6WVFZSjN3?=
 =?utf-8?B?YklJczhBQnJ2aUtwV1lmV1JkVUEvdnlMOUt5WkNKMHBLQk01VzlHZTFvdC9P?=
 =?utf-8?B?N1FSYnR4eWxJWGhZSklZaTJwdXdnNUVJcUxqbXNJL3U4YWtORGY3d0xzcGRL?=
 =?utf-8?B?R25McjdlMW9KRzVlVXMwSEJ4NWc4YmZ1aEwwM0IzeEc2YWV6M1R5WlZQWHA3?=
 =?utf-8?B?clVteUpQbk9XZFY4TnpqVlRSOHZQZjNJV01UTDBMamI5djhIYTlsTU1SRGVl?=
 =?utf-8?B?bUl3QlJTYzJPWklrOVdSTUM0NGU5Y0dyZUo0TXlrK3J4Q3ZqMjlCdnpMVlQx?=
 =?utf-8?B?MEtTMi9JamFhd3lCUmRBS2hRQU9RZmNTVmY5SkNyWlQzZk84VFZWN2lkRlNN?=
 =?utf-8?B?dmNkUWVLR3UwQzBHVUtUVm5DN3R1VTVQcC9STEJEZEdkQzdLdmNHMERHdEZS?=
 =?utf-8?B?THVmMTFUU0o3eE9nTFBvcTlmUllxSDAwT2lzcmRVMnE3VUJUNzhXbFV6QWhV?=
 =?utf-8?B?RW0yc2VrOHlOc2xxclJoUjFiNW9LUXhNT3VIb0pNWWJwMFpnSVYwZUZrM2o5?=
 =?utf-8?B?L2k2T21OV3pFaWY0dEFuNE84Z2l0UDVyaWI3cEY3Yk1taE55Y3BKOVFJQnF1?=
 =?utf-8?B?cm43Qy9MQlErazI1MldJOS9BdUVtN3BncldCYy96OVhMdENkdUU2Y0VJQVhv?=
 =?utf-8?B?NFdQaGNpSGxQeG1XV2VneVpxUGFNNFhTcDQvdkRqTGJ1clRxK2pHQ1VZMjJn?=
 =?utf-8?B?ay83ODhUQ1ZqSXJhYTZLcUplUS9iQ1A1Nk9RcFdvcEx6MWl1SDZTUWRmMDhI?=
 =?utf-8?B?VWtlMWtpU0dsSU1LZnFLb2txQlFYUkRrOUQ5SGZtTkovNFp1NkJnOXpJQWor?=
 =?utf-8?B?MUFQNi8rWlZ0N0ZvdVBPcmphOGEyd2o1aTRic1hmcGtvcTJJY3JCWDBIS0xo?=
 =?utf-8?B?ZURRMEgwWDJaRElWZDZZb2hCc2ZGVSt1N2R6YVZYaks0bW40TmI0Ynh0eHAx?=
 =?utf-8?Q?Q7cpeP1k0MftgnkcVeVDU37oEE9irH3s6k00/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a143095c-c06e-402f-49c6-08df22bb11a6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 08:31:36.3044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0SEfcZ5xj6qPHayRFaYCM7OXm92kJVcNMWXTD1oRv4f/X/so/6iaS5xj/H60uOaRHrarvtWiNLFf9h3alKEYNzzsAG4Yks3yyfXb2PuxjygDaA/dLiNFJSq/yJIWyAd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7174

On 10/5/2026 1:49 PM, Johannes Berg wrote:
>> Example use cases include:
>> - Reading firmware TX power limit configuration for verification.
>> - Updating platform-specific TX power limit tables.
>> - Supporting manufacturing, validation, regulatory, and platform
>>    bring-up workflows that require access to firmware-defined TX power
>>    limit data.
> 
> But ... none of this really needs full support on every production
> device, so it could just be debugfs?
> 
> johannes

Hi Johannes

Sorry, the examples were not very precise.
 
The TRPC table is product-specific and is typically provided by the
module vendor or OEM. It depends on the RF characteristics of the
final product and may also vary by regulatory region.
 
This is not intended only for manufacturing or validation. It is used
to read and update firmware TX power limit configuration on deployed
systems.
 
I can clarify this in the next revision if needed.

rgards,
Jeff
