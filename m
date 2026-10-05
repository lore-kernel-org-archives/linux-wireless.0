Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013066.outbound.protection.outlook.com [52.101.83.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E564AD4C7
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211218; cv=fail; b=IUtOp5+SRWVwbCY8SjzhyYjuoturzbzdovwrNhEK1FclUUNvHCSfL+I8dKS+pp+WYziRqDCde2jDXy4rSOIjdT2XWDYZm+GHhapWKbTSYWgLhc/NYXJxC666Q4FTNIu5gt3ykpwGo8w0k17x8Zp5CW/BzPaugGiVqCB4ye/NjGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211218; c=relaxed/simple;
	bh=xmuL29pjQMbi/5WeO2oW0l0AcASaFr6DHfCIjcZJxME=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=sPRfcrF6wwoQ6E/4Rcc7yv76sR+PwqaknI/gyJRjWLIgkj9jJ7YzybqQ40vuq52OJ1YizHkhDkAeTvN/Gm62/WaE68hnZFoXXU7o6TDUJJQeI/ysXOcocGKOGcNIrrS4DMvuIcYw9pIJ17lt87vDPL2MFPuB4h9E5ObO21fAxFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=AQ9gTycP; arc=fail smtp.client-ip=52.101.83.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="AQ9gTycP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGzGqYRNz8A3FJLcTg9ogE2PFYtAMztv+uedOyl7GJ6I+fk1lMjOydaA1J92I3JRhlHxVxaK4r9JDsKjfo1cqhxUOmcWrOYHdRgFiqKsP2zpkHNqKiFNa0fW1Uk3J+XgyP18Ofkx3KcTDP6kCUFuhcOz9xG4akp7MzOh73pLjsS0jqwnRA664aMUnaAY6Pps4oTpQnuhEMNncd6it4u10t0Igac2Od0Qy4jl0fwd5ohCeYCJtc1zI3t6FQVDNuK++dsJdLYzIJ3t/cva2BMZsciUW9UJYpgJTjA0wzFpRJsa6bpMOtBAMAOHwN8HH83bmuSLQF5t88ID/xL8maUxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9d3t53U6wHbdtErsi4mFzv7gEIWfzRWlMhHvGjvOqE=;
 b=YisChNl2IX0vkJFNLlzgwnSnXY39c1OhsT5vjdSFmQda2DONTdtaWhqqpx6jM3Vk0ND13z4G+TRLEW21z0cqd5Tha+yB6VrBkZb/bbwqvrL9sJ1jJscDAKARxMBFB7cr3ibOAHfmAabcukc2OoX7iCIYOC2/3lw8f+0WBIM06SzDriFwGkUKlqbsgMC1/IzNUonmh++KR9d5HSqUW/CAgJ8L877OkVg2i8E6Povbkhz/J+f7qMo6dDFP8IghZ8tmaQN4CVhE+czmZDAx3F6sfg+dFqLGHiGtnO8nW5LuPuLRsqtUwP+Q9jWKRBL+Kd8yTn9JcVTfs8F8+HlWg3FTKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9d3t53U6wHbdtErsi4mFzv7gEIWfzRWlMhHvGjvOqE=;
 b=AQ9gTycPdpuYFs0h6wpRhhHPcV/XY8yG94jZWikuiBQ6VOChxqFR7sxpoIIYr5dmJvKF4eyNDnPYzjnELQEUjZpy3QMltcCxvNi3BAvpR6ngXNmycSrwYSBL0jErbzCqWMm5FHKqi8UYlFdQSvjjt4e9KnUW5sPePSIbgLPDW9V4Kx+ovFv3ikyyyDusX8noZWgOrz+eoRwimKgevUWyWfmj9yXsKDdHSHqg/erKi6e+1CJiCLs37PVOxdWeFdZf+AxxgDos5s8+RW+yNjNdAdaTIghmCOKajdeyi8Xmjj+qNNnou8ugJLSBJLQV+DiBxDjow9RYGPg77/xNKTyulg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by PAXPR04MB8623.eurprd04.prod.outlook.com (2603:10a6:102:21a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 14:40:00 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 14:40:00 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-next-20260929-v3
Date: Mon,  5 Oct 2026 22:39:45 +0800
Message-Id: <20261005143945.2880386-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|PAXPR04MB8623:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbde93f-252c-4c8e-8d31-08df22ee888d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|11063799006|56012099006|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	W/iiFYBBLKevEc7tbQg2EfrIEUgLO91FlvcBHpDBEd49KZRZNtiDnOfHDjtH5/2LDdFvg2GO7o0gftfE9YzwIoPopezRTjJv/YQO7OiRGc/PMFeJ6q0XDtyrrmGyTOzZ04HPnU5Bi8hCrfDibfdprEGsVy677Ur5g1ubtdu5VZM/p8VScQiDcL1N9rYQ/2+8ukcnRBjNJRxuHjHFtZgUnuNpvRF/euwAlrV15YGZdLz4HVP+2yzQY9ucHk9lGu1HtR0SsCeWzR8iD4gFwcgWG87Jl/p8+dDx15YK6nwHmQS3GAWXYngEdC/UK2NlFB1Itkv1sZ87Blrbe6sWTO1UiOW261sCPLue4ijcsRn14/SNY1laGinMfGM3S7OimHAOSIAk4Iz4BQAkbmh6D7iQ97cUvEhUEmZZ/p73ypIKzjZ8hUZ9IRWRPJDmt0opr8Lpl764fbObf2HBS5Ixvv+30TscHkD7a51C//X/qqp0mN1bX3NYcjrecCBRRE0PGddnIDE/Qiog4/GIdHJJpodjgL7Hz2iWD3+4rwzVlJUMwUtRKKjQK/06nrzmFVjyxfS7chbkLHkAFxKmzXvT/BmmWuDO1xxxeEoW/vJamAJ7LSJm+qha+9hlVqEtCND4cSwI2rnPReE43CdahP68f0JWRc0E/YL+Cu0+DNojmKQ8NNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWREY1loZG9ndm9CdkRSZ2hicnpIK3RGOGJjcU1xSnpGSEJYRjl3UUdLMENR?=
 =?utf-8?B?UFR5LzVBd2NIclIwbkJlTjB4Vi82S3Q1UllxL2lycm9ndzJrOWFxN1l0ZEFq?=
 =?utf-8?B?T29XV0laQ2MxNTlIdzVFR1FFUW1OTEpPYlVVQWYwRXA1ODFTRDBTRHZQeWNO?=
 =?utf-8?B?WGplNDg3dGJ2WC9hdmFGNEp4cjg1V21RYzZMajIzbDNSQ1BtRVF6T0ZQVGNk?=
 =?utf-8?B?SnIyb2UxdkZhTzVtanVoTzVHcGtpSnRrVlNWNHVlSWY0OWFGWi9tTDFFMFNr?=
 =?utf-8?B?MFd5UFNaVnBpcGhwZEZHMm5KRmdnWjhaQUNVRG90QXd1bFRSZ1RsZVBOTXRH?=
 =?utf-8?B?emtyWGRPc05abWdFNS8xN1pscXIrZWl5c09QeW54NWUxSjJtZ2VpaGRpVm1N?=
 =?utf-8?B?ZkFEM1NHbFpFbllDcHBuZHdjcU5pVnMxQ3NTOGlkR0s3cC9qZEtSOTRQQVJw?=
 =?utf-8?B?bVhINjNPeCszV2d1Z2F1Rlo3eitRT2t4VTUyc1dqSlJIMVRFWERva09IQlAx?=
 =?utf-8?B?Y2doWE9VWjg2WUZkVDhWRzhLUzJ6MndWbzNWMExobFZhZERZK2o2ajk2ajVN?=
 =?utf-8?B?KzB2Uy9EaXVzZHAyUXdnaWh2ckhQUkRXaVh4N3VBK3JleUVNcDZPMVlYeldr?=
 =?utf-8?B?SUFmcUg1UzZPSndZaFZpWkxDSzBVaURSdjgwNUQ1MEtMY2RxWG5rblNtZFdE?=
 =?utf-8?B?TEd3bmZ6c2hSMStLaWErRUFnV2tMV09jWG5xNGlPQThmanVSZHluVDVaV2Ra?=
 =?utf-8?B?bmE1d0dCMXBJOTFibk9EaFltdHp4ZUlxdzdRSlZCOTEyWXJMVjZpSFRFRkhm?=
 =?utf-8?B?NkZna0xOVldkSkYybmVsb1haeGFjdmtPSjNCdWsvczl2QXFKYXdDUWVzUjUv?=
 =?utf-8?B?VXFKMTVqUzk3ZU1RUkNwYUVraThsUTFRU0wzV2ZjUGNSVGpWdkcrUnd6bWhO?=
 =?utf-8?B?YU45ZkFTM3hZZyt2b1RDc2ViUVRtdlNnZFVaUEhQMXMrT3F5MHZyK0Rtckxy?=
 =?utf-8?B?dGs4aUwwTHlCMk53QzlrMVpLSTJoZmRnR0pPM25JQ1F1WXV6RDNjWjJFRmxX?=
 =?utf-8?B?VGVKL2NySEdIdUgyRFZacUxiVGtUeWsyT291Uld1TmxGRFFJaDJ1UEZheDBu?=
 =?utf-8?B?ZnAySGR4M1hPaGYvUTFKUkRLZ3lKTUswYmZTRjNJSFBlL1N1ekw3Rm56WDZC?=
 =?utf-8?B?SmpqYndSaUZ1K0xDVXh4eHcvYjhwL1NvMVAwUWhsSFpqU2hDbWQ1ay9idVhZ?=
 =?utf-8?B?SUthU0NTRVF5a1A1Q0syYzI4Zzh4TXdtdk5POGJzRDEvZElFOGNjc0N2RVo2?=
 =?utf-8?B?bXBqQlBwREkwbnJ2dUo4R3hTV1JkTGVnU1VWNnJzMjBoWVczQ3JiUHdSRldp?=
 =?utf-8?B?Y0YrZm9iZTY2ekcvUWRiclhJMk5WL29PQ25tNEpTNENKeVRXc2VZRGY1a2RK?=
 =?utf-8?B?TzVJSUdiN0wyaTRFYllMdnora2lWcUNNdGJxTmtaUTk0QzZqSVAyS1lSRmFl?=
 =?utf-8?B?ZERhMUZraThUR2xLRWJ0Wk9jTzQ5NXJCNis3d0VDQkN5Q0NzM2U4Yk5RcHhm?=
 =?utf-8?B?N3BYeW1hOENIWVh2SS9hUmN0NVRBSGJFY0ExYi9oS0kzWTljaUZ1UlVhQ0hz?=
 =?utf-8?B?SEZuVG04VGxVZmtqUlh4cWp4TmttMy9YWDVkS3BuOXN0Y3YxZ2RwVm1ZSTkw?=
 =?utf-8?B?ZXRLbHJWREduM3VrWGRPRWQxVUc4L0VMQVEvREs3RDBGd1FSNVZXWmVoeXMx?=
 =?utf-8?B?M3dmNGFqTXFiMEtrM1VXNXE3WGF2UENnK0JOSTlvS2J0R09MQk8yQUk1RXhN?=
 =?utf-8?B?MkVzTGsxaFkvZDdVT0lRREtQSWtGSGVNZnpZclhQV1FMTDlycnVNTjdhNUUr?=
 =?utf-8?B?Qm5pTG8rakREcW96VXBiMEZRejJEaTNBOHZKUmFWbVJjTEQxbXYvNDBPZ1Zq?=
 =?utf-8?B?aXY1SVBwWTdqMHcwU3M3YTJUdXlkckpHdVEza2pKa1ZNbmZPTWFSbVNLNWU4?=
 =?utf-8?B?dmQ5aCtFRFRKV01vN1I0UWNrYlFvREx4NDRsUkMyTlYzRlpoVFBhNUYzSHFq?=
 =?utf-8?B?cHc3WVRNeDN4RVpYRnVBTWR6SWdDc3VxTTBVSmFtQ1Y3YmN2N0JMeEpYWHRZ?=
 =?utf-8?B?L2t2UmJmMk9QWFJvdmx5eEdmZ3B3RkVaZjVXMkZ2NW81aDcxSVVlVUlXVFBH?=
 =?utf-8?B?ZkNyMkdPQU5VYjExbE4xbW9PcmhZY2MveEhjYzBHK0pUSlhnS1cwVVFwWmNm?=
 =?utf-8?B?b3MzZ01oQnN6STdRekZReDJPZEx5VDk5M0tRWUgyS2YyNHBBRjhVUzk1eUNM?=
 =?utf-8?B?Ukk5aktXdVhnQUo4b3lBZGk0aTRMRnB3dy8zUUNKWHl6YlpnQWpwdjdFVkll?=
 =?utf-8?Q?An+IzUruMY7CxDvwWdnaMmfzhdsMr4DGg77fB?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbde93f-252c-4c8e-8d31-08df22ee888d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 14:39:59.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fd+/ZjPwPHQ1yrhmcZ8pZL4z1NQ9hu1ndX5VgLrJxTjEAd08LNKoNaO6hhDqN3vx3dIAGlvIfnROPOnTXlQ9CWq59tUYiVuI01v19+o8EQ2nMd6fCYxOCtK/JV6HgLQU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8623

Hi Johannes,
 
v3 fixes the commit formatting issue you pointed out.
Please pull the following nxpwifi updates.
 
Thanks,
Jeff

The following changes since commit 21b4248bfa0f410fa22202fc2c82f4808d672cda:

  Merge tag 'ath-next-20260927' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-09-28 11:49:26 +0200)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-next-20260929-v3

for you to fetch changes up to 93a443bb4e91183101f2a5faf826c41293aedcce:

  wifi: nxpwifi: bound debug info output (2026-10-05 21:53:08 +0800)

----------------------------------------------------------------
nxpwifi patches for Linux v7.4 (PR #1)
- Add IW610 SDIO support
- Fix error handling issues
- Add bounds checking for debugfs output
- Validate variable-length IE parsing

----------------------------------------------------------------
Aamir Ahmed (1):
      wifi: nxpwifi: validate variable IE lengths in beacon parser

Heyang Tan (2):
      wifi: nxpwifi: bound histogram debugfs output
      wifi: nxpwifi: bound debug info output

Jeff Chen (6):
      mmc: sdio: add NXP IW610 device ID
      mmc: core: add NXP IW610 base ID and block size quirk
      wifi: nxpwifi: Add support for SDIO-based IW610
      wifi: nxpwifi: Limit channel width based on firmware capability
      wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
      wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()

 drivers/mmc/core/quirks.h                   |  3 ++
 drivers/net/wireless/nxp/nxpwifi/11ax.c     |  2 ++
 drivers/net/wireless/nxp/nxpwifi/11n.c      |  4 ++-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |  6 ++--
 drivers/net/wireless/nxp/nxpwifi/debugfs.c  | 31 ++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/fw.h       |  2 ++
 drivers/net/wireless/nxp/nxpwifi/main.c     | 15 ++++++++--
 drivers/net/wireless/nxp/nxpwifi/scan.c     | 18 ++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.c     | 16 +++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h     |  1 +
 drivers/net/wireless/nxp/nxpwifi/util.c     | 43 +++++++++++++++++------------
 drivers/net/wireless/nxp/nxpwifi/util.h     |  1 +
 include/linux/mmc/sdio_ids.h                |  2 ++
 13 files changed, 105 insertions(+), 39 deletions(-)
