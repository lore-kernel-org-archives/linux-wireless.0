Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52374E9C3D;
	Fri, 25 Sep 2026 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790366359; cv=fail; b=uTO6TOOTd0RrtMZIkgehFz8YD8tI+Zv2hc+kGeA+qik0Mrrh4Uynv6Wp3X1DvIoXRofAzWkxn/vdqq/v3tMDKa3v63Ur2fkoWmHj8Lvweo1J8yMKq+ciq5bvepFp17VQ5jI9kRJIxCOR7X1envWk7yhn3H5cpsinyuchTkvs9ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790366359; c=relaxed/simple;
	bh=vsC3Sd/biXUC3DjFDrvPqm370s+NPjLkWN9NKZAuD9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Op1NkxF1tIaDwk7j2ierSRGTEO9BQuttvL/WrLDj6U4Rf+XMoh4WWS7V6AuvQV1HjKkpseEaKUffkm2cFf7BkNJB6DNy2iuJuHuzfOzPU23sijpWzr6jNqPw5NXN8jrKMFS4TuskPy+4YPGgGkK5ykIXtzeJjx0rFjcU6d37P0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IxVl/QJr; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IxVl/QJr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnr7Wte8fNnhpAelET0TiS97YDbwoKakt+b7OLySL7uEOX/eAFW4xPQxj4ma22qT1hqSdan/HHfBS+ikEAt20EpI2NVU/qe7gV3K0brRm16yo/xHURb3+y4mPk8VLhpP7kO0B3fM3e5oV9RhLCcGC3eH1s1Ak9XHnUE8X/+q+Ch2ZDAX1f0CwLzJ2x0oYckIbP+1zzla+VvcAs7DT0jE87/qqosVM0BhSIQGbiwgTNcMnRM+NufmN3BF4IDogsrmODKyilaVoCtXgtV+7iTJsfspkeGdYUI/om7H7HOxbq/lrmqTLpsi7GpQAj5RjtyXiIH+hFoUtBWbdSy25NbAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LERcTv8seR1fpPnxmC3ADZ8oMpU6LFickhVEqNWduk=;
 b=ZqFMZ4SGZ2TjFniEBMtP5rJyoXkBXSmiq0OIkyCYvDx7u7Zu3C61UhVW6KjF3klSQbbab6om1+pMZOvO67LAymHCjwLHwdUPqDcOA/Djfx1xjAkUZ7HcKz71Rj0sQVT0mXyehCVG+cOTzLt+L5fRMiSfTak5AUl5quVN08Gm5eP7Y4KI5TDp211Ot9m4iIsVnZ0nDzJsTcEzAHFN90J3KD0coknkp7YBpQD8UCHuRsBSlw/vucWG7XGvcSO87uEIF9/3CMJT1Jrtwh7n0xrTjq6ghasyRMtTTngFwQSJttd4wSOhfzq3KdQXwaoxYWNg6aVWDqqrGQDVJJjeS7GLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LERcTv8seR1fpPnxmC3ADZ8oMpU6LFickhVEqNWduk=;
 b=IxVl/QJrWCbEP5mI1b0Dho3WENRLcluLeYmDiSltUQfc2sik60uVyLGIYJt0qjgxGEgcGIMoBV3xFCFP9uQdzoNhlgfyS1oertI4cKp6UlCVIhXqkxAXLt5Y+cBonneoKBq4AK6ubNQA2IcrYb034nSfC5QAnbPB4VtiSrpah0qckth5e5IVEs1PphN67ouFANZ2s8gfnQswWdrzEMrL2i4OISXN0ghv0HJMZFEP2qABSkABj7F0uBTEsvzoQMQTtU+01vmehh7Bz9nsT5G3IYL8e46SkperWxplXYu1kOm2MLFf+aNkaVFAAtYu3zRlg/qwfUp/xfdT7MK87f2zZA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 19:59:13 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 19:59:13 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/2] wifi: morsemicro: mm81x: switch to use fns()
