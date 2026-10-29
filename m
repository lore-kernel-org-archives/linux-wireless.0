Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793267166;
	b=a6kzxzo8a6ndNkKtXn7gUxOINJFFxkRIVR5EO5YuUMJJu4ruREwymDrgpt5fJB0uryOH
	 fAX5NXdtMVLLJNF7JXj5hIaQ9uNWpYT/mcVIbA2MVjJnBUTxsCZK4R9Ri/MTBJMo6ny7+
	 sKx55Bqwa2fRkpi+DOI7EAMrvi3Gdro2epVvjEFGOZYTf97OvzEEzFeytWiL1cHgb72fT
	 GIvMyfcQtXYEyvNa37FKGqyumb1tJALDszRYEhZmu2C9zwCKp9M3/fZRkM5RaPGoabUvg
	 Gv+6IOaCxPXqDalSOzjosFOKiz6TVHw3w2VBBnEjXgf8k7U25EsO/0DpSjCDBYi7jXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267166;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Content-Language:To:Cc:From:Subject:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=vFZpTP8T3qf2bVXgz/BMjhxNZMTx6pv3G3f2eLNVKEs=;
	b=HFTyeOn2ZYwdpIA0Vpyn9wkgidIIlPoDbKq42i+QoiqtHmjAmhHNF03Rjg4OQJE5H51U
	 5LVvOtNcUIiIU5Rb38/UFnXVFCevN7rd9qmb6Gi3PexvN0PJFiFg4kL5Y5ex2ygzULdgt
	 K76XAdnA/tjB2zPHtDttwVb0VmkCrdq0NUpTtjAMSv7D58UlVEqCyOZjWnDIR9gBUYqGW
	 ThTPzoh+B3H8P+wCgU+t9vJC7zgEXayua9TZlVvTBXe3dPLJtsSZw3/5sJT8324T+rspq
	 WaG/GNTvPU6fCs9e141ytXIKeBMUweQgHaTMS2lv+1WD9I3LJnd5MBEToUMH3n30n0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hotmail.com;
	spf=pass smtp.mailfrom=hotmail.com;
	dkim=pass header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=rmlYx3XM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.1
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010001.outbound.protection.outlook.com [52.103.33.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96A6606A329
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C96A6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hotmail.com header.i=@hotmail.com header.a=rsa-sha256 header.s=selector1 header.b=rmlYx3XM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsgcseP1rPlQSc7YQlPh4Py1/0Fm5zx/AQvoBS0DWlJWvpsrXtRD/LZnXdo5XxYHxnnUpYal3btk69KrhL9M8YslGiqfNV8yMDBYwHXUvV2b2XKKugnRrzZOA3Y8qkGLiNhbNQ44tQn0FKQZEadh2AqTCtFBWVNTMAy8xV0qGpHs5hXdmnAN3Su+oPp5u8b5CxCf2p3nZkRWrVjyOkhlcf1VSRWYPg2F2kpJ0UwraKjgfDvYTbl8mw3rVzrKD7Ds2DEIIIN4RkS8et4FuXVGa1UzmSwnBTQ39Ik7LBQxOMbbZWqwkHmczpXuPcdHgp9FxbjSxx3ouAERKAr6aRnrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFZpTP8T3qf2bVXgz/BMjhxNZMTx6pv3G3f2eLNVKEs=;
 b=aHt5ZVKaOIoOsbMQlqScC13zKu2iZnt8S1Bu3PMUiUVgcuXwuQGQ+daA0drQ6k5H++ujXB+3Pi8sU15F4xprbmmWPwSiy9sP0/I7af4MnzwIK7N7x9ogSkIpQBLWn9YJlP3t67wXx+udQMrLMpWG0A9UJZq5DGM7iRSU2jxKzUOh032Nj6eTJ+JmV0PvZ1Pv+TfGGFkxyK6r/s5LoGSDaDOHz1m3YwTabunt0tOJ5+ZUWbnQ1u4LZNkJsPI3LOPq2LI+7+t6SF5a/Z5iYf1Yw57hVa0rN6VKtY7zJhptjdMaKywKLti6WZfgAuOebUKYOXWW8ElCRie38GMZa5ye2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFZpTP8T3qf2bVXgz/BMjhxNZMTx6pv3G3f2eLNVKEs=;
 b=rmlYx3XMxVG7OLScFTABEIa56v8HOFW5fvhRpNCsnwy40y/ziBJuDUjJmUGh6atUDSF36mD/VX1o5FAfBpSd2G0mvqyNgxYm/ItD8VbgzzS8M1EI4hNXIBCdHzsxt+/m1f+HX4FX0SO5bEveZt5HqnblEdykFI079/Gn6zmCItzLcneL9fzgr5janxwcJAzQp7dUVFVMgFry34pft70hi0LBUFU9mXQBMBzOD1Ws3z34dMqV+AOt5IkHOb1Lb9ZtwXDTZ5bZzNo6lpDfahCA35jDhSp9xGL7pNSTd1qh7AAgfGl/DAOJRYW7/VQUQpo7Jl5F9IfdMOWEXzua9xLt7w==
Received: from GV1P251MB1135.EURP251.PROD.OUTLOOK.COM (2603:10a6:150:282::17)
 by DB9P251MB0124.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:2c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Thu, 29 Oct
 2026 09:46:02 +0000
Received: from GV1P251MB1135.EURP251.PROD.OUTLOOK.COM
 ([fe80::5149:fdef:df2b:8788]) by GV1P251MB1135.EURP251.PROD.OUTLOOK.COM
 ([fe80::5149:fdef:df2b:8788%3]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 09:46:02 +0000
Message-ID:
 <GV1P251MB1135EAB67558AA705ECE1198AB6E2@GV1P251MB1135.EURP251.PROD.OUTLOOK.COM>
Date: Thu, 29 Oct 2026 10:46:01 +0100
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
From: Berke Ceylan <berkeceylan12@hotmail.com>
Subject: rtw89: 8922ae: MLO association drops every ~307 s (local deauth
 reason 2), stable without MLO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0205.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::14) To GV1P251MB1135.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:150:282::17)
