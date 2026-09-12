Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013084.outbound.protection.outlook.com [52.103.51.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E9C357CFA
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 11:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211383; cv=fail; b=iaNrEItlBYujnhPut3yQ2zmvTHSQ5h2pqGynrEjnVfbmVMJYB22hyrWGS+pdyEUP2tf7Dnn7NXP6wa83MkHFE51/D2KZ5/98TyDQQKsBWf5FTqKGlQ06YtZIqn4OE3uVzU6O1ByNRQbdru090Yw3H8x+q0A1YDarvlbK2yzsWw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211383; c=relaxed/simple;
	bh=/z91ELSMrbWaudqyC1B0RUVY9aVHqMJSyNq1OqrCwt8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pmyVSDj2aqRA4YNUDT153Kruzlrjds3O6jxFq40AtHiajgFeqhO4kGGWdScMPotdGr/4Lb/e0/I0/YVtTpRD2QaJ1eixiVKzSXZD62yWJ6FELpoYKolO+HrM2WtYxawPRI65FXfC7VjvHPHczhaphlYMPL+o2O/L0uveX1Tbhls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=AOTC1fAo; arc=fail smtp.client-ip=52.103.51.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="AOTC1fAo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CX1Lcwas9K2vPFsgsiqV6V5l15SC8vHNcmPk5Lop3SkZk8Et4z4NkoKppNGRmu8D+8lp6NxlFceBbdeFocsENnmJquyb+hz+EhniBRkkzBZNlVNlTWUVvfJVsvPPvl/jFLhrOSkkuEDukbls8CyhID26SISAilkTw5VK0FTpenlpy7BiC3GrCbpco8xbFmKsHqEym5dxskumpmuwJK6tdWv2UNQv4PhHhoAymwnv6uRvia63E/eu0uSggQV7TE89hMDlu7GdSERWRHKuZyBV+67d4hhWBPcL+QFzOaimlVPKxbGtqqAUdjHJIrN0q2Wo+l5ibtb78w5RT0+SNO5E+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I68DJSw2P5rpq6Hreo1r9qQnra6KrtjxF8BG4zVyi48=;
 b=Qfqbrhli7mNklfhlcxUSvV28GOeMzQdcED66xGSlS7vfQCa2jNB9oGxAO/1e0Ves4mC6sWFeo/vJJX5EG1PE/RD21v3n7JtM4Eq9KTXdOCeSccJ1ZAxXn7yeHRF0sy8QniGbRSLgxz80N/XOnlvs500QHUb0/pfMKb9aVXQcPhlQn+cAtpn3RdbG6+X8omDUzyKGS48QSQ+7HPQxUeYZg2Yd03iGMOsj1tCJ2GPgikUN30iFeKKGcoYxjFgBkkUbUgNr4fH5ljpSfPDFRE33217VWL2Fy4B+MY6ctzaPHQQdpd/kKgAQdHcs/644QEhFTTHXRFV6DgF13Hm1TjuMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I68DJSw2P5rpq6Hreo1r9qQnra6KrtjxF8BG4zVyi48=;
 b=AOTC1fAopg4L5wG5yj+MmANTTQVkgfiZg2CAkcPEd+DEZcOWc0EGoiSI8VPAgXiYGTfr7bkGWfNf/0yN65bY6JAE3RFZH51/qnsKKtsSmAoPErIhl/SZtw+rKsZmHkFlhx8Ud+uDnrc/+NQiqGPOz+h6MLGTzeaDn6yBuckVFkr6J9RxBKF0PSxcdOaZbg/pN9Sr9tzHEHvF5zSCmJOcOiTRDAuk0JPQCrSB/fr2Fd8uhqDLYE+WVjNKeM+vJ1oM2ARkcgUF6fAghJRVcXpqyjhFy8U0TTNwbUYc/Lnh328gxX+D/IPKWm4z2z0GNJ1eQuTP4pGcvZAA7GuJSnrQWw==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by DU0P251MB0801.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:3bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Sat, 12 Sep
 2026 11:09:38 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 11:09:38 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2] wifi: mm81x: validate packet length in mm81x_yaps_read_pkt()
Date: Sat, 12 Sep 2026 12:09:34 +0100
Message-ID:
 <PAXP251MB0010B5D573F5186795C57072C8BD2@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0111.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::8) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260912110934.96057-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|DU0P251MB0801:EE_
