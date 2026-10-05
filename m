Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010006.outbound.protection.outlook.com [52.101.84.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83631B130
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179079; cv=fail; b=JF3wyNyuw44LUbjmpdFKOS5I3NycJlB4Wl0EwDZX4G7H8f55Qd9ZrVjyR1UVNhzjijgLVrMzXXMaXkoeMBkGNmhlGx0Aq7+hQbHyKGH1/RAkpXAyP7Qi93t1nqHMjMh79TcLBUCOJg1NnnMW517EMeWRSWbYVjB5ii4RiFcoj2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179079; c=relaxed/simple;
	bh=xp3frIbr0wPZT/z7WosSSJfOpGUhPmExNnZTjkz7Nf4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WBDgaSrAm6Vjo4W2c4xFD95UFARTPxKMyNanhdTUMZfsVZTGiBu8kVnvXiUWSvQjiUEKwsNtPw1KqXiwOftSfOd+b6obe772VL+dC+kwX/gs25w4gYLQ6rn2GehhE2uqvzyScPHCRIs0bcFpzsVF3tdiKTPj3m1dfwW8Usv+Z0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=QH4LKov2; arc=fail smtp.client-ip=52.101.84.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QH4LKov2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O5sbDQ8zhLe//pO1yfl6DO1WjGgbddyNx6FrF+4rKpQLtFAkFPb43IdT5oSNKwCIjiI5dyFUgeLzPdklRAefh0fBT3yr8/k3eykNT6Yg4WqpHFrq8fTYUzZrkfNWf30PGQAKObhhvNa2t/KD0Gqsqvq+rJRbArXw7O/HRPpfbPQ/dxpG582l4PmEOlkdDhgtUraY1YVPUiOo/NCo8NJN23kuANQFIgpTnZq/3mhpFDH8dFQfDreTnU/GCIyjBLgWH3PzYVNYbats5hZjdS5fRHvfeykDz8XefAJgEsEODPZyecQXge+Yke4d83FVgPHh6oWzsgIVG+9aRzdUZFnb/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrerwvpMSawdmpOIgblGELnQVNwSmgyavpp1hfqkuL0=;
 b=s6vYTEbaD4UF7SdHjzQ1qBaSJrl8/57qF0urPynpoy/Qv/58gWFYWlI4v+dG1It8oMZB/d+NKDek7WOyw9MTqhbLxx+JWE6XtlRY7iy0EamHGt7ISTGnZhH0QUAPm6cyOLlM7RIKrZqtd/u2dX05kQ7n14m4IZwRFcz4Vg6cbTtDipiVuLYEYNPTPwmgex83OWwh+X+XbvBcUHJK/g1CqMZi8BiYnwXMbu5blythGIp7Ww7aoIjvmW5kUeYIpUf/11b+hCnQyzfITOa2tb9HdI1WpP7cpTtgoPSV+gnb0KNeNEnooToVot7A4WXAZRqG9RfTSFGioNwjukKhswyTPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrerwvpMSawdmpOIgblGELnQVNwSmgyavpp1hfqkuL0=;
 b=QH4LKov25ShUHQLot1GxJS6w+gyQDv9Bk04SjNKsptqVQbtPn8yg7gI7PKV91wTYsm93pb9GrCtF9qPW5fQqn8zlr2rOxdgZ0iPDFAAQgv/DSqN/F1wuA0N8hVzdfLTUCCZPf48m4nZxJJhQZ6UoXuCrNfJ98IwuNKunDjV17EfQTMv2ir44mmwxi/jWMnXzzlUEeSPcD/vK06/FyFW8GAcEdu/MwAxZZ9NTcQgsl3qLROMUMBSLr/U8IeDOYs0fr2aD0Pzi7sAI5E26vELL3eNxIGE1dSWrYi6k7pHL0trSqDo3aGLc0OIycHTojzUvMPMOdemZMLBKpFBVbed0WA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by OSMPR04MB11293.eurprd04.prod.outlook.com (2603:10a6:e10:93::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 05:44:34 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 05:44:34 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v3 0/3] wifi: nxpwifi: add TX power limit configuration support 
Date: Mon,  5 Oct 2026 13:44:11 +0800
Message-Id: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::7) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|OSMPR04MB11293:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0f0cf0-ad27-4223-64c0-08df22a3bc5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|6133799003|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	LiCOLKOce2pWGveANz27Xb0dY/wHA0I48zzLK17j/7D1p17siHFAzdACAvpuhm36bgIj64PAROg89epc79bBjODP8IJ7zyZotb4jRjLKdQxnaRipsOvUgG3GD6a7qScqP/RLqkriCf7Gjf6QH+VMV0Htmu7ztau7AjFjbW0UVPfgz3fKA3M5TkLUt80JfV6QC7gPKtvSNIa3zisQVj9xFfdRj6LJEbl4TLDp2jusFaqfgn8414CKtG8o2Q6ZNGknNWb4dDrARkHHImgSZ4D/iAZ/l/yBRmA/GysXQ9WkhsonKZF1AD91O/iyd7k6fkUv3PHGbD3Guj/FbQWQm0Z/LJoAOo4wQ1rLWXzwhB4ZCxqKS/w3ooQfmoX1zYuo5dnmUKD2u/SxP6NKYpvqZQpDqpQACEkPcMg14YqUHCIliceUWT5GbN2R2G3PFeDU+21gXvKy2muoWs/L1peenGSmX8eDocM7Kc9YDUczA6fDtgBOwmJu1yaUc8AKVJw/It8Eaiq2Asm05KvFLXkRjgabw52MOMYYdakIb0hMXS2hskp4MUS4y6MC0RX4s0HokPSH5qRKr/qXc4TMriiKQY6Xo4wiwmtapRr3PJx4doJqc+Iasi+5DV89s91U4i8bvX8bG1+3tOYHgJj0zoK93Rg79byS8Ubn6isCx05jGdmxjN8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(6133799003)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rYljl9H0wRHEhd7c34FUfKe4W5nQTX4vsDhhdNW+UB8Lu4rvs5jkymWiIQ9+?=
 =?us-ascii?Q?XcLApVIS3iBWMRmw4gNc/ZwE5qoAcDfA4Fzv4LMSb+p0LHYG8+Gy+ARKpbXY?=
 =?us-ascii?Q?9Ntc7yauJck7IF2/IfNYJg7vJyPQUBDMaqg+vqUAFGIrpUElNqna5uEn57Ef?=
 =?us-ascii?Q?UhRetHDGt5jQqdbiVmZVGqvgqc8ihIOActvnWvficbEnrhAiJ/fuNa1n0epF?=
 =?us-ascii?Q?7ZtfKDYnFTaZef5s8Of9KQqiYBVrI+7hN3P3W5/5W21+g2M4GgS42kZIQ/5I?=
 =?us-ascii?Q?5k9e7BQ/ADFgONr6vOhw0GPTVCvw1rRCG3GtOItZjvF3bnsXKdLsfO41e/XT?=
 =?us-ascii?Q?9o/xlvxgvPThEEV2Vvkg6E5DZOXaCraBS54mzLRIGqoTb6fBmjqgDg2H9v8n?=
 =?us-ascii?Q?J+KMT6ZbpVIVaOoMuJ9IxFBiBunreMoMW9uqBrQxBZhqsvULCh3GTygb8Wgk?=
 =?us-ascii?Q?+7ilqzsuiB0mKrm4Q0szpJhbFyUbkq7Rhy3hNqbdQDrlP54YhT4e12HApvnR?=
 =?us-ascii?Q?nb/MH/q4ux3o0fKWQn30dBmv3R1GO/DiNt623O3eLgYyNsYH6u1PUBgMpuH2?=
 =?us-ascii?Q?MH58ULLksAx5FMJ8RrvMu4kDl/ofyZwuqGcnHkbrM6nMyT6Uzjx18d/ZNVHv?=
 =?us-ascii?Q?KYfIaOayxhoPqNtJtGfKt6mSfkOTtofszVx/OhHBG5A25TDokiSvzxuZp8QH?=
 =?us-ascii?Q?aEKuuoVdbaS2iTEB1My2rholTVQY2VqfBtQDV3E6+pBhlZGIU9Z+8QX9pngW?=
 =?us-ascii?Q?zdLy92J3AUN3B8RUWNuL5uUe56gIt5eioSyuFFEQ+dkCKSZZ9VWXxkCqMDRr?=
 =?us-ascii?Q?1/ruwqHqCFR5s5hX8ZrE5ir5F5OWeQxumU6SRROS00LXzcJ9tJdqsyKItOVC?=
 =?us-ascii?Q?Lty6ZzZaCqGP6+1hICaCwe+hWAWfhSOTCrbdUBvnrZQ0ifJtovIvIOGViX6K?=
 =?us-ascii?Q?SNmLuSql6ObhIAYN7kmaMNRadXU6ouxRsLDQyXcDqHtm4u+ZuXJwcfqdTvuz?=
 =?us-ascii?Q?c1qITwkJO7BXjo+Uvgpi746PYcdX0D9yjlMfqpR9i7Mihpa41VtnKztFqAkF?=
 =?us-ascii?Q?ppsYtHapQkJCWGfEbLx1DPWK/Kvq2yuOcZ3GNDtjBb1hW+FqZxZT6cdGPS2I?=
 =?us-ascii?Q?izCD5UW5cISSX17GvXx3i0HcnJAOqW/FD5NmIsoNqqq0TrZTL/cCWBihMn0Z?=
 =?us-ascii?Q?AuruLhB8HV0DcDlNJIu4vGdrxNLmirwjD73IjOpi2eWLXQgFsMQCFcrhF1sQ?=
 =?us-ascii?Q?xoRDAlAHoLjL+cn7YCQXw6jrWTcoxYq617pt49U3xTwUn4ZC8w2PlyiXXTBq?=
 =?us-ascii?Q?ZCLZGO5M64f/8PdkfVV6baw5+bcyQusb8VdefKc8Rs8kn485/h5Cseq/F8Rz?=
 =?us-ascii?Q?YSnuYWgn5LrZk3+kKCzP+8h2trsmYXfcr7IiWrU+ymNjlQLz19oQYGtZMBVS?=
 =?us-ascii?Q?v3b/UnviwAQK3H1G5KNZnwDWn1CchpSEmQPtFi1buJ05oYeB7Q4VfxlYn5+A?=
 =?us-ascii?Q?QnNFexDrMUvRUjxZvI9dEe+Ek1J5wohXfM+fOSdw/PttCKJaY4y75iBCsoqG?=
 =?us-ascii?Q?BiLAo5hRY15wb3JwvaBP/7AIT4Gp92U133zpY9SW/YwduoS0du57lnru9aIZ?=
 =?us-ascii?Q?SoehKx820JwOr8dG6f+emRlMqKmKhqqkm0HAmWLH6tAwc2tcuNezUaUURM4K?=
 =?us-ascii?Q?LzfXz/R48vC+pCMrmGWyR9uEBDtGWaBPlzk17z4vKDx3v4CS1vS5RYQFRlzy?=
 =?us-ascii?Q?pPxJjfE7eH1LBjdWK3D6u4plbb8TBcVGMuwRFoWy31o4dcam1Axj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0f0cf0-ad27-4223-64c0-08df22a3bc5d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 05:44:34.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoqYBpvRHyzMZEADFDAtUhvHioRyALor+t2rqSlbdM5BAx7U4fw5vPoXPiIAyDk7PktBMIU6tkoR25b1iSMFn9uyHxSk1rFxAOIIGuCrI8JJkmrOqGcyxTZJ30xaPyzb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSMPR04MB11293

