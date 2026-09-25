Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD644604F;
	Fri, 25 Sep 2026 19:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790366371; cv=fail; b=SF2fJMeJ+BKEsn4h0gHKmzFPQ8ay8gSPogbcDjcMxJN+0exkl66dyoy1LvgTMhr3+VPt6sQrYdD/VlC2k49eOOmFRQYc6GPK/Ui2Wd7fQi31NlrsOhLZGq7/6mgBpi2FDeoc4RwBAWQseSf1HONa7ZhtgAJoOKgwPw+UR6znvLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790366371; c=relaxed/simple;
	bh=scdK+6eR0ya8V4tHenV/AWvJtpOAYuXzYG8PtFT/UzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hGvXQZS3WPL5wj08GeqRiL5KS0nwznv0Uy0u2TC9a6wvdjIGgbq9cAc5NGzZCbJGOyluTb+TmAvPCssxqCibDJNj9o1quG5hnkcmYBPOm0dwADGSh1IpLTXHmnNsOEBsZlw+U3KdhktVMcysD7WGog1h888tsgfLXKJnNIEowbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CT7+spXO; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CT7+spXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTbwkyI3rse7SXfUiF92qcmbMkwpdlcKxs5UvjkfIu1PiZBXaysPPyhH2ID9Rrajpi44FHY5ojTS1syw7/jFi/LVtNdcJrRp2hYrrgfHFXRRchlJYZYB1pnX1OYBSXJimBIaWzPaDPh53f/KXRjvdab3kiWNm0dLV1jsIgxctnbFC5SQm7EjKymSnVdudN1cz5uzwzUdFKHwY1u/9bRzWgWOcBXoIOc7dUq7yEMyF0qbOsYtz77R547HSUrP4cgrnlwtR1FVMMQ6whrlUo+tWxWSBxqFd55B+VJqoDv9tT7Ddo4z2hjXxAg54hFs3t1VvRmYhNdGjDVFfRsHe6o/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86tmXW02Fv7S4wHo3ax4tMT2Nbhx7Ifl6yvEYj+Hdv0=;
 b=ptRhMbu4IWgiUj/i1EB5bYv90TR5PnX7oH+6f0VkQH7Dt+q60F4tsdHvTrkQ4TdqUZDBfE9IVYpWY2GPZcaxvKHddOxUIE+oconuJoo5lbdxV56/QEgN7vdpsJ9/0BMSzO/DFhcqmf+Q5/8OActjyTpwJ2/bRzHC8wCoEVoMykmyUHg0sa1bnzOrn00zhpQUyKVrXD14lC5qYE++mZosvpYTXrXnWeE+mQs6DN1EuTjEWRPt4ZsLUQ5fxu3eWg+Y8sosPr7f0odMoO/A97i206SoFfCXfnDmTXpYDNw9BH6ybgF4WByH1gLRk3z+KX0HCQhufZ/ir9MeRn3aaa21Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86tmXW02Fv7S4wHo3ax4tMT2Nbhx7Ifl6yvEYj+Hdv0=;
 b=CT7+spXOIyYRQ7xqsHcUzN/5MrYflCnWm7wexuCitFizVVotWPBqCK8Xg6h6Q96575jUiNRZDObmXTC9L7PTgzumkRqz+pjEnh7ScvIphFiIoioCqkrLGTp2kSxpG5zUQUhPR+wAwdR7XJ+LhYrqpzBKaX13VLR4dCGfQBsT1bFNZ7uNVI5sAXdI/UdZb+6iBkBVBa0ZVyz4xbR1JIeNfGXrw2w4OzYSBfSWCOkuzmJSm35igKzfqbMWLnQjit1ShbwVkGY8/R+kV/3vSkwDSWRhx2w3EjpbruVcA/cuim2lcHY/s6o+kpkBK1HPij0PWA2X1aVtIzXUjSZCikMVKg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 19:59:16 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 19:59:15 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/2] wifi: morsemicro: mm81x: use hweight16() to calculate bit index
