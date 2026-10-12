Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011000.outbound.protection.outlook.com [52.101.70.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AFB48C41B
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808649; cv=fail; b=fZKNntzPuLEKuoRpTDhYWlNLADrWSZAliChN9oOiph/VHpq+X51q57cEfsOZ/JSL7mLkuMVxcNO+q/KR7GRAlDX6RJNyDE6O1noZkCIzc5RD/DnBJHMGyPHvMq/OhD3Zk0bGZZkaeHz/WFOC+SLfI14MhDCaF8kAkvv17ON/khw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808649; c=relaxed/simple;
	bh=Dmdf4z3LrYrv4SS6dxREUMYBR8QpKa4Z+DxxoBWDVxo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GbQqmuSFD2Y/t0s0ghadlppzh3kXEvb+0FyrmBjM0aL2SRU0dVpotr1TqWz2Kc8W49vpK7R8SEzAfNnsWrrprUyo+x/aYIcO8vygYVyD2wBuqGGxK8FAGRRIeFikZPApTeSi+vJ1uhgRTN3v5cFkG0kHeIgbVbE0DIvN7p7ODuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=vY7kjYV0; arc=fail smtp.client-ip=52.101.70.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="vY7kjYV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BO1GV8HT78OOPqjZw4xDtJtTG09YullDfOS/rJGV1di72zsBfYPqZM+oaizMl8nkvCG1Pq+pNCUNr41NYkjObF9g6HL6T0yuXSqVo5ssWbaRisGxvKide96jGHTbM5RjtmLRCqMoo940RRbH1PrIDmb4T5tnxewKJRtz7s3mkL+ymZd6tDb1vuLP1oT/939QYb8Ty2EIfdRQEXm/LpW1dv/RKJNsj6elhgdVPU8v/Nx48vbsF+3OWQ5OvqGRdtiX/LO5YxAGOlIta9nEn5QQSulJyiBTysneXVYfw9IbTqiaY8Q1StakvM4JdX+2qQ2zF9hzv3Zduz6K68TRXwy9RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBLyFn8A4HAMbaiXJ8tvseYyn/ateLhclWs03dcRWIc=;
 b=KwnnMfx39Q6EOgTr2HAajZt9Y2PH7Rl1Jwh+v1KKXKl1izPLuKDxjDjlw0rDmEdCqjtsk9BXavBQEuPGKTQZL5kDbaiUBCm6Vn5THuofeGt5A8qnRSIeYx1NU8loo2x0B+yL/xWdR3BqDaUMZxebu6Fqq0PpXyH+y6tf6Vfq4w9sczArifDRhGWwSTndpGU58rpn2cr87XNC6iCCEFB+s8BMk0NrEk+Q8zXSImOu+ZuJrYunzi/syn5ymLnW1kwJq54copyPudrDr8/vPiH2Z3MHJFfhS+DoAVxMJV7b6R3bJGhl2U/0tVHUhtuVIpXxoIxoa2SS4faTZAjJf0qU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBLyFn8A4HAMbaiXJ8tvseYyn/ateLhclWs03dcRWIc=;
 b=vY7kjYV0EYMUCfSs8si00QdjAYLImyZyPKU8XD/SIhRMn97P4+6ghxsJ7dpf9zT9eT7d2x5rtomsFqvJKsDRY3jVCEifVa3ZMP6oqvx/rvM6qxEPKnqonWnMf3pz5JMQ0jiezPK+h06bnp9/jyWYwwvz6u1RQ2v+FKpkMwzLw+viqnszMtxKT0ZilBe6RRMYHOtPS9get0FjIZVQGNTgpCXoeGt+D/QU7Jdl/Ike2np0QMsGtqkFR616I/F3/cJGO1aXOiAHzUoKF/dQMrh1ubqB6YbItZlTISf/eXrP6Yz9/QoKNBlqb14+lhyEdc/WPP+/4KN/Y9miuYssH3QNKQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by VI2PR04MB10716.eurprd04.prod.outlook.com (2603:10a6:800:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 12:37:25 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 12:37:23 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: briannorris@chromium.org,
	johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next v2 2/2] wifi: mwifiex: validate GET_HW_SPEC TLV lengths before parsing
Date: Mon, 12 Oct 2026 20:36:24 +0800
Message-Id: <20261012123624.3147417-3-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::6) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|VI2PR04MB10716:EE_
X-MS-Office365-Filtering-Correlation-Id: b94ea2a0-6150-4564-941f-08df285d9030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|366016|23010399003|1800799024|11063799006|56012099006|22082099003|18002099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lyr+Y7LOk95SmOwynQsxjctwK8rsPYOIJNvVK3IJD4T88td3qJ/PyzSeODusU2u8BMQQSs+y7JxsnhItub4uPqX2UMebV9bMbtcX5jnxmUHtA4KrAHBoYddtBtbIRU1ydHLv48+hVAyF2eKHNFnk1piZrPFHwB1DsimQk1hTdjCUyjqIfraA9gGgFE/YmRAORRy6t9I42pgV9zDx00lFzYwahqu7v0AYQHyHFsd6dmZkD2k6vAPIDl6LZcW+bH33n7nW/8D+7dOachV1sgyp8SDaAirNcmsKvO3FjxYsO6ymWNlcen9SmutYtXug7TZiAyxd+mode8Mvq5FK9mb4m+SOHmtY2mb+SklXQrRS5e7xGtD9qJP8UBI4DsD/O8XpJFdhX0sPlJ4gJQdEJoTjprPxp9Ar4zXL3k4eFJI53+u5sdHjkBR4TMFJ3ttCr3/yFIziDKP4Oop6HfNrrML8HcfhD3D2gn7dhvh/8Fe99NaIEmn7BTT9hH3z/k6HTPAHb9JVANnF3TLhpwrSykrvJcEEpvlExxRZa6NXxYM7Dzw1lFilE++x2j3RqWx/I29gPwbIEZlCXRL0+WA14dOAeYKtyJgIDB0EfGCChKg3BZf31M2SdidMyBd3oSPIlnQEfipGxTffMDTzYnUKgmY4k8zbaZEBlXp/JiQXfuH8kcI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(23010399003)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ozr4Zhr2cp4/5R08ZzXHQfcPoZnVWPlGH7Iv6pRYxkkZW/H1S3gQbdDpSVbf?=
 =?us-ascii?Q?2LtIDjHXoaWiEXU6fvplz0B5wzKYs0F/L32JHxIlEUwIYThcTBh3t1EX7Py8?=
 =?us-ascii?Q?5qAMvtwA/vBjXXy6DilUGgNb8ldYFiRHGayYPsYXQeJwfxxJKrXvaUgdClnx?=
 =?us-ascii?Q?gtTnEGA+RQmz7sNDWR44NPkzy8Z1uqkcH3SZM4ML1OvTuvkMxMdbN8GT1xmq?=
 =?us-ascii?Q?BE1fAmBVcE02tKtnaudJgOq4mNjB9RAuoX+kuZkun8IJwmtCJaFw5HITf93S?=
 =?us-ascii?Q?uHmOsBIqybN2ZuA6BNO/Z+GNPZjvOSQBrffH0oDHXlpL/RHkuLkfJW2T+Ysc?=
 =?us-ascii?Q?tGAoOwG5tcHiZ8Ey4Cw7CByMtroB32yazua0kxjwG4Y/AxprjBsvgVykz7ab?=
 =?us-ascii?Q?Fa76jR+PQumfPCn7j/llKc/m2icP1F7x0gEOXYkISdVW8k0hVLud9DjqRv6B?=
 =?us-ascii?Q?PinwgGMC/Ar0FWWI6sC5krXm8Sy15a+i2mv9hcVR4DMVWFmJH1v1Bfg8xuP4?=
 =?us-ascii?Q?Fr2BoNXxOy8rDl/YjFpjrgVFvaq833JPJw78PLI+QGt0EcDD1wrOdxVWoQ+a?=
 =?us-ascii?Q?J0KBlyXRRVdAncdzDvjnDB56tPj78SbbS+yP5T9tJQJc+xFyP6/irvLF0Yz7?=
 =?us-ascii?Q?DtsPiaTLOj5tBAe1XnhQyftv8Q4rQgZut/7qvXTOqn5qzZEIyic1NZlNwmX0?=
 =?us-ascii?Q?3DpCbFG5F/P1srflrWi6zb3e+uo9LhwXCnc70T3nUulJIhB10b/ErkKwv2Wo?=
 =?us-ascii?Q?5dswyCjKgSryBF1AajfXruF7e5xCZcwIldP1mH5AID6sp4uB2r12xAOgRyvK?=
 =?us-ascii?Q?Je6mlonyTj+8J9lunETtGC+jbmzAoGejr8VQhPbeRCZuEPYIsrrGFdX99Fjv?=
 =?us-ascii?Q?2AvcIYYmI+l7bKQ9cBVuCGlIlx1jQWHyL1efjZS4hrvcG0OiYsDj/VlUpiw3?=
 =?us-ascii?Q?4h7t8F766fQ5tMtmQqxkjmvskODSgzUG6gYzC34TA2icn872/exN/FqO1kdu?=
 =?us-ascii?Q?mVpT6hpfiIVjVq3NmAi2fOb7cr72Gt5oA7SUl4+Zdk6Yg3xFyencqPJAEE3q?=
 =?us-ascii?Q?a5G8TUj1Ch6XOBPmAb4xP+CUPQj7h/tLcJVtEg0t5i9PtXxvtaDWcuvYQ3r0?=
 =?us-ascii?Q?CBXv709sMDr2JYvuVgzxbGtIr3O7Kj+ApQfZtSsO460pbh1dYh7EK9WuI5dw?=
 =?us-ascii?Q?P/YDCXIuCM1FJsbue4jBMpnpChuMlPn6lbhilpetvPucwtxOD6wSqZ/rIu4m?=
 =?us-ascii?Q?pwJVoCcSWQcB5GpXVfBVWcTKOGiC5qMjfG4aTaLTfCsXCSsur4tWHjSL36gc?=
 =?us-ascii?Q?sgxZAyXf4asZpoWcjVN0qyGPSTXipO65N9yhdEeuLRj647Pv1fD0EWGsXkGo?=
 =?us-ascii?Q?8osoSLuL/U6nYQ267DWpWyupUT9H9DU4lcabPng9is5FZKfOz+zMlJEobOi+?=
 =?us-ascii?Q?dgWoww5j/DC+TfEWdP0PAiU1q9jcZ+3EVrB55nTfHmDtEIu52eEC04R2KiFJ?=
 =?us-ascii?Q?4DVm2L8+0o8NNGI58gNOMvySHgvGdOUrYKubb5IQZ1Ng0b3AYus7s1jlfN04?=
 =?us-ascii?Q?aEHUxwvZOTIAPPRWKGC0LR0eIxBhZl2AFlgDmM+DI7/A0Xq9Ksu6JI5bu0nX?=
 =?us-ascii?Q?XvGhk5gSR+QwAYDH5KpmqlTa44AixXLWwMrUYo/qTC8CQ3wkhQCpaEdZdsta?=
 =?us-ascii?Q?wBPw6VK1MgTbed8DvabnR4H5Mywo2DoJ21Z6xYI9ziCaFFiCuLPHSEHf5OF4?=
 =?us-ascii?Q?ZxPzyu5hWD7k3wHYUFJcTuLPZScU43UiA0Y9uy4NAdpflNYiQLoa?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94ea2a0-6150-4564-941f-08df285d9030
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 12:37:23.0220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lvui2u/ODNMW24a2SH96EIbUouUNvF2khjHB0o53lbNsFR9WD5lRJq+YN50GTow3Ecr57ZCz/1wZ7xRa813PJBbSAks3PcqAfHQYtfjY8HXocXZZf9mGLtMQdCm9bj8r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10716

