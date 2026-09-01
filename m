Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC71731BCAE;
	Tue,  1 Sep 2026 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788272137; cv=fail; b=Ffo9FrtlluDik51ScfgSKwGpcutK6p7ZdS/8YtXkGOz8/qls3udl3aIHGxFTWIiMCP2w7QvabYORRJ0go70d8m16ptGGe3qQi+ziU3IHV36K5OXt1jhU2DgFzEW6OHLUnTnl37ewBjILjHCBImSVSi7aqb6DsJWt5mSLopvapmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788272137; c=relaxed/simple;
	bh=yn+5eArbb7TiX/2ZMReLkNjHBjwwP41hZYlaDVEQnbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZO0j6WAtRv11TYMU+vsFLiq2LFwuWtoW1uKN22Nh0m9EVtBiwHynRG4olVyC4GDl59mR0uwFbjCY/it07N2U/J5sDUyRuqKsXzk9oPHBEGatS7AD8OqCMTcR3b/zokoHgOPQKpRPKmSOhkTsJw84uBZAQYkNbaCR08UMO//Ex8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=njQzQC6S; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=VmyQOuA2; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="njQzQC6S";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="VmyQOuA2"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681E8W4f1526246;
	Tue, 1 Sep 2026 09:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=vi2zN89eZkqtmSt0Q4sFrcN5DtDSUBjT9ifIvRcxQbc=; b=njQzQC6SNZSX
	1kbgfBjhU6snsqeL/zYUj0IOHRlUVIn77WHJ/qtPUVCxJfJkDC83KIYWace8LHMz
	ksmiw/SPbveJMoECIBmQn98Skkk9QVN6A6nK3ZIrQX5HSsWdbkgDy9b41RYgHz8X
	9Wj0bpB4xgOicOZSiz9idHYzuvOJqv1nR1i+G3wFrhWsDG3ACUrB/s4iWGIXqLxZ
	wK6l0PcAZGZfPJN7uWNhE7ki2r/dzTnjd3EP/Swk+DbWZa6DTt36AjMpMJDINY7v
	0eTY88UZwkqrCTj+8je5Am9k3+en/e23lAKncYh8ovhmNe2P+BjfFHhN7lwjET8m
	xkopESZjew==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020115.outbound.protection.outlook.com [52.101.46.115])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gbrx96nwv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 09:15:25 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=st1CgZPJ2moZrX7kAQyS4f9OVlMw8ykVmPzU/uEd34gZFZi9ODrthezzrtduim6i63dZZ7fjeyL0ujBIR793JUZY0PFOgPeaH9qmLzLx+0sGOyvgOIXhlUBPzVie/RFu0NhF28kiG9eJcFjGLGVXFqwfAH9WwbOLjHsL2vdUB8jCG6c30S8sJTaAwD97Q5gaLM4KTwhQ462uSvXeyXs2Nay5m3cmutsSJGW58W2hQj9BRwXmMMfgG3o9x6ehtwywhxhrh/rLPmfQWTNGqcQD3y35jipwcZr60pkji0GBEICYqpOuU0qvQZqpCixKxeEsvUga/+h2Ph+otg5NjNF34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vi2zN89eZkqtmSt0Q4sFrcN5DtDSUBjT9ifIvRcxQbc=;
 b=ytebnfopZ6BnjoEc3rITtmQo8iAdNoyNuGFfWNP3Eu2lO5AEUAGRaRzp/tRXrXoHJnXnbT8/y9Mw0hsGAM9lPmi0MiNTuLhSA46ZFiMMkDEjvpusNRTrqSL1VqVZcft6n20B3HvEN9VVN5Up/dSi42ooSPH9b4szXRQ8PqXjGVsaijd3/5LYYSKRPpZtaEOgFcHGe3cvI3hcZzIE/t4APQ+LldBbk6UYOrkeUp4iDUa9Yc3xUR8c/5LNH73sQZ2L7FFAhwWcP9ljHC2zD3f9v0nC8kuNKR+ugM0tXKqB9kxQz+pM+FX503DykS3qq+7of9Fw6dC8nhowO8l1iyouzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi2zN89eZkqtmSt0Q4sFrcN5DtDSUBjT9ifIvRcxQbc=;
 b=VmyQOuA20CAEBk+8RpKcbkk7hGRtUq9KuTKPmbGjd8I8rmOdZz5qKBREp9gH+JWorSrfUm535yo+fYrBTEw7MwG+sQgQqXyNYw6/socaLzK3moLtb9ehOek24wMtL+8mFeWeEdfp1SutjOiivmqg2ELFkH6YgbWNodXBUMWAH78=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by PH0PR11MB7613.namprd11.prod.outlook.com (2603:10b6:510:285::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 14:15:22 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 14:15:22 +0000
From: =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
Cc: "linux-devel@silabs.com" <linux-devel@silabs.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject:
 Re: [PATCH wireless-next v2 1/2] wifi: wfx: fix possible device hang during
 init
Date: Tue, 01 Sep 2026 16:15:18 +0200
Message-ID: <10908680.nUPlyArG6x@nb0018864>
Organization: Silicon Labs
In-Reply-To: <cc4de4e40e3ca50e7288be2b9067802576567c25.camel@siemens.com>
References:
 <20260901083548.113131-1-jerome.pouiller@silabs.com>
 <20260901083548.113131-2-jerome.pouiller@silabs.com>
 <cc4de4e40e3ca50e7288be2b9067802576567c25.camel@siemens.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PA7P264CA0112.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34c::15) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|PH0PR11MB7613:EE_