Date: Fri, 25 Sep 2026 15:59:08 -0400
Message-ID: <20260925195908.252810-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925195908.252810-1-ynorov@nvidia.com>
References: <20260925195908.252810-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:454::13) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7afc07-2909-4134-ae86-08df1b3f7a30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NZFmcxyHDIGxbOb3ZNZe52J6e2uLonIEfiBydTQUt6oMw9RDC9KL4N+niqCURHj5KI3UAl7qfG0vh+KtroBjdPVnDv1GGLkALrSRUCopq/dAszrKWI+o5//NhuHDzImDkr8NnvsxKHWFMDPXvSaP6SYDyv0WkcN563Ttce1sjgRDipgPRbx2aFwOdq+twU4rrvAGDm/J8OE1IXprQTrYwp0HGWIzBSknZTj44YwiaN0hZ6vTneyqWEL13nW2elQtFfGf7jdTrsaN1krxNujCumcd9z0OfLRj++HhuQZuRn7a5rSbNkLjsIwS/bYd1tRkcyzKWWkjEpR/mlQoZyhs3TWLK4W28cTKdFAbb4lh7pIsdjEjyAkY687ODqJdb04SQItvPoNYvvcFIuKNprnkm8SdPpophWTHHXE9yFbfIUEFJBBiIe49nEBvRJJP9ZZQAq5tKiGp/7E7tN9a8u1DxM2XNC2CXp043L7kgdYqqgBVdqbCRT6WCSmLkz8v/wcPIfBiwnq3k3/1N57a+NIJ7No9eTN9eeA7EAW2nQCyDQkv8IWariVnKtCwdPxQK5cm5jwIUUvL7tthEpVa+DhwhBgDxhjIAHPucnQENaO+NEPnTAHy7VD0Vxkht1IMo+xBH5O5tUkxnq1PaKcRRceWIo5yChVNdqXFVDjPdOKVyZ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GUjUaaqEQSfYRuzsCraCEgMpuBu2ixC6laHf8PW2gjRNJ1jmkPpsXwvpYfTC?=
 =?us-ascii?Q?1mKNbhYnWOH9haJLqiT/yndP5DoBk5Rn8BAcJ+N7Ksluz1Xe5A8NmfNvZssN?=
 =?us-ascii?Q?2Dm89V8uNOy0ZjOIpe4RkAS58JWKBySfE6/FSdFeeHskhgnmUNaVk1y6kiBD?=
 =?us-ascii?Q?FHU8hr30D0SRcLs6knU0KMgxb/WqJ/FUguiY8aIAKGPW+MqjK72Ud1+FsXyC?=
 =?us-ascii?Q?XbBgEVYyN2wwe5gVSaAL9DgevWyZTxOJCvyGxh+IcWn3nm3QWEZHObItjS98?=
 =?us-ascii?Q?8fCRU3s0OF6UAZb8iVos5u58DIoMvMmJoi+8PtHomGVaL8ssiNwlnpPU6oeg?=
 =?us-ascii?Q?VnoArGUc/aS8ZLuU60O0yJVqYzuRJX4GZ/vFfcKgk9SE7hTCy1KRMkxOQVm1?=
 =?us-ascii?Q?p19bG8OjPd1rKlnNcXVky90ekt8vTqoW0uwQSfFMevlwOA4sgwk+AOm4yx8V?=
 =?us-ascii?Q?626uSGxNYie50B8OEHbcunvzpIk1UICPD/ZeHPlWr4tpcJID8A9osjNisFXM?=
 =?us-ascii?Q?B9YzfF1OiUu+IfyNkLR5CIjWsyMvr0EnwqHD+EZgfqYEJODRhqXn4drXtyBs?=
 =?us-ascii?Q?lLuYkD8+SijH23rzzOOCHffMlevdOo1Otnu6/gh7fWEofE/6FfPrWdmLozio?=
 =?us-ascii?Q?ddzCm1GvwR1/sI+Up/MZda5HdcfB9TjZQ148LspYM/i47+BR/9NRwH5I5Grh?=
 =?us-ascii?Q?1rX5baOmg4/3htfvxj8STTzaI5UbdBYbeZLrG0/8Bb7nhRv8QVq+PsGSqLhM?=
 =?us-ascii?Q?aCNoSNzBjdXNw4123EbFK07b5yzUho79cfVMqut1kDeyXAbtSdaNDVD+53dz?=
 =?us-ascii?Q?rrXHtrtzdfr2TNhQ0o/nPFSauPM0mu1LLjyFUBoCYgmQSOPVn3LsyySB11XO?=
 =?us-ascii?Q?m3WTiADAmiBeOKsAnHuWjOrNPslWM6eyPi+E+L4cqMDRDw/jmS8FP1By1KiX?=
 =?us-ascii?Q?FMUcGapsNToRUHy7kFxJZ15xSdfdjZTfja4uhoYNTtdn2DagG8I1dSKr1GfM?=
 =?us-ascii?Q?PqiPsXli32pCgWUQHGGRhd0GB9dL1wJeBvvQVEnyUCbcodex3dtnRb78R8XV?=
 =?us-ascii?Q?SNNgq5R0KiiqUNL0KlCTNZAVqvlHkuoPYsEajcEYrFzBlfwrblK85SPN01PR?=
 =?us-ascii?Q?k7MQ7moLjHS7CsxgUFonS5Oog+GUz7aaOG1tB3axbiatPgTG1mu7a0J5q8sU?=
 =?us-ascii?Q?NSas2XOeIEc3h06dK71YAbP22dhWibIjv4IIRD4gDBrvff71SIDxiIIPWTdZ?=
 =?us-ascii?Q?hj8/7pJY+O5ZTvWdlg1edcxG82o/mjTFCmJQny626DDhOENj8+mgk3ZvD78G?=
 =?us-ascii?Q?Kldg0nf+8dkYiZMs60saQDbqd7CYSys8M/RAbslC7vBljiezvvJHqSDIP8M3?=
 =?us-ascii?Q?c1ZxkXVN3I9ygEU74JGkHiG0UbUsUXF0SfvNrmMAnvOCEs9Ed7aNPFo2ABBY?=
 =?us-ascii?Q?inkXSRfon9+7I2mwEVa8rqM23H1isHIO5RSC/sa1cKcAg1jgUeOHVeoWsZFv?=
 =?us-ascii?Q?9ApUePdYvHLwmrAx+7HLMBNXN/3AL0+V1h4WkU/oj8vaeKNybN/inlfmLHo9?=
 =?us-ascii?Q?4hChSdiglRkgJRbl0ItsRvU72D06XJrd4+tEXNIFSX0GkS6CSZPBoGQnCN7W?=
 =?us-ascii?Q?7qNEpTeZbzfQWlhPJGfUZk4qoUWQaV1pQkgeMVBlRWNsr2O7jOfgTm3aUvqU?=
 =?us-ascii?Q?wRDlACTTJYvN07B/QgulxleICBdJ1vDLe5Mg78S3ZVpXfe1o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7afc07-2909-4134-ae86-08df1b3f7a30
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 19:59:15.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1naQsG1phAt5I5KcSEufIhbmgDqIKJrOjq2ehK3u/EELTBA073zmcMqKXokq9LrdpXCFnJXj6DQSo/BCc8PUDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685

Count the set bits through bit_pos with hweight16() and an inclusive
mask. Preserve the zero fallback and zero-based index.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index 4cbc35535e07..6bedcdbcb61f 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -206,13 +206,7 @@ static const u32 sym_table[10] = { 24, 36, 48, 72, 96, 144, 192, 216, 256, 288 }
  */
 static u16 bit_index(u16 in, u32 bit_pos)
 {
-	u16 i;
-	u16 index = 0;
-
-	for (i = 0; i != bit_pos + 1; i++) {
-		if (((1u << i) & in) != 0)
-			index++;
-	}
+	u16 index = hweight16(in & GENMASK(bit_pos, 0));
 
 	if (index == 0) {
 		/* Could not match bit pos to caps */
-- 
2.53.0

