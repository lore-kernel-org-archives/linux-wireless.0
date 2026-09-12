Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazolkn19013072.outbound.protection.outlook.com [52.103.35.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274BE36B924
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217455; cv=fail; b=EJD6Wv0yD+oAu7/6HjfDi43t2zu+TZY1bbpCCGNyjJ0WLe7qbuZbqVTjh2C/8XFlDRPTkynFI3FzvkbgHa7sY8bRZlIlyz+sVTNNAs25fON0G1uYrik1MQJ5QHJE/eGWNRi2HM4f1SaX1f4292rKtpkMlombuCS8zYYjQ+RRrVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217455; c=relaxed/simple;
	bh=ZjNS/CyhibxsEnQZSW6NReCMFYYyWWdjwZf6eDMOFrc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=avo7FjO8OI9Pe1ZooKXgLVohDMqe8REwlLxI5mo06ZJbH5xEOP5NQy9ozruf8I+0kHm1EqPoiImOcx6nME50VRgf1x0H1ImNq9+OwcqAXJKxfm43t2efCs4eh6/s42Qe9zk9IlXib6EWkJAjYYbjYO69YBr78WsFFymMIwlFElk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=DqSZi6RF; arc=fail smtp.client-ip=52.103.35.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="DqSZi6RF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BH2swdvC4OmwYHRSGm3v8IiEcUyTGr2f5vkwOSOahYnR8Uwu86ojgS9bhXeHn0CzYbrblhTSMkr73coIlhgUaH3Ki/SUBs7ReKrJOqzIgZULnVMA0LTDq848wH1BzF3/T4vnlEmUuNtz1R3f5/rTTTEPNCp2prNLy33VecrtOWkZlQvAXzanyAn6cHl0X6LSePPyCyfzOa/+93RLCBBDJYx9OVNUokHdQgJaxdI1/Fq/2JKlP/lwC4Wtl5U3gf8cFZo+uTLPW3k9dNPPi5jWNAShTX1MD4BHCaj6pEDZIaNWWX86TEaABGNB2+CgocnvLOpDwC8zRklU+DZ+y7wTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MA9a53sMh/bivYoF2V789oTzDl8rK5/lJN2QKL/2iI=;
 b=SXrO0RK5a7mSKwiSLsD8T5ZhxCpwikZi537uqomTOpliTsuGad0qwmD6La+UqHB4GUXQ8M+VrVUh/Ext0QsNEpcG/ooKlyeHg23O4mwi7vrZaqwF4SpcjhdUbc3UXqR5vXXBU87YF8j3J5WWyuOO9EYWVzILxTJDMg/KOuLYdHBS1jRaoOM4u9Y8pGNc4Ue0h/bCl++f51gBiEWcaY9iyHCN9AJfcWk0kigevIiBAuxWtzqoZv3ErdPZvkIp5YyrtRjn2BHIx6qNgWGKQ3gDgssYBhWDA5V6razCugqc+HVavH0RcKXRLoCul5jyD06VHLgIinFwFXFjq4rMgJZiQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MA9a53sMh/bivYoF2V789oTzDl8rK5/lJN2QKL/2iI=;
 b=DqSZi6RFCXY/MpETUc6BAgF3VPLsS2BziWH+GPSPqI5SOkvFaXaJq1vfFWErBXkCJ8lPxTcPN6LZ6gqMFBC1xNUG5s6/pS5THd3fpIHTzJ9oMk69eBNawa5BCQ6HoMvMFyr7tnYdcuFRMQr5LpPHu+6LZzbJoifeTb//zFqbCryo1nZb/MdfyJ7U2fjuJFW28Cw+ogn71Vzffu8KrkcQ/Co62irYd+XIaSBhreUQ75VEueoeErfwuEp828FO0kSylWvqVPTxAheqUBMSNnfpe1heeTMqejX59seY1IkAgrBnJDd3pUbFI0uOJNd9c6B7NpsDZx7tIl9ihIzDE5fYEA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GVXP251MB1161.EURP251.PROD.OUTLOOK.COM (2603:10a6:150:289::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 12:50:51 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 12:50:51 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2] wifi: mm81x: validate response length in mm81x_cmd_resp_process()
Date: Sat, 12 Sep 2026 13:50:48 +0100
Message-ID:
 <AS8P251MB0001CAABA8777F896160D202C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::7) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260912125048.9698-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GVXP251MB1161:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c819e15-5f94-4af8-f44d-08df10cc794e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|5062599005|19110799012|5072599009|24021099003|55001999006|8022599003|15080799012|25010399006|23021999003|37011999003|25031999004|12121999013|2607281247196008|3071699003|12091999003|440099028|4302099013|3412199025|26104999009|1602099012|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Eb1eObTj0uGaDY0QFX8Iw1TVkwTADyyGFD3OyW9wkB5eIYfyedEufwmnX+wN?=
 =?us-ascii?Q?PB3iAObwpJCqoKuRSIBiNij7FhnE1SrFxHOKzM5m98QIiyWZ5SAy4W668PVo?=
 =?us-ascii?Q?26w4iOUu2fWz0DGjKD9HxQPyJI16YIfobKWlEqIIO5YoyPvaDy0OrxGYuEFh?=
 =?us-ascii?Q?p02EQrPNds18pL4Jn3EMbKxXneDPJaBhUvGw/p3t32ZMsvE2eX23Ubtbd2dm?=
 =?us-ascii?Q?5OCSarJGiT6376goQgrT/AsJ39bX5CIJ4w9rliWlMxKwkyXmcO32I7uyjbMp?=
 =?us-ascii?Q?I/jFHikDA4noMGSHTQR29YoCz9rIZ7fYDJkcZtFTF2O3PZZWBP3Ijlktemag?=
 =?us-ascii?Q?bCgMkHG6aHAbKUMNUebQAD0rz6HZG51ZrlyOHlPV4G/PdXftmrsrUMlErVdf?=
 =?us-ascii?Q?fov2gSJlVXNQcMgsvTx/eNhc1kmfS0JQwGa30ywQtVR1vThGEZCVq53qwpxe?=
 =?us-ascii?Q?a95Wzxd9916YXFiLjRdsK0RkNwyo+arMLBn8YwWuwQe37DMDBM27k2E5FTVv?=
 =?us-ascii?Q?xugNUoe1vPHfZEe62ilzY/uCXuzaxjQhmFLGfudxFDcFo2m1csFygrJ8Wm1w?=
 =?us-ascii?Q?g75vEIiN7hiGwRkmu6a3EC4FYyNwN60LB/sKeJzebJ81SCzW4HTsJHCExU38?=
 =?us-ascii?Q?NC7agKYlYyaGrs30Me1KCzMH3PVipJM6obVt3/PJQ1C+Q+HGOtPt97FnI8Mu?=
 =?us-ascii?Q?8YVVENRpnVVrUd9JLhZlDyrjUxFe95E3RLvK3bQngIQIxunbNkHt1rtp5P1f?=
 =?us-ascii?Q?44jsStDL6hO2WsKAMcE4b9aoKFVTVewYZolENjSdaoDKCqI5sefDCH+OY1d4?=
 =?us-ascii?Q?7lFVtYybAKGnCR+OlX5z1v/7k7MHBwi0CdTYb4F0XS0kDbC965/vvDdIpa/B?=
 =?us-ascii?Q?xuKWmDwnX8N+wtGNzcYake89oaDwgrFcpjKlzR6Z8gFEFTWzSoPO2SsufDkv?=
 =?us-ascii?Q?ZBcYvIHyu26WRjkDUECQs3nGj+QOHGWfa0TXOlg8bv5fsi9O3wXg/Fp0sCrY?=
 =?us-ascii?Q?f1Hx5RBOVzzmtgZlKSpkC2wlwNpivtAaqrAfiPqIz700Q/IX1E7MTN6W3OB1?=
 =?us-ascii?Q?Z1zcQhYMbHkyplFg+uhIsWjUslokLx+q5fQFdjokhFY6m9lyT2QyJ/tqF3U1?=
 =?us-ascii?Q?M3Fedjm2B9AFBrNFnn9R4adNmHsyv/m2eoeoJVczTBNK7FJJiHXKOwVAwhhJ?=
 =?us-ascii?Q?i8/w4SG9J3D3h2OuljZc3OP4Ni/e8oAdPa9ybQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tgiGz09/cX61X4vPFJOdN5LgiZrDP4UCT/nBNrUnm0yOr5g0+aYjv3TAQHfO?=
 =?us-ascii?Q?sQmkKk82G+PU0qZOlw8HLZRKiWuzIX16k2YXRyA/cJ66I6SyuE6l72guvsgO?=
 =?us-ascii?Q?fTm1Qp+nLTjZxLLeZ7QtTkeKkHz+/BdWHdL4naS8DMaMxeKFB86MQlGZyhVj?=
 =?us-ascii?Q?IsWWVKVZEUP2CYke6OA98JHc1ERfuS6E3IYgH+03ppwxDhroUofV/4baec28?=
 =?us-ascii?Q?hXx5E/8OBjFPG8TFq6M2vsfCuhqXa4nXoXN8vJ5ASEMFFe1B6RGEbZ4oBG+e?=
 =?us-ascii?Q?anjFIN1hiBFO063B1XCbfU/4TeQYD6TzWstzdxTozTQ8cs35kxDsagWPxcBa?=
 =?us-ascii?Q?f+Zv+S9HCwKefi7lPPS91zZELmXUJzETWjPNIWqU0kGaQfSgCwlvreDHdjyi?=
 =?us-ascii?Q?U8TMMk14IZIgpMIKhfnJO8AvPJ0hB15yi7wz5YEJWXaRayVw3PyN/+PSoppo?=
 =?us-ascii?Q?cUh0rVpNjqjwtfZ6RFfPYi5H+2dL8nnFHR/Jk2bSiyvLC6pwZLfGW/AXbvg4?=
 =?us-ascii?Q?/EAI1ZBvOFT1c/6fNCOGxskIX4rn7aQ3gnC7JBfULM/RPNLlCMzMDgvcZG+A?=
 =?us-ascii?Q?J9pu6JOdUN0JnGKoV0A8QIFv6rfnIw2EIZQbkIhYwmE3v5wF0746SNO+f+Ws?=
 =?us-ascii?Q?7m8SVCAw/Emje507mG9rA4yF+R78zx1x/zAAX35M9R9c8DXee0jqFhnVWjJu?=
 =?us-ascii?Q?PDu1LiGG+hSdN8B+ZA5K2kmLjsPV0dyOezwbjfoDxDV5Eyt+SC+B1cEt5osQ?=
 =?us-ascii?Q?w7ovIxtPF9T2gylp2aw2ZO4Tfu9E3lnjzBEJn6pspTD0x5sV7cpgzoOvzekK?=
 =?us-ascii?Q?VLpmi6ChK0foi8U96zXpO1M7tVnfGnnfsIFH1wWFFfODVNqDB1xlVHZs8ipn?=
 =?us-ascii?Q?zyDE0NlTo21GWYEYOcZ3VQXxxlwFOgL6IK8EVYyxzqP4HD0Ooj4ktEXVwgi2?=
 =?us-ascii?Q?o+FZO/W0N1NRIseqsnkeKYmXo8Qe0DUSaYtm69aVY2FRtf6JczJIT8xp72Z4?=
 =?us-ascii?Q?CX1k46qlcUiPVYe4cKNpoZuvP7Et7XaMfU0aX2niX6ZhCa9e92S/m1j+AkZ4?=
 =?us-ascii?Q?MvHwK946eaS3FxMxchcmLcCiIgebBGKNjTs8P436d8R1tw0M5+PEZ7N66I/F?=
 =?us-ascii?Q?DrsJUYLkfgNlOHt77vBLi6j537q7DoBSGLFDyKLyIYZ7fWCT58AG1VsNpvMa?=
 =?us-ascii?Q?gsCYFUFYQ9/pnWyQP3JkGvYpvAnhILJhc77CQxsBqUGQ5Vx3Whh90T6fvvyK?=
 =?us-ascii?Q?pS8gia5ue8hEDqAmingb+ZcHYEZErGWlJTGbdxwCHdXzcWZrA2JpdsZV55k0?=
 =?us-ascii?Q?n8mBNd7MZus4JRkcEZDCJKG7Sg+w3nXFrpOOAAvuM07Gluf9YY1/HqX29gUD?=
 =?us-ascii?Q?SI7TuVjjYH+OR7kZhzRtjGjGv2FKV594YGXBhcY06sVHR075H+/a/AI36eTg?=
 =?us-ascii?Q?nOd/EIDdBMtlY177mGN2klXat+eWynPX?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c819e15-5f94-4af8-f44d-08df10cc794e
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 12:50:51.2656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXP251MB1161

