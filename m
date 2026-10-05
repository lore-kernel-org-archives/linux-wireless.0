Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012023.outbound.protection.outlook.com [52.101.66.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51064BD7B6;
	Mon,  5 Oct 2026 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217936; cv=fail; b=pcDXtDHI4+CnRTdH9GnzMtLtl/ajTrN/vBe5AMQlYY9ZQYyoSgoV0A4kPPbfK7B6bcQMvA4s1izIMNCUXqxFKjZytUheqyNJn5SBgqg3Cmj72ybp58wkRG8ApfQD4a6o7X4xBOEZXxa/I9J1ntQORahmzKWcNaA82Uj322VWjZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217936; c=relaxed/simple;
	bh=K+caCY0PC6o6t0m0SxTs/CaQ6s/m+2X2L2DEOKDtV+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:Content-Disposition:MIME-Version; b=LqYTR+aXXlMZRNHnTTrcKa6uXnUVj0+sbmYzYvOS3wMJf6TIbMJeZ0gYg8BrhsWGCjcCnk4UMukXQBHltCLOyH5tWJBtTgJeT9u4/36VG3N9WHdQu4F5ilM7gwpfK0rY/d8j+SDoLtZqRebKJ7C7kQ+RCY7/PTAB7LWpQFp7KO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=IYpo/2cN; arc=fail smtp.client-ip=52.101.66.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="IYpo/2cN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aCwYo10We2IMS0HnmMb3UxemCgKsKZM8NOmLHJcXH3QPzW/2ioWNgrmkxelJEu4eJGoCkWwVm5DBlUk7kAEQoy4RtD4dLA9Rr97fIBSKKcANXDSXTGUyJiqLnIbpSZDxgRumnMBLxhoH606eyLS9cvZJzg38FgmEbNe5B78V9z8gS7pHPuB4czicHE46yHRuugbv6ckfze9MnbR6EFh9QbwwEq8X9s6jiP6mvwebr+2YhrPDEvRoSXbIFxsHTCaHeyDSTPU5Ia0bW54g9B1rRsB4lAGA81tKNILJsqcAw00diLqeuKQ8fHTJozuzaTjFudQxxh+p0YvFTAcDOe0cfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VURSZHyvjZ9cVF5/rWUrBL4Yc8Sn2/QtM/aRfH7+X+U=;
 b=ClvAKekE4VBhah+Kh+nID2tI2go/3unkV9MiZ4IhcUsTcu3JMhgbzHQvUYLSjXOmhwqI9K1IO6+E4TnbvgA6xBMWMqzHb6RoS7lF++Zv4IKJDBFZfn9IqKkdGK/UZCU6180G8fEKIl3ihPBhYY4XkHd8BR7omYS90fiKv27Tgqsc1sU2Rv2Hp960DAd3JeSOSBAMzE/Lb0HpywI1rqH8Iq2Y3NuZuqto8fsH+ylUMYXYQYIy7uwTFsDFaQ831T0JWS7pBBKigVgyCk23c1Nj04xdRtVn9G5jNRmd2hctdWp95NA4xd8Oyek/lQqT4whMv3dKnyrDFOpjHzRA2Xcxag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VURSZHyvjZ9cVF5/rWUrBL4Yc8Sn2/QtM/aRfH7+X+U=;
 b=IYpo/2cN698gP78c+bMt4NQtrOA9AsLz4ebv4AJHnaAHc47+uHXg0RvtvOWRDPR2MpHmfb7f7ZSCrqQKOFs9fTBZw1YzuzzWYRJ+8vEI/RVR07MjE0CLFaj/cQoRmbg2+Czu/Pbtrh0LdeHm6XCYASjnUb0/rn/IfNSRHjofE67fQYzCCYfT8av1WskfbHEm3REKrjlANzFqzm6DmFo+u2roh2T8dBKSvMvpCv3BYMFKnwOX6b4sgZya/at7tftcuhEzPsoYdLbazps51nmko+cEXqYPs6XqkpKQ37P83CMT9FBawRuTAMOWUut9L3eQCYm40I7rYJix3luf22NAdw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by ZR6PR04MB543146.eurprd04.prod.outlook.com (2603:10a6:910:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 16:32:12 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 16:32:11 +0000
From: jeff.chen_1@oss.nxp.com
To: techyminati <sinha.aryan03@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: nxpwifi: fix NULL deref and leak in authenticate
Date: Tue,  6 Oct 2026 00:31:17 +0800
Message-Id: <20261005163117.2883960-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001161730.49134-1-techyminati@outlook.com>
References: <20261001161730.49134-1-techyminati@outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0197.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::8) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|ZR6PR04MB543146:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2a2858-de27-47b6-a953-08df22fe34e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|366016|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	oJwzZ78Ai+XRMkrXUF+M+HvnEWK8DZsV9avcmU98Mqxfs3PZfhnx13TGD4CxudvbZ7YHtSTZmkQBm07pai405PWBtJ+TcyKj/yjREthSl7CYpTycQQ7wC9D9zLRfdmSN7qWLt77YNc23plVh9HOaqAGzxRsqIP/dvWmIXvFRUV3fM1xFx7WYQmYvR3/6YkLlCFEUZX068la/UpjAO5upzk3h1QMI6SPJDn9M2KSs/BgSZS5P7bzug+fv/RTbYkaTwknDfC7z9DAqDI2cKZZc7VoW2rXr8ifH949uth8Ti/45iGdmk7HcjOVItWObj+sFM2yJyKwgyI3SPoDAcs31hCTMXXEo8qheQU+wUHnzZoNzlpo56FIYXvfaTahVZ5XLw8KMmO7YCiyiRISbgTr64AqFOZB/ouYw9L/GpyUZplBj703ExdkguhCVZjtZ590fshRp8zeLMcKzyBNNGGeEvpKVCQ5SOUAGSOekE+IlUqBoSdLc6ON1q6EjOeD0P8DHQmxhe/ucsWqGykptHrVKB1tCwyljkwHLq4ewB6GAI4/iLNbaeVtE+bidFIDWPJVaxGkxmCutOYO1P0tZCcQLqEVlYdqzDqKlb8ZW0cUf1swQp+ElunSnC9cC0KmdumH/z5KLG9NlKh+gw79stMYjKThTYa2XoI8MuFzbmURkWiw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(366016)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OQFZn3U+3g6IAxk4NRh6ufyIsMPoTDRHrkVjZThw7GhBt3dIi8FTRIxs8a6W?=
 =?us-ascii?Q?i/oqqvmV69liqY3mB1hF8VyksiM7cFryLtc6+kOYnvQy9tE2+eJL0nGsebyp?=
 =?us-ascii?Q?tOIbkhjsS5Ui6p44DGGit7P4I/cM2WeaQZ0eSpF2fWoJDjCRqWa6iWqHGo4T?=
 =?us-ascii?Q?MhsJIxfwsBT4e6Pap/MObi+UcxmsJbvKjyumXulfgRDuEK54rV3xClbGmGpE?=
 =?us-ascii?Q?8HpTRP+VexXmHS4bGlVDjNYSzcd5FF5o3ecDlPxX0J3Z1kU+hEWD7NzKZP+j?=
 =?us-ascii?Q?NB2leM7jCAFwLtOm+K0qXwlseAFvu+BAir7aBPR1ew2sxY7PfrUWdrYUa5kx?=
 =?us-ascii?Q?hTolVxQvh3dhD1wxa9gV4I53y2oKbgq5vtSTffcFOH+qbm0bsHUi21x5mHKN?=
 =?us-ascii?Q?dy3z2TsI6DQd0DQ5NmPTxC8vzymsplvJJ6saq4XqiKMn3USoGEo/mcWfZiFy?=
 =?us-ascii?Q?qh0fw6qJfbmiIveetkjXo/B60Fy1/kzy/xMITTLC0LeiYw3S17ErFqBszrvm?=
 =?us-ascii?Q?u1RWSSgC2ipDI6YRZKAazu9aqVeeeyXc8c+bBfzqOb55xEVvhrfdsJtbTxcr?=
 =?us-ascii?Q?iNkRIr/6GHxKop6vbJQXRU8FKFiMhU8jaYWH2KvCRBIvd2b57WIOH7GNPpiA?=
 =?us-ascii?Q?jVvLzhTQnV6st0qcVIRuG9Bu0Qty+jluGadb8E8u7s0ylPXHneJo19Glim48?=
 =?us-ascii?Q?wOiunIhdHgP1/DbiOEYhlXM0ZnhQ5AUvcxvxQv8xF7ySF6moudVPHvt7kxKM?=
 =?us-ascii?Q?y/yrakl+oSbGIGYlW+cg+t1IBeMlPHL/dQsxB0guE65FTaP1NaOUXP0p7CtQ?=
 =?us-ascii?Q?O4xa3yydl6Ia6zu556p6elDalqnhIrde3hdkXC5xxUAlvH04YvTIVXyNxW2Z?=
 =?us-ascii?Q?GbBr7oQzYwCXRBMM3Fe+Eyb6Wp2UF3Dkav6DVs0xDjY+Zo0JCIRKAS6dRP3j?=
 =?us-ascii?Q?Nr+hhgW9i9i9rRWTRMujzjcyRj+WwOrlbcqrcEI3V3onkoXk5fRTGvklyEkH?=
 =?us-ascii?Q?d+NLY8v2ZVDsHdmSQUAJg0JLIXcTzH/cu4mVYs4mQ/pVApNOKWtJkwVPsvRV?=
 =?us-ascii?Q?lTeBNLiIAksfJ6xVRCPG+VvdKIHwBM/qo5LEvjNkeFSMFxRN94e4KMznRS1x?=
 =?us-ascii?Q?2Q2y1nk5Q8wkpRJR10yt474LQsGom3hN+A97dwC0zV1bvSoJLek10qEm8II7?=
 =?us-ascii?Q?hSQqXYELYWFxBqYVO6Mdi52Xcs0pEGyvu+qZobilvMkiv2vBmJGEyjNcmBFs?=
 =?us-ascii?Q?BW+MN2u5v8UioXhS2pv2rt3nxx26jhIDGqv17ittCW6BKWN83ouH7VWSslsu?=
 =?us-ascii?Q?rMrMeyfRZgSocdJDZVx1GnX54UzKojtih/FUzaV1dJaQnK+9dbJtCIxQRgNb?=
 =?us-ascii?Q?ORhTGkAUNRi5oA79ZwznFUjxRajdI0tuoT6Pkcgg/7zG32WLGe/yrIaSNiPO?=
 =?us-ascii?Q?TAitdq3OMc+L8a6+Vs0Cytb+vTHfvbx+++fA3mhipk1vPuGcREEu2rDCLcKQ?=
 =?us-ascii?Q?sGtIOtpsOWaaTVxhd14mLjX69oXkGpdHsdyihxNYQexdPeDrhP2HOMex6pyz?=
 =?us-ascii?Q?wQtz8GiLym4U5D5njEinUDAZe0ElppKlU2LVyJSZ+ARg0ce2jkrDQqfuQ4XH?=
 =?us-ascii?Q?/SNO1YAb6b2tvlXyRh7lkjJq9V9Gp1H7kQeu9+KcbXO23cZ78uAxGE/e2/yR?=
 =?us-ascii?Q?QzywcLNWRjVsGNwDRaoHUwaUe2XqkXD67XdnLivRcok7k+fZL5cpkNrcx6JN?=
 =?us-ascii?Q?GG9gZpsWqdiTIPVjpprLnECC/Yu5ZBANinCxGJFnOH0dl7YYR4m0?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2a2858-de27-47b6-a953-08df22fe34e5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:32:11.8447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ngb024KBZic1vrZBfMoW2WIOMoZGqfJE1nfwKSIA0KqxFOcoMfSi4obPbUwWAj8K2EhrC7HOAi7w067JX53bT37xsSKxpiJ1Pig6A/mNuqLfy7ONbm/9RmKIl2RYJe+R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB543146

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Thu, Oct 01, 2026 at 09:47:13 PM +0530, techyminati wrote:
> From: Aryan Sinha <sinha.aryan03@gmail.com>
> 
> diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
> index 86304ea33..9eb809caa 100644
> --- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
> +++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
> @@ -3403,6 +3403,8 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
>  		pkt_len -= 4;
>  
>  	mgmt = kzalloc(pkt_len, GFP_KERNEL);
> +	if (!mgmt)
> +		return -ENOMEM;
>  
>  	skb = dev_alloc_skb(NXPWIFI_MIN_DATA_HEADER_LEN +
>  			    NXPWIFI_MGMT_FRAME_HEADER_SIZE +
> @@ -3410,6 +3412,7 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
>  	if (!skb) {
>  		nxpwifi_dbg(adapter, ERROR,
>  			    "allocate skb failed for management frame\n");
> +		kfree(mgmt);
>  		return -ENOMEM;
>  	}
>  

Hi Aryan,

Thanks for the patch.

This issue has already been addressed by another accepted patch:
https://patchwork.kernel.org/project/linux-wireless/patch/20260820081634.4043666-3-lilinmao@kylinos.cn/

Thanks,
Jeff

