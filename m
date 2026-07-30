Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B17238166;
	Thu, 30 Jul 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433804; cv=fail; b=EP8Ip1x+VS9+VY1OMSOULlcLSiBzQ76fZzXP9zmBR+P9lzoqdHowYCpCzy85OrmlHx/n8s7s02FPs7acbJe64vAooIhL/T/sIgbUXvm6ZdqflDgcTodKAMQV7dsfaMImF4eKjOIQTupQsz/GHdbTBvmpXLiVYCrI1uobxvTCxLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433804; c=relaxed/simple;
	bh=mQhpdxwGft04Lit/l5HdQQE9msrd2LQDvwX7yMXT+aA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QCQaLlwpe1IV8CbCtuCSAKWSqDcIV0DxnZ3nGjfRgkPNFD6SEM5gaHcMzcNBEZ8G11Ep+JoRQbkGcZu+WMxd1jTvj85RKq3060JjCNFKYcCUjfkptclZfyOCTrfUWPdo6h+E2zf0S5C1Uq+TVWqVFYiXe7KMFbSbzyXu7d4mzow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=Rq7Gxp2w; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rq7Gxp2w"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UGYhaP1422201;
	Thu, 30 Jul 2026 10:49:40 -0700
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021113.outbound.protection.outlook.com [52.101.52.113])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f091ee-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 10:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtD/83xsygA7foHGpGqEJfXq3qXDDwJxTfZO0diaHF0cYJqx9HzyPLk9nVGAyfHvxP9D34tdiZGWYaoUqB9Rc5r2tRZRpQsNeVchLdj3y3z3QOgZIp+IXyZOCkZmivDahceJnH/Ls2uetd5Sq3tFZw71HXMm6Q2eu+CRW+F++B08ApcGBTLcsv9s7POJkFY/2Wm/2uwhyBeI7do47U73/BzirfpN9XK1epm5LkpAD+neeAtIMj490eAhPQ4RxI890rYN9HuUGp3E9hWJ/oXix4CkSb9WUQx4QU1p9U6qIXbXZYdwrycGXq/YD4wTzf6Lel6Bjo8s+cMntuZIHw7WRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQhpdxwGft04Lit/l5HdQQE9msrd2LQDvwX7yMXT+aA=;
 b=JTKyQblInxY6ZzD0GeuSEJ1FQ3FmL5Jdh4AiiR4HcgvPoOK689VSF95sbt/Rs4bjZCQ8rCeY9YCVLbr8vPSe+d5ZEZmyNyr3W4Gvs5Ot85bjp5WzyIikm9kBZt2HfL2hUV9+wluiuKFuVoRE7rXnNLXBLmfSKnXyGVcmHRUGqmVnmfaX3eEIPeJ8jW7MZCV4vNakKrwaIghG9kGEcm68hN2ar2iU7Y47BX/DeuJFk4HkcnK9JrDiUa8KkoDqhwnvlZ0ksR7fVFrjVpzWsIL2S4y/kx+4o7548MIILIgpnQ6xak7E0NLnnNaJQD05v06yYxEV4gUPVfBje4ViRYS2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQhpdxwGft04Lit/l5HdQQE9msrd2LQDvwX7yMXT+aA=;
 b=Rq7Gxp2wHDbWlVUzhB7fec5xCykTFFoZLVZgE3QHc7kivADZX6T7kYc2MkwGHGWEY3UPGWJWvXamZVIQVrOPDOha9dizVFAOVx6OyauFwQhlit4S2kDjis2JfS0a+AUxCmSbmtu3sjs7G3aiUQJkKziHSFnA3G4+i+Ol9+a7pXk=
