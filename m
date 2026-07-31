Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011056.outbound.protection.outlook.com [52.103.14.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B152DB789
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477069; cv=fail; b=iMNb6o+8QsGDCftaCaZagi4HkFlMy+Sp3XA4Kg8uPZ5dAH2q/imEaQX2MfGqIrtIO9/raw/nA5aO8e4QKvn+Y3e76J8njnQqpvBhShQZnLjr3dGx1oJHGRaiiLaqzwh2VPnvSrHUrQlva8Ki7ZNkT5bT4muoNAMdHJjtR9GtUJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477069; c=relaxed/simple;
	bh=RFksZYSkXTd0uiZhqAEjcRH+JjaeD1z1ZAqsbf8XdNU=;
	h=References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:MIME-Version; b=CtxvVOtZ20iioreOg229qvsnVzjK5vygMmZkIqvcH72Xwhqp7vuaHSGJv81LXY7IV//4PfVdLyQTov69UBd7cPlgqhpFsd1m42mMnoFRq3ogGYEMdT83yD9ecSPv4lvMKoMn0NTGQWxmVZTee34cqs15MsMas6TJLPq9VjmIfW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=qkNlLeUj; arc=fail smtp.client-ip=52.103.14.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="qkNlLeUj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BaM0NtTG7P9gSR7e80botpg+OyxfkE04ndZGFKdmXTBpLnqQZvbGdBUCWsKIJa3kjK57o81egiLWRlmhT/2T4h66zim7RnIzN8eUyOVGnnQrc5D9+Z2Y7rikJgDJvlKTcR7hixq8pFU4krMqZtcwl1o6kn4iFVE9jZNSDd0EDmFNmv+czaPhk6yLU0Tv9R1CXJWyTOQkesxbBrBYbCeyJdmjDy5ebco2whKCifxKb/qT9wLivYiMauqNSfecS+fS0I5rK+vMgkVf+a82CFD3kIEczpu3Y6DYY4p7A3dwbd20s1ARCgQChYFQTYZlM3RJek0TXrZMhWwnPS7XX74X4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFksZYSkXTd0uiZhqAEjcRH+JjaeD1z1ZAqsbf8XdNU=;
 b=Nv+M0AXliDtFDRA6R3m+jBQGklURLafCNA3tm/joVTgF23NbpNp/4ahm+IqJiUWIo/jn0TY79pnXpsD5BrVsiZUMGNCqaEK724vyZkeRq2dd6hc/mrX6PZW2B/qam+HEyXShWVmG+VaXaHowILaKcQS7MMwFKnFgoo3uV3DLAoZTJDUmj03wE05fTjf/WX79FFEWmuoAoCAwTK7m5k21qTZoJYb9LagFH1FQkMnqm7c5JETGovzmQo7zfNBU8OjW9rbv97hbKcdVSptTVsoBUCgmGrjMwN1tDKz8kPZnuRjz4EkKQNB63DALX7dDxhS4TahwMm1MmSX8JkBWzrWT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFksZYSkXTd0uiZhqAEjcRH+JjaeD1z1ZAqsbf8XdNU=;
 b=qkNlLeUjnX0gEQTVwmhOCek79EEPzxTAcWhgRa+vYbhz/Qvg/y+O4Y4+6gySk1oiABEDbrQw0aYVHdS2mbjMsuHhQOfSNUOYC8xGG47sJYFObuyCUp9uVQPeYcBH8LgEuNYfyDodcWm1KOGW+7ZRGxNvcGJPTe0P/Xs9uGEgHFAxUL4PWNOBKmQQgVWSzoxHSUeoczAcdT74V5Z9jPK88V23VEUc5CaDPLQ4IwXel/Ie3XuqglhvBCqz4EoNT4Jv7BF9gisHHdekfyxKsDKPGZ0OlDGB1mH8MAJsRdzHR3JxuakpJJ/fRR6YwBkGWpPwzZF0LBbmX8hviBH8Nm3oCw==
Received: from CH3PR15MB6020.namprd15.prod.outlook.com (2603:10b6:610:156::20)
 by MW4PR15MB4636.namprd15.prod.outlook.com (2603:10b6:303:10d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 05:51:06 +0000
Received: from CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1]) by CH3PR15MB6020.namprd15.prod.outlook.com
 ([fe80::a655:4b65:19a2:85c1%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 05:51:06 +0000
X-Forwarded-Encrypted: i=1; AHgh+Rpwy6Xv94Sl+DE8O2Rb5xSNGJbH+38Jkvg4hvxx6z5tSsJt3a9HHpz3+2oEYUjRVhCsHsptrW1dttcZRiY5pA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJ3daVmaa7mD2+KtfJ8AvcAMlGUbgXfNtfbwET6zhAdGHa0CV
	aYGvvQ2cJ5Bw8YCdHvZRZaYA0FZMA8Ixo3fUzu4u9JSx50aDBvFSH6oypI3UxwRcpgTrbUTQoPq
	p/ZZtHOBZPuM63MLsmTtsXzj8qdNHYXA=
X-Received: by 2002:a05:690e:4544:10b0:667:db13:bdc1 with SMTP id
 956f58d0204a3-669484c1c53mr96701d50.9.1785476623809; Thu, 30 Jul 2026
 22:43:43 -0700 (PDT)
References: <20260715044431.1207-2-mbc07@live.com> <CAGsSZgFqeNpPXS8q9VYGGqE_ONVCD-V18vf0+R6tZTS2PeKv9Q@mail.gmail.com>
In-Reply-To: <CAGsSZgFqeNpPXS8q9VYGGqE_ONVCD-V18vf0+R6tZTS2PeKv9Q@mail.gmail.com>
From: "Mateus B. Cassiano" <mbc07@live.com>
Date: Fri, 31 Jul 2026 01:43:32 -0400
X-Gmail-Original-Message-ID: <CAGsSZgEN=OXW-fVNub4tCJ+bMmpOC6nnXKC00+fWSi8zhvpkiQ@mail.gmail.com>
X-Gm-Features: AUfX_mz9I0vGiOdLuzgsgzbhEV-n_RKf1RB1px9tdjzSh8sTyOzo_MT74_vt7c4
Message-ID:
 <CH3PR15MB6020DECF2DAD37D6A5DF97D1C8C82@CH3PR15MB6020.namprd15.prod.outlook.com>
Subject: Re: [PATCH] wifi: mt76: pass LED define via ccflags-y in driver submodules
To: nbd@nbd.name
Cc: lorenzo@kernel.org, ryder.lee@mediatek.com, shayne.chen@mediatek.com, 
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: BN9PR03CA0848.namprd03.prod.outlook.com
 (2603:10b6:408:13d::13) To CH3PR15MB6020.namprd15.prod.outlook.com
 (2603:10b6:610:156::20)
X-Microsoft-Original-Message-ID:
 <CAGsSZgEN=OXW-fVNub4tCJ+bMmpOC6nnXKC00+fWSi8zhvpkiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR15MB6020:EE_|MW4PR15MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 12418fea-450d-40d4-b75b-08deeec7b5f7
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|8060799015|19110799012|15080799012|51005399006|24021099003|5072599009|23021999003|25010399006|40105399003|2607281247196008|3412199025|440099028|19061999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGxiakRQU05jWHJmQlpWZmxITm5FcnRoeU5FRVFiV2c4MnV3emNPRnhoMlc0?=
 =?utf-8?B?UUczYnpwRVBQRGQxYjRraGcyeXNwdnNDNFc0WFFOT0U4UitmSktnSkhZcytM?=
 =?utf-8?B?SVpZS0lMVGtEWU9EUmMzNTFob0ZtYkJiYkgyemM1WWgyZWluQU10SlVnVWFv?=
 =?utf-8?B?dVJoSzh6Y0MwSElKWTZleHdSTFRUajFIcTl6YnJhaTg5Vjh2Z2VIMjZySEVt?=
 =?utf-8?B?VlpsKzZTNjJnUkZ4SjhDcFJZcDk5dmVCMlJJcjJCVG9jQmxvZGQ1UmRzVTBj?=
 =?utf-8?B?dVNZRVl0U1N3YUNsUFNtUzV6Rk9qaVN1eCtQdHU1dlJmTUNMUVFKMHFBb1Jq?=
 =?utf-8?B?NTZrQ1pTRG5tSnVJcytad0xlMEdtbVRVVGJjQ2FMNmkzM0tlaUNkeWlURkdQ?=
 =?utf-8?B?MXhuZDZ6bFVJTlpkelFZN1d5V2lRbWJsTWQzeityRFZmQ0Urdm80R2swZExZ?=
 =?utf-8?B?dnJjMEx4Qm42VHpYcHFocnk1ZjU5SE02TTd4OFQ2eHcyVkRGSlZkUnJ2MTc0?=
 =?utf-8?B?QTVBTjMxSXF3ZURTb1JMdEFmMUNSbHU2RWVSdUZlOXV1MkU5YmdhN2RBbVBG?=
 =?utf-8?B?cFRNeFg4R2xud2U1ODczYUZUcFgxbGFrNm10c2FPanEzc3drOWhla0xLUk1N?=
 =?utf-8?B?QklCVStReFBRZkhMeTVpU0ZscVE0aXU0Q0JTK1hReFNoVXpUNWhhL3lYYzBa?=
 =?utf-8?B?b2FRWlo2dG04MURLU2k1TGJ2YVM5TVBpeG5aS2hCY3Q5VEJYUzZ2QXRybm5J?=
 =?utf-8?B?WjQ3R2lUZjRaK1hPL3dMa0FwWm11Q09mMkNWYk5rRUdLY0VEdkJ6Qi9XdEx5?=
 =?utf-8?B?RUQ3K050Z1RCU2pzbG1XcC9wYjN0OVFtdUpwK1hzL05vU0xZMW1LMjlRS1l2?=
 =?utf-8?B?V0tGQUZsZ0owQndscmR0elBpUmRQVHJ6YklycDdwY2t6eE0zUHAxT0dURnNh?=
 =?utf-8?B?OFM1MU9mRWJTM1owamRHb1VnSkV2S3RhUEdtd1NjZmdscWtxUnFwRFJnNEVn?=
 =?utf-8?B?MWl1aVJ6NURCL3Bzb0FBc3B5eTIvTmdkajZPbVFGZlJCTW15QVg1WkVxVlhN?=
 =?utf-8?B?QVp5YW1XL3VFSFR0ZXY1Z2I2c3V4cExHZHNpWXVxcjdRQmExUE5lUE5NVSsv?=
 =?utf-8?B?cS9HaDNWYlMvWEl4dllsQkFqQWdHTHYzc25WRTZyVkVGZmdWMlRQY0RUdldO?=
 =?utf-8?B?QlRQKzErOUloL2tIaU1ubTFWeVhENEFMbk5LQkZMM0RVK3RQeUxSajZDelhq?=
 =?utf-8?B?TFZsc1dOVUpZSWplT1ovTTRSanBKRHU0RlgvR3hUSzdHU0JGNWhQcHpNN3Jy?=
 =?utf-8?Q?7xD0F3aq9BHYo7U25LgPcFOCr1pGv5Gw75?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SERnbEY2U2tRbEJ6cXVTZ0orcG1yK0VNWFRiVUZsc3NONzQwZDVhSFFndkpZ?=
 =?utf-8?B?amJDK2hvdkF2cnd2SlNGZkp2VVBrNFB4MGJHWmRySjYzWE1Mc2ZtcFBicUUx?=
 =?utf-8?B?bjM0a0Rxc3FUdHE3Z0FaSDNJamkxbUZkQng3cXdkdWhQNkplb0ptVmlOY0c0?=
 =?utf-8?B?M0hvK0g0YTVPTTRwdmpqYkg3cjQ1blhvZTI0U21Gb1RIRzE4KzNKbDVxMFM1?=
 =?utf-8?B?TDdpQmJ2UXdFNEZoQjBJRG9DbE9DNlVDY3QrZUZ3MkVOaDNPQlEzbUtyZnFE?=
 =?utf-8?B?THRoM1JxMHJBdjdTb3JLem1pOFZWNmZhRUgvQzNTYlRwZ1dNa0ZwWnpibHlh?=
 =?utf-8?B?VUVjbEdiN1l3cjEvcmlSaUk2Y3pUVExoYTVIUGdyZkRaSjZ2Z21PSEhHYVhl?=
 =?utf-8?B?a0pFTjJxM0xYMzZIYWxKMXF3cnA2Z1J4UzlUZGpaSmM0cTU0VDMvaXo5L0pM?=
 =?utf-8?B?WFI4dXNKaFMrSm9HZjFSNjNWSStPMzR6SXdxNnJXN3VneVVka1R0YTBvYlZi?=
 =?utf-8?B?enQ1VWJLOTErR3ZvM0xaMHNHWHB1YllqK0piRlpjaGNKdGp4QUpxVjUxenBJ?=
 =?utf-8?B?M25sdDlxdVdyNTFJWlBzSXJXa215U2hRL2RmY1F2ZU1zU0FicGsySXlML1hj?=
 =?utf-8?B?d3N2RlltY1dkdFdNWEM0N054bFBnRDVjdTh2Q1BNcjV4TGFvOFlHTS83UUNh?=
 =?utf-8?B?Um0xb01iSDluNXFkQTJkUE93YWFRRDY3MEZjaGdIdlJrbWtPZmlHM2d6eVpH?=
 =?utf-8?B?c0NiNlFkd3ZISHJCSk5TMVdON3I1bERjeG9RdnFmYW90SkRneEt3STU5MUtL?=
 =?utf-8?B?WkVGUUVpN0Vtdk1uTVJOVmFNMm91bFNoSHYzTVd0TUQwWm5CQXJQSmJnZVlr?=
 =?utf-8?B?QzdaT2xXWWNxYlZPQzdFWTJLeitzUEpaOXBBWm5zbDJ0U3ovdk9GUDZCSXdo?=
 =?utf-8?B?VTFqRkN0MGVVTDQ4UmpXbFdyWXJRR1FmaEdEcExkUGozZng4VWlkK1BYWjBy?=
 =?utf-8?B?bFJnbmhiMzhyS01INlF0cGJRRWF2d1pBY2NwQmNUMDdmUURRcWd5SDk0cjhh?=
 =?utf-8?B?NUNPeG1mZDVBOHh0TGVmNGNReC8xSEJlQStQTktGY3AyelMrQ3V4eFV4dVBP?=
 =?utf-8?B?RXRhc09ud0pPSTgya2d3QXlZeW5Pb0VxNjFuOTJwUjVSS0hWeXZKVm9sVnZi?=
 =?utf-8?B?cGduaHFuRmUyUXc3M3dwcW5CMTQvK0pNRCtOZHgxWTlhdW4ySXp6RXRxTkl6?=
 =?utf-8?B?WEd0Z2JJZDU4ZllneHAxS2xuNThBY2R1K3MycStiU0ZOVGlGM2VYekVKYU85?=
 =?utf-8?B?MDZZN0FkUStwRmZNRmhUK2R5enFrWGN1TE5pVEJsQVh0elZMQXA1MkNkRWNT?=
 =?utf-8?B?MUhUdk41WGJCMnBXV05VMFBNZ0s4ajNLTFNtdE41RUN4OHFVQXpia1JOT2dq?=
 =?utf-8?B?S0VCSjB6UkpWMktyVjZKazIzS3Y2UmU3N3c0UUp1dUNlL1RnYXZVTUlvWHVU?=
 =?utf-8?B?dDN2SmZodHkvUXNyd1lmb1hFQ0k4M1pZYVp5VzQrNlJXVnZNUkZhRGJmWVFB?=
 =?utf-8?B?R2J4UDRBZ0x6M0F1OG1lUFRFeWt2ZXJHR0FHbjhBOWxGSkZWcG5sRHdnZ3c4?=
 =?utf-8?B?a0lXUUlZKzMvbzB2UmRkTktYN0pyaXZFWXlUUDNCS2cveng5SDhPYUlHc0kw?=
 =?utf-8?B?NU9rVWpFeEJWUktQRWNxbTJ3b0RrcmYzZGRRSmxGeGJlWXNIbUwrc3lPVXJr?=
 =?utf-8?B?SjRiMERzWmRMS3RxYWhNbUV0bFBMZmNnNzVnQWMrMFpvWERyMWVLRHZyU25H?=
 =?utf-8?Q?o/GqJ0vNZFTgr12BmonjACqyoukun1SXiJmaA=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-d4257.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 12418fea-450d-40d4-b75b-08deeec7b5f7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR15MB6020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 05:51:06.0905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4636

Hi,

Gentle ping on this patch.

The mt7615 change was tested by me, and the mt7996 hunk was also
independently confirmed on hardware in the follow-up above.

Any feedback would be appreciated.

Thanks,
Mateus
