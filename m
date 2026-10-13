Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366C49A3C4
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 06:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871655; cv=fail; b=h550G2MnkpXedGpf/V5T5ElM+Aimwt3sGfSOnIEoN162XSafCAytM3pRg0gMRTW8k05bvpnBhJXKjtxkgP7Cc1K27hbPmgEM+SKn3Dh6KE53eu9qO4z4iWH50aIBQP7eSQwy3BskCIhy1vidNb5sR82topV8oa9cESU8L7F4PC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871655; c=relaxed/simple;
	bh=orBvBJe0OelTIPe8poE8qQ1nj8/zI/PJt6L92sb1+ho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eTPQfXriV9bO7Znjc5Uq7qVO3MvN1Y/y/okGRikl3djmLxexQneIZNfFG9A5TTWi/O8ZabYMtthYrfBs0JBZ6+7C6ivW4ZVvx9Y9WQeUVHRA1pX+r1YXoQxAnSPprsMEVGu9p2/JlXS4Nz+N7gA9uNogYn0D9vg1oAIiiyBdf20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kCTI+1dv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=FNeGXllh; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kCTI+1dv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="FNeGXllh"
X-UUID: 5c5653a0c6cc11f18dc8c9802ae25ab1-20261013
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=orBvBJe0OelTIPe8poE8qQ1nj8/zI/PJt6L92sb1+ho=;
	b=kCTI+1dvrxtknrzmreLY8UXMUaRwB4KFJ2Z8uE1tJvTLYqp9Vhnp1l+naa6EHqR0oVS5U9bJd4iI8r3Ri95GQzRHc6+RvdfHXeBkOfgpdrl/YBm5l7FzCsb4pF14GojzQFFShUh9r3d16jeYth3nzzp0wxt0ydYWfM+BILLRCio=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:9ba781a5-b675-48ee-a9c6-54479c2767cb,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:291e20b,CLOUDID:c61c4895-3103-4fdb-b79c-08de0e281a5d,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:4|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5c5653a0c6cc11f18dc8c9802ae25ab1-20261013
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 903202352; Tue, 13 Oct 2026 14:07:24 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Oct 2026 14:07:23 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 13 Oct 2026 14:07:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rARje7SpBI+FHrwBGTuPkoH87W1oZSd2SRkZ5hFJTZsmcii0P3ai91zoOMPkygau2VHNQOnoV29l8LbjjdIhBxWIPLlPLBpighCDErOl5LC+l5eiwp33hq6cCvj8wv9fEr3MZiPciwb4M9l2CLr//PUbLWmZb/w9TdLVhk9QOKseWDZLjyfrszKXdDnGOHqMn6SeLQdh5Ge9eXLVg56kluOcCA2eyzhbsi+l18QjEYNcIuKh7N7gVR35P2l8nuPh9xrLWQKsRmZ2W43r87+kW++y64xzxvmJUHYjZyzVeUInA3EHMSDdQW3YKNLmKGEHDNbBbD0XAVOoyWJyNA3r9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orBvBJe0OelTIPe8poE8qQ1nj8/zI/PJt6L92sb1+ho=;
 b=idXcgVk/yy7xm2uLNo5vhF3vK08766zwMVsrPvufMUalRe+MM+1Rv8zFrCKrNM2S4YR40JhGsNSLpL4WuwyvH5BOPSnMuXbKnlxoD+D0xu/+1oDbJaL1BFol1bhT2nSYENUqzp8tsRsiBaBMInl7cSYR4kMgrk4Wpu1kFRMVRUCDkBgjeCQZsCpCbWVXUOV4A6mXqoY7z2G56XSt3dGeInvfJ15IKbQBG96F8wU2ebCiUHwo01Q0jd7s1RR3TwsGZetYqcLjzEldxf+yCB9zL/OZB9Kr9/ssMO2oX17T65aSgmx2xZXKsZcDZ54yp7VBQ6Sn7ONSAeYjdx0Fqff4tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orBvBJe0OelTIPe8poE8qQ1nj8/zI/PJt6L92sb1+ho=;
 b=FNeGXllhrbvh96vV/pls/xHJV1nrRWnO4YWAs8AfhqYw9oomVGcSKRpVbwEvx5em8F0DGJJQ8L+Ex0Zu70AhTAiWiCSB3IuZuuSvcKthzTyocWvhAPHP3Vi3i1Eb8DLWJ9ct4ZW3l6rLJCUqwjtD6YYIxFZG/9sLxiFhpxAtFMo=
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com (2603:1096:820:d5::5)
 by TY8PR03MB10546.apcprd03.prod.outlook.com (2603:1096:405:3ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 06:07:20 +0000
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af]) by KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af%3]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 06:07:19 +0000
From: =?utf-8?B?RWFzb24gTGFpICjos7TmmJPogZYp?= <Eason.Lai@mediatek.com>
To: "lucid_duck@justthetip.ca" <lucid_duck@justthetip.ca>
CC: =?utf-8?B?TGl0aWVuIENoYW5nICjlvLXnq4vlhbgp?= <Litien.Chang@mediatek.com>,
	"nbd@nbd.name" <nbd@nbd.name>, "lorenzo@kernel.org" <lorenzo@kernel.org>,
	=?utf-8?B?UXVhbiBaaG91ICjlkajlhagp?= <Quan.Zhou@mediatek.com>,
	=?utf-8?B?S3VuIFd1ICjlkLPorLnoh7Mp?= <kun.wu@mediatek.com>, Ryder Lee
	<Ryder.Lee@mediatek.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, Sean Wang <Sean.Wang@mediatek.com>,
	=?utf-8?B?TGVvbiBZZW4gKOmhj+iJr+WEkik=?= <Leon.Yen@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmVmZiBIc3UgKOioseaWh+iAgCk=?= <Jeff.Hsu@mediatek.com>,
	=?utf-8?B?RGVyZW4gV3UgKOatpuW+t+S7gSk=?= <Deren.Wu@mediatek.com>,
	=?utf-8?B?SkIgVHNhaSAo6JSh5b+X5b2sKQ==?= <Jb.Tsai@mediatek.com>
