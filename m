Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012005.outbound.protection.outlook.com [52.101.66.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59CE3BB9EB
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402047; cv=fail; b=WIFPb4n28Ahsr7w9zoORDQHSU2C+iU+dMqZ5p3aevmNmPy2lzCA0PSXptDhVb6JFReddFJB2jaFcqRv1l6i/cPoB80Nq/kZBWvxF91866R7gNHDX3d+Jqosp+ADVk7hTN8CIJ70ZTbOWWTXDxpndA7Wc3grpfbZsRh7/pMtryyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402047; c=relaxed/simple;
	bh=36ItrS/iO71uJdMvl4FKiTDlGWrxuG8DplL3MKXrpoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QR+JRfeqJmLGyqH2kXm0IIOqquOCv43Ft4GmEcnHhKtyHvW2kK2Gf9MjcRNcSx0BIZmKNsqs6VG9iZt3b/nSqSxYH9rF+U81lGkuIA0LcpmEE1OtAAbSkPjhrP8CfY6sKGb05rCojXStgRj0Htb3ccnuOTG3e/o3XrAQv1D5iZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ZAA1uJWz; arc=fail smtp.client-ip=52.101.66.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ZAA1uJWz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=shJc7QJtZM6YD3GZzNMhWo3ves24OV8Jf8bkaT/vGUolcW747y9AXVGDeQq83cxlgXjHN1X8HuEhA5eaWuYnnBym8IkTi+6eAjloArDKouH6mRUrF1vEevwhNYAaeiTPY186qghPhgYc9RgmuGZPiqUCXZ0iXHoJTNybWKeVxiOaXOE8lZrwJhYORzGd+aUvl7SMlIvOUxD2f0bDRgrqu6mTpCbQn5ptxFJpvDHJ8pzGdsBzVR/pZ63gRekdbuT9GnATHN3g2MSWFFJ3d8EdWR3FQtGNG2r1xpKV0qtqy9uOT64qoOaJjIxfRnNXCzKgePIwHQxUNamhPaGp4610rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMUxVgq8798zdXwPW/9nH42YmE054aYzDghslaYk2rc=;
 b=eZgp/4W/LjRHUOYW8c9/Tq02AYEKFOVXM2guJ8GXDSbSCEtgqal2baWn8ooTlj1yfeWizoMYG+TA6SCo6USUt6nKAWVoCJsBRBe7hbLTXVWSK7aGDMr7Qtb5104MWQUkXH2/ksXMF+hSiAm1kir7dtr6pkUWdnNiwL18zoFpMn7f39B5+NY6zOwRaAozf6dJGdbD+NBOO1CeY31mxl0oEWulBCiAdQnKaVLaolHGlgbTIfw2vL5/IFOIngWT56oUDa+kendnu5giT+/QHpmwBVjO4kMwD+3+E7Sk1SYKu2m3EGqshj09Ipi3/HE8j6kpm2m2bBeelwyZHBA8hvfLYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMUxVgq8798zdXwPW/9nH42YmE054aYzDghslaYk2rc=;
 b=ZAA1uJWzUxNZVYpHnx63kPxo9Xer1mp37N2xHqrUkJuPs3gGViMjgixaje8rJa0oNUKcikNrZbxEU6e5++9OPryBPOrrGw2HEuRJl3bf7VQ21mFDsYeCVpbmHXuU/MQNMBVpODMJU25qCEK5jVnQ8EyThUTuIcSIg2IdRC3Ul/jbfc2FzvaDdnqCi/UzzriV7HGF0V1iyytvbYTtLMUfF3GSQ58sfkSro2DZAiTYg4HA6t0RzU3GuIElMipzPmzS0adJxJwVl+PSnNYUHP5qC6c4Yl0KxxYgRBufycV4gzqicqlDkpZANiNjB0bqofvi/gwJ8kjUQ5aUClORhkDRNw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AM8PR04MB7441.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 09:27:21 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 09:27:21 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/3] wifi: nxpwifi: fix the 11AX_CFG response handler