X-MS-Office365-Filtering-Correlation-Id: bca46249-0477-433c-df28-08df10be54e9
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|41001999006|55001999006|24021099003|15080799012|5062599005|5072599009|37011999003|51005399006|19110799012|8060799015|12121999013|25031999004|25010399006|40105399003|1602099012|10035399007|2607281247196008|26104999009|3412199025|4302099013|440099028;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y8jTs2KzOmuXptu4ZFGjiyKpEn3Va83CO0FkYOGu0+wXDEEtmY2j0OQjC5oa?=
 =?us-ascii?Q?g0O/3fLZH7Sf5YwTRrM5vWL0atT0HXgNPAzhi6iUZbhWK4J4kTiYuMYyyOlD?=
 =?us-ascii?Q?DanQjAg0NjgOfZhjtGNArxS7KAFiSGSwfB0Lh1CEszXDOr2aBodcDfPd55JO?=
 =?us-ascii?Q?nBpVb8RHmZcuC5m4GF0lCJj4CG+CYKqOTrDOOkggVOt+VX2rbHjK+o0Y9MyS?=
 =?us-ascii?Q?vKHDS7MRj2sf6RDgKKDoE9Czn8SqPcdTjKPUFreU3icepFjaJUkO4VHV3tRm?=
 =?us-ascii?Q?A6DOo320UCYVYhGFEb2Bsz0aqN5+8i/h3SjYprb9L6bJzbU0DlPhlJJzjWen?=
 =?us-ascii?Q?QMquRKtf3stpuGTsawBYe4KaZbAmjQNcqk5VErazsn10n18a0NZkwuZNkj81?=
 =?us-ascii?Q?qeNG6oYAj0+iBlSS8veNsI87gwvS89vuU+NZ0YkdFqFnuxqdvS7Qradc1beq?=
 =?us-ascii?Q?t+mYwnP2pdlEsSMgCH35htU7A0GP7/yA+jwz3zukAM4+5zOORfn1Pyu4x01c?=
 =?us-ascii?Q?qN+IoNL/dP4AZYLBP9WkNprtwBil95YQOg9z4AmGwWqT6+iNJw8DM65KfVXT?=
 =?us-ascii?Q?qAxQrCgpEXscUD8SkdS/HdC9rVnkkrrO0CNJ5Qbe1vSUki7jK7GvjGmLgOt8?=
 =?us-ascii?Q?8vZw5WJzpD+Lb4s+XyzPqmroqZHcMUhu6vROl8wu+J6Ej/EZBz9axlwBPclX?=
 =?us-ascii?Q?7LXg96xdK99A0vG9gubWSH+tTLogH15rzuSElLzOa/GebIxQs+2oLovuzhsl?=
 =?us-ascii?Q?mVzhgtMaA8cjQ5Z0sJB5AMkiV9OKyVEWEx2L8l6fszgfL0F7Bp1LVFpwpjOF?=
 =?us-ascii?Q?+5m9yI3gX9Cs5FtrShxBuwYzJrl9ItzKh2ro3JVAyjJbI/3XPx1ofpANt3Sq?=
 =?us-ascii?Q?P1MFSLfw0vZoO2XreCFDM0r/CkZytN8erI+vDymttHlgoV7OLVT8KuA3Kldr?=
 =?us-ascii?Q?4oQNhlJyOaW6sC0HQjJip24GurdBdKcwp7ueXjxDJ8Yz0qDz1w56bXc1vYS6?=
 =?us-ascii?Q?6SOtgFAfdgjjqOkWgRr732zZDT5gHVbDk6oEqlvBIxWNciahZdis58/qtpH5?=
 =?us-ascii?Q?Q47i9ha36OhNuR6iHBLt/wRuHdHd6WrmwexMBjlbY8/HUMiiGv8r5BJOzpDO?=
 =?us-ascii?Q?8Z5Nsg9AuHcsHUy7nuvnBwQslXVF+mm568/uA1gRwFe/4NJzz2rS8YuL60gD?=
 =?us-ascii?Q?DVFILar+PVHXKKlIOxxKmd0t3DWHuot1TQ6UMmCe6mBWpm1TSlPRbqMUAlI?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xniWIQHovB/ZrEiVcyftWX0IPrgePNESfUtuOYLJya/C1Oq1sCdYH1eujm2I?=
 =?us-ascii?Q?06AGfcePUc9iUozUFIZ/7BaJRJORXQ1ukeaM8XL3H4FZuCA+y4DjUzXQF5GN?=
 =?us-ascii?Q?9vqONy4FIKZhJoUUMh100TVPBIQbm/4w82by59Y1UsxodjCEHwQDyj2iUDQq?=
 =?us-ascii?Q?gaCm0B4iRzO8aYwxF1Zjo6LwKSVtFsnXzKxtoXFcT0XQNX152amrvnPvO4Bj?=
 =?us-ascii?Q?/72gkdbEWIqL+gtFTDCyF5ylcwDVvdCu+Lfyzi6ZUXLyJaBuwOeJnBf07Osq?=
 =?us-ascii?Q?bCQgsw3Z8q28t6Jj5hxWWSDQ2sygUU6wnpHvE6Te+uaarFsBvSYmbxf1UbXe?=
 =?us-ascii?Q?u+whC2hrYpxGwKRxc72yJXx5HJX4RnhrersOyVusE4h/X47Zwppfeifb5h4e?=
 =?us-ascii?Q?C3NLZG12LWJPnFTBE243a8tpUa/+SXC1kxYTW9hxKeuz67Zzy44v/4on16iE?=
 =?us-ascii?Q?sq7bjATRF2KGXDf3BdGZ5gYfMPvmh6apNpDO7h+eG1OvkY1FCDGewVM9qvVh?=
 =?us-ascii?Q?qzsRprBrhpUecWB9u/uvPZAUHMJp1Tfy4gMlxVHGau7TWKRwg8aJ1f0wiLHU?=
 =?us-ascii?Q?J9F76eJ8IOmX7kY6wMvX6M5BgpcBzDeBuV/ZHzfeP8BVabKYQX3CPKP88NZW?=
 =?us-ascii?Q?awROQ9gdO803SeP2AWxvf5Aw8VOYnPqigJbma5obt7yt8qf4HaxuBgAYtj5o?=
 =?us-ascii?Q?9TufwLC2A5bPZbKwYN8B3ZjaORD+L66H7ZflOWWiP8qJDWPIVHhYsAVdZion?=
 =?us-ascii?Q?7GGutf53cHOfhRwkGIRMjX2lmo64qf6mXxZjUxNPv+5x+7O2uqyYQ0ZJkpgh?=
 =?us-ascii?Q?bSqm475jmCUqOI3gCFtP3HjyRARFoa5haqG9BrZs9YxFrZqeIO95fadj7BtO?=
 =?us-ascii?Q?0qoeEeH4rhsQos4pEgIByFsWGMBXgwNamZcRPZQoloTIQTeovYNHGFkdcvW6?=
 =?us-ascii?Q?+82g+RP/kSwEhwCOkgWMVb8eOeO2lV5fKHJwkzxJP0TTwMXAP3LeUNULTfTe?=
 =?us-ascii?Q?l39tEHNE0ZkIpwAcSdyFIXWYsDDLxKkv9BagxwpW/FxbtdaifqptrqcdSPiA?=
 =?us-ascii?Q?T0Mti4M3pqLUyC7PcDxqoRb39AmlbrvjdbmMmH2x5w3BowwNkBigmFk+xj3F?=
 =?us-ascii?Q?XgBFaenXo4e6pow+3EjZYFpqVtQJ8MqcFnLivm3Z4bxU1458J96rQRs+cv1l?=
 =?us-ascii?Q?nhIHg7p3K+20xbfciGxwTGsFabuSd3jvo2EcCJtQW28qGeU3JExoCpC9xpD0?=
 =?us-ascii?Q?d4lDBGAtf2Wmf024DoKGAjLQJtPtn6jZvki4RNsafLK9LOMgOl87ZX2fPHP9?=
 =?us-ascii?Q?EM3LJ2iuJOEMz/Nnla6dhHSzFIxcXSmauWdx7U46CfiBUTCwDfLHl4W0s5AK?=
 =?us-ascii?Q?9JCG4oqty+uQhTf6l+Z/LZimvoJU558ffsDUAzd2e8bm8dlKrB0TxFsEOWQJ?=
 =?us-ascii?Q?wiE5IPhpCXl9pGELHyZjD+1dascYHLzn?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: bca46249-0477-433c-df28-08df10be54e9
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 11:09:38.4906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P251MB0801