Subject: Re: [PATCH] SER: mt7925: race condition in mt7925e_mac_reset allows
 compromised WiFi firmware to trigger host sk_buff use-after-free
Thread-Topic: [PATCH] SER: mt7925: race condition in mt7925e_mac_reset allows
 compromised WiFi firmware to trigger host sk_buff use-after-free
Thread-Index: AQHdWfmO0JkeVmH1dUm8/L9tIzewB7b637iAgAAeiYA=
Date: Tue, 13 Oct 2026 06:07:19 +0000
Message-ID: <25dd92bb32320e42d0e847e7c14ab1f234722426.camel@mediatek.com>
References: <20261012032657.58631-1-eason.lai@mediatek.com>
	 <20261013041801.268294-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261013041801.268294-1-lucid_duck@justthetip.ca>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB7079:EE_|TY8PR03MB10546:EE_
x-ms-office365-filtering-correlation-id: 984976e6-3e7d-4379-d2af-08df28f03d72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|18002099003|22082099003|38070700021|11063799006|261009223027099003|4143699003|56012099006;
x-microsoft-antispam-message-info: /WlQH9Kfy9YAILueFbnvps6KptR6BkwoiDTz0q9NB5ZR0Vx9BybSZpjbpHiryOL/aYckeBGV9UlrhT4rIwK+TLIYh4n3jphsygQBAbi29Ac/zNKZ52BfMNjkHWKjFrNtNPXAtEseOg2wVbo47Bw/IHiVffsqrMuZgmtjtYa+qjqRyhXfLIEryMcwKxx+MZtO8YU2DwtsOPDHptDUviS2v1d65uaeNPbkC+PZEAlUEb11SqLi1BGQi+OttvLy73y9Z46X7GpVxcjZv7xWwqVi9kqW+wOtPERoobLW999GuSVp/pWbXxfS6RHDR8JR+HgMRFLOsXMU+A+Hacg+e0fD2cxwFHNOX76FWnt9DMq3XQUqz1QMbPM+GEOLQ6AzVqt/7KhRhH3wGC1zCMSoUD6pXQbqKs6bK73ZWV3x9NhjA8bf7F2ufbaQF4dUYJepTzIV+Ep4d8fmlMwxaSsHn2JsZYryTWoNkdnZnqWcXYkVApT/JeUmT1prSXABQ9B3jEk7w2q+MEPJPGZYXTjs7zV1Fs/pJATSDtWC055sn2hXzrrekrE8vee2nfZostzkNz0kQKGERbQE8UUkWZEI5CYQxmGLZw7i3ZNo99Mmp2XeNJdoQhHI1/AAfeuPPbF/0UEHLs2qFcswdhHh++uW87CoKHUkt1WUVpIuWCk3JSd9TRdQGVG21RybtnVIGnaxGEzLjqaaUr10/v9UxkXZrWxUBiv6/9k0KdvugwFmO3uPEWc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB7079.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(18002099003)(22082099003)(38070700021)(11063799006)(261009223027099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVAwVWxrYllYYlpnUjF1dE1xQVFBYU9hMnRwbkwyUzU4ZUZnaUQwbGkvVFFW?=
 =?utf-8?B?L1hyMlQraFptTCtYUng4LzQ1NzF2SlRJOXFkZUdjdExMNytxZ1EzWm5pV2RL?=
 =?utf-8?B?UENPVWtwSEJuN0VYQnZsVmFrYU1kY2ErSHhpOXl3ZWZ1T1BnTFVyQmcxbTlt?=
 =?utf-8?B?RUdhaXlIMVRPM0ZPSk9ZZjFaMTVldENjSnpJOUJvcmdrZ1pOOEEvTXVPQ3cz?=
 =?utf-8?B?TmQ0V1E3WkJOYUdvZTMwKzJKSzJocG5HemNJZTM1dXk2OGQxTDBoN3FNOGJW?=
 =?utf-8?B?RkxSNlpIU2g1STJDU0hBL1NIVm54L3ZYMGpoOGhQNUh5M3gxQjIzc2U1cExJ?=
 =?utf-8?B?RENQMnRkNHhkSHYySGwySlZXTGs4Y0s2bWpINk5GUXN2V0VQN0JoVVRIT1kr?=
 =?utf-8?B?RFBBSFRCWUVRbm5JelN0SUQvWjFZRnJQeHVhNklVNnZmWkVCZmR2VWlTK3g5?=
 =?utf-8?B?LzFTTDdmc2ozMVkxOEJ2T2x2WWlVdUZ2ZUVoMGVDODNNbFF0eHlVVCtOYXRW?=
 =?utf-8?B?S1E1NUJTNXlPMGFXQ1E4bER0ZlVlS004ckVhVHFGeVg0UXNrVytNOVdZcHNw?=
 =?utf-8?B?Z2RGaWhWR3lhamlkMXJvZE1jZnZLaFprNm03dWtrSlRWY1gyZlprSnc2V0xZ?=
 =?utf-8?B?WmU1YXlFQXlMM2REOGNTL0tpbFVKSWdsY0xqdlZQVUNwMlRnSUp6NGxIbTh2?=
 =?utf-8?B?UytKcFRuKzV6eEZOTGZ1RkU4dUV5Z1RPeHpQQ0JlWS9TZ3Z3bHdCd2VxV2Nn?=
 =?utf-8?B?cWtNSEJUcFphenFSNGhQcXloa0NlYlIvU0pyMUEzdGk1aFRvUzFaa1UvWUIw?=
 =?utf-8?B?MGZRcis5RGE0VWEwdGNrU3RBanRFVmpvNi9DclBreTgvSDVCWlY2akpYK3hn?=
 =?utf-8?B?Z3p5NWJ1elp0dkJ6SGJ1dWhZTXlzSjNYMVJwTEMwZVR4NS9RYzltZGZ3eGMx?=
 =?utf-8?B?MmdFM3ZYLzArd1pmQ1g4cjB5QlJnZU5aVitxZHlyQ3lQSUR4WFVLb0d3UHEx?=
 =?utf-8?B?Z0tvVHNzMnRWR085ZlgvTjJGZlhZeDY2QnB1clNYdmovOGxwaEJXS2VsZDcx?=
 =?utf-8?B?b053NFMzTFRIUUd4NGRINGJrMkVZcTZQSFo1Q1d6ZExidWROZXVycVIzSC9O?=
 =?utf-8?B?b05wWWNNSVJ1UWxyTy9BbHV6K1hWcmlzL3pnSUFDRGhld0RoQndNRFRKRm9H?=
 =?utf-8?B?aDA0TWFGMTJBOVFjNndFU3c3OGdoK2Nhc2FrSXlqUkk4c2NIeStzOHBwVXlJ?=
 =?utf-8?B?RUtSTURyaGFsb29DUThqcy9TM0VVN0ZnR093VXNwZEJtRjhpdFcvSEIwMGRB?=
 =?utf-8?B?REFiOG43akE5cDZzMytKVnNJSFZYd2tsdTA4UkFxUmMrZnpISWFsb2k2Vkp2?=
 =?utf-8?B?Sm91aHR6QStaNnlmOC9hSng3YlptZlpKVE84WVBtek9pZVZDMHRJM3JGaGdl?=
 =?utf-8?B?YmhZTi8wVUplemZyLzFBRk9jTUd2b2doOGpiZ2VYODV5djJIc1NoSTkzZWpU?=
 =?utf-8?B?OE41cmRPWTdaNVR1ZVJESjE2V096R29oOUtNT01Ec2ZzdHhlVnVqeXF3QmJB?=
 =?utf-8?B?ajM1QWU2YSs5SW5INVZGM3JCYTRwQ1MzM011Rzk1NVJYNFZwZzBLQ0oreUQy?=
 =?utf-8?B?QzB0Q2pyNDFaQlAvcUpRa3NxaHlhNmhjNldudmhjSVZCenM3VXErRzJKcmRP?=
 =?utf-8?B?cEJVb3JIWmdSem1TeC85enJJUmZvRWJDdzhoRjlvSXVINUVOSk5IakdtTmRu?=
 =?utf-8?B?ZUVTTlNRd1dVY2gxUUJoQ0JsWFArblpSMEhjOGd1R1RveWt6b2NuWVgrMkhz?=
 =?utf-8?B?UXpGZGZTbEExQ0xwTzM3MGdqQ2duTU5yb3VNcWFHdHFSSVFYaE83dTBYT3Q2?=
 =?utf-8?B?SlVGZnkzYXNBQ2hKbnBrS1VjU01nYzAxVWFrV1FCb3MyUDdjYmRBMGZQblhz?=
 =?utf-8?B?WTFVbGZSVmdOcEF5TGwxenYyNmgvRWlvRldCenBwRzlDdlUvQzFTMnBhT0hp?=
 =?utf-8?B?U1RqQTlpTHB2blFhajVNb3R6RjZBcnFuUlJBNkxhWGRmQWxDYWwyZHl6SHJM?=
 =?utf-8?B?ZzN3U3dsM1VPTjlDZmZRVVhHWmJteW0rRllUYnQ4RERHZHVNWFNyam1HNkh2?=
 =?utf-8?B?akFzMnVQSHc3YStuSStEWVZUcWMxOGp4OTVqWm1MMyt6eHdDQ1JLK1YxZEc4?=
 =?utf-8?B?WktMVDlaZEE4S1BOS0FVMmJ4Zk1Ja0tLN1Z5TWw3UnFWQnh0QURDVTJ3VFpq?=
 =?utf-8?B?RVJpUlhLOXBhL0RxWHpGaFgvOTRocWhWNXFmYW5FeGQrVG5pVHloWXJjMms5?=
 =?utf-8?B?UVF3RCtmSDlDSVAxV0JzclFlbUNxQlBkSnUzYVRzK2hKV28wb0psazFxZ1lN?=
 =?utf-8?Q?T+OyWnBrPAZwWNxk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C1FDF27BFF85242BA5796CB404BB19F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: SUjVoFaCEkwAnH0h3wlfjCZtcsDiL4JHjg5/09HeAOHRo0nlFrsRDEd3xrpLrx4k2yCjU8HPEt5s9MXaw+RaL1QeI1zPC07b2P8OzJWbldqnFUcCPyy3S4VvpPPSBimQhK0TEztUKqj1+9fZHCaRYuBCifhv6ErIYYsZDIK/RQC/Ov7xY6YbvHEvBANB7k5xZoGWVt+HQ/SD8xZ8N1ZG5P6zuC9m6wUQfEAuWKPYZxmB0t5mFSX5jzQWgh7DuKVBi09GnvS9F9KLTt6jdQWHRVoHz962LgHjNywgf6iZBdaPzgFQ/KjRHsAExwq8ScGAaRhG9oTk9J8tok3N0b8uzg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB7079.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 984976e6-3e7d-4379-d2af-08df28f03d72
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 06:07:19.7832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xs+cOepIiS7zTf6iKDuLcrM38FELZ3AujJmsNzGH1cCSoD9c2SVHurjkGTqlbcyxeWyaqtT8dBGx7LV+GY2FxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY8PR03MB10546

T24gTW9uLCAyMDI2LTEwLTEyIGF0IDIxOjE4IC0wNzAwLCBEZXZpbiBXaXR0bWF5ZXIgd3JvdGU6
DQo+IA0KPiBBIGhlYWRzLXVwLCBzaW5jZSB0aGlzIG9uZSBpcyBvbiBtZTogbXkgZDEyYTU0YmUy
NjA0IGluIG10NzYgY2hhbmdlZA0KPiB0aGUgbGluZSB0aGlzIHBhdGNoIHJlcGxhY2VzLCBzbyBp
dCB3b24ndCBhcHBseSB0aGVyZSBvciBvbg0KPiB3aXJlbGVzcy1uZXh0IGFzIGlzLiBUaGF0IGNv
bW1pdCBtYWtlcyB0aGUgcmVzZXQgcmV0dXJuIGVhcmx5IGlmIHRoZQ0KPiBkcml2ZXIgY2FuJ3Qg
dGFrZSBvd25lcnNoaXAgYmFjay4gSWYgeW91IHdhbnQgdG8ga2VlcCB0aGF0LCBpdCB3b3VsZA0K
PiBsb29rIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gwqDCoMKgwqDCoMKgwqAgZXJyID0gX19tdDc5
MnhlX21jdV9kcnZfcG1jdHJsKGRldik7DQo+IMKgwqDCoMKgwqDCoMKgIGlmIChlcnIpDQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZXJyOw0KPiANCj4gwqDCoMKgwqDC
oMKgwqAgY2xlYXJfYml0KE1UNzZfU1RBVEVfUE0sICZtcGh5LT5zdGF0ZSk7DQo+IA0KPiBEZXZp
bg0KDQpIaSBEZXZpbiwNCg0KVGhhbmtzIGZvciB0aGUgaGVhZHMtdXAuDQp2MiB3aWxsIGJlIHJl
YmFzZWQgYW5kIGluY29ycG9yYXRlIHlvdXIgc3VnZ2VzdGVkIGNoYW5nZS4gDQoNClRoYW5rcywN
CkVhc29uDQo=