X-MS-Office365-Filtering-Correlation-Id: 8894a95c-0402-46b5-cfcc-08df083375a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4022899009|52116014|3023799007|6133799003|18002099003|22082099003|56012099006|10067099003|5023799004|4143699003|38350700014;
X-Microsoft-Antispam-Message-Info:
	jPIXr7fidT6zmmiCSvBcQrrCFMiE+tbOB10pstWvuHmbB2SM5u5mEB7iWRkiZIl5yYQVdPVv5VatsMbAcVVZUyXQ8WG/PS50By1EocF6K3TqVIAvkdnUcIo9AT2dMI21ShMsJyT9qAjQPkwpia0D0wWrPHWiL0PovJH9eXJhlalZQvsNbjm23hxOM3AEquTkOG7W1Cr5RidEb0uieLV+EvZcRu1j4ODS/koM83CSOcYFQnp5dXn9GhDTyjOc55THApJD1r88PJWQ8u9+GqpZcUjvO/f3jdOuqKxPOqmkWp9Sm9DdJoRBOvWFdJ0eBu964EZR5yJXlTs8n9w05l9a9p28HWmzWZ0ckB0D1As94b3OA7PPzCJCJF9TwcJGfzsigmA57FEK/hCH99MnatROESbncisIIdMsqBZBk9PJJ56zdFYZ+WOPYLflKe2/wu/mgMjzUskJVMuXgt20J+W0dUwGqE/uI52ROwTZh8RYDIWgdZIaPLkCgR/3FK91sUTtq00vWeeQlSHRxOOd/UEmttlQEB6UMGhvSNvWRzLq95rhKLz1iQkQBmibfyMTV9m/NoaSf4otpMXmYAUyGlbdkoUffoF4hfUPn1yXPDjhLbmSTjugLZ+v/cK1IW0CZtUbkCR0BERg7AThPQEJPQ287uNkoBfOmNSHKtZas+RD3CGSWbu68pv70ASqW7FicVnWz1xP8kVkpMWlwwxsO1hCeIvffJytoYf/jesiQ5CwDFw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4022899009)(52116014)(3023799007)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003)(5023799004)(4143699003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzdONXRHZVU4Z1ZxQm1POFhIVzJQbnFEdWQ3VVJ3UnRsbU95N2RSaW5IRk9R?=
 =?utf-8?B?Q0lUYk5RNGptZVRXdThPTlBEMjdUQVJ2L0NlY1JucWpYTTVNYjArWWRFL1lt?=
 =?utf-8?B?YVpYN0toY0trSHRpSnpQSURZZGx0bFJEc2dkWmhOMTlJREhETjA2L1dmVnpB?=
 =?utf-8?B?b1Z6UklmRDFVcmZYN2JnU1RJWHM1WkoyTFVFMHpmdXRKS2l2ZERxNnlYam8r?=
 =?utf-8?B?dUt3eS9SdjZ6blFqQ2c0UWRyTTRvdk12c0tiM0xPVFlvZ3VydWhpVGsrSWV4?=
 =?utf-8?B?VTNycFF3SW9mNFp2MlUwbmd5TXBoSnRYdjJTM3JxVXdOeDh6aFhkbTNoVStC?=
 =?utf-8?B?V3dPTS9jNUZRdS9ZNjhrK3FVTTVFTU82blhOWFVHamN3UzViRVZTWlorR0dy?=
 =?utf-8?B?QWcvU2NSTHZ2bkhTTlRYeUxiOFFBUEd5NHk0Y0xKeGU2R1NuaW44UUFaVGFx?=
 =?utf-8?B?WmpabTNKS1dsODhOdGlVM0pFVExzeW8xbkVWOHhNWWVCaXZyRnZHb3QzemxC?=
 =?utf-8?B?S1drQm5USGZxQ0IwMHFaWEczLzkvV29yWFZNRlAyT0lidnRMa2FWN3V2ZUZt?=
 =?utf-8?B?ejdNVHBqN3RHL3JEbE56NE5COXRFQkFpNE5kK0RWODEveTBRSWdJYmRCck05?=
 =?utf-8?B?bmJ6T21pRkxEMlVCWjRMODNVVHMyTjU2RTlJZGh1OWRhM0U2cS9HWlBJZnIv?=
 =?utf-8?B?SmFHZVNZajk3TCtlb3NDL2taMGR0TUtFenRFUHpFK21aNEdKMFlGQWRFb3pq?=
 =?utf-8?B?anRGYUF6WmZxMmZGcTlheGpwZ3NQVGt6alZTWEYwWitFeEUxS2d6ek1LMnRt?=
 =?utf-8?B?RENVR215U2pIT3lTYkF5VmdEcW9WRkNBSHRQV0x1WDRwQ2Q5UU1rRVBxeWtZ?=
 =?utf-8?B?cHBDaVlsTWJacXprV0ZSSWhYR0VZd2F6UWhBaGJRMW45dWI1WEhFVkdnaUtG?=
 =?utf-8?B?b2tXZ0cwQnFsWEhOVTh0ZW9SY2dEZndsSlFDTkxxc2JNSWtzcnRRS3pueVNn?=
 =?utf-8?B?aHZxRzBDd2VKdHdNZk9aWndkci8zK2VGQjY3S05HT1VRSDhCSis4NHVjUXky?=
 =?utf-8?B?V0wyOWdyblBmQm53bXFpY2NJbGJIY0tSWUREVlJhWmlrNjlEWnVKbURIdHc0?=
 =?utf-8?B?ZC9iTXA1TjU2eEtqWlNncTBPdEFUcDNHZ0lqTXQxRjBoUU1DNVhRQisxSTJ6?=
 =?utf-8?B?OVFkUGZDRkE4eWt4ZWtGNm83dlg3cjVZdkxRWnU0MGJKM0lTbkNsN1dUbEc1?=
 =?utf-8?B?cENvTjdEL0o5K2xxQisvbE5IQ1NuNlVpaldYeTFRSU4xV3ZsNm1rY2F3dzI3?=
 =?utf-8?B?clFXNU9ZKzdaWU5tNkFLNkc3WEpXSythS2tLeXlFR05oNlBoVW9scWdNbEdT?=
 =?utf-8?B?YlZlaGkzTHlkK0VpUWxPcnJRNTRPOFFOOGxORFRqS0x2WG1BRmZCNUQrY25x?=
 =?utf-8?B?VjNLK2hYa1RWMUFMWEFERUt4ZlcyK1dvRVo0UThMYStVR2hyZWlSaGhMWWZC?=
 =?utf-8?B?bmVPcnR4SU1KbDdpQzYxbnlwV2lDeGg0QU1NVmhlb2E3aEhtWTNYZHowVTlK?=
 =?utf-8?B?bmt1a2JxNEVmazRSODN5QWZCZGtVdkJET0tRRTZGeGxNMHZqTlVDVVVQYzly?=
 =?utf-8?B?c0VBT3lQVlFnZHJHekluZEFqSGQydnhKRERtdlNMR0pHcFZvc0VXSkpuNHZ3?=
 =?utf-8?B?R0g0Tll0bDNZQ2ptcWd0cFhKdENnVEpqNWZKRDk5SFFuZmRlb1dvTVFEdHJj?=
 =?utf-8?B?OFgzSlQ4Q2Z1RTVLbEhlUkdLMWg4d2d4NjJxTjBvQ2wybmprcmUrSkpyTEtz?=
 =?utf-8?B?OUZUR0RNSkd6K0RXaWdzK1JzZ2lJK1hYYURSN3ZFdHFoU2taamtaUlNreHFl?=
 =?utf-8?B?MGtpUmd5UktKSGRDTGluS0dnTmhSVWRSZXNZLzM2SStuajE1UHJRV3p1ekc4?=
 =?utf-8?B?SGZlNEVNdnJ0RjV2cDJsaldvSCtJNUFBZzY2S1hNWWtWSGc5MVRTOE0yRGF6?=
 =?utf-8?B?cFFTaUh1VkowZkIyeEFleWhjWUorWmN1NTNNUWNkdHZqOC9HbHNwVWY2SXNH?=
 =?utf-8?B?aXdxUGlkckh2YzhXZlBtWnZ1ciszdThzNnhKT3JhS1BUd293ZmZNWDBqcHBO?=
 =?utf-8?B?YW53UUNnZlJmWmlMZldiN3V0SnVOWDBoaVBkaFYvTzNzdThGYm1xZjZoYi9W?=
 =?utf-8?B?TWdZVmpkYlJPeFJOb0gvb2EyU0Jqa0tsTnovbDlHbmxCeC9IN2t4eVVGbFpz?=
 =?utf-8?B?VTJZSGhweEtWdTM1cURBK2JGUStWRG5ncFgzTFRRc2E3bCtIaloxTytrWXFI?=
 =?utf-8?B?b1U4amxNbXR4YWpKOGlQdG5ZY3dmM3NUV0FseFd5QlJwcy9CSmdMUT09?=
X-Exchange-RoutingPolicyChecked:
	tvkym2MqhZBSpMKjihmQFvSE726ejN7JpFJclfPY1+qPks6PeBF7WYDPSKPPrHaw0eTYYqC+YnrQZI9ttJ+5nrOJ9wrEbYMJcbc+g9tdxyV9ipuoU0ZDZnJspLQHHZiDgrZIyXJnnSkBYIseR3UkjWthwwrm3s9DM06qPjubkQ1IXU0UlQ36ANq6x6LW7BeQT4mRHjyvkJlSPu72aQyLAtCPgsGMwGq4wtlk7K3Sm++Po+9zfl1k1RDbwttgqJp8nCEu4n0Yu0xY99URy1j3jRmTAtY4zjp2/S/APhgq53486eF9LdiRGi3fEGJ8YSrlmfn1D81fncaVoxaaPVIJrg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8894a95c-0402-46b5-cfcc-08df083375a3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 14:15:22.1565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOncYJZmEg2FPTHNLTSAmHXf6xhLlwycgKHNfSVZg+uGIPPjQ6Tf+YhhyPOT7I3YAdMzZwJmqQy01QAFNq3ZQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7613
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDEyNSBTYWx0ZWRfX6hmrP+klxq5S
 GPTAtYv5O5QM4mXUwTmT0PmJjtr8hi/+D/u/q8KqdG3TzLON1ATH15icLMMKyUIvQgYwsCDEHd2
 aGCvZ7DAp7f5bpUdpYh0zAB9G1zwPlxEhfHPEuevZqiNDpb2e9Qzcmv18E55OB/8H0GwOqrZbXf
 u1fjeh98Et1BV9JadiDyIts8KNZx59SbHopvNe7tyTlpi2Ha2QWd4sOXHIJ5VTLiYazTHXdT1Nk
 rdI3Wmm6+jok8HuACOZpl549TWYLTMT2F6K03P9x+dyBWZ3RE5CbD/4CwuXHNdD5F9J+ZeLv6Ch
 n2NuMcBoSzWydADdXhErMzZzJvClLjhDgRCtMQ8Dppq9PauOJqjL1U7X1rmFw0O9BWlJVSFi37B
 MGgwPDvl0rbXb9Az8XjH+YzQfK7h6IM2We93V3HT05pclIZnerdjnDp5xC+mk/iakJUsNlXD04o
 dSbpeaES1gjOtHU1EYQ==
X-Proofpoint-GUID: 8CGjHvsZtEARrETyTU2gO7rRYobLUzl9
X-Proofpoint-ORIG-GUID: 8CGjHvsZtEARrETyTU2gO7rRYobLUzl9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDEyNSBTYWx0ZWRfXyyuS0yoTP3nS
 oMJ5JhXhaK5hN4cfhMWVP6NDoDoSE1zcTJSZXClKvEc4S0ApNkYHJ+DWOfdKsy8fye4M/idDHr4
 s/bfs7GFghZHdtPidpnWvkESqTgdZcM=
X-Authority-Analysis: v=2.4 cv=fMwJG5ae c=1 sm=1 tr=0 ts=6a96ddfd cx=c_pps
 a=3+BHtXVVVEj9tth3MIVLhA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=a_U1oVfrAAAA:8 a=2AEO0YjSAAAA:8
 a=05c6V1T6kwCnyL1AXLcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_04,2026-09-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010125

On Tuesday 1 September 2026 12:43:22 Central European Summer Time Sverdlin,=
 Alexander wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Hi J=C3=A9r=C3=B4me!
>=20
> Thanks for the patch! Just one pre-existing issue below:
>=20
> On Tue, 2026-09-01 at 10:33 +0200, J=C3=A9r=C3=B4me Pouiller wrote:
> > The WFxxx device provides an SDIO interface. In addition to the usual
> > in-band SDIO IRQ, the device also supports out-of-band IRQ line. OOB IR=
Q
> > requires a specific initialization described in commit f00dc1d789e1c
> > ("staging: wfx: poll IRQ during init"):
> >
> >     When the chip starts in SDIO mode, the external IRQ (aka Out-Of-Ban=
d
> >     IRQ) cannot be used before to configure it. Therefore, the first
> >     exchanges with the chip have to be done without the OOB IRQ.
> >
> >     This patch allow to poll the data until the OOB IRQ is correctly
> >     setup. In order to keep the code simpler, this patch also poll data
> >     even if OOB IRQ is not used.
> >
> > Commit 57aa557f110d9 ("staging: wfx: introduce a way to poll IRQ")
> > announce some limitation about the data polling mechanism:
> >
> >     This function [wfx_bh_poll_irq()] must used with care: if an IRQ
> >     fires while the host reads control register, the IRQ can be lost.
> >
> > However, with last analysis, it seems it does not only impact the IRQ.
> > When this condition happen the hardware is lost and won't reply the nex=
t
> > commands. The only way to recover the error is to pull the reset pin an=
d
> > bind the device again.
> >
> > Currently wfx_bh_poll_irq() is only used during the two first exchanges
> > with the hardware. Therefore, it has been reported to only happen after
> > a few hours of bind/rebind in a loop. This explain why it has not been
> > reported before.
> >
> > Fortunately, wfx_bh_poll_irq() is only required for OOB IRQ, which is
> > probably very marginal. The In-Band IRQ case also uses this function,
> > but only to simplify the code.
> >
> > This patch limits the use of wfx_bh_poll_irq() to the OOB IRQ. The bus
> > driver now tells wfx_probe() whether polling is necessary. When it is
> > not (in-band SDIO IRQ and SPI), the IRQ is subscribed before the first
> > exchange with the device and wfx_bh_poll_irq() is never called. When it
> > is (SDIO with OOB IRQ), the behavior is unchanged: the control register
> > is polled until the PDS file has configured the IRQ line.
> >
> > To conclude, In-Band users are now safe. Users of OOB IRQ will be still
> > impacted by the bug, but there is nothing we can do (and nobody
> > complained during the last 6 years).
> >
> > Fixes: f00dc1d789e1c ("staging: wfx: poll IRQ during init")
> > Reported-by: Gerard Salvatella <gerard.salvatella@siemens.com>
> > Reported-by: Lukas Stockmann <lukas.stockmann@siemens.com>
> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/net/wireless/silabs/wfx/bh.c       |  6 ++--
> >  drivers/net/wireless/silabs/wfx/bus_sdio.c |  1 +
> >  drivers/net/wireless/silabs/wfx/main.c     | 34 ++++++++++++++--------
> >  3 files changed, 26 insertions(+), 15 deletions(-)
>=20
> []
>=20
> > diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wirel=
ess/silabs/wfx/main.c
> > index dda36e41eed13..4e99fe7e5bb78 100644
> > --- a/drivers/net/wireless/silabs/wfx/main.c
> > +++ b/drivers/net/wireless/silabs/wfx/main.c
> > @@ -399,12 +406,12 @@ int wfx_probe(struct wfx_dev *wdev)
> >               dev_err(wdev->dev, "unsupported firmware API version (exp=
ect 1 while firmware returns %d)\n",
> >                       wdev->hw_caps.api_version_major);
> >               err =3D -EOPNOTSUPP;
> > -             goto bh_unregister;
> > +             goto irq_unsubscribe;
> >       }
> >
> >       if (wdev->hw_caps.link_mode =3D=3D SEC_LINK_ENFORCED) {
> >               dev_err(wdev->dev, "chip require secure_link, but can't n=
egotiate it\n");
> > -             goto bh_unregister;
> > +             goto irq_unsubscribe;
> >       }
> >
> >       if (wdev->hw_caps.region_sel_mode) {
>=20
> At this point err still holds the (positive) return value from wait_for_c=
ompletion_timeout,
> so wfx_probe() would return a positive value (as failure).
>=20
> But maybe it deserves a separate patch.

To avoid confusion in the reviews (since this an unrelated issue), I will
place this change in a second series.

--=20
J=C3=A9r=C3=B4me Pouiller


