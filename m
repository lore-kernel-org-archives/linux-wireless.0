Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010006.outbound.protection.outlook.com [52.101.84.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A64E31E852
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179081; cv=fail; b=tlf0+nqXsk1Z+eKZ+woCeKpXqY8vTAZHQTIBBN71BFS+ex29dpb2hyB6Ekt5MkQqCsIsvGVxvUWy3WiNP80mtIe5ocl9pfPeRse+FnxvJ2QHe7LmjvaYGs5XcdEXtelO3VYJoFi1eIjSKPeMf7mkCUMBp45zOExzPYHiYqUGSWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179081; c=relaxed/simple;
	bh=KBvaoCkoo4W0Dr6S5p3RlXENeFOZBVZ8+w7n7pKWSfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VBjBK6sCIaTSdpMLg9SG/JWvQxpo3KhJzNZus8cX3eXmGvt4fEGj7lo9VTZwrj0iLfUui1aVtKRdjqD7GLYI1F3ocLCQ63wwCWfnvL3Os0UpHYxoVRJM1g35TaRdoVGzRW7Tiyty/slSx9dAWNU78VHHUb7A9DKaHAOStr9ydRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=EfCWvurp; arc=fail smtp.client-ip=52.101.84.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="EfCWvurp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9a4gDXsoVAdFfGcoKLUtdo4rEYTcW1t7lqcKUCDsTuEW5Jyo2UH4k8rvcQ04qbwcD7eeSIJRX4fi1bK6v2NPOud+Qidh5NjT0qEOvMU/pcKQvpJgEwip7MoRg/rtx4Ci+WBjAD3ADU5QM0Ip4obpJEGhV3iyWSuGpVSdCTYxA1SQTm2xRQbUq1hQjVFRROKWf0I0x1DQE6tTQjzOTNe12GVxzgmLV3+M0D8qiUBL24qdZ59OUp213hrPspV0RpO6N+FSzmIzo0v8LoQeUQs2P0C3vd0Xqbya2zHMFjqTNgRAF/NujIBKjO14SQvldFSlFIIVXtcrbv8jpc2SJvcBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5EyHJqDF6F2JshQHvnIvmV4PydTjB8wtrypBeWo+Y8=;
 b=K7pt7nvZYxtD5zNqSnFVRLqHkrsRPTHp9ZcBhsB+0X+5HfJ+FSsRQ8H6MmKStBsE7aBRGFfCZT4ccAw5yhIFmSNfB3ozeL8na20VrQEyDnr3ZXEhbMPlW1Yy19O6zHTSQx5wBeda8e4CQZsgdOkk4ezXLAXErkgxPO7sRFyPPL9mySJbYDJF8E1JTncEIDI7N8D1GSXDNZZzUYgUJa+dEvgqlGe3UWgfvOoOCss2WR0PCu3iyervaLDfdKpnfhgqHjNqtcG2UDqz3sl31fFrnz8lvHXzyruCP2NxuXB7PBKGaD5lfo/GYgGFSWyXs1nOGArHPQFPnH1DJ9zVzh56Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5EyHJqDF6F2JshQHvnIvmV4PydTjB8wtrypBeWo+Y8=;
 b=EfCWvurpByo02faEcNvB2w66k15SG0xDNLE9SCfXcXwJC0LZwvmcxljXmD0hTu4GM7ovsJ/4tdW0z6Rb1ReSsprJRpDdWCyBtW7dhegHThoJbnp2JQ1+ZTcduhfeecyC4xzl3Iar1tGz1u6Yd+WoDQzGpcIK3bwvU86J1Sd3Z4UILH6im1yVAs8wmHH72mOeDuQiaQUCPTA+44lGHiG3pSezKIdo/b1l2R48dYKL20UK3wlRRIz6L906650bJVtEkxI4I+6pgJ/m3+n93PRiUFQGtEr0bXu/OFzYRPc6S3xUu2t3cyVmi9WQYgSTKu0zVWLKI0iCieVAlje38HQ1gA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by OSMPR04MB11293.eurprd04.prod.outlook.com (2603:10a6:e10:93::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 05:44:38 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 05:44:38 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v3 1/3] wifi: nl80211: vendor-cmd: add NXP vendor command definitions
Date: Mon,  5 Oct 2026 13:44:12 +0800
Message-Id: <20261005054414.2874415-2-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
References: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::20) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|OSMPR04MB11293:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4a09d4-b927-4594-36d8-08df22a3be6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|6133799003|10067099003|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	MJfRMWcEO99Rvg6gWjKwnwYDcpoecTGRTzR4hB7p46hDYfkpo/by+v69rwFyvy1DO1XP5XHtaAZjivf4Cn81nk2915s8VWfUPVQe1UNJaM4tC9VOfRo3NzPzgNUHPDIxEkzVHdzc65MAFqs70szbjIRIOTgNr/igkA02BXVsW2UtAoE4h3bh14WQcaJjmCWv2h8DPBX6U430GJvfgWX0CdExOIcB92i7QuIETvoc32LUuXGAJotu7F/BjI0V3IE7cEO2YInXxkDtJo+kHX0r4x7G4dIZzEBq6xM1qOWHKbWxrLVpeeyKBWQggkAddxysbIUKLrTqcGMHt0iJkE5ZiE1gu/y6lkOYrUbGcLahkHRblAFsR9OcHSBvIPWBnwfYe2FZTsY4NLYVgtxt1h/eSlBaF6dEs5m1k4PqEcdfwUh8uCrVlaKlvHXI0UpaGZ64ayahOPyz96UwyNTOPgtbeS3+IDN0VsWH8tvQpXg2C+9RfcTKMAxjr2ukpLINppeh1xGUCWIbIGeJaDALlDhy3hRWvYXtW38pUVEa2SYbxvSQSCuKKIwct6Xj7Yc8espUN7U5epWnWWqQikm50s3G5NrQP4R77L3wcUzq9q9n86PrTCmqEBolKzvjpLQMBUKpGiv3uvnhU6P08QUo+EM2RfDzsQdetZ4NkOPREgnGNMQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZAss/Giq4oOLjZJ6JZLH2TQsegZ5lg1UpeKSli9vfwNn6s7jMU7OkhD3f2dF?=
 =?us-ascii?Q?8MsJpBfD3+nBGMNhM/zi35eLLS+pg8TegTin06yRFkjvVvMHJiQPwISvoW3g?=
 =?us-ascii?Q?o/LIVPWEq/AnG3menAUINnqaoKJspuIH0Tfh0SAVj7UCbol9jE50CJFhlMYs?=
 =?us-ascii?Q?d9ErGf1X87m7If2WBlC1rAHARh4sQcCBBAyLMd7yEuMxdGuDd4ZzoQT/ws9e?=
 =?us-ascii?Q?OJsiMy4EGooKD2Y0WxFhV//DeCsC86rKsNtSuDXwo8q6IXFh6MZ8I1y5gSP2?=
 =?us-ascii?Q?JIHe0umVO5oCqehauzERyFn5LMQ4f9ASxgec2c93My6YTlkrzfi6rDh1llm1?=
 =?us-ascii?Q?PJWzcruJ27FWwWI3XCWCCrGjAOoKEgpeHVmoSTagNUuc6sjubhMXkxwez90R?=
 =?us-ascii?Q?0/Mws/eth8/Ef4etgfrYaS4xSFrOrXRZ5avQoAhq5kabHGkUYMRaQF/R1bKi?=
 =?us-ascii?Q?I1PaEuSfQpjEZqJnY1WNjpESsMeK5alAzN1Tk/1iLvi0G+h11M5z0cbzTYyb?=
 =?us-ascii?Q?6mNlu0QdEEj4BiDYxxstiNwayTbg4ZEY6RHlw1QADsjb/9HJYApY2YhELfUb?=
 =?us-ascii?Q?z5fzKtoyD/CMZhfolYEg641eyjJllZXvbDVatnk84FL55yWhuFoEf44NVD4z?=
 =?us-ascii?Q?tDNSrj6KN2okGuen80GsZyH1bxg1jq18kL602g6oFncyc69BMk9CsHm+ES6K?=
 =?us-ascii?Q?UGslcm+b5JQi+ayfjoEWo3+1h32b/RB7cDpptt6MNtxOc4BULlX6Hvw5nGFc?=
 =?us-ascii?Q?06/kyjIBPXJhya7BH8aXQuJ1r7ERf8yNxHJo2w7Rc20Be/PUNNfL20L6edNe?=
 =?us-ascii?Q?fEkcEqCdTmWtgibfo0HOt1tuK9GD1/kYlSM0hobBI8yJqNzK7NBUxMUKUhTy?=
 =?us-ascii?Q?hWeVm+hXF7jRSgTW4Y4SexU+98a2xkqUhB/Pcpu1vEFz9EYmB3C+Pa0ASR5o?=
 =?us-ascii?Q?okzK57YAeqDYGBl32GzY/Qc1yUGBbqE9N/emnwjHW+Loe1Ger+aOcawNz2Jo?=
 =?us-ascii?Q?vXzUd37LqPSzVUDrXPlN0wMEqb7CW8S8uAbRkRe729zEcWtieTSHyOEmVVrs?=
 =?us-ascii?Q?v/y+MomKi/6ncevpdhNtZ5Mk6JrlyoKYli0jmDduUQ19DI1hoOwLTlsVccf3?=
 =?us-ascii?Q?VT5tipKHe++hCEvXozThj7SEcKIRu7CJer37SsesYxpDWyaL8busJmSS2wZe?=
 =?us-ascii?Q?NL1M4d0Yxica7GVUbnRgdEVM6/JKlxFxkuIUAQvd5fYCnWUyzDC1pyfj4NM7?=
 =?us-ascii?Q?4hcIne5JnNDZy3sx1rL9TrBeUtfAbIM6T7zabe05vPQOfv528wZqlmaehJkp?=
 =?us-ascii?Q?1kC63KNJQMZzDQHk7lp8slOG+9ALYVz12d6xVOi0ST+2sbQiH+UabveCpbEv?=
 =?us-ascii?Q?OsGBQl7Zv3uR52UKFxOna/fKSD95A4gxc0Pe0OTlDt3PFuMgrg9Jd6PlFuua?=
 =?us-ascii?Q?Ud+2vEYtPJcmoZTRLOSI7WEwoCBKgiZ7miy6lAXjSkOyom4rKQQYkZMGRrke?=
 =?us-ascii?Q?0Kr7p/Ae0jKvFjH3mo0654oh8VPbxvYhzshZGjVcW+Rh+mkAhsjM8aGpUJIZ?=
 =?us-ascii?Q?zipf4+rEAin3eWbHICU776oY1crFY1Dih3CMpAhZkzRAt/bHWnrq9apmvecW?=
 =?us-ascii?Q?cOkm9xHyXv/Zs0JOL7VYNEc68mWEQHZbFiLSif212tTjvNzy8DFuqpmVD0OH?=
 =?us-ascii?Q?qOg1HeHewoKH2W8N8XL2luMBFna+j8Mq812mqxt0BwRHFKK50n3Hd3vwraBc?=
 =?us-ascii?Q?LwtU4LcqepTunE5aRSzN7mquVRcm2nlaK+sCop7V4cix1bjLthlO?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4a09d4-b927-4594-36d8-08df22a3be6b
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 05:44:38.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: om3LMXydJ9v6zQzoFJeesCXhDcjyqXsCEcvNlpMFaDart+tsWKUBk6D2kgYbx1Tttw1WRrTjNEHZS68VE6HK5mHaGhNBlom8BGPxI6UK3A6KgAqff3qf9oLhZwk37Dif
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSMPR04MB11293

