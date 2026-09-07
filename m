Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2E40243B
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788810742; cv=fail; b=HKzYgA/bZ1mgRwFiudlrT2/Um0v8zFMcidbn/mlWy508Sqbxoh9Bbxj8v0n6yWXOosacLIFsAqaz1pj1R5WIbX5ARBLzNuut8jTpuhTycg7pbS5jSbXJ8NRrrnOvdAvQeYBsfjHQlJwsd+Au05UV5q1GyUDR88r0zoHsd2TwxQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788810742; c=relaxed/simple;
	bh=VV3Gg88GzmCWIvsNXKYAjvam51atCRf0IlpAwwZzHMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KtGs4ob7ZW453Fe0g2z5LV6c46ZbJZUNEFbbziogSI79uisNrHYjk/mHAcx7J1pCUESZTJ2LEVBEIc44HNKPjGZEUykIlpnW8W8mQyobncMaqJJaFvkJWZwFwXNwCAH95rab1a0gvqRV1zPtk7k3yXGNeQF2wPVPLBcjqnLvByk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=K+AmZxC+; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=bP5Xv9qy; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="K+AmZxC+";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="bP5Xv9qy"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687JFFuH1017890;
	Mon, 7 Sep 2026 14:52:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=PTTJAGqiKs242sEDOW9unlaWxuKOgiPzTzNtH+E+T3s=; b=K+AmZxC+qWQj
	6KJBGMyEx9hqlFZFFs9vvy8oZluUY/xUbuQyHtqobNxgmY3gfoi6501IqLPuY0sk
	cIdUyPewZtHoUe36w95OeePoH9f9JQu5QxMpcw7xUMxNNSKLESukKWmSOvA6QCPi
	oCrF1wqHt+qFjk4wqmW6u2Z2rIXriunOdjejkGf76ZERgVH0G66WOah1mGKSlKbL
	r3m6ZtRg3eZiFlcYUZ/tDUTG7WytBSsHOzjhCC7VJwUM954CpYlgYRsGpU3C8QV7
	UxT27w7WrhSL+4JavobUbS5PS3cfhltEkX5XWtaCqkYkazGIb76qjMgA1+gsNAWY
	+ayBJI/sEw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021113.outbound.protection.outlook.com [40.93.194.113])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggckbbwbs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 14:52:11 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDKcjfs+xUeEuaPIhFQyi8VpBLWam08x4QRbS9OMcD7sEciJhRImuoNwZVltzmz0PfjpAZhfB/DYJ5xNk/rigWPjWU+wxeYrTAMENBoGAurp8LLxUHKzJyqanh4K5jlm7ZxDDcvDQcuiBCTiYa+a7AjOVCqC3ZOyoRuBeGfku8wkp/e+kyzjI3LmbLLV+3JI5z6eHXXejt7baihqBdbuWdTi6NY5pj2Eb4PcKtE4sUuJ1MOnBT8qH376xDB5tDZIo6ZiTivw8/AYnd/Nl2Xf7Vh7cMghj1PRDOLwBp6upun+5DpdvcSwZKkoHbLxxg7qgQUUTMHiiFtlfCSaVDgK+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTTJAGqiKs242sEDOW9unlaWxuKOgiPzTzNtH+E+T3s=;
 b=l5IR7jsG2RKnQcr10iiyTgk+KvCBnM5rWmg3tqF5ytq1XhTjcUl7cIFi72Ad3yzsEJkUIveOj1z41wYU4cDkfu1usAYQljPEpKReG6wzSEI4XRYkSUkkc0mX51eBZr7luj9/mFOBJ6ExEmiICRoluoaYvOUX4n/ZhF2/SFDrKqf3pDHsXsKGr8oygVco1RzSWSp34VOLRKtSXxvVNAYo2BUdsyWpq7UFyvNoQ6ywEiACiPel41Oio2fGEIECC/bLm71I+YyasTt3SQnao62VbxIAfNcW8NFNZpjLqfgY5L7BQypT3ruo0RfS+psYHe9mu38+iWCCOEGYpbmDttuy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTTJAGqiKs242sEDOW9unlaWxuKOgiPzTzNtH+E+T3s=;
 b=bP5Xv9qyF3r24QHsCMLguzWYhkmXO965Fcyr/wQJp17UBNRo2K5fC/Q1pXzTTFIfGhA+ySjei2tsXm4iNdXM1MWS1ZeF9PVIi3KhHydrrFWSG3dOFnAXmzca8uH/krnKgEINk54dMUrGGJVNqOFuaDVvpWuJOSjy9PIcZhlT4IE=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by LV2PR11MB716723.namprd11.prod.outlook.com (2603:10b6:408:3ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 19:52:09 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:52:08 +0000
From: =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: gregkh@linuxfoundation.org, Aamir Ahmed <elb12345@hotmail.co.uk>
Subject:
 Re: [PATCH] wifi: wfx: validate num_tx_confs against HIF message length
Date: Mon, 07 Sep 2026 21:52:03 +0200
Message-ID: <4973500.rnE6jSC6OK@nb0018864>
Organization: Silicon Labs
In-Reply-To:
 <AS8P251MB000103B16A46379DFADEDB21C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References:
 <AS8P251MB000103B16A46379DFADEDB21C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PA7P264CA0273.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:373::12) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|LV2PR11MB716723:EE_