mm81x_yaps_read_pkt() reads struct mm81x_skb_hdr from the start of an
skb whose length comes from the YAPS delimiter, without checking that
the skb holds the header. The length the header claims,
sizeof(*hdr) + hdr->offset + hdr->len, is not checked against skb->len
either: mm81x_skbq_validate_checksum() sizes its walk of the skb from
hdr->len, skb_trim() cannot grow the skb to the claimed length, and
mm81x_skbq_dispatch_work() then pulls sizeof(*hdr) + hdr->offset from
an skb that may be shorter than that.

Validate skb->len against sizeof(*hdr) before the header is read, and
the header-claimed length against skb->len right after the sync check,
before the checksum is validated and the packet is trimmed and queued.

Assisted-by: LLM
Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
v2:
  - check the header-claimed length right after the sync check, before
    mm81x_skbq_validate_checksum() walks the skb; v1 checked it after
    that call (Sashiko)
  - move the existing skb_len computation up to the new check
  - return -EIO like the sync and channel checks instead of -EINVAL,
    and word the errors like the existing ones
  - commit message rewritten
  - Assisted-by: LLM added, before Fixes:, and wireless-next named in
    the subject (Lachlan, on the n_channels patch)
  - no Cc: stable, the driver is only in v7.3-rc; recipients from
    get_maintainer