X-Microsoft-Original-Message-ID:
 <6d218cc2-c63a-4629-81b2-fd479cc5102e@hotmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P251MB1135:EE_|DB9P251MB0124:EE_
X-MS-Office365-Filtering-Correlation-Id: ce60fb0f-9797-4da0-58c8-08df35a1719f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|20031999006|25010399006|4140399003|8060799015|19110799012|24071999003|5072599009|25031999004|23021999003|15080799012|6090799003|24021099003|39105399006|12091999003|10035399007|40105399003|19061999003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGI5Vm9XM1NFOXYxRk8zQm5hQWE2SW1aSHk0UHlkVEFpTmdUeFY3TmU1T0dT?=
 =?utf-8?B?d001VW0rYmxibWJSbGM3aVVEbHZHME5oczVJRlAwdDRvcEMzNHc1cUROMDBo?=
 =?utf-8?B?RlBsK2g3QUY3M1JzSUpNK2UzS0xCYmk4VTBxdWl0UHpvZ3NVMk5mS0tjNitK?=
 =?utf-8?B?SURFY2dlMzhZbC9rS0lQUkpkL0Q3a3VmaVpKa2xndWlFNjc0bHFYT21TKzZN?=
 =?utf-8?B?MGRBaVhacW9rQ1V1cERjOWM0NDFaZHhSNm5Bd0pZdjlWcXdLUUpuTmJOWmpC?=
 =?utf-8?B?VmJmU0Noa3MwdFJlTUhwSlRvR2krZUpXazM4UW1DMG9hQ2NnRzFtUWZ1UTl6?=
 =?utf-8?B?UVFaY2lkMXJwYTB2Rk5IdUpUMkxhS24vKzR1MnZOK1VEUFlKNEZzVUtjb3lw?=
 =?utf-8?B?UHNLdEhhYis5VzVNTWdqNUMvN1cwM2tybzJsc0k4TGxMM2I0NHpCMThNbEFR?=
 =?utf-8?B?aUU5TngxNXJuaXNBRFdpb1BGSndSWmRSRGozV3MxcmZ1bnBlQXFtYkVuNkpy?=
 =?utf-8?B?UE9PL21SSHpGbnJyZXJaV2E3OFQ2TlFKb3NubG1MYzF3NThHTnBjWnBZMGtF?=
 =?utf-8?B?Sk5KNmdCbm9OOW9oQ05xRXEyY2p1QmhNS0xsUU1kN09xMlpLNmNET0Y5b1JB?=
 =?utf-8?B?Szlsc2RCVms0b3BlY2pUK1FaVjdyOERaOW1BVytvWXNiRmRvdDRhd2Y3QW1Z?=
 =?utf-8?B?bTFtNmdUL0hHdjVFVENHMTI1QzU0NkphRkdNSi9sZ2J1Uk5uMVd1alRGQWdn?=
 =?utf-8?B?WVVVSGZpNzBEU3E3OTNZN0hlVWNwQWU4R2xseGRtWnVxSU5pL25GUUVSWkhY?=
 =?utf-8?B?Rmd4eEhwYUwwajh3elhYMWh1Z0dPNjUwbVFML3NyYUxIQ25lWWJLUW51ak5x?=
 =?utf-8?B?NS83bDJGbDFMVzFhQ2l3MmM5dFZ0WVFCZFJveVJKd21kZVZHSEdzZEZmS2Z3?=
 =?utf-8?B?ak5yWDUvdFI1Q0s4eXcxTWYzNVQ2YVVzc0MyN1YyNU9wUkZTMGhXRndVNGRV?=
 =?utf-8?B?eW5BdmREUnJDdDV2VjcwT0N2R1dRcTYxTmltSkkrV2h2cnJtVW9pS1JRWFZm?=
 =?utf-8?B?M2hHNVlENDlEZUNXcXIyTkRvMEsyNU0xRmlCNklBeHJhS1ZBTHREL2lJc0th?=
 =?utf-8?B?UHNXNjlMbXVwU1ZTRkRBZjBxa1pOTlJUalVHbGlzSWVWQVF0RTNla254dXBV?=
 =?utf-8?B?WU9zbmxsaXFzNGxadUEvWnY5bnJZSkUvdHphWU5ob1BBbXp5MklMOU5TVUpw?=
 =?utf-8?B?dnc1V1VzclVmVW1ValVaaUp3amlVMmUvMCtlKzdpRFVEekM3b3o3UENQSnJp?=
 =?utf-8?B?VmpRdm5vb0YrN2xXWTFPUnlFWVpKRXVjMTl6WE5jTkM3UkVPd3hkL3NzOHhs?=
 =?utf-8?B?QVpXd0diSVNLTFhERVdZVTVVVG14RlNjNlozTDQ2bjVUUE1wVmk2Y1dlWWxs?=
 =?utf-8?B?bVFlSjNnMTlqaWNqNHZidlpDMlIvbHhEbXllbEpJRDRPSW8zS29rYXczbGFL?=
 =?utf-8?Q?Ggky8o=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWE2Rzl2cXdLWXk2VG9yVW56SytVQzI2Vzl4eHlHUXMrdFljdWxtTkhrS1Nv?=
 =?utf-8?B?TWlVQTd3T2p5cWJRYTNubzZJTlpjazcrditkUHB5VDdNa3NzYU1DVlY4WE1N?=
 =?utf-8?B?R1JjUFRNNHFvNDBuZGJNTnVMc2Q4bjlEYWdRWjVRMlJxMFdBRUxVeHZQYVV4?=
 =?utf-8?B?M0ZhV1NqcHF3UDdDbkhBa2FNQmR2bXpxMEVLS05VZXcycEZNeFgwTXNMMkpO?=
 =?utf-8?B?Q2VzdzQ5cjYwWjVvU1AyaHNXVkdUcHdoUTc5T1FENlNpV050NjU3Q3E5UGRp?=
 =?utf-8?B?OUhHMFFXQlI5YWd0bTJJd09wenNpVGhsVHR5M0M0YzNadHZSZmMvRFc1OTlO?=
 =?utf-8?B?Mkl6dUU3Q2psdjV6eDBrSm5TR1JOblFZZjlwMVhJVThVVFpMY0ZiVGVXUGo1?=
 =?utf-8?B?bENDVHZUNE9aeUVsZk9BWURjR1NJRXVHbDcvUmllMmVNenBiTDNzSUxRUDVT?=
 =?utf-8?B?TTAvYVRPSTRXM0JzSHZwSWxvSDJKMDlwdVQ0UjlxNUFiMkxUZGY0TE5IZ01C?=
 =?utf-8?B?em1KcklrQTJyVHpRblVvVURkWURCbjJOVzNpN1Z3YTZJY05hNG5ZOFJNMktF?=
 =?utf-8?B?ckdROGQrK1RLbklUN1FyNXhlU25CVUJFYVV2MDFZTVJrbHl3UHVtUEk1dlNw?=
 =?utf-8?B?Y2NKaXVjUVg1SUhFcFZ0anRsWjBJcWFuZys1cUpneGFmckxCNDBwcytGUmcx?=
 =?utf-8?B?NDRYS0VVV1B1amNNL0MvcVJJdVJXZnJQWU1RS3FIU2hlakZiVzV2RVNqVE9X?=
 =?utf-8?B?U0dYa3ZQbUUwbGdkRm9EOXZCR21VbUVUczBLb0JDbWp1SDhKMUd2ZC9yR2FV?=
 =?utf-8?B?TEhrNzdnT3h4VW9qTXErOW1ETHI4K1VYTWNmZXBXR0kzSlUxVnpnYXVzeGEv?=
 =?utf-8?B?Unc0YXhxOG9PeFJXa0haTHE1S0NSeU03OThLVmdTWUJnNkxueEU3aHd2SkJB?=
 =?utf-8?B?MkxDMHpSWEhKMGZtazdKeHUzWWZRL2pyRUtoa0ZCZUtRNDJnNU9jTDFIcTdu?=
 =?utf-8?B?U2VsVnk0Z0lWYi8renRoNTYzR1ZjMDkyRWJDVUZaZWRDT0xCWEVHWGR1eFRF?=
 =?utf-8?B?WmhraXYwcHdTSWtXNWVnRytuWjdiVkZnN2tWS3VzRnJ4NSszNzBXWVNOR2J2?=
 =?utf-8?B?QVRiWFVYZ2w4aTdaazVKaGFiNS9WWFVNUzRPM1ZvN3ltWGZkalNyTGQxWDQx?=
 =?utf-8?B?ajBDK0Y2blNCUlJtSGx0emxGSmcwZjdPaHBXTUFrR3Y4cnRkSFVyay81L09q?=
 =?utf-8?B?OUVvL0dnOVlaVG9oWWlGb0hlRFhWLzRwZ0JCUzduaWloTGJRWERmUzdyeTJW?=
 =?utf-8?B?eTFpRXFzbjJmblJtNDNRWm16MTBrODJVVDdPV2pBL3pBZnhhbFE5ZDI4Ukk4?=
 =?utf-8?B?emE0Y2FHbENuK2dSbVhJZytMWkpHMXlPSFJnTXFvbnk4K1h6ajkzTE5EYnVR?=
 =?utf-8?B?UHJPbGM2M2h0Lzg0cVZBVkJCWkFHYmhsQXVHczJKR0wvNlFucXRkeStYL21Z?=
 =?utf-8?B?V0t3VXI3WTNlRkNDWUdteUNWV2hmbHdwaGd4Y0cxSHBJalIybzVSVHY2Q3V4?=
 =?utf-8?B?SGp2NTJ4ZjV5RWlqSDhLNkJJc2dwZW9GMkp4b3hhdHh2N0FyK3dnZVZzMGRw?=
 =?utf-8?B?TGpmcWZZd29XVkdoWldUdzdEWGlIYk9VRTJzQXlEUTRNMHV0Y3hRN1ZZMGJQ?=
 =?utf-8?B?c2VCMEZPVUFhZjRnQlJ0SjFrZ2VWUHlFYjE4c0VMMXlMUXZKZFdId2RpL3Zi?=
 =?utf-8?B?VlplK2tVcUdkdXIzM0srdG1hV1RaaWw0dm9rT1pCd1QxMVh1QkhVSENSaG9P?=
 =?utf-8?B?WTgzZ0JCNGdoSURaSTR4MUk4Zlk1eW5McTFzbXJJdm5SMnVSRWNHdUNwcmlW?=
 =?utf-8?B?Vm10RWtvRFhPWHVad0IrVkVvbmZTR3YzazBpYnpIYXNvRHlwd3ZyZ05QZ0JV?=
 =?utf-8?B?Ly9KdmlXaCtucUl0NmpJS0NKSlJ4T3pYMERlTWVZM0I2ZkVDcE1VbS9qbUgr?=
 =?utf-8?B?UlBFQUhYQ05RPT0=?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: ce60fb0f-9797-4da0-58c8-08df35a1719f