From: Jeff Chen <jeff.chen_1@nxp.com>

Validate TLV lengths before accessing TLV payloads in
mwifiex_ret_get_hw_spec().

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 268a795db486..6e04d7da6217 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1494,6 +1494,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	struct hw_spec_max_conn *max_conn;
 	u16 resp_size, api_id;
 	int i, left_len, parsed_len = 0;
+	int tlv_len;
 
 	adapter->fw_cap_info = le32_to_cpu(hw_spec->fw_cap_info);
 
@@ -1559,8 +1560,16 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		left_len = resp_size - sizeof(struct host_cmd_ds_get_hw_spec);
 		while (left_len > sizeof(struct mwifiex_ie_types_header)) {
 			tlv = (void *)&hw_spec->tlvs + parsed_len;
+			tlv_len = sizeof(*tlv) + le16_to_cpu(tlv->len);
+
+			if (tlv_len > left_len)
+				break;
+
 			switch (le16_to_cpu(tlv->type)) {
 			case TLV_TYPE_API_REV:
+				if (tlv_len < sizeof(struct hw_spec_api_rev))
+					break;
+
 				api_rev = (struct hw_spec_api_rev *)tlv;
 				api_id = le16_to_cpu(api_rev->api_id);
 				switch (api_id) {
@@ -1613,6 +1622,9 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 				}
 				break;
 			case TLV_TYPE_MAX_CONN:
+				if (tlv_len < sizeof(struct hw_spec_max_conn))
+					break;
+
 				max_conn = (struct hw_spec_max_conn *)tlv;
 				adapter->max_p2p_conn = max_conn->max_p2p_conn;
 				adapter->max_sta_conn = max_conn->max_sta_conn;
-- 
2.34.1

