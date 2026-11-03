Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793690439;
	b=jyVHJrcaSoVCrEHlZP7nZwR9WChlqgQxKm9cxjbZSwTQjzawfquigC4PXrWblKiCq2s7
	 G/LMBZ6kPpaWnM7Qv5ZXhe4bk+QVaj5l9qrDXJwtta0/JGb/r/oisQlyOxB7sfKXUrf5e
	 UlQVeprqAVtjS0mT7uOD6CdACSMYYdLabJobrPCdLyVJD9+9x+h4skdZ4PXY1vfpO/YKs
	 lC1knnb8JY6jxgOYY07EXW03YW1Z7gXMR/9agONzJwQ1LxsEZRrBu4WArtf5cbEUJwGx3
	 LgQzwzYRgLtpvWdCDsus5VToAMEVNrdhSJuFS3UbALOGUozgLQnpL4aTYDvvWRiEq9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793690439;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:Content-Transfer-Encoding:Content-Type:
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
	bh=9aCmDz5zR+xeSEtPtENlxQN+6xFoXadhj5hilbu+fNI=;
	b=5VRFcDVm7Og1gv7y+T9y1MOCx1uJHHOX+rjPCzCiK/k2vDf8tsHTPEKgIyFKh9cuW04L
	 rdKqNssFhTXw+QZJzydyN55KTaH9o8MaHZaw5YACJWsYnmADPI1wlhV0f0JPm7sdNYUNn
	 s3J2XKp1ZPcfVMWNsx/PpvQSIQ4ktFk9tT05ik+6Y0q7lOMLNPbVj/8YkNDDSGdLnZTXW
	 7q/S4I4sO4BJlcGD/SRZFXSlBoLrGAcrdkzGor9KBw5QPNVmufB490/IAbdYc2S92H6Tp
	 ZiF8qEjJwIJYiTm7xeauq7fYTrhUmtv98oFLtco2dwJb1hNzk29N0AkfHgtO8tz9B0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=AWknFg4q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.20
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010020.outbound.protection.outlook.com [52.101.84.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08C3606A329
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:20:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B08C3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=AWknFg4q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZofWXFgO0X3+BhT6PdLA+YQ3s43NsVPnBkKnTZeu9F1ojhLWRpucprt644Zj26mJ2OWp9AycxqPK284RthtTRMPF/0jaXTdG5nmM+7grRf1zNU/z88lKR5Cx305K+do20EN6syhEn4TyZQ/Qbwbs29i8/+lgQiTVPoRR2x6SNyHx4W5LOaCMq3cp3jZhQnLP9QsAwYoQdZZOUKpnNCRPTetfmbQQpPJVVnTTcLaz9OQpUYEe4MvOVajFOpWQ3v8giwsaFBVd+aMMBdVLI7pa73YysoR10YQCQfiAjAwQ5yr1q4B5IIDx9E3Qck2DMN0a9hNZMvc+Z1nJQ7yZV+yxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aCmDz5zR+xeSEtPtENlxQN+6xFoXadhj5hilbu+fNI=;
 b=e81lW6jbe1CG5SC1My7RUt+Rp/hpUzEmq7Eeb0guo5+tO5WaJs236+ankhfA401+Zk09VLI0phTbIaach/rQdIk707ivYXfZ1WO68oBtO/cJJfcKRmb9hp3IEQPoIc/2EtIo/Wy+qnWcJBVd4Z+6QaZoqiMSXNDtqu0PpGJhWsM8/JvsU6isg/h0aHIAOn3AvvXTB9RWYP5Du0u8naSX5SCHCOag5rdT5HVlr56Xs1W5XBPopLZ6PcFt3NMrcBe8wjptcJX0tPKtWSxazQvqctAxHxPjraIS4+H7d6XPqE0E9N5JfMegmtlcMuUsouKbyWoMxzHp2d8IL27wjwmtxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aCmDz5zR+xeSEtPtENlxQN+6xFoXadhj5hilbu+fNI=;
 b=AWknFg4qOm21K/u6ks6f19xOppz9m9hhSxe714d4jYfs6/YJoEQkKYji9TfoxXw4PLuPvJZsOyP2a3BvWyWMY9UruwEFfXXt3mIhNJL581t3O7gPjy/fvi8e/MOWMMycQXYonNHmXZrjnZwdNsW/wnsUoTKqsmf6ObtRS5IUAeAuWBUn/V36TpEoqpunKBSMBKxpmXsnXbQtOJ298o38IVqqwe6Ef07F35d0iKBCRekdWWeza8DNvCEmPoMqsM/U3fKwJqUCZlmLq2ynID2Ue3O49+v2PsLJcuNuj0KxuckkxRK+Fi5M7dabM+pDlnM+nWWkj2jUER1WrKLZop41CQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AM5PR04MB197544.eurprd04.prod.outlook.com (2603:10a6:20b:7d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 07:20:36 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:20:36 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-fixes-20261103
Date: Tue,  3 Nov 2026 15:20:22 +0800
Message-Id: <20261103072022.3955633-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P193CA0022.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::27) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
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
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AM5PR04MB197544:EE_
X-MS-Office365-Filtering-Correlation-Id: 6033dde2-5ed4-4a5a-236f-08df397af496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|376014|1800799024|366016|10067099003|18002099003|56012099006|11063799006|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261102123227099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	NDqP5s2mwKrfuioir10kA1nlodfaXKND/cIXj4qYgfTe8lqRai7clezBwQRXC96JlY8ujkhWdpORYBKneFSGVbUTUsl+LvhGJiOOgVl0E1PDjBLgGHKnDKViDmBz3GKUpDadTmYqbe3dlnmu4JxmKWDoiRpVQBjT/iEb2bplvcXH4kJgisa15rhKFyy+vY6VFBkZGSSuVb0wfeaA+6vrZcCe+e0/+uNNNjygPSMNo9jjLl9G5XSQzNGRhq6UO9xeKai2REPFhpl7U9Xdsr4gNs5/gLBcoe3CgB7qsOTwW5Uxg9dLsb2n12XOTP9CKt47pi4W3aMdoVtVWQ2YzkL8Ygudz4mCCul7T1h/SQzl1B14w+buMlAy2b0MJV+gH45PRt2BpIP/LybvtC7thBN8MvjCQbXJpyBjJ/sajwpYQ24CjuM6jeO5U/nCMi9kkOH5pdQo4RqWVkjyNl6baAN5xlT5NirYklDc+5smE5ajd1TLE3IZmIplplFuMS5h33Z4BF4kaNIeuO3Z03Mob8l5lWg/LFmruhpFaR/lgXd/SGIubsXjG8ZlXGk8RcZn3e7zH1J0Cqun8TklGemLk1wEPOJMWLNppDoapq7bgbMEAE4YuYemDJr7lFgW4DspL4Mejx6G0zxnfRyhgjbWp0q9C9cjnWZaiTfxSeZfgQ3d3tg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(1800799024)(366016)(10067099003)(18002099003)(56012099006)(11063799006)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261102123227099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gUHseSLRHelfjrdJjtKNnNl7N72AcqP3YCcSY8ca8thzdopz0Y1o+cA5mJqw?=
 =?us-ascii?Q?3+iy3tRMYr1BREIfucTCh4eTz2NGmg0pZ2NZWkmEUJcXpJIVOsHVvKrObshr?=
 =?us-ascii?Q?3u12AMKPao+S/9vkSI0GZa+XDmhdxmtM+ApMmU9PQ084LGAD/XdIjTVBSAmP?=
 =?us-ascii?Q?baHoGL66S8xSDc3uPRZXfR6r0Gaig8suLGKKclR1WKhr2mNnlUXaNZnZfES8?=
 =?us-ascii?Q?+nZOzujJ/+CCMOpLvrAc1HsgD/Lr3mmEMPL4WcwBk2ZFPyftIJ9302SnJ2vr?=
 =?us-ascii?Q?bMCTqJFnVgKpbYA2b5m5wcWAE9nLaBLFNukjxbATa9hVNCWl8PTxbk+mroF7?=
 =?us-ascii?Q?Cy9deiC4pHvOd9PRBiSzRnsloEp2lL4hwBoTPy4gG1ZyszbIDCmj8vmZaGpx?=
 =?us-ascii?Q?EEB7IvH1B67AXS/BTyIGHk9bwJbz1MGCfJ4lsoXAOqa1BAirijnBSXZ3jvN+?=
 =?us-ascii?Q?YI7y4Oc4K/7zEtMQGP+4rX/gUy4KqM8R1tfS07QUmrCl51w5uxNms0WFxfU9?=
 =?us-ascii?Q?XcRdVCgTPDgR2gGupC+gTOO7lD+rAauawVbgs1Yd+eb62FudMSXcd6lB+CAa?=
 =?us-ascii?Q?InyDw4Ky5XZIQgYOtV8IkNuPl7jbdLkWqM+CsaLGNEaxQGmXJ9xdKx4Njkpa?=
 =?us-ascii?Q?Emlv1dsSTDF4kENaWpuMfuR2hE8zoJTwnZpYT6AmzmPGB52vcn2tBwkwPr8p?=
 =?us-ascii?Q?sc+0Zm6J9791T4OJTvoPGsVo1vNavYMtvKsdFe0a6CEVgktDbNJu0Lm1z7By?=
 =?us-ascii?Q?NjlxsR8OuBqSR1m+adok5H14Yiys1C3jrrP02UBzdqSn2wKCofd7lWks537s?=
 =?us-ascii?Q?lEnFGgT4TLSa3O3n+rEfVjLDNFYtTkXgChEc70S8Y7uw1wuzw71y/Ye0WqDx?=
 =?us-ascii?Q?FqWAC4cJGdxl9XW60YyJIa5LlWRCVydDRe0/7AO+YbAxwJeWAKfcCQzq6hG4?=
 =?us-ascii?Q?CCn2Z5DrU0o+iqkM2MPux/2C17OYFkdy/YklSdMi77DKhVHKAmbJNipkzuVG?=
 =?us-ascii?Q?XM4ba/Qjdjp1Yd9baK4W3/INn9to1zqL7pGMvEyF9EXEwOfKJtnFOXCQd4Nk?=
 =?us-ascii?Q?ndiETGbPPPqMZ5JiVVAdlzyZb5G+M9QrWct5NcR0WhIpwPkcWd5NFciVD0eE?=
 =?us-ascii?Q?VFqcukMkQJ//QnNcnQFhNcHNnqsnxrcnW+P8cNG5jDkZdRpkLHHwu5EkhjpD?=
 =?us-ascii?Q?g4KIsjGeHKkNwk0vpGunhr86rJj01EErkU7p12Za7t28hcwABdZpwdMoDYwC?=
 =?us-ascii?Q?Gbox4anJr/A53iwBfOEH/Cgrq9hv5xnMPiOPLRAbmo8j8yJzAGk0QFemTSFl?=
 =?us-ascii?Q?uSVDtbYEn7MU/1ylBM2nWQrNkYa5nRBJM6MbpQG3xV/IwwQwf5aRMeLNICot?=
 =?us-ascii?Q?Pjrt+LebNl/4fFtQeMA/Ivn1T1mXIxP2x/1RN9W0oBitqhROBnmsG4RN5NUo?=
 =?us-ascii?Q?aM4fRxuSbBoUuAptERK5y/g7yF9cjFIlOmovkcepqxY8BdTM4OWJ4pnRLMKs?=
 =?us-ascii?Q?gMZQvS1JCqqAyuKjKZP/9jptkQ4jwumkw6h239YonYJCIOgaV7Vu98PHIrVX?=
 =?us-ascii?Q?8+4Nd7zmc7WeppU7Izre/fAgPFuw7FCipW2RTpYmb5U86QGLefGIWCZFRtNF?=
 =?us-ascii?Q?Db7KKCZL20CSWAG//czpHFwvx8KvjeC2NxAPGf5MBOCWrV9SUKDY/d3bcjmU?=
 =?us-ascii?Q?zAgBmZ6XgRmV7nh1Z76UUhwMzVkgNmFyOlatlG8OgXB+fBKNfatLLFEb+V2t?=
 =?us-ascii?Q?KGA5PTc4aqqdaqwXkaoyOFaeXd77JdJb2xDh4GSWh7NuEuSvoB9p?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6033dde2-5ed4-4a5a-236f-08df397af496
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:20:36.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yf3kahj5T0twhtWJeu6gUeN4Yt+sBGDRmoXUW9RzEScHvE2mEpwws3nda/rUvko3IGc84bPNHXF5RCTBBXwKyT0wTLWIsJh9w9K1lb4MLcMj9LH8wwsZr3dgpm5bfOBx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB197544

Hi Johannes,

Please pull the following nxpwifi changes for Linux 7.4.

Thanks,
Jeff


The following changes since commit c3e67bd82b9b9b1a5118f09a429ccefe2aab0741:

  ipv6: reject wrapped temporary address preferred lifetimes (2026-11-02 22:31:32 +0100)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git 

for you to fetch changes up to e7c7c4ca5c41c38bcd6bb08ab57f6ce53f4ed0df:

  wifi: nxpwifi: validate monitor RX extra-header length (2026-11-03 14:23:57 +0800)

----------------------------------------------------------------
Heyang Tan (1):
      wifi: nxpwifi: validate monitor RX extra-header length

Tristan Madani (1):
      wifi: nxpwifi: validate scan response TLV sizes before indexed access

Vishal Gupta (1):
      wifi: nxpwifi: synchronize scan cancellation state

Yehyeong Lee (3):
      wifi: nxpwifi: guard the 11ax response handlers against a detached command buffer
      wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
      wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response

 drivers/net/wireless/nxp/nxpwifi/11ax.c | 67 +++++++++++++++++++++++----------
 drivers/net/wireless/nxp/nxpwifi/scan.c | 52 ++++++++++++++++---------
 drivers/net/wireless/nxp/nxpwifi/util.c |  4 ++
 3 files changed, 86 insertions(+), 37 deletions(-)
