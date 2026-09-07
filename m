Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazolkn19013085.outbound.protection.outlook.com [52.103.33.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBE3EC687
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 03:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788751563; cv=fail; b=p9yB6QFWlCksRteDVff5XZw5RnGplpUVq6yXZflAH17iOwxOg/wjzgQufGZiiNd5w6LEKt6Hn44/zv+jP/li37HxEd8O6kXdopBfa5171ohT1vbk3rLjZFa9AzzlnXd7w19irBta+wgYezK532ot81QOjRp0O4WNENE340D9Dls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788751563; c=relaxed/simple;
	bh=9Qj3kHMqCRYrKde+KpYMcd8j/n6B1iKqseSkyt9bERw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MRgiRf9W6PD5mKZvoGgD8bC3SuWQuw8rqpEP3I5UrgiYRb78FRv/W2sfpbOfgp2p+AF1bk1Gcskf8TsGgPSnNp0esTM1wOTwLKHZLgD27j77hIoJmz9RLy8Ms6ciSRmXdMXXjVZTJjBMIqMZTRKo9J5Lxl37Yc2qS9Zqb4bSis8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=fZu/RqA4; arc=fail smtp.client-ip=52.103.33.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="fZu/RqA4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mew/l+bOpiTeX2GebU83pwdrZPsFr4XsPxTY+0ln0H+KGQ9O1/qjuCsIzNmKG4eHmE2yP8Xl9Arhff8GcSrxtI/flmx8LGdMWTUpyFa2wumrJ/CFstxEpeE6SQ2DdexW6o06Wfp4IMNL+1cFTqWKW/BstBC8iIBEXhwHGnXnphVnApurh6wb5hHsxZJrWUCY2e9BDtuCZjy89QSBRSmjENIc61axtoRqHc6E5ROeSoW5zF3HRxRbcNrG/ONFoRC6CrZyCDTdg0B5J7jacjnn8jASPeCdIm71+3uHYkcsr7FPiN/TXrZfsbpCzrNh76zII2EvOdqP74vpzOB26uMgRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfKHQwhIrdDtbE8UQkDFNrGY+cmbsh1zdPuj3Q47WDA=;
 b=cqP9vrkgcBwrUED63vwD9CjpgJl1yoY9nQ3aL+dTGq9u52GfNUhRIrRbLQcWLhOp86gjLDvblbBiURVvFfQxIeKQ+i3fRovcUP/a06JUW7gLl0sb4qnR9B8cwC6AYKxB/d9NveeKzCFY4Nza1rBqT+7dmd2xoOZ2oTWkEb6LIA0EtAInMlydbLMWElqxoO68sf/aaBJejGI4ly2OQZQvO5UiuCatmr4F68uIte0fLyjxDjdkVpDlvQkGKkL2/QtcrnshfVoauUtq7g0ziP2vD2PlvqKoJEIHFIHYn1Y07wVZnfcht4ihiQehaSFJh8YvBSnnMP6UNicx7spbU3Qu/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfKHQwhIrdDtbE8UQkDFNrGY+cmbsh1zdPuj3Q47WDA=;
 b=fZu/RqA4lWwH+6p1tjVm2NgCXlLW0ANMIlkInno2YkbJ/3RhyIYQ9erG+OkpUSjN0K+6UHGIDsOFf/UjuPrcyJQabtCazR2K9og99ucL2semV4Q7hfBD44RZU6eO0Xau6Lp/QYGxVtx+VF6fT5LTyB+o3zcoFklls3ontUPDrLmi199m875o1kPX3qBSXi4IDeHslxYgMbtslNO0tCnsLHe2QeORbB4Uu3pKWUGvb4g9LiepyxwD0dDovBRPUlOg0WZ75MSVu9ezVzQOwBnvD7f8b0XXRSPqTePYcow0I5NUJgM8ThzYTJWpG0ObdIFaJiL5YgqYRuvdm7Qe9A/2OQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS1P251MB0679.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4aa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 03:25:55 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 03:25:55 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com,
	linux-wireless@vger.kernel.org
Cc: arien.judge@morsemicro.com,
	johannes@sipsolutions.net,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: mm81x: validate n_channels in disabled channels response
Date: Mon,  7 Sep 2026 03:25:52 +0000
Message-ID:
 <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::17) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907032552.516487-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS1P251MB0679:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0482fc-3216-4bf5-29cc-08df0c8fb9c4
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|24021099003|25010399006|5072599009|15080799012|12121999013|19110799012|51005399006|8060799015|23021999003|2604032031799003|55001999006|37011999003|25031999004|3412199025|440099028|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hmdgXG06rejH/DIk5EQoF+ZTEKYqWTY8qgq0lOYFwWkBdvApQ2YVnhaARqSH?=
 =?us-ascii?Q?He8tD1aYzhOp8b19RDTLXtaQ42665ZvvdgIyzSdUfvcU2sB51xZjhk1WD3Ud?=
 =?us-ascii?Q?We6ghWBbDNOsnM3JVJr0Wl2EqaipoOMnnjbb2pMtUEwBBIBHKCOjS9uXpR7Z?=
 =?us-ascii?Q?xEoQwTaAHp7mxD/f52TejJAd6i4cTvm511SFj3LKlwkp346pHSWdkbaUFS6e?=
 =?us-ascii?Q?1iXTwsYNxAt6gtYNALFXQq50vtMIz6sQV40eWJUJTCHpZ56eROXgrwWJIaEd?=
 =?us-ascii?Q?bORvQoGMp2lxvfbLhAHYSg+xjP/pCSsBeDZuDBmHAozTzv9736JzT7qyaGor?=
 =?us-ascii?Q?l+iul8boa/dUhLaf2itnF5/+JlA2HdhQohtcKD2BfJriwApc3aE7o46h/IAm?=
 =?us-ascii?Q?peBNpESHYxwmN7cKia3g+R5Y7SH4rEvKI9C7kp9GaKUhE9zt9kWluCfhuGW2?=
 =?us-ascii?Q?sxusij81XSehBXtip4JhlTiNK07E7W74LMNQmcvQunIl6HP6qPVp3+wUcAPE?=
 =?us-ascii?Q?omkHSazcqqMo4XrB6CnL5DDxAuqtK/Vs/704KmLYxNi6Wf9z9FSc9Jge2enW?=
 =?us-ascii?Q?Nxs12XjLpf7n9UvS30Nl/wz8SivGBgwJY9LU5UKCsgAhP7LLjZDpoBJQLGtc?=
 =?us-ascii?Q?jRmpwyVwED84h8/UORqZKjKJBP3/MUCxrmbO60q0aO2ceSmztViwLHbhlATF?=
 =?us-ascii?Q?9jUtZjy9CrRy2zlLpJFn3gCGgVn6W3t4IesKHMuhfOV6wVvOkfTBCtIeo++g?=
 =?us-ascii?Q?2VajjwHQa/kIzYafD3qWdkb7i/iDjPd4Bx9P++/Oyb0lNYw4dvxtuDXh6NOJ?=
 =?us-ascii?Q?VqKSMNen03UnB1N1wgRMcC3DfDWuf/UHidJ0IBwE3Se32OiJGVpTemyOTu7h?=
 =?us-ascii?Q?qXujkNA+EN6ZIj7SY5oYqKo7ztcZRzUHQnHNWXuUKl00wIW63TpNXun9XMdq?=
 =?us-ascii?Q?YD/SxytVBz8ib2Hb5J1/V7CV15QIdsTW31caQCvihWNFLo2tZOY0eDVqNo78?=
 =?us-ascii?Q?RrvRlO+9rCAfP6AFUBgnw3S7Pat9j8Vucu03pXKdgOFyI+oYnupa9AzHleX6?=
 =?us-ascii?Q?GzXighXo+p0AvdcEGNMSL5Gg94VZaRgoi5Bnq2FyXhWVhrw32rl/x3ccHg9r?=
 =?us-ascii?Q?WjXlQGIklR/0GjP1QtBb041Ew3dSyG2GXx3B3RyXjMyR8qMPvfUpAGI=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OGJzc3JiuSaKFcGytUdIGpdnqxmXe9I8QIJpAHrjJEg1BJ6Qw9OaEiNhvAMo?=
 =?us-ascii?Q?CwPVjk1aMZ9splSv+vtP9Es2XCN59zRKkPLt+AGFzY0YvFzwbod125f6ZWtj?=
 =?us-ascii?Q?iBpC/fwjHcqs1V1FCCgqLKLMDEHSyYEf0XaROKRliUmJcPPT1tLllZKH5pBF?=
 =?us-ascii?Q?YU8OuZ9ZwqmndDS/EcGY6YaO6e7c4IaSWc65vKQgv9dv3UYZ7ZED5R+7Ui27?=
 =?us-ascii?Q?r5r9tJMQo/iuAKPOAap/lM1JfTugLq4poMtn0XSuGZOKQJOVzGC57SXrsRzr?=
 =?us-ascii?Q?M0Tq3PbskI+WAdKm2dKKmYM20mDJ1/yorQdWkRLbHwUiANtpLd1QvzPKcEts?=
 =?us-ascii?Q?cDeYtBng69keLeO3lVmN/SAahoJ7ktAyOQbPCt/PtZhEhGZmYlASdD6yrc53?=
 =?us-ascii?Q?RfL3/bO/F8/y0zkZLBza+r/xHppoIKJ7aY6B8rv7UNjE8042ozMukdVWVdWI?=
 =?us-ascii?Q?j/luTPqxno2ONUUr9bRSCF6eD1qQEoNszFCS5XKdUt1FAsDOWhsybPc5AMEj?=
 =?us-ascii?Q?m8EOY+DLj3+U4BoPI5gASBu1Q0NJunaocvzftpeC+qhzEE9oOEfXT5IBNxGt?=
 =?us-ascii?Q?VIoXgQffhMBQp6c3dVrpI2yqhzZP7LcmbvvgT82r1kCxTRSSymAjC5mifUyy?=
 =?us-ascii?Q?xdiKOHhhn013vLNUia2HAN/R6CLDSmWSpZq+0TUy3CDxQ4f/FYBYVmY6+QE7?=
 =?us-ascii?Q?VA6QCqWlstklpLP6WpN7xqo+OEW68vL4zbPVhchA/JiUB8ufZDVLYEog3KYw?=
 =?us-ascii?Q?dDzR9tc8O5nmqIko7fbxd4DeP8MevqMszzqgcs/Qy+AatNiZLuJzfbNdgmXJ?=
 =?us-ascii?Q?JlQCDwCp16g6YpQGRjoJ/uu2KEBp8GWuNmvXGpYqpEIJk1Xnk5JSnP+Dg3Rq?=
 =?us-ascii?Q?aEZcJxftm/oeUEsoCsZ/uYcdU/1XHUqumfE37k6aPRjKp04B1ZwC7cawoYRd?=
 =?us-ascii?Q?n5XaEiR54Y5qk43eNst4GeUozZSiRIURgxdp1EdPudG7l6bI0OheBY/TlOQ8?=
 =?us-ascii?Q?SzDXF1uYLVzEdXYq4FRUiXG8nECpVfhcJY3hbPyMAWEo8wQN3vLdfaeGjlIX?=
 =?us-ascii?Q?gKjh+szoY2aKIH1eSQUbDLTAZ86fqQ7O1aAdjwyK0I7gqj5iH0sojFUTduCY?=
 =?us-ascii?Q?YmN6LlYckH7bsPKNUfMLvptQ2RaooE3BMPxGQHPQTxd1SlOP2fdLPUsZs73u?=
 =?us-ascii?Q?z0TlFo+avz8ux8mbHLgk/iHJmftF928E+6bITw/gyeiHVi+PU7+nhUjGZm1d?=
 =?us-ascii?Q?K2m0mkfPdJfDBjBhiPwFYxBecGStcc7NhrOL0hek2LQmHpVgkuzPyQrT0GhL?=
 =?us-ascii?Q?xVxR1n87f3C0b2SxSU8JAl8NOkgJPTmOrZKpJxoVCR7Lge0Bk3BVesTEYA/J?=
 =?us-ascii?Q?/pPWOGfOJvbKafxGFtUh7HA7AeVKB3k5VINyhist9jzzDCBwPfLY2aSJC+78?=
 =?us-ascii?Q?v4/I/HugGULyGM3TIuL0zHN9jJmFouph?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0482fc-3216-4bf5-29cc-08df0c8fb9c4
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:25:55.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1P251MB0679

mm81x_mac_check_fw_disabled_chans() iterates over n_channels
entries from the firmware response without verifying the count
fits within the allocated response buffer. A firmware response
with n_channels larger than the channel array size causes
out-of-bounds reads from the response buffer.

Validate n_channels against the array size before iterating.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 08ca116a68b4..e8ef0d9eebd7 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -288,6 +288,11 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 		ch->flags &= ~IEEE80211_CHAN_S1G_NO_PRIMARY;
 	}
 
+	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < le32_to_cpu(resp->n_channels); i++) {
 		struct ieee80211_channel *ch;
 		struct host_cmd_disabled_channel_entry *entry =
-- 
2.43.0

