Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010058.outbound.protection.outlook.com [52.101.69.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CC3EC69C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791295122; cv=fail; b=qAtBvwZYrJSHgggFqCRg4iYu+ZWzrA5mYxieyKvUDkwWPUuWxEmlEpNF1tV7efBk31WcdWQ3hyfxUWSUY3dMfkrcqK3Gas8LcBQm+kHNRl4D2jNtT0DivIARHON4o3zbD+e8VCNT5YhaRw0IoBhTaHue/MH7fIHlDJS5ehfKq9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791295122; c=relaxed/simple;
	bh=5gRJ1svOkIPD30IlV4XOCvHWdKIUr97j+xo1aSEAJDc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=IHAHy0gpN+Y2dnZ5mgFlHN7sckJ/PY49Ro1Df2TGzAm/tELnEvb194SWDC4+eLPpUQl5xXH1MDPZCPhhTv4CaOrM3AHIM9q7C3BA0Cexuvovgb6oMSQIbDxFh6b28FPBZ58+/FFo073zFX9o9JV0/JNTf6IB2+eDmGsqA/zzOqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=X61tIwp+; arc=fail smtp.client-ip=52.101.69.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="X61tIwp+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjzfH2wm9pagzoCOBmcUs+iwFFzpJeMvRCN9V0B4PwQ2o514sE3BD+vzO3dJUjEbedEKOQOhfmboUfhryiYLlofkf/MAeAbgzJGPe85zPVaSr51fFtOfG2ZecFHsWhmfn6DimtCeYcCuEMyxWwWZazem9qWiGc9wR4OtbHAQ04SzCDyaw6g8npgclmda+3EIlNifr59BA4q/e1ZUxjRj7n9p71wKbSNN4y8BP7+OYGJYqydGiRldHzzNLs0jm4YArG5vqcNACoZMJLSngo/sh7W9HUh51sQvRqeDd2WJN1t48Zvu3J3IcfckYc2s7YuSiSqVvju/pmCGWnXMjJv+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ykqCXYCLy0gXbC67jFjmSpAdGpEj2zNZ5SV05QCb8I=;
 b=jI1HwH6gIuoh5Kiib4AOFjnW2+HZ9hoM3QjAqQEC26mILeTqNp6X6115WyOkYeFKatamNsqDbC+5Y+eVJyTEUOytvr+EVXe1OP3JkoLEZyvRHBpVYp0AsU5uotZ/Z0TS9ENK7boksKr0+rHRi5B9+2j0Hra5aUKRQ6il+WeZDdIkCSqntZv3wbc/69tt1S+fIHVZgBqzv3TWi9UkFcuW/kUoxxp0B1NNx093ViFsxg82MOAnzz2rJC5DFArDOCFZmHb9h4Dk9oKb/LG8wrJYRvrEBsuViLcXZIBO3+j7gK5XyLA0x6HgI6EGVQCjUlvJhr/zWYzshdmr+eElsdZJyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ykqCXYCLy0gXbC67jFjmSpAdGpEj2zNZ5SV05QCb8I=;
 b=X61tIwp+I6PVeWRTe1YQpjOuyuStTnPO0wyggTklanJxLLGc4fJ00/Oq4egKlyppJw3hZ3DGwAmXOuZUI1bBi8njYtROG2pNNCQa6Z+AODajVTLyTSCEDgKf4hhx8V/qmVzmjlHSoqZFMpH226W1sgJLOjSMQCYvRiP2kAPA+Oyw4m6tu+s8MwxJlsh/zr7QQz6M5Q5y6ToxOkKFs0W5ZQgxuzAF10JXk2ZY/YYpz2GJOzN40T772e/iTu3c2PCjXLttnTvVvWHfuJsYXeu5lrkFRqHGH41UdRS8MhjL/2mZDtrHygj1AH6gPCqtKSCdAxR4X1Zv+BMBvB7rkHRUAw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by AM9PR04MB8667.eurprd04.prod.outlook.com (2603:10a6:20b:43e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 13:58:36 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 13:58:36 +0000
From: jeff.chen_1@oss.nxp.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: nxpwifi-fixes-20261006
Date: Tue,  6 Oct 2026 21:57:47 +0800
Message-Id: <20261006135747.2922747-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA5PR01CA0126.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d5::7) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|AM9PR04MB8667:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0b9b64-4c6f-4db9-ecf4-08df23b1eaa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|376014|1800799024|366016|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uUwyW9PVM+/YlX9QLRpx/jPSqTDTxl01wic6Q1rOdTfrH0Kt3nU4xvEXrqvjgszSK90Vrua2oc1QJA520d9PEWlTiC9a2VNloPeyJxAaGyy6Kfv5g92/reEVtfZomdCG0YYu6Z57llbZ2ENgJRxIRo5shZVceM0tkpH8vI4vICgcwLBN5DbAC6LZoIIFJ+hZVeM8sW1zGQuYtFZVToK1ieH5znYpyRDFk43AkHKy6uHB+gTwOQ4saA+K2isPfADiZmNiJPUngr/i8aihQnSoNXiJKGgbiSO0Uc6t5hqDoayOVtTckK0fDoWvpBgPzQCRoTRup7yb3lAX5Py34UnlSxnIYeQoirnNFwpoPm6bTN/SNtBCwCylM1m8vjQk88GyzP7hUukj3yEBqn/9kWlBxNcWMxvS9S8nm2OjtQLFniK4FO567XyamqNykiiYLaE4O+4MA7W4FoPyUgTu6aJ8hZZJTNmSGTcWwYGpljMvbhvX0oI7EKEPLWgxLQqlHy48MZlAO0ij9/tw0bq2k8JBKT2Hx8d+L4QdAjQiE1qGYmhS2tMO1d4AMw62Axg9cgmQWsgN7rEtGEgkdNOy0nHqfzqDnKAP9eLBVgqtrBbF5ekddZJM4Q4tOesApvwXnaWmSljqE3Kjp2b/Mfzy7N2AzczfZ+aOcKAFALNQUusKtU8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(1800799024)(366016)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w+WZcwwK1vM3biQgD9aJatNrEzgQPBr8/VXDmPL4Vt5ikPJ/nYP1sAi4oLXB?=
 =?us-ascii?Q?VpB27ivAnolO3LTj2LQp/+KNG1IptBzNkaCtSnSnnB2YO3MDtPNGjZExJvYt?=
 =?us-ascii?Q?/2Uq8rtu/slq6v8mwjuuOruZE3uZ/OZSJqCZcqiq/8ANO4rvtIV22xLDIHC6?=
 =?us-ascii?Q?XwzUBrsnIqHHYzCMbM9lIY+0+Jyy1WcyrN6tD31ZQ9jSdUlwpZyG42rxj64E?=
 =?us-ascii?Q?LokOUaLuONQO2TW/jwFRSlWpWWUN7AAAF8we6UtnZLHV8Mt4lgcmWYsg1dNK?=
 =?us-ascii?Q?Es7mR5YlGcfEHUCK3Lyub0qG3B+Hu+vPPx0QRgvfn/lba4N2fkIingH3PJ6K?=
 =?us-ascii?Q?SLywZvP52Zx9QFxx+rffWOCEsxqY53mQ7PU+DgQyUC5dMPeF+RVJ+5FRB7hT?=
 =?us-ascii?Q?wkRm1uZDHuHCHxyy7w14cJGxuF/63FhNJZh9QboR2nA4ewNvsNbcWcKWydHY?=
 =?us-ascii?Q?W3XENwk5+ppsPTLnYnblWLxNmgcDMFeUt7a7V8AzlJHK4FiCdaE5GVd+5szC?=
 =?us-ascii?Q?mE97IUW9fI9Sk7T5c40ziEzsX2JUcQk3tgsR6F99EJKPJwvId7Vg2dAsAGkt?=
 =?us-ascii?Q?i8MPukVwKhHgiTYk6ILWGWJrn1alStiH3vXratUgr2jwm8Z0pb3Sx3iWyeDy?=
 =?us-ascii?Q?k4OHDg52aLwADgMJtCPpFNE+qoPnNYix8gOMsg/0dbTTQ/lezFednFkAc8i+?=
 =?us-ascii?Q?GeG59yLrucVghowq9K/2NPFE8yJohNsswISxB8viD/g994PNXBmmYx/vv3NT?=
 =?us-ascii?Q?BOWtVlZeM8xQFil96+uubUERgKKjm1AzZEl0rW9BDNP0np3u5TunlxiwzrmZ?=
 =?us-ascii?Q?CfvsfX/GdFmFVSkvHbeYchoDTRVyjrhXjkDYyUzBgvBijQBvPajZwjUKiOBP?=
 =?us-ascii?Q?K5zsuQNyWzQEzqnkrR/Ia8qPIh4NgYgrDYa43NhPyh0kV8Tqn61K+aXYBOxq?=
 =?us-ascii?Q?IRlv1qwST3hCPrPIzYGDcuIsE4utJWvkuY4WjbkSqCoQeWs2W+Y5Hu9+a466?=
 =?us-ascii?Q?vmkzgNZNYPajWAvyehkIZwgkji7Um6lnIVEjDftVYPg2sh32O67AdcoQf1B/?=
 =?us-ascii?Q?I3H05WbnOscYp1m56KsZ4I6TTeL/9f0GI4SYu0YybltwwvSs0hrUxlIr3zff?=
 =?us-ascii?Q?3UOm9uYUmPsaC+PU6s8ndlNSleAecS8lgv39oEejwKLUwC+Yud4BE9UvMzRv?=
 =?us-ascii?Q?GKDSwqoC96SrwucGFPpiPXTyH33s+V4xYl/HrOirCyoTyOAwfAPz4s9xE6CO?=
 =?us-ascii?Q?dgUsb1FoWSMqsO68ZyEoHcFRExQwQqBtSDA9hfLTWriDLoTP1joxankkvgd4?=
 =?us-ascii?Q?0Gb2vrkRUH+qIF4+iv62C9nB5F6Lts9DLNiCVrhVF15zSxQrwh7WFFdVDoih?=
 =?us-ascii?Q?vjj2zFuSUnz3bCRRmNx/tN4Z/QLUDJnuD6gtVKBpryY+HN8yxmePfbXmsPuZ?=
 =?us-ascii?Q?jox6KRr29QHeAwKjlQkykYdvebhRzFDgnNsfM5k+uy4N6OZ0XR+ifihf9Exr?=
 =?us-ascii?Q?tXMGDN05DhZ2KHlWLfztcZF7QKR1Xl9Ct8rToHn0yKxaUysBP/oEIztU1ZwD?=
 =?us-ascii?Q?sbDt/vkxa0Fe/JGW+pYc7r/b7s94lvhlu7An9cdW2BMgNKFfMFRpEzQwAp+q?=
 =?us-ascii?Q?q4YOmAipx1sxCmTwyFgF6g9Bl/36hQcudIB1mmkpDX6m7FEqwZ+0z+/bYuRN?=
 =?us-ascii?Q?f9FkA2Q09EQf/5NxTEgA2T4EwzZ4z2USna7UOoyGlVSgyXD5RB1yUWya5+X7?=
 =?us-ascii?Q?lCsKN0nwt8CVaKyVhug887pODvphhuVX0mU5Dkb19nxHp4+cTeuj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0b9b64-4c6f-4db9-ecf4-08df23b1eaa6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 13:58:36.4846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgaisS4/yW6xjgQ2a4QhxjNL4uqqI38Q7Icy9HtitQdI8oIm8YJJNNSK/56BZLj7aWBvxyUMFxLzoVrzyOodAeO0kW9+ZoCofBKRZXTzNQcXWhf11y4DtUI7koQPBITh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8667

On Mon, Oct 05, 2026 at 09:17:29 PM +0200, Johannes Berg wrote:
> Hi,
> 
> You based this on wireless-next, I cannot pull this.

HiJohannes,

Sorry about that. v2 has been rebased onto the correct base.

> I guess I'll (when you send a new version) pull this and try to convince
> net to take it, but Jakub pushed back because Linus pushed back, and you
> really can't just send a single pull request late in the cycle this day
> and age. You _need_ to send more pull requests and earlier, especially
> now that we get so many fixes. Yes it's only seven patches now, but some
> have been pending for almost two months, and Felix has *36* patches (if
> I pull that). It adds up quickly. Please send things during earlier RCs.
> 
> johannes

Understood. I'll send fixes earlier in future RC cycles.

