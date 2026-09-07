Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013074.outbound.protection.outlook.com [52.103.46.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BF92D0C89
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 02:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749947; cv=fail; b=LjgY7l+5RyjkpxVn3KyW3KPZSzoPR+p9Sz94u/7t/mvmj5GsA8j1X+SvpukDjA1esCKpK+uyT7etM455PEnTjGFgY2oz8pBHMrDsPIVAuRqEkiUd3gINUQpolQMI+IamJtl3gOncFLlLqadFd5jyuC+ZGoVRjDxKO2LLYmyOK5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749947; c=relaxed/simple;
	bh=ISNLjBdxv9yuNyLNZ08balE5B7bTqCMquIfJURsWCM4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PZC2ORXLJl0Y4M7tntWspCSpODgZaN7sEIcAt2dxrhNDC335aO7wnN+hjwfFR/e6MoDbNTdfS47sPjOhyWKg7WRg18JiDc8pn9t7EgSTqOy/RyH9GS9zzY2VgCDBoEdEc9Z47fkWpdWjsp2/XNfqGJ/+/E/A1pMsHvghOae6psI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=OmvUMe4d; arc=fail smtp.client-ip=52.103.46.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="OmvUMe4d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bi0QYZb/26DhFAx5jolo1w3ip3QXkqof6ebl/f40zM0MLTH7FvYV1wYu+dI9KAtcB5RSKpls8fUyZJ4am26NKb82mqivurxJl7jVzoFDXjEn5khXq+6lVyYVp12PA3T9RJQjSUXw1CXmXIRqOTX8tvibgvY0uc/hQUk9Ggj51Ym/cI3M3Q0o03VG1CLKzRxYuQNzy6Qs18hHcPWIS62JQRuX3BWp4D2UGRkYR4kdJAiOPkp7feji9hIzIOywsbLdz21yTMBVSJ6iiomXOywrG3nMcdTPscdyYsxcWBjIOB9JE9nr0T8EqFpg8Y0RRGrg9xcRyKT6fSiDtE7d768/GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVrvUSD/A5HOxmbLhiooEatMcMcE69/jebHtDecLo6o=;
 b=dd5CWjCNeY2ljZDoleeWtmRJcyeoD1lKp3djnSZhj/4UYWQMLKrl5qqIWBX23RgyXlbxz+ztKdafCVHiZtUjOK0j3Kz5VznxPtKJt+ITB6j1JO6nIRl2z6S0awizpRP4evBvBq+zZIjieDrStjvM8MNmlR/+mG8uMT/PFevT8fR5zSrbXKrDB1CqP2rzfImVE/8va29RGoyaetu3MpmK0MZpaBkO/Vz5wYyApkB9nL107ktiCJ6Vr77xUnkUPjWkbbsTZKEefTvNhE8ZtajQUBYtwdzw2x0+xjoopFusADYh25qfhRFcX8b7b/mPYnI/eqpPVsnnr04yI2RLG/X+YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVrvUSD/A5HOxmbLhiooEatMcMcE69/jebHtDecLo6o=;
 b=OmvUMe4dr5MLo35i4+2RJchdRqICcO7weclRbazogG7lI4TDdRhywNqm5uyI2MrQQTyjLD07ClmduWyNx6iVDB71r0InOzXAzh885BISNIpWqPds0RRrc5XmKUvf82GxaPfBnuOwMDUAXjeP7zYSFMgyqzPnjKgMhAn4UI4+MQIGP0uVwmZHu23sW0v9rt3cEz1QEwqLAGojxJEzWNgBSq1I7HQ3Rwglg6lrkbD27TybT4cJh1+JUatRWoM5bwZWPmTYvZfbHmb60AzrPq/WvwCGBP+y23CQvlEf5n60wXKZl5jk/wa5bElgN36TOFXGpYFJry191tTcKDXJiK9PCg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PA1PPF7BA71296B.EURP251.PROD.OUTLOOK.COM (2603:10a6:108:1::21c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 02:59:03 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 02:59:03 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: jerome.pouiller@silabs.com,
	linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: wfx: validate num_tx_confs against HIF message length
Date: Mon,  7 Sep 2026 02:59:00 +0000
Message-ID:
 <AS8P251MB000103B16A46379DFADEDB21C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0029.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::16) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907025900.508314-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PA1PPF7BA71296B:EE_
X-MS-Office365-Filtering-Correlation-Id: db793dba-0a9d-45a2-8b7c-08df0c8bf929
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|25010399006|4140399003|15080799012|2604032031799003|19110799012|37011999003|8060799015|41001999006|25031999004|55001999006|24021099003|5072599009|5062599005|52005399003|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4a4DGnTArOLARtdegz8/BfUvKxFL87t7E1SN9jJ4rthJsXUMKeAfj8JO9xT2?=
 =?us-ascii?Q?qFiuMBTjaHeQnsFZHqFS4AFXv2Ne3XCDDgbaFHR8o15rpnPqor7V8KJ8zCq2?=
 =?us-ascii?Q?NXHbD/hkkB9HFWa+G+85Y4Cfs1udBdP/b8HZ1pnxC21EyG3ArwoypiGuYHXx?=
 =?us-ascii?Q?NuX4sng43Q+7OCapsiL6VR6E3V5cEy5ojfFuzHGaBrhvJkWKfqWhH4M2f6Mn?=
 =?us-ascii?Q?+as5Tc8PfObtf9BadXANF5AH/A47kINyUDiLJfCASFkWFbXLP8cgEDR6Sqjy?=
 =?us-ascii?Q?rZqcN3CO6D/dZiXPYmh8lTnWCzE3++O97aQ2cuWy47a/II6ohAVtJmmsWSoR?=
 =?us-ascii?Q?NzcJfTI3MTLgt6JIMJbCWKvISXtoKCyROn411YfOQByYsj21NVBIy3tNFIvJ?=
 =?us-ascii?Q?Um0qZhWVlEfaRW/t03MtC7JnebLNrGT3J3aIboKYDvj/ZswcWbfV8Ohq5w+/?=
 =?us-ascii?Q?hX2CIfZ8yTpRDWsKJ6i7vyAJiTBrY4HFcbDlExWzZCLPY66ySZIUycMwwRKy?=
 =?us-ascii?Q?BETbWIbTUT6NrqAxhFLeIS3jd2qsMO6YPmrowE+nVafwJn3u7LI0YvbUYpyG?=
 =?us-ascii?Q?H9ZefC+DSvKE8Pybhq2S97Vz+0J6GERFR11p/AGYn4eCcod2cQ1g3GIBoyJY?=
 =?us-ascii?Q?8dqS8G6Izhpgx+k1zD1m+du6JsaDqC3tA1jl8WFHLhYrLTzFnkPdl8QBSFK7?=
 =?us-ascii?Q?AWxX4JcK4B8sZzcuEfBOZ1L6C6Z+cPZAkeUkZuMCOnhLhPWbrpyCXrnzFYe2?=
 =?us-ascii?Q?UqIkrStJLTfWKj47gGi7VBwUJ+9tWSz1UlLgHCv7WNXFY6qCwyrFaA/tg1MI?=
 =?us-ascii?Q?nvyfRTklQKefWkLF6cLNt0T1fjxIbYyqPE6u4qRa+lsjYl3DDKRshA8RuWrA?=
 =?us-ascii?Q?EnSsrg3WIgboYCWW1YtABI/iIlrgVKjE9G0OO/VeS+huSyErBzrHK7V6DK0Y?=
 =?us-ascii?Q?PMMWra6C7jiqFZjTDIuSLPEA8y7XaAXHey9mm5o0pfn+azdhGyuulw6DEFwT?=
 =?us-ascii?Q?iW/B3WwjiJNXYBFhnXBCPGtVs4GaU3PoqTz/TujDt/kx31WToiCEfk13rZQX?=
 =?us-ascii?Q?/wUPJnqiwsz157FHVbLu1YUj+NMxX+USkjvbrzdvNcYfuSS068TlJs9GCi36?=
 =?us-ascii?Q?eP50hnzhCGPoygqepVnTaNyAxy+B2ZVbC0/6hhxhWTCTpiCIJ+LH5p8=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LXL/yMig8RnyXrHb9PNry5eWTXhEeIPNkHaU8CJ9FiXcwhpx7i//DG7jDckI?=
 =?us-ascii?Q?p7KTuPTPT/9kavST1bn4wcmgfxUdYUme4jEDC3elljSS26RzntlTFvKDWckm?=
 =?us-ascii?Q?4hRHjlJvTwcIzsBw0tfeT9WukV0Sn11wKJ9YWRCgV92ZGiAtahMui9ycWE1q?=
 =?us-ascii?Q?4f9tqilsh9fZvfIxH4+0D5hAWvxP5XbJ+GAtMDanvUAfs2IUky+QZJLoDD8x?=
 =?us-ascii?Q?ivW7/k/4jNuAs7ebrxHPsg2UhzKkhQ/WeWo0SREjsqyoWpCljvCHjvBL3Q/o?=
 =?us-ascii?Q?MpQUJer2I66A9EV+E7pfi946SvOMvwrltLk2pDHov0llsk0Gr9M5pETmY1xg?=
 =?us-ascii?Q?TgkGnUrJFL6H8fphCrTBdKYtEDzDPRXs4gRessg8D+Y4H2h8yvWX5Jt9414j?=
 =?us-ascii?Q?cEyR0+HXkF6oYglAepNyFSLs2xJcloeBpuXgIbStP4gBP5/rGQvGhotXf4IW?=
 =?us-ascii?Q?Tj8GTjElf9nxfj29MSd7hXJHrYsVQ1iAtiv0tQt+ZRFb8EO18RAVyGIjvB3y?=
 =?us-ascii?Q?P9D5lFnedeIJBfFZuto7RlFwu4VAgEwy1KOSOH26d84vYi90uuYoGMS9A53/?=
 =?us-ascii?Q?3FYOlyjk6B4Y0OFZ02AMXG1A1euBBEtoq5TIlnCyNwZlcvg3TCpvHoP4owTC?=
 =?us-ascii?Q?Eu0m4W9B+gGyyocMQBskId1meMbqh1KZPm22tc6PuYQD94PjYJPwee5wWRC+?=
 =?us-ascii?Q?ayB2cMXCmN3BJc0F1rKxmInvttRdBNr5JbTe6rOA/i9CSyylWG+n9P6F1825?=
 =?us-ascii?Q?rm5jtnZAGd4OoVfBA66jnJZnZMzaRoJoOrTv0MleKsvJ8SjKP+Km4j887/hg?=
 =?us-ascii?Q?/YKUDwODlfLv2IScicrZySuDERGsNbT7IU23USQ7Gtv8IH08OOhLKKQiHXGr?=
 =?us-ascii?Q?Cq5JZNaLiF7JXpY3+DFH9dIYKwtUAuIkGRhaT6a959efXfcRK2b7NstzWTGR?=
 =?us-ascii?Q?U0+O5pdMjDphGxsqp3P2A+is8Ot9iTr+9F+5YzAAl4AG2k5zaMoCf/19sA/w?=
 =?us-ascii?Q?KxGvyh81FRIxs50AZsjQNLQ5jk4hfaljh6PfB+SmBGGgAzB12/LB0cU1a5/8?=
 =?us-ascii?Q?24aafIAtMBukIuLLu+eVwPAGJaTecKI6+efi+xv31urI4oYyj6+x66r0kPJp?=
 =?us-ascii?Q?M6oDAJP5r2zoWUcSxYavcChT4LVKf2SPvmDLGbEfxtfzktrRQuw64j4cI6JL?=
 =?us-ascii?Q?eNk9Y4w8Tbu2KPtzET+PG40PYr2K2lXPyn5sCyynV2JF1Z/UsfONvAeQJHrc?=
 =?us-ascii?Q?CGIc+IcPs88LaZAC+RHn8nqphOCbbgSbkJLvndoLUDIICsevnC0vhDPZu5Sz?=
 =?us-ascii?Q?JwbuIFBy7tRCeY1uqCHb3Q0m96xnxDtIz230F2y/poFRtExLCjfl4BwLKr2X?=
 =?us-ascii?Q?UYnglnoLsWKBq6oIXWGp9CDWnXm/OM54MpDDHEsiwbEizeOOINLytG1mq+RC?=
 =?us-ascii?Q?fGUzQRPdDA/Mz0zX2Ph4hma4yIhiHBRt?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: db793dba-0a9d-45a2-8b7c-08df0c8bf929
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 02:59:03.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PPF7BA71296B

wfx_hif_multi_tx_confirm() trusts the device-supplied
num_tx_confs field without checking whether the HIF message
is large enough to contain that many entries. A malformed
or corrupted message with a large num_tx_confs value causes
out-of-bounds reads from the tx_conf_payload flexible array.

Validate that the HIF body is large enough for the fixed
header and the claimed number of confirmation entries before
iterating.

Fixes: 9bca45f3d692 ("staging: wfx: allow to send 802.11 frames")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/silabs/wfx/hif_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_rx.c b/drivers/net/wireless/silabs/wfx/hif_rx.c
index 64ca8acb8e4f..683fb67916c8 100644
--- a/drivers/net/wireless/silabs/wfx/hif_rx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_rx.c
@@ -62,9 +62,15 @@ static int wfx_hif_multi_tx_confirm(struct wfx_dev *wdev,
 				    const struct wfx_hif_msg *hif, const void *buf)
 {
 	const struct wfx_hif_cnf_multi_transmit *body = buf;
+	int hif_body_len = le16_to_cpu(hif->len) - sizeof(*hif);
 	int i;
 
-	WARN(body->num_tx_confs <= 0, "corrupted message");
+	if (hif_body_len < (int)sizeof(*body) ||
+	    body->num_tx_confs > (hif_body_len - sizeof(*body)) /
+				 sizeof(body->tx_conf_payload[0])) {
+		dev_err(wdev->dev, "corrupted multi tx confirm\n");
+		return -EINVAL;
+	}
 	for (i = 0; i < body->num_tx_confs; i++)
 		wfx_tx_confirm_cb(wdev, &body->tx_conf_payload[i]);
 	return 0;
-- 
2.43.0

