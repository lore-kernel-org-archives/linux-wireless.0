Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A354E8E06;
	Fri, 25 Sep 2026 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790366357; cv=fail; b=XirJvvD9FCK9TmhJpMLSYxT4CXlPYk0AXRWJZIkTixCdtzeKXt692lMd06oTlWfHSopPyOhsqOQuM24QKqOLMajwEV+nGgVapn1WDFvabJ9urtZLj+zUWOvgI65FRmJGiwEQsbyt9H6SqN9dw7s9pgbQZ+GIZ1Fpt3ildYH29Ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790366357; c=relaxed/simple;
	bh=zeEaHsHuVCXSmP+KhxXerSzJIqFNHn5J9x1F2zYBdg4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pHk9ftQj/TKnb+fpULfznBY5STCOP7UyVphJ37aCH5FqmjTId56Q39+rOpaudP5jPEiQ1qLpOrQniRxTGmSJox2kKfAMwLuDo/E2lGRov1jawzBsTyZLTfLDz0DLbAghCQYG8x9CpfwOqQVGeQ1s+RMc7KqGvi/ZDvl1YVFxZrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ex9wcXOd; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ex9wcXOd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IIQU3zToeGB8UuYxdfEAT+IBli68t9NUb+01oH+stivgk/sf9LwF+W2rmaFEHWTZQNwxKhfSoiqUgiMTuFrUQjCULn4mB/Kpgp16YGz9+DsdB/qwmTPIFQZhRCNY55QeCWR8K1+yt4CYruXKuKEe3fXnTqpC6Pi9P4bLWkaAX/LZvyjfj7ysJCTlUqgw5FYYPYiywCNt21bL0521z5cX/zYfTpkVd2tOqhGlxxSDF2CtRY9Tl2wMwoNOzQpnjbbJWoi2e9xe4zibqPsWTLk/USOwjv119vc4IbKzvuj9wPvvvZzvWpXyTAYL8a54xHRQKSSB/wBcSJdZflr3QTjMuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mbGOIxWrVYWanLjwkdFCVeOjFUnQX8cA6I7JQmskp0=;
 b=K+zchY122FlWHRttq2X9jC87zriYkurzGlQnm/ljhmlCql7Sd+TaXAAF6edf9AAvdMq5FR58ifnPkWEdm1fkAa9uChpuSSYge48qGCuBQJQWr2ARSNy6UO8Nby/Aa/QIJdNLrdaCNKi8ZAdHmIWozUdTrcTxio03iq6BhuXWaVRcqgkdGniJEyyg02Ye/yeotdFAuqtKKX5Nxr3lDpRBx7/FUuhZKZ1TeqepVC99icAcnK+E2/qIrIRbxdZ9bjn1uxTGvGJkzfLtJm2U5AYPOt0+5u5o0+eW15Epo0hIIm160XzwN+Gzcw6JBWFV29qFaWfAgWeaxK0mw4ih2IRwoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mbGOIxWrVYWanLjwkdFCVeOjFUnQX8cA6I7JQmskp0=;
 b=ex9wcXOdfc2k6DXR00SxQGuxmCwj13wHre7powqRc636UqMMPyRZkuW4edZF/ElJoJxkWU/hiS7Pq9JYkgjpk9gxt/skvtZzTiFEWwzbsUABvc+23NUhPIEnxeLUQQXpoL+opPSUO8vvTCqboEpueLkOsJa8iYwQOtFQmugwYzN5tIIj8t7l7EcqgyIslm+unZ2Te0m64XgX6uMjBSsfmqhRi1QhDke90tWzc7tR5wE3bmeCkJEJffcQf/0rK2/jVE3DTlkKUJqzI1/kIQAnpnMw8XtC/FPhXehRlOPpznNav3UzXZBl2KSyh4K+RcUq/Wof3GYJT+CJKfZYi362bA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 19:59:11 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 19:59:11 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 0/2] wifi: morsemicro: mm81x: get rid of code duplications
