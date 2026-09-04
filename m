Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7852A3CF02E
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.31.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788508962; cv=fail; b=itdGx+4HZ1b40ajGItxfqrw9KHCl2RRGZ9b8Fk6qhNTqFqTw26oQKxLOvobqhXD8hm8hw6+4bNbFZ7qJzhTI+KgcqI7epM7TblFzCMxlxN0qvXdsi1G4BTntBrpqBQSoFvwR6440ufN31U7tAk7Mvu9Ov/DJe7hvefcyiwlY3Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788508962; c=relaxed/simple;
	bh=a+JT+ZIMQQNdaMpTiVzvYx/t5Vj8XOOkS5oQTTbc7A0=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=l979zR33KTViGlJ12Pc8JqgzQZQBDfN2JVUdHQPjJ9/9XooUCRLt9mAX+VMbysdj38Gzf4isroJP13U+wrDj6EkzxITxP0nCZkbER68fiEDjgOMHiTZxseounYOPWJiY2XYkDDMdl518zIZHzdQ8qIiPeUv3vrMUbIH/5AT+574=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=l8Pe84Xs; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=q2WuvxVl; arc=fail smtp.client-ip=185.183.31.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="l8Pe84Xs";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="q2WuvxVl"
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68462RI01927697;
	Fri, 4 Sep 2026 10:02:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	270620241; bh=qoMpwDqid8VYPawNlflGmfFjV2DtTbDB9Gmcx7DqrjI=; b=l8
	Pe84XseJibxVVlkx/ODgtApM18LMMtqhUUeHYpMB3W7a3uTjc6Gli1mmMn4rHnzp
	0aWSY3A+jy289AUYFcbwY/IkKNbEbAZphCTQP6i3SvudEK9CzKxSbncLzq45aEry
	7Y33pg2Fy5qjVLc4f/Kl6R+T3brcW2lW6C/3A0P7ACUFGxnb92T6H5Xe/lSX149z
	7LaQuuMgxstEhV3EYJm5ycP5iGG/QfK+E98ZBTi6WBvwvFZWCC/qyns6WVHNYSsm
	8GGmrm07SDSa/apGOsoMBV526Chtdu98/tB9uwbimOuOZYiS9u+gBTpODMYx3bg7
	wtcOIHe8KlsnQPwioCEw==
Received: from osppr02cu001.outbound.protection.outlook.com (mail-norwayeastazon11023102.outbound.protection.outlook.com [40.107.159.102])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gdvvqus5g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 04 Sep 2026 10:02:20 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxjW4gUUjIbhRhuVU2utIhqd0N8uIjQhI2Ttasy6DzAHJinjVkIR06cSOGgHwDkRqVLY9Z2fTUQzNbzIus/3BMkn/SLHM7nRszTWtwtuzEokTCOJt7Jd0tiLq4kLm5uDUuwjI/2pBDF8KwJVOqvTBPCxR+P8NIydCqqT02KUd0M2R12fl1BykeT/Fkoe0zZ8ffe8lhYBi3YPVk4xpp/UFUMxOSf3UqswqMwNhEaL52cZQLARmHQUUcshB2q39wI6BqSGLm8T8JcbXR5Q26LihnwXdGAs4N0X8U3S28uch6zdn2ALFgQE3KBIsbVdG05ej5YFmxTN30GGRVy9ankdRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qoMpwDqid8VYPawNlflGmfFjV2DtTbDB9Gmcx7DqrjI=;
 b=Hrd2GxMpM3ry0QrE7tGsRwMpM1HtBl26sra+JQzsAxTVM0U20IAPyxykaZr9wmUQkJkVC7XCfNMDOUzyh/QpmiDvyV/1s960N/T5Db07Nck7Mk8/MAbNRSxDQYv8VAsKwaRVdhCxswadgl9GVzY0Ci+jRu68l8ObbIIG2DZJzUl46XvEbx+Oo9PjV0/0pgvfxC7dGZbqoH7oxVkXTumJe4nXIHYBYfHj9KUgjkY/G3CTVtsonI8g+Rd2nZXTRRsCvWWDSkKYFTwhxIfNhTdfS1pQp1p5hqs/LKnUIhtoPXRjqbQQAugR/r3g9RCepvoZD86Kf0IXIEe0WX2S9Mow4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoMpwDqid8VYPawNlflGmfFjV2DtTbDB9Gmcx7DqrjI=;
 b=q2WuvxVlallminItb21vUs0zkO2TEewvgvpFphmr/9GiB4bWg3cxmxAT4YJDUt7Cn2krleI/5jPD3AV4oUDlamIxkGHjMcSFcGn+PPd9HFNFLMuXk6M99SimOghP/smcw6kXtUarp6wUTG6NjdOKoHio7eUB/Gk482pNh4b1NiM=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by PA3P192MB2839.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:02:17 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 08:02:17 +0000
