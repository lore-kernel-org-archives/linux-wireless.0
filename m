Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011053.outbound.protection.outlook.com [52.101.70.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FCA480350
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 06:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392462; cv=fail; b=Gn9DcmxHU3506o/OtKgis/ozd/ESypRuf/rxtRWr6FHMI4UejN+r5hTIydL9elmq5QEZY4rzJVds4vwad3EqiwEYNmRzoZAOHodxwjzjS7mBSoFIBD02CMBUFVNmXm86g00t1BY4lJxt0LCpsIykq+BrZnWtpbYJNiIXRc4niRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392462; c=relaxed/simple;
	bh=BDAs9PLM3g3JBXTqJSnYbsmqk6182A7Oljf3WJ5rIRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zgp2Xl0VRtr/mL2xXpILm6EaxD6cK3fu8LrshgueIiwOrPIvc0kgtk4GW7KyKZvq2leHn30f26Fj4FNfIJEEmLOsrCFubIhwN4EYTplg/kyzODCCDVwna3c53ePf+MD++HDOCYtnjj89DANYno5fyW1/agN1lweqIIMrUZ2o5GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=R1o41Diy; arc=fail smtp.client-ip=52.101.70.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="R1o41Diy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Alg1/MD4l4p5lMJXpJkHWM4qzpj30Vq0yTvWbdTqa5PN4i+b7iemmwGPgNSTCqjOfIagzmjj8YfNDmZ8mPjWFu1i3Bw+FU0vvfRoihsEdBp7eQwOgoDKOK7UOafd3QAQtmZ+ZEhSpn1jYerTrjOYnEDHYCG+A2iFVI56/UbYOWaqNn+Qj8QIuhJYu8qAuGaBgBM7xCAJqgykly6cLmCDiglQS1H9fMggcbOxEL68yGgEHceX6zi9682n4oYVDX58emq0BOvNY8O+tFMZOzMw89XP1b6z58x6JEkFlyr4pnQ62LmgsXDFxji4IWIxkLgEv/EJqsMcUlGzvj4RQNo3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DHup3gs/qgDKi4bAWo7ufUEXbgccsZhNxf/LHQLqZg=;
 b=exe3P5MUUb5nX+Fj7M70PxuWU3fMY+R5mQxbUPJJUXVjH/narli61jCuvjpSfgtFZ+GiaomfwAi8FoAhLW6DQytWLDk1no6Rn/McFKbPvQCqrwmCmOTFpCGIblK/S9o8+5oxOvYxWjapHMxyL6CXsgtuG0g5sl5UlCIxUmwUoaeMXNLahwCm1fUIwWb63pXJ0K0sog4MaNpDRlAjJolnozfAh1XiPWTpu12u6Y8AC69UKz5br5o7fcsrDUPhfYnEAsTCYuhGMc5/1Xl0gpH3QMJD+xG2LRMPxcnXQ1KPfiT4DhivG+b3lIRoxgVptaYlb+uazd4kuK7nIfyGbfEf8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DHup3gs/qgDKi4bAWo7ufUEXbgccsZhNxf/LHQLqZg=;
 b=R1o41Diy5ee+PDWk5OSWbtqmZAj4CHb3L0ju/q0Ip3SJYNnLDOxhNcdnGnJTXPlR4w+eGpfArt8lazuNQO5xa5uFEUIgo3BJz9z1E8Vs6O5gtAxtODMCqVgrYgAEBQ9tCG16Qqizr9LZ/agBJEbtmnvdHxVD2yJSskimHYI4db/zSNPkWE9S//M/4mDy4a4h70rc4wdG8dk7JpE6MQkKO3/bYU3lndmvuB37reYBHnjmM/pNNDbBK1TOYawNwpu+x0n0PMH42VY4Qrg+pBWbLZ+8edSsqLXD2ELBSqCsAFJJrFtf4TV7E0XKiXIkxOiDeUtYKrhBz4AEop3hqZCPvQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB8433.eurprd04.prod.outlook.com (2603:10a6:20b:407::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 06:47:38 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 06:47:38 +0000
From: jeff.chen_1@oss.nxp.com
To: Vishal Gupta <vishal.gupta_1@philips.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	jeff.chen_1@nxp.com,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: nxpwifi: synchronize scan cancellation state
Date: Mon, 19 Oct 2026 14:46:48 +0800
Message-Id: <20261019064648.3606059-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015113433.2312077-1-vishal.gupta_1@philips.com>
References: <20261015113433.2312077-1-vishal.gupta_1@philips.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA5P287CA0223.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b4::10) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB8433:EE_
X-MS-Office365-Filtering-Correlation-Id: 4734765b-7aa4-48e0-f5f9-08df2dacdcce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|23010399003|1800799024|376014|18002099003|22082099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hQSZ7UwBkG84F7vSi4tvEj91yzANzvFI8F8CjCxtIJ64yBjOx9zuKoop0ezQd0Xhwv9JT7xJFfvbtNtl3rIWh94MZZQ99Cvz4BdwQWrxUPpqLkhPGosd3ecyHrvjQZSaAI2AQUgyUEjuE8lOb1vXBB0sgy9wyrmpYOxXMrFyxT/8nxXm8vYx5Rbygq8aplST24AK6QojCpFb38h8x8siHnI8i6Px1WF5tRQhZo9Go3fwGMB1UnDWtd2L/gX03plO3qR10QXq36y5JD3m8RmiVB6f0PdUkCDyijc9OE0szTWUzHewkiwJxoKozmfl5rmn1meYclrCL8o7A3YaJ93dZ7EwmOvteDMv/zVVkZTgX0FQoqsjOBDCd0DJqZLKA/K3AFCjn49dM3phm0r2B/hnvjvU4Gg54FZoHLeR6b4SmJYldDWZi0zrkSAIGto1/FOwGQlpI8c27ARKrnRQYC0DEMu8IHDKLwgtAjXdScuGqdglsjb+NrrMkz9bincFcG6Dzkxkn+J1r2wJa+Yiy5EDlbrjYZy8Mp+2Kb44+GkVYXAwCI+wYCTeWa2U3a58AyjtXT57RAlvGtMnbOidtlDeUas1XzK+jOgTtgONyrPa/qrlzLwaTX1ZuZQDDiMXxImlsFRTFtS73439rSdDOLV0qvzVAaeMscfdnpNnFWySYY4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BBhV9Na3XZfxX0DaRSVZNX0Ei1KhpSSmQehcpMp5eEkB/AVTdPo6d8+wIYpv?=
 =?us-ascii?Q?L5Cn9o96FM0aFdGACQzEoZ8r/HnV5BF2UzmjBJUhEgOS4ewr2x8dfFi/XVte?=
 =?us-ascii?Q?QHagkCugK3VrpbprwiiN/JgwLs2Hqc6rg6aktRGJDbM3oWvF+zrM51FODqdz?=
 =?us-ascii?Q?S41rR49Q/qZD4BNAoI+gMXeYK4edFEYMJqe9LVJzpJ9Ripu6Uz6aqfEP7Pb8?=
 =?us-ascii?Q?Hkrsbjc4O9/XGFdADNC7sVXQoshSomDCsIy1uTqTkYYp1kS+pJgKDaV5Kozs?=
 =?us-ascii?Q?jLvxP0HKPbYmj9I+eillptjdxrvK+dZkjhn2uHg7NuySXFgeWj6Q/r2sGLPP?=
 =?us-ascii?Q?cOLdfdCyn1YIsR8gFm+vZ4io83M036Jg7omz3jfPxJsCCMeC4NKdYr8MCKa5?=
 =?us-ascii?Q?ooqYYsmRQGUjnmepQmAsoFfgdiAeUQkQ0ESxOa+xonKQEy3RYIk8G9QqknWq?=
 =?us-ascii?Q?erW7+Kd4jB4ARpmUGY2tBPFIXC0zrU42cZLM79oOj82yOVAzTYzfgmcrb5XN?=
 =?us-ascii?Q?MjuKhvo1PniVwfgP5rtDZfhOKQhx5u69noBQYVXsnH+GammG44BUf3TqgUiv?=
 =?us-ascii?Q?ajo69XRAm0CV528dO9mXnCreZujTCU1mJQoZ6Alu9EzaRoR3hxzekeGmVLir?=
 =?us-ascii?Q?IhpDMKAezohdgqgNTndoC27NEXHkA2UpEioFwdUSPaK3l5MTTTsc2ujfUmaF?=
 =?us-ascii?Q?kYzYyKTexmDmHvIum2wz8b03IqkOw+wb4b2E4J0Et0wv3ROEMeZAmlRsc+ma?=
 =?us-ascii?Q?0TS5/MruSt54JjFmA76XfXVhX+fkrre9iyQYyLlpppbSX7xombcUNyDabgq1?=
 =?us-ascii?Q?LhLSShocD66F4j9p07mc1pCEobl4ipviu9ENP5OZMrh+/kwd1mRj+ZoQu4EN?=
 =?us-ascii?Q?Bj7pJl4VJXJIi4Lg3LdJszsZnrEI+pFi0VMVl43asgchvAjtmtm7PbAw367D?=
 =?us-ascii?Q?t1RddfUuKQE+wUQR/fIZXvv2wZ1vNf04Zos5ExbE6gqXd2Hqe10G8m85RmKL?=
 =?us-ascii?Q?1+gVERukPMfg83IKBAlGIWmdB2+IpcXYUmhP1vaRIVVPHtmIKQx+IqOVe99m?=
 =?us-ascii?Q?DF5IqJ0Gti3lHThlTzLqVvwO0f+hBZnvZyuI3sEkcu442W6U8oZOsVU50lRQ?=
 =?us-ascii?Q?EhglY9wWuUze21EmvcgzUNdYB9pFarcQxkoauk8o/zo7JD4hV1/XbVfAfTGt?=
 =?us-ascii?Q?OkUwb5ZPfBYqXktgxX8fv6UDgAmFsBHmy0M4QiCrCOYhOuR4y/rajPiB6HCq?=
 =?us-ascii?Q?YzO8nK3qRZQjFYjjw/hS70YXUIYT0YqHKo6EeQs5qax+KZYMDuRVa1I/6c43?=
 =?us-ascii?Q?e70bPIE+k+pXnmWgBDQxoz2lcTCycQEhXs4PW+8+r2teWc4cI3cbRQ83LTzP?=
 =?us-ascii?Q?LKbjHjKrouTID7SuBANwGvlGGaFGHH6CjCF3uM1dhqON452yOLwV/+Ej4CP4?=
 =?us-ascii?Q?GEOQyM6IXKssmWKfEfCZqAsQB3tqBhuhUF8AAQESbeqo6RHyxS9vcAOuF757?=
 =?us-ascii?Q?cBaIcrvz9Q/YP96sCHYJgFnu+t1FM/X45JtxHzs423m2HhwxFBZw4YMxAk5V?=
 =?us-ascii?Q?i5QonTo1tLLHH5P/romUqklhT61m6VTXm09ZKAOZIb3o7zeW+8UG0hGtnzai?=
 =?us-ascii?Q?Qk3hUX5aztphAzQw2sdYQSD+X4S5jdB7vq5Mq4CzMnazTIYy/QbD76jHcX1c?=
 =?us-ascii?Q?uVH5Gz+uOMVJAT7HRaaQfHO0f+JMGG18+Si4WWBEX1uYjrP1GJ0fGNDlwS6U?=
 =?us-ascii?Q?slo0ZgjQZtk6A4E0r6q6D5qS+f2T2NnmB3pEhRoqszEGRMexpzrz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4734765b-7aa4-48e0-f5f9-08df2dacdcce
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 06:47:37.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0swLAXeF2F52QDvZFcUVdLKawkJ0RyIs84U/cjniW4AT7OD2YTcpStChAR/nMQOLOVcVWGGFjYcB6lgi9sOH8o4vSFJ4OAIFY1IIadM9XKAp8/rEmz9pKFfFW2JUY3j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8433

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Thu, Oct 15, 2026 at 01:34:33PM +0200, Vishal Gupta wrote:
> Read and update scan_processing under nxpwifi_cmd_lock so cancellation
> cannot race with scan state changes. Skip scan completion when no scan
> was active.
>

Hi Vishal,

Thanks for the patch.

The commit message could better describe the race and the competing paths
involved.
 
> +
> +			nxpwifi_dbg(adapter, INFO,
> +					"info: aborting scan\n");

Please fix the checkpatch PARENTHESIS_ALIGNMENT warning in the nxpwifi_dbg()
call.

