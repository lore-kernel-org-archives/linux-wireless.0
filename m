Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011069.outbound.protection.outlook.com [52.101.65.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C234A3A5
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132447; cv=fail; b=FEnBkBi6jHyxut8emjINgpKFLG4AurY4faL3SHaMVPzfAtcqDZW4HK+5N9MOpupENqAiXOF5+nu5jp+J9NIUooWahz6OrdsidDsKY4nZlFEgFzm7TXa83hQFMe7PJmHLyU3/x1fkFdPGrMoEKac4VgAj1Jb5ryQeTStLKo8aBs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132447; c=relaxed/simple;
	bh=S48rA4hS+ViRuoAPcxTXBQdyvqH5Rynp9hX36R9121g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p2JqtyuFkVp76wN5IgapUpkcCvsH0iLqbZIcoBBBjS3ptC7HNHCaf3kAO2sjdzVwQ9dQuuLe+zURYH01hi3BWlrM62EhcDNNJ9CsJvtRsIaqOKATSDG075owD46FLqA2WYxfbK9Dx6nD0mnJ6Z3Ut2lk9YCq4VcMKFgQq84GNfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=igjibrGL; arc=fail smtp.client-ip=52.101.65.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="igjibrGL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BolHva+VcwS1iBPRNB6eldEBc6omaQREkQ0M2cYBoypYsqvriT0EV9X/LLMgKXewAmEZVpNJ2xRnXvV+we1FLa3m62vzl34JPyn6hPmWvmy85mg5XNd67sc3LfN9m82590Dg7sHBWo+NEMepcz9zm2p/dvp/+6WlCFLf3bVYsplU+lKaJA1tpso8OcGZP8wtMj2tHfTC+LCNlHI5XkwnMwwKSwfx4/YjDjaLC5GFos9fiWjumUltbRb+H1uPM6Zn5MiWBQfTas91uGSTtUu/2wBFYxoATkHif/E+zlTWaoeuHWz9qHkkOQLo7dKcB68RbEo3iOI0kKKqzjifCRDdBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkkMpZDM8lUKVdPyUjI7WPk1sdn9EW8Mv44TIpZeweQ=;
 b=xw7y1osX3lwWRIy9mAopvqGzidg5NC1ztqV+i/XnD6EaSisIfjGkq6ssqlHAgje3SjYnUjmnzWWTZ3kv07l7J48ROijBNEbrCn35+N8WEZDEByW39G6Vrc4HR4h0dzo6MpCYJyMmWfYoTkvSM8e49pmtqZu1fIM1Aoo1Mw/O+LazeHFvhzeYOqwqJ+OqAsqExNjeuZAiQkZAX4p1hjddPyEW1AhJ+3ZoluRC3k6dtjDwPVxCWQp4qLL3UbaBYHBp+eRFcQK0ej6IkivuW3OHXcKwOhahoYGXBE3pvgCNS2Ls9RhavPcO7dRNXIYxKqImypemO1yTY+F1koBiR/TPyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkkMpZDM8lUKVdPyUjI7WPk1sdn9EW8Mv44TIpZeweQ=;
 b=igjibrGLLJPY8p6miWhPxynkupX4sMYGE8l5wwdVv1fKutyEYXSIyiq319RY/+uXr99GbbwaL88ZzOFtUqZP+ShE/7RlosVCKLII39n1jH9FUYJ/X64fVwiFlDDNU4FXktUkTwGMHr3d3t+sbSFOAuImlxTSmsK0Hf9q+AkRroOmU4CXH06Ukqgm/a0AgTiuUpPjpPla0LhDgXQqAy8g+zEo8lZtPZSPzofBw4RKeYBmblnOQ/dSHiX/i8iSzj9UcN2KGXrO508QWvZqZx+ZjFRQLqPeUAg1Rjd3iuc9Isrdz9oBgEWzwXWsIgA4gtY93HC3mO+gk52izUtC40hH1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB7637.eurprd04.prod.outlook.com (2603:10a6:20b:29d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 16:47:23 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Sun, 4 Oct 2026
 16:47:23 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v2 1/3] wifi: nl80211: vendor-cmd: add NXP vendor command definitions
Date: Mon,  5 Oct 2026 00:46:27 +0800
Message-Id: <20261004164629.2860677-2-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
References: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P189CA0027.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::16) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a57057c-64cd-40d3-bf09-08df223729f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|18002099003|22082099003|6133799003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	RsgsjvqwF9Yx0y53+xev9AU2mNxI62qJ6Vo3Iv9PcByNDgtaa+/ciecY3rJHVh21m+yRjxlDpRRVBxwqypqBstylOAR2XaPv9AWNgnlW6HyJb9X7oZ64swWN0uNP4HFn8/lFGyR9/bTkH9RSKcOfkSX3LWjBsDyhgkT785zKCB7q4XV++c8zZyF5gJkkrXRkRGZmq2XTpXjtY4cbvOmCcZ2jGlmk6u9F+b8plHHI9sMZGWkeh2smjHQP6tVofOt9kr9nnwBbmKOoITFPRZNOyQ818WK3QwHIV1QvNcLOsPiNbTtL5TWzOyqsEsaaOI9vaelfakPkPG14XgiKyg6TK4q7TMBa+CEQTcK03T5WQ47gKS2SsI46w6B6Pk2EesU9D2V6aTq831+XMW0+EnXcMQKwDZhVJXg8EWyURP9EdWDOWrTCZiOjnKwqRuAglu2icLKD9VvH0ZYzYoSDFtQXFrxeSK1V/mdmg+8YksN5WLEp4JhLcuJ8hrWP5dgpp0UoIS9+ZXQTh1mK9SkA+dIX04st49szNatVCVKc+0u8xm9agzh5IaXvaGMBorvAp7OyptrBk9iFp/T48ZBgKlDvJS1DL4G564lOQ6pUfm5S7zMYGec+yUNAryOwj55uiBxYklUezCCa4nfVAFHoCJ9rUTmZJRE3EIwxtY3T1ORL50s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BKLBP0zGAb6dBEEVQL31S4Whk97/otbVcwfT15Gz6bH39RTUi2TDbzSI1oiv?=
 =?us-ascii?Q?SVAygBAhpx25LOBuicstrmnkwj7ZW8QFH8pLFyC4nYfoGOKuBjTcZJf5000s?=
 =?us-ascii?Q?1CmOW8Ct7hbQjS6bHzSKIAow51WqNi/gXjBebO9Godvvi/W7bsUaxLQWI2GE?=
 =?us-ascii?Q?1Xp3Gqod3jCnrypn7rrOA3+TVrk4asmpfr5Wj39x/PwHJmPZjKDK3NfbFKZf?=
 =?us-ascii?Q?viB90p2jjqy50YqAjDpqepvyOBvj28tD1jASAUSdwg8xd/0Z5/wFjj+eiyFd?=
 =?us-ascii?Q?M9oCYMwcBph2mSoXTaKjmNeVyLJUyHYQ92jD78BfE2yUg1BoqrLVmqCFgH9z?=
 =?us-ascii?Q?S5F73yzL2kgsUoJnzGM3hFy0xn7A6iMLGN8fT88/rCX8PaQHqkYI+nJxEBw0?=
 =?us-ascii?Q?haKQscBpaZ28ILC5sQvavDpaqDoqJdIj3uHnD0jaG1Er3kkogXpdlNCvl+On?=
 =?us-ascii?Q?3Em6rF1X00YaQ0rabi/sDuYShYg2hOB6/qzmki5LUr973rrlsssEzTPMdLKB?=
 =?us-ascii?Q?rjuj7njEhcLpmrzD9qd4JXv+CYP8DLDcZwbrk/7UXs94miqrSkscFU2vA2O7?=
 =?us-ascii?Q?kDI8mZQ/v647ggw9ZITkpi0h65wCxcDEkeBCwhw/vUULdxaSKhISO/4A9HiX?=
 =?us-ascii?Q?kxjIV33raCjcsVJ6I6CLop31gXP9s/Rco9LEXjp1O2S9rTlYJfWIEzJZcxQm?=
 =?us-ascii?Q?iioHPSjyAdyycz8m20b8kpOYqrN3/AFSrC+QhGWRKqUK7Yh2GhuPAfBgIXzP?=
 =?us-ascii?Q?kDiZ+Rj0ezWePFplKnhPp2nsKy1ljn2MC2GcxGl/quR7akYgxCWdSgf8NuPv?=
 =?us-ascii?Q?fAmKIQZCx6ZQ99lhREKKACMZcCO7i89hCATgOPSPuBtNJSCw27W3qE5gZq/+?=
 =?us-ascii?Q?tTzDKlXvGr4hma2haoSGFDaEqfQbf8Crf7KQMyXJ0wilp2eZl3ImoBthiz4g?=
 =?us-ascii?Q?dBUzoNHtf0WBBwRb5PTq3Df7J7ZwGNHn2YVz5R/aIN792+LGuf0gB4KccU1L?=
 =?us-ascii?Q?GeMMixoB9UoOoX8C+LU1khQs+v0pwwoyn/PMCfgCWe8UveIu0zT/fTRBqDlm?=
 =?us-ascii?Q?kK/9jVGy86C6if6gEBfJdRPgT5GWjGZpYsh2tA2lKgXV1eQ0Yz9L0A7y0u/7?=
 =?us-ascii?Q?i4R/i3bvGVesaie9vF5FxY5rfCIPoQF/usTaqPx5x+oy3e6/WRwRFWaSrjfA?=
 =?us-ascii?Q?3Hq7HZuIcLR8ZUn9fn7bGiLMPwaW8yTXjRazcmKhGFhUSiOF2nnnAOGsIrm3?=
 =?us-ascii?Q?ypJoPaZci36XXI7kyqZn++f/5dbAljFyr0UMUPvFm+uyW+bBR0wRY3KkNjLp?=
 =?us-ascii?Q?PJPaHpZaiVyV40fFe6vKgQp15r+i5DZrtytDSQPDy9pj76oSASNbyJYlC/jd?=
 =?us-ascii?Q?yVb+AZYLrZWgU0dBMJnVI97PNaoVGU+3A6oiaNv/Rc+zlRgrz2rc5eA2bAVJ?=
 =?us-ascii?Q?DPDK/oEswq0iTahvnvwr11YTDB0xwUVVakyAJdI6Z7ggnIQUdDsunLytZkBG?=
 =?us-ascii?Q?VbwPRnmghcSDgWMX2fN9UhwAKekf0PQb4nozvwRezxHYWrO/YefDEa83FESs?=
 =?us-ascii?Q?tpoSoSqe8I9pjOrx7AyH3fInUSgzZqT3GkJ1gMyFgBZAtMIeQQ5tzPkst6OS?=
 =?us-ascii?Q?Ak0jpL4q/w3O3oF3H17yBIEIBueRrakDQXcUlKu/FlemmN4khkN84pOtlFQk?=
 =?us-ascii?Q?qtLZaV4gjILjol9bAKLfDFS2hDmT0ZJHT/jWki1trrnuNA6c4wFvOkomxa90?=
 =?us-ascii?Q?IoDEjyLycUqBSUEpKmmgDicnjMEvj8OsJm32IiaQOZkk6Wz/xh0D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a57057c-64cd-40d3-bf09-08df223729f0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 16:47:23.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLXgY97nwT/y0gwEdMG8y7+087pT0s9MsruQ47IDvqzeR0TtMHwq+SLDeXMQw0dVjCdPuY5UXqbKpdhoMjW0oitDV3zl1AZcAZiVXtn0TA0zEPfr5KEv+EM29ERiGI1N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7637

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
index 000000000000..261504690fcc
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
+ *      attributes defined by &enum nxp_txpwr_attrs.
+ *
+ *      SET operations provide TRPC table data through
+ *      %NXP_ATTR_TXPWR_DATA. GET operations return the requested TRPC
+ *      table in %NXP_ATTR_TXPWR_DATA.
+ *
+ *      The kernel does not interpret the TRPC table contents and only
+ *      passes the table data between userspace and firmware.
+ */
+enum nxp_vendor_cmd {
+	NXP_VENDOR_CMD_TXPOWER_LIMIT,
+};
+
+/**
+ * enum nxp_txpwr_action - operation for %NXP_ATTR_TXPWR_ACTION
+ *
+ * @NXP_TXPWR_ACTION_GET: Retrieve the TRPC table for the selected
+ *	subband.
+ * @NXP_TXPWR_ACTION_SET: Update the TRPC table for the selected
+ *	subband using data from %NXP_ATTR_TXPWR_DATA.
+ */
+enum nxp_txpwr_action {
+	NXP_TXPWR_ACTION_GET,
+	NXP_TXPWR_ACTION_SET,
+};
+
+/**
+ * enum nxp_txpwr_subband - firmware TRPC subband selectors
+ *
+ * The selector values are defined by the firmware Transmit Rate-based
+ * Power Control (TRPC) interface.
+ *
+ * @NXP_TXPWR_SUBBAND_2G: 2.4 GHz band.
+ * @NXP_TXPWR_SUBBAND_5G_0: 5 GHz subband 0.
+ * @NXP_TXPWR_SUBBAND_5G_1: 5 GHz subband 1.
+ * @NXP_TXPWR_SUBBAND_5G_2: 5 GHz subband 2.
+ * @NXP_TXPWR_SUBBAND_5G_3: 5 GHz subband 3.
+ */
+enum nxp_txpwr_subband {
+	NXP_TXPWR_SUBBAND_2G	= 0x00,
+	NXP_TXPWR_SUBBAND_5G_0	= 0x10,
+	NXP_TXPWR_SUBBAND_5G_1	= 0x11,
+	NXP_TXPWR_SUBBAND_5G_2	= 0x12,
+	NXP_TXPWR_SUBBAND_5G_3	= 0x13,
+};
+
+/**
+ * enum nxp_vendor_attr_txpwr_limit - TX power limit vendor attributes
+ * @NXP_ATTR_TXPWR_UNSPEC: Unspecified attribute.
+ * @NXP_ATTR_TXPWR_ACTION: Operation from &enum nxp_txpwr_action..
+ * @NXP_ATTR_TXPWR_SUBBAND: Target subband.
+ * @NXP_ATTR_TXPWR_DATA: Firmware-defined TRPC table data.
+ */
+enum nxp_txpwr_attrs {
+	NXP_ATTR_TXPWR_UNSPEC,
+	NXP_ATTR_TXPWR_ACTION,
+	NXP_ATTR_TXPWR_SUBBAND,
+	NXP_ATTR_TXPWR_DATA,
+
+	__NXP_ATTR_TXPWR_AFTER_LAST,
+	NXP_ATTR_TXPWR_MAX = __NXP_ATTR_TXPWR_AFTER_LAST - 1
+};
+
+#endif /* __VENDOR_CMD_NXP_H__ */
-- 
2.34.1

