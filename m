Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010015.outbound.protection.outlook.com [52.101.84.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB04F4D5990
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791969108; cv=fail; b=Fazmw0Hwa7br87X9NksCeWiK4yzDypAV+yl1EW84mD2uC3JanZ7YF5pH6qmdHFI6UMeJf2sslekqiYJzXJ4j7/I4VEUEHsgxy7l+KbXPepR9zPKozdbytKe6LHvnt+rcJ8kWCEFDHzcUNEjOCzwHRVh/H6IzM7dxVBlMKOROVgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791969108; c=relaxed/simple;
	bh=tooaUmIGT1OyrgqmwCjlGlkS1qvoacl4UullOXFwyo8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=GoR/9N4xrYlac2eppsaI7hYjrEPr+OhDGP1DpuPgBFACuCxma9ApuMHs1+3UBl1JwxnFZyEHP4odZelMokd3tz4MBxOVdOqWcnW78cMDD4AiSKfoguhjoVewesavWtNs4GmMO+4MGnuTne7x0IJvmue6lL7erfWOVAB7Dw52oVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=RHqSUdpa; arc=fail smtp.client-ip=52.101.84.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RHqSUdpa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wPG3NfMgznpJ2DRtPXA/RI08bRGa9AZeSk4r4Q3QmcExfHOEme3E2qYe+xdaaYLO5tVHJiHzKkdkDsygYQDkg5luSc/Lq4YwZBUmJiSEZvbr3KsaSjiBbYhfmDJy4WJMfxJ7EwHK6tb5T62hQNCaTZUryLqHi8Q76yEwmxlxjmZ6kXoO9/SMwHph7qcCkT4Bm4p4KIF0OPz5tHoa4O7cqpznH38NusR42fEBDYIHWT7oELkj4GFENDU/P3du+xkexdAhaNcn5wEVi1nA+XHdw3Zy9pL7I2KOlqi15vPs1kDEve4Shb2jGs4bBYCyiNkkxKZuj7kxdF3BTViF5sWR9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKd9IWtoYYSgB0GIAZHobJ1hl+A3DuzdfxcCBf5GsNM=;
 b=VduCGXAipVjLmu4MCmERH8LTFJuGNRG4YiKXXJ08HBSR5ns7EZuHBU05sgCm0XXqNR+zEHRSz//12LM3/j9HStUAFonJrf50XykPsEYTS3tp3Hihe2kJP0cErrjk5rGiNJve+oREULMzWLCSnI6Uj9M+X+bwsVof2foePbw77nhTds6TtoYNSXJtcDIUxvyp8fat1zhQcRXbrWz3icqr0ljWyvsw7JCnbM3DPuSozaJixOql2UbJMVr4DnRZbhHLNW5N/9O1RFaDvlb+4UsP3q7HAEquYYBvT57zkpKbtSIVyFKi8R2NNHoRw5pTbv7GCc9TrPd74Bh3bqyqi5uwrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKd9IWtoYYSgB0GIAZHobJ1hl+A3DuzdfxcCBf5GsNM=;
 b=RHqSUdpaJl71fWqzKcy3/G53fUmAJocHDebvTzo1IpXKdL/JD2L8zW3y0BWp6r8s6ER3Sk+Ral+zioDwQrZ453Fm4WNKFQLHxEZrq1wEYzkhUqvyhh6aSr/2Ysohudkgzyc3bKpHXcSYeRMHllusm3BaPXXqi081bH9kno2gvEUBABEs3PEC3hhXNFnyzMHuPSpUb5AhnGNrhJbmo8RhicYp1acUtE6uUQ76WsML+cykYj5WhN5ccHP8PtUY/rLtZFLp5iYx5t9ehso/cNfv0q/yqSqMVi/ZFJcjC6dSriAO0BGhNryNqCvX7H3PXLbkfYCZAEQrg1i4cnQ4+pdiPQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by GV2PR04MB11328.eurprd04.prod.outlook.com (2603:10a6:150:2a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 09:11:39 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 09:11:39 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-next-20261014
Date: Wed, 14 Oct 2026 17:11:01 +0800
Message-Id: <20261014091101.3496150-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::19) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|GV2PR04MB11328:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c648647-2569-4771-41c9-08df29d3279e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|376014|1800799024|366016|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	C9XI3j90qfR0SIQLgO6cupiVCIFINqUGrpRO0vlnhVKhVHE7Kns7ciL3x2h55y1k56tBBopsl5zSm8mhWVPobXJzbduPMdmcIxXrA9ahBU8Fxz5iR/j5iSycTwmBC9yaK2HOxSPYvOPWHPzqOuHYQMdqG8YVNVDdjJ7Zuhg4ARo5OGIPD29KxTi59/XVben0+tMTEObpmAYX/nG+Hzh6CXvl09xmMROC6jFaAtR6kSh+fwVc2Tv28YUHNSfSZEnNq6h4mNosNhen6ldE8j86kRg0/KxsAvULCW13oc7+JzdYz2Tx1QBhe4a1B2bEEGkAib7F4IHLcx+wp8Z9RF/Vne/8qrx4FND11KPAaXeRMlq/YK+nijRDjHTo8ZfNJCcvs4ursge0Mr+lS6tzCoOuKWKJA/ulNc7qiRx6I7A3J40Lpx0NqiHZcyf8MLasBi+vFimpYLRMKaYdLYvehYG0ZkcmPCFRwEWPjIG4ZBDy1bAcgUq3lFYH7eHUVBOZKgWR6D6HjmPlqjXYUTCNEzCUYUQ+VGUd4WxOLuBo1XiI3sXYm6IbRLoUU0FebPCoPQ9NbZUAlQEyhT+aV0jdIrQ17xm8dfJhwwBVubTQTS6mPmKN5gWyPejpybL4HfT04LpddcNplFeQtKyQJLwibkgNbvzQNkcbq+eWyYp8qEuCJ2E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(376014)(1800799024)(366016)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3l0WwDU2v8dzMtNaRbS1FGqrcPBj8idBrnoIn7mjDwY7YF3/dQsNalKw4+T/?=
 =?us-ascii?Q?gFV23PMwfLazutKbusHPSfdx8zETgFjWjNz6viV0Fvl2vi5L45L9YcMlQEJq?=
 =?us-ascii?Q?EQP5KDAwvF0rxA+HAiVEmQPYZkMMjrAp4WFHvwkyjQ6c/YLy1A7zoSEjIwpl?=
 =?us-ascii?Q?yrt3tTZN//a+0Nc7gJvT6da9B/hkrHgWeRq0FeDDK87Ei/CR8sLdJiOl6tzH?=
 =?us-ascii?Q?AacOh3w7sHTNvS2QQprtCfMyV4kMGuJMN6k/+IybTtwjN5I41kooG5id2M0K?=
 =?us-ascii?Q?o+pX9SKTVpCmvZE1R7tPINJsIGLpAwiJZHsVuo7R8LX5EL1uTaVY7+/J5MbO?=
 =?us-ascii?Q?JmD4VIma+IkRUVRD7XcxuxOyBN+au8P7KP2Xu6DYpfKdM3XOBdQxr1ybDX+l?=
 =?us-ascii?Q?RNJiMNwqO0YMFXTM5QZjkRFS6GoKmy65Q3R6y36KhKmrsUNkYw7PEbKtV1EF?=
 =?us-ascii?Q?MeIjKW41X0JP62lBCXh9PFXPB92gr2hIfknkYBnCt7yJ9n0HgkchLuSc9wC8?=
 =?us-ascii?Q?XLgrpuphqD8G5G4v2FlEqbxSEYqkQUzCimOnyUZtRostFWJzKUxXAKDA9zav?=
 =?us-ascii?Q?gSNUpLxBgmmJWLQDX9nYMSLGgNrZrP0nbUZAdd+zbooo3sQcxaSSUR5kDOGk?=
 =?us-ascii?Q?PG6EMj3jM/L+Ag72pOKM3HZ4I0oBepbi1Y2agpCKULWJknrEEcezLCTDEMnn?=
 =?us-ascii?Q?1jVtVo+yem5B9wnBSs/yP8i+uPhD+6R4yTJp8peKNrsOZfefEESzelziZ5Uj?=
 =?us-ascii?Q?PQRiFqyQNYV1BbfJmDgu8hGxIK8fm5EUCsErPJJ3uHrZ7aVqGmwwfXHBsyaS?=
 =?us-ascii?Q?mC3ipG95GbvM4YT3D+OmXrX7FcIDvM1cpQRL4KeMcIeVwTxgecWBihYuovkK?=
 =?us-ascii?Q?t3YOxh3SeEFLE7r7jvnGDHvjgyQbdDoS9x/EX4dSwKd9MIR72l/HCx2uyYCW?=
 =?us-ascii?Q?rWHkhXMntPD/sCUAWlBjfZ7SZPUsXsjj6KRhE9chGT3CwLTLudmaY9kurYcJ?=
 =?us-ascii?Q?PSI/8YAG/SR0EQoP4wmhGB2LJOntdej+w9hxyniMPnLOWJ1ilR36ExDuTOej?=
 =?us-ascii?Q?WAs6CHHe7PvT4tJI0/sVMKdXqLr/IGkNTRvEq8TsKpYWsl6GFjv4Hq6psAIb?=
 =?us-ascii?Q?6RK0e+u4Ro4xTXcpxuU3yE0eyv2K5PkC2aqHY1PPIWYnKvp7Sb0MoopeYueX?=
 =?us-ascii?Q?kyQ2ZevKzh9Vcy+GwlDiWZE5r+L+JQ8w8MdNV7+G3mL8nyVIUoEIwDQGuGZl?=
 =?us-ascii?Q?TF+usSiYakiJLKYORDU8sjPJo844VuvuY9ie649Y03Hs77Serp2nhgY2m0zi?=
 =?us-ascii?Q?PFSgb6U3xOQNHo6MF6YdaFUJyTblIjhew9QhRxMfrCEeelEYOCcxEi+Diljs?=
 =?us-ascii?Q?FpsCsBz2es5LjRT26Oj7FQy5MmOx4eXgxwYM/zRD0/LiCm113OvGZSEVt9ab?=
 =?us-ascii?Q?yBDAtWpPpzZt2wMrEUnSlcNLfqV0FwhBvqw9KL3LjA+Qd2CuM558UHYFP3mF?=
 =?us-ascii?Q?5hCMkEWOSvQLQr9XIisyGMnxeLRRROAM/ALkQAyPqCf2S+sN90mrHI/AL8+T?=
 =?us-ascii?Q?qld0+JFaYVmUfmkHqYGfwUrCbIYlhTQg//5I7FgOQfJyez6JCECjJaP5jASV?=
 =?us-ascii?Q?M1k+VdXErUCB4L+iTHJI5G6XGmx5DRQw2tc03p8d56Hb0L6CfnPYQOBRHm5j?=
 =?us-ascii?Q?h716TFcFEBEwWVQZ7PyM3VLo8sK4QcSFu0X+hqJZAllnTxuH6zCOhDKeLGQK?=
 =?us-ascii?Q?8p2CfnzIvZyfmuBoIHpBDm8bhPk0aFPencQ64AR7rAjUgPZ24b2B?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c648647-2569-4771-41c9-08df29d3279e
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 09:11:39.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQa8D9T0GK6QbXtPaJkG1guA7Qui2RMjBFS4rjeWG5dwTwl1yWBDqt9dIQE0HieBDFg48qvjtSCLmLJrpp6GC0HCr6e/F+tGFB91TkMUY/EiuXqnrUs6oumLA9tpaLNd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11328

Hi Johannes,

Please pull the following nxpwifi updates.

Thanks,
Jeff

The following changes since commit cd026e68fdbf88b9cc522b76c7a9d92c9a41f709:

  Merge tag 'ath-next-20261012' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-10-13 14:03:49 +0200)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-next-20261014

for you to fetch changes up to 12af2f77de337d353aa5c5d8b063e0d7648fe070:

  wifi: nxpwifi: use str_on_off() for carrier state (2026-10-14 14:36:46 +0800)

----------------------------------------------------------------
nxpwifi updates for Linux v7.4 (PR #2)

- Fix timeout handling in nxpwifi_sdio_poll_card_status()
- Use str_on_off() helper for carrier state reporting

----------------------------------------------------------------
Aryan Sinha (1):
      wifi: nxpwifi: use str_on_off() for carrier state

Karl Mehltretter (1):
      wifi: nxpwifi: return timeout error from nxpwifi_sdio_poll_card_status()

 drivers/net/wireless/nxp/nxpwifi/debugfs.c | 5 +++--
 drivers/net/wireless/nxp/nxpwifi/main.c    | 5 +++--
 drivers/net/wireless/nxp/nxpwifi/sdio.c    | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)
