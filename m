Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazolkn19013086.outbound.protection.outlook.com [52.103.35.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE81A0BF1
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765448; cv=fail; b=aqGf+oGsOeeB0HggZnCj1qhJ56IjvP+SkaZKZrwEEygiAtLCy4B6fo/W/LHSBvPBoyBAghoeXLS7FEBvHNRCtrBtd98nkL5blKlVLsg7hwUNuaHfZajZapPZMEHB4Km0sYHWCgAASHy77EcM2PoDIrMK+8ekrVzNecfILHs6bu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765448; c=relaxed/simple;
	bh=G1r3bZk0VBNoFjCEUXiNtMr1VJ0Y5/pDFyxgY0+85i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s7+Aby9P4/5wwqagfuBdm6zn2IiR3jVRsfT67I2Okvt+cmO+0DCQFc7WZTx+E5/uKf8X6CJsd0gvxsKdP05tA+qN/2sbqzs8eNFkeFpUcgAS7x4zmSF70y32QZlari5JuQZnnB5K4Y/3KBzwqGTC2wjObGef6yKMsQ7A9Qerolg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=OKfzTztR; arc=fail smtp.client-ip=52.103.35.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="OKfzTztR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tqLr2UqICYiBqxhnfvqo8/A2I2LOkbG9xT9Y5UBSF0mapNmygMh3ShsS6HaeyPSp5r7TlTStwA6e4/gXdLyNhsxqBn/wxAiM4jI7viPiAwfuUcEMwZv/NRxyUpl/zwYREUVcWd9/ycpqC5lWdG3Tr9ow3VDLGltUntNcP+apYdYoYFaa9ZV5fOjBCrrazc5KzsQ13BY9pEST3heNf0IeRaWzfp4+0rMzrdEogO1FoPTCCvoWZCUAi5snW5AHD4UiuzgVqVevxxAZTpQUW1/Einq1eutZfhHIibwzE3ogkJZ/SM7SACUcSWroAg2FFfPTIpJu21NWuL78KOqbxudpHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20LYbp7U7lJYEbLg6QlfXBWAPD1Zvsw2fEkYGPT8YR8=;
 b=LJoe5j7nOXSBN5cDIVooykqp61wK1Kn7cfFZiZrSUOuYCAodDE8wvyhDE/gtgaEHGRbPYYH7/aZqvkzCxbByza93tjT1IHiIige7N+M8iRtBaHapuTh3K53kflbdVP1eKKVlZvwHlGMivKaQwPBoc7lNNNf3WylC6YteQQjVc8fjykDXqBq47i0nA24mSUbes9ND/a99MSuh5Nd8rjZqV44dU0IqacVMZs2q8BnUTFtlRuCCj17fzhSCgNd0nOLezuyS51WOGO0YkIXjKzxhooRMKvFoPw+Okl0GEricenRMJumr5cKN88TU6gK+fjqOP7SjBiHZMDfZjO+3ugjohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20LYbp7U7lJYEbLg6QlfXBWAPD1Zvsw2fEkYGPT8YR8=;
 b=OKfzTztR4ySnHNzcfMLWw7DikB+Qg1Vq2ytnFJo2TgHiupWIpSLpMhBJtp7ZTUmCQSzpnLOXhhRvlSv9sn4Afirdvak4rBacDd7LgMlzILo7fG5tHNKxzfUv7Z5X7FP2WsymGeumWNQlBNAnRAcdsbeeJIlWoWWKmjXos4YQa0t53BMwl1SOH8ChBZVE5SSZaSLqjL6nxh3WDMjL4ZqNOG0na8cVlL1zHNEbpglTvY49eWjzXqTp5w2N0heN7LMkesyP5Ug4D4vwJrJhvExpXuHc4UbED2TOiX9CHX/jZfHbOJRxofIrkkdj551RmeJzDbaQKqE+8zeDdEa7WO+V6Q==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by VI6PPF401F5B88D.EURP251.PROD.OUTLOOK.COM (2603:10a6:808:1::14f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 7 Sep
 2026 07:17:23 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 07:17:23 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH v2] wifi: mm81x: validate n_channels in disabled channels response
Date: Mon,  7 Sep 2026 07:17:20 +0000
Message-ID:
 <AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0640.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::21) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907071720.587005-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|VI6PPF401F5B88D:EE_
