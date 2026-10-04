Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011039.outbound.protection.outlook.com [52.101.65.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01BD22CBE6
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791132429; cv=fail; b=q6t8M9J1JqzGp3QVksUpmjIps16bCTjPzliNwRIPt8FY8xf1YVqnKYWmcj82ZfG87BylSiLvrqAtZN9ONZS+b+P5NPot1KhDJL1iXKz4UTbVp58kaeNtFPzyHzFrWMAIPM12Aj2d9v9KdsnpJShrduC4658r082oKEe3+703prc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791132429; c=relaxed/simple;
	bh=EQXyvo3Yw/74tJcAMRz/U8TQmMDHokzDNBqU8ykunSY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XLd3GvnHsq2e7xwj0vk6NWEwvvzwANIu5VZmlq1Bq3DNTjr7LP8qFYx9sP5/XKh5Oc03opinzzrS10nKoMJ8QfkGIYE4lRCI3cxGxDh8SFrIVWaKdj6t9GnNxG7FxIT+gcNKDQLKLiK7C0y2a7qPTan3CdmJBYQTn8MPXJ934N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=plQTJyBt; arc=fail smtp.client-ip=52.101.65.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="plQTJyBt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmNhUk6UhVGGKPmFXlmChSqodlvMq5fbm9Qke6ebEBrcz5hLwxd36IhY0F8+5yvxavrknHB72K1ny1sfCm8QyXbNuvJUB6Ml54OzgYgoWc9UVpci0+iVFouTKrkidwXInIRT2VpODsyF+53hjypJk2hgA5C3OP0XPDNW0tUWKeLC8De+emDB73CXphi5epZRCO9ZfCLjCHS6pyaaq8eMZ+WgQD1Lt1+mqSLDVCLCIRuz6I3vpsVvF8mFPgvC7/ldKjOwAbcYMwn1xFRt42m/PY1ZuALHeGYSQyRqjAJJaerje6u/4oIfdpjcswjsVS4lypfegE2umHFjimBmzeib4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NwlHcSvwLDDCvKmWPKyEq1ykX8NtQrHHE3umxrF6lI=;
 b=gsSfhgUXAtEi/C09iok1n5l6Ho4O1ti3ACjQFD+3SlicjzZIMa/uZktRjGFLFyzH95hzr1O3XFodi6plKIz+LbUONGJPltz5LO+t+gVc5YxhytzcXnHCWtxNKwiIV3oyD0gX/Un+GTDDF/AWfkQqC66sQsHUZroF2vni5DnhclPoswM3b9li2vA9AXwMf9yAW10RZ1Mbq0t9Ziq7MsvVLPyorzfp5L9v2jLgVByOKpr9vClSBgh2AVMOhVPCWE8uma/RYyV35cHm5ryz8u7Nyv0FcudYenPoCzEvDlhJBUg6PUbuPl+6xLwO3KxHXpCwZpf7j4mGXUJp+8SArJ4Q5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NwlHcSvwLDDCvKmWPKyEq1ykX8NtQrHHE3umxrF6lI=;
 b=plQTJyBta97zDX5ucRT3zrEFC4bFQWyfCSW/zriyyaXlvPP/ZUSWt4gZ4DJuOdGxWWNAiBDddzvNR2xkFqtbPGcdTGgX3zGKXwMtLW7HprKxpPecJVnBVxtk0JlGyCBiOEmlUCEjiA9EvxUz9pQwB/o98bEjIyeYp3AGD8C8mijQr+nt+AG09jtsEHQexbNEj4kB6T48KY7uUJRbqq5T+WuT04xfQqX0TiYE4Xt/oVGVS5SpfiyzOUgdDShoh5o2swuy/acHryleJ/6l0EBBxavv1qiYKDcQl1nsT0i2yDiijXL/XgY3762oKhF4AMfTwKCh68KuUrUYV7yUKbhLfg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB7637.eurprd04.prod.outlook.com (2603:10a6:20b:29d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 16:47:03 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Sun, 4 Oct 2026
 16:47:03 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v2 0/3] wifi: nxpwifi: add TX power limit configuration support 
Date: Mon,  5 Oct 2026 00:46:26 +0800
Message-Id: <20261004164629.2860677-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:295::10) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: d223803b-2ee4-4cb3-5a0d-08df22371e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|18002099003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	LoSYuCEIJVGIH+ju+wsV5FTBwZeLf+bqfHu60Vo5gHtqL92gXAsFx+hboXGzEYtxUcWkVPSJIBYUaW//dXWekEO/BSq8rfxPDcDtXN4YykvIThMXmsbld8tT46bdLY6tbfdsaBOn/YQ9bmqVpF6Bpu6Cp/X98VFzmkbBeeFpey928feae0K62I/irn02yapaquqVNtNeyHfsMKNQCcOvADxveDtA9NjxhKYVArbGUiYZ4UXyXJFY4SogW9bNNe/OBe5iyR4VOi1eOIq3gZkyTZUVu58khgAAX0N7qH5+aYe89L0OWD5DSIbajPzCX6g5bEiELM9kwwJfL9XxOVCFmlsH0JPZyezknqMSnx/Oz2CkwCyU2u+HsMErbetptX06vUbxZU2pIlhrHNZnUG+qpu030GQNWDhDhCXcodSq1R59QpJ/3y9I20zXnkPCfFzQMPStFrjPKA3dCBts0cdyU9pfcybKILsvXebvTE9gSN1u4kbsgUwtexnvuvS+xG3qvDvRqnFdHK1a1v/5a/bAUgIYTss20yZBFJ2vcsKVtvsjczah16X+iMbUm31SdV+vBskkShnH1ATTXFCC4PDzshWogqfiqw+5dST/ECO654LshaGREKUV4OEdwq4WehvRDyU268V7pjkOtTt9GIba7m9cTdovIMwhh8euei0VHM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(18002099003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xRditIeCrLvNLG+NqllJOeLB3owb+O+SV+Rdxs6AxVIEIuz+S6coXZQU+RtX?=
 =?us-ascii?Q?NZUQsb2IGzk4uRgpOvqYud5iZHeRaeKjuETkV2v35AdLTKvdC78lUrrgMwb9?=
 =?us-ascii?Q?FYZrzQG73fqT19VhfcErfX5TOP0fHHY4D1oTO0tCIM/YgbTkgwwvuuxUII2P?=
 =?us-ascii?Q?VNWhYZ1mPjy+jsYXTWrkH5DVCyHxNbSTOpNF+0G2oxMNkmf73mUnUM6YxvHJ?=
 =?us-ascii?Q?IwLXF49YxE6/hIGVwNt3PGcswVfrqXjdvw/cwtpes83qHHfdoG97K0luHUqX?=
 =?us-ascii?Q?/pgWN819WcXsPYd+/G2867Mw8CIoEc0rLnU3qRmvY6u9tIOinio0+g8DSnEw?=
 =?us-ascii?Q?y4HVTYBAP+IamE085r2qLA43oelst1nvEQvQG5sWgJzkR/YGxLL4WiX3hHgB?=
 =?us-ascii?Q?oKOaoGB/KvCwGaaRgcq2UUJFaby6HUzc3OkwTmoGMWHe2JnD4o5FbUX6aFt3?=
 =?us-ascii?Q?CkQmCsfRx+T9Vd0QccACC9cQy8vctDlp9AJrjqJnVvMXQMQkI+oFNNhADYXu?=
 =?us-ascii?Q?6N8Lxk4kfDIDYYxspxm3Q/h3MsyjE/wnKbxRBPVhTbQ1vECWsJ4cRLbHI+tM?=
 =?us-ascii?Q?YcO00iMGR1OieEk2g+4WQsCrV6ZrdjSsZ76Gw6el7tvUq8A4YdTgsRIZpEer?=
 =?us-ascii?Q?rT7gZaQUk1Xs0A341ah1JguG1n09kslnj7A/OTO4TrI5j8QOwloAItlaiPBo?=
 =?us-ascii?Q?hbT71Fd0Dp7Hi/S8y1AzMvBuNSuLmcvQ/7ncUe7Ies1NiN3sNbZ1tRGMxlPz?=
 =?us-ascii?Q?GHWeC7z4XTJZeC7MFHEXbS5FrTZzs2EhyF9iiEzxYn2PPfbeiHcYeB4knnyM?=
 =?us-ascii?Q?Xe/82szhjB6QcqKMlUnE7H7RqL49dAjo4w5ilWCuvTNjyUHvHgWiRz7XMwKU?=
 =?us-ascii?Q?73k7CYgw+yyYp9aNzZAW2FFhp80dObZKB4UhZWPMqySfDSqFnS8EVn5MchTu?=
 =?us-ascii?Q?m6EPW/MVmcQ2oAQ8ubtJ1VmqGnL3vsswuuwT35PrvFLuOYDnJUIvdBgOVyPE?=
 =?us-ascii?Q?V0CzTqBNcgaLmkM5aT7jn5acaZDPXYyYrkPgKBg3T7tboa8vYqZ5jyLd6tuv?=
 =?us-ascii?Q?5Kngt1TAPpSeSiMWAUQGrdY9BO50MSGChKiocr+qOdtvJ0RKzu9OQsFLyE7D?=
 =?us-ascii?Q?r+RrsLe8yPWGIReyMhVWixHmHnXIn65qGE9PTD78byPyqLsB7DJW9LTc0TB+?=
 =?us-ascii?Q?lsOdSKcZrzJIz3NTMZwX7Im/3ImX00mBfY/WPkQ5PaBCeezc60gBnDObZHOu?=
 =?us-ascii?Q?Wgx5IvlNVSrCHIGs7udrZAJWORGVwL1WIRo2/8Ms8ftybgncj21eX47fzDQe?=
 =?us-ascii?Q?eHtgX/b5BqdrRZ7+gHnuh8oZXB/3tS4RFZAT0CmqMgoLvGMw2r7EffvixuFx?=
 =?us-ascii?Q?teT6E3yYT7xV0famdf0YIfmkztzblgoczwyBeGQhq9iXiHPudzatDTy2v2OM?=
 =?us-ascii?Q?9+mct8/574mDK5fL0bN7nmQrRYa0R5+hQar3FEEeZOU3ec9aaSLT2p21RqnS?=
 =?us-ascii?Q?h2pyuUK2DjN80+FRCI2JtoCw0U4Uebm422HQYKOJ0QSxV+YJwb0EkWlv+UsJ?=
 =?us-ascii?Q?pXXajdp0v9z8DawVccRHNvHdEK9eFZv13fQjFnpHiiP18UfXVT7eDY8qaLbK?=
 =?us-ascii?Q?1fPu3FglqkJZEzl4nxhnJTjGPMxquTCjGCnk1uEAn9ftNyuXCjWt2y2/YA3B?=
 =?us-ascii?Q?jiQNPzaCBpfM5kI7XR7YUrTo2IMA0zRe0NaF+/1LTJADx10LfGHAMOVZKke+?=
 =?us-ascii?Q?IpYog/TIVFjcTHWUYgS7Emveo8icJbx1PHOfR0AGfktNXj7iPR5L?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d223803b-2ee4-4cb3-5a0d-08df22371e4f
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 16:47:03.8377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QM05AGCGcmFo/giVwNLt+C7Dqki38njNkkqpHn4GmgzrRrnSVS6Gc4hPCgvigxPqGv9XcB1QZTzHacLY/kLkM0nFVJ6SaE4rqVuAGUlqiInCaPNxeiZQEnvTYrQM2Rxa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7637

