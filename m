Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011000.outbound.protection.outlook.com [52.101.70.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6CC48C8A3
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808647; cv=fail; b=QlVWIZcLTdGCCaOwuCMESxQxPrCmqPaeoKEN2/crvNTeq9ywoVg1HhzSQEkxElPZfXB9rolC2tDYoGaCOUTMbqNC0wouQh7yQYffyWzPZX06IUIWQhStHFPbsNWP2yMBIWze6EwD4kWgz92WL0Qdarb68JpkCvOz/vSX/n7jVvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808647; c=relaxed/simple;
	bh=xZVJ++R1TjcvWtoKcpTX2gMImiuF5JMtWxGI/G2htrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cZy/Xj32Q1tz9MByT1TzO7xoeNCQ8WiIEPSKpWE+Cc+Dst5NrIbchxL7VqXaogAC4EuLx8C9cemiXMGmOGMRpMKP/ECtX0eh0/Am1TSSXh2tI5KUqaXhg36dYma901ieBFRIBij3Yq7HHyU45iwQHhNDtQwPVrZWXCwOlGW0Aq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=DJ9R1QYC; arc=fail smtp.client-ip=52.101.70.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="DJ9R1QYC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCDbQGd3FrLHKTg8eRTvgi/z0+ql0xy+WRZ2fKk9WcSKs3N+L9N6ILm7rUCundXvpl75JzV5G1H5+duH6J3ME5wOxNXS9UgdqNyH9mW/RbdjPBs7ogA/+w7ImV/sujc9JtFdCJVTyX2FPxU5TXo0Y+LLbABPB9f3RXeficK1H1wgRaUAH1nMy/4DtOJI6OH9PSRVS7m/PIy8sRQn8+jklZ42CS782B6whbjQp2KEfuVyrwYhkeTPRgqmQts8TURxE9mhk9O5lkzqHmbVz3dGVwLCmF/HNy0HRaBZsGMwkglk5hGbkIW/EMyU0WDW5xssEZhJyP8M+KW7qgJKYFyJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NowI3A9SA1dEL5JoLDEU604T5g+d8RO/GL4+J7Tpkek=;
 b=O7Ic6JfWsBvDNV2yGRl8PjjwcdLrlXDnkq2cEiFo9igoRC/0MknxLNvaLBKIDABFgeVY8tylU98cKG+oiv75RljLH+h2O7nnNPLD6USiy8gfrbQXAXazgaE1RfLXqY00Gk66tW43DRDZisLwVPyLVI8tbekxwBoCdro4cN6/WDIBg1XBwO+8muDWCDiufqldpzq+CKnCMobpb8XfAxfqoKaktfk1gX0niLQAdXGM3rS1Ij1PmzmfTJ+ruB6ZdtmnvAtYh55Fg/7RbHMD/ZP46+PpcB6gbbBsaHswGMOLObcl4llexKU+PLyI8AcliwdI1oTeBT+BeQhUz3LikixrDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NowI3A9SA1dEL5JoLDEU604T5g+d8RO/GL4+J7Tpkek=;
 b=DJ9R1QYCKUPn2n1iB37g4k+wu/5izvjr2i7l1F0GqoBPMhbwgEXL9IXVwTkoXUZCLlIqB2OUZ35dKLzS6LBF1+rSo1nHuSGcI3Zy13YDdBFC6fqC5z7l6qi5e66GLh4QeRgc6wwsZSemyEhLmW9QI8YcUG6pAHu9dovcKDrI0tAFln2Zs1ibysur/+59r8rgA35vTztC561DKV6pcljA/oK3TrLxK6/qRfPUs6IqNMWvkS/idmd4xsfIZIG5ZTnqfo0DoGyGKX7o/YB5Lie35a/EqMSPxYw9IZW9UDTFL5dlqVikYwsCRrhfiJPg1b9m/M8lK/hkiPrfiVm2IQxVpA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by VI2PR04MB10716.eurprd04.prod.outlook.com (2603:10a6:800:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 12:37:17 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 12:37:17 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: briannorris@chromium.org,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix number to firmware version string
Date: Mon, 12 Oct 2026 20:36:23 +0800
Message-Id: <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR5P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::9) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|VI2PR04MB10716:EE_
X-MS-Office365-Filtering-Correlation-Id: a701e1e2-8add-42bd-01b1-08df285d8cc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|366016|23010399003|1800799024|11063799006|56012099006|22082099003|18002099003|260925022911599003|260925021911599003|260925021311599003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	dIhBQIJFzMbckFMwsJJPHERNDyceFrleVKL5S666GvRQCkcYOE2ZhvCnrkJgU1oZTWw1ZXcWDRdLJNyQxk8eZtJUwA2jRqjckE5SZleV7bsv67kCY1A72BDgug2EmCulknziY2wVhygLuCZQaI/U/I6g9EC2yd/r0ZEw1b/rQTa7fx9qy8dLduNCrEVWS0Np2rTH97Vf+++aWPHHEQTFHucGOcCpTI/c9zg8I1E/zBA4pJE1FF3E3z0BMONAi8kNwXu3c4ZlNiXwUw//fjKT23bsdYae/wvh4t6s1e6yBz+b1OMiV8j8an01n4I/tZz0ey8zSu1nmwnkLFnaBEnagyWNAvh8PSNVuT79zzj3Ns5+wKiVN29baurMgxr2uUWEGiaqZWAmNrWxzJRuY0ig4LBnQzXCYMqVR1KtIatf2bLCY4UAfA0PQE98jNcUjWxf9l24EwXrRUlj8cHM842pT8N/j7SMgLPpZPfZjoOSHqOuFmSXngmX6YfO5hbGyUQCrMR6MS4AHRhU/jP69+/1QvX8YpFwlxUZBwJnVOinOBF09ZeiJvJEDE8VCb/nbpJRjM8LOzShjKoxcG9gYKokazi3rtZOKuuFD+BqYL+JeN1k5/L6XG60H7vjC2OgABSBZZiN+69hCcHnHxEkYaVrvS7EDFmNfqz796OwKM5rlxE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(23010399003)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(260925022911599003)(260925021911599003)(260925021311599003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1f7p9P6MOGIFm1ATABvKmJZutJVqiuspI67cadkrJKoZQEbtyOIXKedaIBSj?=
 =?us-ascii?Q?3AZWXC6SqGbqwHDFrF1AJ/ZJfEU8Z5jM+9GfKAVycoMfOIHVVwIDDqPrriLD?=
 =?us-ascii?Q?kdLm14M/seQrswWgip9SuPJ+cFmxFD/+nOhbg6kNXyg4OckzvZvJVHbp4q4N?=
 =?us-ascii?Q?lsFVYulnv6zdFRbs8+GM/FtYJrsHLvbtIJAC8a5wMD+4k1VyBKcYqF616SCe?=
 =?us-ascii?Q?3JaT+DeJBjngeeOjZ1w9GywIyQRaDeBvwGa4C72T7CWmEAB2nJd3fZ8YumUB?=
 =?us-ascii?Q?S5cNtn8BcU6WYL4vSVnx5zcqJrKKqyxuqiM7fDiyVDSqdAQHcZFqmouzSsGb?=
 =?us-ascii?Q?21j/T6TbepNxJ8lb3YNMPj3Ab1rGuN7+Ywy+EC2uRy6TanbjOFSSQydq2s53?=
 =?us-ascii?Q?FoqmzB9IIKEciikxjix0JC6cJbIX1JrKF+FimAUh90Fei3RD7MZusllheQhp?=
 =?us-ascii?Q?ia8aPrz518hd+Nze0VJHM6Gr5lpltZS84zUKqXLXQiqwfQRO2spi7zVHudxt?=
 =?us-ascii?Q?DbAWizdQ+gZg4rlvo64Ualr3hA+QDEoJdOJvqKKRXo+7fTNLcaUBE0O04CwA?=
 =?us-ascii?Q?pSqydv38Bgo+NkNhohe4yNj0k6/1un0zeuQPfoD09867NjOpF9fb1OPOzaEc?=
 =?us-ascii?Q?N/tqC86CtckOJSh7Q4sIKbo3edNGPHEDoqbgzs3fPOR9+zP7fdb19Up44h6A?=
 =?us-ascii?Q?qytg2gim79Lqi0+U0OjNN84R9SyVD/mbkbpVy3hWW7ErYmVZj2w9h8hqB/oG?=
 =?us-ascii?Q?N6gXQ8mIySYP0HqnF2/p+0dkF24mdnrw+gNUz32Bm+VUf7QH0LPiq0SLcFmk?=
 =?us-ascii?Q?CkbcjE5mVnhtNTcuoEdHakJCwnAZKXgK8uWLfOqh2NHIfitAuJZU4uIPNrnw?=
 =?us-ascii?Q?u0Jf5OYP/EzbNs31PE+P570AfhC3GGHW9vSAIEnc8VngH7BHSIrWYr+LgURo?=
 =?us-ascii?Q?ZXuC9NDpwS+bVvwwHa4f9lta3Wct08qw63GhpkFquy3enjiFyJlK3A5IEZYS?=
 =?us-ascii?Q?/0nLr+UhTS91m5lBr3njfhfISkzKNxOcuRgNHpcCo7rYgbtB68rIqbDtwdM7?=
 =?us-ascii?Q?Z5h0aWjZaBYUsJZt9NZTW7CXx4V2dKSTNubtBssUD9xYnbNe0jma7McPbliJ?=
 =?us-ascii?Q?nJyTskb1jZ9X5aCYOsggA7hhbLwKHl2K7VlUB+3guhQ3DVP2LEyUrmJ0q/44?=
 =?us-ascii?Q?XKev3qZcMkVVaRTNrhbQ+hOvRnJ048T70aRbgQ+8bBT9+KkR89qfvYFdgUvd?=
 =?us-ascii?Q?nGGCOYGjitEJiLVHQZ8fBZQYnhsGydc156rcJmZk7L3CdVrBDJrLSTUaHMsQ?=
 =?us-ascii?Q?1gKZt+LieQoqwmvBuYNJ/qcohfZF4zFUZwHaMp4wC6ZV4Cfsv4NmyKBucnu8?=
 =?us-ascii?Q?Ao3j3GQSwhWJa76x0NTEiBzw7Bc7k5mA9RFR9yTAyn/2DpXHq5WZVmEg+fnK?=
 =?us-ascii?Q?+p2tRl6pzozLQAf7MNfHDjMS2GIyQP9roVEyzGubWx0ulLq7n3001M929ajA?=
 =?us-ascii?Q?MdXsWdaMnEseuBZNmkjjSatAKhMDwb0LA5Kn/5eMHvQYj/H/3viStNScVLjm?=
 =?us-ascii?Q?cEwpgejjhSora8uxkNSRY8HSaph6oki3DMsCwvKcMRT6zuSs6noHu0Hz2X/u?=
 =?us-ascii?Q?zzlzrj6TdFeVmE+SPio9iBlsoJPc6TXOvlqrUqmgF4MG6hLDQWwPRJU9Yno6?=
 =?us-ascii?Q?Ocxe/g42feECFxPezPSdtz5/BXUDjidAqlaErBa0c7ATkyzOk5SOlLLU1W13?=
 =?us-ascii?Q?2Hcywbr5nqCI1gAxFgR1zN5AqBVXSPtEV9D6QtJEuVh8XwZFpP0V?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a701e1e2-8add-42bd-01b1-08df285d8cc8
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 12:37:17.1987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0L/Z+J64I+Tv3ICmR1wXuPMtFqaXbPRvbaBq05AoB5JtqifqUxpiHcylGnuBxfYazy5WgK/zYr4DoQh72Nq91kwC7wwo2IG4+TUIqjgfeiOVuE30uzspgN5XdnswkVKY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10716

From: Jeff Chen <jeff.chen_1@nxp.com>

mwifiex_ret_get_hw_spec() parses and logs the FW_HOTFIX_VER_ID TLV,
but the hotfix value is not stored in the adapter structure. As a
result, the hotfix number never appears in the firmware version string
returned by mwifiex_drv_get_driver_version().

Store the hotfix version from FW_HOTFIX_VER_ID and append it to the
firmware version string.

Assisted-by: LLM sparse
Fixes: 7715d79553de ("wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses")
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c    | 10 ++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h        |  6 ++++++
 drivers/net/wireless/marvell/mwifiex/init.c      |  1 +
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  3 ++-
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 29e0f274575e..268a795db486 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1594,11 +1594,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 						    api_rev->major_ver,
 						    api_rev->minor_ver);
 					break;