X-MS-Exchange-CrossTenant-AuthSource: GV1P251MB1135.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 09:46:02.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P251MB0124

Hi Ping-Ke,

On RTL8922AE the connection to a Wi-Fi 7 MLO AP drops on a regular
interval of about 307 seconds. Associating without MLO on the same AP
is stable.

Hardware/software:
- RTL8922AE [10ec:8922] rev 01, Lenovo subsystem 17aa:4922
- Firmware 0.35.80.3 (linux-firmware 20260916)
- Kernel 7.2.8 (Arch-based); also seen on 7.1.9 with linux-firmware 20260810
- wpa_supplicant 2.12, NetworkManager 1.58.1
- AP: Telekom Speedport 7 (dual-band Wi-Fi 7), one SSID on 2.4 + 5 GHz
   with MLO, WPA2/WPA3 mixed. AP MLD 42:45:e8:de:e7:20, links
   60:45:e8:de:e7:20 (2437 MHz) and 60:45:e8:de:e7:28 (5180 MHz)

Symptom:
189 disconnects in about 26 hours, typically 307-310 s apart:
08:52:03, 08:57:13, 09:02:20 / 09:36:04, 09:41:12, 09:46:19.
It happens with both links active and with the profile pinned to
5 GHz (a single-link MLO association). Nothing is logged before each
drop:

   09:41:11.855759 kernel: wlp130s0: deauthenticating from 
