Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5706C53D0A9
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.31.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788952687; cv=fail; b=RRE9YkuZmgodzcYbnq/dT94VzFiSFRPLoZS2sHGWSgcGu5+bFRrWNfYsVT24+N1BRaQXrRD83L6Ig/gZotop8sNMgk3dyOlSxuMLROx/oO3jnK2/yNJoLAnAYnqcujIvW4hGMCzGhZSbUfhT4g1n4ClFY3WXxoUcAQXXqwV3bDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788952687; c=relaxed/simple;
	bh=cnlbewS5/PU6Lcq4YplSi3amSsjhzScVvopIl8yR+1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AG9l0NgeNOWEJDb3p9CZ+yFbDH/JhTHDOu+vLMjlKLsjf02roh7V1khygnOebTu018eBQWoF6PwpQP+juBGwFEv0aHdGmhaiA3HH5uLgpmGlCi0L8GYylQ39cmCe56zmw+o6u8xk/MXc+dCfPvp/n/snsTB8UCDKidR+DV1gezw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=l5u/2+U3; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=DZAvHCnw; arc=fail smtp.client-ip=185.183.31.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="l5u/2+U3";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="DZAvHCnw"
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689ApYtF1752426;
	Wed, 9 Sep 2026 13:17:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=270620241; bh=H4UKswhLtDLXH0fJ6VuHzgTG
	DT67Z0rVIPS5FjIxjTg=; b=l5u/2+U3HIpzO2T6vAci/aywosMMpxaNp1I5vku9
	RYeOPMtzA/Ep+uwJhxT807AnO5aGrmV6PXZZGAwg8DKFT+TgstAidW777AxChZlY
	dH6i6jHJ5ZM5QW2SBrWObMkhjy1X3ggadVxZUhsOmOmGQXFZ0T21T2PQKEZXsach
	3Vvg2WrK1wxzt5Tq1gX4uH2mINyfyR3c/Q8dLMKjFCdn+M3d8wAQGTzDVH3OkzBu
	DSGTpVrSbyI2KHrIxsUJhAscfImdbBz5xElknBd3QCRknFf2RwTUu1/7WhZMFofY
	ya2ooTi7hmzEYEJEM4jpaN/UgJBpOV2oNHuC9o3aWXj/Gg==
Received: from du2pr03cu002.outbound.protection.outlook.com (mail-northeuropeazon11021123.outbound.protection.outlook.com [52.101.65.123])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gjq600t77-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 13:17:34 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fSdsx8SqzxhuSyxnDtpPYrJf05RSFKzi4iYRRU+BWl2e/zMMTfRyFLgJJdJg/ph2yKnH9gAe/J29u0AbXZ3cBJeIbr1VyaLoI9Iw6Nmf4ARU5XEw6DqBdiQdnucn1SU3PD7kldeOUFhXz2syA4r7N8pzlhgWMNFK8o9/lk3S5newRKOoSLJ/q1HE39A2EO+eolHrM96izw9HQ+jr89m6YTMfPDhjq4cu59pOz0koalf00Ucaa/79S5ejHoCWndsOXQtvAyo7rofVIzjDtHm0Ni6QZyXoFX2As/4FC4xj3y3OJCCnr/no3j9MUCntGEZn1lIR2KN+FWHLl0NHyjrlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4UKswhLtDLXH0fJ6VuHzgTGDT67Z0rVIPS5FjIxjTg=;
 b=a3t7gokhENoPpbWnt7n2wjuXPOCWHpng02hsxVBRfmOWU2Afi+moHmJJqlXr+yJChwBA+bMp1DowB9KRNVn0NckGPGVXyAxGKWQ+uaU5mSQI2Hmxhv9ZQEJMpzmPMHOtavUl7AEFGUMt83je/T43J3u17YESZ7I301++nuee6iISYb1oVTeMYYc7OnjsmADXJPyV8vvUhok7B2BWRMkgmbJ/GhCQmhmFWzPexUqPwExe4/wBA0w/Cyt0a+vpW5URHbp8yZk/dZjxOOVNtvg1aHfDPAVj3PkXfOaPdWnAE7CTOUbDnmnyno+7RksnQE73nCFqnHs3fjsyTbkVrgUTpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4UKswhLtDLXH0fJ6VuHzgTGDT67Z0rVIPS5FjIxjTg=;
 b=DZAvHCnwhiW6Kl5OzXypqVWJxvjO/8/5BtzOgy/PmW17PfXsQ42FUwgE6GpDVOzGySHUk2/k9yEIm+Y8Df5Yhk2v/QOr4fWUmW6h/Jn/e6fEJgZPvCVBhJfj2Ly08zL01iZ7z8kaL2RWC/YNMYzXRQr0e8TZV1PGtkbzmgtfa6g=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by AS8P192MB1970.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:536::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 11:17:33 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 11:17:33 +0000