-				case FW_HOTFIX_VER_ID:
+				case FW_HOTFIX_VER_ID: {
+					struct hw_spec_fw_hotfix_ver *hf;
+
+					hf = (void *)tlv;
+					adapter->fw_hotfix_ver =
+						le16_to_cpu(hf->hotfix_ver);
 					mwifiex_dbg(adapter, INFO,
 						    "Firmware hotfix version %d\n",
-						    api_rev->major_ver);
+						    adapter->fw_hotfix_ver);
 					break;
+				}
 				default:
 					mwifiex_dbg(adapter, FATAL,
 						    "Unknown api_id: %d\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 93561116959a..f254d6d6e3eb 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1104,6 +1104,12 @@ struct hw_spec_api_rev {
 	u8 minor_ver;
 } __packed;
 
+struct hw_spec_fw_hotfix_ver {
+	struct mwifiex_ie_types_header header;
+	__le16 api_id;
+	__le16 hotfix_ver;
+} __packed;
+
 struct host_cmd_ds_get_hw_spec {
 	__le16 hw_if_version;
 	__le16 version;
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 0c8925013724..e8a5f9b758d6 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -296,6 +296,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->config_bands = 0;
 	adapter->adhoc_start_band = 0;
 	adapter->fw_release_number = 0;
+	adapter->fw_hotfix_ver = 0;
 	adapter->fw_cap_info = 0;
 	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
 	adapter->event_cause = 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 8e6238c01aa6..5dd01bacc7cb 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1003,6 +1003,7 @@ struct mwifiex_adapter {
 	bool host_mlme_enabled;
 	struct ieee80211_txrx_stypes mwifiex_mgmt_stypes[NUM_NL80211_IFTYPES];
 	u8 fw_api_ver;
+	u16 fw_hotfix_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
 	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 19196848778c..1d3874734851 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1144,7 +1144,8 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 	char fw_ver[32];
 
 	ver.l = cpu_to_le32(adapter->fw_release_number);
-	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+	sprintf(fw_ver, "%u.%u.%u.p%u.%u", ver.c[2], ver.c[1],
+		ver.c[0], ver.c[3], adapter->fw_hotfix_ver);
 
 	snprintf(version, max_len, driver_version, fw_ver);
 
-- 
2.34.1

