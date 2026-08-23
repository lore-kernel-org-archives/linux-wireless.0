Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011008.outbound.protection.outlook.com [52.103.1.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8981A23A6
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 04:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.1.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787458984; cv=fail; b=hNAFJo10758UZ4PHB/CacRn424T4DZOjS0+zVpe0YfsN/UFlA0tkfD5pEy4HpfElpop5b/DsOTS/GYKSySfwI3FYOIMjO0gPdj9kcRtomUy/nQHcbBUgUS342/GKeXZ5Qo4l6xcxkd7yx53ek7rPdUryp3RXvDQs9OlQMcaFyAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787458984; c=relaxed/simple;
	bh=jOJ1XyoxIFe6JNjBTJQ6V2mFzsfbfUK2TiROIkU1AXk=;
	h=References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:MIME-Version; b=AADjr5tBNr9Dm7Xht3EPDmOHLyUlA8GYhG7OZbpIWDnNXnuIHe8mj7JEOI0G0IlCLA6fdo3UOUfTPAex6e9YM8hHOU3PruXMmrpK/4Fef8WgHLUoqwqrwoN1AnFfWrD5HfddRxvtbdS+8XCwzHeayz12pkBZfGoVZX37MmlgMxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=Q2Nqy9m3; arc=fail smtp.client-ip=52.103.1.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="Q2Nqy9m3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tI+q67y6i0ykAs/kuGSgZj5Fsxbc4J5FPVsv0PD8pCWg2Ea22SoWj75Vb2tKmK6BQ1rL4Ejh+b/H1oLGDm4yultqTL8gWS8RPO1VTuHo5HTQ++85/ekxhL0iosnTac9MdbfImT//YlKlWJ5SmzJ9RMo5pZPkqa6P+mVgsOVY5aTpLuGs4ZeIdUSAOmsjzhAUf6roZ0uiBDZ+OMT4Un5W5f/Ch9vcFSFpDWDQ0hIfoIV5Q7Y07PotPHB01YpcCLTNYeZBDw7pZE3MU97eLbR6YDyzHYF8PIfWrUB8B0ocvSH0DfswLVwgME92lNCmgTuZMQouSJiEQ6gE3wyIlWadfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOJ1XyoxIFe6JNjBTJQ6V2mFzsfbfUK2TiROIkU1AXk=;
 b=FE91CFlAv3K6a/19e46uwmyE/hSjQ62DnJzmcaMEs+YQXB/lkp/kVKosZ2hF2UlNwL1MoVFbhBx0chITUp04d8hpII01fBwmI/Ae3m622jIxTg8XfpSkrJU1GwmbXDOKODGahprdFcvmE9+UOhqKrXPsFpnpdusQZvsRvr1mV3pvzgR7bhDuZGSO/NUyDB7fVU5ytXxPVNrcq2Lcu0Zp98WIe/R8A9th6Iac7co59GMhO/ZVhDT+oiF3SNIxCF/DVfhkMSFr9qie8Ik0UsvAWFOe49clFyKuLVdDtcpU4Q4Xmtr8E6LPsF6I+DxA3GGNKLKCGSsGiRSq6tjOTMWuVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOJ1XyoxIFe6JNjBTJQ6V2mFzsfbfUK2TiROIkU1AXk=;
 b=Q2Nqy9m3WrkpSIN2nJIs7GRYMa0EvrW3rQHDAl21dLXGH4jEbJVt5nRgdpjBeTAyAbWwCBiO/Qhc31wuIhm6ytgWP9GC6BGGUVyIx7qJyxIJR3xTmr/WysZpB8ycVn23y+051hm5sMkq3NOe6GkpIbjlfHXEStE2CnOw2vFzqq1b0jskxeSyIqshx4vW34o2VBYofy0XEdKeuWMU5gxozfz7yJpcPENVe1XI+tQw4yMp/eWxmq3KFZ5jFrm17tY2HFLzjnT4rrqzlNirYNOO+Xo31tNuK1taVDeTfe/4uLUSa6VhtC2xkUdMuaCrxa8lw/MnVDoTeXvbeuYYInA+cQ==
Received: from CH3PR15MB6020.namprd15.prod.outlook.com (2603:10b6:610:156::20)
 by DSWPR15MB7112.namprd15.prod.outlook.com (2603:10b6:8:35f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sun, 23 Aug
 2026 04:23:01 +0000
Received: from CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1]) by CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1%6]) with mapi id 15.21.0339.010; Sun, 23 Aug 2026
 04:23:01 +0000
