Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011014.outbound.protection.outlook.com [52.103.66.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359C4306B0A
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 11:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788002751; cv=fail; b=YUk+ekL7DfYRt8AKXLaK7DnDs6kuk5wXrcr6OC64ewV7xBxdklizVrZcTOMa8A2AOJ4G85nVjSV1R/Hxc5M5ogj4U1xyLd/r88mOXHWmiZMjWKfm/Q6cuM/+kDJrp+ML2yXYqtdJqAUXjfcumNjLtNJUTShs75RH3qhTmOz0gTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788002751; c=relaxed/simple;
	bh=cIbZ3XcFbDLBCIVOrTzhZVIDITFUYuJu0v7Y95s0Ou4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mIQ6MQycoDDYETu2OV1m1YDiCw6k/P0lL3y6JtP8mjRIT0sMTUWORi429kU2QGry7mq0Uurle40OP5mPhwy9FnI4V5JV/2diPp1p/hINCsccNLQw698WF8DKjVWvS3KIxCVkZKzOU3lbcFscECXI/7BmdzpnGYJRl/XoFiPkBnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Ed8acV3m; arc=fail smtp.client-ip=52.103.66.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Ed8acV3m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1URoBZ0sWgwQ5CuQWy1R4GuRWvitWRLMVEgTx4g6xGY79MeRgqgqpK3fbNg8BOZvgvynEcl8O7mPPoRoKwC69hWOBLlbRnur6XOm7WnZOur/2SUukoPvGGYj/V8qxsNlKpm3QeptdlIomWuT7gWz3MQW4RVmc4k8rR6fTgOv2jcQa1/kPh30LkGL45eqdqZz1AyqCEzoTSXRX7pBCxr1DsqkaMG5NY12IXG/cqU43hIxGK2wz5fc6iaE0ou6WmxQAYmIMrYp84pU5KZVCD/3agT1asj2wqxbTOMYMVuRHqKYyrlmsVrEcjceNVsCEcgC+NdEpK7+QqJUbSTeZEVjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYWTMF9XS23Gtkf4LhGXDq4oArzTCSCEVFmHtl40DJk=;
 b=mhk5E8V7Y9/LRcy02EfOr3beG2VzNvApk9n5bbWNHX498cbX/EpTiMGWUaOIBy305BdRIr6I4Vse2WowB9tBBZtXBuQTpQ4PdMMPQzHqK5D0QJFhCl53FmcYuT1/Zp4yQqW5nfTb4bipS5rttUVEkL5FQIcjlt2whfKLCS249B5ldNac1rH9tRSlnikNi+L7fI055EsHXnw8STU7nk1rPlULPJJYulASCw3RSiCKtiYonFkHZW1G1ZJl75A20Q0izIFt0Jz6rEcjg2bnsS6kyaDr2e5m75NQgdq5FpyaxjQzDwqbktF8rczxBEKHLrkq1bcgaC1c65tWMzUPKLk19w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYWTMF9XS23Gtkf4LhGXDq4oArzTCSCEVFmHtl40DJk=;
 b=Ed8acV3me13MeSxs/3mbPqWhLG9qRS/+kHJroEQ8bKIQNnhwdwLyJBSgmvfQIv8Cw0en7g1AribY843Xk5rQAjtIJaX0N3u1tKjym8Ai4HcPZ6ot3r42clV7WQlxzGQuQzqbsEHL0++ZbdqZ4nVjpejQCjh3iNZJZy1LIv434MHO9wwBGJAInBer8md4txSCaBOl3/RsN3tWGiiKEIMuKWjCsieEL/SuzK6tAPCh5LyoYA6hKzAnYfXCJAg5ayTc22CSNZdoVlsES1TGjBGXYWkERkLr2p8O01hJ1PnypUZMa7uVyCI6Vvcv2I9skAcf/+sMQ+xKDxz4OsjWoVdEMw==
Received: from OSZPR01MB7795.jpnprd01.prod.outlook.com (2603:1096:604:1b4::8)
 by TYYPR01MB12709.jpnprd01.prod.outlook.com (2603:1096:405:157::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Sat, 29 Aug
 2026 11:25:46 +0000
Received: from OSZPR01MB7795.jpnprd01.prod.outlook.com
 ([fe80::7a31:a23c:129f:8288]) by OSZPR01MB7795.jpnprd01.prod.outlook.com
 ([fe80::7a31:a23c:129f:8288%4]) with mapi id 15.21.0360.008; Sat, 29 Aug 2026
 11:25:45 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: joshuaklinesmith@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	ryder.lee@mediatek.com,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com,
	Shiji Yang <yangshiji66@outlook.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt7915: move sta_poll from tx_free to mac_work
Date: Sat, 29 Aug 2026 19:24:49 +0800
Message-ID:
 <OSZPR01MB77958B2DE22809C3B09DA698BCAB2@OSZPR01MB7795.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407031534.57132-1-joshuaklinesmith@gmail.com>
References: <20260407031534.57132-1-joshuaklinesmith@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0031.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::10) To OSZPR01MB7795.jpnprd01.prod.outlook.com
 (2603:1096:604:1b4::8)
X-Microsoft-Original-Message-ID:
 <20260829112449.851014-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7795:EE_|TYYPR01MB12709:EE_
X-MS-Office365-Filtering-Correlation-Id: 3568cd81-68ff-471e-c2ba-08df05c043f5
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8022599003|25010399006|12121999013|5072599009|23021999003|22091999003|19110799012|8060799015|13031999006|24121999003|24021099003|15080799012|11031999003|12091999003|3412199025|440099028|3071699003|2607281247196008|10035399007|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iVpZz7HAvxLlGrBS8S0q4v2A64K9Iv1IdjE9qWS5psvsc0aIrigOwUgqhFGC?=
 =?us-ascii?Q?K/ODk0tuMwt8r+hwM0y3/yQppNG7Vjhl/SXeybJer4sBISxxXn7ZMIY9DY3o?=
 =?us-ascii?Q?MLZ6ilhajhIZLfWanzy5oqj3dXvc746jAfPDDPy2xOgltuUgAsmVF5dWB0Xu?=
 =?us-ascii?Q?z81p/q5lE8Ax3FOTlL2BafMNasLIl4fG/+1Za5LfBkjde8q3XGOBgOxI23MV?=
 =?us-ascii?Q?DaGKdpxOFQc9fyEP+LvR4D+YZinz3cLonufI5x+TfQ6MAgOV3moqUL1zfNn0?=
 =?us-ascii?Q?ClGMxS69fhpQxlmrYpOU+JoK/HkXElbzHZaqYgtku1XOk5WkkpiOPl2XgehA?=
 =?us-ascii?Q?GCmLVxFRXNwf8lchp7n+rTAqiqtrH8Ffh8O6jxfOBr02rdjrR2hxp/7XRaFy?=
 =?us-ascii?Q?VUXiBHhABp1DUkBpQhD+iHvnFjZ5OFkJ/Y5IzoTqjfLHnzSUswyJoXaQpWCu?=
 =?us-ascii?Q?obJ8q7DFYjl1e4EVAtzeCBGTZMrOBUnrbU59PvWD1NF+fECLbuFQCiSZO3PN?=
 =?us-ascii?Q?PL2Balug/BrnL+xRAvTc5DVAEMZOJw1nUtjNp1cfHTgN9cPn26AU/x0bRKd2?=
 =?us-ascii?Q?SoYhNInLd6dtnh3yBKenCkjX70Q0fGrpjbM6CbKkIy40qKCc/YZQon1QWUzY?=
 =?us-ascii?Q?XND3ZtVG+dBiskc5h26A2xxNYuQAWLcmstla9nMdJBmljDUQi4x57ZeC3INw?=
 =?us-ascii?Q?DYA80ZQN8NCvqAskUfibrP8y146LiphW8tWn7PUaQta6RO7Q92AEasn8sg+w?=
 =?us-ascii?Q?0kKnj53EjOtb8s1TBMSqrmMBmZ4jUKAtyIDplDP3Xr3EsK+lcPqkWA15itzj?=
 =?us-ascii?Q?PLXfTJGcHlPieqVnoZGODsJrVxQQyjffOendtgqA7g12opVI6XNBx7pV70YP?=
 =?us-ascii?Q?dD7AmlbfG+olxnU7Ew0U4CgmBhuMHQvg6mWkKkWfKrfNedFDt5fwJqn3Lz0F?=
 =?us-ascii?Q?wcdCkyUDkNJEtxSqSdeaOYLz1RvFdvZfaPGBEFfENplb7fe+XnUenULRmTnl?=
 =?us-ascii?Q?7Y0h/m9NaoydZ9QcXfh6nEiyrX1isV7zPqwZ/qnFHhMnyXy+DizSPDVW+XUm?=
 =?us-ascii?Q?VyGWalr7hN4AEDyEMn5jWITHXDxdLo+TOXwwVAjVP7+T/3TkjQV7pJqw/swN?=
 =?us-ascii?Q?U26t05cJ2PQrDFj2Mxn5PQXN68p57pffDQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4PuCBRj5LgraOZFxQ5dzJKJ6bXfoNktDc8ek6AuyWn9c2J+gEj0mWB25gUMo?=
 =?us-ascii?Q?l3+TWPATW8OuywiwcTaxZ1LDdnyP09QH845iAGVjzycQYqHw+USzaUz2ed4e?=
 =?us-ascii?Q?R4lB0Lj3+37FLupq6rUUilmcl4vAGloUpomLugzTHFAn4NXPqrJ4NoFkMNOz?=
 =?us-ascii?Q?abLVvYwJu0s90N4QzFlZUbyUKr8WQFlPfk4py57uGqf5GE4QEcR33IpzMAEv?=
 =?us-ascii?Q?zgVynoDeThJvh7NIymYly9gzn1gvrurpAi7tzKP6Znw3DH77A5isqvy4p9by?=
 =?us-ascii?Q?PaJP+PFfWv3gx1NuWOlOCNN48LDvoDSTutb4jipWAVlyAOW8hTZQL7ZlLJj9?=
 =?us-ascii?Q?Qtbi99NBOeU46eNNhYbKTY1InrwFRN++qXobcIWw4u5Pa9RMzkNzRsAjSjtq?=
 =?us-ascii?Q?SHSDn+GkobwbGxSv89CTjHA3/EW/I7g4zKnKaf4L5ES2jmYjy4BGQc3qTJsy?=
 =?us-ascii?Q?B6yfD7sUZSQGaxcUyP6TfW/AO65/XDzmrC/O0KYXGz+MYDx+ziZU+COPorNY?=
 =?us-ascii?Q?cd3OgMMveYjEuz0h3Wunyy9U7i+Nsm/B29KQLwWODhzBYhEPFXiqvymDzeFt?=
 =?us-ascii?Q?W1YvvbJfJiYdtQVwH3XrVM7hGUZZ2Yu9UBdr6hay3hQAqf2t8igls9/iEvyq?=
 =?us-ascii?Q?+cCSuaiuS56kPboIwErkVYBRomHVYUhp9WrmiOE6vvek6IyCebKPvqd75O9F?=
 =?us-ascii?Q?dIKnV8xn3+hH38Ppl0AZqZRtPfOdhqT6qN3596MaQpvtgiw3TvQT0rsqgYmO?=
 =?us-ascii?Q?4iCIbkFxLTPKuPXF4u40r2Q16zvbI7lntYL2nioV2YYwZH5YMjefKWB9bWsN?=
 =?us-ascii?Q?dDZ5ZW4IEzy1frsmyhAtXGHQvFxBzIBoEpGGe4GeL2Halj+X2Ta05oqUQEdg?=
 =?us-ascii?Q?nHYP5fivP51+N1q+ontZEpf/A+TdgoMrALNY3kMf2fGxBLWkd0WAeYQ9/eMv?=
 =?us-ascii?Q?IW/gmjQDRJsen4Kh1ctj4BOInfZn1lNl5D8Ydl74H8z3PSVDfCW5fII8XcBV?=
 =?us-ascii?Q?2V33iw5NC7NL0WAnI+GQNn4wGh53Y2jbZfvBkp+p8ANl27lXC8VAGYDGJjDW?=
 =?us-ascii?Q?8qyJhTZlMiehKK8yxRy4o8xIOQpCqmmHLUasRnYUeepOC+D+zVeiUGNz8Xjv?=
 =?us-ascii?Q?inz53m6GlK6HtY+UVwjU5aBGEDBhqJ+vk8dkEJaca7RPfA8N4rNBVzLI0nUK?=
 =?us-ascii?Q?SnJBhu4WRV1DY8rmyyAcd/iQttF3EJl3iyMherawtuT5xh3WZ26qBQDsSSDM?=
 =?us-ascii?Q?s/8XM07iUImGUL0guiGGONy97GX3Os6KkrCL+BnwRb8JPvYgo68/A2y6KgPD?=
 =?us-ascii?Q?6k/wK88EdnefXvg6LxDu7sP8tVAsnR4av7eFlla9tAeqUpneCPrbcMqu7j/2?=
 =?us-ascii?Q?ntk4pQafqvQpHYGAC6sHe4j2oEJy?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3568cd81-68ff-471e-c2ba-08df05c043f5
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7795.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 11:25:45.4664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB12709

On Mon,  6 Apr 2026 23:15:34 -0400, Joshua Klinesmith wrote:

> mt7915_mac_sta_poll() performs direct MMIO reads of WTBL entries for
> airtime accounting, GI reporting, and RSSI. It is called from
> mt7915_mac_tx_free_done(), which runs in NAPI context on every
> TX-Free-Done event. The high-frequency WTBL access races with firmware
> WTBL operations, causing kernel warnings and panics at
> mt7915_mac_wtbl_lmac_addr, followed by MCU message timeouts and
> firmware communication breakdown.
> 
> Move mt7915_mac_sta_poll() into mt7915_mac_work() at the periodic 5th
> tick, under the device mutex. This reduces the access frequency from
> thousands of times per second to once every ~5 seconds, serializes it
> with other driver operations, and eliminates the NAPI-context WTBL
> access that triggers the race.

I applied this patch on an AP mode MT7621 + MT7915 router for weeks
and did not notice any strange regression. It can also save some CPU
resources.

Tested-by: Shiji Yang <yangshiji66@outlook.com>

> 
> Vendor driver analysis (mt_wifi.ko from MT7981 firmware) confirms the
> vendor's TX-free handler (red_tx_free_handle) performs no WTBL reads
> or station polling.
> 
> Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
> Link: https://github.com/openwrt/mt76/issues/1067
> Signed-off-by: Joshua Klinesmith <joshuaklinesmith@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
> index 34a0690c5864..2f307c4caff1 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
> @@ -864,8 +864,6 @@ mt7915_mac_tx_free_done(struct mt7915_dev *dev,
>  {
>  	struct sk_buff *skb, *tmp;
>  
> -	mt7915_mac_sta_poll(dev);
> -
>  	if (wake)
>  		mt76_set_tx_blocked(&dev->mt76, false);
>  
> @@ -2012,6 +2010,7 @@ void mt7915_mac_work(struct work_struct *work)
>  	if (++mphy->mac_work_count == 5) {
>  		mphy->mac_work_count = 0;
>  
> +		mt7915_mac_sta_poll(phy->dev);
>  		mt7915_mac_update_stats(phy);
>  		mt7915_mac_severe_check(phy);
>  
> -- 
> 2.43.0
> 

Regards,
Shiji Yang