mm81x_cmd_resp_process() reads the host_cmd_header, and for a response
the status word, from skb->data before checking that the skb holds
them, and copies up to hdr.len + sizeof(hdr) bytes into the caller's
response buffer without checking that the skb holds those either.
skb->len and hdr.len both come from the device, so a short or malformed
response reads past the end of the skb. mm81x_mac_event_recv() reads
the same unchecked header for events.

Validate skb->len against sizeof(struct host_cmd_header) before the
header is read, which covers responses and events. For a response,
validate hdr.len + sizeof(hdr) against sizeof(struct host_cmd_resp) and
against skb->len before the response is matched, and bound the copy by
that length. A response that fails either check is dropped and the
pending command times out, as for a mismatched response.

Assisted-by: LLM
Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
v2:
  - retitled; v1 was "wifi: mm81x: bound response memcpy by actual skb
    length"
  - check skb->len against the header before message_id, host_id and
    flags are read, which also covers mm81x_mac_event_recv() (Sashiko)
  - validate the header-claimed length against struct host_cmd_resp
    and skb->len and drop the response, instead of clamping the memcpy
    to skb->len (Sashiko)
  - drop the min_t(int, ..., skb->len) clamp; length is u32 to match
    resp_cb->length and the copy is bounded by the validated length
    (Sashiko)
  - Assisted-by: LLM added, before Fixes:, and wireless-next named in
    the subject (Lachlan, on the n_channels patch)
  - no Cc: stable, the driver is only in v7.3-rc; recipients from
    get_maintainer
