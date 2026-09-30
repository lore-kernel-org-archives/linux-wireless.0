Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590564E2F0F;
	Wed, 30 Sep 2026 13:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.31.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774159; cv=fail; b=gcPuBIJTx2tV+d10KmxgcBEh15X2ixR0lH9JZZMpU6/7x4paAfacrKmt7TtT7TOeg/7st4s7KD82UF0QW0nJFIQO7B1Wittw7FKoY2i8TWPAonRPVScWNnNOlhKsm8EBC0iN/mX17eQGEj/MGYpK9fCHxuISK1UVeq9+k0dXUQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774159; c=relaxed/simple;
	bh=I3gMC5Pdprqx+Q6nZCePKvy26AQ8px4sT/Jg8uQCsfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PYJ6Aepsd4OmB312Lyp7GkYMn06N/eh/JNykjyXhFLpGwHRSKBWDl2O37qimEpbMi3UoX6nIoL9loGt869p6K9HhP0+1nXUYJGN+TzBPNitPj2ib3uKIgGXsY9+jxJIscGQH6pvVVv1qH+yv6ihMYtD4tc5XouCxqv6yPt1WrLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=ELkrbrP9; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=pt13rdTM; arc=fail smtp.client-ip=185.183.31.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="ELkrbrP9";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="pt13rdTM"
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB9x911517728;
	Wed, 30 Sep 2026 15:15:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=270620241; bh=Bv85Z0EES1Pygm2Td24oFbUH
	t0302SkW18IvIa4qP1g=; b=ELkrbrP93+2yOQhJIL7UuZ8NPHvV5vn5YiM0BO69
	sbyMG33XiNzOFgz7s1GdiHs8HPPVnO8bqiiKsONv+mH5RjmpuQCyowbu19HeLc4U
	Q2Uxu2Pckl5MhuR8qQwEs/vhNklIH3VKzGvhi5Sh/7INZvG1wWlmpFPBx6iVQplK
	YdhWeBBBvlummoS3QV52JIjf3DL8Szkpo7ULiuTRRltbrG4xwtXsvKQqve2qbaUK
	Jq7VnfnPvsFq/pDkKkgGuJyixrAPoJxuCKqet3d5qMv3SAQanmj7T9bYnxmavjVL
	OkqognbuNRHpjp0YRPJwgNeN4PmbvTxlBk3E/i4BTKmDZg==
Received: from osppr02cu001.outbound.protection.outlook.com (mail-norwayeastazon11023113.outbound.protection.outlook.com [40.107.159.113])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gx221vjj6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 15:15:13 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPWCOWG809Orvbz7hXl4wRITm+9vW2vHyAXTgE9P4526AcODexBVfit2kAd1MZ2QAX0i4N3/WaPWDFwSdyl2W1SKKrd/b2TDlWLZYItK+eXiShAjRTH19CvOa7s3Eh9Q9n8TzHm81rJ4kFEozzp1KGprGp4xjhDtVL+Qdsq7LWMNc+K7JQW+9R1YUIHPoYzqO48MP/WgZ3lMWQIes3HNBf0s2ADOP2XD+CJv2Mr5wIjJ4KMLi6ucQ9vSU8y9/d6Y3N1JJAFZjvkcy6FbOnLl/+yJ8b1tT/ECU+UhRkknwsX+QXzWPX8HRhvxzer3K4+nV9mSaOMEsNl6Wf9LYsf7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bv85Z0EES1Pygm2Td24oFbUHt0302SkW18IvIa4qP1g=;
 b=dWpj8Ka8ifyADIht62ToDctlStt+fYSq2Nz4hoRhUwRypjpKMmOsFk1zz5zE8+AmOQA8jXWcdR0B5BSVIMfW/vXFfNjPFvS7jk02zHlnXO44n1wGhQ5PSSt6SM1TfmKBi2u/5jT3kQgfsNnDjSWCybeR8qBdAD7Makeu2Sv2xJgzk9Miaq5vWITAsh9feASKeG5j8KBvCXjpQeLbEeRJB6fe25Ne2gLrz6AzO7UiegSHMf6SzZ8RP6ZjxEIpXH1qK42LGs/NQDFF8qi2wpqkXpWHD9FFygpureN9l1WD9inKz6S0q+/JMzxraQorK3JU0QDP9gCm9BdZDr6ZSgy7Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bv85Z0EES1Pygm2Td24oFbUHt0302SkW18IvIa4qP1g=;
 b=pt13rdTMS9dx2RYvA6eC+RLM2maCWAx7x+1DJFxIWLr6P9BSx1YjqZIm43iUc5i8Md1dJyr85BeVXHqMBsyNhW01VFeft+QG1BS+D5G5d/oQ5is6RgiYJ7HXyLiJcAt26ibx55nY4VrvfVhFx6cBPmkRPYQjwV5hf3SQ9ZdiX78=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=westermo.com;
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by DB9P192MB1444.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:326::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Wed, 30 Sep
 2026 13:15:11 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 13:15:11 +0000