Received: from CH0PR18MB4244.namprd18.prod.outlook.com (2603:10b6:610:bb::18)
 by SA1PR18MB4744.namprd18.prod.outlook.com (2603:10b6:806:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 17:49:36 +0000
Received: from CH0PR18MB4244.namprd18.prod.outlook.com
 ([fe80::7491:b2d:4603:97f1]) by CH0PR18MB4244.namprd18.prod.outlook.com
 ([fe80::7491:b2d:4603:97f1%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 17:49:36 +0000
From: Elad Nachman <enachman@marvell.com>
To: Yuyang Huang <yuyanghuang@google.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet
	<edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski
	<kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kuniyuki Iwashima
	<kuniyu@google.com>
Subject: RE: [EXTERNAL] [PATCH net-next v2 1/3] net: prestera: ignore
 duplicate RIF destruction events
Thread-Topic: [EXTERNAL] [PATCH net-next v2 1/3] net: prestera: ignore
 duplicate RIF destruction events
Thread-Index: AQHdEM/PYBEcDyayfkyp5xkmpi9SzLaGdJow
Date: Thu, 30 Jul 2026 17:49:36 +0000
Message-ID:
 <CH0PR18MB4244230A2BE15899162DBBE2DBC92@CH0PR18MB4244.namprd18.prod.outlook.com>
References: <20260711005405.2861680-1-yuyanghuang@google.com>
 <20260711005405.2861680-2-yuyanghuang@google.com>
In-Reply-To: <20260711005405.2861680-2-yuyanghuang@google.com>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR18MB4244:EE_|SA1PR18MB4744:EE_
x-ms-office365-filtering-correlation-id: 5e0d14ad-7a44-4053-446f-08deee62ebcc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 llX2+FBchMe+ZH8HInm+TcLc5dyCSJCM8GRcEXRb0Zu6CReMJdcsfdrCK2SgW17vrWzrMpC0olI/c4YLpPWUeb07KOYxhq2UIkFh3awFOITZj7SPbbONZ5sXnZuCF7hMmg7rXnNyxFHo0vdTL2PJErJ2HvcBd4x7MokByaUDli+1DjERGXYvvv7CpPyiC6yb4RyihpVVERMCaJeuuRmDY0J+A2gQq0oPRclc/HmCdGejqzzeNTGY7m0zUYYAc18MQnuyxA7PUzNuCiJvFLL0dHwqmhST1M+lHU+iaB5QDVGjddLVGuZimOPG+WJT004+lEea9Ufvnq34j4fYY3TbM6360sEbt1TN0/vnmVHrx95UKJu+8qJOJGW6yjWg4ebs6ot3SyWBpX0k5FaR62JzLtngflgQZQzDXvSMXKONt5u6a7bHCDSJRz8qHjkyRu4GSoAMQYFaulO+qqHvlXlDh/MxbATN8x7KVTiJBR1+IY4DSDXBNir8F8NLjvvjZEr/wxIeRo97gGu3G9EbLZexwDmXrKFK8Zv2my5+INCjByb+zB5Vta54KCgMM/LSJwtm9VsOmQUPtrnN5GgPgTIXixgWhdSikjMcFmX1eKGk9d43f5Y9pW3yP8PDJYrpWCqx4BTjWno5YBPGnlOWl0VwijAd4FnzOzJPyzxlXBzablJrJh7krI6PenBdpaajCyjunRhT9x05PZHTL+EfgbXVJn04xoho5pzo34NKbLrSqiU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR18MB4244.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QnRveWt5ckIvL3RNOHdWM3R3NmQxNzNzN2FUNis3Mm5MY2xFVmJ5VUd5cDJu?=
 =?utf-8?B?Tzh1bU1qa25DNEpXTC84N3A1bVd5SVp3K1lMWHI1eDlKeUVUaVIyb21HY1Ax?=
 =?utf-8?B?VC9QUVhBM212Ykh5bUJneHFja2R6b1hCSnYrSVZENnBTb2l0NlVmTXZuQTR4?=
 =?utf-8?B?S2thRVhzMktnVkxFSFhOQjNlWExtN3lLbXgwR0MxaG53NzE2OEVDVWpQVWNJ?=
 =?utf-8?B?YWYwSk56Z1ZtRG5lQWxlZUxEVTVUZjlBR1d3dzI2TGQ1V3MvSWRxV2wwSWJX?=
 =?utf-8?B?Qis2bCtUUGx5NUpNVWxwZy9EV3ByekpLUlJoMzJOdWd5Zkt0YVBDNXpUUU8r?=
 =?utf-8?B?cnYwVit6cG16VmNRbDYrZWd5d3lQQ3RZWHc0N0VxQ2xEQW9yaWVjWDAyTVo4?=
 =?utf-8?B?TEdQeFBDaEZreFJiZlI5Z3lXQlU0ZHVqQW5PaUwrOTRwNHdyL1p0c3dQMStm?=
 =?utf-8?B?RlhLU3RnQ3VoUkUxN25FbnpsaDNqWFNtQk1GTjZOWFJpUEZaSFBSdFluZVNa?=
 =?utf-8?B?Q2hidWFyZ0VNTFhuZ1RvVGhpK25mZ1laaTR5YkllMEk2citlSnVlaFdqOWU4?=
 =?utf-8?B?RC8xZCthQjEvVUsrcnExVzlQMDhMcFVjUVA2TkRPN1UxSHVtL2pEZUtVczJy?=
 =?utf-8?B?elBEYTlUVWd4TTdXNE1zTE55SFU3L0QzTG4yWktrRkNCb3B3NnQwZzNqS3Ja?=
 =?utf-8?B?ZlZGUmdSZ2sxc2lqL0ZJRGFDb1ZKYWdyaG9zbUFJQk51T3hvZFVPYW94Q2lM?=
 =?utf-8?B?eTNrSTE0UFppUWtlTFgxM0VHMVVkNG5od1BMNGthbU03TjVRUzR5bWpoRHhz?=
 =?utf-8?B?VTFScWVEWUNUMVRDd043R3dPbXRBMU1NL1NuWmtPOHN6YkJtb2t1b3RrU0Qr?=
 =?utf-8?B?d1B4Sk5FVHk5NG1rdWxXZVp6bXREMzluUXhvQ2x3WGVSQTI3V3lyQVhRM3g1?=
 =?utf-8?B?cjk2a1dhWXRoR0FaclVzRlFLNG4vYlhJSHJOOVVlQURjMTF0UzErNEpOZzUz?=
 =?utf-8?B?RmpIWFFqVm1QT1RHZkx1alJqRm9kSmhWSytpa0lpeFIvMElwZUZTMXNhSjVz?=
 =?utf-8?B?em0wc2k4aE9ReVMrZTFVdHp5T3NtUS9ob3p0ckI0RTVockdmc2F2SWJRRkUr?=
 =?utf-8?B?ZExhUWNDd0c0dXAzNmtUdVdPYW5QdXB3bmZOeWJRbmp1R3JnaG55dXJzRENu?=
 =?utf-8?B?L2Fha2t2NWh2QW5XRzRueXNhdmZ6dHB5Q1lUYm9pK0doYk8xUlFWMmIvVHQx?=
 =?utf-8?B?dWdlU3hwZEJSVnVrT3dkZkJ4bTN5bDBid1VoL2xURGRuWlRpR1NyY0hFWGdX?=
 =?utf-8?B?VDlDSVFyWEE4RU9SMXArcS8yVTcyeEpUanVUMXRVNUx6OWNPU0pwL3pEdUlH?=
 =?utf-8?B?U1JQS0owcnN6dU5OZ1Y3d1FraXprTmdHVkZ0UldGQXlxblR3ZWdLaXJzQlo2?=
 =?utf-8?B?SzlqRnBsN0VYZ0FDZnRGSzVmcWVrenU1dEJpSUEwTkNKdnEyZlJxa0NwNzVp?=
 =?utf-8?B?ZVJ5VjdMWVpTMnZLbnEwTE5ZR3R0cUpMWHU2RG1MLzBveFptUDdGbWdXYXZB?=
 =?utf-8?B?S2NpTThabyt3cDh4SFZITFNpYkdjYVBZdEhwaWlxNWl0ckJ2UVhiT0xndDhW?=
 =?utf-8?B?Vk9pb1haeWwyZnBtVU9RdlppbFVrZ3RBY3IxZWgyYkxBU0JOMjUwT3IvbFh1?=
 =?utf-8?B?aCt4VVI4MGxtYTVIQm1zc241UmF3SWFKL1NvcTUxVk9NLzY5elY3K2tpOEJN?=
 =?utf-8?B?Wi9KSyt5b2FrNERhY2lNeGJNeDZhZzJkZUwwajlkVVNGMTUwSG1KNXdiS3hH?=
 =?utf-8?B?MGV3TVlCbCt5Tk5EVWhDQS9Kd2F4bm03ZlpvWUl2ZWY5ZDhudmRncHdFRURu?=
 =?utf-8?B?bktTdC9qN2RsUGVHaVhJY3M1ZjdPd1NyVUtDMmNGU0ZETkZZVFBTTXZLRytu?=
 =?utf-8?B?Q3lwcU1ydC9vVWduUHFDcG1JcUpWYkI5czErZmhBNDlCb2xrNU44NlpaN2RG?=
 =?utf-8?B?M1Bmd2Q1L0VQZUl4VEI1N1FtUE1BY0RtTmhZR2Y4bFRWWHBVUUg3Wlo0TXlV?=
 =?utf-8?B?NW1tQVh2MFlURXNGeGlyUWlPL3NUVzd3eFZOM2o2TEd5Ukw4NU5nOVhXQnB2?=
 =?utf-8?B?MWYrdDdYUFFNZ2wwbXVDV3FHdmMrd1RVbTVOZUtUWDRTbVd0RXF1TEhWVGg1?=
 =?utf-8?B?YUcyOWU4KytzV2RIdy9oa2QxeEo5ZHpuME9jTGFnMWI0Zzk5ZFFUbGRZV0dY?=
 =?utf-8?B?TmtQekN3aE1TcktxNWJFSlp2YjBmM09XY1NhOVl2cFFwbW5SSW9ScjB3S2dT?=
 =?utf-8?Q?MWNIJ7N9OMhPnww5Tu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	n3oNypbqtQpsTDthLSHjXyj9I7YCFBRrRK208ive9wW0K1FTSvVgK6UumZDU1n3V9BLlrUmeyUBgQ7m+nDVv5UUKisCZuqVS4ooHIfdxn9eskXcFEVmqmf8dh9CurNp/YE3MvbvCEEIdd/lNmwI+8ELZdphckAWIzViqeobDZmclX4AyJ9ThYVKg1948ibwkoQYRsGHUDYzOJByJtpmx2/BWR9mp1Fy/zNq0CkDTEcXtbufQivO6C9ptfcnIvjWsxD+nzhCfQHn2+tKV54et1MSfYf04T5l2iR/U0t9YA9ZUmr9DfTwe4f8rrsCKxv6FVHWTWy06e9RAy72wBr+xUA==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR18MB4244.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0d14ad-7a44-4053-446f-08deee62ebcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2026 17:49:36.3387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jy3a3O29FP7Bkghl+e4+GpbDhjYTSkhcOoyZ9HlYE+WSUqT/T3RhM4E3gBEWQKG/aod7VLYuDabKCPuw2TXyaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4744
X-Proofpoint-ORIG-GUID: Fau-dvApeLeYZN4a4GG0CpMa2QbrwQBG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEzMyBTYWx0ZWRfXz/3FKFKrhy27
 a0RShKjkp2FCi8T3iRW0Zrkr7mBLBRqzd21U2VAOzCXf5QTsmFEqOFsozckw3/Tq6LIpNXQaih+
 69WSm3RuCkUQoOIclDu+inx/dnTR3RMbzViAuvCdFya4K01qKGboq6Bp7RI22/ktZv3Jg2uD8Xs
 rcgHpP6Yfrce5C9rqKYZvnYR2Dz7k+yT6LUEdtZSLLcTWsxziPWjhRtonlS8MSehSfVAe9Kp0mr
 AFDUqZNvJ2CdV5R2ZAV/nOiKa6xEzw71WRpXA09+FXK7UXSl515sSWEUEnHhqQ07V/vM52M7ytI
 0fPEnoZDvdpXihd2Pou+BiaiO4Nk11R4/rNFs0eb7F/bCirVSlWPDi96b46wXHj72KxQCZSwtdo
 KEDrHdSPPWzLSMyX6InRWNu9gRPcnOI0mHw1qT3Amt+zO3LHH2LToHg/ZQwR/ONmY7PSiNKd4aI
 Fe7yUbeDt+egT57YDwg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEzMyBTYWx0ZWRfX0u5ZIMMoZ6JN
 /lYGyuhNrYUj0NRnPyvc5V/3vJeBZ92agESFdivvYgmBjbA1ziLkujiWCgXVcpoO4NW4FeqUzOS
 kerLKmg+uKS/mFTzOht7BjOWpldr0ZI=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b8eb3 cx=c_pps
 a=yJil8v8xLNwAZq1aIpUJ5Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=QXcCYyLzdtTjyudCfB6f:22 a=Ikd4Dj_1AAAA:8
 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=stkexhm8AAAA:8 a=20KFwNOVAAAA:8 a=oQcyyo_0AMgCiD0e44cA:9 a=lqcHg5cX4UMA:10
 a=QEXdDO2ut3YA:10 a=y1Q9-5lHfBjTkpIzbSAN:22 a=OBjm3rFKGHvpk9ecZwUJ:22
 a=pIW3pCRaVxJDc-hWtpF8:22
X-Proofpoint-GUID: Fau-dvApeLeYZN4a4GG0CpMa2QbrwQBG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_05,2026-07-30_01,2025-10-01_01

Pg0KPg0KPiBGcm9tOiBZdXlhbmcgSHVhbmcgPHl1eWFuZ2h1YW5nQGdvb2dsZS5jb20+DQo+IFNl
bnQ6IFNhdHVyZGF5LCBKdWx5IDExLCAyMDI2IDM6NTQgQU0NCj4gVG86IFl1eWFuZyBIdWFuZyA8
eXV5YW5naHVhbmdAZ29vZ2xlLmNvbT4NCj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IEFuZHJldyBMdW5uIDxhbmRyZXcrbmV0ZGV2QGx1bm4uY2g+OyBEYXZpZCBB
aGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPjsgRWxhZCBOYWNobWFuIDxlbmFjaG1hbkBtYXJ2ZWxs
LmNvbT47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IElkbyBTY2hpbW1lbCA8
aWRvc2NoQG52aWRpYS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSm9o
YW5uZXMgQmVyZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD47IFBhb2xvIEFiZW5pIDxwYWJl
bmlAcmVkaGF0LmNvbT47IFNpbW9uIEhvcm1hbiA8aG9ybXNAa2VybmVsLm9yZz47IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgS3VuaXl1a2kgSXdhc2hpbWEgPGt1bml5dUBnb29nbGUuY29t
Pg0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSCBuZXQtbmV4dCB2MiAxLzNdIG5ldDogcHJl
c3RlcmE6IGlnbm9yZSBkdXBsaWNhdGUgUklGIGRlc3RydWN0aW9uIGV2ZW50cw0KPg0KPiBEdXJp
bmcgYWRkcmVzcyB0ZWFyZG93biwgdGhlIGluZXRhZGRyIG5vdGlmaWVyIG1heSBiZSBjYWxsZWQg
bXVsdGlwbGUNCj4gdGltZXMgZm9yIHRoZSBzYW1lIGludGVyZmFjZS4gSWdub3JlIE5FVERFVl9E
T1dOIGV2ZW50cyBpZiB0aGUgUklGIGhhcw0KPiBhbHJlYWR5IGJlZW4gZGVzdHJveWVkLCByYXRo
ZXIgdGhhbiByZXR1cm5pbmcgLUVFWElTVCwgd2hpY2ggYWJvcnRzIHRoZQ0KPiBub3RpZmllciBj
aGFpbi4NCj4NCj4gQ2M6IElkbyBTY2hpbW1lbCA8bWFpbHRvOmlkb3NjaEBudmlkaWEuY29tPg0K
PiBDYzogS3VuaXl1a2kgSXdhc2hpbWEgPG1haWx0bzprdW5peXVAZ29vZ2xlLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogWXV5YW5nIEh1YW5nIDxtYWlsdG86eXV5YW5naHVhbmdAZ29vZ2xlLmNvbT4N
Cj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJh
X3JvdXRlci5jIHwgNiArKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJhX3JvdXRlci5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYV9yb3V0ZXIuYw0KPiBpbmRleCBiMDM2YjE3M2EzMDgu
LjBjNGY0NjJiYWE2ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9wcmVzdGVyYS9wcmVzdGVyYV9yb3V0ZXIuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tYXJ2ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJhX3JvdXRlci5jDQo+IEBAIC0xMzAyLDEwICsxMzAy
LDggQEAgc3RhdGljIGludCBfX3ByZXN0ZXJhX2luZXRhZGRyX3BvcnRfZXZlbnQoc3RydWN0IG5l
dF9kZXZpY2UgKnBvcnRfZGV2LA0KPiAgICAgICAgICAgICAgIGRldl9ob2xkKHBvcnRfZGV2KTsN
Cj4gICAgICAgICAgICAgICBicmVhazsNCj4gICAgICAgY2FzZSBORVRERVZfRE9XTjoNCj4gLSAg
ICAgICAgICAgICBpZiAoIXJlKSB7DQo+IC0gICAgICAgICAgICAgICAgICAgICBOTF9TRVRfRVJS
X01TR19NT0QoZXh0YWNrLCAiQ2FuJ3QgZmluZCBSSUYiKTsNCj4gLSAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiAtRUVYSVNUOw0KPiAtICAgICAgICAgICAgIH0NCj4gKyAgICAgICAgICAgICBp
ZiAoIXJlKQ0KPiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ICAgICAgICAgICAg
ICAgcHJlc3RlcmFfcmlmX2VudHJ5X2Rlc3Ryb3kocG9ydC0+c3csIHJlKTsNCj4gICAgICAgICAg
ICAgICBkZXZfcHV0KHBvcnRfZGV2KTsNCj4gICAgICAgICAgICAgICBicmVhazsNCj4gLS0NCj4g
Mi41NS4wLjc5NS5nNjAyZjZjMzI5YS1nb29nDQo+DQoNCkFja2VkLWJ5OiBFbGFkIE5hY2htYW4g
PGVuYWNobWFuQG1hcnZlbGwuY29tPg0KDQo=