Date: Fri, 25 Sep 2026 15:59:06 -0400
Message-ID: <20260925195908.252810-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::32)
 To LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: 22989f3c-9d50-42e4-b5ef-08df1b3f7780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	0wliiNd8FCcr2vtcLaIZGzMKUH1xqiYjllAbkqCf06xJX5cj6uIyPfOejyA1C6V8LylFM2OKXt03JgkRd5eeqahwH2i4MZvrN0UThCZdK0wPrD2F2pcqd4TOlR2O6NosspURbSpfeUQry9AFEiv0Jbd5wNoOInGfe8cWmsBOifOM+0LYucy07q/S9iFLaHAE9cOtuf/Y09oBL+K36OKyUQLqgIn+NKHDlLP14MvgXXsGlgMtgn1oA+iIFm3TivQQfWbuOGMLJs5gdbYNFZwnrTCxMQxWhQAs7E8+wlE9517vYUR7YF38hzsm6TKQU39jNlNYtpJ/PAOq78LBF4wgamElr+6NHvScay2j8yzF/4etFUsWbKcKerQ+3eIOFTvISif68r/rIYUumubBB1jawosVyZaQ00dvFqjHQL3TpxQWgA5RAQFuiipoNM402R6dXZtsuRWT/AcYRYnEM80VETzv4f5g+k8zqX9Nl3/MKI47TtY6+0o5slKG2Er3nwDjbcRrNrkA8UOKXWR8aL1loppi6IZRtvXPPp4caVG8a3bF1gUGsEmvIqgcQN+aCy1sAx4BKxkoOkvF16bqd73IOMX1xdvh6A0EKbBydv667EaFHPy5FDMgw2W2ZYUmbh1ezWHY3Z+6rI+78JO5htXN83ERsiPnM5TA8W9rTdKOmS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gHrPe7n95gaOb04GNPaQ3yLkS3Zq1MQNUYHOEnmXHx9ass6QF8aBEnKqKyPf?=
 =?us-ascii?Q?6c2K0KOTFMUZVpRnvLs+fcMysRUZPoD9fFv6UZLkM9WNg8Fo54Trlwsdf46G?=
 =?us-ascii?Q?HErp/BnGrK1NME/40M/XQWlYaSRCvyiDLHgtJPLyzGHoByPug7lOH2d+OD7a?=
 =?us-ascii?Q?JK1lrg34p8iXCZDSwp847D2ppTL/yZyfUZTSjHVW222fAeq/coeCK/LDyTcx?=
 =?us-ascii?Q?MNvXJubh1nMEGIkLKFBWB4Ws0PvGR+fsvYssto3rNHqjwL7xZK+wyBvHfMzM?=
 =?us-ascii?Q?A55pNKSRsjrZDpRmloMjrBR0JNAKU+LDhICXZ6mpMYy6SaoVMOT80o9TZJw9?=
 =?us-ascii?Q?CzZ7ls/0/lncHS7eU5Xp8+kb9AR3IsoffIWBsswv598ChNhRZ6FJRM8YRj3a?=
 =?us-ascii?Q?opVRGGNZVc58pJZ5gMAef9Grh31wh8r+Y8MJqkhwgS66pXZxDHAlOk8riTf3?=
 =?us-ascii?Q?sH0L+vVEE9wXiRCag4ifoUHG+d2Y3lzM8OZqDtXtXVERX/MquVjNw0pauwoK?=
 =?us-ascii?Q?ThPGerD3I4wn99wEyXR5kfndphI88PD2lfBG2E48INaIxlnSipnDYnZ+e3qX?=
 =?us-ascii?Q?z/qcamiPN6ys8y7pnk1C8CVX3EM3ubSGJYYBjAMqadHg2wUpfPlvw7EGctlX?=
 =?us-ascii?Q?9esLprALQzlxmTfah2IZXiR+eXmeA9CFgPsKp37m4QpaxN9i74iaQmNz2EZ+?=
 =?us-ascii?Q?PECb4sPYiS+oMSHtqGPpyK0Rx55bKE3OKZXEmSpw+eMp3E3RH0+9E9Otj84y?=
 =?us-ascii?Q?HyV1x0PJus8uygM7nrBbR59yUXi486eDREbl+rXmGEp/7wVcU8JOBjz7v/3m?=
 =?us-ascii?Q?C5sDzwcztA7ifqGsxAyRFLqEH0reYCCrocJDtLk6QP0d3cjHBoV9FBHGW9ho?=
 =?us-ascii?Q?DUUVWWFHVvTwPCEi1LznKIh0Bowf377rxvwQ7aN1qkK9RUyA2oReDQpB1Glf?=
 =?us-ascii?Q?ARp5LEwM1JM+M58zAP5Iop1GKSqNsvSuxt9vnp7iAHxPEJN+8jO5rIGFae//?=
 =?us-ascii?Q?AYHYMHuYDhbcrgukrO5L3s2O9bzexosuGIYNTOkUckEfnmwXTKSgbqYgVikO?=
 =?us-ascii?Q?u0uGNs3N4FnbdUaQjlU2y5+hhjtqJ8OiS/tfjAQPlWggQbqE/gmtovGY3yeE?=
 =?us-ascii?Q?XovGl9xsvw5Hcf9IR2sx1gjDIzudyaJQwTg6VsjhGcW72wlYgiBkOVWfOJf/?=
 =?us-ascii?Q?dAsX8vwWqYIR9+sx8TuMp1a/F54CnvARxvmr2npzrUreOSb7lrgo+ZFzgNsp?=
 =?us-ascii?Q?IifHF9+vEdKrowiUWrdpkeBOmn5FmISDPx968FAKHltASqgAGiWy/P5oHRhk?=
 =?us-ascii?Q?qEPy6/SYJq9+oSwOxq1+WdpFtZnhQN404jxx3EB2Hxp4wH02wCzntWPPr+oi?=
 =?us-ascii?Q?6xiYPnANl8d3TcPhOzNW1f3iC67z2i+2H6yscTLINQ1ouKbQ8AeSdMsjKNon?=
 =?us-ascii?Q?TEDoa6nnCmtFyVUTq56X7G3CXBNeO8Cic24xMspeS7IJ/I46D2Rkg6qnHL7T?=
 =?us-ascii?Q?ftgc/MAfGTfOv0aGz26CPRsLAbVX1IuejdYvH7g3wx8ixVBzrHkmurxZIkhw?=
 =?us-ascii?Q?oyJplv+zFcT2tXJHWflcLG3DS9RsfzDeCwvvrtmz07QCLOSaAqALtkMphYVI?=
 =?us-ascii?Q?gstl96htkwUP3o8KP+8Csjq100O6GiVvb5WWYh68rhy54kfwzJ7gHrCXgNbk?=
 =?us-ascii?Q?4nt6qY0aY65OZRrZf8wKHOMmP4wF1LNsSOfOqefzO47P7alx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22989f3c-9d50-42e4-b5ef-08df1b3f7780
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 19:59:11.3463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmoJkdjldx6aISS5wMzw+jvWdgx1klF/yGQy/e3OCY7O1Yekkw4Hor4bHfmzvQIIbPOuJoWKCgpxvTjr0FFFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685

Get rid of nth_bit() duplicating the generic fns(), and drop opencoded 
hweight16() in bit_index().

Yury Norov (2):
  wifi: morsemicro: mm81x: switch to use fns()
  wifi: morsemicro: mm81x: use hweight16() to calculate bit index

 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 34 ++++----------------
 1 file changed, 7 insertions(+), 27 deletions(-)

-- 
2.53.0

