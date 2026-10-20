Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792468740;
	b=zLM04/PaO1T1oAIdR2whSnbyjtsEVn3LCDdsQCnNhEq/KXRo0otMiVZ8GIDN9LlRF6Fj
	 Gbey6lT6Mp4FZoxuu3CCHpHnuYN/qcWIdl45ITr4LlPnbOBKatr8tkNcDnucBjpRaxM0g
	 t3PLLawF9Y2ob3EV82D1VB58IMt0FqPLweBM+XoPGAmyP5Di3aRRLW8HMqtPFJLoqzT2O
	 1xzhS2KdT84c0wDNKTKVQHCjCz6UC6CCDHEzN5qq/9Gn0fl5fXTxeLjHTADU5TMyiug+L
	 R4fQyhL3CzRnMJ/aUxtqXM4sLWeiaYexy7fqAA6LbWFuWesP/GRFo/GzTVSsiIohl3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468740;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=P1tTYSYHqVX5ZYUjnsZTF0FhAGQNCD0iwEObRYyrLao=;
	b=yI9V4CLW7v/7bXBHQ6Sff6MZ5Msa80/uFUW09L/TJv06KKLpIm+HIBPQV99mO0pJmOFj
	 g7XGf9K3Wq7m+w+knFbzSrdajdX4haivotyqWsTlb3mDamIn5QaFwodSsqBL1gP5brrZt
	 MWMLgdMK15QNV2SZia+XisA/MHd8deVR/CToPo6U8qBRSj5aSd7hp+KZPJW5ZL1IY4hq4
	 afCZvNas1LSByvRZ52iZ16ZzO4olr721MjgKUbxXPQK4i5ItoIJKZT3GKX2sH/gtC6vnM
	 TVQfnd6wx81zC+Cyn9Ht/hECWEdVWYrF6TEzdx8bOWvgqcbbKVi9lqXmsV1vrlpoYIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=w39djiVq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.2
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011002.outbound.protection.outlook.com [52.101.70.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E423A606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E423A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=w39djiVq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPZy1Gzje9U7mYmZvY7Gp9dv66T4Q5tQJzggVH4LmXEZPtb7ea33nxhE3CRjPezgtgZgYbARSqd7i4zXW27I19rRmWKqNwXdDve0vUxJKsn+MA8fOJW13et7IxEbJvRYWUw7sTnzEPIavtqQfMKvwLrVsIGJaweGESsO05XKLB0wnp2uSVxwsNg8DZhO79wwa+LT9ztpoj4qB9hlCTzAmbgujvQmhym9Vtwg+1GxVSsbeyRj6ML0wUqp43P0Sq8vxuvXBdeR112hCuec1NHdppNuCBlPUBGAFSax9LFAvlJmB46ew13kp+qxyoSU4q/R0nvFZrEW7Vor8SaFM68qIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1tTYSYHqVX5ZYUjnsZTF0FhAGQNCD0iwEObRYyrLao=;
 b=mb/HYbegJHHuNgo3aqPrIzS/LpMJd+NvBw0V0dzB2fz2SP4+foVTua207ube0tjnjWa0PbLyTweObnjxoMX2W3HWiWwYwP6iwOo8uUCymo1jngNEk6V2YDepbGyrTu6oDBaRBrhs6wJoyneVvKXurr0AtWyK7luudquc2hgSpjlWWpY8yc7XPeX7Sa9v+4KAPouoIGDzAucOM4aXbcLorXUNXfNDZddgY971EpU1aii1eg7EssG6DAznvJrPz7ptPuUQWs3mFkfFT3K4CyBilBwDFXcqt4HqmOhbl2uI8iq5wuid75/mbFXHm2rztiO3rB03logY4BLJDJ/5uR4n6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1tTYSYHqVX5ZYUjnsZTF0FhAGQNCD0iwEObRYyrLao=;
 b=w39djiVqS2bAMtc2h9k6BBgipmJIkapSrfJSaYpLH2X7iafEDDt4/6HR23pWPLnTlrayrAoN8GsqRR5A4XRui5AQUsNCNxpCjcl4uOXT9XVY0dA7c+dSBsL4LRWO//9iamhpeAEiJ/q2JBlDJUg2pttZvYZZiyUUDlsEAh9Oq/TMfHCZ+QxGGsrf/dz6oy6uitS4bQZZR4oadLBDYnOLRLPJkGzrWvsd+AoJgzvr2sA/5UhQpQmCmI7hxQvpQFMY64XIfhzPiBaGQVjR4w6gx1E6tlZbYNfom0Q9fcrx3MJGBs04M/+9E8P/dVqCJ/Njlyjy7xA3eP9d/H4f/7HzUw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com (2603:10a6:10:1ad::21)
 by GV1PR04MB127854.eurprd04.prod.outlook.com (2603:10a6:150:802::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 03:58:57 +0000
Received: from DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c]) by DBAPR04MB7272.eurprd04.prod.outlook.com
 ([fe80::512d:486e:56df:d3c%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 03:58:57 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 2/3] wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
Date: Tue, 20 Oct 2026 11:58:26 +0800
Message-Id: <20261020035826.3628498-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020005027.1105121-3-yhlee@isslab.korea.ac.kr>
References: <20261020005027.1105121-1-yhlee@isslab.korea.ac.kr> <20261020005027.1105121-3-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P309CA0010.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::17) To DBAPR04MB7272.eurprd04.prod.outlook.com
 (2603:10a6:10:1ad::21)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBAPR04MB7272:EE_|GV1PR04MB127854:EE_