From: Jeff Chen <jeff.chen_1@nxp.com>

This series adds support for accessing firmware Transmit Rate-based
Power Control (TRPC) configuration through an NL80211 vendor command.

Patch 1 adds common NXP vendor command definitions in a UAPI header.

Patch 2 adds support for the firmware TRPC command used to retrieve and
update TX power limit data.

Patch 3 exposes the TRPC configuration interface to userspace through
NL80211_CMD_VENDOR.

Changes in v3:
- Fix kernel-doc warnings.
- Rename txpwr symbols to txpwrlimit for consistency.

Changes in v2:
- Add a common UAPI header for NXP vendor command definitions.
- Move vendor command definitions from the driver to the UAPI header.
- Address review comments.

Jeff Chen (3):
  wifi: nl80211: vendor-cmd: add NXP vendor command definitions
  wifi: nxpwifi: add firmware TRPC command support
  wifi: nxpwifi: add netlink vendor command for TX power limits

 drivers/net/wireless/nxp/nxpwifi/Makefile   |   1 +
 drivers/net/wireless/nxp/nxpwifi/cfg.h      |  11 ++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |   5 +-
 drivers/net/wireless/nxp/nxpwifi/fw.h       |   8 ++
 drivers/net/wireless/nxp/nxpwifi/main.h     |   3 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c  |   8 ++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c  |  67 +++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.c   | 152 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.h   |  14 ++
 include/uapi/linux/nl80211-vnd-nxp.h        |  81 +++++++++++
 10 files changed, 349 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.h
 create mode 100644 include/uapi/linux/nl80211-vnd-nxp.h


base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
-- 
2.34.1