X-MS-Office365-Filtering-Correlation-Id: a4984f3a-34d4-4722-1668-08df0d198036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|52116014|1800799024|10067099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	DEIq94r6cHQlEdcZTicA8Af3xzv146ANDWG7A4H+HluZqCVgZUWoPOdM/who88V/PusP6mhcZZVAbPccAvQISIGi//37IPs7EOfIFczChAhv0FJFfisJTcN0iA53y4m7ljws/ho7Tjs8DGfqccMS946LGI4pob+8K0sCDrpZNQg+nSRcMFprf9n8f56ids1Jz6rbFUDlvCEHF1umX0yfY2OjQwfwFSx4kmyHTMcTpZotPorpSyOsWaAYSMV54dLIOdUTHbWBQ6JEPAbrnm4UanRmGczin12OJOW/O+ESbWtNJAxD7kYOciNNF3b8npXU6F4zKOb+JAiEmutUyIHqPGsueGPHqDNPy/eleUI41WsVkPFrB3UD82Kb2xBx3+wwnsfUXERZzid9y4PErBUrqV28/AqNAhq5DrYq66LvcCJWJ9iEZF1b1UPaDUm9phY/0dDCXnhpWVBFpG/1fbnA32SM0qdwxrnj4lIIFCXEDCtKC4EAlHwlTm4yE/C2fDTI6vRJY50tvEGU7YYtXUC9Awy5DKY/dhMSGbzphmmu08AKSXnlEqeA2z9MUfrs7tG6H0GVjlG0F1pgAkHMeFhUlMORMHPOwuv53Xnp7Afvko7Kv2MBzXxcjGEbib4gdWjdBezAz7PBpANezSKVus50pdtKMUGQ207ZT8CV1FraYdU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(52116014)(1800799024)(10067099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3lCWWxKWEJNVWh6cWVXeEFXd3A0TUdWejhXdW92WDRuZjR2RlQxays1MVEw?=
 =?utf-8?B?L3ZFN09weFhGeUlyam1MZ0FMYndoSldPWjlWdDBFcG1XUm9xMUVndnpGNGNo?=
 =?utf-8?B?Yko2UUwwSlMrbnIzdktyZG9GalNYbUNNODA2K014SVdEcEFmS1AzcWtjTjlk?=
 =?utf-8?B?c1hQL1cvR0grVGVRVENiNW8zV2tmMm43bFpLRWh6VjFZTm5kWmNGbERlZ0JC?=
 =?utf-8?B?N1F5bzUxYWcxbVpHQmFHakJOSnpRZzNQRW9MSFc4bEJJU1JVSnVKS3hDcVZw?=
 =?utf-8?B?QmRSM01qV3pxSlJyYmVWVFl4QWg3eVV1NUNpNERnVlBwcVFXK1gxZEdQVWlQ?=
 =?utf-8?B?MmdBNzFxRTB1NlZ4cFNUWjQ4MHhqUFI3akxHWm1lSWhIODNTT1E4R3lITERz?=
 =?utf-8?B?d1l4cGVESEpmQkxhbU5HRXIyWlFTRU5HQWV6Tm83ZHdtQkVmUkhrU2E2MUpq?=
 =?utf-8?B?RC9pTitSVGVNMGFPd21nVjZacG1xMUxnZitlVG9SbGRHd3ByOGJ5VXJkTjNy?=
 =?utf-8?B?Uzhhcm50YzRneUhjZWRwR1JCS3JNZTVlcjgxQmdZT0oydjNkRlgxV0JqNXZF?=
 =?utf-8?B?Y3VMWnVnMldMSDRlQTd3SEdvWkczMmE5OEJQaUo5c0J2L05Yek5GeVA5NnpR?=
 =?utf-8?B?WDFpYnlQTEVKb1BVRWNNcmFOaE9QUHE1OEpCbk1VdGxub3NYUDlpell0OURp?=
 =?utf-8?B?Z1pkSlhBMk55WW5NN2dwU0pZUURZVXFRY2VLeVRveTJsUE56SWJZMGFnYnFO?=
 =?utf-8?B?aEVua1FuQ2FIYnV2ZmpnNFRIajBDNDEwVElXQjJNRUhVUEsySzNKTWJjZ3Uy?=
 =?utf-8?B?YVNkRVZjYnJQOUNzZE5SRjl3eHdVL3dScFpDMUV2eEdVQ09Gb3I3LzY4SHNu?=
 =?utf-8?B?ai9iOGRUWEtyandDbnFzSzVuVzZ1ZkErUi9tUmUzV3NiNmNjcDlZeUhpMlBo?=
 =?utf-8?B?eGo1N1lYdUlUS3Z5TDNrS0c0eVJuTTk3QW15WG4wc0xJQVNzNkRTRzErVmkv?=
 =?utf-8?B?WmlCclRTRG9VNm5mQmdDazBvMEZkVmdVRGZTYnJ2WFdNNExTN2dsUU5pZlhO?=
 =?utf-8?B?SzJiQU5wN2ZTeGs5bEwzN1Zaa0tabXUyRjVSZmlHMG9KaytaaFBaT3k2TmFC?=
 =?utf-8?B?YUk3aXJGUjYyWlYrYjF0T1RhVlBIWDVsdVlMbEc0MDJUOTNIWFo2NnNvNHdU?=
 =?utf-8?B?Z0l6L1hvUS9yVVYwMCt4RlJJOFRYS0R4WWRUZFpmTWVFWnFaSUM2bnA3R3B1?=
 =?utf-8?B?U1lzRlY4cmZwd0t4UTdidXppOTR2ZXpPTDJEWVYyZUtGVDN2aXdobUwyT1Ji?=
 =?utf-8?B?MVd5WmpPWTFOZzBLMFRoL1YveVBXZWhYcjBBTVlaZkxpT1BLZnRPNFFSS05X?=
 =?utf-8?B?d1VHQ08vSkVXNUp0a1ZXSVltR2xuTG9PZjlkMFRlK1pPa0ZRNHlPalRaSUUw?=
 =?utf-8?B?ZkhJRHlEckRWQVorVm5VaFdpSitzMThkRitPVDVCMG52NWpEUi9rRVlDbU9t?=
 =?utf-8?B?TktsanUxdGh1SkhQZTJHTGkxRDkxZ3loMVMxaWJjU3JyakdrTjIvQW1hZjho?=
 =?utf-8?B?bmJGVFV3Qy8yUk0yNU42ZjFjWEpLQkFhcW5RMHdYRUgrOGp5Vk5wWXB2TVNw?=
 =?utf-8?B?cUZvRFdJeXRWemJkSDVaL1lGU3hjUzVJM0xiOTgzakZUNHV4dkhuZWF1Rzg4?=
 =?utf-8?B?Vy9OZEVqbVo0QXFzWVhVQkVGWkpkeUN6cldtcWV1c1BHMVMyVWlJNEJwSjF5?=
 =?utf-8?B?K08zMWJTWTIyUUZ6MCttcFlCTHJHNTRVWHE0bzE2bXhxNFRFdTlIKzBzejlu?=
 =?utf-8?B?amkyM2F4Vk8yUDRydWtmYUVzUGk1bWdOZW8wNjhXZlJ5TzM2Qm81Q0RoRVNj?=
 =?utf-8?B?eFU5NmM4c3daU0ZqY1p6UlYvVjZ4QkdURy9FTVNnK0RhSE5CTW1iWUFTQ0gy?=
 =?utf-8?B?Qk9iQ0NKSFVISFBzN1BwSlQ3OVErNklhQTBucG9MQlA3a2VvNUhIZ3UvZXJX?=
 =?utf-8?B?RC8zSlJ6VHpEQW5mb3RuMkg4SFpaSHZBd1o0NTNvRStkRjBUelpSZ2RUb3lW?=
 =?utf-8?B?UVF1bnExOTZvR1ZMYWUyeWVzNnNWZmZFVXIwVnkzenlZUm1Qb0RKQjVkanpj?=
 =?utf-8?B?VGtrM2IzendEdkJqcU94aW0zSVpjZmY4NkdhYU1XUDFvMC9TRXIrSWlJNDB6?=
 =?utf-8?B?OHZtc3JhVVNlQTFsUzEyem5yMm53MkQ3N08vZXNOd3JPbjR1VzlybU9TZzg3?=
 =?utf-8?B?SzhkK0lkZFp2aXlkdHpBN0F4NjJjNklmSG5CU292VzNnbXN4QXlydXNWYTdj?=
 =?utf-8?B?TU1PWjM0azZsRUxOWW9VbVNWeGVXNWJlOWNMcWhZTDVpaUo1bnY2S0djS0xN?=
 =?utf-8?Q?qR/1r/f7NQ/HCiyzeeCCbZySw7dNRAnJWEwP78pX4J2XR?=