Date: Fri, 4 Sep 2026 10:02:08 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: ath12k@lists.infradead.org
Cc: Kalle Valo <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        linux-wireless@vger.kernel.org
Subject: ath12k: QCN9274 WLAN.WBE.1.6 firmware drops pre-auth EAPOL in TX
 encap-offload mode (WPA 4-way handshake fails in AP mode)
Message-ID: <app7ADVti1eiVQr5@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: GVYP280CA0038.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::15) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|PA3P192MB2839:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3e5331-8852-4b26-f518-08df0a5ad691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|11063799006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CJQhAGC5MgWvaoiyc54WpY/4ItdP2JHzZwQGENrGyFrGLQDeEPShrVBgiX1b3OndLbd8vHGfcyrtOfjrjRHyFDcFWhqlFVawZCP7zDqtHM0ptYURDUWtQK5D1sSgwhXE9UpA+OUWb4AsZG9cXsENpdU12jzQCHnecnlAyyJshaaOLTe9mPlrLLfbCyQ4jzz8VVjzjEYv9znMy7T2YWOXGRdLTOoznm9ynsZw83xL6hqbb4Pj3Ik2j2HH4fsnLTnHNV3y2PCnY3WJ6Cz7aLbZZgPvFc1xdX4bSYSNbkxD1FeCDWkWMhvvLtXmaiN4a34qaqeYoce+3xn2OzZe7W9AjmL7bgDSwNz9hp6zYmtthrdE1bJpUO+A/XUmi/C6aGmn1oR8LDiu0jkgAR51zFWdpx79P5mnylieuDhrHho+Ajmth39kwc863qeT7ZVYyFfhThR8vtX4rnpXL4gx8tnO+HdGwCg3Rg8pweNAoXG6IAWgRzzMH8IQX6kCLeiTp5QPMGIxFkj+JD+OYxUJLQrtibdXmZA3VkpyjnHLdIHZ4vsrt4mV7fS9ydqXT0LQqyWwVuj1/mBKh3ubO6oJkMkg/LCcQYSELoWPbvFcg5s9nIzoX//KWD+iZEElVN0zEcP0r6T+vTTXJ/2VO9ekzohR2YOTCIhU3hGr8EB81xpLAqo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jD1KAuIwYjdKoVEeOLjCGXJhajua/qoNFnUcC7Wwtso0Hi4C5tGONdSl5Dol?=
 =?us-ascii?Q?PEjk+HLKqhcfqWgw+8I7wbKcGrYYpGw07blJ5ml6Wz7Ej1q3Hmc3LItCcpy5?=
 =?us-ascii?Q?5x8+izz8veKU8CNwCfjnuqZdawcSMvsWnOm/6HsjHiipfaGldFqxLizO5mhz?=
 =?us-ascii?Q?jGgi8P1YJ9vceaLDOsdKtZsA1gZPsP1Q4wUA0Stj+VQ1g72RXwX7AkKWi4zq?=
 =?us-ascii?Q?04h7tXri58BVkUu+WErOMOH+9+9QDRDYFkfHNdVo+gCk9nA3Ev0FIh8B7z9m?=
 =?us-ascii?Q?Y00y9BPBB4rxjCo9If20JDBALLXHRwAHAAP9kUNNkwXHwAp857b8fgMMzzth?=
 =?us-ascii?Q?/U2Wk82IJ9sava7w0lLWhuYsgOrSvYMuHP3Q4TRPbSznMIybMKjkFsve11q9?=
 =?us-ascii?Q?I6UAOOu05VlnUuRWh67A/paExhTp1vlf2+p2GF/CAF11bnh526G0Z8HFhhm9?=
 =?us-ascii?Q?rRj/FHu0AAAaVlaIe1w7REV20knUTX64SVq2objP3E+mYG9fDH7wcGhgmZ/8?=
 =?us-ascii?Q?PkeKngvl8Om3Yswc0LkQ78X3yMlWSHZulFGKUbZNl/bkjpA3A93cP3LxnB1Q?=
 =?us-ascii?Q?tJUNxdpmCG1NsaiPjDTTsewdY6OSmNwW9IP0rVFCYCchnuUk2lnTPybbdHvm?=
 =?us-ascii?Q?+aNsxHcCcffG1z4gt9ziRN6122uLPTtEtFlvbcXDLWRlbU9SltPclESENrG7?=
 =?us-ascii?Q?vj9gNBGStMiCG9daXUiaIP2/l1KyiYtz+coiiTPjMYMz3P5a4JCwHkA8l+Ag?=
 =?us-ascii?Q?aTPJOfGA3msVKfKX5zYRkxk5gmWdPuX6N4us6tHgt9cn5iwRjbzwBOfI1R1s?=
 =?us-ascii?Q?8kA012QQUOt4fjJbth0GSUf6QESAiFMOIyqDt2x2NEMotSLunX4pgpQbS+Em?=
 =?us-ascii?Q?OJ/GnP61E/BooTynyAt0g++XslNjwHFGlL/F67sOtBrcWnvgc3rJJuXk+uSb?=
 =?us-ascii?Q?6C5n/Pds+Ftxhv19igIfrLKU08tP/E6Pcx+rEZdHoEoBMaqb4L18Bqrn82FT?=
 =?us-ascii?Q?eDhv97jK9+MJyFc+78D7u4+aaXAXR0OxBd4eWBPpk1/QC8pDCL3gdICxKhco?=
 =?us-ascii?Q?C6nf5/tbTFByeZBAGwfC5PJwO431k/WJRr+j4CWTA1Lnn6WXC8CPxbXjO+ZI?=
 =?us-ascii?Q?Jq7pKh+/5kSdvpr7b/Fq3Ho/ZvoWuTGzVQL2OwSmhB9Kh47L6JXpGwCsylA9?=
 =?us-ascii?Q?a8JB2munAHGEAui11aiGkt9ggr3VRKh/ywyfMpc5Uta/p7DLoZPgzSJwKEvP?=
 =?us-ascii?Q?yPPExI49un6646GxSxis5VdAI0z4a0zGb7pbARItTX1FPwn89AKEw6OIfEA3?=
 =?us-ascii?Q?3OiDpezlcFvX36imqBo7Hd6BXlT4a1ecA7l1d97FHI8sGfNiEU/bbm/Nzv/r?=
 =?us-ascii?Q?SThBUruDvzae8/nrBJ2b11WD+5scq4T7QkYXDN9xupStdWbAY9e9zJtzQW9p?=
 =?us-ascii?Q?0aCZb6GQ6DFv0UEojm5I6Q4GWmYTugVnnigIfGNfA9ARhGjTXREYkbBNRdEj?=
 =?us-ascii?Q?cnvh23zgD6ApItuNJFVR60I36VCvH4v6i/KRKtWG3AenKIYEn+GNhemytqBc?=
 =?us-ascii?Q?45DfJPLwyJi+nSf+Uk8fGBEpk2NPkYG3oFvr0rIic2Gd1s9HaDtzd4/+7kOU?=
 =?us-ascii?Q?7wWiMkSMiV1CfpIhx5XOczJg23aRm6OFEgSSj8zTJrud3+ALxSjg4Q8yllWl?=
 =?us-ascii?Q?UjW41ruYfGWsCw9n0xYOs65GR5uHgjcHVoOVbYIVtR9Zs63K6dHGQVsl2oxR?=
 =?us-ascii?Q?WZnR2gLxVg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	HHO5oQFEGr72/b0ijWg5NVK5+ZOklWFMu2oXO9H+bH8LL6cQ/7CeuLrUCJPp7igni31jzqWC6+v+IWjRxFaC5CCpDRq0oyurPeJsgzzWuKaNmdGxQ75gkIDNOe7YcASWiigNem0i3uZIeIK801qxEahgJ43STz9G5kxK8onETTyUPnmd56Wm/8LaYgkleOPLUWJCTsEKtlY+qOnzI8vaZgpG05hXw18sLEnxDm1VB4Z0gCChZAVRjqMqGQqlHtuflLfZvufqMVGoYGvPJ0jAAlSF1ufzt01GEOGJqimix18v3Dtb9t0QY1+fnp6VpMQaymP+W9ydPS10FAWQc1i85w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hB5RJYiR3ON0Q8wcqqCLfqNjvYuWh9gUV6vmjVEa62tTf1Pdk/1hFZUk3zEjjvrMQjCKsReRW6IsU8ZGN3Dy6rrC4ECLxUXWIfitG5cX616PnjWR2YCNKPDv+gAgSLZEfMVCz2BUW7VpegFqBGicgdixah07KXjxHKFpVwIbwu8sJ9fEauNHifsBsVavm+ko+bnZla8zfRo8BV7KydS29H8ZaDpqJ98QjW0nQzM4DcSbKEO762yGUB+ykU+Sk2qAa90Q8Fxj6qC4vfXXmOJjXsbY1wKh97ZFSjaqHZP7zEnCEaXwePJV1gH9MU9UarYFEsvPNzei6cfwUZ8e/ovvukswh9VSsrtcq7NouNwcIwo1BoyXXfzhyVJtQQwoYyGiFrfKU3vOHCNpQFruO81KL0zj/opYQPbuMi1oZw2o9TqhmnML8pVrKAdYfxYs2Ci0aTGaXJzesEOl6qN3VfEyRp7PmgSSRSHcnKwZKYM8WhGW5d2CL+LoCc2P/33ZQMYayKw5VPNQtz/yO02d8FfYVbiDOm1S/6qWIpR626JAdxSiteXC2L4uUwPP1i9Kda+WGmucSUw7oUXnFfPtfFaYh0t2cpT3HdmnB7s6roewp6Pe4S9Z6sO7I/LAGSE30+Wz
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3e5331-8852-4b26-f518-08df0a5ad691
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:02:17.4266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdyZ2wdeCwUxP1eBk3DODS1oNEqOpa+E3v/3KIOGF/+MdmR5Hw2GSehHEihi/Q7UkSeS96pvQYq0ei7MHRFiCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA3P192MB2839
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
X-OrganizationHeadersPreserved: PA3P192MB2839.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDA3MyBTYWx0ZWRfX9lXFhR5qJQ88
 L/LFv2HP0us98hggCBIuLpvt5189uQtRVkCkBnHCiZv+LSDzLMUloaRHnSMPBP/liKW0aHnh7Ri
 07JqOoL8VbVMx2X/w03qKQkqDFDWhTM=