v1: https://lore.kernel.org/linux-wireless/AS8P251MB0001B650C31E9F37C3B7907BC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

The other items Sashiko raised on v1 - mm81x_skbq_validate_checksum()
reading frame_control past the header of a header-only data packet and
ignoring hdr->offset, and the skb leak on the -ENOMEM path of
mm81x_yaps_hw_read_pkts() - are left for separate patches. The command
response length is validated by "wifi: mm81x: validate response length
in mm81x_cmd_resp_process()", sent alongside.

Compile-tested only (W=1 and sparse on the base-commit below); I have
no mm81x hardware.

 drivers/net/wireless/morsemicro/mm81x/yaps.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps.c b/drivers/net/wireless/morsemicro/mm81x/yaps.c
index e98a2a587..ba03bd9b3 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps.c
@@ -147,6 +147,13 @@ static int mm81x_yaps_read_pkt(struct mm81x_yaps *yaps, struct sk_buff *skb)
 
 	__skb_queue_head_init(&skbq);
 
+	if (skb->len < sizeof(*hdr)) {
+		dev_err(mors->dev, "packet length error [%u < %zu]", skb->len,
+			sizeof(*hdr));
+		ret = -EIO;
+		goto exit_return_page;
+	}
+
 	hdr = (struct mm81x_skb_hdr *)skb->data;
 	if (hdr->sync != MM81X_SKB_HEADER_SYNC) {
 		dev_err(mors->dev, "sync value error [0xAA:%d], hdr.len %d",
@@ -155,6 +162,14 @@ static int mm81x_yaps_read_pkt(struct mm81x_yaps *yaps, struct sk_buff *skb)
 		goto exit_return_page;
 	}
 
+	skb_len = sizeof(*hdr) + hdr->offset + le16_to_cpu(hdr->len);
+	if (skb_len > skb->len) {
+		dev_err(mors->dev, "hdr length error [%d > %u]", skb_len,
+			skb->len);
+		ret = -EIO;
+		goto exit_return_page;
+	}
+
 	if (yaps->mors->hif.validate_skb_checksum &&
 	    !mm81x_skbq_validate_checksum(skb->data)) {
 		dev_dbg(yaps->mors->dev,
@@ -185,7 +200,6 @@ static int mm81x_yaps_read_pkt(struct mm81x_yaps *yaps, struct sk_buff *skb)
 		goto exit_return_page;
 	}
 
-	skb_len = sizeof(*hdr) + hdr->offset + le16_to_cpu(hdr->len);
 	skb_bytes_remaining = mm81x_skbq_space(mq);
 
 	if (skb_len > skb_bytes_remaining) {

base-commit: 13e51269b6656768dc595ed6025e4974f2026543
-- 
2.43.0

