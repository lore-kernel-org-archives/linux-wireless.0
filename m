Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010031.outbound.protection.outlook.com [52.101.84.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F7C1F7916
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179087; cv=fail; b=sjKeJT4i2vgEMv1L6/qFSiVZFYpOtWx8YD1R2jVh7mEwNMxdlerkdZwh+9MTrp7NfCrieD8VSo4uhfG/vx1eyGZxfbaQEeieObNfxYSTP090tNFQfsHWHuD/XogZ5tdNyWtyxIBbLFo8/+U2OygPoOQbpGz9/U1VRlSsCKdt72M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179087; c=relaxed/simple;
	bh=gA1TwtRU8xfFEMsgLE4gzajycfeeD9k7fQBpN5mGK/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PgnsRj/QCoS/WOH5ijk5eA+n/u0K0iFJG3m5BwmssII7Hp03qDYReHJKGkad1cDo+D6cCB08CZtax31ZxuITc7SBwB4i79//wtSKcsuNif5KlplH7ocVbw4HAiVucT9cfok62HuaRPLVgyB0puIo4XwnmjSIDeWtKoz8vVUROSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=NM/Vgl+f; arc=fail smtp.client-ip=52.101.84.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="NM/Vgl+f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N04Lo1ERni1GYVYKtVXEZPf0tbMAJvObiQCruNhBbNW2oVJhrc24qFPcajaFu6cLhGCbzT4qLJefhH1HRScIP+f2tghUK6nmkxi5WT1KBKp+vxqeFq9k2qmmN/u/HGUOMX2RfmSTD7bAWTsZafOCeQskOQkdrQKcqgi0xovffDf6Klx6bujk/9ygNR0hiiB5DNJRC2CflgUr+CMOnGJXn67s342sZMvZ0b6fhCdfoibPqgKBkuZBXlgk/yLBmQPgCkq8B8n50iM7s3vSkT0RE56AVKS/Iir7QhdRijDhyb7+1WF5tGV3t/QjivLV3clpTJqTPCvMqEoQym9Ti3wU6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moS1MwO7lPxBAGQ0r//Js5OI7Ln4LeXN8n3BQXFvlLk=;
 b=Ao5gFJqg6IhZTY116gbxSSDaQ3OpPPlohdvap8CQ0uB6cnAVbqA+MrkUunyCmo6kwXQidlRp1aZ95/ouhENUUSBSIYdZ12r4bn1HLxatq/MyHgTYvBo1P8v1pekWOGvXT9hkP/Fkrik0SZaYocqDsExf1gSXkS7XK9AInnkl7ok9rCIp8qmMgo8lYHy38KJA7Z9R8s9bj5KdetbaepCVsrSQkRbLXPGDrVbBBoL02VIVR4pWSucXykk9MX/XCpBv/ufkjDG3sOQ7gNOfB7yK1VQLkNc0thcYcfrQN3XCzIFjMTJo06V2KKWjuj3ih7SKujwlMV6wi3hh0C3gPzlZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moS1MwO7lPxBAGQ0r//Js5OI7Ln4LeXN8n3BQXFvlLk=;
 b=NM/Vgl+f2P5qxJnLeAl6PSqzhtB12VU2ZXabY65Il3Ci2puguDMAteuswioFIIgsUoapblpZZVBLxwx6gPXX6xjGBZLUAqjfcDMLulZfYw3li6bVhxq6ajLSL/ZsnR+99SohSxsiQFycFBZg/5xC1h540KWpyVSWke2IpGU9m2Lf6Fr2tzOdzYZbzSCsfcLjkwRt1cbGRosD9CySqrQTK57vwY4g3vjQGmfSiN2bP0gUdhyDTocKxdcrM5qKATBYIsWc2sLxvXtLe2AMfho5jbs9Nk3j8m7Uui3ELIfnwPFSl86J+Tju/N+zqPlRvbTlByX7BP7unSXQ1I1cABD/NQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by OSMPR04MB11293.eurprd04.prod.outlook.com (2603:10a6:e10:93::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 05:44:41 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 05:44:41 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	kees+treewide@kernel.org,
	arend.vanspriel@broadcom.com,
	benjamin.berg@intel.com,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH nxpwifi-next v3 2/3] wifi: nxpwifi: add firmware TRPC command support
Date: Mon,  5 Oct 2026 13:44:13 +0800
Message-Id: <20261005054414.2874415-3-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
References: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|OSMPR04MB11293:EE_
X-MS-Office365-Filtering-Correlation-Id: 393ab4e5-9396-4a38-1ae2-08df22a3c0a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|19092799006|11063799006|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NwBKMpz2Q7d8b+NRpFqbnni//GDj/p6NFG5J9rBRHmIj6MyyhxafZjGxsCU1YpWb++uMvtwMHBmbtufFSMwlytaL6uKq7IYSIU1ZwkCw2IPHivZZkkaD0VlyOH9x5vy/w8rXv/Eo6lCpzjoxwjisYJLljzcQozyRwqu8ZHyTopjGqL4JOWFi65MhR61nn054l925FfT6Iux3Q5WQs5m2y8fYpixyNv4yfWKXaNqRCdTGjZuDKJKA0+oZh6uqdwdZvLuaVubmuqqtoM0tB94iznJBiF5/9UNX7yfQSJtOGEDONWTkxJVeQD1xZnq14a4KX3Po1Z5SSyTkkyQriQiJWbLOm9/T6Mr8kk+6EV+IM3OfQov3i2VoGqc9Lbmqe8HxGTAz0LgLVd02+CHl6GBDQnfQ6+25gM9FxdKR/b+8XT+2O4SeUUZscdkL+xsRS0GrFOVFd8qhyG1QagkfOW9NF1AELJjov1YrRUdUShPH3oNO/ZMUv6XsU1kBfK83+afwMNegF1yhGxF/SOqcPXs+SFC7w2lhJSnZ+2DKSwXj+3rOqgMrveXYdWhvIn8pmf+RVnH10ZTr5fuS8B4DKa0L9vpyutUjEhk/9wjkd6+zEpiD+6E/viwfWay6uZAeL8mPgbBCtpfgLBYXx1HgnxffCk1IN+e20U5Bi049BuF7aq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(19092799006)(11063799006)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?agNrg+42KQ6h3SLdrldY4EkfB6/e2gQFqIkc4WY2rsLH/vg3Yvv3JD9KYVTm?=
 =?us-ascii?Q?GB5wN5XLBmTpxIc/vo2cezy/B/YWkPM/EfOCKdTsjYcb3ORW8FqNHOe0L7i/?=
 =?us-ascii?Q?T6kgm5g8vUvHl7K0QBPWB3blCxENGFDhub44vfk/a6qIwsSgdlAoWkxnssv8?=
 =?us-ascii?Q?COjX0eBaO0qdgrWEBS2H5sSidz2uZKj4H6LjgLbqtGgi8gJ7HzwH2HLiVj2w?=
 =?us-ascii?Q?Q/4Z57lNGzI9ARe+/3NEqfV5JrVDsEy2Eu8TH81tiE0Vp2NpjgOm+SaCrrSE?=
 =?us-ascii?Q?ogab2el9HqOTR2ot0DWO05jYzupXr39UbsL3miDa/5yTlJjfIGnRg5fR5+SH?=
 =?us-ascii?Q?zfUWah9gIaBXl4Z978FHh2wPANiMVDliCrFS12tNQBfVUdom/AdRZUbdVa2m?=
 =?us-ascii?Q?gnFlWTvbK7YljCWbs5GfYSSomNxClA9A1YMJ2qG7y+Z73Vjy1R30zZPNAa+7?=
 =?us-ascii?Q?X6H81FonMF36BCMGQ0eIdHkUy72b2cetsWnTg1fn7bvtsBawM4+Ds/k1w+Bh?=
 =?us-ascii?Q?8cjie0dtKPGnO9nw8A6XnCoKoVpIbIEmrpSXSIeewDPk2cen0bHP8PRukcl6?=
 =?us-ascii?Q?qO+weymmd9q+B6T5vLLZnjg7fgkekzhOgj3QlcP+++QRo2P6eG0btSIF33B7?=
 =?us-ascii?Q?3HyoDPh+lZhn6hagk5rjPsq6xStkNyN+HoImjPWVGkrupuwKfBBGkwpaLXTU?=
 =?us-ascii?Q?4tn8GNeMUbuCYhdCUXsFygrdawNVjoLyAfhRcHhdrdJJM36zQZabAbvlWRIl?=
 =?us-ascii?Q?Dhz/q+iZ1Sc9YOGB1O/X1Kq93rw9fceuqlJeK41VJCCGhVe7vl6JKArH0onY?=
 =?us-ascii?Q?IvYOkq3YLKDmF/ZO7dmmYhAhthlVtim/ccBFdFPEkfdUg4qt2KENKdJfJ2aM?=
 =?us-ascii?Q?0g2ib3xfXih5t0TQySDXph8Iajzonpi4lYocZ+HHhPzpMoRmCLgisiuDHVtp?=
 =?us-ascii?Q?RsOBsTudOQ9OhuSSfaqXAi7+qZdJ3WvqoRHsTb/ZOo/WVc9QU33ViQ3V049F?=
 =?us-ascii?Q?thA9GnehJIX7NSN8eFo4tGcVXHTUE42hBUKNv2pb94VY1Zgnc2X/t4YIxcX+?=
 =?us-ascii?Q?j3RfdohIgWPZbXLDW9aKe8m57ojp2XvXJTmNUXtCa06+q9c4mLfFG/+ZH3/4?=
 =?us-ascii?Q?nxGoK9iolP6ypKJW/k5XxfUAru4C7wp0PF9TDbBqTI9s97b9QF3XBV+Gz5d9?=
 =?us-ascii?Q?zlO2IYIH584Amei+lKevxZX+i/jJG6X6iiLZUcQTuEBgh7NfK/6EIQhGhTEc?=
 =?us-ascii?Q?znwPmACJUN3hXxrssP7mtM24Q1SrJAjs59dsus9euQ/yaAW0RQwHJmZhUWhR?=
 =?us-ascii?Q?T15AiALoKjBFSYC8IMHZxpcGujFcxYnYmkpeJhYDHEW+uWtWEV80aGwNcqE2?=
 =?us-ascii?Q?zSEDN3PtFCa2lNzD/A8srM7TaWOBQTmlI25JH/+NT6fK9UTMTZtqNeAs9Vwg?=
 =?us-ascii?Q?1ICtf9arya0X+Ocni0atBn5C20veBTmKa0UeSta7wusS+1G5YLNEo937HF61?=
 =?us-ascii?Q?XsLJQNOdLH0NvxHvSEdpnDqOHhBxLg4bCHYzdSiIw5ZcqqQXKI9ukrr1AhNL?=
 =?us-ascii?Q?x5i0aiS6eG2BB4GxAD1SoS9e9XrU9X89ahHYNNQrlstYGTtVYXrE2UuE4uUl?=
 =?us-ascii?Q?4qWDXuWQk8VB83GXsubvlN/5rxXYM6CJBbAADY4CzulfbwH739trWoW63dnr?=
 =?us-ascii?Q?obOonXs873mA6FKi1XuGbn4XKWFNDhHdco8Wvub5wZT3u8OeZ8WnqgQZGqk8?=
 =?us-ascii?Q?Qd5yWdWk7NE6wVU0grbCuSHjb+/uavSS/Tlc7Or+PxDC7T2iuKOV?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393ab4e5-9396-4a38-1ae2-08df22a3c0a4
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 05:44:41.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGu1jsL8O3niQneJaY5w9OELzEIQ6yMnNMbLIUPyD/RuVustqNFRzt7p4kwFWAedpzxZzrBpVM7qNgHT8zzAPUT/M4U4ZWpH4cv7DeNsgYiUS0r3lysCAKziJuhGyfBA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSMPR04MB11293

From: Jeff Chen <jeff.chen_1@nxp.com>

Add support for the firmware TRPC configuration command used to
retrieve and update TX power limit data.

Assisted-by: LLM
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg.h     | 11 ++++
 drivers/net/wireless/nxp/nxpwifi/fw.h      |  8 +++
 drivers/net/wireless/nxp/nxpwifi/main.h    |  2 +
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c |  8 +++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c | 67 ++++++++++++++++++++++
 5 files changed, 96 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg.h b/drivers/net/wireless/nxp/nxpwifi/cfg.h
index 8627a3372978..4c0558ed483e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg.h
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg.h
@@ -755,6 +755,17 @@ struct nxpwifi_ds_coalesce_cfg {
 	struct nxpwifi_coalesce_rule rule[NXPWIFI_COALESCE_MAX_RULES];
 };
 
+/* Host-side helper for the channel TRPC command. */
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
index 188110b020cf..0de5d2fc9242 100644
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
+	__le16 action;
+	__le16 subband;
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
index 9bfa4aebc3e5..8ac5008e0081 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
@@ -3033,6 +3033,70 @@ nxpwifi_ret_sta_twt_cfg(struct nxpwifi_private *priv,
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
+	/* usr_chan_trpc_cfg->len covers action, subband, and TRPC data.
+	 * Reject lengths outside the supported command payload range.
+	 */
+	if (usr_chan_trpc_cfg->len < hdr_len ||
+	    usr_chan_trpc_cfg->len > hdr_len + NXPWIFI_MAX_TRPC_BUF)
+		return -EINVAL;
+
+	cmd->command = cpu_to_le16(cmd_no);
+	cmd->size = cpu_to_le16(S_DS_GEN + usr_chan_trpc_cfg->len);
+
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
+			return -EIO;
+
+		resp_len = resp_size - S_DS_GEN;
+		/* The firmware response contains action, subband, and TRPC
+		 * data. Validate that the payload length is within bounds.
+		 */
+		if (resp_len < sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) ||
+		    resp_len > sizeof(chan_trpc_cfg->action) +
+			       sizeof(chan_trpc_cfg->subband) +
+			       NXPWIFI_MAX_TRPC_BUF) {
+			nxpwifi_dbg(priv->adapter, ERROR,
+				    "chan_trpc bad resp len: %u\n", resp_len);
+			return -EIO;
+		}
+
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
@@ -3217,6 +3281,9 @@ static const struct nxpwifi_cmd_entry cmd_table_sta[] = {
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