X-Proofpoint-GUID: R7dm8zPgOlaOgHpziPL7V2tiRsU2r6W8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDA3MyBTYWx0ZWRfX2dGvY1+deQJr
 z9sYtJuOTi40WAHUbLV3rniYT93Ycrb6BCuaIZKmmAFUYnjPEeYY6dqhZ8CK3E5upqp5DC7SL5W
 DTLiL6HeNGnpKLRKo4Olj7pmM24Mkm4ZEXkKJstZcwDP6qJKTVyz8hKcS2JZuRmW68fqFAQG7Ko
 PBYNbQqP55N/gc1nZrMTW8Lpge3Qi3CVidqzt+KYdoznS0TSUZU6lh+I9Jw+RnH0pfF6KsWWTMt
 osuiw7pIpCs1UnGdzZ0QILs/4j+Ar1CYhytJ4JTC1uOuIbkc4wu4sv/NHcxqNRR81wYDSpA60Gm
 HN7f9X16XnBw17VtxORt85tJA1CXvc8n4S6+CBxionkwNwJKC4uFDNqu4JsoGRftK/tcjjcOvdd
 hff0UebkJ8BYlScWxGc2zzrWxzbGrnSQ/REVbrTkVACbhm5cfc/RFtyGLnaY94w570qyjb0eTXZ
 QxXdl7brfCO0jXRPryw==
