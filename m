Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010016.outbound.protection.outlook.com [52.101.84.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7D34E0B8F
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 10:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849230; cv=fail; b=Vzk0bF/3Xe7M6JLx4uDarVGvHxq6/T4uUwoZtjSlZ2r5tdhzcz0qMC0I6PDSRgBCeRzC24vPN0LKku1hr8of2utvIzebXhHv6oTKNTYpUX0S8WbgTDDXo4Qr2KpGO9snS+JazQaKMtl6DnkOKz2zNUQYv6qlw632h3/Fl2Pg994=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849230; c=relaxed/simple;
	bh=OjDSk+fUl220IMGvpZoV979nI9gxWownRyRWuRmgv4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q4GEYl6VKuJ4mA38q3VzOYU46VkEfy7C3yCcRjzH3xtnn7a8v/FY1bQm93z7fJxfwBIn9COoXYYg5bu3gv/QpUWyxXUBBdXlVxCn8H+JObKkq6n7TVK8cFOmgDQYhS24DN6rKMJlGYg2IeJfJ4oFcbU5+/jmVYmX+jP++RAt3nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=THmale7Q; arc=fail smtp.client-ip=52.101.84.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="THmale7Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdytCKfczP7OOaPxBuM3kWTG2C7hubVmi1bcw087Nl+sEW1STqTdlP5Sj7SnR0b7C8qCnQXZN1FSAo53+7AxZcjiLgjoezPIa2FMEXRB4VHXJby1Z/mUx+6uBue0uIT/zqRkoPHdTqYeDAjUB/pCAzHuq+IM6mVzfO7zrQ9/NHmsnXadk++YBcn5au6Lcojl/PA/9mb3m5rAhboukemP3Mx82mEyUED/GEc+hoDVUSkSUa53bHv24S5mn2shofBZuvx7RLLXeuWzVHH+uz3NP/mS1QZ5XXIZWJclDKil8rZQ297vTnzOPTgQLz55kinuj85sffp9bl1Ev96j7I5aIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20LCiIXlSoBsLtJ9n9BRZWlvmQfmH3AncfwRyMQ7NZA=;
 b=V1QztdTHM7/xmI0S1xUujkrKlRIdMMRP1AW1vfqN1VMRMF8s+wmKMOug8L8nFx7T7prAGd0hW+0VUj8PY6n+wXxY13trgwQiKqZVz9k3dZuE4eWvGD3vlyYbr9ncoXjcgMXnqfEdQNKxnqZvvaB2VGY7nMOD+LdqoIWhoe8CBIXN3nHGm+tlLOYVgEea3CjTX9IYp/AOpQoWet96oknmBp1hCFHyfRKrGsOImRFkdnCnTpCdgLRgQf4CP6S2zTe90XT4VYzmRnIrdg2PCC/CRVseV6xHLVEJC9ngzCCSGuRIbBicujSLPRZEsPx8ozLyFWtczV0P1QSr1N9I74EYcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20LCiIXlSoBsLtJ9n9BRZWlvmQfmH3AncfwRyMQ7NZA=;
 b=THmale7QxHiNiwWvc0Aau14Uc/FrXdmz5DC5fqc5aQB9MM4dBOaKFhRn70fj+Kk1ayjFo2+7xwLc1fTkFNAhFEDLq2Phr5z01esxwoh6U1AR23bQu96eqvVcNUephDZxXEwTBNhowfgLq9Y5dYEMbE83s3adpacaE2thDibpDwJ62+ajax1TEJ/sKkbP8zdwhnPchILVS4aOpVVKL3uJq6ZSQgN/Pg3xE1Q6sCnNJSq4FrZVX6006doXNf4Pzlq3bSdqS6JP3vIlHz5fOI3DRApwJoWOLXAx0F5YdzRD3H7YgadIv/Q4OvEL2DGw7/4zmcHvBwDujP4Nz0JSBfGjow==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AS8PR04MB8278.eurprd04.prod.outlook.com (2603:10a6:20b:3ff::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 10:07:00 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 10:07:00 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH 1/2] wifi: nxpwifi: add TX power limit host command support
Date: Thu,  1 Oct 2026 18:06:39 +0800
Message-Id: <20261001100640.2829946-2-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
References: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) To
 VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AS8PR04MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d01102-2bd2-405d-fa96-08df1fa3bc18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|23010399003|10067099003|56012099006|6133799003|3023799007|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MBSkHiANHuoIz+lam74q8SaZOEyTdM7QpJmoccEPtspCWcCvwqPUB1qirQupv10t7gz4KG6RJIRD/lIay1wjK9h7pV+WoDn56KAecSvWGuJhv6QBRXN0TNvqsjhZUoI86Zji0ZmTkCKvYSc33NUQ5K0C82xEMoMQCyPfVam570zvy77WRYTHPegx72eZZKIbxowMagFvuOf5hHrstl+PhJmvGVEX1xQtplT1R+oV4GA6oR1DJpnwLyeMZFO7xY1nF79B4nY3kVwZHDJk5dM3nPTifyZPEdMhCRIp+sNKnimlGUD3rw8pJNa3qWtUs0/y7R+rj1PI/esGkW+lLqkVV7F4OJuKALxmXbPxasq9xGTpKgpQAuE6agC+pxQQqCzTZ4/KYRaJznC70s5QLX640haQ7NgbDnnBEzgs+8Wk9A/ux+zXwPkJsr1GvUhdk7zfEj3hcomjuHDBKfmgADaX2Mxjh0V7/4FFLmwYHWHEKAExrTtGl8lURP2F6bu/r7dPew9yiiPen5OPtf3PTFq4syJCawsL6G+9FvU88b5rgg4pOrafFuges9T/qcpADtTAuzGy9FM9WwKYLhV0SCNFw2FTBjUB2e6CYxfk1Grvs13gRRA8RYHDmioyAVQZ6IGOOKWZaCHeGIGFAplfsjGSYDearJIzsIEELJ296pF8ViI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(3023799007)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TyIFMu/PsE2TCpYquDzw7iBH2pMZT0BssTSUf6a6IcVxMFNZIqhAVwjzHAta?=
 =?us-ascii?Q?FQzzfQPIJjHrZrEYUswG37HwkIPM+Wg9GvracVHaKEK7h9Cw1kvbx0/PU4u5?=
 =?us-ascii?Q?Sd4kPrAQRw8/ysNwVTPJ38t0GUOev/R7LWqXHLzqDlClJRsIZt3bZ3nOqMbx?=
 =?us-ascii?Q?Zy0pXiWdJpyPH6pJ1jEvhoYW1DMXXQvAD6Xmi+yAGkN/obpC7huck7JqdxUN?=
 =?us-ascii?Q?aioz5D01bvXkGR46ePrSRftZRJIpjCRcsEgsZxE9eiT8so1v5ThtyvcYyzhZ?=
 =?us-ascii?Q?pwfqtR/Oo0BWfCA5VAkczvBcgIq01HXyjI7dIovo1KyMmnRDFukYw1jtX4Vm?=
 =?us-ascii?Q?c1CPigW/e/jVRgqJ7HVxxQqwfE68nfSrNS3gCOOkaR8DxcZPbZxfPC1G7TpI?=
 =?us-ascii?Q?SvbKFGWJQXPExl3hAF0J0KpVHfmILAHBJYFSyZ7/CcF3/LRNW6bymEE0DMWA?=
 =?us-ascii?Q?vTSBB7IosPfFJ5RsDhEuizb18Ff+DXILNKlo/MDzrnozdHEXHcfxkLDu3sF0?=
 =?us-ascii?Q?XhFKNRA4msxYSUBknpvY6gVAio6ot6e3OTH3QPDqmtY6g55/iH++tWs1E0U0?=
 =?us-ascii?Q?CRj/5+eN5O9QpiQCuwpfQ7a+R3jMYC+5pcbl9iY/IE/2kSIrxD5GPelqJ7yY?=
 =?us-ascii?Q?D0dQSg5te2KULArxJI/r8o5EeoYK8ESfRg0VeuuF4+oElX+fJf+52YUZLX4Z?=
 =?us-ascii?Q?2VGxYHLvqhw9H9KEew/hnUAyseLa2Bx6/i3j29rFcjQMLK28mLTG/utghHVF?=
 =?us-ascii?Q?RBeiZlqQNh21wegTO6FGXNmiKPVo/YUHWQNI8ihLv5pUjMEWv+dZkyuHwM9w?=
 =?us-ascii?Q?qRIBomIiZE+5KziwGKpj7SY6jJ9ITYo/pJENFSrQH2AIFvdqSP3MuOzuRTH2?=
 =?us-ascii?Q?3qu6W3ZiEONOereNFCzCemODC7tZ3DIrcpWxUQEX1j44ejhqyWO2G6rbAH5r?=
 =?us-ascii?Q?rqkAwLzei/8Ot8MQ/hiaBtY/+oPbjfjZVcNOpKizW8gtRnNlEEwiun/eMrhF?=
 =?us-ascii?Q?El8wUWVgORflBRXcmOsHqjFFOv/O/WqpbTMVdq61/J+NE7cQGzVtjImHEo7H?=
 =?us-ascii?Q?J4k283F23QlGgEMIiefcbnTOWhtK41g6hyzfl+8uufRtLmtl9LDYQVqlVLil?=
 =?us-ascii?Q?7+XUdBI2jLk3+4krW3FSi7hasTJEQ1aQGTVo7axDJSv6qNe4tykqN2Oc9jPd?=
 =?us-ascii?Q?nhGYvvUOmhr7pkTvKAwiG0GiNnXYqP32AkQpIgZoOXJFgEewygnTbZn6t6FU?=
 =?us-ascii?Q?5Azilb3jUHNLR6r+BkE6llg9urUn9nYuNIeBVTGZn0ZsRB+YJvLJcZ30GEUr?=
 =?us-ascii?Q?oVola55ZLwGHk/bR1aqqT6xo9DMSPJ3hXl35DCVOamdQ/Lry4zsDy6/V7qc6?=
 =?us-ascii?Q?D4FoGYb/iu3YyzCLpl+zDTdkQ7bmiDdw76ySwE9IKa6P/yQpl25Z5jFmIv1H?=
 =?us-ascii?Q?KgkT1/2Yi3Ia993q8GabTwr9J2KvMFnlz5oz1QzO3W2MPWsNlAlb6SA8feqp?=
 =?us-ascii?Q?nvh/7zurKKMUSk3FOdY9GB/M30QfyetLCaRuUxVpI9PSM6q3v8BKE1y/mYhi?=
 =?us-ascii?Q?wQpCoyCl6ZXoT3qsIIP6bdw1NtneZRUbG86ZICVE+hQSGQCFxpDrhOZ3vaj0?=
 =?us-ascii?Q?Ean0dckgpwTyw0CthfswvgCM78eUq0j1nQRDwjG+MHbdvX2gDk4Fn2X/4CVo?=
 =?us-ascii?Q?nFciNcQJ5A++rFxVvyApQHI+5RjCHWlgrSfo0dYoV/oz6NeYndrKkLTNVlgd?=
 =?us-ascii?Q?+1qYH/xqS3kHxZGUiuE2Ukn/8fpFhPhJezP1XbqMf/trD8gYJ7g4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d01102-2bd2-405d-fa96-08df1fa3bc18
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 10:07:00.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZB54GPMm7NMz0X3/2qfPgE613Qt9inJLTDmLbpu2WJ6KZSBtDO0ewIcdyBE6la+8MNfivjlF3xpDYUeQ4yW59IQsdON+gBHZ8TJhokITQu4A2/yEid3Ncu+CzxFnZfSM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8278

