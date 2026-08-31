Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574383890F3;
	Mon, 31 Aug 2026 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195156; cv=fail; b=hh0tY3hCP6OmvvYp5iMsc2Kn69k97YuVSm1h7Odf5YuIQZMvvoekIcp7JCMa9yh1r5C5GnFUK90nzPEFZYvMlTno3cbj0N4mJgr0seTtPt2AmWz/j+kP3RicJOod1/mnYam3bL2HCm5tqQyBac43qXFVOKFvi4E/zxGWwv7xZk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195156; c=relaxed/simple;
	bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QQpzdz2KLdO194/BO87tIGIxEf6kQ4P0cNlkdDTTrUy8OmABmYC4P+auAbTvNHy8BI46v+QKIwP931uFUa60plDofGXU5QzqJ8id+nmMdWprsWMZcxIyQRsP4WBTYCeXz2OOW3UnoENMSq5ZwZ8X102Om5XAh4I9+FqhnEgOelk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=AL71KHo0; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=cOSKn5Cr; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="AL71KHo0";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="cOSKn5Cr"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VFiOgl3259035;
	Mon, 31 Aug 2026 11:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=; b=AL71KHo05hcH
	ejnbDn0s6qcsjN3a3eCOP/EweyauXNE/VaKhPM3E2FJkReimM5WTR6fElsqrXFL1
	QbnK/1VSl1EY7YyzlvA4ZHxN7H7OJr4TbWZU2XM1ifo23am0jzgnOogcyw3cEKtK
	poBG8AfKCS1S5EipM6QmVNAnLzajvAktJgujh+ddW9xSk0jfvJzpoW93M0Jq3bf2
	mktWudsIyckXVq8+XElEcT/CdRLcx9UnsdtLUKRmbhghFG+Kdmzq89IVLJ5YdcEY
	VUY8+lsZ8XEE40jRCLpFisOCvNeO7z9XC1gZwk2f6e915RTOOt72wBRpNYzZ0cic
	0LkYuYABuA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022103.outbound.protection.outlook.com [52.101.43.103])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gbrx946p9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 11:41:26 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2thsTxiRTF7mX37yJf09r8bNaE55aoZqszXpQpFXSaARuWxq51rB4p6BqV3hSCF0E6sNYWy4VLLq3hccsA3qS5N9UNAr42TXcRh89ADCzpyZ2RTkx5GatRXfPsDs2VRPh4nOKvx7ot1RfY3OhlB62eXsPk98/HzpX63k+3cSjpbVy6Jxpd3MCHom1vrMVAkHVQ7hTzG0x3G9zVba/scUhjo09C0A8YudsCx4OttILXgOYwUHHJuVl5wKU2PbUHZSGDElGfnxzfsFQeTH1eDYJgXuXmScnDsit3d3tgeR+tozTLInSH7xaqMAduKTVZHgyrUI4ulfs0zalmwf0fHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
 b=l2Ry01/t/FyZNg+iIWutpod/SZwovHBA+JFUY/KmyMrKsV3kSCAOP1MbQjeov4fmrdgB4IMWYcYbUlZTYW7wFXNp0lE5MckkXhJRZ6p6p1JHEPcjvWDrq+POOM7p2ig3m0Vzo6Joi6Z3oGZetMdFZoV5Vx02HOF6hZVZHpe7UDyRPBHTUhWod51l9bDEfAYNwwFDPEi3IKzDWtrwJKIoQIjSTPAWDQ7z6NEz/KMGTtOnK0m+zvrVBNlD2dubzl2DecbRrzMvHc5evlZ1lhpY0HTvjzCrkbH5PecjeEtzIwlWNsqWnl5KnRMz4YTBJAr3EHz7Svd0vWfz9tlxtn8Kjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
 b=cOSKn5Cr+igingR1OmX9LLCrSJaTW80Y+qHhKMDkiiaJwSwQex14YDEc695ixVgpDBd3n+lFOcCOzPhXz4AaqmytMdidbXnnOgykslvlwOWik2HipUU0leMHmEIdR/aP3RoovUfOvPnoZFOWgajm6EpZYZKsUbAgnOt5ulQE8f4=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by IA1PR11MB6492.namprd11.prod.outlook.com (2603:10b6:208:3a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 16:41:24 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 16:41:24 +0000
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-devel@silabs.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Lukas Stockmann <lukas.stockmann@siemens.com>,
        Gerard Salvatella <gerard.salvatella@siemens.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Subject: [PATCH wireless-next 2/2] dt-bindings: net: wireless: wfx: discourage OOB IRQ with SDIO
Date: Mon, 31 Aug 2026 18:40:13 +0200
Message-ID: <20260831164056.47683-3-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831164056.47683-1-jerome.pouiller@silabs.com>
References: <20260831164056.47683-1-jerome.pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAYP264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11f::18) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|IA1PR11MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: b23912ec-4c76-464e-5605-08df077eb1d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|52116014|6133799003|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ed7mSFcKfAyG2iKzId3+BTago50lhkGTJ9jv1B3Y2oPPT/YwPDy3ldsvNiKuMU5+bO/oFZDwLaSZzM8TqPDuqb0vMswuc8pjMJS4aOaBxXW7uBN+Ukq2HP6KcWkx0lRy4dRgqtgVHgmDzfXv6KnC+SpmVGZBl7OlCd6U1poze1prDvXlrmX5J5hwkuEfPniRcYTjCsN9JKRMaflTsnnunKCra3QHTV4Jc1Nc8+FHFyzZCIdbDXN1eOeh5ZVfNX5tgyeEjkhINZqykpcFwt2nAdNhzGeAPeoV1chjOivCK/h7ruCjugYb6dcB79/tdVlwsSSuK0AX6GKxDEdPyTPoygyNP+dDuJBcTqtlkr0FVAfp8vHucGclljy8yAA9Kxb5eRv/CkhzA0ozj2pE0fgPVqlKRI8hSEdC/Y8jMO+KDvhgnzeG9YnOXc5s1qTVARqTDE2jAlNOiokwho9Hexvl4FAaZxGGfYAZtGs2w1tvpzIHnpj8E37QbCdcaS9C78vsuGoOS1PMypuzNCH9afk4i3rPO8fELDXpw4OYu7/eTjgOhBAgQauWG4sqzRHBDavC2y9IqjtxKXc9D2jFBZrZRTeb1FdLzOrD0y7/K0Xw2PU3Srh6ppYdGn3AyetUysij0g+ugqItgfGGTWiBTn3D+qSwPI/b5MoP6YypK7AeR1s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(52116014)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzFKbXJsbXBEZ04yaS8vRlh0ekx0NHVWTytmbUNVYXRpdHNNSjd0QlNFaXBy?=
 =?utf-8?B?WXZFa080K0I1bnBUOWNLNDBnQ3c5QnEycEdTTFU5NXArOTF5eit6Mm5DcDJz?=
 =?utf-8?B?YitHUVYxQnF2cTAxK00vckQ1VEhRdGw3cFBqM05QYmYwTFBUelhtSGFyVHRI?=
 =?utf-8?B?Tmk4MGVJQzJyQ3hIdzdObmxUWjZaN0liL3RZVEJXRHg4M3QwVUdoWXFXL2ta?=
 =?utf-8?B?Z1k0V3ZQNGZwNVBGZzMyWXhFRmRvNVptWVVJMzE0OVNXb1BaZGRSYTMxTkVH?=
 =?utf-8?B?eFJoWWoybkNlc3VwQmpndmdndjBOai9jRjF6SkpIMk9UUldvQVBvZURhaWw1?=
 =?utf-8?B?Vjk1dm9peW85OTluVXZpYXA3OGNMRE03SjJTbkRDeGJidUpIbldITERxU3Vm?=
 =?utf-8?B?azcwZXNVV3hpVmtLSE9BRWtlNDlsd0x2MDcvRGg4dHNEUUF4aHZEMHArejNN?=
 =?utf-8?B?ZERZSk5WdGpzeFpacHBDK1FPVDZSSUJ6K1VnL3JFYWtKNE0yUGhkZXozMkZi?=
 =?utf-8?B?T09YLzd5V3lqNC9XYnFmQjN3eDI3cm0yRXJCTFA2cEZQejNBVk5pOG9NREs2?=
 =?utf-8?B?T0MzTlV5bmNFTE1lakFGekF2NkZBbEoyRVdDOWdXd0pKMEI2UHY2ZTFBZG9x?=
 =?utf-8?B?bXJjRnFkRVYzL2lRbTVjR2NOK01YYSs3L1ZNZC9xMkxKODdlSmZlR2pXQVVG?=
 =?utf-8?B?SGREbUpFNXE5SWhmQTRtSUtSb2pxdHkyTXhzL1FLTjJGaHVoSCtzbjhZRm1H?=
 =?utf-8?B?YkZXQzlRaVlaNEQ4ZDhTNGJyRW03U1Q2S1BhTGtjekNxWkkya2VTcmxPaG5D?=
 =?utf-8?B?a0JEbG5MRDJVNUVteTZKQWpKU2s3K1pWUTBRdkxRSVQxWDlOeUFtUFpPVml2?=
 =?utf-8?B?VVlZME1qRGVWV2ZBTFIyeHJQTm1kSDFwT2lrbGFwSlZkemgzRWd0QlFzQnlL?=
 =?utf-8?B?eGZ4SW8wNzRGZkxMR3ozMXU2eFgyZVF6b1RnNE1MNDNDSFdmd3FHWkk5Nk5X?=
 =?utf-8?B?ek91ZmxLVDRnVDBNWW1BWnM0Zm9oUll0Y3ZaMnZLOWtVTjVsYTNCcVdaRWFR?=
 =?utf-8?B?VDdiVFhRVDdEWlhLYXBOQlUyMEpqSzBsWUxTb1lOUVJFdXlHcTMzaUlRZXk1?=
 =?utf-8?B?MzVvRkRkYjcyY3NwRWFsNURObTM2WXFCWGYvYVQ0cVpBdXdPc2VyaHZJeVdk?=
 =?utf-8?B?ZGZNZ0xqbW4rWUQ5WTViTm5IcGF6d3J3Y3p3ekZzK2RCWUwxY3lEVmJWaWlQ?=
 =?utf-8?B?aVVoRGYzTDhlQTFuY3lCV1VZS1M3VzFqZzJPVmdOY3Y0c3ZDUTZ1Ujd4QjRt?=
 =?utf-8?B?WmsxVERFaFB0L3N4ZjJLNXFQR09rSmNZZzQ4TW5acXlEWEl5R0JrTWZwNGxn?=
 =?utf-8?B?YkEyc1VoSGhvVEg1bDVOOFFobFA5aGxpbHZpY3F1bFNVRk5xRHhySE9qMlpw?=
 =?utf-8?B?aTFzTnpZSUp6MzhmS2ZtSUNMTyttc0M1SHJhalFobDdwQkd1ZFNDc2tOeG9w?=
 =?utf-8?B?T3gxUUtKVkFCakh6UHV6dERJenNnd0lSRzJ0OTBNVndkMjNGZDd2TmVaQUZp?=
 =?utf-8?B?bm1xS3FXVkcremVXVHdUb1dCTFUyYVhHZUo0QkJSWENDS2NhclBKSDJTekd3?=
 =?utf-8?B?Nmt4Y21BUnRZR2NjejBhM3JXOTNjNDZUMG9uUnNIODZxZU4wWGpQemxaRzgy?=
 =?utf-8?B?UzdKQVAzSHZ2Y2tJQ3l4aXJVVG1xenNRMkdmOTlDNHV0ZHhXQzd4VERmazJD?=
 =?utf-8?B?NjhWQ05maTNOWExvbHlSbVdWTjdybi9ETmhWamVBTHJ3R2RrbnBwanMzWE5u?=
 =?utf-8?B?VHFqdXF5NldiV3E1QmpCbkVhTjBOU3V6NysyVlg2RnFnanpmTkRRUndJenJt?=
 =?utf-8?B?YXJZT2VFZnRUY3FKMnpmbWRNSkdSVUtGQVN6OEhoZ2JEcTNRRFczZDlYYS96?=
 =?utf-8?B?czRuUXJOV2J3cHdGSTQxdTFSNGkzanQ1SlhWWXZLUEFKNko0OGwycXBrR3JE?=
 =?utf-8?B?cUZ2MlJKaGFLb1dlTHVaaGI0bnp0bG8vNlhnWGdkY1pSSmx3UjNrS2tiYXFD?=
 =?utf-8?B?eDIwR0F1UUU0TFVEZitGR2E5Skw5Nk9kL1VnZitiY1ZucTBBKzVMWmdRWU1u?=
 =?utf-8?B?M25jUkFFVmxtZEtzZ1VJMlBRZ1RLODh3WEh3T21qaitYVHpBYUhoTFM1VU9P?=
 =?utf-8?B?Tlo3Znd0TjFOVU9yd2x5YjdVUHc2MkZET3gzRVlDM2xueHVaaDlPYWQxeWkx?=
 =?utf-8?B?VTlWTXFkSUs1T2VjTmFGN2lmZXlqdDFlTXhZaXRjT3ZpcmZpTy9IeUZ6UlFU?=
 =?utf-8?B?cStzTWRLSHBlS2tibnpnUnRicGxVdjVZZWFidVcrN2lKaW5SbktlYU41andP?=
 =?utf-8?Q?LRF8V8muTu0ZhphHn7SIc2Pvn3iqLTt+WLqL81kHuCryI?=