Date: Wed, 9 Sep 2026 13:17:24 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: ath12k: QCN9274 WLAN.WBE.1.6 firmware drops pre-auth EAPOL in TX
 encap-offload mode (WPA 4-way handshake fails in AP mode)
Message-ID: <aqFARFlTS7757Zks@mpf-ESPRIMO-P9012>
References: <app7ADVti1eiVQr5@mpf-ESPRIMO-P9012>
 <cbbb5555-60f0-4a4b-881d-403decc53ca7@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbbb5555-60f0-4a4b-881d-403decc53ca7@oss.qualcomm.com>
X-ClientProxiedBy: MM0P280CA0079.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::12) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|AS8P192MB1970:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e739015-019a-4bf6-442c-08df0e63f1f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|4143699003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	to9B8qPvwi+sK+ifspnOI8dJ+iyQ4t/VUVKZVHUJTKRHRFZD7DME8If8m0uoZ84zTGYPZheRXqCW0KmcN2NZ74vgGBLZnRid1JF3ywfvdcRxITB1PRXTt4tsspDb3g3Pv5d7LqFTolnDqSoCqls6/kz39bQzKi2op6ND8R6mveQpgTmeekhs9iveUomYYxrC1SyNGfcbUiwtM6amC2BWpmbF2xABQGFOcgikW99MAXaD8lnBMRXt2g5+l+4gsqGydO0+h0iFRbOjFz+qpqf9sG//0Cz9rprJH8C3zgnDNY4FPClJL10US1aHEH+zDV6uFHjYF90yLaUOX6CTbAsOeDrDtB/4hyH7+DAIHoowi9oslilamYv9LZINM8C3FpspgRzrhcLMAMM5K6PBNqqMes6KcmjxuMGvLdb8GYFT4ywpOKJux3F065MwoV2OJx9+237iT6Cqx+c42eU0J7NDxE33JGmbJWgI71QIjFRi4DA2TQ3/uG9nEfenuGX9SQykFvhHRZfssgtXRpsK/At2U8oyNKICGwhCVR0eAGARIFnBCAfLRZt1O3NkCdr/2p4FHFa42uI7ZjokIqPF3ufFBHZXS7C+XRoK2AJHT2ln1wvnwrs5KpkS5jmSAsroS7Nbjj4CCqtXiuiPH+uvVLMuZRadY9wFxr/3s8gI3R4sz9A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(4143699003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wf9rpDjyUe1V8ilMRMaNImGQAAZZC0zjJyxcjvEdR5FR6vkSdl7Cj2KzExMS?=
 =?us-ascii?Q?BpWkAAWRmFmXN96HVyhVsVdg6wdMAchH7E1hWnr8IlIjMuK9MQbVGsURhZwz?=
 =?us-ascii?Q?hgz+UxryzansK33PIlqTHfPR5oepS6KvWwLCzBMuS7gxhR0F+nCDr/sr9zks?=
 =?us-ascii?Q?JbqjwtYXo8UCQoaBYZtG4m015uLr/Dgor13weh5r/JDnRdio+j4F8qbJnFsg?=
 =?us-ascii?Q?BNiapvq/J4rL5YSKqoM9vakkG5lcsVAzy3iBJf9KwIuor6KDRHWouh2tYsRk?=
 =?us-ascii?Q?9G/w633ubQ5rbAYCUZmB1my/1nrVp83BFRuPqLazLfrBf6TZ42Jfq5FTFuk+?=
 =?us-ascii?Q?nUjoT1NPsRVeSNk2BgC9AphtR5oR57CBc/Wd34piWavGtVHZqFdcpzFqAB2y?=
 =?us-ascii?Q?E1/rK/jYicdd6BIsHY4SarlhuD2VwsXscyKjIHWOQHxeT2We6s1v8kmsRHgb?=
 =?us-ascii?Q?t+DaU6HsBKphXYeMNILYNQ/gBTNecnK+exI6UzwtxodMSE1ZICb3n7SbpVWI?=
 =?us-ascii?Q?DGn3UqkVeCgXX22eAThjmcnJTUFyl7xSV47KXMqfd7GgY4FwbrfYBQtezsJp?=
 =?us-ascii?Q?vzlLmZyLn/01oXvJnpedj/9asgM+kDBM3c3bZgQOJNzb32MNmbjVo9xEB1y5?=
 =?us-ascii?Q?aloiAOVAL9AxTuVlAwnw/YN0qp+bpqByYUuTDj14n1XiTJaQ8OiAIAxoG3E4?=
 =?us-ascii?Q?TCxAF+779laiA0Tku1Z4mt506Z6cQwhdesmQA7gVdymr5mS7wajCXaWomnT6?=
 =?us-ascii?Q?RScWbmP0QKFIQ/EikUkMKQ9yxtRGzgeomgWBY4s9sTejIVE+XMphvbHM6WYJ?=
 =?us-ascii?Q?jAHhV9GnbzZhG7iDzhB9bBI93mQy0BYTSelGF5e1i1yhbR5wDb6xcV88Yp+d?=
 =?us-ascii?Q?/f7CaJIX1tTp3OX29jqFEup5ihA8hWGwlnN0HBJ4ZaHsxpzQh0uRlHvoUbFn?=
 =?us-ascii?Q?TyuZsHGWz8TC07R2J171FndUA7h2gOTxQONBSqyw/2w3sGGWnMfe//aFYmT7?=
 =?us-ascii?Q?UxjEngUv/8Flrz3V7jVIbTVKw9mK7ofIar1NZkwZWIgZC2ViP0HdwX2Zl1sO?=
 =?us-ascii?Q?9jPM7Dov7K1en+ochtLvDNj2DsIvR74WgFJficuGqNZ6uq3M7UMWbbkdALo5?=
 =?us-ascii?Q?mkvamh+GtbLAJlvZM1eyWKJH/g7PLU7u0+M9CAuzHfmOGb5P5zkNZXzoCn6R?=
 =?us-ascii?Q?a8sz8pgtq8z46gJ1ri9zNn06nGESns0YeHYgbzT5QR2Exi4dXNl9UiH4Z2wk?=
 =?us-ascii?Q?839SdejxJCBSSAAJx0ohQzscifcmKojxEY/+RElvYyGyqEPZRu4P3XOycnML?=
 =?us-ascii?Q?nP9FiFumQ8cAjJqAt7zvCSpuVNPPjHAT0iIu+T87OtOSG53LEPet48lJT9Za?=
 =?us-ascii?Q?epXgOG6ePfT3+AHnWydhJkD/uBXdOUG7akReHkQqu0w3YA4ize/4Hnzs5cns?=
 =?us-ascii?Q?biGiZA4sJnAKAeE16xzpmm1DrImLO/wFbl0Pi3IddEgHZAAg29ytLycS4nDz?=
 =?us-ascii?Q?U0dU0u1yrLvYVyhIEQ5Ka7MM5aZhflFBb/QmYkwV0JUMD2JUp7QHSDR3z0h3?=
 =?us-ascii?Q?fpUvmn+DzMR82BnRT6EpF+DM9VTlSpd0G//u+fPlDO2BbhCueb8lrMFxIhWy?=
 =?us-ascii?Q?fx3I7i9KQNK9Pnf1NCOBBvh1Oo8pVwj+VSdQdBLG521m76tDLYPpqG3Sc1dK?=
 =?us-ascii?Q?QEeJX2YGlXH8/veKjzFGEL6vu6jGekKDll+vqoMyFJ8MB63kCfITuoOdKkvh?=
 =?us-ascii?Q?dEbFr8PBPQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	aDsEfY0HJkuLQNRkVQFKDO06CXEaDoPcYZrAF2aZ4q7MoA7ogOBw5If7FuygBvYqfz1v8wW6HJ/8gDOmfRKRCle+Q2m0I1Aoz0KRKY/XWTRhxFrNMOkDYJ2Biz+HAFU0kZ8byUEG+R2dKyuZeQAVixNx9kxhgqEH5AgaKwHGCopkiqQ4BmK7aV1G98W7grIP3wPqlz9mSpbycOlYNDafcbQsDlZcetYnSA/H/1wTci7qxsxC4oNzxgc2djH8o8yHiTsTN8O/jvNTNOIttLLMrT4DkP5zpWa2KJhAai2TLWIZTIXOI/ay9jV44p0MUKL2a3NekD4x1NgpDIjTA92T0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RgznfBpUMvBYZUNborXU0K9mCqjrWSAMTwVuaTfaLOptZfjQK3RA3v4rw+SozlnD7dmay8G2oSRUxMRgUJts0/TsFPEmgpLrxinMDs4r3y7NvMYukJyoCYqoIMAhmtS0qlWjjsDkjRv3nfD56LPfDnKOp+4Iu5TmEFTPMDay1vpfCeCfowVnLyVt8lrNBnnso87+5UGyxsb1zH3SksiF37Aa8/oBOaWPV7d4mHlwJxHwdReM1OTRA+22Xb893ZVcmLY09wsbzwIC2xTaeAEBvof+YPzmCXOdq4DxQfiCjpvuXCZr54FdXS8cFb5y44vtKj/Mq4lYQZeiLTxn3ca+TQxlu0/6jwSWSa2D7c/wyFQ23ti9dnDz+3KluLtdzNyAJBCxGL918I/wfM1RB0OcBbUuMHAFpGgCZscpQYsXmC+3CgFW+95qYqoVFHdGU3EPkSG8YpyWkWxX3lQJ3WVLadImUnZ2qoNPE7ZGbzMLHdeI0dBTh4IZL+NHg5VHTEydYBF1E047CBL7gUsvt2yYuiz2iSEVqwEmtZ2HVPsasnO8AvR6EQNP1Vfgb0XL+TESAiGtExGJPIqAVcDNLm16kkfDVRy0YWcj8ZEn/D/y3m5Psbvd4Gl3xmh3P5EVAkc/
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e739015-019a-4bf6-442c-08df0e63f1f2
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 11:17:33.5310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euBRJ1WoVV8MZjZG+pRNfT/cptnmcfEFcQQBVyJpevIQPEEWIxzNX6GNUp2UP62E3SSLgmsnron64PdPToXaUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P192MB1970
X-MS-Exchange-CrossPremises-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 104.151.95.196
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext:
	DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: AS8P192MB1970.EURP192.PROD.OUTLOOK.COM