Date: Mon, 19 Oct 2026 17:26:53 +0800
Message-Id: <20261019092653.3609605-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>
References: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AM8PR04MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: dc3ada03-5c4c-49cc-0a47-08df2dc32d7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|23010399003|366016|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Cw77eA1T2Gf89iH/NZi4J5ruCZBpSEbgKhkhLmfzPRX99i2ClUshwoeP0Pa4nsE/NW/kl09Nvje7wKih59u3+Nun391wfLA1Vr3hax8oTo7MQEy3IoCX4xhe+pwk/6SnltKwoT8yXTGt1bldvE/rzugfpvpma1ia9RxNUJIS+/c6plJkkwNyW1+4Z9w7EcFAuDR3rNiAkXYvUYZLaEQ5DjiICDH425TBhaiS1yA7EjdrWaxZ+DYhORMLwlsp9EDozrWWe0GLEa6Z5RulHU14egKMIDd2YNqkAQLNIcZdaIq5LrNgURjUD5a4Hp46ZshEGVbcwgyiACWA0ED7WMAMn48I3s6Argc8CoxSknlWBfw8chTMkcn/iS59dDwvz85p21nq0njs5QrrEaXBAdymoGs55CUXsBGRmJ67SUxtgmbqDzsRjThYT7mmQ7BvACGxC96TeTntaq8poJ9qR9ypy+4pdX+3z0sGfKkZQtH9Kx2JHS6GraXSBeCKzkYIPR9boImF6Fg/2q9iEvqWgsFBbL7Od1Cqx615oMOX1PPD+ON/omzONs4aUA+EH8QYBddJKVnNPAPUGRYg4NZBGuj2pC+JrHf7SY2DTlJtAnk+YSzdUt6kJV8MlriKBvDGhVLxsXOKcij3hTZylj7uZ+5EJy+U9FhKWhd1RmcfJRQpi0s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m8sR3qccalaFHNKtf65kY/2UFymD1LK1fGChCeaDYwvte7kqyh40TRTsiH7S?=
 =?us-ascii?Q?DH2qwtA0k0wCImya3Y4pvnoH27c113uzdv1MPRFfkW+3E8WZrxn23t3hwiEZ?=
 =?us-ascii?Q?RSCCQdaWfEHSzFknlZJmirQldgkt7HAGTJXb91vH2LfJ1tXBMoMDqr16YX7d?=
 =?us-ascii?Q?ugqSS19DcPsDgD+MPkg3gwHOfUyUfdjQAQQ24g5tvt71i5LfF/U33VEz2yFc?=
 =?us-ascii?Q?gdde0k9Id+HBFamdXLrkYUMQSlaAIzySJjfY8oIjKWl7qFSUp+T+X3lOt/2d?=
 =?us-ascii?Q?OEVKK/egds1l2GWDmz966OQysIYsTlNcp1VvZI/eSxZUankXKI+zbEqrum9c?=
 =?us-ascii?Q?ETR+z0S76Pl3oxpm4q6+9Q3MaKJbmNikoHQ3t6GtKleySaSQpFelwX7Eo8UL?=
 =?us-ascii?Q?iz6K/Kas+YXQGQ9ZJIh/zJNTLDh13ol4khAyTtbmYZIR5jXXzgl4AOB8KMpr?=
 =?us-ascii?Q?YpIw2weRTumcFpYghPuQRQ5JH61p7v6GHAuPZeeZIOsqLFY2jpR2vEo5dtdD?=
 =?us-ascii?Q?JsIvkKK17J7oRSzMSucZ7tM0qLDWVM2g8zvRGN7J4dD/Ead8g/1w+wIInpDT?=
 =?us-ascii?Q?efT8e3MbeL6R3PN0SiwZQyMGaZVDNL2DYGEj/Ij0lHlSO1WQukK8DWse3bdn?=
 =?us-ascii?Q?R0qRLPHwwI0bw1EEXPoQn9vmyuvC6gYbzk9DFhs8MotU1iiW8r+Wbdk1qfJO?=
 =?us-ascii?Q?/VgYWz6d9MmNVj1y+1aMLBnee3F1H5qg3QGPFTeWd43nMXLleKvrYmNaMy4m?=
 =?us-ascii?Q?+7GrqzSCnkfzgd3KSixmDDj51liSGeJiUCVNjae6kpgop/lTFfm4XezSmU9m?=
 =?us-ascii?Q?UcZ4wgSdHADOAwZ0Hn2vYUhnl4IJjFuFsZ5semklVkvv8/vYYHoHrCzmdtvW?=
 =?us-ascii?Q?/AMcAK5NRYz/U3+Yu4uNhfLzA0FebYDp+w8Y5mKXKFefOXlVC1/zksKC+nO6?=
 =?us-ascii?Q?hRMplCHIAMf3VE/1hatdqIPPhe+lBjc9FCAuYcckBTWuCYNlL5hH4CiNRQ9S?=
 =?us-ascii?Q?KTka0/6dvSy5mZ2vDQNbX4RqDSba4AFCFc7jipWXYKPKela2qiP9p5kR0V1b?=
 =?us-ascii?Q?cXyLJf91fqaAlXTql3Cb3eFAVTnD9BH/RLrYIxh2/XJP0nXcC+pFKjsm2Yd2?=
 =?us-ascii?Q?hn34GlUNoRtQ3sf1i2TB+xdlR3e1MyotdRGmEAChBCkY0aA0Sy55oDj/nwSR?=
 =?us-ascii?Q?Xto2q/i/rsyI9U3Tru3O4O2dUNAYRjMmqh10kR30RCtVGJ6TFHP0L6cBT+bJ?=
 =?us-ascii?Q?h8duhd1R9KuTpXd0IYCu/fvlTZ5n51aPrszkAgRPPVLJO5krGrEQ1dgYPXh6?=
 =?us-ascii?Q?BH9qD5LDJYjDRxC6WwJPck3V5//sQHsjP99kFPV+vOelr+aWy03PRKCozts8?=
 =?us-ascii?Q?yjy27yEN+vvWfadgir+wW1u2w/6caP9itsKIZDUZZ9XpqzuZFb/BejWHlO57?=
 =?us-ascii?Q?UQeYV9yA8b1xMb4zNT+QyagWcSxXSphzdIkygyGdxh9BGUwFry1nCib97vAX?=
 =?us-ascii?Q?AY0shtVZwlfPUmsKGoLog2Rnp6nCBYcYotaLLWfNWdqY8y9FnAUkueDmXIY2?=
 =?us-ascii?Q?iwPrfqqX7JyJ1tQqz3TKP9k4e7VwT3Qo/U6IXJctV7waJeSU4v8QATUwNgiV?=
 =?us-ascii?Q?tFu2l/tO/Mc9iJ6u/Msg5F0KggWJO7wpBf6Tps3PfVX/mJEOnotQfxcof7gv?=
 =?us-ascii?Q?d0cWmFxbDVnn1Fjp/QY4y27XZfQDwXHSc6UcOSsEz+OOPmN+PLBNq2+S5umc?=
 =?us-ascii?Q?I5JmbbJsTbjyl+gy+GXjJWDSu567VTstBN7z8/H70oPgpKLYcP2f?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3ada03-5c4c-49cc-0a47-08df2dc32d7b
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 09:27:21.6267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5sPGa4Qv46l80WzmKJUmZyYXPF37cTcjfWzSS1fb5X6vzO2LKleS3d7zjmr4xqKMRpn5QUQMxsGgFH7o5Fd9GKr2SZQseD/z4tSePRD7Hqjz27MhrVgXXQ3+9tG1s8Mo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7441

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Fri, Oct 16, 2026 at 01:25:39PM +0900, Yehyeong Lee wrote:
> This supersedes both
> 
>   [PATCH] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
>   <20261016014927.434473-1-yhlee@isslab.korea.ac.kr>
> 
>   [PATCH v2 0/2] wifi: nxpwifi: bound the 11AX_CFG response handler
>   <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
> 
> which should both be dropped.
> 

Hi Yehyeong,

Please avoid sending multiple revisions in quick succession.
It makes it difficult to track which version should be reviewed.

thanks,
Jeff

