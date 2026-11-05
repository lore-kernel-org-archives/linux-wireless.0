Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.107
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793878348;
	b=noQqwHnegDaYZsRsdChwTyjTcpj+DFPdNxpKK72Gww9Zw7oDMggGVx71lJ1Nr6SPVb7R
	 B+WfC4k0QG3Vtogkul0IQ4P0s95ET2fjD3k29+SyFvmFpSL9V8SB1YnMmH57j3+wSW4O7
	 S+PnQduMD1sqMoYb3B1AZNDg8yzSQnha4+dwL/qsrWl4femD6cEH8ntQRzAT82bs/aUpe
	 ZUIk2Wk61Z8dRz15+jNB0azHdHypFdz0YrcrSl3s+0V5UE/5C/M3q4PXtwyoGt+RArkXK
	 lvu7RdIDJeTj3RGsyHcbBq6BFPHdUr1R8s+MHlew7+uOF4nEdfFlWu+c3i7C/1LF2DA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878348;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
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
	bh=js2Vmlv0kM8BW4T78R6yiYJWHYkEs6LlmPkRwLF6Qeg=;
	b=0lorQNT6e05t383sCFCBlGFVUfgPgSWpkvFjHb3iLcDRZNCyI5PWwvrhoVTi99USBWh1
	 FPVUsSZhu6s8rmXE0EFUPFXkDy4lh0I7QvNl0eIhvW//9aoPeP5um6FrGVVy2xlZfF5oQ
	 liq707tiLt/GdKRWf3J4tnDcU9ji6p3gy1pPH0i2ztBK99ujaqdoWMG5VTtb0IExR3Gxb
	 6QW78SanotNPyuNROtYysKKSZyqVEj1GtSWmdBkVbi7MiFZIh1G1HVmiYCX1jaxlq0sLf
	 BndHLnRGa7ULMyXz1uQGUCqQzvj/ym6iroVAnO2b14XDlFiJQvBySXtRJrPVQYx6H5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b="Joz/x1Kj";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.107
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022107.outbound.protection.outlook.com [52.101.126.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D2E606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 11:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75D2E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=Joz/x1Kj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVcjhA8K/w+UGU8J93AW04DfMVwZzbctY2NBYfycL9B4nojv7Ps9xOEmT485Zwnh81/X6OJVdvKsHfPpRNjXfPxL2dYhEzgKIMx7UrvS3MYPcjCgQ2gNK9D1ShvyJ5D95Kb+lubUA3ONmoxJkdgA3IHHhEnQhlvOii0sxDGXS3YPnUSrKiWq30WmBcbRGFfCD/op7k19qUIwn9PQrsWyxs/6BxcC1JLTs4D6XPnsbTBgf9737o7cvYKIobJpBuKsiypWgw9Q/ErbqE2VpxoB9xbzr/4++XmeVMnVNTrGHY7pdHsvlbse2f5GdrIXBzbc8cni6gfOrp3HJQKSNQptHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=js2Vmlv0kM8BW4T78R6yiYJWHYkEs6LlmPkRwLF6Qeg=;
 b=DLLdUlfkg/USZcCqFVGp6/3dpcB1iYhlyDu7CIhAUhXdf11HK7UUtycawPU9W1QG9V2iKQpQx4B3+rXRKF4/O7EDpMKo8/fl/28tJ9UzHsMihRDI4kE6bqtaJ7aYnFm2qnneC6I0AJh4RzcuV5jsQoX8lKo1D0KD+xpJVK7xgr9XgRYzSTXJ/q0zwBPnHviwl1u0PPpVbva9RMhbVIVZjC6QJffTabhmwAfpmjA2tEEYYrlaCJiP71PO37Vj/C8s775zsEnrfab4mMbsmoWQmyJR47J0XNfL0ySE5vFfwYwkpWEYXoIXk7Rkc6LsyjQrGKg2JbUfNgKkLiBAox+kRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js2Vmlv0kM8BW4T78R6yiYJWHYkEs6LlmPkRwLF6Qeg=;
 b=Joz/x1Kjo5O1BMdUpDonvZa6V1qVPcQZS6Syspx1CQJqwPTBnvehfrD4Js0ja+VEkeDp5N5jTkV8paq/iXH8OzepXOCHKLPU5y2DF8pHq4K9Ul9Ktw7isbz+avdMd9xWMrMpCG4GK0YKH73xkbjBAEEfORXnxHbcbH4WHb310dh98ZwALaWPEdMQuBxJSEYWXkxesY1c2GJnmbsPw3iju/R3fE7zaQP4joMzX0DasTT+0Mvvh+0FoWEdlpGgb2XcTQBBfZd14q9QhlS5WQmtobQO6edg4fvzssXHYof6QdP+Tqz2jdNGybPGDfqAzIEk7iC7bRD5qPnO3aXSqRgJkQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by TYZPR01MB5373.apcprd01.prod.exchangelabs.com
 (2603:1096:400:338::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 11:32:21 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 11:32:21 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Huihui Huang <hhhuang@smu.edu.sg>
Subject: Re: [PATCH rtw-next v2 2/2] wifi: rtw88: check the C2H payload length before reading it
Date: Thu,  5 Nov 2026 19:31:35 +0800
Message-ID: <20261105113135.3560378-1-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <89b76c1edf151f509a912f887d9fe0b93cc9e19c@linux.dev>
References: <20261031175621.2228762-1-hhhuang@smu.edu.sg> <20261031175621.2228762-3-hhhuang@smu.edu.sg> <89b76c1edf151f509a912f887d9fe0b93cc9e19c@linux.dev>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::13) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11)
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
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|TYZPR01MB5373:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ce6127-893a-4ec7-33de-08df3b307496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|786006|23010399003|18002099003|22082099003|10067099003|56012099006|4143699003|11063799006|38350700014|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	Kbdd0P3WCxkpnXxxguTEZ2L9Qs5U+dzuZ9lItnsH9fuez2NQES+sEaPkE6/rQCptycY9o1QtAIuZ3HNdrQIPDdK9q51UQ60w2fuNO7lbo79SakiZH83FoJ+R+O6H6b3Lh7dnJ9qo0TpZrr4cACotejEBRSifXDRbKbz2QvkxDsg+7jG5PsyLIV0sf3ofL8C9bKOmKP4N5Pg4scI1mveUoU+QDapP3x5LO0Az9c24sXjFFCmQYMCWvSfrAcVYzA2x+TfK6VaV4/3w8QrUsyxiPUraHBLhSelB1xiag684RlAV4ZxTnAEDevJc8APybHO+gZoQwg9VXvJaoIN8xoNYCUJ1H7OeVDQkxs2lvw6RwbBfBNXxs5bPyHajrwHD119M55pqZMATaqraeZNsq+MovZ1tiw++3an0NKrRQwhKQNmFxOaDuaMEvG0UPjXMY46dJtndhL5rClRKwTgbaRQtoe9dKtUQVLECiLuYgP+sK53JrwYQL40u+MxE3Um3uZ3rfdONu6BDkNAn5gdrvLMn7L2iZi4LImai3kVAMSrkhy9gika6hhcWgMfFS8cDH6e7BWStR7R1s4+RBj5mHiAwNtTQTfJdfTrO62F0OAmBaAMasXVvULLubPHdriaf9esszYSYcio05SMRn++3PhJKC9d6yFt4WY9L5iKh9cpWSuQHeDDFmhaL9LRo3NTu1cOuBzQC0KnLOR3TAChOuts0cGlJcxHT6ZISHT0HNtEWLpM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(786006)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(11063799006)(38350700014)(261026121527099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MRZ4c/OWbBA3x30C3E/NPqd/jae0TFJ8tnUrMqKWz+/CcIMnb0ILG7meOBHf?=
 =?us-ascii?Q?Frwk7WIJWJjcBh9dOKuxt3esF13Nc/scrB0eRz+q9vjdrNpp9LtPwRsQ7U+x?=
 =?us-ascii?Q?l51BjeH1RzEnFf5jEy2gyoQ0ich5xO7SCDZij6GgGzaQ5ICdQnWW+OjoApgA?=
 =?us-ascii?Q?6uAOdhD6okUNkVlhCiOa+uQUY25yupyxUDZjUM05aeE9Fwrdko4uoXU4gveb?=
 =?us-ascii?Q?WO9HU7r1rrx4qXVwnT9n71sAeuZKVx+j0g33yrPQevJFm5QR7vyCf7r+7FAo?=
 =?us-ascii?Q?2sTxdlwZofzQ2tDBqIaTEssXbBkbZewjhX01Ts3sFNQY1hveKSnuqG+sX7sa?=
 =?us-ascii?Q?oFsEsKiX2I/LfC1BVj9pcQswqsZqgTKR5dHQ1y+2yhRhOelVnZgMaMMNvGss?=
 =?us-ascii?Q?JS4PTgtRHjElIhZAju+q4Om14c0ylepJ0wU8Pq89TIsy/SiBYUsT3KHqO8RF?=
 =?us-ascii?Q?G4WJoe58TLc4hkKWesBvt9df1ii4Zy3WF1YI4ZWOYoKZ8b7AnPnQOzTwSVI3?=
 =?us-ascii?Q?GhEspmdVi/0H9rl1Cj4rqzcGBV5ZjdMhbwv8fcR3CeI+NUEOmo15/CMfrfYD?=
 =?us-ascii?Q?k606uwUu6CsT5LyEmuLeQv3JvQOGliiUQZt6aCb/zR7/8SOizIl1FpeU/Fbw?=
 =?us-ascii?Q?c74QjXB3LRQllSDqE47BuQddy3Zw75YCmPY+gsF+nYZ9rw5edf7qb7MFy9CN?=
 =?us-ascii?Q?s9nCb8CyUxQ+/caQPYFYunGH9gylRJhSmb3qqWeJQ25VTppei7lQZCsh44J5?=
 =?us-ascii?Q?aiKg6755FHXVZnI0Hmvrn3uYiReywVdjnHsXK3XYEswQP2vn2trN/hgThtES?=
 =?us-ascii?Q?0SNJPXnQ6K7IQwkIcL5Y0yozalHJ4KCkHpFcn9WkBGvno4tAGRHJy51Ko1s6?=
 =?us-ascii?Q?3Bstu52nIBX/ZGsh46RYjFFi8+qGxY4RVkpc4qWfVKovkXH8nK9Zsu4pME8t?=
 =?us-ascii?Q?bk5tc05NkhSPPeiHI6aSzzqv8j/DpYhL/l6/lBRZPA4k/pkOyO+0wwAsJ7A2?=
 =?us-ascii?Q?FZm+TtfTgq4/og9vN9DVPOtgN7/UL4G+8KYS0rYLqAgEWqfSBGKzlz9q43BN?=
 =?us-ascii?Q?Ywu1T1Ga0amZi3hBkOwMW9tb590llWZW4i63Ezr5c0ZaSTv/eoNwaV/fRU6L?=
 =?us-ascii?Q?6YqmcZd8OoA1bh3+qEydPmZRA7cPt+Uve2iAWYeD0t6dHbcy5TN6scyYE9SI?=
 =?us-ascii?Q?R6FIK9pHfYMQNvLk1GEAfQEhIoGST9bpyO2vmlPBAChUAwcUyJUlhRwEiphe?=
 =?us-ascii?Q?hyTEcLugPf35W67+bhMBXYaz9Z2gUyRpOd1ZxWFz26KOrjE1OZTscp9gZEdt?=
 =?us-ascii?Q?Xqp3Cq268+GGP3avQmg3fP4lxeiVOSTz3QkTbLocHoGP/EwuqRZgDaV4h2Vy?=
 =?us-ascii?Q?0/3iR11QLr9mh9aZBceA9ZJ8L0pxHVEjqX2HfZ+WuJ2WZp1wq1UvHDlCM/Im?=
 =?us-ascii?Q?CUjfrX7NZpRwuSH9cxaEP/D7Neb6KpWor98CBQaEB/ciRDrjvQPRUhuYl4pj?=
 =?us-ascii?Q?pYDxK+90Raul0N5TNz6r5TKTEBBEnhCpJJBBI/EyJC5u+8vQksY6QlSJlQ7T?=
 =?us-ascii?Q?M0ns05C9ZNiA22aTaKgw+Z/BfH5nAx8iJsM4blerO3uJPKmFpilY0CMWA0Qw?=
 =?us-ascii?Q?6cNccjzVe/YshLAlYDCD4if40gFOmDEzvJEEDH2w+tIXjTp5S1lkwtVXWPKt?=
 =?us-ascii?Q?/kDtNHwBcw3IFoC9YniaQx6xZZa4kLsUCStfHW0nADsPzEZpsddZtTuU2hZO?=
 =?us-ascii?Q?TFoiWvnBQg=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ce6127-893a-4ec7-33de-08df3b307496
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 11:32:21.2803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nl861jfW0B+tf33p5o0jr8UXh5aU9NRgoi1QeVJPb9969J+8js/qapEbQZsB/7KWA/NMNwJvo8po2s2X/Udefg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5373

Hi Luka,

> Maybe it is better to complete it as aborted here instead
> of dropping the report, something like:
>
>         if (rtw_c2h_payload_len(skb) < 3) {
>                 rtw_hw_scan_complete(rtwdev, vif, true);
>                 return;
>         }

Good catch, thanks. I'll do this in v3.

Thanks,
Huihui
