Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010016.outbound.protection.outlook.com [52.101.84.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475D74E0B68
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 10:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849224; cv=fail; b=mdf1j6E0WggWq43/Lmoj7AbbvXUOSK0YRlan1Ua+959mzmtJ8Ns2fNTuZAUXV7Y4/lZ5CTCzPXZpbItQIVdfQwriaMusqnZjJVo122eJYEOTpl1qKpsmjZY0sIjyTuFGJzpzDb8ORBuIQnQA9ENVnGfd80k9du1Kdp1owQw2yj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849224; c=relaxed/simple;
	bh=j1cCz5ep+TSajOEH6nB6GqCIyRL1HjT5CmyDj5Ih83g=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=RkqweCAAxP5OnVZU+N1CRNCCo2zIepH0RO9uograWCEkTIGwCUmNtGPfW2/aCQ47pqZvgs9TNcYB2sYwfEkB0Ug4t+RO3FDcrRYl5rkMNHS/0g0+pt01wnVy+tB44pbqHitRSBT1MB36HnjxWlFCwX+wzEgiifBdK9CXHf16NgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Bo2Vxp06; arc=fail smtp.client-ip=52.101.84.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Bo2Vxp06"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikHrR33TixoZhvszkXOaztxpMX4/QPuEWbgEeI2NnUilTnniAgmqmyiR7bMcd1zsIg6a2oOgfSf7lYDxRvWxHk+QH9OfghwfQXxzPRUsouGLHMw/NSgJuaoemeOuJllVx+5zPzzEClyIq2PBWpe/XjMTwiTZpeS71eayFKFVXca4i8Q+s6jXSLGPbKzB6d+2XpZClK+c6dAx1q/muhp12uUUv5lj+pErKRElBcGd/l+6Wu5AOjjruINRy/NeVF4iUp5ppV6ix6eJtsuguXou6lyeyqQrsAhKB/pkyohPD1qr5BveBkib2nkkeE20PT0IgV+CSDakxSgE+Lta5h/D8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GasVeWEk7NGiO79ZF0cD2XEXxGVjYifzDCDzqENJ9Oc=;
 b=IWhalPjEil8MRJ8WOeh7bGKlXBbERGwLZTLTCgnD2/dcITxWWRRBNOsuDpDjTjf4NQhTOuZNErlybVo2rJQ8IMx38gfX5nuiDUkuU5o3KoSsesOyUniQMCBVmfYOzq8HXezpX+pAFE19S+wLXp6lVdgBfDuxN99J4EBM80CQIG2kj2nVL40cVEjVliXq02aF9lA3SgFw3peeIpuAxHbQLSN719QCBTEcNGN341+GNkBJFupFd3LME0/WK6uH79WITFy2n3OHHYKljz2z3QQk4Ldwb0ukVVSPOnj3MyJHtemyw9aFBOGb7YOiZ1ncIKpcgH9+K736tkvYhOV76XtFAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GasVeWEk7NGiO79ZF0cD2XEXxGVjYifzDCDzqENJ9Oc=;
 b=Bo2Vxp0672CMfIe5IHdbBzmYRdFs0+WHlu+kHzJZtLUhtBUrvgrJpbXec4TeGhS3oNLtBkjHm1eGUgR1KFxmaad58PYvAwpFZfHx4H3Pq4DdgIMbl4WCCCA+BUzFSydiFjzBIo4wPV/eQPExP4mjOOAVdsei1c4lqKEW3VlJsKHhJ60rZ+/OJ0emVEN8XA2ZC/euIq5kYpISBVJyANWspnshOcL9OTd9tAYWsmYux6a0NfFQ3ToqiQnwLh5/QQ68rjinqwL80WDQtLnGWkk2h79oXtBQ2rH8tWLxGgb2ZdaBRHlEow7oFd4kKdgqOSK30y6B+NA0zJiOmkvZ/KjkVg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB8278.eurprd04.prod.outlook.com (2603:10a6:20b:3ff::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 10:06:55 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 10:06:53 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH 0/2] wifi: nxpwifi: add TX power limit configuration support
Date: Thu,  1 Oct 2026 18:06:38 +0800
Message-Id: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: cbffd77d-085c-476f-9898-08df1fa3b7a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|23010399003|10067099003|56012099006|6133799003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	WccDakM8Pk5y5MuqFnoMzSC0Vztd0aAFH2UcVVSL5BRvziiARR7eRd/uIJV2U0hf+TDLrkCaHwJ9kNRwL3rqQAbJwvAA3NCtLoAUpUIBQaAeR3yDF9dL1WaNUanJJSg7WvFNIaQEELSBUjkgJuxSIBA1xfamKtHVcOODNpQJv0vBOi4svCxi9AcYYw++nScWrYZQ//L0T+zijrUlyVbqCpAghiR175uENgtjxC1nrqVE5UYc/RbO3zQ7bAYdRXd8WUCez/mk5YsiExOk7Vy+rAI/jjvl1KVzS7WBhHFWoq3Cjb+OsbyJ/qyHF66ugHwBDhJZ2H/h8Er+I9XSimzg3yajpoLuxWGVREIb9VhtQcxOHupHLeVA56oQ7apI2CMTMsR0SM0OVywtOLAsHTh85tajHNUiZxUOdsQjJ63q03oYA65SkcFMvwUB4fCiA3soLg6eXAsf4XI49o458xwsbkxW5qqtYOSqn67RgPUSXnaGkdAUMSK5arq3n8SyXR9S/0YYKJVz+qa+R+rBZQJ2Y0f3O41td6fz2jSjTEXwkY5u0bmLp2xFK5Y+9Div5jThWs3We9G/cm4zOGTC0W+6meIORj/14Iwkh08S6LYpP8NI9IPR0goewbT05x1+EtJOK5XI+v7XuTOrhkEX4cnViHvQY0js4NJfyaRzosOZd4I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzRQZ1NZRTdFU0ZYZ3BFZUdEc2RuZEYwUlJFUkl5Q3JXNG5ISHVKOTRhcGlV?=
 =?utf-8?B?cFUxWHZTNWMvbUQ2eEZMVVBQWnB1YXJMOHpXZmJCTEYvL2N6KzlraUlMSVBo?=
 =?utf-8?B?OGVtWUtHV1FqWkVzWmFUaFkybDh2M0NIakd3a2wrUnVOdDdxUjRIK0RtcUxz?=
 =?utf-8?B?VCtRQ3hXQ1AzS0RJdzlGeFBsVGpSUEwzSEJ2Y2g1RmZtdGZXTWkrVzMyeGNR?=
 =?utf-8?B?Z0xML1NYMGtwMDFGY05Kbjg5VUM5NjlWc2VrNXoxeXNiTVE3aFArNzhsM0w3?=
 =?utf-8?B?SlYxc2pnQ1pjcTNuT2tTcDVBejJCTXBjN3MrbzFhMGNnMjBXbjkzalVFOVFk?=
 =?utf-8?B?NkhKRGFwK2MySWxrTU90eGVuV045a2JFSk5PSjVHY29XZm5VZEcrVkFXQXE2?=
 =?utf-8?B?NWV6bGZscXlYd1pueUFrb20rcG1SWVk4VS9tM2J0QnFIa0toT1B4NjdjbFZX?=
 =?utf-8?B?LzJhK0hFSnUvOUdMWlh2YThWdzhzUnNJZjNuaWlqdjRacEg2TldNYU1udC96?=
 =?utf-8?B?K0paWGxTc0FYRndIOTc0RTh4Q000VzMxTW1ZdjNWZDFXc1AxMXNjb096WUNt?=
 =?utf-8?B?OVJ5MGZNcnhvT3lzNkRrSE1FTkJlbForR0poaVBrOXhURTBtODArM2pFNFIv?=
 =?utf-8?B?UERCR3lPSEdYWlhCU3hhb016WHp3cnhWRmtzbWNQTExFWGsrdVdlTmU5R0d0?=
 =?utf-8?B?aE0vRGIxY29iZlZ6ZkFLQkZrNys4OStUanhIcjVFdFptcDhkT3ZaWnluRW9h?=
 =?utf-8?B?UDRxOUM2SVJzeC9MNVBSaVJHNE40L2VETnY5SEIwZjZJZ3pNRlVGVUxJMzBt?=
 =?utf-8?B?MUFuczlxcURNQ1Z2K2lFV1ZZWjZtcSt6R3JndkloVnYwYTF1U3JZamdCYmtj?=
 =?utf-8?B?QTJXN1cwdEhXYnp5MHFlbkhpS2toTDUxbjhlTnRacEk3VEYxZFBkd0ZGVmdD?=
 =?utf-8?B?TkJYUXA5bS90b255TzJnM1hmOHN1N3U4Q0RPVTVEQ1MwREZ2a1A0QzduZ2xv?=
 =?utf-8?B?RDF6SnVKQTloYi9WV2dMSWpXMnB6VExOVkZHUHFBY0kzVzhaRVZWRkxFT0ox?=
 =?utf-8?B?c2x3OUNmWTlxNml6WFU3Wm1VMEJpb1BXVlU4bFNEMUlSQlpWYW1EZTg4N2Zy?=
 =?utf-8?B?L2YvczY2WFN3dk1BcUx5WTRBYWJDc0NtK2hWMWl4TGJnWGs4bVRzbWhnWmVt?=
 =?utf-8?B?R0FUUnBUZ202Q1g2NkNJd2twcWZhTzliT29yK1RjbEltS3d0REQvZTd2ZkNZ?=
 =?utf-8?B?RDJaSGRmREVKYlJaRWtKZHEwSkljK2JJdHdDaXA3SGRBdFJHY0U2NDV0ZkhE?=
 =?utf-8?B?MzF3QTAxMC9XUzFPWmVuL3VnUDNsOWh1eUo2SUZYbmg0OFBQS2tsbVhLWEo4?=
 =?utf-8?B?N3pPZVFWYU43U2hxNFRLZVJzRE5KaHlBK3lmeXZORnpKY3NDNmdSSnU3YVdq?=
 =?utf-8?B?VFh2R2dkV3RsMllKR0dWM3IzbGNxRDZqSnZFWC9xS2FyVkdmR0VDbWFHcmdv?=
 =?utf-8?B?RnVCSkR6MjFZRjF6ajkvbnVjNlZIMlJnVzlZZ2JsOHhjK2loM2R1WmF4ekFp?=
 =?utf-8?B?eVpuZllkblhJckkrOG94TDFvV0UxUy82UE92WXhyc3E1c3JzalFUckV3SU9y?=
 =?utf-8?B?SHBxemdZUEVyY1hnSHhuQjJOSzJYd0pxbSs1U3VmbzN2WXpjVnVOQ3Y3WnBl?=
 =?utf-8?B?UUprRk5tWXcwb21Yb3Z2NWFrSXNYUnJPRE1aYVM2VGNHemRjRWxyTTZPN3py?=
 =?utf-8?B?eFRKR1kyUW9jT2NOTXMrdmZCdm1peUw2NTdJdHpkWmsrWUhDQ1VKVll6bW1j?=
 =?utf-8?B?UVE5aElHQmxBdWx1TTY5MmNEYjU0UGV4cmhCYkVtZVcxd2NEU20xOVJpVlZH?=
 =?utf-8?B?RWdjeElERHJCL2NQanM2YWcrTXpLQUo0eldCSDVtM2JzRVJRNXdLQjNwaVJ1?=
 =?utf-8?B?MFBodjFybW5CL3hnc1dSS2V3OE1ha05sZ0FRWVdWamhrVjZzQktBOFBjbjMv?=
 =?utf-8?B?UUV5OXVkTklhR2FvV3ZOVWxFVTUxM0d1Y01oUFYzZ1VjWGIyUWFTL203Uldy?=
 =?utf-8?B?WWYvN3ZwTzBBaExIT3Rkdk1xRUNOV1ZIMFVNYzRTLzlDLzRJSXRLaXl5c3g2?=
 =?utf-8?B?TW1wZE1rTU4rVmNnQXlOeUF4M2VsTWFLc0xWQWV2UUpTNFR3Sy9wbG9jQTdT?=
 =?utf-8?B?UVA0dTByeFE1ZFY5UXMwbHUvL0JycHQvVUJidXovYlRRaXlZUW1UU3htcXV6?=
 =?utf-8?B?QlNaKzVNcDcvRmxENXBUZXg1UGlRY3FXbjAzL1h2WTYrUnlsVm10MHpGYkVN?=
 =?utf-8?B?UURWcVZ4WXNWYmF4TGpNbGRxUnJiWnJyb3RtTllVUjBsNjRYMmY1R2l2bk9R?=
 =?utf-8?Q?bUCUdl+/gl/YgE3f+OFd/PZp6+5n82J07wrgE?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbffd77d-085c-476f-9898-08df1fa3b7a8
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 10:06:53.2449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT2R5I3/D8vYjvwCCzYBuk+EXl/2IR8wo07n+cKt+r9v8Rj+RIT455tiABJEuylN4fBXGVaA/IVotr2J/4wg1+eLKORj5wH/ZX0HoVEBXdjCgPDTS47fM38y1WBhgDpX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8278

From: Jeff Chen <jeff.chen_1@nxp.com>

This series adds support for configuring firmware TX power limits in
nxpwifi.
 
The firmware exposes TX power limit information through the channel TRPC
configuration command, which uses a firmware-defined, chipset-specific
data format. Since this format is part of the firmware interface and has
no equivalent representation in the generic nl80211 TX power API, it is
exposed through a cfg80211 vendor command.
 
Patch 1 adds host command support for the firmware TRPC configuration
interface.
 
Patch 2 adds a cfg80211 vendor command for retrieving and updating TX
power limit data.

Jeff Chen (2):
  wifi: nxpwifi: add TX power limit host command support
  wifi: nxpwifi: add netlink vendor command for TX power limits

 drivers/net/wireless/nxp/nxpwifi/Makefile   |   1 +
 drivers/net/wireless/nxp/nxpwifi/cfg.h      |  14 ++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |   5 +-
 drivers/net/wireless/nxp/nxpwifi/fw.h       |   8 +
 drivers/net/wireless/nxp/nxpwifi/main.h     |   3 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c  |   8 +
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c  |  74 +++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.c   | 164 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.h   |  46 ++++++
 9 files changed, 322 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.h


base-commit: 1631d79ae57dce2c5f88ad278307028638a8b4d9
-- 
2.34.1