X-MS-Exchange-AntiSpam-MessageData-1: ygX7ORU9l32+8Q==
X-Exchange-RoutingPolicyChecked:
	4cAZjkSs7LOiz12m99unR2TD8LOT8zGFRzQsEXpiMZ7FlyEzeNqIO5KjYEAzcwuWr3LwICG+2RVz68+Rc9hXda3xn0/pipPHoxvmIzB17sOZIfcj/150Gaeqn0guV33bRnwo8aVzOezdJ1SpPAVp20g/sVqL0WZutDEgvO6RYcTEVqioX7S9ftgLcOojdDwuGgZhO5IloUBcpCgh42qxzpuBO05bfkJIEhoeC/o0JN8sSkZ2p8hCwFbcOQMBA1gmG10VJBl61oO0ZejMmFsrwM34EvG3RTrWoe6WoofwddTVUzqCDRehYzkc2qfcfl5y1x0RSFHrEJKpG5f7e6NV2g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23912ec-4c76-464e-5605-08df077eb1d9
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 16:41:24.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVsruN0myNR/yU5zJ+O/UzoP0rpmCb3xlkqdzeDCxnCzbCxzMkp3SkDvZEOG/A9DPwiC8+u2Y3cafl1lBpPdfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6492
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDE0MyBTYWx0ZWRfX9PSm8eFuqxmI
 qqZjzu/RekpSOA70dzaYAkr7ZFA/yB+HPm5rSiyEcw8SkGEKH2uctIxkJKxj/FpMn9O2G2W/suq
 EmCeAY0DTwh7Uttg3gzUejvzt9IYgfZJxRoMS6Fdv19evRb9Nidbxw9yo2h4EmQ2W9Kf09JRFhh
 mZFDwtPZzp1dGwu/LW2szNDHw5bUSIEW9rBbxC4CGSX+MeIyigZStel8I7ktRHJ6JFLAN4G5ORX
 KB+16AOGXjdWE1onZ9b2iKnbntdQ/ZvnQzxW3DFg+H1DOgDyuWUUH7pGJhFkqJ4uPkKyJ/D9Wlx
 ufuxhLGza6kmYN1KITGlBEfCTCJdVSIF598hpQmPBcD5+VmrNPy4+xzimv1z6D9hCNPRtDfbk8a
 58tg+b/fZej+mP6MEWRs6IkesVFPbwoArJz1K4tufiCIocPhxrPy9RuIce+lA8bmthSAoubQE/Y
 LG7QXcDiU8hrJIcoaPw==