From: Jeff Chen <jeff.chen_1@nxp.com>

Add NXP vendor command and attribute definitions for use with
NL80211_CMD_VENDOR.

The initial user of this interface is the Transmit Rate-based Power
Control (TRPC) configuration command.

The TRPC table is a firmware-defined ABI that contains TX power limit
data. Existing nl80211 TX power interfaces allow TX power levels to be
configured, but do not provide an interface for exchanging TRPC table
data between userspace and firmware.

Therefore, the TRPC configuration interface is exposed through a vendor
command. The kernel does not interpret the TRPC table contents and only
passes the table data between userspace and firmware.

Example use cases include:
- Reading firmware TX power limit configuration for verification.
- Updating platform-specific TX power limit tables.
- Supporting manufacturing, validation, regulatory, and platform
  bring-up workflows that require access to firmware-defined TX power
  limit data.

Assisted-by: LLM
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 include/uapi/linux/nl80211-vnd-nxp.h | 81 ++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 include/uapi/linux/nl80211-vnd-nxp.h

diff --git a/include/uapi/linux/nl80211-vnd-nxp.h b/include/uapi/linux/nl80211-vnd-nxp.h
new file mode 100644
index 000000000000..4e18d0f5af03
--- /dev/null
+++ b/include/uapi/linux/nl80211-vnd-nxp.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * NXP vendor command definitions for nl80211
+ *
+ * Copyright 2026 NXP
+ */
+
+#ifndef __VENDOR_CMD_NXP_H__
+#define __VENDOR_CMD_NXP_H__
+
+#define NXP_OUI		0x006037
+
+/**
+ * enum nxp_vendor_cmd - supported NXP vendor commands
+ *
+ * @NXP_VENDOR_CMD_TXPOWER_LIMIT: Access firmware Transmit Rate-based
+ *      Power Control (TRPC) configuration. The command uses the
+ *      attributes defined by &enum nxp_txpwrlimit_attrs.
+ *
+ *      SET operations provide TRPC table data through
+ *      %NXP_ATTR_TXPWRLIMIT_DATA. GET operations return the requested TRPC
+ *      table in %NXP_ATTR_TXPWRLIMIT_DATA.
+ *
+ *      The kernel does not interpret the TRPC table contents and only
+ *      passes the table data between userspace and firmware.
+ */
+enum nxp_vendor_cmd {
+	NXP_VENDOR_CMD_TXPOWER_LIMIT,
+};
+
+/**
+ * enum nxp_txpwrlimit_action - operation for %NXP_ATTR_TXPWRLIMIT_ACTION
+ *
+ * @NXP_TXPWRLIMIT_ACTION_GET: Retrieve the TRPC table for the selected
+ *	subband.
+ * @NXP_TXPWRLIMIT_ACTION_SET: Update the TRPC table for the selected
+ *	subband using data from %NXP_ATTR_TXPWRLIMIT_DATA.
+ */
+enum nxp_txpwrlimit_action {
+	NXP_TXPWRLIMIT_ACTION_GET,
+	NXP_TXPWRLIMIT_ACTION_SET,
+};
+
+/**
+ * enum nxp_txpwrlimit_subband - firmware TRPC subband selectors
+ *
+ * The selector values are defined by the firmware Transmit Rate-based
+ * Power Control (TRPC) interface.
+ *
+ * @NXP_TXPWRLIMIT_SUBBAND_2G: 2.4 GHz band.
+ * @NXP_TXPWRLIMIT_SUBBAND_5G_0: 5 GHz subband 0.
+ * @NXP_TXPWRLIMIT_SUBBAND_5G_1: 5 GHz subband 1.
+ * @NXP_TXPWRLIMIT_SUBBAND_5G_2: 5 GHz subband 2.
+ * @NXP_TXPWRLIMIT_SUBBAND_5G_3: 5 GHz subband 3.
+ */
+enum nxp_txpwrlimit_subband {
+	NXP_TXPWRLIMIT_SUBBAND_2G	= 0x00,
+	NXP_TXPWRLIMIT_SUBBAND_5G_0	= 0x10,
+	NXP_TXPWRLIMIT_SUBBAND_5G_1	= 0x11,
+	NXP_TXPWRLIMIT_SUBBAND_5G_2	= 0x12,
+	NXP_TXPWRLIMIT_SUBBAND_5G_3	= 0x13,
+};
+
+/**
+ * enum nxp_txpwrlimit_attrs - TX power limit vendor attributes
+ * @NXP_ATTR_TXPWRLIMIT_UNSPEC: Unspecified attribute.
+ * @NXP_ATTR_TXPWRLIMIT_ACTION: Operation from &enum nxp_txpwrlimit_action.
+ * @NXP_ATTR_TXPWRLIMIT_SUBBAND: Target subband.
+ * @NXP_ATTR_TXPWRLIMIT_DATA: Firmware-defined TRPC table data.
+ */
+enum nxp_txpwrlimit_attrs {
+	NXP_ATTR_TXPWRLIMIT_UNSPEC,
+	NXP_ATTR_TXPWRLIMIT_ACTION,
+	NXP_ATTR_TXPWRLIMIT_SUBBAND,
+	NXP_ATTR_TXPWRLIMIT_DATA,
+
+	__NXP_ATTR_TXPWRLIMIT_AFTER_LAST,
+	NXP_ATTR_TXPWRLIMIT_MAX = __NXP_ATTR_TXPWRLIMIT_AFTER_LAST - 1
+};
+
+#endif /* __VENDOR_CMD_NXP_H__ */
-- 
2.34.1