X-Proofpoint-ORIG-GUID: R7dm8zPgOlaOgHpziPL7V2tiRsU2r6W8
X-Authority-Analysis: v=2.4 cv=Lbc0eDfi c=1 sm=1 tr=0 ts=6a9a7b0c cx=c_pps
 a=yjUwPfZTp1nEpXz2ZpnTZw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=WQ4YJ39tjzx_Hbm9pN5v:22
 a=U-qftYCtcOvajx-Bi2YA:9 a=CjuIK1q_8ugA:10

Hi,

I'd like to report a firmware behaviour regression on QCN9274 that breaks
encrypted AP mode, and ask how you'd prefer to see it addressed upstream.

Hardware/platform: QCN9274 hw2.0, PCIe, on an NXP ls1046 (ARM64, little-endian).
Firmware: WLAN.WBE.1.6-01243 (QC_IMAGE_VERSION_STRING=WLAN.WBE.1.6-01243-
QCAHKSWPL_SILICONZ-1, fw_version 0x160484db), from linux-firmware
ath12k/QCN9274/hw2.0.
Driver: ath12k, current mainline / backports.

Symptom
-------
With WPA2-PSK or WPA3-SAE in AP mode, stations authenticate and associate,
but the 4-way handshake never completes: hostapd (-dd) reports "did not Ack
EAPOL-Key frame", the EAPOL-Key timeout retries exhaust, and the client is
deauthenticated with reason 15 (4-way handshake timeout). Open/unencrypted
APs work fine.