Date: Fri, 25 Sep 2026 15:59:07 -0400
Message-ID: <20260925195908.252810-2-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925195908.252810-1-ynorov@nvidia.com>
References: <20260925195908.252810-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0105.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:25d::17) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: 77591959-1b41-44ec-de01-08df1b3f78e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	prI03kfoNK4Fs9aGMa2BRZ39VjISO8wlhkw0+uO8VjCkrIQXfhofVMvpJiHeRSHtnVkeHq7v5DEHPa7HTtgAIME+jV7QMYHV/3BFKCTxIovKueT/G701iXyrZceD46qyJ98QsgrRUOwQuaYnOVT6s6TBBQdZ9DX1keDJ9hMGT2nlLmcIpVKklCiBe19K6q6+uIfrBtq/zCCRzM7mtjo72pyGg17YTHsT/1486lhqoAthxBzdNm1zn1xG/uj9/sKvePZfEgP5steQ1T1lMRUsqPUibJdeJwsLexiouvUXZN43r1JSaQF7uTNCmCxv8bC7R2Q065UIk81oHisuhyJACW/hWv4+g1UR/7IwW8C+jkgyMOm5gxqtP2eDwLIP1q/VQAzIsX2SCg0G99PBa+znhy5lRyXdKOX/4xzz3Aq41DyuXL7uzZFQXt6VdmLtlA58o2JZSLk1T+dWVBjrGK63pjznmP1sZqEyYdPsG8nCHRGVvgyIAT0A6LWwWTIbzbv0jPfQrZy5LJ8ZLKEvXvf7qFRk9gJNWpHJ6Dc7qlm2G1aIuglGDJnkai6EbnGuLjnhLL2LlI+lYJMpuY/ykaBE/cOoRTEsOFx3JxdFZbXP0QtoHIOgwJcbM6DujquLDcfdnlBxgLgofbyDmoHhcsm4Egutprw1awA+4NFDxphRX6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JGrYuwOAJZF1oyYH2Smpv/JxMcQkixXwQk1rlrLMN5b+NExlO7fzWNCt4DxM?=
 =?us-ascii?Q?+0gDxIPer/+kRoHLoOl0j5QE0/hJxYFd9r/tdom6cMSW7zAXTZruWuQYeArS?=
 =?us-ascii?Q?TTv6bi4EfBoK1jg1IsPF9dpdtBx3xvY0rTWZrJ6zmsCsvExcXiWSoyu5nJ/y?=
 =?us-ascii?Q?3N7QIRuiVrP+U1ZB/Fki1SBi3NWolhsyKIeoTwTspeFYbOLcjIGBBPJl4VUP?=
 =?us-ascii?Q?H1aPFlJSAwhPEHO/Vepo7pWkRCsa38BulWFmQQeXcgIQGyXP7sFxzuBVgHZ3?=
 =?us-ascii?Q?tjsC7oKcWcb36Ew8mGUM/SURfcij8nTEcksbgmK/hNVP5o/0ujULXzf+zGj6?=
 =?us-ascii?Q?Tri9c4yVJ0gWw778SFIcC5w4UI3yplbl4yAHQ07cGzFu9/3D548K2guFHWH+?=
 =?us-ascii?Q?BDGByBuOOwU07RaII+RClbLxcd0obQuF4TbhihQJnOjWHNQb4oCXkjMrSmSY?=
 =?us-ascii?Q?/XcpNwIRNSt8NRPBv8rH/iQMHMJcy7xTuI5qcQA84SIYUYIQGOGKuyEKcPo+?=
 =?us-ascii?Q?LzRBV+p66JmLImCHoCtI5KhemGT9e2eBePOA/Q9E9rHsp3J4iu7TE2YLmNWM?=
 =?us-ascii?Q?81iDqLtF6/K5O3ft/KE7TftF0Npzh1ef2lsmrzzkpkgWSB13Pb/v4xOxMNf1?=
 =?us-ascii?Q?NY1wnpSPlvkfABe7CQoIF0OAXcs3Fhz1Rp4dnUZZrXVCsmhzlPx8ShCzxodt?=
 =?us-ascii?Q?HgeqlK5r+5voXj8QOOMz683uOrxPE7vJHyLD40xr7woWD4CTcedqwPwuZKmI?=
 =?us-ascii?Q?lSxctRTy0rS6t368gKNeAo6OX7QFQgj34k/19x3s8B9phW69fwAb0ERT4hwW?=
 =?us-ascii?Q?dzYwgJy+ijs057nPIM4Ys7a9/ib9IKaIbL2pf2QCeoG3TRdQQBQ6cwBxswd7?=
 =?us-ascii?Q?tkh6BROVoZLnj7qXq2WUq+ptFWg53x7CEsVF6h0p7zXWewxmaHnEEdnXxti8?=
 =?us-ascii?Q?C2BJ0eCpEo6J1pDXePwmSrvVN4igcPB7xFT6ltEK4K80mXkda2rsFSm6PesU?=
 =?us-ascii?Q?tOnm0FCDl8zLfg4QCvubKNKZnSw2QTsbI2pR2pwW+26yg0k5FjswOajVHxIP?=
 =?us-ascii?Q?TLA3dgVv5pDgKHX/6QIIrF+l69sitmIrz/jlIJLDckUhplSZzNb0X6dji/3+?=
 =?us-ascii?Q?BEszWyWSvsBMqbi3I1A1jiYwkIVlBKoilrBZrW5TiwqX2Y93/8q32MdwFAM9?=
 =?us-ascii?Q?tQo6QXFAz+9sg49K6lT2wpdskcHkM2XeDhp9F7UE1iRfgprMtnOSfgoqkQ1W?=
 =?us-ascii?Q?NwMPm8uG8BWGgPSxioJCeTTw4dYkLFs72QSDGRiJl2bBlZd/VHSOCVS739ky?=
 =?us-ascii?Q?0GmMInr1KwRAO15tz30iqQeN7Ackvcmv4uRD47MzCvDPhBNhXBZtsLnIvajy?=
 =?us-ascii?Q?z6eBYAD2TmFSeAij2bJRhVL3+Fd9ScehTZI2PLSb52Tl3rAbCB6ZKsLQbm8h?=
 =?us-ascii?Q?kjnbNSwqu3LLLorNG4WoxsfsKX7KiSFbguIK/vXetRZkF27yf2LaRiC9zssL?=
 =?us-ascii?Q?XzoMUfxXJMHTpL9v9un+4NUYZHnR1aVO6KZ9okKJJEBvKJOEOLPpoB5mzk08?=
 =?us-ascii?Q?ZvAO3djvSiVT0MPW5NzXH7jOy7K5Bp5SQJ5mt5F6ehIJ2535rWrZTC995ht2?=
 =?us-ascii?Q?GIC93TOGlK12E5PgA+uDWak7ODxLMbKgpXgrpyi2yKT5UYGYaHra8V8uWN1V?=
 =?us-ascii?Q?ng4zb+UoUqTPUWEUNrXCIlBOb94khC9bhY1PscMj9EaMcxga?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77591959-1b41-44ec-de01-08df1b3f78e4
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 19:59:13.7198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHtI3g5p0GjJL5iyqyEBAajAE0pV+HkEHKZsiQtPpgJg8qIDKvkYVVZV1El9Hf/E+Ni8BGsFB11sfdot/cDHkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685