X-MS-Office365-Filtering-Correlation-Id: fc45922b-1d48-4583-15f0-08df0cb0100e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|51005399006|2604032031799003|23021999003|5072599009|15080799012|37011999003|25031999004|12121999013|8060799015|19110799012|25010399006|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1H70htgmkDKcQQ2xAmR0Li0Gj/tEUnvlPG8skcqfTblfpX9L1jZvPh7zdFVR?=
 =?us-ascii?Q?3kJ7RcXJXMgRLbbFal3DIhw1WzYrtPAXXLUgZgRCqZg9GRPpb0B3PBAesXF6?=
 =?us-ascii?Q?Si6qQ1v5Yxsrmxpg6FsHTfPwffKlasNN0BsGVRSDiWnPeyKtgW360pTrcm2n?=
 =?us-ascii?Q?v7ITTZ8WRgaYCxmUjiJVFKMu0eZ6SgdeUe2PrZNfmz4AmAQuQ0wZYgFYIph/?=
 =?us-ascii?Q?SZ4x+GpO28MQDSNkbf/9yuj42OuoRxi3Q0zXCYC1kTpjvDTdeGv4qBu1D4ho?=
 =?us-ascii?Q?gd5DMeyJXVrQcGgBU1ANGeFjh2p87kqkQ1ONOwPgZY6Dhr0dGuH+RDjt5HIJ?=
 =?us-ascii?Q?4BdSIEhPlfexSNB9BL7UWrXiY+jXAo1kTH71gtlBn81fx1QZhlXVrBOY87mI?=
 =?us-ascii?Q?Cvb7K7R0xYrv1lhrM/913jtIjf8lMfOI6B08EUyM/r3ErRicDj0WWUFQrYA5?=
 =?us-ascii?Q?cqj5F3D1Z68Zyr5N0Yj/i4Exv/kkzSsC89vixAVQZax7psAPZId2UHbheyxp?=
 =?us-ascii?Q?Lrj43rIWWE/tF0Mer0IEuzs9dVRTQrUKjd1HP9xVEe8ANPkUfhXeV4wlSGL9?=
 =?us-ascii?Q?RiexFNTRmnrv0srW2CyiC80qb3RU2huH2NCpCxxT4WbhgkhBBk10YAKKIjee?=
 =?us-ascii?Q?u7wDSv4ExPhx1e0hfDr8s1ao1/wE3YXOkOxmckg3MMn/WysyiiBW5mLZU+hI?=
 =?us-ascii?Q?yz9GfDjCF75LzSO9QWiHOz1pemPuxwTFMRa/Q4VPiz3LhewGSjsJe9UfXo23?=
 =?us-ascii?Q?9D8GYlIDSqCEKRbfB1KMQRf8g4buvpJmsRxSu7y7iuS1lnFcDSndcSUr74Ni?=
 =?us-ascii?Q?Ih3bRKYAvU9KvrXwBDm5D+stara5FtyvqQeAfRVSHNfiK/IyFB6edI0yLfoV?=
 =?us-ascii?Q?sLmWK2nRSnSyrNM3hU7LYhCMm3xB6xdFZbUiBTkhcHobUwr8MM7zQiV6U66X?=
 =?us-ascii?Q?lYB1Fp5aFTg/jrf3uflDuw+3un/fdDpNAFXGXRFjOrFEQ7ZwtRh9mSBc6yHb?=
 =?us-ascii?Q?wyqw6oLZ1jFYaNa/uQMIep+ZUlHooV59Cc3JDuXqwMWCFz0VSHM3NMY9ap9m?=
 =?us-ascii?Q?y1VQEFf2VDY/7dOMlosmsUarL1FYxrQr6pm80KFiPDGGuuE+hvdzmjbAi9Ai?=
 =?us-ascii?Q?CgdTExzFgKjveo4rCVSxt8sRMZt6xrh5Uw=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0xOvMIfs+KmRqhuBgxPM9d8sS87QshYHn+q7t+cICAe+GtMBOzyifEuWIvT+?=
 =?us-ascii?Q?Bgv0pQqP7wnMAsVFEFn6lw/4Wv8GP1elfDtPlInUIbmbLR/uz9tMtZl4myql?=
 =?us-ascii?Q?YpKffG1syq7XWRTGsEEPxxo2lci9FngD/Lp9U2Kh+XAIx6RP4+PZv5zB63OB?=
 =?us-ascii?Q?PZTnLbb99H2xfvVW6MVJsU2CuYysFZPmWFqewdUHCJtky0f/8eOLooewHGbE?=
 =?us-ascii?Q?QApj2El1UsV9JPO7JwIZjsFX7DUb54/X5iDLBMrSxJl6LYxsPUrF+1X/+pEj?=
 =?us-ascii?Q?cN2LBpfBSyM0NgyPICegC0SC7RIUUqEK04SwQ4b3HaBfWivUsFZLKhzNlQe6?=
 =?us-ascii?Q?3bjImEg5VI/6x28h9z8OWTQGSU+TBEvoNcZB30lvyQ2ZCLiR65gOHi2OvWAw?=
 =?us-ascii?Q?t4OX6bhBuRUBVIB9lHHANoZIUDbfecLI+6upd3ZpAW6qjdwYHtgBqC7xFiyN?=
 =?us-ascii?Q?/sljLxnHSehVdfOrQWRf9+X3suLXjFam5whi6oZ6Kp/+woQA2VfVn2qWpQZb?=
 =?us-ascii?Q?dX2HsCfaqxo7NzAUvYqOqY9yTLncZiVUR+3VejKL50fKJFaY8EfLPEZM+leN?=
 =?us-ascii?Q?ahLOdVdZAd5mdUtiMA86e9hTnQrr9sA6sNPemv2f8PgkVYmDHQq99QDrGiZF?=
 =?us-ascii?Q?BlbOauiFDBf5tJijiXkLqekyoKCs7dUBFjw1Utgaa8cpPAJQBrrYssuiz1GF?=
 =?us-ascii?Q?1qPvAYuqa1TcQSJRxP+0CLj9BrX+NoRgo8OyEikfX6L2WZqZupjM6vKOm9dB?=
 =?us-ascii?Q?I68LXJLO53ud8ixLJH1+AHXzH0DO2avwUj4kXNcx3Ae8honDYBg9j4uG53H8?=
 =?us-ascii?Q?y4s+nV09uKTzW9UWYind36OV6xWuCSZv58B488eAj06O/AntMbVO3E8/OYf6?=
 =?us-ascii?Q?ZpOVCesAILcsLk9mjW1XQUFEVlN4iF3LBFbflGPmZCpHM6gqGK/sTvsmmhEP?=
 =?us-ascii?Q?RpNaDMDoJaX6vrI8WpkeCQKUhHxmIb1rM0IZ4HwXENAQg91IpvZgQEmai+62?=
 =?us-ascii?Q?0bt4X7L6w8W9/I7SDvzUIoppniQm4L4sc9IGxhdhsciqk2xNYGsw+K6PAXBE?=
 =?us-ascii?Q?ANaPLyDNJu0tYH80LWvCv5V1dLwFPMP2kVkTJHiARVOUjZViRH5gFFEpevoa?=
 =?us-ascii?Q?1OxHBGIXghrUeuya2cTwe0NX62YdMlWlt4sJO0krVLD2CwTcS/DmsbDbqncu?=
 =?us-ascii?Q?xaWniIQTWPBfaX654ioD0TWdBlHiOHi6RzvKKEil/4fj06hfcM8gTBnKtYD9?=
 =?us-ascii?Q?+wqr4FMOs8FnG1vIuGY5bYepmoqwPGPBiaHS+CeRjzUEJZ5QIgxhKvM9C5mt?=
 =?us-ascii?Q?fmv862gNOPeSZuERnkIapmLyG1DmVb4Y7vs+/Xx658HVRD9N9iwXofcj6QJW?=
 =?us-ascii?Q?gCdB9PdQSGhzED/q5JRgtuJaasMjmEwPD9KkSAf9CZHzVWTM2PEGXMVjQFog?=
 =?us-ascii?Q?KmnKFV9N7lv1K4Bt+NUra/sUvuofAV0q?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fc45922b-1d48-4583-15f0-08df0cb0100e
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 07:17:23.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI6PPF401F5B88D

mm81x_mac_check_fw_disabled_chans() iterates over n_channels
entries from the firmware response without verifying the count
fits within the allocated response buffer. A firmware response
with n_channels larger than the channel array size causes
out-of-bounds reads from the response buffer.

Validate n_channels against the array size before iterating.
Place the check before the loop that clears NO_PRIMARY flags
so that a bogus n_channels does not cause incorrect flag
clearing.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Assisted-by: Claude (Anthropic)
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index e8ef0d9eebd75..c3035a993d06f 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -279,6 +279,11 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(mors_s1ghz_channels); i++) {
 		struct ieee80211_channel *ch = &mors_s1ghz_channels[i];
 
@@ -288,11 +293,6 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 		ch->flags &= ~IEEE80211_CHAN_S1G_NO_PRIMARY;
 	}
 
-	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	for (i = 0; i < le32_to_cpu(resp->n_channels); i++) {
 		struct ieee80211_channel *ch;
 		struct host_cmd_disabled_channel_entry *entry =
-- 
2.43.0

