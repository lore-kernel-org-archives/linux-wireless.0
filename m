Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.139
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793883625;
	b=i/Cey0BeXnnnxvHpmYlGzisHdGDwbF3ixxPUPQPPckVXjBXv+xseUV3wtmUODHsRycW4
	 Iwym7gu+Dc4ANJafRCOKO6HyjKtPE/n3/Has/XZRMsb5C2eFM8xwE38eYr8rEkNf3ynCa
	 f0OqdGwRKn0g7kIZsWIWzKQ/MvEc7/nU5OaaExpXxpiQlw/o7U0v7n1xJS79/yczP1C46
	 6D4GwIeed7KPAr5r6L253KjaZwd+r7tlXzcR3x9aw9rk4MhGdC4IO2397Cy6bq4LcqenA
	 40Fnfqvs47tnDYt0IjcGWL/Fumk3XyLosfwWgV51V6J5HqDBVxZNJKr36ZPCK0chcYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883625;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=us4zvzsUc+4zoV2YkUR5qjVfnwRb+1QTySllwmduZYg=;
	b=gJAXDdJWlF17s1P+vR0ETnpQSnwBtHlQtV1Qcj9hCxpTMXew8L8NIGrBqQC1Gu31Lk1l
	 WDluPe/No43/ORtyqd3mHVNKR91OnuWr2fHZRVgrswYvxQ9UzsGDA+l+zQk76oLDGzSuN
	 64fmlyzRwMSXABtJZD5gvIB4D/vtz3tcXyC5BxVa6AfmEvN/P4MAJ/SFqIOawIJ7uZsAU
	 YRHQSdMgZEpIWRF97Lq95j7qe3wICZDXidd3ytIoKg60mYbxN+9Ou5mB8EUp6ni4QmDaq
	 SVhCYq0PoELO/OluOkz2euEbgaMbTCDJusXKWQ2tzFeFPhEcr6TS6km3W4Rjvx0zx1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=lH1pc7OT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.139
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023139.outbound.protection.outlook.com [52.101.127.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0A606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 13:00:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19C0A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=lH1pc7OT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kHnrD2qbo2MmImmV2EtaUFTqzpOKKbNaZjev8qs8ggXSP2cuSVmv6HitX6aQmyvVwadUsUkB5nRHshiwFh8kKKHd7rH8MjNrd/Nas7nrRD5AUjWLJo3PgM191hB9aDwByCQWhxpsQpSV5auLclDlPBjOZ495KRx+uAnGkEXFdYUPkS4nJHu/i9mazwTgW4Ih3JhrPeHwL/XPeJWJKdLuhxrhIZ24CAua2m9k6bv0UmTH9ZzSC4kzku5NnpB1P5YcGAFcuubWnhdq9QIkRCLPZ9SwGC9xR5Oc918rIPnHbpw84WXZ1m7IXmO+uCzAya0nDQjAPTF0+XSt5Vy0aEaE/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=us4zvzsUc+4zoV2YkUR5qjVfnwRb+1QTySllwmduZYg=;
 b=TPbpj+avrMnP1w8vZ0AcGq837WoYUrBF0S/88HpfHDT4px1QQS04a+FyqdU7hJMGWyz+8Zo/2Uz7nhXZHB5qpWxrjybtT+sS8tiqwzzKLL6NBA4yxL35jpPRAunSlRXIdx6yuWMUwjiCfk5+7weMiYBk87A25/66qzSPrM7V7Lw9RPEJAKRT/EvtdjLnxpuE5SJmlY/GI/Q334ah6UN6KJUprMDOruH2NTKRaUKb829XqQ/Z0oPC1auyzl7S3HL2Ycum9+sltpRgQtaBTL9ACjp7OD+skK+87L9ywodKLngvhO61ybd+f2JGAGtI+FkiTjY/j3lt65tuypPQu8H/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us4zvzsUc+4zoV2YkUR5qjVfnwRb+1QTySllwmduZYg=;
 b=lH1pc7OTqb9j7orAL8FiQQV0YtVzAusEKTNGlAgB7oN94yxT9dYSi058+iuY8nZoi/CTdZJPBuUVGIG68LPdElEl9oODmCcCibYheiGAQzH6AAIzVnGBh+eEqEPJy05IkVS/aqMcKRgJadqW6PAsjbNMbNs5oHn1O1BVIdV1bjYALbumnoKeEmEzIVAB6/4Xs+fWIBYGP1YCYKRbtcw2FOEvu8yQ8e7Y71tG2NX+sVfhDtG1XJ44MY8cU8CjxG/VQPsLRU/+2w0dTo6URQLw+kUhhyaIu5sI9FFvrK3+HWPCIV6vr0eGCJpMLv9QP93iBFgZ/J8nYuOq26dxEQ5vjw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by TYPPR01MB7840.apcprd01.prod.exchangelabs.com
 (2603:1096:405:313::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 13:00:16 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 13:00:16 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: linux-wireless@vger.kernel.org
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v3 0/2] wifi: rtw88: check C2H header and payload lengths
Date: Thu,  5 Nov 2026 20:59:53 +0800
Message-ID: <20261105125958.3891196-1-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|TYPPR01MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 49d96939-b7ee-4bab-fa8c-08df3b3cbce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|786006|52116014|1800799024|366016|38350700014|56012099006|11063799006|261021123027099003|261021121427099003|261022105027099003|261028144727099003|261026140227099003|261009223027099003|261022075727099003|10067099003|261102123227099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d4lcp0PPxkDzb2sN1vb34VEvI8FzonLnqmZzc8rSd9W9t12pRQe9afYx2zuFlpeSCgEhlQ+dUHbeoHS4XYfM9KJBV2Cwlxo1Ci1tT5PaQB6z84KXXWAyxBtxzn+i0ajh9HgLzHxEcgl86Az5TyFNBYcNlEUlykKx31UlxCvkFJvlI9JU2lKYzUPE8upohhlapnqP/p5VEpoO0aZ8s9VDo9bvwvIsL2HBImgHFcUnWgiUy8i7l6IBF4i1aY9GPhNiNTeTVMmtLvghpugAqUdtyBUqVQpO/4iM1WgU/OjlBlwMF0HxNOQAggZ2+pboJujlF6YQ4oWoJEPr0SvKla6dftKYtZMOdp8b+Lue2bNA9neBcKT4+nDQwgEdFPIQk7jkMwH2h2wkETxE0Id2XiG57e3+9N9iMzVyJZsqyzrX1sYhydq5RPFjImHipM2wvVVf6o5kV8tkYpFmXQRECWE97OmmbMFYYd3Cszm4r6cMjgvaqL1qAX9kujCEwjgYjT/+6twPnb2bJscvjDaHeJjM/l55wUlf0bl2hL8nb5QhQFuCzknzGahFcWS0w6YKwPyQ9iPWjVgMHwsgiaSrU6wH9e2P3J+C3HTSq1kiSVCPV+g17bD5rO6cYDwWPlmlo1ICoNLZRdfwscJ+ZbidSpYZyObzYabPFYHqyj4bJpSr8sg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(786006)(52116014)(1800799024)(366016)(38350700014)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026140227099003)(261009223027099003)(261022075727099003)(10067099003)(261102123227099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c2HsVDypIjUKKoFuBCRxj4gFWr9FltpnLW/KoGI8MHlN8/WNDIXfTSc/bvGE?=
 =?us-ascii?Q?dWzkvL37zMQe3/wpkEU7SN4XNNh7vaZ3Q2uIgw3Yfa756bsgIc/exkm6LbWk?=
 =?us-ascii?Q?XMKcP+Z9JIg8oCvmSykoPEhQB79jr6jJ35/6Hvsr14x8tXBqaTOw7I3VhhFb?=
 =?us-ascii?Q?H1hgr7Ezzx3eS63vGFC3acNpLzPDzwTMez5eb6oiT+8wB2XGHbF3wuYuKNnZ?=
 =?us-ascii?Q?gtM9eapsv8Efc0bJyabkr+w1Y2dNTH3Iomvl42ggZsS7MVXpRjOvji6FWLaF?=
 =?us-ascii?Q?X8qUokDHxi+s6yt5BX5NhZtaWuu1Er7iK2zt4y4ciypxVTxVVR1Zoy5RxQz+?=
 =?us-ascii?Q?m3jsBb3yflmFOOp/tuCxxmGsRPSxyoGR9ErJ9D7Hgw5/4NnlqFW5zlGdyoCx?=
 =?us-ascii?Q?Nf8H72bkN0EOW8C8P7hkzq+56oiqOmMnMiwUmTgWO8GmLT2IxYN7jzNuE5hM?=
 =?us-ascii?Q?fd8nSZM56P9vXDyTns0/PCLFkvthZOnCYYezHNmD4FA5Jag1bO0AibVB66Wc?=
 =?us-ascii?Q?fa1kdiP7UXOUKE2wOaFYPv1jh38Dyo9CrWwv13uneF2aFFkexTg8oXiHdQb4?=
 =?us-ascii?Q?G55mREEhMHXRMMcAFR5J5qS9i5k47omt5PaFfK7GftqEG/2+uM0kuGkMQFLd?=
 =?us-ascii?Q?EUvzpmzh4jk5nGXlGywxYaW4UzCLGkCIeJ2GMNQNo4EJbV10mWpfsWaVHpcz?=
 =?us-ascii?Q?Ot6UvFiIHWQsf+wRVGqBL1Qi8VV2uU8YSZhrv89aMvpx0wDWLyqHSzXYokfN?=
 =?us-ascii?Q?bbX0IG7aXEl3TRtdNFZ0MnlRhWYGw/4k1AtGaglUhspbH6UGm3puS7jT7ppE?=
 =?us-ascii?Q?d4rFXib/tcPwf/6q2MxkjAc2dWKJ4r1vqF28ja9w+Lf7jDnekJQFvFkPTZ7b?=
 =?us-ascii?Q?P+a2CrGzpkfv68bPkusL6sWdYMx/KZSqRVWydF7Gfq6vah2BbT6OpGarlHyN?=
 =?us-ascii?Q?nK4Qg0jihn9gyM0FnvwoCyLF0z8AjBMwZkpkmxtQAeKa4uJpcXsj21to+KD1?=
 =?us-ascii?Q?Nt3gofUddSZJA7dvGtAWYRcZ5/ow7mn5oIkk7y3y/kobjoibDHf2h66lG4DA?=
 =?us-ascii?Q?Ap6x/X01tpGCY/4byQt+iIAvwjHkN+IdLlS/Y2WdRtnLI6Z55R2zpFnZsZ3S?=
 =?us-ascii?Q?x38ySLC/WrnL4goyMEksMmN99OIVMYkDhcksVmYMLe65IErGXJ9Dkl4ZX/uE?=
 =?us-ascii?Q?ODFv8dXlwv65oRPa3buJtE0HHgfYR8GilKM6UF4Uie0jaHGNefx1s1IxJ5zg?=
 =?us-ascii?Q?OLw8ZwRdwfGlnpJWrtWtU47oKf71BXtfuD2/W+NQR4Rhnweg9UOj/hUbej0Y?=
 =?us-ascii?Q?qTbwAkFpgGX9/5qDYMyC1Deeeictwug3T1Q4TFqoCpERSI8eyW4G6z/HKMGi?=
 =?us-ascii?Q?sKr93hOGS1wWNfJHc4obtIj3UdSm3V2QoohAiNbNbBNa96ij/zR1nF5+hCEP?=
 =?us-ascii?Q?+3A1HQYs7RBbDd0FBtyRKtMTRjOGz5uW4EmaPjuAcIME+GY2/sSg1sB+FTR4?=
 =?us-ascii?Q?nS+mQruC+uHSLoe0ck4Vrs9bIAEsLVdjKdYjiuH/jTrXnE6HxT27bgv/6VTx?=
 =?us-ascii?Q?g8n3vkIhsghStJNfKD2YXZ4zm/MhY+ZL4fF0k3g9KWZxq2Qg+hjVSYJz1wG9?=
 =?us-ascii?Q?kunf9dMBxs4whjNbqriuuD1KHLttE8TxZarQ850wp2c10okHDW5xnTVsIzCw?=
 =?us-ascii?Q?YgrZdIFwTiCg/jtG2NfoIs+WaHHC7ITInK8ybs4ycsoqX/8fOZ/0jSItXl5R?=
 =?us-ascii?Q?hHHFMfDVbg=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d96939-b7ee-4bab-fa8c-08df3b3cbce0
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 13:00:16.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5jw6sQ/H/BLnQZWyqxXxT0edJKe/gmmgc3PctkbLeZ4KT77/zN8NwmoYvrWHSA769fX6/BCfQvP/zgmziIrzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR01MB7840

Patch 1 drops C2H packets that are too short to hold the C2H header.
Patch 2 adds payload length checks to the handlers identified by Luka:
scan results, coexistence responses, HALMAC extended events and TX
reports. The header check remains a separate patch to keep the stable
backport small.

Other handlers, including rtw_coex_bt_info_notify(),
rtw_coex_bt_hid_info_notify(), rtw_fw_bcn_filter_notify(),
rtw_fw_adaptivity_result() and the GET_COEX_RESP_*() users of the
queued coexistence response, require a separate payload-length audit
and are outside the scope of this series.

Changes in v3:
- Patch 1: add Luka's Reviewed-by.
- Patch 2: complete the HW scan as aborted when the scan status report
  is too short, instead of leaving the scan pending (Luka).

Changes in v2:
- Patch 1: print the C2H length instead of the full skb length in the
  debug message, as suggested by Luka.
- Patch 1: clarify the description of accesses beyond skb->len.
- Patch 2: add payload length checks in response to Luka's review.

v2: https://lore.kernel.org/r/20261031175621.2228762-1-hhhuang@smu.edu.sg
v1: https://lore.kernel.org/r/20261029170017.832708-1-hhhuang@smu.edu.sg

Huihui Huang (2):
  wifi: rtw88: drop C2H packets shorter than the C2H header
  wifi: rtw88: check the C2H payload length before reading it

 drivers/net/wireless/realtek/rtw88/coex.c |  3 ++-
 drivers/net/wireless/realtek/rtw88/fw.c   | 24 +++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h   |  8 ++++++++
 drivers/net/wireless/realtek/rtw88/tx.c   |  3 +++
 4 files changed, 35 insertions(+), 3 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.43.0