X-Authority-Analysis: v=2.4 cv=ONKyTiaB c=1 sm=1 tr=0 ts=6aa1404f cx=c_pps
 a=zNMqk6dBDzYzXfNKB6ufmg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=WQ4YJ39tjzx_Hbm9pN5v:22
 a=VwQbUJbxAAAA:8 a=U02WUVaKTlNM7OgEJ00A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: GkfBih_R-sMnYqVm87sAFkxSEGA-aw42
X-Proofpoint-GUID: GkfBih_R-sMnYqVm87sAFkxSEGA-aw42
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDEyNSBTYWx0ZWRfX3IejD9o3ySwk
 jlDNRwHKOetfYqZOfXdRShjBYgbcyBDDOa/QrAkhUSMz2ABHvGEu6zxALd9MRtfefGNXENkm3xY
 12L6khoGYq9EzYg3nRoa6+qOTzulZYI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDEyNSBTYWx0ZWRfXxfrkI6fnu6ZI
 AjB1WFHW4G+SwDpMtYHJ4klHcC6eI/m62btryN+m6RpF2dK609ckZtiX2aUAkG94aNrBwdOmV+Y
 reLYGw4OYg1C9RykZIOV/mHDU/W1nCQg23lPVJM0W0JyQ5bKtHaiIl37wF1KCYifCawIWyl0cm4
 HHz0aEHcJM0d7HMZrQkVQnzGSJYi13amHmfzkLDvn6l/mTwb3Qak+p8LVDIRkQl0cJG4CvwOHdM
 x3nOgH0JRuyw/HSYRAopjHJvrmCbB0/s3I2dRH5WZOthPyRQ/pfqBEXjdjH8iMN3+GOZsTEeJF/
 42RCaMCQ5VVXUelIrwAdyuCiiuCK6K62N3vwm1XQwu5Xw8eLgsGb18J/vdHPY3vttcxk2ZQGU1q
 bcnpGorL7RDWWARq++ZOhgYOyna88vcUAlCzGxzLayPSXFcmSt95L0+AqL7VThQrSCoKDiRIegz
 bZcFfQe+gw7zf4E35CA==