X-MS-Exchange-AntiSpam-MessageData-1: S+igRMPR4ZkqQQ==
X-Exchange-RoutingPolicyChecked:
	jkMkEormiGOU/5B3WBpPWLyfJZcw6MT7QD5IDXwBSN8qzZc6VVwHoQV7z10u96ZdG9CDvypnBxoLIIWBVX0gAxllejLv7J6tYvDk3j8krr6LbbIqnBrW4S1jUwCfCIFqckn2HsSv0HZ3S1vz2b0CBiSFyjtZYHA4y343QTNNwJUmPzQ+bu5V0+sBrK4LSe4wfioyd141KkmmMnmE+3ZsuyTMSntZlccLTuq/1tfMEEavczgzAMwuXrOYuGRf4DJs3HzyJCOcsnx+wqMDgejvJoYHy/OZpnmU4fU9yx6pTBzNDeaXdjyTTWe7noxj1BH5eoTaMU7wId4z/oL5WQDb8A==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4984f3a-34d4-4722-1668-08df0d198036
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:52:08.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCoD4QVTcrRFSC3SXaIMxBCxhhwV19bGNgyFpssuTWr5kUyzS4zbyYpJ4Pd6lVcaQK8jiJtR8XTGFVSlHe8G3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB716723
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyMCBTYWx0ZWRfX+WwKO7OW+YUg
 oaOXkzfVXhZlv4+UZvYrIyIOUHJc+/tJDdRXlqSEA99PhkMUCrwbGv+VfZJ3zJzXkwQfS5gfjKR
 Vn9Ep4wo1fjwVkjXZhA36Ez/hBdBD60=
