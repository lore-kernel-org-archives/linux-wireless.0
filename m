Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011053.outbound.protection.outlook.com [52.101.65.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FA9279DAD
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791770645; cv=fail; b=UOfJq/a5DQrSFY6R9z+vySTsOS8Xu6gsrBeWyOBwodIsuVmo3EnqGPNd/vAKmlr57IjlBFlMlrFeV6Ze+87d2+WuMvGQcw7er8FZYMYj5xHs5nXPwL8mga4Dg/5IqM2FSWAFmN7r8/bNGW56zMDKpcPV4whpZdTZLkhNWCj7wM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791770645; c=relaxed/simple;
	bh=8bPez6L/x00nQxxX/l80jOj21gRQZJhDglZ6yFfhLPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:Content-Disposition:MIME-Version; b=Om1i7RBk0UFEyI3++d5MdVe7gVBjqFviIIhJEj90GLMBHvYb+fXjdtoqYXW1NepY3mQUf8TYKNIimZo55x92yVSzueNeQRiL+FpBaYkfNmgCedDVzTZxkLYDdQZJLGfLx5Ya50Cgut3RfTeJhuBZ7DtVujToi//9CIh5PxnZXbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=UJzZ8O83; arc=fail smtp.client-ip=52.101.65.53
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="UJzZ8O83"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opv/U2Of1UhEsuPJnLOQx04pxNLE3K/T+MCRfAOfwpEYoKD1+35g3viSCQEzg/0ux0tZnW9ibTtMWxEQaGOWxbVe9Euw3gN+4cigVGELI1DGSP8P8oz8K5FtwPEkPRW162yucsNR2R+j56T8u1yYeqWOGsAJtIpmsiPYb+Njln4+jHH/9zNHC27CjGpiMDRM59+0iZsVtJIbST2HA5jK531rseVnTdjmj1txQKXimhElQt9ORHqee9FjzGEgLtKe1wJYXOdViargRhHPhRzkFMiMfANC5RhklmU3ocd2FdsyM7JN/x3BnL5oiLtsCAaIjfu14DWUWcqiIMvU68pYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xU6ak9/44ddavptqlkQ0ZCbKIoU4gear8x1zHqEHQRU=;
 b=hE4L6dTy24/w50cdB8CVq7TjxgqQqUpqjCIvfmZyyajfAimSJsEry38wMjE+Bu3m6hqoGXUn0xeGxh9zg1q9GrbetwcBAwmoO9bB5OdBju4N1/hsAZx+EUO42BlCWZTf1zxMyXVwckNvKQOWOhvx3Em9tSrBUVM+cluBMEZb7IFMrozaJw6X1nlQr3StwDMGrMEDN8M+EkbSbawH5Hq730984NiASEB1qRQ4IBHYS9C0qKLCbmQscHg1ZmfwldI5Gxt7Byb9O4EdRn5Vm7rCrxACwH+PnJa3fmbWURkGhvRBKYmRH4RRu3gHwgmrqPu0OzO5EAmGp2yOEq1T7eL3ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xU6ak9/44ddavptqlkQ0ZCbKIoU4gear8x1zHqEHQRU=;
 b=UJzZ8O833U+j52u20pll7N5LwQ5B/q0kwMcwgj9dDkPbM3Z6cMvrVB3TKSg9meiNwWqJLbcB9dSxcppRa3Ek+F3CKFIifdekceO/aPtES6Glh5RWiv47k1kqQPqZMaNumQAN7ytSKqX7OjVpV4TfTbNM5JwFPTktdjywbnilzrJoz2Ldt9TcIApblkpZPDRPShOuZ9TKXFDqzRs8pPBxHlQ0cIDBRhKFUzojvkws16obMXUcD4s5MFk5UqUAYF9pLT3bJHbQ1Q7m8ueHYHPYLlT3BI/FLCoYlq5otsjuamNWHueCSBJ1eiYVL20zSfPZKgXceJoF2ZfJkk2UDYSmfg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by PA1PR04MB10357.eurprd04.prod.outlook.com (2603:10a6:102:452::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 02:04:00 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 02:04:00 +0000
From: jeff.chen_1@oss.nxp.com
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: nxpwifi: fail the firmware download on a poll timeout
Date: Mon, 12 Oct 2026 10:03:11 +0800
Message-Id: <asw9+ftcdKi10UUU@nxpwireless-Inspiron-14-Plus-7440>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261003192256.78255-1-kmehltretter@gmail.com>
References: <20261003192256.78255-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0151.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::18) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|PA1PR04MB10357:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f4c5c11-bf43-4c7f-3d5a-08df280514e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|19092799006|366016|376014|10067099003|261009223027099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0fPoNKchRpexjuq0fEZfL5LsY3ghZXIcAcWvuRYztk5N8qVX/wEDwuYVtjr/MiQ5VoesLNpEVEx1XC5jrR1ZvErJym/leuD7ASRDNb/p9ffETXez0fZbWD9TBdDVNz0yp2PP6h3AiFYIyyGiR9QKrouX7YbT/rScO10IFpC+DRtahj/dO6oNR/syULv+fHM5CcMHd9ufcEDv851iMzW5iswLnHmG9vtwgQbLAnyKS4kw0w5/e7OGNqeQc3JiZiDjroYDqOzyzUhxf//Hd3PxkKrIwOs78azycq6jSNDEcBLKqmxbUNlFufDnIwy89OVB4RBAr3on1P35bJHHe1WuQHRjO7rEwBd7j7Jl7tCij2Fee0dI8yTkdJ84xCxBbN9LayI1j2CKWgnJOIQufCdGamGWDngvzslt2jRuLrBnYoL1h6pDjVGZAl1DdFROer6dmQSZTlDZBGvLDHt7ALzZddV7fz3Xp3gSuGOz4PP7lcc5OQSvuyiVO6szPmgKKWtfQrrOf6GhJhbHywhVZZXzDaPCWJFgcTjdwxpO5iLmJHoOyGA0JvmCFSn5aC/8xgNa6sP2DkpHKh6IGO60obd3ikziQNAMOC+6a+owdmshoewFZKy5LiI1HLUE+EOaKb9QHfUg01Tl/jGAydEg6przDk7Nw/tEcFxKonKzORWab+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(19092799006)(366016)(376014)(10067099003)(261009223027099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r7iV12lh6YKwmfn81cmbymhDRa+r1hQ2NfTyoUupSD42Sx2SsSZ+UAQWdbz9?=
 =?us-ascii?Q?QITPZ16UVvWOe1FM7DxWzTawVFoWWEvbGhgFptF8ln5M1y3UFEKm8MImEZvO?=
 =?us-ascii?Q?C4k012rA+imRR+iKTcf5y+y4JHXGeEawj5ICgBZmjpVqf+1JxmSiXg1C25OP?=
 =?us-ascii?Q?SBiIbGOBv7fFZZog+pUTyMDcJwcjGXa2TnnQzalEzzSqo9Pc1DST85IarAQ4?=
 =?us-ascii?Q?x8/XyJzmIVhQ8z32bXuBwX/CmGSE1BMRpYFqTkD4PJQzAgCzDKPWpp5dMC0f?=
 =?us-ascii?Q?9Wiazdb5g0MJR/xlfYoqhN0mu7zCrl76FUCNpLSbfqAeqtiwjwBpTmNbFxGq?=
 =?us-ascii?Q?/Pc58FpaX4OdIqeIQqf3nJnuv3ZK0uEAICUq8PaxbKwqb0uXKf9Ob+teqx/j?=
 =?us-ascii?Q?enq7PXksmo7aT3d3uppPrJCA8TJQiXvbvuKXN6lvutIHl0hjp93IWKmhgEW8?=
 =?us-ascii?Q?5tSrp24DfXQIQYk4cG0wKhweqQONByQxMoJtnKJLQogaA1jFQjEYoVUz3ATQ?=
 =?us-ascii?Q?PPP5EgqtzmfcNRedXpyefDiqUeeNN+3XsKMI80T6e5kNcwpQsAvN8hvIacht?=
 =?us-ascii?Q?ksa5ejFfK9T4pTMmoUPqU3nxWx8YAgUtVb7Wq+BlRXZJ+CJX/HI5WI36WSxn?=
 =?us-ascii?Q?7t+fNn0zqS80rksXRGibf2zdP4YUvQrFNiPvsZNw8vHpgCPhiw2E8qs+3E+A?=
 =?us-ascii?Q?uWrjXJtQ2IxQXg7FzBzCbKRJ46NXIKTU/OR6eNoaOEjhRIsKwZzgSmRlgzfv?=
 =?us-ascii?Q?w0My4FTbc/z/Vu1RtVMR6ggdoQu6pRC3cDSm5h2FlexfIttWNJ4BcFPzClOz?=
 =?us-ascii?Q?j3kOGKCe4QKbRbjL+sm2qk7R/230bYUI7+SXEBmcp1/19Hl/0rlGMMxaR3jv?=
 =?us-ascii?Q?3x+M241ls5RGA+Jo5wjjh2rSN2CJf4z3uLsgyhprwMIBiYC3N9bporZ4pDiD?=
 =?us-ascii?Q?PguW3n6TgkOiV8XjrwS7AhgOhLxQDZOflIMkl3+AhbWm797rmUU2Uebcz+TE?=
 =?us-ascii?Q?SvzaYoa/+LtBOBhWuu1hLA5Obnf5Zpdld/T1ZeFbjwiAEnnbnOjFsoylyANA?=
 =?us-ascii?Q?VpkD4YBJ14/cPdSioGbFCPRqeMujULxECeLiM8urWExp/vbkuk2RW3B5Pp2c?=
 =?us-ascii?Q?YNOggqjCERIyOBqGQMn5ri6TSo01rQsplpuWdlxzxtQCXVVApFcLaAIhj69/?=
 =?us-ascii?Q?XoiPmIJKgB4N0m0FKgLslOg+8Ximd1j5opxGgFl+XoniNt0AZJMkwFpl1B/h?=
 =?us-ascii?Q?7fzymw/32ItdrC4CY3DI4A70hNy3YTbeKLPk6Oy7Rxk/PeHWVQ6Gbfi5MMtp?=
 =?us-ascii?Q?dWqjxFIKYO9xjbpqfdCV3sHHDAixET3NbOb4iB+jTmTDtSLoHze9bUu+RMOm?=
 =?us-ascii?Q?nhhw1arzE4UdY2mie4RgiLqIoslfbXs20AopB1g6bvNiW9lMGQ1sSfkdn3aL?=
 =?us-ascii?Q?C1BsQlYItDdIIk98cac/vCk+vqQq6Oqw3u80j+ckLc0ai3tQGHLpoDrG8Ke/?=
 =?us-ascii?Q?CT8QZ8RTq41hIWw6fvabt8dcIBM+oewTaLncUDL6aWmaVi/3qxlyPxlZCBtn?=
 =?us-ascii?Q?GwzKqmWTMsoohzmEC8dzVjozubOE+omFeh/ymt1GxDGnw/J3wKgT8le6kkO3?=
 =?us-ascii?Q?uZmv+LO5dJec66YNstSAUHB4GG8Du76VQh1wb2vMGwoGn74zdvHB9SF9MwpW?=
 =?us-ascii?Q?yPCx6F/iToBnexCe1lDtxB+R3qVdQWWbSVtod8B8/pyXYEmbst9mmuNfKujO?=
 =?us-ascii?Q?APCSlp+dmdpNTB1QUHNUwBNTZwMiDJILcgc3C7rA5cBUbEaF7Zhi?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4c5c11-bf43-4c7f-3d5a-08df280514e6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 02:04:00.4898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oo7FGRdsl8CM6ePdvJ6otE6joLlVETKB1Q2K/CNZ4R6gq98sqpY+MbzyoKSQFTvINxvgc44AqlbWMpJJruLWxi50w2K/xdbCRTEHMDyBLwuxBBxlQZikoarbtAcDyu3m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10357

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Sat, Oct 03, 2026 at 09:22:56 PM +0200, Karl Mehltretter wrote:
> nxpwifi_sdio_poll_card_status() returns the result of the last register
> read when the requested status bits never show up. That read succeeded,
> so a timeout is reported as success.
> 
> nxpwifi_prog_fw_w_helper() therefore skips its "poll status timeout"
> branch on a timeout. With an emulated SDIO card that never gets ready,
> the driver logs "FW download complete (0 bytes)" and gives up 30 seconds
> later with "FW failed to be active in time".
> 
> Return -ETIMEDOUT when the poll runs out of tries. mwifiex, which this
> function was derived from, returns an error in the same place.
> 
> Noticed while looking at a clang -Wconditional-uninitialized warning on
> this return statement. Tested only in QEMU with an SDIO card model
> written for this test, not on real hardware.

The patch looks good to me.

Could you shorten the commit message a bit? Please focus on the root cause
and the fix. The details about how it was found and tested are probably not
needed.

thanks,
Jeff