From: Jeff Chen <jeff.chen_1@nxp.com>

This series adds support for accessing firmware Transmit Rate-based
Power Control (TRPC) configuration through an NL80211 vendor command.

Patch 1 adds common NXP vendor command definitions in a UAPI header.

Patch 2 adds support for the firmware TRPC command used to retrieve and
update TX power limit data.

Patch 3 exposes the TRPC configuration interface to userspace through
NL80211_CMD_VENDOR.

Changes in v2:
- Add a common UAPI header for NXP vendor command definitions.
- Move vendor command definitions from the driver to the UAPI header.
- Address review comments.

Jeff Chen (3):
  wifi: nl80211: vendor-cmd: add NXP vendor command definitions
  wifi: nxpwifi: add firmware TRPC command support
  wifi: nxpwifi: add netlink vendor command for TX power limits

 drivers/net/wireless/nxp/nxpwifi/Makefile   |   1 +
 drivers/net/wireless/nxp/nxpwifi/cfg.h      |  11 ++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c |   5 +-
 drivers/net/wireless/nxp/nxpwifi/fw.h       |   8 ++
 drivers/net/wireless/nxp/nxpwifi/main.h     |   3 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c  |   8 ++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c  |  67 +++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.c   | 152 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/vendor.h   |  14 ++
 include/uapi/linux/nl80211-vnd-nxp.h        |  81 +++++++++++
 10 files changed, 349 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/vendor.h
 create mode 100644 include/uapi/linux/nl80211-vnd-nxp.h

-- 
2.34.1