X-Proofpoint-GUID: XbA-IfAJUb5K4H2-RfZjl9hKp8rTA4rE
X-Proofpoint-ORIG-GUID: XbA-IfAJUb5K4H2-RfZjl9hKp8rTA4rE
X-Authority-Analysis: v=2.4 cv=bahbluPB c=1 sm=1 tr=0 ts=6a9f15eb cx=c_pps
 a=+jjOclGHkOGhuepu6R0Llw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=Zo5euW2OAAAA:8 a=pqKVCo81eF77v6G0Uu4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyMCBTYWx0ZWRfX554p/kO1CWhG
 aZU+vFGdhIKXnbpKI0bEADnguzlBUFbG3E3fOZQ8z7A04ZbdgJAaj+5UgRzuvsoa7GtN/YOd2lA
 o7+ADYoDtcKUpGFgIpLYAVONZM3UT08ULT4RGG0itVJAksPwFGUeWTDU9G1DIwvohRzm3dqvk2a
 X9FlquLl2AIdFR9Pt/RNA05E97ppQRZt3DFMtuac1+XYTB26l0rN9hdTjeJTu7omznd/xGFv+ki
 VoXb0WTcWTa6JlviiFMmGomMfXMwLkgIw76Yw6oLffNEixHqr+Aa64snwlNu0bIOp19npcHbZfb
 Wtc5ftvwOJQGW0Pj+/I3kHyFsuzrA+uz7JsnhQbPzNHuCOUUI22mSOD61Jr8L16JVi57HHAjTDM
 HgSrO0ZZuWu/YSIN5DPSsgPEEOJvgfoHDptxqnOnpsoZWe+gpWX4DU5wjimn3sXsnWc0YzYx8SS
 QpOLM+8EgiAWDcAz5Mg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_05,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070220