Date: Wed, 30 Sep 2026 15:15:02 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] wifi: ath11k: release peer accounting on peer delete
 timeout
Message-ID: <ar0LVqHZF8UlRB0o@mpf-ESPRIMO-P9012>
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
 <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
 <arTp/9A0iMNpIhl2@mpf-ESPRIMO-P9012>
 <8bc3eaa1-7233-48db-a41b-ce3f08fbdd15@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bc3eaa1-7233-48db-a41b-ce3f08fbdd15@oss.qualcomm.com>
X-ClientProxiedBy: GVZP280CA0093.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:275::7) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|DB9P192MB1444:EE_
X-MS-Office365-Filtering-Correlation-Id: e9e8d032-1f74-4fc3-5cf2-08df1ef4db4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|11063799006|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	S6+MSdaOYpP8vvUgyd6slO0vsniPiMlrxOOIppCkyIrNf253jQds1ZymdVTOBvlsm9k2Jh0vY2YkZMoAKEaVuaGZf8iMLE+lPv/C05awcnXFKPXI/ue/uCSFhxBqr7R3jcokcKE9t6Roah5MeZvB2VkTy6NdSiYpH50m+vBGqCFSwmbDIoSRiZ/6zTBthXO2HGSOTrgEbVu6WYv4ffzPNIfLbmOIB3zdv6d7cPvBjcjkjHGDK3T5ZxNLLnzF8cprB6vybwk/wYH/A7dnxp8Lsog14bdcUTViYySh+7qEggRvw2aN0xUxQ00wkstCDT6lhMnUiBTiNlbOz1fp7VE+t0GSyv8Rj70IitufFfPcdPv/kI/StW6RA9MUzWlg00ExZqQZu8ao7xnsxkkhYdr+EBY/Hracs8teoxSpe4DnkyW15kufP2L7eh/7U+MWFRTgc/pl8Afk3R7FoIShO5rG7WLwN43J37sxdmjpyMBWtXixV1FSAPkjgmQkPApYjPjSwgXzZGGYcIi15/m5CxbCWPTuKzK/0epacK8gE9ypSAAQX9bYfScI5eqGRwe0wcsb8qk4RZTZ1QuDAw8hw/s2crpJPzTwaS4d3vOByl9NIAvExmy0PVKspCGi8LcXnC6y1qzkZQYnAN1VlInEf5SIGkmYyKIbEsh4YZv/0C7aYNs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NrHEGnTfhGwqwbQUNK67/RD2PNwvGmR+tqzzxopSpUkX/a7MXw7xiRpWllPm?=
 =?us-ascii?Q?9r0/S6xJrqX7eaJIFhx1FQvv1Qc9nubq3c2sE7kZwpqy90YF9FMzwkfTs7IY?=
 =?us-ascii?Q?vCoBEhUNYbEJ7NCBxdz88PwQ32vmiePufjKkCvB1nz69hhTu8m8HQWMx5RA0?=
 =?us-ascii?Q?F35SbrbJY3GcTUmXak6iXEejdRVjSKfOORovo/DVnQGlx6vLDltb0BPSsx3+?=
 =?us-ascii?Q?1gilKWF6itxcqwegzziuE07tJAcss3yUW5wxTh8pmR7PxHZAZt+xPeP/+rFn?=
 =?us-ascii?Q?rcfAsGbl4ECSc6xbpxm13dq0nPLYW+R4RLImEdXB/uWjgZvTXe5jZjOcTp6L?=
 =?us-ascii?Q?vDXWBE4RYyNella+Xqq+jRIJ75gmIrc/MYUoJJjp71stdYbsxk0oxYHroCEh?=
 =?us-ascii?Q?UkLRKglPHHo+jDpSpTWQ4c8JKUxa3hB4d+o+RIpEn2HZYcra3XsgojOxEwZD?=
 =?us-ascii?Q?cc3ACdkiPtcbcLyq7dqX6F0FGll6O1ZzbrY6TOyKUq5d/bM5MoTsYElsh5hO?=
 =?us-ascii?Q?1Q0akLWbsXL5nA5eC7gEy7fLWGfqKIvI5rrFcAvo8xbyBKub5GHx2dXwKoxW?=
 =?us-ascii?Q?Rs19fc3EnVVbjGZvDH/00ubL/M0TU6V+5cfCWyoMPgw73AwdFnrKmY3E//YE?=
 =?us-ascii?Q?qbds3ltElrBS0vyqxv899AQPLNRYCVwUuZhFwgLAOzg4N0Edr+BRRqM+RQbt?=
 =?us-ascii?Q?yPD1WzxJDr0rP9QJ5y3e1bbDbAryqE2dw5oWwNp+c9kGETwlG0RAqdR94rkR?=
 =?us-ascii?Q?IWlnJR3HTpK9T8aAH2uBcCzc/hcxVRYQ16bRK09ZMutKELDAWwWcEaTw6gDb?=
 =?us-ascii?Q?Sdkcq8lTOyk240BbXwKnjUdHroqNMadRIeqAjMs1IiNXpka01h+EKeM1H5jZ?=
 =?us-ascii?Q?1NivYns1ofFCwJILSWVsVQbeRv7ajawE1j41arjYwUuWTIm/RVRL5r+Yr9Os?=
 =?us-ascii?Q?EZFv7gbToKGMCVG9+jLZtrJs6dKTcyn6v5i0DqqIFq16sUZnBHO5As+2+7Em?=
 =?us-ascii?Q?9p4+XlVOGCQN18YfgBUf6zk+J/fWK34kiheOhtXABJxUeioJjo7rRnDhwmHB?=
 =?us-ascii?Q?kuZckf2ww5VCShEA7Lz9ndY40Kf3L0FFs4uWU08iM84rNxxdlr+Xz148iSKn?=
 =?us-ascii?Q?znjqs7JmP6kIo2cn6vyKN+vouJIlCk5UL/vi8HDDWfm1iOqFTjKdjmBBKRJu?=
 =?us-ascii?Q?tP25CiIwRSG4Z8mM+7AzXTbeTUUCzeyvbloKL8S5j63ThU2bsXs08yV4nSVO?=
 =?us-ascii?Q?xCezJYzBSwKvIwP5y3ugUnk1Fd+lxiVZpY0f7O+4dJhMXSlzeURzNmp2MYCh?=
 =?us-ascii?Q?PW8x020QpIDIER4wc50f4Lnq4IER6seu6eejUxX9mPxnhqKHBdsZ1qDe7N0m?=
 =?us-ascii?Q?7swKhiKeEsr/7KgvxXzopk9r23yjISindYpHtE+4FaReSvS5EVpFf5wGaK93?=
 =?us-ascii?Q?9OAFAI6++4FBTmv+i+UoGvAvIMQ2ZaU1v13STGoSlb+w7LPQ9YzlUUp5fbmr?=
 =?us-ascii?Q?+pCRYVknir5EFyTkpM8jEhCgaM5jaaLI2YSENmgiECCA0pheiP//NeNUKy2A?=
 =?us-ascii?Q?cVSyb97Cb9vY2h2cW554+7NE5h09FN9Kt9HWDFA6cFAtpRKNn9TRQ6exJWR1?=
 =?us-ascii?Q?PN187f+aCR5BIfaIEWxPFp5fdeahfpsszRWvNkJWHktudVKTsLW7F60z4u6V?=
 =?us-ascii?Q?40AWrkq1yY43vdEeN1rS0rLtd4nYfUZc7EAvSQkkUDhd7RiBddvTWZaYvCkn?=
 =?us-ascii?Q?v1A0CoCDGA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	stUWySYdjBYGbqMzQY/+2c5Ud04cwByBI1W8P3WewmevVxBmqec7qjcsgJB97UGzjdZyphA5X1GlnzKgWa3vOQgLfqCWynkpRFX1RjZPRaOqjrvf/AB8lxHwWW02268lqqN3tTTnVlQ+1x6cpJqokblt9c/gmDZRP8fz+9rY8T1hZLWHKcW3Jr01wO4ryfGb+8Xi4P1yrz1t6ir6B6pIgadoaE/a3SqzwG/dhFgH3gmagelEooo2+/YBlZkxRL5w+4iLXxXbJauExJ1/9716iIrdcVYXCDLQKBw0pfMg1ecea6QMMTs42v0I+OeYqPpBhYLfXdFZKPBfjZi3KkSzvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OaAg4KAIFwQc6YzTaGQyEN42t0GXvnJxxg+orLpIlYegn/W7XD1/FxXZSvEsmTES+YF34hiCZY3qNTwIQlw813A+UMgxrXPo4MRsBaMQp0z0KENKQU42nwyIJ6MuG2PSOYUcnmmg0ipWes4i3E5Yf1Al2/K0AdZpYecNP2/X5kgQ1z+YI3GOR4jt3V4WQj/BKDSKlpgUJMUnW3SE3Sy/X3pzXC7gDryebH3Rfdj5hhnUx3jKFaH9Y5NVPb4Efw/u+WBk9MFV40CpTQqFukkA3IFO6Wal4zYB8GLUSYSezhg8AxyWxn5dybXoyQg1TTaOw0xwA5V+YCsKQpEwy6GteeCtF8BSQe2B4lcLzkW9EuC29b4J8s7gxk5yUjm4yGR92fMR4qpccA/ekoJHY+IOIBYRbokk9ZdFENaa7poIH5Mr84oJVKH1ZTmBL45Rt0rCo/97Fj/Ws0wzd+Qahg8WNSM64Ua9tMmYXkTdu66hy9qKI2vmJ9rIpr0jxREb1zUNEE274u9FTbvG+n3wqL9/tPSJY54e5Hi+SrwD+PlCrJWHA4/BzhnQ5Kmx1AdCFGU6Lg04qhOYbZZj0PpB/y+QVOgzAJp2t5vRUOVLDCIxH9DojT9YmWB1hEdZBBm03z85
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e8d032-1f74-4fc3-5cf2-08df1ef4db4c
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:15:11.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9/DQ1OAJuvLM/Wn7fmE+6W+amdtVr2yMvntuMsXTkLBSZjBhM8Sd0QMd3YHnwqoRM4XSjhge3LpYzg+V30FCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P192MB1444
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
X-OrganizationHeadersPreserved: DB9P192MB1444.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-GUID: r2Y-Vv7Jh4ywBGQNih83elvx7gMSjpok
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MiBTYWx0ZWRfX5qdt+5yt1omU
 9/jVmuIKmM52heKPCe5MSHLcoBi9O6gGFP5xF5qliNcjzoiYK79nI7FVZJDfc/gJc3YHBnSGVjj
 VvLdejl5sLQraML0vSJmb8TMMzncBJI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MiBTYWx0ZWRfX+COh2Ygdw7js
 VxNr6Qz3JEZ8RmPK3o4XSe/7hzL94LUutLwXn1HK2NW6q3oFtspEbjsJivGcou3svJP88Vpo7Xv
 Q101m4XUwH3mcWpAod3hDejMFpDtpZ7grEYZmJJ/5vsMDySPUvh02neytoWHc1sUgk+UkAkdH0X
 IcdI9ovgoV4jH22fGM9wBmeActCpxdRfLuQSWmAVeQZFA29h9E2mnp2UsThZNDibt1ZJQzxrB8d
 /BE5k0Z0DrmcPD+IzRPwBBtPdOV5o/v5dXTcj+QPnzuKxQBPD5kEES/ojj6RnYt42iZ2BchUG+X
 RM9mcLt9ZVZFqeQcyVnJA3gN0sfr8gn5r8ey5lB0//kVfbtBwQ7PhsqHZFZwgbRFZgWd+VPQyoS
 39XxG27KihhHntvBnxGvp3IdAEA2gv0e7mKmb+1Q/oivnm7BiG9VeHc1o9raxYXJhsBvP7icQyc
 bT76jnL20aWtuzlR0tw==
