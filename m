Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011063.outbound.protection.outlook.com [52.101.65.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4044156FB
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 02:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857137; cv=fail; b=bkFv6lUp3V6Uueb18w7s9qezEgTjIHNGtq93ApBTJJM1Ds6cxlmedWxZbGD0BAC8ZycURuXofvw7egJVwJvhhp0qBjtztWqcpb/8NOi8Db+gRTk4owCBcd/aXK0v2GldlvCWIsv5j1wUvl/1pdV6IAVy+4X7tbvT7koYPo+ZYF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857137; c=relaxed/simple;
	bh=jBG83H8Z0rWF9vOQt7GhUMWLieB7ICADnhXbUAAJI9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p7njJiPHi3VmGMqnnLqbXWmcEHfmv5tElyKoUKWdlA0Zhp1uMPOP3nuk3i2Ns7GaAu+ZxqkZekxa0biVQ9DI0ZiiWmPT8ZHzG44idQcLR5NFqlzSC8G8ziXSeG/b385qxhcERd29Q9GhPhjaYNWjZ5PmhP8k8/pRBT6i/e4a71I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=HWij/yKd; arc=fail smtp.client-ip=52.101.65.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="HWij/yKd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfP+vI9JmOyWizA9CZC7oacbU261OYx16c7yVwa9beVyL+ozsfwVDBITwmdtOVg+Ft0VTnbT2YXr/B/kBGMk95EbK0NqDeIraZmur00Mz7FqxiwJSRtDG2IStFg92zOHRG3Bv2KyeRb0tT1wLMJXLHyGN9DHfgNvxsHrkrd4ZUoSowE6hYhuXwRJWkKhQbYOrnDsOtbB9xH++mr6gqc/e4iNwB5WEUgKEV23qEeSLjYPDyNZWmj690PLjeB+tp7UKDpzOaV19LuqClH+V4C16Ka6A2/cj6qA8nSspnci+9VswWHTLZn8aHxrYI2QLSRe1XqrSk40v9ybuLZCbQM70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/KJX/3uARiaHPd+7HO1+pt/cujirI/m53tZuj4R1zc=;
 b=mLm1swKMpKUE0VUE4vMSl5+5Gm9SgU6b4xtDfd3GeEi6+PHy+6rYVuGqtgroLy03KMlcTB38PE1QojjG+nQmh5229R6m8GpRW9FbWepysv+5Erv4NqnMel50tl7kDBBXeJsVAmEfzvFlmt6DcPAUoJvZ+ESVhZVTHAWmk1jDjvjK2kdVloXx+Fwb5CoxjW1IogMQGvSV5/bE1/CF1FweXnHl9pwMKpD2hSLhhDvzMXQFTPxoSxoW4Af8shd48+RfWKPEXE8bc+JcwTe5BCB4Xp4RDkUufHPbusXPqc2x3lK52cQw3/IrKrocHXX6jnKbY3YahIKlsDSTzBdyCqCyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/KJX/3uARiaHPd+7HO1+pt/cujirI/m53tZuj4R1zc=;
 b=HWij/yKdbuUMp4R0Hb6GwulpZLcVdCu1E0U3qDz/q5WlJnzDrZ/kcf6rshB5Kot/gjLZ66IgKsNqbqBogXSweVZ+btihMIAnMB+/4xpnhnCz7rAmQVE/KELV3v1dXwwLAHiGMHNwyx3yCwGzhJGu5OviYibf6IJ58q0l21Y3pO2XzTFw+kx4jlFeYjqmfl1OMjSKDLUVJTGc5fR0Cj8pmVbaUsvvEH5pCMXdBzAbK/y1arXrTFEUU6lCEIpMZdWjSdPgklTt7eKsav/p++MHHisUHIdHz5INbYrpoXqawXPVMLqSuuxwG5Y0nTcMxBz8VGm6yCd0IwgGHjUSAbzrZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by GV1PR04MB9120.eurprd04.prod.outlook.com (2603:10a6:150:27::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 02:05:32 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 02:05:32 +0000
From: jeff.chen_1@oss.nxp.com
To: Aryan Sinha <sinha.aryan03@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next] wifi: nxpwifi: Use str_on_off() helper
Date: Tue, 13 Oct 2026 10:04:25 +0800
Message-Id: <20261013020425.3199421-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261012154759.42423-1-sinha.aryan03@gmail.com>
References: <20261012154759.42423-1-sinha.aryan03@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0009.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::12) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|GV1PR04MB9120:EE_
X-MS-Office365-Filtering-Correlation-Id: e3075c34-125f-41ff-4bee-08df28ce7621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|19092799006|376014|10067099003|3023799007|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+0cTnp+bpXEnT1c1fl+qGo9WJmJCxLahgXxCD1PHgYRdENbm5Aca8coQeYBQe0Lzqh1qKuhKV17A68apa3gubOuIX6QLP7QV6ZLV35UNALH8CIhMj4A4abCXZbqFgF+hY1UoDvx67iar+gaEeUtlxLWhmm6X0y/pLIFQoWP8lErsjiSo1v4xkOWm/QjjZV90k34BahyitlR6M3v07IWurCKFNRiMQR1XuFmV2DUGQ6WCMl91DVIqe2rgc5H6InDvQSUaxrTr78GYn0My6SKVQvrVrzSJtVF59yepHnTg3G9WtXBdb+bQREBU6FktIT1+tUjQk/qB0O441gY1+OTBarjZTmiPZ7CaPHugOwh8fxDpfmqCV/DyBQWvRhibc/W5Zj2PCMXxtcl8zukyOkCQzGQnPTujxY9y42QZp/UOVfwYE9UUaUlVvcvR2w3hITjpCqCrklYnLI/VDUkNAcjvsiIH4YgUhrfGU8fRdS+Lw8lBX2pPx8Sz1ck/AaB5byhvy3iuuqiHHCtZsm9t+n8p7iEHguTnxcZZmtSCttKfESUvdOiX3ndc8HO78R7FA6sC+kygtbdFSR2nEF0H4rFLZO7D53RcNiCDIk8Ila4pr2llHETof7SYMMXGYBFUeHwyO3cxaPPPgbkAwN5ErfMtoZBR14oX6XmeMoYrxb96vq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(19092799006)(376014)(10067099003)(3023799007)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L+XzxSuHBtcV4XChTAW12MhyTEsUB+pCiz2F7stNMqaw+ywuezEZ4ebJBpTt?=
 =?us-ascii?Q?Otc8adefRxdPt7OwUIYIKSb4ykgpFCqsD9rxFKEUtBoTw0eJNxXVifCHN7UO?=
 =?us-ascii?Q?glrlpGU8UgOJpw6gmvYKh/DhxukN8OXxfVUZrBRX2wB4kVd2HzW7KnEoUo77?=
 =?us-ascii?Q?JOg7/DUCrLCMe/9LxDenE4DwhD4/roB7mKM9/NRZl9uzFtRfrXSOli58PUOE?=
 =?us-ascii?Q?5N18JG6LiLPZbqQJ3tgbsCd4rJUXj9W75/+sQ66keZgRvjkmzZDXmWwdS6EB?=
 =?us-ascii?Q?sqFa43eQxzBwYOmwfHH/23baNCvsXy+oOQD+UD85CvtxNbbRXZp3khLwpEKK?=
 =?us-ascii?Q?CHsfdE63u/z2I/Kj00xNwMuYkjX+GX7qAhJ3D2el7RF81WlGSXAtLh1i1HN+?=
 =?us-ascii?Q?Kv4tSAWz3p/y9qs9eXpoVMs2aEWthiwKR2kFV2mOoyttHXplfB1rASTZ4F9k?=
 =?us-ascii?Q?enezjGfrDdZ1ZrIyLaEppsYyUxZEnBdLpy5WUEppYHxkja77VgpO1DMH9NG5?=
 =?us-ascii?Q?Z3rFJAbpGE/h68nVvnMUQfcHrNM97HlVb3FqGq6HVOn1nLkta3RYqh4sKLN6?=
 =?us-ascii?Q?MjNf0BFoORgjTVScZp004qJ43IfjSROt/hyQXoH0CvFqtSHlR1c+MStluOM5?=
 =?us-ascii?Q?Xv9YMpyW4mtYb9VLNC9PTvcPgcUP+wCJgTCv3SzUQXehttbqHcqMJcW7y2iu?=
 =?us-ascii?Q?xqXjLCNqjPP/Qnzx2cZaqOCdCTw++KNbMm9FhDX1iP4QPcR5qtm+8RNFHsAN?=
 =?us-ascii?Q?6E3ZGfrQa16wE2V4eFNHZIxbkMMNHrOwaNkH5UtOyqmaiKgdCTFzHbHsKO6T?=
 =?us-ascii?Q?hygJvfDmfzFT4/vzy8uhzhNz96bbt189vNijIbztDh7HaKcCloxDk9llk9DT?=
 =?us-ascii?Q?JYevRihEPCJt+Oy0Z2GH8IE2t+okxZp24aEBp1bN9a2JpmRoROtFsXqtGx2l?=
 =?us-ascii?Q?fymlbysnLyh/Swi1PbsyjDllNbJ50WNsY+b7T04p/SiVypT0XNHa1yO/d3aH?=
 =?us-ascii?Q?jJVkb/lP2vWxL6q/qNx9p6J7L/WTHgRKdROUEqzt6+meeGCmBkVQp8eiLGOc?=
 =?us-ascii?Q?w3fRyKZhjhplnaiznj95ev7UAz1w4J+FYUvKcXtdw5zJzT7naXVj7mTKcFw+?=
 =?us-ascii?Q?Sj9ZWnkohEqEuc15eeC+zQEl8wFJQXSQUvDdAWCKRCAzBvsnh8NP58eLgRa7?=
 =?us-ascii?Q?6kXFA9duIrf+Sigjd5NIqIyf0z/Airc7qD33V6qJ5+xbLy2nMhDLHYAbJdqn?=
 =?us-ascii?Q?yMO/nN8wNvFzpnKn0tBnKztXydDWKq0gfUbXHZ8W2iIeZ+ruBVO3Fh4jZRj9?=
 =?us-ascii?Q?04U78PeFxR30o9jNOQtyf5JzpvWzgN2gLltgTM/5mBR0WxLBIcDmyRskHx5d?=
 =?us-ascii?Q?+P3X5CedrcaMR6CTUVMA1f6P+FAsEATpjpUJUa8/P0dxIRfWDvlw70G5Bi0p?=
 =?us-ascii?Q?OCccCzxzG72A+I6no4jfLxnDiLsJ8ZgXnuipCC/aMnBq9kBZYaD37gcEITS1?=
 =?us-ascii?Q?ERDitI68kDQVrqQi7rtA465qKKqQGssvAtRxtyogfDxMg0+MAwMUMY0pdQDC?=
 =?us-ascii?Q?dIwDdlrtCg2fxQ5BBMiXuIJT3RJ5h3RbLhaPhFJNiIY5/s47Vj1sXUrk09Ug?=
 =?us-ascii?Q?53K6n99HvTD1+S7fHB3RIWWEzUCoJ2hoBCIFp3CKe5LUS9do+BMUBsaAd1s7?=
 =?us-ascii?Q?CTRxGg3aUWRESGSZsSS6bn12U+4TamgdJjv+AIMd9Flk6Qlnf/dq7Dmo0c4h?=
 =?us-ascii?Q?hrp9AQbnQAwz/wRiPm+4oDQ4mHux4E3oeHx2SsXnisVZoMEr4hVT?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3075c34-125f-41ff-4bee-08df28ce7621
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 02:05:32.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogqzNYfqcJvR1P3eHXFU/Zi6BRiOr3/yET77wDc9plIQWpHHQPsw/Af3hQ+sjTzBqoNd+IFq/dvwokqqz8G/XPJ8vOGnrB/4b03vv5ERwI9794nhjbkqLrJNgblxRmhc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9120

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Mon, Oct 12, 2026 at 09:17:54 PM +0530, Aryan Sinha wrote:
> Both carrier prints open code the on/off ternary. Use the helper from
> string_choices.h instead. No change in output.
> 
> Signed-off-by: Aryan Sinha <sinha.aryan03@gmail.com>

Thanks for the patch.

Perhaps the subject could be a bit more descriptive, e.g.
"use str_on_off() for carrier state".

