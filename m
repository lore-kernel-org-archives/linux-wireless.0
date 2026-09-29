Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010023.outbound.protection.outlook.com [52.103.23.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBC92EEE8A;
	Tue, 29 Sep 2026 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676218; cv=fail; b=n0m1/P1vIVN5vyZdyNuBHVF5bQtyM1LO16rYEc7JCSR8I1GiVKR/ga+VXvYoIdwl/URyugSjvGntBEQIPtzYJh9g7zWsxq8e/r6WGDh1jd6hYKfODKbhOJ3naIKPefE/hPP3hHWClPXLvrRbVgljjFwjil7XPiV0oyRViQ8dB+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676218; c=relaxed/simple;
	bh=t6TTI5MwuuDE7o/nuhjAVBb7eaz1U02GmU5ZRbQNxww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mYwHSdK0mkqYLLGZ9lwHyukGBpdXTH+Yx/WNIHCt6sL60X7MlhiqM023ME5GOtM99c1VXDlNe/6zHqUHNprW0VvKapSnrvYevZtXGJCsXym18BuC6MbSB4jzrpPbCxOXE62cmExSwzrZTt1w7rmqxGTOtfMV6YhsdFHENQwNvhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=mv+hh0pZ; arc=fail smtp.client-ip=52.103.23.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="mv+hh0pZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0uIwGY+V7GV4dC9YZvYI2FfFHKbaSCbj2cil87bpDMfhCTmv4hc7mhEqqbNWu1qUUt40svS0sOo2WmyG4tc9yM8XVRKXLeE/D6rdn//SVKl3B6MyorY/aDXzWO/b+d5Vw6+5Zh9GbZsCg2ubkqzAps1lqVtznCjengOLUuc7/wYiGuLlG5e/11RFYrKmAazETsi4MY/cP+c7KQl7u3+sTRpVvfB3GHcWOHAP0AuaRAwAEd7n7IDivRLLTZ3hPmW8vqc76XxSIVuqt2PMfko+3ndFlUGFA8N/hevOKKBkTkAT2Am2GfFHl+mpCaevBFAUaGY8uyoVTPQUMi4berkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOUfB9f4zeTr1Y3B+GnIXQHBt4g2seQ4tjiMHzQqYjU=;
 b=tR3BsMBHGY+32NiNrNR23nNtCPKxy8Kh7AXYG3pVN4RpN2d66FUw+9EqRETHhbMpqF2EKJzWvCnLr7DsZNQ5zbzE/YSnWONydnlGLMe9nsLX0rAyiuSHqLNJRbMQpteqhxpD3rWlnuo7hVHFBRXKjv+e1w90SFbA9KHMVhWb5OV5ewTl6/HzAbA9G2EMq/8Y2vigRbepyvF2M4F6RpKwm/cPraug+yhe26thVrqTUc+h7vnh30bTtAwQte3CQ5svQnTrGBz+iNgI+ZlwGuNqXyKpljxvIwP8oBf8oxg3RsZyX4avI4ZZYluNMaYhojpZ2oYEjJYzbTsYeArrTwBjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOUfB9f4zeTr1Y3B+GnIXQHBt4g2seQ4tjiMHzQqYjU=;
 b=mv+hh0pZFk8EXRC36c/iJGqjruixcCxRdf43B1GaXMpUJzEoDQF83Ad2qusT6+Q/ZuOdvrQYqmOTCqIRbkjuw3REkMHcDpeT5xcI+yiQjKM6Q/r+yJam/nl/OBFsnXvjtovUVOOZp42fH2Zev3Edqpv8Ni0ubzIS92gEZNX7B8I9Cmca0a+WlsZZ6CPkoZWn13Tt0hONUg3NcjS8Kq4WwryqlXr8HVtrkXcmZ91+aBGyuyMfB4rc4GS2Yonywv+yEIG5KLojdPdGUW86eQJTCL2ernEZfgBogvJ1lubdPZWf+z+Lgp7TXvTxNR11l1c54Gx4JQ1yrVocMn9nB+GOxA==
Received: from SN7PR19MB6736.namprd19.prod.outlook.com (2603:10b6:806:263::12)
 by PH8PR19MB997491.namprd19.prod.outlook.com (2603:10b6:510:3d5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:03:27 +0000
Received: from SN7PR19MB6736.namprd19.prod.outlook.com
 ([fe80::4b6c:b84f:b71c:d0a]) by SN7PR19MB6736.namprd19.prod.outlook.com
 ([fe80::4b6c:b84f:b71c:d0a%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:03:27 +0000
Message-ID:
 <SN7PR19MB67365636EC5E747DA51A4EFF9D8C2@SN7PR19MB6736.namprd19.prod.outlook.com>
Date: Tue, 29 Sep 2026 14:03:19 +0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 02/16] dt-bindings: net: wireless: ath11k: Add
 bindings for IPQ5018
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org, ath11k@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>,
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>,
 linux-arm-msm@vger.kernel.org
References: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
 <20260923-ipq5018-qcn6122-mpd-v1-2-86729521a75c@outlook.com>
 <20260928-sloppy-perfect-marmoset-bfec90@quoll>
Content-Language: en-US
From: George Moussalem <george.moussalem@outlook.com>
In-Reply-To: <20260928-sloppy-perfect-marmoset-bfec90@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0051.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cb::12) To SN7PR19MB6736.namprd19.prod.outlook.com
 (2603:10b6:806:263::12)
X-Microsoft-Original-Message-ID:
 <5e1b70c2-d52e-4191-a862-9b2567e54d6d@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR19MB6736:EE_|PH8PR19MB997491:EE_
X-MS-Office365-Filtering-Correlation-Id: 49117c8d-434d-4604-665b-08df1e10e7ea
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|25010399006|8060799015|19110799012|6090799003|24021099003|23021999003|41001999006|37011999003|15080799012|4140399003|3412199025|440099028|52005399003|40105399003|30101999006|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmFkR3UxTlhnRnE4ZWdxSE5udFROc1lNaUVZWDB1RFI0MThYcEhlZ1NkQ1M3?=
 =?utf-8?B?VmhEVnRwaGZvSWlCTldWbXZPQysrN3hJUmsrc1dtUWZWK2N2RVgzWWtoKzkz?=
 =?utf-8?B?YkhiMm1icjE0cnlpMFMrNGhzZGluTDNhQUF3SVJucEdZS1M3cUxsQ3J5eEk0?=
 =?utf-8?B?Z0dDODFPOVZzUDc3eGwvV09sdzR4U01aOUpHQk0zYkhaZlRzeGJKV2E5algv?=
 =?utf-8?B?d1pBMlpGWlY4WkF6ZTVLVFZJR0NldTlFSWYxQ0NmRG1iNXRJME1SMWJkbjR4?=
 =?utf-8?B?VVdkY2pqY1ZkdjNVckdxMHBENmk4Vm13cFpNRmM3M2poZWNZa3R4cHV0ay9p?=
 =?utf-8?B?VkVZbzBFdG12di9oWUlBckJFWVVWNEcvNE5yZkEvRWdFWkhTZnRTV3lMdVhM?=
 =?utf-8?B?UEFob2hYWS8rUUJpQUcyQlIrZ0NxRXg4a0VyNlRhQ3VkeVRHVXg4K1dOZzEv?=
 =?utf-8?B?ZE43elJ5VGxXdU1vUFNaSTN4SDlNQTJlQVJTZ1cxMW5hL2UyUUVPQlBhaFZF?=
 =?utf-8?B?NFpOSm0vQXVQTVQ0Q01NWkxRMnM4d3hWN2tMaFNNZDMzRDNleUZVOWkySUxP?=
 =?utf-8?B?dnFrNjB0QXZwcHEzRjZRM1lOQ3RrT0J4aHhqaVdzazFnVjhCNGUvY0dWemsz?=
 =?utf-8?B?R25BbWtBbmlRdGVpR1M0QkFuQ0hCR0F0dENhTEdBaGRIVzBWdU5iVlk4NDJF?=
 =?utf-8?B?SHI0RERoZXdFSklySFJqZnZQcGxBRFRSMmFZbE8rOXZsNE1VUjdLVm43cEtM?=
 =?utf-8?B?T0Eya2pKUVVMZ0c2c2xCT3VabXVQQUxSNDhDdG55YjhTSEt3SEFwOXFVMDJz?=
 =?utf-8?B?azNKOVFWTG1xa3FhclpqWmhTN252UTJVOHRZeUhiREVON2lWaXRMRWRiRHlt?=
 =?utf-8?B?UjkrOFhLdUFQRlVrbWV2dkFxMm9kZC9ZQXJjdFl5b3BxZ3NlWFFzZlJuMHZS?=
 =?utf-8?B?MUpRWEZuN2RSU2IzWjNXVUl0ZG5qVHVHK3VZa3JHQTdSVGF6czBsOFhoaWd1?=
 =?utf-8?B?NGZXaTNWbVZCTHR0RE1HT3dJZWRUbnBuRVlrOVRlQXNQR3hxSER6MVF4Qlpr?=
 =?utf-8?B?dm4wWERJd29OS1VFNTlNUzYvRjlIcUVHRlpvWkNPTllTRTRub3lEQmdSR25K?=
 =?utf-8?B?TG5XOHViODkzN2VIQXo2emo3b0U1SENtUUJ1djlvcHcxZzJpY0ptMnk4dFYx?=
 =?utf-8?B?RFhYWE5tRDMwSUVaWXZ3Mk5GRTFROERhcW5UdmVUQWp6VUxrNkhmWUNxY0Jy?=
 =?utf-8?B?ZVlIU3lYSjF5WlNVbEs1UWJjZVd6MnhjWXhWSDRXTk1jMllzd203b0JLeldQ?=
 =?utf-8?B?eklCcEFxejE1aXcyNHlFQllIZ0lSNmJzanBWNXdBODBUY3Z0UGs1L2ZXTzRr?=
 =?utf-8?B?Q0xWN0FPSlFYYU5VTFVSUUNlREdlM2FVM0ZEOEhuUFB5ZUMxQXFpOE53NXpw?=
 =?utf-8?Q?NSB7k8se?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WW1ZaU40RkM3SjVERnNzWGYyYmw3ZGJGQTFRKzRQckxzUmppMlVtWnN2ZUV0?=
 =?utf-8?B?Nk1RNXV1U05WT0ZBdHUvdVZ5bWF1VlIxOUJDenI4OERvUWc3TjhVeWl6cHJr?=
 =?utf-8?B?Q2JDcExQOWFyK2VFSnRDN05zbWlvc0h0Z0lIVWxkQmtQcFJNekNINkRRWGQx?=
 =?utf-8?B?OE1TaEdReFQ4Y090V2FzLzJ2VU9mYi9VRS91empaSExTZnY4ZWRCYWNvSkgx?=
 =?utf-8?B?WlJzVVZSMkdUbGVKdXdEd3RFU0VZckRXbmNJdTA1SEMyejBGMEgyZUpiaWhT?=
 =?utf-8?B?cUMvMkt5L1JqWVFEVG5tWWF4R1FYT1NXYk1hUzRCSHdjekhxOGFYYXllMVF6?=
 =?utf-8?B?ZFFwNlIwUzlVdHVlR0pwUW9kT1htVzc0R0UrZW9wZFI3MmVkaXZxNGRkVmor?=
 =?utf-8?B?WlVFU0x2ajRQVU1xSmgxVDFUcWRCL2MxQzFNbW5FM1VkMmtzS3dWK1IyKzd6?=
 =?utf-8?B?TW9sSmU4UmhBbmpVcS81NmdlNUxJT0ZtN3I0T3pYdGRxLzRucmxpZ0NBSDlQ?=
 =?utf-8?B?TTZwUkN1Nnp2UGt0c09tMkdDY3lpZUZtWDFhVW5yU2VyZ1BMWTZLWDQzbGxD?=
 =?utf-8?B?QUkwVXNTVW01M0wyQjhHcXQvNGJLZzQ4R215QjVKUG1Va2JDazlQVXdPdmMy?=
 =?utf-8?B?eWowZ0FYVVgyTXg1R3VPUTBqMDVWRVliQ0hjUjJFSzVyOGlCOTZYU0xvVkZ3?=
 =?utf-8?B?WmVwZGNCTnNyMDVRd3FqamJoUzZSZHZ4ZE9kY3g0NHpaUzlsZjNSUDgyV0pM?=
 =?utf-8?B?QWM3djh0K2haeDI4STE5dVNXS2JBdDJJemlKQ0lCUjdHTU9yUnUvYzRrNklO?=
 =?utf-8?B?ZkxFaTlIaThOWXZPVVU5d2o5MU1BVzRLZStHa05OeHB5VmNtMkZTdDRRSHRr?=
 =?utf-8?B?dXdXUzhGTTl1ME0yK3B5QUU4QVNRcEdRSVFwbGhnODFobWF4TmtLM1NhQzk4?=
 =?utf-8?B?U3FnMmU4d2Zaa0NxellzUXg1QVBmKzRaWWZGTzMwZ0I2OUdWUzJndEptcmFL?=
 =?utf-8?B?VWxyMTFiMjMyN2xoVkR6UlNzcVZKclJaaG9IbHZBdGtET1F6T3JhaGd3bmJo?=
 =?utf-8?B?STJjUmMyOTFDUlVUVU9XSVoxZ2REakpsdXhQencyc2hicFpOUWxtNXpvbWs4?=
 =?utf-8?B?cFpBSVpzanRBaUFYNFU5Q1hYOUpQcW10RHdmdlllakVNMTI3L1h0MGxrcHMy?=
 =?utf-8?B?MHY1dER0UVZFeWt1angrdkxDQUNuZlNNVDZzazBvOVp6MFpRSStDdkhZQk5U?=
 =?utf-8?B?WlNmYUpQWS9XdWVEQ0ZsUlF0TmR4SmJ6TllWcjRnUEdrVWpJUTlraTFFTlpP?=
 =?utf-8?B?bHJPa3RVSmJZQ2dsakJRb0F3K3hDU0tqRWZiK1VERTNhTElSWnRBa1dScHk1?=
 =?utf-8?B?ZlVsd0hEZHhVRGUvK1dLRWY2ODhFSk9rYzltMDJDVW1aOHBMa005TUh5WFFn?=
 =?utf-8?B?MVdGQUxIb0dxS29OTzlJbzQrcGpvcHo5cWhSWjZoaVJya0VISU9ESzRJVHhO?=
 =?utf-8?B?ZVVuZWpUaktRelJVdnYxenpTbWFCbXQ1b1VycFI4ME45bXgxRW5KdVRYZEtM?=
 =?utf-8?B?MWYyQW41S2Z0NlRPRUJpdy9BMVE3R2FEZER6cS8vQ0JhQWFvczZxUEttV0RY?=
 =?utf-8?B?cVBSWC9JL2EyRk1CQ0RpelhyV2I3VFEyY1B0S2kzeWJsM1pKaGRsb1B6SlhW?=
 =?utf-8?B?aDNISzN1eDZsa0VoZUZzTEFSMkRLMFVTT0I1eXJHdjV2ZC9ENkg2WW00aUZs?=
 =?utf-8?B?aWxrQUpwWlphOUhROFB6b3oyMXRQc055dlg0N0RycWZBMXVob1ErZTB6SEda?=
 =?utf-8?B?ZDVFNWwxbDMvY2txWWRXYk5KSHgrOFV5VlFlWjlwY2ZOaWRtV0I5U1FaWmVL?=
 =?utf-8?B?UHprUVo4UUlpaFVzYkdnclI1M1hUVmhOclVZWmhpNlA3OUE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49117c8d-434d-4604-665b-08df1e10e7ea
X-MS-Exchange-CrossTenant-AuthSource: SN7PR19MB6736.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:03:27.4086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB997491

On 9/28/26 14:45, Krzysztof Kozlowski wrote:
> On Wed, Sep 23, 2026 at 04:05:08PM +0400, George Moussalem wrote:
>> Although support was added for IPQ5018, the bindings are missing, so
>> let's add them.
> 
> So there is no ipq5018 compatible in existing file.

The compatible is there, but it's not further specified. But as per your
suggestion, I'll move it entirely to qcom,ipq5332-wifi.yaml.>
>>
>> WiFi on IPQ5018 boards come in one of the following configurations:
>> 1. IPQ5018 (standalone) + optional 5G/6G WiFi card (such as QCN9074)
>> 2. IPQ5018 (MPD) + one or two 5G/6G QCN6122 WiFi chips where QCN6122
>>    is an IPQ5018-specific companion chip.
>>
>> IPQ5018 implements the multi-PD architecture as follows:
>>
>>                      +-----------------------------+
>>                      |     Q6 Remote Processor     |
>>                      |            RootPD           |
>>                      +--------------+--------------+
>>                                     |
>>                                     |
>>                                     |
>>               +---------------------+---------------------+
>>               |                     |                     |
>>         +-----v-----+         +-----v-----+         +-----v-----+
>>         |  UserPD1  |         |  UserPD2  |         |  UserPD3  |
>>         |  IPQ5018  |         | QCN6122 #1|         | QCN6122 #2|
>>         |  (Radio)  |         |  (Radio)  |         |  (Radio)  |
>>         +-----------+         +-----------+         +-----------+
>>
>> The rootPD is responsible for managing the lifecycle of the UserPD and
>> shared resources and providing SSR notifiers. There are different
>> firmware blobs that include either the rootPD and userPD binaries for
>> IPQ5018-only which auto-spawns the userPD for IPQ5018 WiFi, or for
>> IPQ5018 and QCN6122 for which the userPDs for each radio must be spawned
>> by the ath11k driver.
>>
>> SMP2P is used for signaling between the host and the Q6 remote processor
>> to manage the lifecycle of the userPDs, so add the required interrupts
>> and smem-states for incoming and outgoing interrupts in the case of the
>> IPQ5018 + QCN6122 MPD configuration. Otherwise, the SMP2P interrupts and
>> smem-states are not required for the IPQ5018-only configuration.
>>
>> In addition, document the memory regions needed for loading the BDF and
>> M3 firmware as well as for assigning the M3 dump memory block.
>>
>> Signed-off-by: George Moussalem <george.moussalem@outlook.com>
>> ---
>>  .../bindings/net/wireless/qcom,ath11k.yaml         | 423 ++++++++++++++++++++-
>>  1 file changed, 410 insertions(+), 13 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> index a846cd704b19..621ad6d4ddad 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> 
> Where is the compatible update?
> 
>> @@ -29,8 +29,13 @@ properties:
>>      minItems: 32
>>      maxItems: 52
> 
> 56
> 
>>  
>> +  interrupts-extended:
> 
> git grep should tell you - it's not needed. Drop.

Noted, thanks!

> 
>> +    minItems: 56
>> +    maxItems: 56
>> +
>>    interrupt-names:
>> -    maxItems: 52
>> +    minItems: 32
>> +    maxItems: 56
>>  
>>    qcom,rproc:
>>      $ref: /schemas/types.yaml#/definitions/phandle
>> @@ -56,11 +61,15 @@ properties:
>>  
>>    memory-region:
>>      minItems: 1
>> -    maxItems: 2
>> +    maxItems: 3
>>      description:
>>        phandle to a node describing reserved memory (System RAM memory)
>>        used by ath11k firmware (see bindings/reserved-memory/reserved-memory.txt)
>>  
>> +  memory-region-names:
>> +    minItems: 1
>> +    maxItems: 3
> 
> Names would have to be here. But why do you need it in the first place?

It's for the ability to override the default hard-coded addresses
defined in the HW params. The memory address/region to load the BDF into
varies per architecture (regular non-MPD vs MPD). The current HW params
define the one for the regular architecture. As with IPQ5332, there's a
need to override that and assign the right memory regions for the BDF
and M3 dump.

Unlike IPQ5018 and IPQ5332, QCN6122 doesn't have its own m3-region to
load its M3 firmware maps to the one of IPQ5018. Hence, the need to
define the m3-region per board.

So for QCN6122, it would look like:
	memory-region = <&q6_region_qcn6122_1>,
			<&q6_region_ipq5018>,
			<&m3_dump_qcn6122_1>;
        memory-region-names = "q6-region",
			      "m3-region",
			      "m3-dump";

> 
>> +
>>    iommus:
>>      minItems: 1
>>      maxItems: 2
>> @@ -78,20 +87,11 @@ properties:
>>    qcom,smem-states:
>>      $ref: /schemas/types.yaml#/definitions/phandle-array
>>      description: State bits used by the AP to signal the WLAN Q6.
>> -    items:
>> -      - description: Signal bits used to enable/disable low power mode
>> -          on WCN6750 in the case of WoW (Wake on Wireless).
>> -        items:
>> -          - description: Phandle to the Shared Memory Point 2 Point device
>> -              handling the communication with a remote processor
>> -          - description: Single bit index to toggle in the value sent to
>> -              the remote processor
>> -            maximum: 32
>> +    minItems: 1
>> +    maxItems: 3
>>  
>>    qcom,smem-state-names:
>>      description: The names of the state bits used for SMP2P output.
>> -    items:
>> -      - const: wlan-smp2p-out
> 
> Why isn't all this in qcom,ipq5332-wifi.yaml?

Will move it there, thanks.

> 
>>  
>>  required:
>>    - compatible
>> @@ -103,6 +103,242 @@ additionalProperties: false
>>  
>>  allOf:
>>    - $ref: ieee80211.yaml#
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            enum:
>> +              - qcom,ipq5018-wifi
>> +    then:
>> +      properties:
>> +        interrupts:
>> +          items:
>> +            - description: misc-pulse1 interrupt events
>> +            - description: misc-latch interrupt events
>> +            - description: sw exception interrupt events
>> +            - description: watchdog interrupt events
>> +            - description: interrupt event for ring CE0
>> +            - description: interrupt event for ring CE1
>> +            - description: interrupt event for ring CE2
>> +            - description: interrupt event for ring CE3
>> +            - description: interrupt event for ring CE4
>> +            - description: interrupt event for ring CE5
>> +            - description: interrupt event for ring CE6
>> +            - description: interrupt event for ring CE7
>> +            - description: interrupt event for ring CE8
>> +            - description: interrupt event for ring CE9
>> +            - description: interrupt event for ring CE10
>> +            - description: interrupt event for ring CE11
>> +            - description: interrupt event for ring host2wbm-desc-feed
>> +            - description: interrupt event for ring host2reo-re-injection
>> +            - description: interrupt event for ring host2reo-command
>> +            - description: interrupt event for ring host2rxdma-monitor-ring3
>> +            - description: interrupt event for ring host2rxdma-monitor-ring2
>> +            - description: interrupt event for ring host2rxdma-monitor-ring1
>> +            - description: interrupt event for ring reo2ost-exception
>> +            - description: interrupt event for ring wbm2host-rx-release
>> +            - description: interrupt event for ring reo2host-status
>> +            - description: interrupt event for ring reo2host-destination-ring4
>> +            - description: interrupt event for ring reo2host-destination-ring3
>> +            - description: interrupt event for ring reo2host-destination-ring2
>> +            - description: interrupt event for ring reo2host-destination-ring1
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac3
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac2
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac1
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac3
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac2
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac1
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac3
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac2
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac1
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac3
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac2
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac1
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac3
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac2
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac1
>> +            - description: interrupt event for ring host2tcl-input-ring4
>> +            - description: interrupt event for ring host2tcl-input-ring3
>> +            - description: interrupt event for ring host2tcl-input-ring2
>> +            - description: interrupt event for ring host2tcl-input-ring1
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring3
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring2
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring1
>> +            - description: interrupt event for ring tcl2host-status-ring
>> +        interrupts-extended:
>> +          items:
>> +            - description: misc-pulse1 interrupt events
>> +            - description: misc-latch interrupt events
>> +            - description: sw exception interrupt events
>> +            - description: watchdog interrupt events
>> +            - description: interrupt event for ring CE0
>> +            - description: interrupt event for ring CE1
>> +            - description: interrupt event for ring CE2
>> +            - description: interrupt event for ring CE3
>> +            - description: interrupt event for ring CE4
>> +            - description: interrupt event for ring CE5
>> +            - description: interrupt event for ring CE6
>> +            - description: interrupt event for ring CE7
>> +            - description: interrupt event for ring CE8
>> +            - description: interrupt event for ring CE9
>> +            - description: interrupt event for ring CE10
>> +            - description: interrupt event for ring CE11
>> +            - description: interrupt event for ring host2wbm-desc-feed
>> +            - description: interrupt event for ring host2reo-re-injection
>> +            - description: interrupt event for ring host2reo-command
>> +            - description: interrupt event for ring host2rxdma-monitor-ring3
>> +            - description: interrupt event for ring host2rxdma-monitor-ring2
>> +            - description: interrupt event for ring host2rxdma-monitor-ring1
>> +            - description: interrupt event for ring reo2ost-exception
>> +            - description: interrupt event for ring wbm2host-rx-release
>> +            - description: interrupt event for ring reo2host-status
>> +            - description: interrupt event for ring reo2host-destination-ring4
>> +            - description: interrupt event for ring reo2host-destination-ring3
>> +            - description: interrupt event for ring reo2host-destination-ring2
>> +            - description: interrupt event for ring reo2host-destination-ring1
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac3
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac2
>> +            - description: interrupt event for ring rxdma2host-monitor-destination-mac1
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac3
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac2
>> +            - description: interrupt event for ring ppdu-end-interrupts-mac1
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac3
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac2
>> +            - description: interrupt event for ring rxdma2host-monitor-status-ring-mac1
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac3
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac2
>> +            - description: interrupt event for ring host2rxdma-host-buf-ring-mac1
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac3
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac2
>> +            - description: interrupt event for ring rxdma2host-destination-ring-mac1
>> +            - description: interrupt event for ring host2tcl-input-ring4
>> +            - description: interrupt event for ring host2tcl-input-ring3
>> +            - description: interrupt event for ring host2tcl-input-ring2
>> +            - description: interrupt event for ring host2tcl-input-ring1
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring3
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring2
>> +            - description: interrupt event for ring wbm2host-tx-completions-ring1
>> +            - description: interrupt event for ring tcl2host-status-ring
>> +            - description: Q6 firmware user PD fatal interrupt event
>> +            - description: Q6 firmware user PD ready interrupt event
>> +            - description: Q6 firmware user PD spawn interrupt event
>> +            - description: Q6 firmware user PD stop ack interrupt event
>> +        interrupt-names:
>> +          minItems: 52
>> +          items:
>> +            - const: misc-pulse1
>> +            - const: misc-latch
>> +            - const: sw-exception
>> +            - const: watchdog
>> +            - const: ce0
>> +            - const: ce1
>> +            - const: ce2
>> +            - const: ce3
>> +            - const: ce4
>> +            - const: ce5
>> +            - const: ce6
>> +            - const: ce7
>> +            - const: ce8
>> +            - const: ce9
>> +            - const: ce10
>> +            - const: ce11
>> +            - const: host2wbm-desc-feed
>> +            - const: host2reo-re-injection
>> +            - const: host2reo-command
>> +            - const: host2rxdma-monitor-ring3
>> +            - const: host2rxdma-monitor-ring2
>> +            - const: host2rxdma-monitor-ring1
>> +            - const: reo2ost-exception
>> +            - const: wbm2host-rx-release
>> +            - const: reo2host-status
>> +            - const: reo2host-destination-ring4
>> +            - const: reo2host-destination-ring3
>> +            - const: reo2host-destination-ring2
>> +            - const: reo2host-destination-ring1
>> +            - const: rxdma2host-monitor-destination-mac3
>> +            - const: rxdma2host-monitor-destination-mac2
>> +            - const: rxdma2host-monitor-destination-mac1
>> +            - const: ppdu-end-interrupts-mac3
>> +            - const: ppdu-end-interrupts-mac2
>> +            - const: ppdu-end-interrupts-mac1
>> +            - const: rxdma2host-monitor-status-ring-mac3
>> +            - const: rxdma2host-monitor-status-ring-mac2
>> +            - const: rxdma2host-monitor-status-ring-mac1
>> +            - const: host2rxdma-host-buf-ring-mac3
>> +            - const: host2rxdma-host-buf-ring-mac2
>> +            - const: host2rxdma-host-buf-ring-mac1
>> +            - const: rxdma2host-destination-ring-mac3
>> +            - const: rxdma2host-destination-ring-mac2
>> +            - const: rxdma2host-destination-ring-mac1
>> +            - const: host2tcl-input-ring4
>> +            - const: host2tcl-input-ring3
>> +            - const: host2tcl-input-ring2
>> +            - const: host2tcl-input-ring1
>> +            - const: wbm2host-tx-completions-ring3
>> +            - const: wbm2host-tx-completions-ring2
>> +            - const: wbm2host-tx-completions-ring1
>> +            - const: tcl2host-status-ring
>> +            - const: fatal
>> +            - const: ready
>> +            - const: spawn
>> +            - const: stop-ack
>> +        memory-region:
>> +          items:
>> +            - description: memory region for Q6 firmware
>> +            - description: memory region for M3 firmware
>> +            - description: memory region for M3 dump
>> +        memory-region-names:
>> +          items:
>> +            - const: q6-region
>> +            - const: m3-region
>> +            - const: m3-dump
>> +        qcom,smem-states:
>> +          items:
>> +            - description: Signal bit used to shutdown Q6 user PD
>> +              items:
>> +                - description: Phandle to the Shared Memory Point 2 Point device
>> +                - description: Single bit index to toggle in the value sent to the remote processor
>> +                  maximum: 32
>> +            - description: Signal bit used to stop Q6 user PD
>> +              items:
>> +                - description: Phandle to the Shared Memory Point 2 Point device
>> +                - description: Single bit index to toggle in the value sent to the remote processor
>> +                  maximum: 32
>> +            - description: Signal bit used to spawn Q6 user PD
>> +              items:
>> +                - description: Phandle to the Shared Memory Point 2 Point device
>> +                - description: Single bit index to toggle in the value sent to the remote processor
>> +                  maximum: 32
>> +        qcom,smem-state-names:
>> +          items:
>> +            - const: shutdown
>> +            - const: stop
>> +            - const: spawn
>> +      allOf:
>> +        - anyOf:
>> +            - required:
>> +                - interrupts
>> +            - required:
>> +                - interrupts-extended
>> +        - if:
>> +            required:
>> +              - interrupts-extended
>> +          then:
>> +            properties:
>> +              interrupt-names:
>> +                minItems: 56
>> +            required:
>> +              - interrupts-extended
>> +              - memory-region
>> +              - memory-region-names
>> +              - qcom,smem-states
>> +              - qcom,smem-state-names
>> +          else:
>> +            properties:
>> +              interrupt-names:
>> +                minItems: 52
>> +                maxItems: 52
>> +
>>    - if:
>>        properties:
>>          compatible:
>> @@ -265,6 +501,19 @@ allOf:
>>              - description: interrupt event for ring DP20
>>              - description: interrupt event for ring DP21
>>              - description: interrupt event for ring DP22
>> +        qcom,smem-states:
>> +          items:
>> +            - description: Signal bits used to enable/disable low power mode
>> +                on WCN6750 in the case of WoW (Wake on Wireless).
>> +              items:
>> +                - description: Phandle to the Shared Memory Point 2 Point device
>> +                    handling the communication with a remote processor
>> +                - description: Single bit index to toggle in the value sent to
>> +                    the remote processor
>> +                  maximum: 32
>> +        qcom,smem-state-names:
>> +          items:
>> +            - const: wlan-smp2p-out
>>  
>>  examples:
>>    - |
>> @@ -464,3 +713,151 @@ examples:
>>              iommus = <&apps_smmu 0x1c02 0x1>;
>>          };
>>      };
>> +
>> +  - |
> 
> No, three examples are enough. No need for fourth.

Noted, will remove in next version.

> 
> Best regards,
> Krzysztof

Best regards,
George