X-Proofpoint-GUID: mNAaVuMsisYXmOYiQD8CLClEETQoa-Ag
X-Proofpoint-ORIG-GUID: mNAaVuMsisYXmOYiQD8CLClEETQoa-Ag
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDE0MyBTYWx0ZWRfX37Gu+ryVp4c/
 3yn2Khup6WRqqdkQ3I9/hcTkPPaso3q6sgQB3tOycFed2VSm4JqIvfW+ifqwLoqw3H5CPCv90LG
 MwyAAdsJh5b7VyNSlI8qCpeigEaNkv0=
X-Authority-Analysis: v=2.4 cv=fMwJG5ae c=1 sm=1 tr=0 ts=6a95aeb6 cx=c_pps
 a=poLntA6gJg8PyknBlaXY5w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=2AEO0YjSAAAA:8 a=3cI6r80fLADfETk40vkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_05,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310143

VGhlIFdGeHh4IGRldmljZSBwcm92aWRlcyBhbiBTRElPIGludGVyZmFjZS4gSW4gYWRkaXRpb24g
dG8gdGhlIHVzdWFsCmluLWJhbmQgU0RJTyBJUlEsIHRoZSBkZXZpY2UgYWxzbyBzdXBwb3J0cyBh
biBvdXQtb2YtYmFuZCBJUlEgbGluZS4KCkhvd2V2ZXIsIHVzaW5nIHRoZSBPT0IgSVJRIHdpdGgg
U0RJTyByZXF1aXJlcyB0byBwb2xsIHRoZSBjb250cm9sCnJlZ2lzdGVyIGR1cmluZyB0aGUgZGV2
aWNlIGluaXRpYWxpemF0aW9uLiBUaGlzIHBvbGxpbmcgaXMgdW5yZWxpYWJsZToKaWYgYW4gSVJR
IGlzIHJhaXNlZCB3aGlsZSB0aGUgaG9zdCByZWFkcyB0aGUgY29udHJvbCByZWdpc3RlciwgdGhl
CmRldmljZSBpcyBsb3N0IGFuZCBvbmx5IGEgcmVzZXQgYWxsb3dzIHRvIHJlY292ZXIgaXQuCgpU
aGVyZSBpcyBubyB3YXkgdG8gZml4IHRoaXMgaW4gc29mdHdhcmUuIFNvLCB3YXJuIHRoZSB1c2Vy
IHRoYXQgdGhpcwpzZXR1cCBzaG91bGQgYmUgcmVzZXJ2ZWQgdG8gZGVidWcuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4
LnlhbWwgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJz
LHdmeC55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKaW5kZXggNmMwODg4YWU0YzRlMS4uNjBkZmUyNTdlYWRjMiAxMDA2
NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9z
aWxhYnMsd2Z4LnlhbWwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTUwLDYgKzUwLDkgQEAgcHJvcGVydGllczoK
ICAgICAgIHVzZWQsIHRoaXMgcHJvcGVydHkgaXMgcmVxdWlyZWQuIFdoZW4gU0RJTyBpcyB1c2Vk
LCB0aGUgImluLWJhbmQiCiAgICAgICBpbnRlcnJ1cHQgcHJvdmlkZWQgYnkgdGhlIFNESU8gYnVz
IGlzIHVzZWQgdW5sZXNzIGFuIGludGVycnVwdCBpcyBkZWZpbmVkCiAgICAgICBpbiB0aGUgRGV2
aWNlIFRyZWUuCisKKyAgICAgIFRoZSBoYXJkd2FyZSBzdWZmZXJzIGZyb20gYSBsaW1pdGF0aW9u
IHdoZW4gdGhpcyBwcm9wZXJ0eSBpcyB1c2VkIHdpdGgKKyAgICAgIFNESU8uIE9PQiBJUlEgd2l0
aCBTRElPIHNob3VsZCBvbmx5IGJlIHVzZWQgZm9yIGRlYnVnLgogICAgIG1heEl0ZW1zOiAxCiAK
ICAgcmVzZXQtZ3Bpb3M6Ci0tIAoyLjQ3LjMKCg==