On 9/8/2026 9:59 PM, Vasanthakumar Thiagarajan wrote:
> Worth trying with commit
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1e33f8acd837420160ea088160d8648a3db54c3b,
> if it is not part of your image already.

Thanks for the pointer. I backported 1e33f8acd837 ("wifi: ath12k: fix
encrypted EAPOL TX in encap offload mode") onto my tree (backports-based,
single-file dp_tx.c); it builds and loads cleanly. Unfortunately it does
not fix the symptom I reported - the 4-way handshake still times out with
reason 15 and hostapd still logs "did not Ack EAPOL-Key frame".

Looking at the commit, I think it addresses a different EAPOL case than
the one that fails here:

  - 1e33f8ac only re-routes EAPOL frames that carry ATH12K_SKB_CIPHER_SET,
    i.e. *encrypted* EAPOL. On an established link that is the GTK rekey
    (group-key handshake), which happens after the pairwise keys are
    already installed.

  - The frame that fails in my case is EAPOL msg 1/4 of the *initial*
    4-way handshake. It is sent to a not-yet-authorized station before any
    key exists, so it is *unencrypted* and has no cipher set. It therefore
    still takes the unchanged is_diff_encap / TO_FW RAW exception path in
    ath12k_dp_tx() - exactly the path the 1.6 firmware appears to drop - so
    1e33f8ac leaves it untouched.

So the commit fixes the rekey EAPOL, but the initial handshake never gets
that far. Test details unchanged from my original report: QCN9274 hw2.0,
firmware WLAN.WBE.1.6-01243 (the latest published in linux-firmware
ath12k/QCN9274/hw2.0), AP mode WPA2-PSK/WPA3-SAE.

One thing I noticed: the commit's Tested-on tag is WLAN.WBE.1.6-01270,
which is newer than anything currently in linux-firmware (01243 is the
tip). Two questions:

  1. Does 01270 also change the firmware handling of the unencrypted
     pre-authorization EAPOL on the encap-exception path (i.e. would it fix
     the initial 4-way handshake, not just rekey)? And is 01270 planned to
     be published to linux-firmware? I can't reproduce your test setup
     without it.

  2. If the initial-handshake fix is expected to be driver-side, should
     ath12k also force the pre-authorization (unencrypted) EAPOL onto the
     native-WiFi path when ETH TX-encap offload is active - i.e. extend the
     handling to the is_diff_encap case, not only the cipher-set case?

Happy to provide full hostapd -dd logs and tx-path traces, or to test a
firmware/driver fix.

Thanks,
Michael Pfeifroth