42:45:e8:de:e7:20 by local choice (Reason: 2=PREV_AUTH_NOT_VALID)
   09:41:11.917670 kernel: rtw89_8922ae 0000:82:00.0: sec cam entry is empty
   09:41:12.051829 wpa_supplicant: wlp130s0: CTRL-EVENT-DISCONNECTED 
bssid=42:45:e8:de:e7:20 reason=2 locally_generated=1
   09:41:12.051917 wpa_supplicant: wlp130s0: Failed to get MLO link info

Separately, "nl80211: kernel reports: invalid link ID for MLO group key"
shows up a few times a day, but it does not line up with the drops
(7 of 189 within 15 s).

Ruled out: power save is off (NetworkManager wifi.powersave=2). Other
non-Wi-Fi-7 clients on the same AP are stable.

Workaround: disabling PMF for the connection (NetworkManager
802-11-wireless-security.pmf=1) makes wpa_supplicant associate to the
5 GHz BSS without MLO. That gives 0 drops in 33+ minutes and 0% loss to
the gateway, still at EHT 160 MHz (rx 1441-1921, tx 2593 Mbit/s).

I can collect wpa_supplicant -dd logs, set an rtw89 debug_mask or test
patches. Tell me what would help.

Distribution workaround under review:
https://github.com/omacom/omarchy/pull/16978

Thanks,
Berke Ceylan