X-Authority-Analysis: v=2.4 cv=HcqB3SE8 c=1 sm=1 tr=0 ts=6abd0b61 cx=c_pps
 a=BsJo92phwnomxPsqyV2TWg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=WQ4YJ39tjzx_Hbm9pN5v:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=-3fE0hjeeAZz44GM79oA:9 a=CjuIK1q_8ugA:10
 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-ORIG-GUID: r2Y-Vv7Jh4ywBGQNih83elvx7gMSjpok

ath11k_peer_delete() only decrements ar->num_peers when
__ath11k_peer_delete() returns 0. On a peer-delete-confirmation timeout
__ath11k_peer_delete() returns -ETIMEDOUT, so the decrement is skipped
and one ar->num_peers slot is leaked. Once enough slots have leaked the
ar->num_peers > (ar->max_num_peers - 1) gate in ath11k_peer_create()
rejects every new station with "insufficient peer entry resource in
firmware", and the AP stops accepting associations until the radio is
restarted with a wifi down/up.

This was observed in the field on an AP after hours of uptime with
frequent roaming and reconnects: clients could no longer associate even
though the firmware peer table was not actually exhausted, only the
host-side ar->num_peers accounting had leaked.

The delete-confirmation timeout itself is otherwise harmless. The host
first waits for the peer unmap event in ath11k_wait_for_peer_deleted(),
so by the time the delete-response completion times out the peer has
already been removed from ab->peers and freed by
ath11k_peer_unmap_event(). Only the ar->num_peers counter is left
inconsistent.

The timeout is reached when the peer unmap event arrives but the peer
delete response is missed, e.g. because the response event is dropped in
ath11k_peer_delete_resp_event() on an unresolved vdev id (logged as
"invalid vdev id in peer delete resp ev"). Do not treat the delete
confirmation timeout as fatal so that ath11k_peer_delete() releases the
ar->num_peers slot instead of leaking it.

Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
---
v3:
 - Drop the defensive peer list_del()/kfree() branch; it is dead code
   since the peer is already freed via the unmap event or on recovery
   (Baochen Qiang), leaving a minimal fix that just ignores the delete
   timeout.
 - Reframe the commit message around the field-observed num_peers leak
   and the resulting station association failures.
v2:
 - Correct the root-cause description and switch to netdev comment style.
 drivers/net/wireless/ath/ath11k/peer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index b30a906..f573a2c 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -340,9 +340,10 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
 		return ret;
 	}
 
-	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
-	if (ret)
-		return ret;
+	/* Ignore the return value: the peer is already freed, only its
+	 * ar->num_peers slot would otherwise leak on a delete timeout.
+	 */
+	ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
 
 	return 0;
 }
-- 
2.34.1

