Received: from mx0a-0024c301.pphosted.com (mx0a-0024c301.pphosted.com [148.163.149.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911130C16D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.149.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795394; cv=fail; b=jiL5nJxyfm7xtXAIdjrZ8r48aD0q8gCf5QwUMRe1ftAGWdn/oQzOhhMUATD/7qeUrjK7sKou6wH6X7TNoXuHQy7zJU8ycNwSvdrWN57Ld71qRUmJRJht8XTMtnwCMjCP3iuWdWPa3+tJH/TitCazdUFcBQFbDBIDJMBXEFLjF8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795394; c=relaxed/simple;
	bh=TDs3+QiFbBxpzg7yMtaAg3gSFqQU9zAdNPz+2WhPCRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H8zDKJdbfw3HDK/iVqF3NDwb/dqBmTesJeI+f3lAxvDHMeUp4L9nLVFN1EzFcPHCoCvXtfR+Dwo42j0YUU/f44ZLOZCj/vQzILd4A/g4fcNM69gyYh3eGhi+AJ83gAyosfygtwBdVw7clhYxwXWqC/8ctBq/u7EL/Vf2OybPbs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=Fc2BFeVT; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=HDcRq3YN; arc=fail smtp.client-ip=148.163.149.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="Fc2BFeVT";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="HDcRq3YN"
Received: from pps.filterd (m0101743.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687DdBhi884493;
	Mon, 7 Sep 2026 10:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=I9e5839JAsOV59TAAYVyf8iP0x1czGy8V5rR0bLHhxQ=; b=Fc2BFeVTgUsR
	g1fVVeULjezTlqBiFORYANrbyLOck+ZBCGbZOM+Q1JfjaYFb9mF6t3gsYZ11ZEEp
	LVxfpkmlHW3b729HxkIXEWI9WwGJo0MkGZA5Pts/TT8Hx4yuVGAIrBzho+mB1y6C
	X5iBPWwgpRU+HVNiBa0yuhUgqdD4EDCigEa88Jjjrxw5bYf8trN9otjhopSD8eB1
	ySynCAor53E7F6mdSu/vmmgDFphmd4HwsizNyrvGcmXeimILChC6gG65F3s43IYE
	VyQ0XV4oN0+dn5J586Rc4LmyJA2ajPyMemhbDP2tWh+Pkut40Eo8HofmJulV5iNX
	47yevt48eA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023121.outbound.protection.outlook.com [40.93.196.121])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggfd8kfqg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 10:36:26 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVK2oQK1OcO1tcCicNBHfhaPTwULEVUiEp1ZriU7vQqsbnGkFi7oJGv+WbtoMjQYY8uE+9qaQtQRHNVmFhLJraFlx98Zy6mBFzmS+T8pDlR5Wb1ZVvbt2du4DFQVxx2reBkZV8iT1NelxVX3z60okJ5adtFdXu+8ZX+z+K7XFzex/nS4ow8axrXO5MSarjq5ENYEWVqY9n9xhj6qwAStVIeXmPCRMvxtSYpcl3pGoLLuZbc9l4heKCpc5BIWOGNR8QLVcbn0ON8D/QbMv8W+CH2T8u2kvDEaPNQcEU8bUmNlTWlKNN7yX8bRl08HahXmThkYXNIME7aP7OjFc/IXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9e5839JAsOV59TAAYVyf8iP0x1czGy8V5rR0bLHhxQ=;
 b=oVIoyFB6FhqZTRFQJDRjD9u0K1OCxY7L/ZDjxbSGKOYNlXq/R5Z0bLVcUabzVR5NlG1b7/HiqFWTWcqB9zD//Av8ykrHXOZ0xnNzZiws5I7EMZ5WzpQrc4N4JVWvp0Po/7bp/GtKREtydLcLUaVlayeODJaCOKwXwrHElvDegdlfJnKLDxIW+IdPGWrC1IuJhBGb6a2SpypqQq/qbz7LvmicORCQF5FIecLSeoRZiBpBzlBLDbhFi1SG1IS5626v4EiRu9FNkWQbidZ+/vw4/lXH9SddrFAZGxy+F0gJ2Q50qgBcGd8rKmIvqIMdep5BW7yh7hxzXW5jKqAA+aV3wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9e5839JAsOV59TAAYVyf8iP0x1czGy8V5rR0bLHhxQ=;
 b=HDcRq3YN0LVZ392G/+H0w05vOwxvSbW4Dy3ihSvyuRRmRr0c6vvwpt9o9FVkJZjkli17Junx6oU5z+VVf5cZXvAPEcCJB7z5jv6rPUqJyOrzh4sQ/qCiqUf7kJ8hY6pOP8Vu+uFgwWi182H6gPdkGnkd8U7U92QX8xKEmG9EEP0=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by CHXPR11MB9651.namprd11.prod.outlook.com (2603:10b6:610:2fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 7 Sep
 2026 15:36:24 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:36:24 +0000
From: =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: gregkh@linuxfoundation.org, Aamir Ahmed <elb12345@hotmail.co.uk>
Subject:
 Re: [PATCH] wifi: wfx: validate MIB read length before copying to caller
Date: Mon, 07 Sep 2026 17:36:20 +0200
Message-ID: <4736844.8F6SAcFxjW@nb0018864>
Organization: Silicon Labs
In-Reply-To:
 <AS8P251MB00014841C19595C74C545C80C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References:
 <AS8P251MB00014841C19595C74C545C80C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PA7P264CA0275.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:373::11) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|CHXPR11MB9651:EE_
X-MS-Office365-Filtering-Correlation-Id: 4543f9e7-0f0a-4bfd-a9fc-08df0cf5c60e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|23010399003|366016|38350700014|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zEQWgqykVU4mCR9qWIkVhpG7ggynFzLOSD+pG3XpDzIvEzq+qkAGCym4DANVnlGXB9EUnS9ywSIoeo7oddZH5j/P6nkdetnjd2YtE08czelAwUq7wUjB/PxltCQg9zD0nQfoQu9io63Sne+zQZ3wgA+ydloUyOYSeTSy6G/LUHJP3ysfa0weCIi+1QR29EI0JF7CCNzK/Xnk/6BLMxVpO9K9N73rRK9JlFR88vLDSRfrLag9FLTjboRAFjY2ykh954H0Ka0B7/A5fyyACvzRPJC3hEOQr3CzJlPl7dJQx1TbqicXM0iAbpdHO0SmTLkhKjqWqelQBbF9PMbJ8EF1w3X+qN5jRglviWD+oKFxA7F3wya7XxxY0vbOq/B2h9kb5uUcyTXg/e6KSvDeBl/k2lSWoEDcdaFsfvGEqS7/ZyQ3TxprqNOocayz0yQV/akpgGm1i90ZEUzr8h7rXC33NbUwwdRUADhmJGJmjuEb+iLwDd/X438GjEmNo7uJps1eLhX3i8r6O13Wlfh60MN2fdPXQovwrTI/+b3/Ex85colVHO6PTm9KDDRlm2ZQBnnBDIjvH2R9OZwGrZxiGgQ/9fmufLPCANtYZ/0M5WewdNraGHbtZ8xvjmD1hqKoBdVxQONc8fQ41lTY+EXfqmrbjYeE6XBs80NGKeWJ7x79ADi2SNxWGrCYiuEsIUWYi0CsAisdrC8lZcxcp/w4biyifobAJFQXVWSf14qvN+Wcju4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(23010399003)(366016)(38350700014)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wmprdk9qeGhpdFVlM050S1hqYkJ4c0VLYXlCVnZUMVVCb1daeFB3K09iZ1NT?=
 =?utf-8?B?aWpIVy8zbzdDazd3U3plMkF5cGoweDhNcDdsNC9Jemc0VUREYWM5TmUveFJX?=
 =?utf-8?B?MTMrQ0ZwczUxNzdNL2lyekplVWROeFhhUnhnQUZhT3UreHQzeUF5VU43aldt?=
 =?utf-8?B?bys1enFJcnhMSzhMY0lzWDZadmpEMUlXbm8rQS8yODY0ZXZlQ2M1TGhBZkxS?=
 =?utf-8?B?ZndmYVI0N3lteVB2dXczdk5BdTVKYmJiUmN2WllPTjhCR0pXT05qTDlsVW9u?=
 =?utf-8?B?aTR6QWFEcUQwQ3JVR0RBMDYyQklkMjkwU1E2VDJrK1dYZFZxMkVmL1dSOGtU?=
 =?utf-8?B?ZEo5dFJIdHlVd2NNem1DV0pRTDdtY2FHcVJyVXViSi8xeWJVQTBtS1czUWJv?=
 =?utf-8?B?TGZlK09pQ1JKZW1USVk2OUJOb2N0Z2JXM0tsbU9SaXhkU0kyb2g1UkxUSE15?=
 =?utf-8?B?MDJzUVBTOHUzUTRnMEMrV2VDekRLT1dIaXBvRWVBSXN2Y1FiMnNkQ0ZGdS92?=
 =?utf-8?B?NFFKS21SYlMxaWNUUG1rZVA4UTdWMC8rZUdTMitzWXVTNWFmcUtYRW0vUTBt?=
 =?utf-8?B?dVVaeGZoKzM2UkZ5cUkxQ2tXc3d2cXE3RTlXREFVOXU1dklYM1Z4dTRKeGF6?=
 =?utf-8?B?ZHBBYmZSRUxSeU84RktER05rTGxPdEx2MGtLK0JsZE9DOXFibXd5MEJtLzk4?=
 =?utf-8?B?dER2ak9Iemhka0txV3hzdk1ndm1LRHUzWEUzQSs4WEM0bnVEWXJlQ0I4d3Vj?=
 =?utf-8?B?Sy9YU3NjK1lTZlpxQ3RCMWozZVY5cHQ2cDlnd2c2ek1VT0dGMGhUMHhEZndU?=
 =?utf-8?B?VEI3Sm1qdWt3Q2s0YlhwTmVVMS9ST1NhOUZPRThYQkNXbTBOeWg5dmVlL1l0?=
 =?utf-8?B?WGxtNW1USGtXN1g0S1N6NVNnczJJVHlBYkExaDN5TUF5Uks0R3UrenBJMnFW?=
 =?utf-8?B?M3haN3M1djBlZkFiZFNSRkVlMm1hbU5qWjNRQU9Ma0RwN3gwaDhzaEdPRkR3?=
 =?utf-8?B?K1d0OEEzVXBZSzVNRVJweXRqTW1IYUlZVkE0VzFOZmw0bXlTUEt0Z3ppQ3ZL?=
 =?utf-8?B?MHV4d1RIOUJ2d0t1VUFRRVpuejl5UHJRN1QvUW50S01YNVpsaWdybk8wMDZG?=
 =?utf-8?B?cVBCRXlJOThxRWlMZUcvMjh0YUpyQ1hSQjVsOGJmL2hVY1lTNDRkUy9RYzk2?=
 =?utf-8?B?cURQK256NUlzNzg5YzFPS2lDdlJRYkkrY2MyMmRwNm82WFlQdTRlZHVaMGJC?=
 =?utf-8?B?Ulk4dzUrbmdsOFNib2x3a2hmRFNPaWxVSUlaTjcxTUxZY1Mwc0hNVkZjOVdT?=
 =?utf-8?B?bjRWaTBIWEpJN3JWeUdHc21rRWU0bDVUMFp3L21rOFpGSEd4M2NJVGU4MTU5?=
 =?utf-8?B?azhtMWUraWhidm5GY3RoVEF2dlNRY0JPd29DQXNjRm5YcFJuZUNJd2tiTHBH?=
 =?utf-8?B?c2d5K2NRbE03QjZreWttazQzVDEwNmYwQ3ZIZjlkalJhS1FLTHNvYzNOT1U5?=
 =?utf-8?B?UkZURExNRWluWW5YcXhWU0x2QVJnRXZlc3ZJc1RVdlNtWTExUE5VUHBlemN2?=
 =?utf-8?B?N0lVT1A0MnROSFgrbUxUSGVQbjBrb215aHk2TkhFZ2ZBL3lmN0lUSG9TUDB1?=
 =?utf-8?B?WjVjZ0U5RlZDRHl4c2tUTWoxM0VxVzNtb3FuWTNkemJZZUcyM3hXTjFpeFFj?=
 =?utf-8?B?VDdRLy92T1FSZ3hQUGRBUGVZb0MwUHd6Q0MwQmsyUDdVSDlKQTV2TEp1OVJo?=
 =?utf-8?B?OE5NajR0dVdjQ0xxTm1WRU1uR3ZjZ2ZpVUkyTDk2TEtJQXBlVC9RQThPVUdC?=
 =?utf-8?B?WXhBNUlkSlpIUmNvK3k3Rm5SdDZWUVhiOS84MzVNKzNtMmFDN29wb3haV2xW?=
 =?utf-8?B?blovcEF1ZmFHM1A4ZzhndFptbkNtTVd2ZyttdXBPbkxjai9FRFFOczh6a2to?=
 =?utf-8?B?d0NUWEJkUTFBbUF0ZzlZTm5YWCs3ejRiM08raTh1WnBvOUVzYkQ0RmpIWEF4?=
 =?utf-8?B?MEhIMjJKSjJnNlNaRmo0ekNkZk5waDhEMjVPRkZ5cmFMVTl0akVNTGtyeVRT?=
 =?utf-8?B?QWxHZ2tBMUxpeUUyVkhEeXV3a1RveUZ0TCs5UWRNZ294dWhQMUwxdnFjcVo0?=
 =?utf-8?B?L0lXQ2RUNlhpRHlabTlWNEt5ZVpsOE9vSnFOekhtZmpzdk5pNTZ2c0hrL1dB?=
 =?utf-8?B?L1h4Ujd3N1BIZGQvM0JGVzdCMndTRTBWcDUxS2U0QW5pQ2hGUHBGa051UTVS?=
 =?utf-8?B?SDRBVnlNWTI5QVBrbjBXZi9tUHNYTHhyYVN5NEd4b2VOS2hRb0pHVUJPRk5o?=
 =?utf-8?B?Zmw1UjFtMFNKMlBZdlJFVlhMYUpwQTdvN282ZE1DbVVsTkU3cGJDQT09?=
X-Exchange-RoutingPolicyChecked:
	n4ZOjATKc8eZs8K+HawQ0EOFrEqTgWXDNg7BacZp3UqbNhow5pm6wIke86prdLlni5Hy/FqhCMSXJ2IJVMh+mYVfv2QReTgDDxXl8jLlysrxm081aNFob8158TFkLRnw0nnXcdKPKrE0eeIaI2gPTdwid5MCS/qrSolc5l0UKmsKkZjeciUp+8i0lnyjtbUrE0KoTK2urHl2WzSePakuLg6sSRshwdVJkPmafre79flvEehhsTGoALak6ptdRy+XYTB4POqLCeell9o5Va/3BtF67fZSWkwMmKco6rEDV+RvSB840So+u49KL+15b2Z+1n1NNw6IdemKNAVMMesVIw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4543f9e7-0f0a-4bfd-a9fc-08df0cf5c60e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:36:24.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWiv3Uut/c9C1QxGQPLGoMA3aG9NcsQVj2MSBhhOyGC69X5ahwnnrIm3KAfSTH0cczc6Y9FGd4Xscz45DVpx+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHXPR11MB9651
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE3MiBTYWx0ZWRfX+S1l7mTn20+U
 jXloiPaLMWR7AQBkIZWYQnGrxhOXxD8vXvwGjDxlFg/5LaWKcRMN/2Pgwoz6fY8dYKLjlDs1R7o
 VtVAJ9DlaF+XYz3D5DA4ef8LboSHLfs=
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a9ed9fa cx=c_pps
 a=ZDePlyM4ypdfO5fYno2TiQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=6KgOrB_2K63Cyhqxo4vW:22 a=Zo5euW2OAAAA:8 a=MZ-vaWmsU8g_eP1OPOoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: F3xg3iWOzbjJ-cfK8iMlZ4rshNlAMryt
X-Proofpoint-GUID: F3xg3iWOzbjJ-cfK8iMlZ4rshNlAMryt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE3MiBTYWx0ZWRfX3OFsCRLKWEt6
 fMb9M/ufBwe4buqUdD7k3UqaLNoXYGdJN33GMHL60GxcDFZboMQ8B5NSmecNd2iWXisLAYAp9Yq
 pbUdq+5cfwUy//3Drm0MsV/vUG88N0RXeTd5lMCGaJV2fOLV4B4V6l9HyYih//lk8kUcnD1FxZV
 rBtiF15BWxC18S+kUcn+B8SdXnoGaFQy9Cd1OV8tglIe/c81KK1acudMr/KUBIwAdIY3tw2DVQF
 kjwNaUYtQfusQHgMVXsYzIp281lYXtut02OcW2G/OhjaLmLzq4dQtenHt9NoTMyX+jIm+dG3KdY
 sBj7Wh9JjTE7MtbJhbSa/nEUi/ZBfkjq3JOqL2hjl6NRStmmgyEZicKgXcehHlgLX8J92arKB3P
 mN4l1LG+rwIfwjrZC6EfD2CHP8oNcLKnirFQk/4qvOB05N8YcZ+83zmdhjdHbI4HZxVSsTNjjED
 op6RrmML7rWqx5cj+fA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_04,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070172

On Monday 7 September 2026 05:17:57 Central European Summer Time Aamir Ahme=
d wrote:
> wfx_hif_read_mib() copies reply->length bytes from the firmware
> response into the caller-provided buffer without checking that
> reply->length does not exceed val_len. A firmware response with
> a length field larger than expected causes a heap buffer overflow
> when writing to the caller buffer.
>=20
> Replace the dead -ENOMEM check with an active validation that
> reply->length fits within val_len before the memcpy.
>=20
> Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>

Note you should add LKML in Cc: of all your patches (see [1]).

This kind of bug are typically spotted by AI agents. If you have used
a such tool to discover/fix/review the issue, you are supposed to
comply with [2].

[1]: scripts/get_maintainer.pl
[2]: Documentation/process/generated-content.rst =20

> ---
>  drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wirel=
ess/silabs/wfx/hif_tx.c
> index 9f403d275cb1..a6bc1c522e3c 100644
> --- a/drivers/net/wireless/silabs/wfx/hif_tx.c
> +++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
> @@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_i=
d, u16 mib_id, void *val, si
>                 dev_warn(wdev->dev, "%s: confirmation mismatch request\n"=
, __func__);
>                 ret =3D -EIO;
>         }
> -       if (ret =3D=3D -ENOMEM)
> +       if (!ret && le16_to_cpu(reply->length) > val_len) {
>                 dev_err(wdev->dev, "buffer is too small to receive %s (%z=
u < %d)\n",
>                         wfx_get_mib_name(mib_id), val_len, le16_to_cpu(re=
ply->length));
> +               ret =3D -EINVAL;

I believe -EIO would be more consistent. Otherwise, LGTM.


--=20
J=C3=A9r=C3=B4me Pouiller