Analysis
--------
WLAN.WBE.1.6 advertises WMI_TLV_SERVICE_ETH_OFFLOAD, so ath12k enables
SUPPORTS_TX_ENCAP_OFFLOAD / SUPPORTS_RX_DECAP_OFFLOAD (commit d29591d5b52e)
and mac80211 switches the AP vdev to 802.3/Ethernet encapsulation. The
unencrypted EAPOL msg 1/4, sent to a still-unauthorized peer, then goes
through the RAW / TO_FW is_diff_encap exception path in ath12k_dp_tx().
Under 1.6 that frame is apparently never put on air - it is never acked.

The older WLAN.WBE.1.1.1 firmware does not advertise
WMI_TLV_SERVICE_ETH_OFFLOAD, uses the native-WiFi EAPOL path, and completes
the handshake. So the trigger is the firmware enabling ETH offload while
mishandling the encap-exception EAPOL path.

Workaround (local, not proposed for upstream)
----------------------------------------------
Not advertising HW encap/decap offload restores the native-WiFi EAPOL TX
path and makes WPA2/WPA3 work again; MLO / Wi-Fi 7 is unaffected (gated
separately on the firmware MLO feature IE). This obviously sacrifices
offload for everyone, so it isn't a real fix - hence this report.

Questions
---------
1. Is this a known issue with WLAN.WBE.1.6 on QCN9274? Is a firmware fix
   planned?
2. Should the driver special-case the pre-authorization EAPOL frame so it
   always uses the native-WiFi path even when ETH TX-encap offload is active?

Happy to provide full hostapd -dd logs, tx-path traces, or test firmware
fixes.

Thanks,
Michael Pfeifroth
