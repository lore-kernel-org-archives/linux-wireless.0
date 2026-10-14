Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012052.outbound.protection.outlook.com [52.101.66.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA93B2FD1
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791958237; cv=fail; b=nzkkIjI0tmmWrErxqejWvo36vwi/PFzTU9iyQ6XWNQwPCiH9w7gZAEw91fx3gWhau9QqqVFYUvQenqqwKNZZs9l4v8YrDpSbQhCnckmuz+syAvCPTB0DSKCcyQjpKv3JinP1gmX6ZthY4IpC+NP3VLXyumg2ff7wySn8p0kqvHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791958237; c=relaxed/simple;
	bh=Gse9fEfloNyykDb7TaB+FWWg60FwasYvtH93EKffHV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qDAc6HZCt836SEHTMjjKdI3ikTgV8vRopdNha3qVcfU2VecCY60fTvghAYj12bBxfBI1fNjkhJUunK/dRy+liFWofFqv6KQGJKPlj5jcUwmQ7vSUSBCxr4F+ffU8sf2IVxlW4YDvQshfFi/8l24a4TMmubxLcrqETYoHJmsy2Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=LFfyBBkt; arc=fail smtp.client-ip=52.101.66.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LFfyBBkt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAAjdLiiApEZJQ+a3FpFXqokF6FlqUJxa+Ix1ru4S/7Nege4n0TiKYodlczPBqOTIscyofmEHfmETuM1pYa95nFN3djTeXE7G5+dd+TDXAMyM6JiQLRZh5kqUpuVuswbaAsVYAZd9EK0W5IeirVSMXRI7oR3kratGAn4KAIZMabCPIbQdL3mVWz8wAUQkgoAh12NzrsznJLWvOjnWGpkSSvqeawG5is6rzfsj6yHqrkALGq1IE6Q+kHThV6/ZBLzm24paprN+N0wbdSD2yr7dOZtJCfkEUjbVeE3NT2mItFjcCX0oKa2wlYjKThUWy4l7JdcNEH7YP9FbNhhAR7jUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoKtpAVMnJDbSggFW3MkEABQZoU00QQe7QUmCln4Y84=;
 b=AGQ2KbBaqpuITdzo4jSEwfmiM12kBxVe9WCKnlWow7GmL5C2z/n9O+XBszSKFWkZLm+gBx/En30R1yUnE70HKvF2L0EB7nCUP/Xd3Shmvic4aZYogcgLUSLUxFw0aUDSxaC1AFXvvl0xqIOh7ziQL9OrXWnnRIuNDKDrhbhI18tJx22VKAdtcTFLdtVQp1WAXA+hgSujziadAFQ0+cQoHo+8qMcpnL5jMMnvkXeNxlpAddGHMD5fNS4BjR/XiHIwHOYuf8SbinwHXB3C3qlDjevXA+k4GuC3xg//ZhaD5gxk0H2bdXL3w3tbeVPJloHYfTbe5Z0PuLI0g0CoFfz6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoKtpAVMnJDbSggFW3MkEABQZoU00QQe7QUmCln4Y84=;
 b=LFfyBBkto0AWKhvMBWsA3+/d+MtUBvO2VRzIZb6B9DG5lthiXBaFOXXjT94Ww/WLZBOEhQ1un81QkObBcJUjAM+qQUHt/Z4lY41Xgr660uHSC1+K8I61WFDDmBCoyoESattdbdZX87s3xrxzhAAah+KqQqdPcbXb5O6xQKPbNCODnmrVS3YPbjgJEoIpC2nmkdW0w6DYvdGolck9Q2CYayAJB6qcOgbNPHIzkHuJFwYHu1TBV0nrM9zKX48K3vaj/JUxUhinAlMlIK9oHmoNAzaIG83cjt4a/JXfD6B6VZNdZ60uH18y3QAkf685UQUFEadJpwBps/UKSte5KOLSBg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by VE1PR04MB7293.eurprd04.prod.outlook.com (2603:10a6:800:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 06:10:32 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 06:10:32 +0000
From: jeff.chen_1@oss.nxp.com
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: nxpwifi: fail the firmware download on a poll timeout
Date: Wed, 14 Oct 2026 14:09:43 +0800
Message-Id: <20261014060943.3492064-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <asw9+ftcdKi10UUU@nxpwireless-Inspiron-14-Plus-7440>
References: <20261003192256.78255-1-kmehltretter@gmail.com> <asw9+ftcdKi10UUU@nxpwireless-Inspiron-14-Plus-7440>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::16) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|VE1PR04MB7293:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bea013b-0181-4ad9-c812-08df29b9da43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|1800799024|366016|376014|10067099003|22082099003|18002099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WnVLah5NjBDTIBRyzxC+1dIKuBnM22WtLiXKrcIQZimYuq3rq0lJkXXMpZ8uyWyCcrxllsOKuYXeEo8JbvEnIk6BaFOiiLg18tZCjQRmep9RROiXB/0bJT3h+tMmD8AMpZoqpPITlbIGUYe30ntRZAz5IZMJg2njbMeY2aG7BDIIxOLe8XpWutWUweJig2jk1pGzKWdFC0Ar+II2jW+lWS0xCnUzA8IjJeEh3oml6BOGYusA0QlzT3fz5bny96W8sp0McGaFNrO7blslI/EWn8Lntyn1rVQpjtyMEaazruenDNLpACWJj5oHBtDXy46fwC1N0B0pnIFNvfVaZJ/srSFSrAiGeX1g8PHbW7oJ49hpf6+E5qZQ098w5XTEu4t2W+hWXK+ExCIBmkoTLE5AXmNn4mySQkZfk0oBgKkla3kA+KEmXeIUabV9l7Of/sAij3w5YgH+LASweaF5+umXJAo8HuknGO/7HS0alRBsjtVTocoItvE4v/q964XMqLSGERE6oespd/ptTr+2SzvAZLcdu4PQxcm/esut9AbldK5jvr7XFZcatkn+v62NJ2aNgZhrFNdXI0LhJ62cqzgbaxMhv54Ez1B/mGfofBzPCrjkqFPAj0UvSjQ2tSDoid0ene4OYVqggPPqwN2uIdMg1Fw+oDFKGlA6FoD6g7w+qq0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(366016)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VY2+GpGtkgXpPj5K5wc6LPpbYhte1sy81fypOPj33s6cdF6UmlH6KsAcM4mV?=
 =?us-ascii?Q?6lyw8+t7tfEKRRqcYyJnrHhJQ7P6zLu23CYxZsKH1aySArUTByPVFyfEiIzx?=
 =?us-ascii?Q?LQMZvTbxO9FzubP5pvrUKPE0UmKUp4KbPfHZca0J2dZcIaJNpPlRL6HabM+5?=
 =?us-ascii?Q?ZOh/VXRwFoNre4BSSZyAvOZSeMQe3AxNFMNgOmINEevZDeP0mI7+Xyrd2mta?=
 =?us-ascii?Q?T4jwvjSg8IXpKcCYM+ilHSdiiYm/QPoYUGguSP8u8g/EmuTPjAlciNzaa1rx?=
 =?us-ascii?Q?tGvRGARsHzQEGK35JoehX/qrmWPFe12N+19eN5iFteAFX2dGDuKE65v8fkew?=
 =?us-ascii?Q?Td4ogL7zADsy+Ql9WZ0M/UgeXHK3aBXGdaQgBWG+f/ANE92TvtPXn31GQluk?=
 =?us-ascii?Q?6vAet1dPB2Xk6XH/Yq59grSvtimwgXhw7/FEUYjaRf/1ydrgYOfawclqshen?=
 =?us-ascii?Q?6hn8khnEJxhqWxItC80S7RClJmsIodAYxm8/D6hG8xcDj7LfZOnkNIqscFqs?=
 =?us-ascii?Q?yKrtOwCbdlYtM0hmwCQNc31QpRLmQtMHjA2YySCXE1V52EYa0w/xCgS/hzGA?=
 =?us-ascii?Q?vTkn3b3e1/aMfZV8nOeqbMYDfflKCym8ndjJtWMP/nMraKetDkS32MztuCMV?=
 =?us-ascii?Q?1glHsL2l/1nsoNoj5WrGogPhjrJorIWOHr2HEseFMO/dAufXcJztAm/wGhn9?=
 =?us-ascii?Q?T9uhwjzrwo4mPha/SK6YcpfT8d9QcCrTWeNJDuVuMbh48Oso35VPtkwUyGDm?=
 =?us-ascii?Q?2LdGKZear9p/g47fA+h+zPcQH42Gs4tAZStTk7k02NzY+6/z7TuxFF+e15ko?=
 =?us-ascii?Q?Ao8v8HSonQZZclXDVnHzyPpsUL4zYiBlGpJC6ijBLlkkDiHSlqZrcdGb4qqz?=
 =?us-ascii?Q?0jTHftFn8osiCV7w2zUtmYN6BhRWQfsEGkBZBmAQWPCozbVTsN4Yh3aANLzE?=
 =?us-ascii?Q?EibUQL2CxitZU6ZOVMVUqXg03kb3BUiWJgne8M9OyqEuQSNtm3gArYcG0HD6?=
 =?us-ascii?Q?b/CDl1qUMOGLPV+10cCmbiInMhmf1BhsHNeNnJEva5uHLMFwNBQfTsqAHW9V?=
 =?us-ascii?Q?NsG93uEUx1huG+0RWLURhVaSEc3yDOdCjK7r9jbtDGn0FzEWawuvsomkgwRb?=
 =?us-ascii?Q?wnW3dnqYgHTY7r0HC21C1d0pq/uhZDvv0s0mx8mOU0bwhKja36JT6LLfelhd?=
 =?us-ascii?Q?DkUSYWt+spi+MC2di2X0xxm5hqpYGOZZI8LP+tCkCh/1o/8iKXe0NT0NkGrz?=
 =?us-ascii?Q?n/mje9d+xcSyZ6+p4q+mfpA5R1q00UqM1YNgQT/zSjYMmeWqO2RLUXlFEexT?=
 =?us-ascii?Q?Jo+exehw01wlVxEfNww/JOb71xhF6PWp9Fc0nqjjFGr+8RgrOAb/G8UDQ395?=
 =?us-ascii?Q?3avYleTvudVM4FRdrpdDMx1wT9cTwySRFF+3TjatYCUuLr782MicPyTt5Y2X?=
 =?us-ascii?Q?6jvekVGlMJQ+t5pUE/APfLu4m8Oqq/N4IBqdId6Ga998PiBOTv9BdJClVNqh?=
 =?us-ascii?Q?/jEpv+7w9yNTbhBle3bXdov9nUeSXM69YXV9c5d91ywvOMHU/blgjdKuw2Tn?=
 =?us-ascii?Q?aV0PXnvwbsUo5MawrWh/4pHzVIiTDICL04EBwh4Gy008oegHleuaOpIunUVU?=
 =?us-ascii?Q?yW4Ct5Gt6lUvlcMSvCNjhlt/X7pEZ1NPtBawqlOtcIyl7/WQuIcwkV7QcIY1?=
 =?us-ascii?Q?RZyZRsO68G9EpPYO5Awt8TIRcbOKx6T7/xiBVt3fmW1UXLklSPFGf7P4LZfK?=
 =?us-ascii?Q?GkrW1FZKtptFwG/EuAa+RWzZ+voo8ISzFk1LAJoCTXLjUo5URIWT?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bea013b-0181-4ad9-c812-08df29b9da43
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 06:10:32.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/S8vftnrsWMMF0pTKDJl16DfWD9bxAcJM0J6Z+TgL24X2TT4WwMa4v8MI7+ai6gfGNMyrY/yxi1/Yrba3lKmjk3HZbPYMh0YdK0AOZ6kZhPI2ZTUCkCZnl2x2yws8Bg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7293

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Mon, Oct 12, 2026 at 10:03:11 AM +0800, jeff.chen_1@oss.nxp.com wrote:
> From: Jeff Chen <jeff.chen_1@oss.nxp.com>
> 
> On Sat, Oct 03, 2026 at 09:22:56 PM +0200, Karl Mehltretter wrote:
> > nxpwifi_sdio_poll_card_status() returns the result of the last register
> 
> The patch looks good to me.
> 
> Could you shorten the commit message a bit? Please focus on the root cause
> and the fix. The details about how it was found and tested are probably not
> needed.
> 

Since we're approaching the next merge window, I'll apply the patch
with a shortened commit message.

thanks,
Jeff