X-Forwarded-Encrypted: i=1; AHgh+RqUFW5G2DJz1cNJ7G7WA5s5VaImGYagfmjEPoIaOHYuQsCCmsmB3cwEUsHVUEL77BYqF3fkzByIcdK1M4OnUg==@vger.kernel.org
X-Gm-Message-State: AFuF++myl9qu2tgZZ3Yb8aM1W7rRJLLRqlf65PnH9fhOSjByqRAwSfwi
	Ztekh9s57euQrzblWdncXEzd2HldJvCdGWmkdmSRvv0ttwC3Hl4LFpHnsahuIsKVSo/c/7pOUjz
	niwN76oEeM9U+MvZKj1luOC7i6GGCgB4=
X-Received: by 2002:a05:690c:6605:b0:7fd:4ef9:e5a4 with SMTP id
 00721157ae682-84c9ad37e57mr38079507b3.29.1787458501913; Sat, 22 Aug 2026
 21:15:01 -0700 (PDT)
References: <20260715044431.1207-2-mbc07@live.com> <CAGsSZgFqeNpPXS8q9VYGGqE_ONVCD-V18vf0+R6tZTS2PeKv9Q@mail.gmail.com>
 <CH3PR15MB6020E8912A56105D447332BEC8C82@CH3PR15MB6020.namprd15.prod.outlook.com>
 <a7681525-b5fd-4a34-8ba5-99e79d77a694@nbd.name> <CAGsSZgFetjvj69w6MELzMcXyMjD76SQJRey3_UW=SpvR3arSCQ@mail.gmail.com>
In-Reply-To: <CAGsSZgFetjvj69w6MELzMcXyMjD76SQJRey3_UW=SpvR3arSCQ@mail.gmail.com>
From: "Mateus B. Cassiano" <mbc07@live.com>
Date: Sun, 23 Aug 2026 00:14:48 -0400
X-Gmail-Original-Message-ID: <CAGsSZgFAP+mmmynpZzi19xQUA2B+G0PVP9so2GobAShc4EuFqA@mail.gmail.com>
X-Gm-Features: AcwNN1UQJ_OjBJCPrZDHwsf89IE1s4zjLW0leTnzvnyRO4FSdhmcjkFM0FG6IeM
Message-ID:
 <CH3PR15MB60205538E5911AC6214857BEC8A12@CH3PR15MB6020.namprd15.prod.outlook.com>
Subject: Re: [PATCH] wifi: mt76: pass LED define via ccflags-y in driver submodules
To: Felix Fietkau <nbd@nbd.name>
Cc: lorenzo@kernel.org, ryder.lee@mediatek.com, shayne.chen@mediatek.com, 
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: BN8PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:408:d4::39) To CH3PR15MB6020.namprd15.prod.outlook.com
 (2603:10b6:610:156::20)
X-Microsoft-Original-Message-ID:
 <CAGsSZgFAP+mmmynpZzi19xQUA2B+G0PVP9so2GobAShc4EuFqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR15MB6020:EE_|DSWPR15MB7112:EE_