v1: https://lore.kernel.org/linux-wireless/AS8P251MB0001B37B237975CAE6092B80C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

A response shorter than the caller's buffer is still copied truncated,
as before; mm81x_cmd_get_disabled_channels() relies on that, and the
fields past the copy are left as they were. The 16-byte minimum keeps
the status word that mm81x_cmd_tx() returns inside the copy.

The pending command skb lifetime against mm81x_yaps_flush_cmds() that
Sashiko also raised is left for a separate patch. The outer
mm81x_skb_hdr length is validated by "wifi: mm81x: validate packet
length in mm81x_yaps_read_pkt()", sent alongside.

Compile-tested only (W=1 and sparse on the base-commit below); I have
no mm81x hardware.

 .../net/wireless/morsemicro/mm81x/command.c   | 30 +++++++++++++++----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/command.c b/drivers/net/wireless/morsemicro/mm81x/command.c
index afb7ee9bb..7c9078873 100644
--- a/drivers/net/wireless/morsemicro/mm81x/command.c
+++ b/drivers/net/wireless/morsemicro/mm81x/command.c
@@ -145,19 +145,30 @@ static int mm81x_cmd_tx(struct mm81x *mors, struct host_cmd_resp *resp,
 
 int mm81x_cmd_resp_process(struct mm81x *mors, struct sk_buff *skb)
 {
-	int length, ret = -ESRCH; /* No such process */
+	int ret = -ESRCH; /* No such process */
 	struct mm81x_skbq *cmd_q = mm81x_hif_get_tx_cmd_queue(mors);
 	struct host_cmd_resp *src_resp = (struct host_cmd_resp *)(skb->data);
 	struct sk_buff *cmd_skb = NULL;
 	struct host_cmd_resp_cb *resp_cb;
 	struct host_cmd_resp *dest_resp;
 	struct host_cmd_req *req;
+	u32 resp_len;
+	u32 length;
 	u16 message_id = 0;
 	u16 host_id = 0;
-	u16 resp_message_id = le16_to_cpu(src_resp->hdr.message_id);
-	u16 resp_host_id = le16_to_cpu(src_resp->hdr.host_id);
+	u16 resp_message_id;
+	u16 resp_host_id;
 	bool is_late_response = false;
 
+	if (skb->len < sizeof(struct host_cmd_header)) {
+		dev_err(mors->dev, "response length error [%u < %zu]",
+			skb->len, sizeof(struct host_cmd_header));
+		goto exit_free;
+	}
+
+	resp_message_id = le16_to_cpu(src_resp->hdr.message_id);
+	resp_host_id = le16_to_cpu(src_resp->hdr.host_id);
+
 	dev_dbg(mors->dev, "EVT 0x%04x:0x%04x", resp_message_id, resp_host_id);
 
 	if (!HOST_CMD_IS_RESP(src_resp)) {
@@ -165,6 +176,15 @@ int mm81x_cmd_resp_process(struct mm81x *mors, struct sk_buff *skb)
 		goto exit_free;
 	}
 
+	resp_len = le16_to_cpu(src_resp->hdr.len) +
+		   sizeof(struct host_cmd_header);
+	if (resp_len < sizeof(struct host_cmd_resp) || resp_len > skb->len) {
+		dev_err(mors->dev,
+			"response 0x%04x:%04x length error [%u in %u]",
+			resp_message_id, resp_host_id, resp_len, skb->len);
+		goto exit_free;
+	}
+
 	mutex_lock(&mors->cmd_lock);
 
 	cmd_skb = mm81x_skbq_tx_pending(cmd_q);
@@ -206,9 +226,7 @@ int mm81x_cmd_resp_process(struct mm81x *mors, struct sk_buff *skb)
 	dest_resp = resp_cb->dest_resp;
 	if (length >= sizeof(struct host_cmd_resp) && dest_resp) {
 		ret = 0;
-		length = min_t(int, length,
-			       le16_to_cpu(src_resp->hdr.len) +
-				       sizeof(struct host_cmd_header));
+		length = min(length, resp_len);
 		memcpy(dest_resp, src_resp, length);
 	} else {
 		ret = le32_to_cpu(src_resp->status);

base-commit: 13e51269b6656768dc595ed6025e4974f2026543
-- 
2.43.0