X-MS-Office365-Filtering-Correlation-Id: 6284a476-400c-4d2f-e61e-08df2e5e7736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|366016|10067099003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	U5GziRIWjBDGNGtW5TGcJrU/K3VzbyFdCqa8d7EDYS5ZNP2QN/dF/kSDe6C8/aOY2rx+KbZo9IOewfD8HZt2gtfgGCX9kmSrDvOT0iLfm0opU0Nw+2Q/VFJlP4RzP1A2HNNIdxu7rsdrV+7b1p4qDg2Z+iguNNEOVfJDKoN0+yuEFFjyOyMhJVi/N5joS4ZrBZt7di0r6FVNxnKD1JPJt3gsJ7OkxRJdB+W7rd5CIYhz67QMxDjRGvz3qrPycogYC0QVFhiwMAoKwzP7jdiF8jIGX+Xaeub4Q/L2M2csKH/ktgHUBoLHU1b9CmcUBrO85mCzDrE4l4h04fD6NlG9DPhxOOFyzUFh9kjnS9Mi65DNS5b3JK1F+XkAyH6V3m0F6xNIkUOfU6RKM4S2ta8Sg84z67BuIgMzAWgFD/zjJp2aqMMn8B8DlX2AkS9ImPOW7sEf6PkId4dJdOLzZAf1JFj4ELe764u+ldjl/RTOB4ljY67wh6rS0cirs6hUSdrJt9BHZIZlP8TsrvScEntVT9UPWDv0hnlQtbX9NEyfE22W57sYM0rlMQyaz4kQzEnLn2LpCwjMCyBQBdylDB0uNl9ghADaj56+b2N8JJYCw/G2IrRsbCgACgrLOlnslLAvGQlawzWRNEkMLrv6T9EnSFl3HX3Vav/ProM/ov5GS/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR04MB7272.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(366016)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BKSAfH9VFZuhZJ/06SIjC81cWS/xVF3VgVvPdWaYOpsbdZANBKoy6P5INXlV?=
 =?us-ascii?Q?ia35DbyunJApwET7dO2nCaSkc1m9Bnl+UOeVm+vYYWWUR8dKgpdlS579Nri1?=
 =?us-ascii?Q?OxAC3xD5hMxZnVSROT2syeirglpNBHX6XLFNG4wXpK123oGbJYM1sZGwc6li?=
 =?us-ascii?Q?oy0EHkvr4FhMkqfQvZ26sOMroQJ8U3HlQ0PvLOUS35IE4NIFCATP9jAPHmfX?=
 =?us-ascii?Q?ZaHd2rszJGp6hTRTk/rh5YndhHfHMLLTuS7OdfZdzClgV4cFWkDmJ8J2yhF5?=
 =?us-ascii?Q?jXu/7ZK7OprLtKwPZBO/PaMF1rAF3FK3HGp/UibgPZAUDWKsGpL65p3ig21E?=
 =?us-ascii?Q?hVK8TzxbnPfbWvhbT3ZTWOiWBsFKefuvUfEk10hdeU+7k1oljg1iKHm3sQqJ?=
 =?us-ascii?Q?HIvD1WjWNVAI8aUVdPUVLRFCTIZznvae/qpVs1yOgOkqsi4EBgvZwbNiaZQf?=
 =?us-ascii?Q?XHPnNO7hh0lzfUS4yviv5CZor5MmMbBH/x4umEzsRxfxLHIrrfk9MxnB1y72?=
 =?us-ascii?Q?bQ/v1ebxDdh4RQ7tsk3Q9ttPsuHkTTtX9kQaZ4t4als0F7VR5e3oxFtUwlkS?=
 =?us-ascii?Q?N0AFbaOPheVtVPP+bj9BlQV82ZJ7GswKcIK8KEjakRVYOKiIrXb2FnWkuKeP?=
 =?us-ascii?Q?2NuszZ/nsZyx1v5FnFSQqMCnj/sckd9FxXygSQp7snCyLgTnuVOECZihOa1q?=
 =?us-ascii?Q?Xb+HI22RoXvvkFYS4o5XWjjolXevTOi8k46cHjQjP8pydeu3XfWxu4C8nuL2?=
 =?us-ascii?Q?WvUJxwLOMeKGDh0Dr8wa1X5QHvEyTtnUSTqoJFxQLcsiCbroKosx7iORsXdV?=
 =?us-ascii?Q?NTUpRrQ94+feCk/R+W6Ko3wRIoqsglXAUXDiljP6V0w3VLUJkBG/8aU0YsBH?=
 =?us-ascii?Q?N70bX0lp/a3QEwoTx24bG6ZX8Gv5npBEb+u8fZY321BR7GsIEdtSVlhDuoe5?=
 =?us-ascii?Q?9aIWceifLIXAjUK43iqtG5dADmwE7Pk/ymyDY0IVapiJC493KMDoeXKnzxjC?=
 =?us-ascii?Q?oA9l8FhC7/1jopM8v1AhAqWKt0vl0vt1iEGKOgPDvpvocA0/cVLOOfeSZg0Y?=
 =?us-ascii?Q?bqgr6MRLKWdobL3D6EH58OzXThMwm6ju5/43wfnNx1Lsj9iyduJp7xIxUZQD?=
 =?us-ascii?Q?MsPbqx6NZ/A/Tv/dGeB1BR19DPqzpqSGs3RHd5NnCZ7lLMdDltR1UwA88WWC?=
 =?us-ascii?Q?tgcH40KJEBoi6sXCcBKHYtrVj47Sd0/SLir3pwnKJKcZUa2EFLCamKX1MUoH?=
 =?us-ascii?Q?RvTwj5PjVstaMsBwAX4YUiPVNLKjVKfeoiS2dIVaEHSrOdZchJ00XnLntbGH?=
 =?us-ascii?Q?/1nuVi3VYlC31DX22/FnHrGXTedGfSDGRbULppTpNAjXe/vL+jFqBSN7O0/d?=
 =?us-ascii?Q?HsJl7an8q7YXlSQaHC+arcAkaicd09P9wKOgpikJJRJY3SUuBSK7f1WBphe+?=
 =?us-ascii?Q?CgExkQy3ev+ZCdr6/WOOodgEm1E90ji0hUlicc5wsEwGvnv6X6i2cO1xWoXb?=
 =?us-ascii?Q?2e6PNrOUDnUGfSYm/YY2HfVc+gI+UTf+Map1CpFYBaMq7WRwt35BjDt56C4C?=
 =?us-ascii?Q?ukzNJatfdzq9gs6QyE9glHxip7uR0qZ62xd0q7sovZlwm7d7ysG7D3CDJ9jb?=
 =?us-ascii?Q?X1Vn2DLT0plm9ehBBvMLgd7GnZy4hNxXIR0U2au8iiIksC+mtFAPTupytqGq?=
 =?us-ascii?Q?s5g2LozP7xMOkEIAdGUD5Eu5m4t1sbvHwJTYd7gkopDXmfoUkKj7HRNT1758?=
 =?us-ascii?Q?0lii6whCDGx203TcsU/5+kuRTE8y+M/k23UjlCpkb7W21s5sMywJ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6284a476-400c-4d2f-e61e-08df2e5e7736
X-MS-Exchange-CrossTenant-AuthSource: DBAPR04MB7272.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 03:58:57.2996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odFvH/2GMQOd1FThJJhRkYy6GbZPCPeRAt7+qB8wRfDnCs2v8cv49SHh0C0rN4Za8kAkCYn1kWoRC6MaZzFr3pcNKEjR3vtNMue2a4g7btfoqhnD0HMQDnesRu6QKtNG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB127854

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Tue, Oct 20, 2026 at 09:50:26 AM +0900, Yehyeong Lee wrote:
> The send side writes the extension ID as the first payload byte of the
> TLV in nxpwifi_cmd_11ax_cfg(), but nxpwifi_ret_11ax_cfg() reads it one
> byte later and copies the HE capability from the same wrong offset. The
> capability test runs on the wrong byte and the copy reads one byte past
> the declared payload.

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