From: Jeff Chen <jeff.chen_1@nxp.com>

Add support for the firmware channel TRPC configuration command used to
retrieve and update TX power limit data.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg.h     | 14 ++++
 drivers/net/wireless/nxp/nxpwifi/fw.h      |  8 +++
 drivers/net/wireless/nxp/nxpwifi/main.h    |  2 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c |  8 +++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 74 ++++++++++++++++++++++
 5 files changed, 106 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg.h b/drivers/net/wireless/nxp/nxpwifi/cfg.h
index 8627a3372978..c94ac8e9b368 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg.h
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg.h
@@ -755,6 +755,20 @@ struct nxpwifi_ds_coalesce_cfg {
 	struct nxpwifi_coalesce_rule rule[NXPWIFI_COALESCE_MAX_RULES];
 };
 
+/* Host-side helper for the channel TRPC (TX power limit) command.
+ * This is not a firmware wire structure; @len counts the bytes from
+ * @action onwards (action + subband + tlvbuffer).
+ */
+struct nxpwifi_ds_chan_trpc_cfg {
+	u32 len;
+	u16 action;
+	u16 subband;
+	u8 tlvbuffer[];
+};
+
+/* Upper bound on the TRPC TLV table exchanged with the firmware. */
+#define NXPWIFI_MAX_TRPC_BUF (4 * 1024)
+
 struct nxpwifi_11ax_he_cap_cfg {
 	u16 id;
 	u16 len;
diff --git a/drivers/net/wireless/nxp/nxpwifi/fw.h b/drivers/net/wireless/nxp/nxpwifi/fw.h
index 188110b020cf..3a6bf452e89c 100644
--- a/drivers/net/wireless/nxp/nxpwifi/fw.h
+++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
@@ -386,6 +386,7 @@ enum NXPWIFI_802_11_PRIVACY_FILTER {
 #define HOST_CMD_CAU_REG_ACCESS                    0x00ed
 #define HOST_CMD_SET_BSS_MODE                      0x00f7
 #define HOST_CMD_PCIE_DESC_DETAILS                 0x00fa
+#define HOST_CMD_CHAN_TRPC_CONFIG                  0x00fb
 #define HOST_CMD_802_11_NET_MONITOR                0x0102
 #define HOST_CMD_802_11_SCAN_EXT                   0x0107
 #define HOST_CMD_COALESCE_CFG                      0x010a
@@ -2373,6 +2374,12 @@ struct host_cmd_twt_cfg {
 	u8 val[];
 } __packed;
 
+struct host_cmd_chan_trpc_cfg {
+	u16 action;
+	u16 subband;
+	u8 tlvbuffer[];
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2447,6 +2454,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_11ax_cmd ax_cmd;
 		struct host_cmd_ds_802_11_net_monitor net_mon;
 		struct host_cmd_twt_cfg twt_cfg;
+		struct host_cmd_chan_trpc_cfg ch_trpc_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index b25a6a4f2936..9ae017bdc6ca 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -1415,6 +1415,8 @@ int nxpwifi_get_wakeup_reason(struct nxpwifi_private *priv, u16 action,
 			      struct nxpwifi_ds_wakeup_reason *wakeup_reason);
 int nxpwifi_get_chan_info(struct nxpwifi_private *priv,
 			  struct nxpwifi_channel_band *channel_band);
+int nxpwifi_chan_trpc_cfg(struct nxpwifi_private *priv, int cmd_type,
+			  struct nxpwifi_ds_chan_trpc_cfg *ch_trpc);
 void nxpwifi_coex_ampdu_rxwinsize(struct nxpwifi_adapter *adapter);
 void nxpwifi_11n_delba(struct nxpwifi_private *priv, int tid);
 int nxpwifi_send_domain_info_cmd_fw(struct wiphy *wiphy, enum nl80211_band band);
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
index 56cf63fbf7fe..650de6156912 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
@@ -1175,3 +1175,11 @@ int nxpwifi_get_chan_info(struct nxpwifi_private *priv,
 				HOST_ACT_GEN_GET, 0, channel_band,
 				NXPWIFI_SYNC_CMD);
 }
+
+int nxpwifi_chan_trpc_cfg(struct nxpwifi_private *priv, int cmd_type,
+			  struct nxpwifi_ds_chan_trpc_cfg *ch_trpc)
+{
+	return nxpwifi_send_cmd(priv, HOST_CMD_CHAN_TRPC_CONFIG,
+				ch_trpc->action, 0, ch_trpc,
+				cmd_type == NXPWIFI_SYNC_CMD);
+}
diff --git a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
index 9bfa4aebc3e5..07cab38f0644 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -3033,6 +3033,77 @@ nxpwifi_ret_sta_twt_cfg(struct nxpwifi_private *priv,
 	return nxpwifi_ret_twt_cfg(priv, resp, data_buf);
 }
 
+static int nxpwifi_cmd_chan_trpc_cfg(struct nxpwifi_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     u16 cmd_no, void *data_buf, u16 cmd_action,
+				     u32 cmd_type)
+{
+	struct host_cmd_chan_trpc_cfg *chan_trpc_cfg = &cmd->params.ch_trpc_cfg;
+	struct nxpwifi_ds_chan_trpc_cfg *usr_chan_trpc_cfg =
+		(struct nxpwifi_ds_chan_trpc_cfg *)data_buf;
+	u32 hdr_len = sizeof(chan_trpc_cfg->action) +
+		      sizeof(chan_trpc_cfg->subband);
+
+	/* usr_chan_trpc_cfg->len covers action + subband + the TLV table.
+	 * Reject a length that cannot hold the fixed fields or that would
+	 * grow the command past the TLV buffer bound, so an untrusted @len
+	 * can neither underflow the TLV size nor overflow the command body.
+	 */
+	if (usr_chan_trpc_cfg->len < hdr_len ||
+	    usr_chan_trpc_cfg->len > hdr_len + NXPWIFI_MAX_TRPC_BUF)
+		return -EINVAL;
+
+	cmd->command = cpu_to_le16(cmd_no);
+	cmd->size = cpu_to_le16(S_DS_GEN + usr_chan_trpc_cfg->len);
+
+	/* Copy action + subband + the TLV table verbatim into the firmware
+	 * command body.
+	 */
+	memcpy(chan_trpc_cfg, &usr_chan_trpc_cfg->action,
+	       usr_chan_trpc_cfg->len);
+
+	return 0;
+}
+
+static int nxpwifi_ret_chan_trpc_cfg(struct nxpwifi_private *priv,
+				     struct host_cmd_ds_command *resp,
+				     u16 cmdresp_no, void *data_buf)
+{
+	struct host_cmd_chan_trpc_cfg *chan_trpc_cfg =
+		&resp->params.ch_trpc_cfg;
+	struct nxpwifi_ds_chan_trpc_cfg *usr_chan_trpc_cfg =
+		(struct nxpwifi_ds_chan_trpc_cfg *)data_buf;
+
+	if (chan_trpc_cfg->action == HOST_ACT_GEN_GET) {
+		u16 resp_size = le16_to_cpu(resp->size);
+		u16 resp_len;
+
+		if (resp_size < S_DS_GEN)
+			return -EINVAL;
+
+		resp_len = resp_size - S_DS_GEN;
+		/* The firmware response carries action + subband followed by
+		 * the TLV table. Reject a response that is too short to hold
+		 * those fields or larger than the caller's TLV buffer.
+		 */
+		if (resp_len < sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) ||
+		    resp_len > sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) +
+			       NXPWIFI_MAX_TRPC_BUF) {
+			nxpwifi_dbg(priv->adapter, ERROR,
+				    "chan_trpc bad resp len: %u\n", resp_len);
+			return -EINVAL;
+		}
+
+		/* Copy action + subband + the TLV table back to the caller. */
+		usr_chan_trpc_cfg->len = resp_len;
+		memcpy(&usr_chan_trpc_cfg->action, chan_trpc_cfg, resp_len);
+	}
+
+	return 0;
+}
+
 static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
 	{.cmd_no = HOST_CMD_GET_HW_SPEC,
 	.prepare_cmd = nxpwifi_cmd_sta_get_hw_spec,
@@ -3217,6 +3288,9 @@ static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
 	{.cmd_no = HOST_CMD_TWT_CFG,
 	.prepare_cmd = nxpwifi_cmd_sta_twt_cfg,
 	.cmd_resp = nxpwifi_ret_sta_twt_cfg},
+	{.cmd_no = HOST_CMD_CHAN_TRPC_CONFIG,
+	.prepare_cmd = nxpwifi_cmd_chan_trpc_cfg,
+	.cmd_resp = nxpwifi_ret_chan_trpc_cfg},
 };
 
 /*
-- 
2.34.1