Replace the local nth_bit() helper with fns(), which provides the same
zero-based set-bit selection for rate capability masks.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 26 +++++---------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index fe7e4f501d6c..4cbc35535e07 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (c) 2017-2026 Morse Micro
  */
+#include <linux/bitops.h>
+
 #include "mmrc.h"
 
 /*
@@ -198,22 +200,6 @@
  */
 static const u32 sym_table[10] = { 24, 36, 48, 72, 96, 144, 192, 216, 256, 288 };
 
-/*
- * Calculate which bit is the nth bit set in an integer based flag.
- */
-static u8 nth_bit(u16 in, u16 index)
-{
-	u32 i;
-	u8 count = 0;
-
-	for (i = 0; count != index + 1; i++) {
-		if (((1u << i) & in) != 0)
-			count++;
-	}
-
-	return i - 1;
-}
-
 /*
  * Calculate the input bit's index among all the set bits in an integer
  * based flag.
@@ -291,19 +277,19 @@ static struct mmrc_rate get_rate_row(struct mmrc_table *tb, u16 index)
 	u16 mcs_index = index / rows;
 	u16 mcs_modulo = index % rows;
 
-	mcs = nth_bit(tb->caps.rates, mcs_index);
+	mcs = fns(tb->caps.rates, mcs_index);
 
 	/* Find our spatial stream */
 	rows = rows / streams;
-	streams = nth_bit(tb->caps.spatial_streams, mcs_modulo / rows);
+	streams = fns(tb->caps.spatial_streams, mcs_modulo / rows);
 
 	/* Find our bandwidth */
 	ss_index = index % rows;
 	rows = rows / bw;
-	bw = nth_bit(tb->caps.bandwidth, ss_index / rows);
+	bw = fns(tb->caps.bandwidth, ss_index / rows);
 
 	/* Find our guard */
-	guard = nth_bit(tb->caps.guard, index % guard);
+	guard = fns(tb->caps.guard, index % guard);
 
 	/* Add range checks to keep scan-build happy */
 	if (bw >= MMRC_BW_MAX)
-- 
2.53.0