On Monday 7 September 2026 04:59:00 Central European Summer Time Aamir Ahme=
d wrote:
> wfx_hif_multi_tx_confirm() trusts the device-supplied
> num_tx_confs field without checking whether the HIF message
> is large enough to contain that many entries. A malformed
> or corrupted message with a large num_tx_confs value causes
> out-of-bounds reads from the tx_conf_payload flexible array.
>=20
> Validate that the HIF body is large enough for the fixed
> header and the claimed number of confirmation entries before
> iterating.
>=20
> Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
> ---
>  drivers/net/wireless/silabs/wfx/hif_rx.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/silabs/wfx/hif_rx.c b/drivers/net/wirel=
ess/silabs/wfx/hif_rx.c
> index 64ca8acb8e4f..683fb67916c8 100644
> --- a/drivers/net/wireless/silabs/wfx/hif_rx.c
> +++ b/drivers/net/wireless/silabs/wfx/hif_rx.c
> @@ -62,9 +62,15 @@ static int wfx_hif_multi_tx_confirm(struct wfx_dev *wd=
ev,
>                                     const struct wfx_hif_msg *hif, const =
void *buf)
>  {
>         const struct wfx_hif_cnf_multi_transmit *body =3D buf;
> +       int hif_body_len =3D le16_to_cpu(hif->len) - sizeof(*hif);
>         int i;
>=20
> -       WARN(body->num_tx_confs <=3D 0, "corrupted message");
> +       if (hif_body_len < (int)sizeof(*body) ||
> +           body->num_tx_confs > (hif_body_len - sizeof(*body)) /
> +                                sizeof(body->tx_conf_payload[0])) {
> +               dev_err(wdev->dev, "corrupted multi tx confirm\n");
> +               return -EINVAL;
> +       }

body->num_tx_confs is already used in rx_helper(). So, the
error detection happens to late.

Until now, I have considered the device semi-trusted, so skipping this
test does not shock me.

(I tend to prefer the readability of the code rather to clutter it with
plenty of error paths impossible to reach and impossible to test)


--=20
J=C3=A9r=C3=B4me Pouiller


