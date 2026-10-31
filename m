Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.126
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793469412;
	b=1Fmkn473D1Zd8sIOFa9Re2+I5hrJOSs3I8/6Aw0JHhgP3HIxV0V+UX2SdLAfANTuEK+0
	 qM5ug0dfnGP9r+R3vJFbfkqop4IddL7pEfAdC5OlBihvNIuVbZwcAykDbm7jEp9xr2ZeO
	 Usk1GO1Zpjs1hkwncoaFcFHqtjVBvWuv+s7o2SZtcFBFlLI1H9q3KdKvtk2kYgPsc6yxj
	 BLh5H0IQx87Y0JOxb871Y8FGrFHJgql3ZoXsUDv011Oax4Uwb52gmA+tH/FXMof/uYl10
	 jiDQT6+5R2A+0taHK9FnT9mO5TDuEj9DF7HnzzokOInDb8XoVSOKe5k5q2C9nYIea2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793469412;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=bXRdOzVxLK5izumHi8qN5CTAa68ENMLEX7/GD8deYBY=;
	b=Wtz/caO/YwsY+biT0B2Y8+sprlDWnfqPKsIiqfI7ktuKXwr+aTzfgJkp3hAF8x2EYJ5p
	 UdUySUmi4quCqJ31xDuVghXBp9O04LrAH81vTeE5jOk8wYpYSEoffaYnCSdL+7BgoISF3
	 F1T51BJGPMlZOFwKqoRm1714EvX3sFWiyIrMzcW4Zm/f6t3TI+OFY5N5NFJjk6g0+1/nq
	 4AAJ0QMFQcMpzBVbpzTId+10SqWLSNn7t+vKOQ80LXctgwoXsoctvTT5LkBA6mvLVRM4Y
	 dwc6TZRgvSW5CkjfrWrrdPrQxbQ6ZNEztQnvv0ap9T9CMaEc7ypOfrvIoBA6+MoUJpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=jFRUy092;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.126
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022126.outbound.protection.outlook.com [40.107.75.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1024B606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 17:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1024B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=jFRUy092
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUqhDepULKVDoBdLOuDFtqAtWqzqdEH3VUPVzFBMWdtqth4RkYPXrTscQLI1TtqQ5DWtbg3kl2wrK/S4BQ3P3uOfYVzKwbTzfB4KRNrf1qRWrZaqAUeoulamj7NnQR/dAZmfybdpiGlHMfMSX1SgjbQBRQ95UifrlxWaRy3nlJb66qRFcAlpk03QD4/RoQvOCwyEOgSgZy720XdT/pcL/nbsXxKlddpkEBtEL2LBjwJyKXIyrX4J3Bdp43KVvp9jAvH0ZfWM57skvDgLgTzXMNyRkRD3chluImHCTQzPDFb5VlhbQm6t/PuVXN/VXdOgrahHX4EXJEUxwVWnU5tCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXRdOzVxLK5izumHi8qN5CTAa68ENMLEX7/GD8deYBY=;
 b=mqB7JCA6a1IJ5RmVIBuEB+WNOJBgQ8j9ynBDHvv6EwOBC7K4hAt77/DKKWrryO3MIjJeeFxvKsy93VtzmhBe/A7vPKBBund6PA2s2RgP2gluTmIUJ8mEUH9IzjBoP2uKZ3OTwfRIUlCTU6PFnxtWLykAZbcG3+r9TCX7MI9aTm+hDrmTJeytrukWYSAMFpEM+6CHScpcUYpQsFrkoBbScVm3lMHq5vkzXtpHBdHh/ZzS+7muiyB/oPojihEWy8ys8jZoUmglzucISFNbBySkQ8Zwyot3m2m/eJ0EUSd9sQHkIaNSNT4xZVTp0aFMfMaEAN0IkYe5xbdnv3t3pN/U0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXRdOzVxLK5izumHi8qN5CTAa68ENMLEX7/GD8deYBY=;
 b=jFRUy092aHk3uipCh9vbbd/iut992DDn5NY8N4IcDz51WNqfRm/VR71zxv2CY8SGlAMIMu4cV9eCWe9ZDpOR+6ECRPccbK1KiqGJfcQX5rFsPs8TwPmJoWqAs0UmtZpdHjw8EzDdmrfgmv7Yvo2ACSvMD7h0nmmz4YtDOBP3HWIac9lSqtYqqvqlaT1GpOdsl3zrHvqvAaJi9w/jXJCd8tmu2EJr6TIAqFecYuNTfWxQYuhdZxasVZdPHXA12nzJrL7IbuDY5sql7ysBbP+yGsHxzwOCiMaUVJ1+bKeemw3fqIcucDtgoypEyjLduk+AGcr+mc7Q1lrojGisypYICA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by KL1PR01MB5904.apcprd01.prod.exchangelabs.com
 (2603:1096:820:125::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 17:56:44 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%5]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 17:56:37 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: linux-wireless@vger.kernel.org
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v2 0/2] wifi: rtw88: check C2H header and payload lengths
Date: Sun,  1 Nov 2026 01:56:19 +0800
Message-ID: <20261031175621.2228762-1-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:295::9) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
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
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|KL1PR01MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fc76b3-f91a-40c9-34f1-08df37784f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|786006|366016|1800799024|376014|52116014|38350700014|11063799006|56012099006|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261026140227099003|261022105027099003|261022075727099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UFrpy/UDx4ni+nyxGXu42nbydvuYIS10hdJ6LIp+gWnVN34nJ1wmrg6iNxvH68YytbijLMj338MmEZAThdPrirxJQuZXEldFP7HFtrKtxyH5wU8PqB4W+UfZZ6QuF6DOtH+CPAWmzWS2Y6AAgYBHYGOV3JGJQz5BZtlTScKgWcEIXfCPScaCe9/bgpP3WcQFAky8AcO1RsvjQB3ieqlWC5Jc4OPRmuihz/TQMJkeHHr+9BTiZfWvEFvhyYgFIEZoVy0xOG/w+Mh8jk8xqZ3p7pKBIgvH0zIJvQC6TmjbYsNINxxNLlZic1NoKqyYr3HERlZ18pvzKzqoqAgBf1eegVyfutVwSLyQpVRF5nnOTQE9vl4mEjj0kqLUfvHGwNLDgVpFcORdpgw/Yeh2ue3nGRXlO3D2CyAjtO+A0Pj51utt3JvTIS+SFdVA9hbiL4u3TnWeHA7OQn/Qhh44S80Nh6NhlbQffnPOGro7AXKCLeL+npsJXvsV/b26nAGRnd9qRvhDLrwTSxqZCsMDq8ovGze25ZyUpiwlyaGFQhrJLMe6Sd2Rs4LeChzh/kPe5smkX8nsywsVOYkEOvwJLua5Tm8MCBjbKoAH3K4W/viHbrvFsZWUnAleneFXUDfpu8DMaKIp1HlcrXKN59AB+LU+FlJ05NiiOcoIxMzQdoHtiH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(366016)(1800799024)(376014)(52116014)(38350700014)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026140227099003)(261022105027099003)(261022075727099003)(10067099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wgnjo6apwAGtDSHoA3N8ViFTR4faoAMWszpnpQELQMDm0bohpX7NstxLn1vx?=
 =?us-ascii?Q?6oOFCkJetVuCes3kfcWyvWiwrfSr990UXNZLIUyH74fyZhizdwRxRIE6x9sz?=
 =?us-ascii?Q?sjGBxLUCyhPyIkHI8MMRpXMQzNGGUHxJBqk797Fu9+VIEgdwQ66FW+/FFwE5?=
 =?us-ascii?Q?q/NjJiWlYERkxbqqEXmtHK9C9YS5djfdCXYx9wFOQ7tA+bHLT+LqzBVDH29w?=
 =?us-ascii?Q?doiIBZpI/0cPU7bqYT8NcJ6YTTGhjNeBaAcEQRuwg9xS9qsjEuRMR5Jm/ox0?=
 =?us-ascii?Q?fSxo3tbwJYAQxZKk3YZ36LhLBeftmKeKnDcmCGeTfaJqanOhv1ow6hL2T0yJ?=
 =?us-ascii?Q?1A5FMItzwt3eNwIXey2rudiGIuj5rFvMf2scppnhEfwcprh4fLJ8KEQcQZoy?=
 =?us-ascii?Q?3hw7FQ+TWYJyN/onZW3qB9RkBCQmMiYH/RhhuKjP8CVKLQ7zHEYcKMTG+Nyg?=
 =?us-ascii?Q?8lQnzwl+rcSg0RiSh8KDBEDt6uTHhI3D4RCJNNSKMCMSaZc7bbTKZNBSdQZ4?=
 =?us-ascii?Q?I5WKf3D4CZF4nTV3imhyS1ceWHW/FtzvNjqvGD9Yv+KIuMWYD19rslhD4cQc?=
 =?us-ascii?Q?+dDU/OAhAoIny0izo5Lr+JK6wxZHoyOriPTDcYymJoTT8FOv3qB6NoUBbQS5?=
 =?us-ascii?Q?B3/8MFCvHN/2/s0S6izgv2d9YT+tvu1wYNdnjoJRK6w5T8CGW+L9vZ7h3/Jn?=
 =?us-ascii?Q?nK2ui4hovJJTMv8j0EDtdF7Nd0Iv8YEFOplPlbfxGO4Vt8B9Qe/WXHGV5ntw?=
 =?us-ascii?Q?D9ef2GEGl60QKy83jl93wsmhzWVRNqSi19f3hl1eyk3bHXHpp/WA1cb6xq0x?=
 =?us-ascii?Q?CTTcDQsnymgJ1BkncWa+YNBDXoCV+CURTuGCWGnPu/vKbDgNSfblgAB+bMOJ?=
 =?us-ascii?Q?lOH6PpZqX9oO7VsJjHCjk9suiJYpyOLqLyfoenaOW1H7PZLJ1NiGAnJOFqre?=
 =?us-ascii?Q?YZaIcCi5eFb4QyHTpavjQn/NiZpXw/QLe21BDMWkfQ2CV8Gcymww5ZEYImla?=
 =?us-ascii?Q?1Rbu/9jXU+sARJ0NZWt7SYi8DzZfstmUhjInvQiLeU3t5lQjmzwfQbX+yeKl?=
 =?us-ascii?Q?qt43bR4m0DIrIY0yaRiyM2/RqMBtZMGFOH1LUZUxZiGIRsPGsm72wHL0gt1y?=
 =?us-ascii?Q?KoAK/18KaEHpzDwp/smfLe2IebWjAwVfHCpgjeZ5GZeofckCuZafwu7PiQDK?=
 =?us-ascii?Q?n/Vkn32zHlZbsqe3L4MReFQiylCrYKnpXX7atpvctm3Rybo0SQ2aULZ3j/Y2?=
 =?us-ascii?Q?M+gpEaptqJTlbhFW27oOED83xItDK34queaSTJ+9MdGDbfuPQNFcYm9fmc7p?=
 =?us-ascii?Q?xjdRNjpuyTrYpp1agd5lQ/PYViTR4sZIBUrEjS9P7KP1QC4JFQQhZkUKERfP?=
 =?us-ascii?Q?jEDmPar/ZhuquYCjCkmQ02t1z9aBAdFmDUpd22UEwI5qeIm2FJeapDaFAwOO?=
 =?us-ascii?Q?UUKQEgO0jFw6S9PV/4GyVn5SRD1ulwyVueBtHhaDcxHdxD15kUct4u3YkQv2?=
 =?us-ascii?Q?FgfEuIGZ8YKdbigG5z3u+qkIE8WkIQyxa4OCrYS7gsa/1Q8voKXKEegxMcK7?=
 =?us-ascii?Q?TEkwCsE3E8aVfcB+IqDtIwzfpnvXtB4hg7BsjPGLnZYc1SkXsah7F36VEV+m?=
 =?us-ascii?Q?4u1QfqdJKzrpSMa9UyeQSU9bd2WmyGVO6mHnPuTWsJs7VJDS6lp+gVkBf6oL?=
 =?us-ascii?Q?vjSan9jrSSgW04nbAjpAvCTDxfcNPCrD+V+zZYp1+Cf9Cm0v47WJEqhODJ2W?=
 =?us-ascii?Q?LZXigReeDQ=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fc76b3-f91a-40c9-34f1-08df37784f20
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 17:56:37.4553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hrkfd4RXRV7CP93kMlYeFN1QjUtra+W9YLAhQcYNG7VCUXll6z3wkand9tK7GzMvyz5UdCrAq2tJRXpttXSz5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR01MB5904

Patch 1 drops C2H packets that are too short to hold the C2H header.
Patch 2 adds payload length checks to the handlers identified by Luka:
scan results, coexistence responses, HALMAC extended events and TX
reports. The header check remains a separate patch to keep the stable
backport small.

Other handlers, including rtw_coex_bt_info_notify(),
rtw_coex_bt_hid_info_notify(), rtw_fw_bcn_filter_notify(),
rtw_fw_adaptivity_result() and the GET_COEX_RESP_*() users of the
queued coexistence response, require a separate payload-length audit
and are outside the scope of this series.

Changes in v2:
- Patch 1: print the C2H length instead of the full skb length in the
  debug message, as suggested by Luka.
- Patch 1: clarify the description of accesses beyond skb->len.
- Patch 2: add payload length checks in response to Luka's review.

v1: https://lore.kernel.org/r/20261029170017.832708-1-hhhuang@smu.edu.sg

Huihui Huang (2):
  wifi: rtw88: drop C2H packets shorter than the C2H header
  wifi: rtw88: check the C2H payload length before reading it

 drivers/net/wireless/realtek/rtw88/coex.c |  3 ++-
 drivers/net/wireless/realtek/rtw88/fw.c   | 22 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h   |  8 ++++++++
 drivers/net/wireless/realtek/rtw88/tx.c   |  3 +++
 4 files changed, 33 insertions(+), 3 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.43.0