X-MS-Office365-Filtering-Correlation-Id: a43efcb2-c912-48ab-3ec8-08df00ce37ef
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|51005399006|25010399006|8060799015|19110799012|5072599009|6090799003|23021999003|24021099003|19061999003|440099028|3412199025|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cytzeHRQckpYazR4cW4xQVlSNFNtbjJLVUVaZ3dab0FSdXVBblNXLytmZXov?=
 =?utf-8?B?VU1iMmJYSGdmYzZuNGN1REQ0VFBnODB1VitscnF5clFBdU92TGtsQlRNaERp?=
 =?utf-8?B?ZWNuN1BvaVNjZ0swVFdRdURYeUk5c2EvYVp0R1lVUysxQXl5Y05JaXpndEZW?=
 =?utf-8?B?TnJqRGttNnEwSm1ZdmFLUGtvQXMzVVRvQm9ic1VBRFdtTEJlR0RvUEYrV3NS?=
 =?utf-8?B?WHZjTUQ5dGFsZk1YczJValdyYlNqRFE0UkM2OEdrYkI2bFdueXdyUVJSVm4v?=
 =?utf-8?B?cmZENmM3andoUGtKcFpnbG5GVWNjdnJKS3YrcElvOFBta2x1RFYxS1RiWG0r?=
 =?utf-8?B?bXNENzkyV21qMHZEdXB3ZFJMUnU5MEdvZFhHVW4zRmVHa0F0RVhONXNQK2VN?=
 =?utf-8?B?VHFiS2JYZEVUdGY0UWJ3bFpaQ1hOZHVXSVpDVjFONHdLNjdGVUV4MktsZGdI?=
 =?utf-8?B?ZVp5dFlxZzl4MFA0bU0yUWtWMDJ5TXZZVFRzSkg4Vm5Id0VDTWM3b1pEaW9u?=
 =?utf-8?B?Y3I1QXlRdS9kazZZaWVQMFI5TFN3ZG45eDErWFdYT2pRei9XRnVyUzdScUhy?=
 =?utf-8?B?RFVMclVuZVV1dWNHaERMd0kyNVVyZE1ZYWt2SlZOSmo0RllkOWNneUNxYnlr?=
 =?utf-8?B?R1NsdmdEQmg0d29lUlFRK29VSk4xb2Vobng5Mnl2VWlyNjlWUzgybHdzYVpn?=
 =?utf-8?B?TzNPdzVmc0VpYmowdG53SExkR2VaUXkwcnl5dTRnZHNlRFY0WTJsNWtwZ0ps?=
 =?utf-8?B?UHRSeHNOVFRHWEZhd05KSXlBTUo4VUcvT3VPeklWNVVld2pPNkNTU0ZmKzBw?=
 =?utf-8?B?NmkyemVxZ3MrczNBcURkKzN5TUdPM2RJekpBZVoxb3dBeUNtYmcvb2hySXZx?=
 =?utf-8?B?cStvVTVlL0s3YzdYMmdhRlpEQ0Z2bHZwV2cyZjVkcklJWWw3OHdIa1g4L042?=
 =?utf-8?B?dkNQK3BhRzNXQnF5Q3V6UEFuMzhwSzRBY3FvckJsUVRJR3RLY1hRZHk3OFhG?=
 =?utf-8?B?bmRCUVB4clA3OUxkRWRvVkRPbHIwNnh4dEx4akFPOUpJU2tEWUtRU0RlQ0VN?=
 =?utf-8?B?N21IR21uVFR6Y2FkWWJQd2tySnRteWNrelE3YkhYMTllYmNjME9YSVJEbzFB?=
 =?utf-8?B?KzMvVCtQRFBrYlhRNW9UTC85bjBDNUl6QzV1VDI2ZVpXc3RxSmZVT0lkS3hS?=
 =?utf-8?B?cDBvOG5nSGJEZmJVNldtR0loZlBIblVrM0dMZWtyZUE0cjc1L1hCclVSMXR1?=
 =?utf-8?B?WUlvWFRvVGhRZVVIV2xaNGIydU9iYTBlelpBelhQU0NFNFNtUVEyS21Fd0tt?=
 =?utf-8?Q?xm8GPvi8ocU1hb/XMEdZI3KJW9imts1IIM?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d25rS0VOOGcwYlFZVFJQcDh5SFhnOUlPTm1DOW53ME9iR3luZ3NGSXhVY3l4?=
 =?utf-8?B?Zi9CWlJMb0VUZTBOdVoyeEU0bkkvM3ROalVFeVZQVDRNK2daUVNOVjl4cjFy?=
 =?utf-8?B?eUFMSWRWRGdjQS9CZDVVYzY1eHJYSHp0Y3FycWt0K09KdnJPbjFPWEp6ckpM?=
 =?utf-8?B?WmRuTHIzUGdZOGxCQWRBUzFhNlUvWjJlcVdyT3RmN0hJdDF3SXNLQ2M0RUJQ?=
 =?utf-8?B?T0Zlc0I5enJlSVVpeFJWS3RsTk5QOVVlaXlrVVVPeUNQc3BFcE1WR1VUak4w?=
 =?utf-8?B?bTlhMVRHQ2RsV3oxRzJ6ZnpIa3V5K2lqZzNJclY2T25PRVFmdnZUaEZMc3Fr?=
 =?utf-8?B?eEJkRWNQdWNWUmFCRGp6YzAvU3lqbnBCVWpjU1BqZDh2Njg3NGZxdmNLZVla?=
 =?utf-8?B?Ym1zcDNUWXBYQWdTcUZnTjBEbitPcE1HSzNJY0NtNFgwYXdSUW9kb3JVdHhC?=
 =?utf-8?B?amtha1liYnE4MGFESVFKdlltVjdvdlI5aHFqMXN3b0YvdnovNGE5dnpvTnhu?=
 =?utf-8?B?UURaTDNNYjl6bXNHRXJGMEN0Yy9NN1RCY3FnM3JlMnFBNjM4TDM4cXRsa29Z?=
 =?utf-8?B?Y1oxLzFUaG8wL0JMbGZlZUhLVmJya1JSemlYZzFZai9JN1RyeUZFY2RrRGlo?=
 =?utf-8?B?TkFvRUxGcm5LM002T1RSL2IyWXJyaEluV0RLeU5nMjZoVnlwQW5BWmdMWWI0?=
 =?utf-8?B?TmV2dHRRNUw1elNDZTlPYnI3UEswMnJPNUJlNlB3b1FnR2hFYmhxZGFUYmJq?=
 =?utf-8?B?ZEVCMytoM294MDN3TmU3b1pIU3hnSFk0dVJ2OXZ2THBOeUhCc0ErUXg0Nmkw?=
 =?utf-8?B?b2R0am1HOWJBWE55RU5kck9OSnpCZm82amNodU5IUmhlcjc5c0QxbjFtNGpL?=
 =?utf-8?B?ZURtZjZ1bWlVN0tCRTJQc1AzNU5OL20zMjJJc2dadmxVZDh5NnJzNmNvWlpE?=
 =?utf-8?B?MnNjbytPTkdUb2lEdjFMZTFwbXNzNEdjWGZ0MXMzT3NPQ0tGcFNSM2p1Vit5?=
 =?utf-8?B?RDVGMTBsWkErMjNtd05vdTRHNjNTelNZcGJBRldNanJUODZXWVBlNUp4cHNI?=
 =?utf-8?B?QVVwT3MxQnk3QUFBUTd1dlRPcEVUMk0vN2pjUldQbG5xa1RzL05WZE9UdFY3?=
 =?utf-8?B?ak1aNldJYzZYZFJIZUhNYjJ1N1FEcFhTSSsyaWk3UkpaRWw2SkV3T0ROSG5q?=
 =?utf-8?B?a3A3SGVPVzF5UWtSZ3VVT0xkcnRIU3NkVnQwNThGUG5mN3R1cWZRUVVNcU8x?=
 =?utf-8?B?MTRXWjdGVjJzcG1SQUMvRTZCK2hjK0Fzd0dJcDhDK281cjBxYU43TmQrU0lh?=
 =?utf-8?B?Nkx6ckJ1WXFYblQzR05PMEJGKzE5T0xVSVZVZC8rVW1WV0YwcEpvNlpJK2py?=
 =?utf-8?B?VFJMS1BGWjFvaVRNQmt2VWxpTy9oMldlKzhjbS81elRWUVk5VEpGZTRzbGJV?=
 =?utf-8?B?R1V2aFlZS215TDdKU3FSeThUT3lXenJTbXJVMi9GYU5uNFc3MXFNNGlud0h1?=
 =?utf-8?B?emNRaXcyd0xzVnU1N2dlblF3YzBSNHhKWDJZV0dsQVY4M3J2U3VBaHk3SmZH?=
 =?utf-8?B?cmFHbEs1Y1JmVnVEc2ZJV2l1RUhBMHNlQ3JjWi9jMksyQnU1eUN5M1I1Tm5Y?=
 =?utf-8?B?cjJFNlhwZFZSUEQ3c2g3dEpqTGxuWTh3VVIrS202eEpvdnZRUnN5SG93NmdI?=
 =?utf-8?B?MFAwWnZaNXJMVmNxb29vbmtWNjdXSVUvMGNyREFLMk9xaElmU2lYdmc5UHJm?=
 =?utf-8?B?bmQ4T3l3RXZIb2VvY2xBQVA2eGM5MVZkRlNuQWFrSXY4RmhOczRnZTRraEMz?=
 =?utf-8?Q?LkHUYm8O+KIi4lGpq1Zvgw7yTeT+jMaYWTUDg=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-d4257.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a43efcb2-c912-48ab-3ec8-08df00ce37ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR15MB6020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 04:23:01.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR15MB7112

For the record, this has since been merged upstream as of
c5a3bd91aa735b669618610d5f0ebfa5786845a6
