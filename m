Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FE83DB62F
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 09:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786958596; cv=fail; b=iNNahm9J3MpHQWiuOg1/SPKKGGDhzj5v6R0jKzTLu7ZPtYq7/0/DoAyB6YUm/pkhkgtjC9xePH3cIl1aqVq5jd689ZsMNifdp4gwXszbSL1AjN3gTWHLjrehjC7yA54qKKkc2hbjRASXF58spmIFHPhHpAN+ytlqTVwQ435p0+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786958596; c=relaxed/simple;
	bh=KSsfMyNa31xPLL1ResPY6VwCrxhAsZwOMr/2nLy+o84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o692tSVRg2OJhGJwkOytPMgU6Vj8yH47FqVpc/jYnBHot51GIM6wkH6AZxs3y/OrMJlNhubfQyIwvk3pzcLPch/7p5w5iaa2ty8FIK+diYdMW2cgoFMXqkJ5y2P0N/snRZhewvCmbygXNxPJPktUhMWqdCxefADkkCGKgp5UCvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=s5BjNzxD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=R/qGqOJl; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="s5BjNzxD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="R/qGqOJl"
X-UUID: 410dc5e69a1d11f18dc8c9802ae25ab1-20260817
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=KSsfMyNa31xPLL1ResPY6VwCrxhAsZwOMr/2nLy+o84=;
	b=s5BjNzxDg9v33LIkwoG9/jsP6omErAoOeV6t6AzYVpbQHmcTonAlEqei3y+XF9s/M1uDdRsxlPqWuZnM2IbAaSNaBO85T3NEoD7MooThnBt+CGCieXh8E2CLtlMC6XWrsz0R1NlEBkbujz0LZwPpIcGcAFQYeSXdS5xGEzraLSo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:21a0d131-3b08-4805-9bf4-3760ca385323,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:9249f4f1-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 410dc5e69a1d11f18dc8c9802ae25ab1-20260817
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 861210665; Mon, 17 Aug 2026 17:23:06 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 17 Aug 2026 17:23:04 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 17 Aug 2026 17:23:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6QFd05xV11cX8ZMphrUPQiqKSnMUnqZHjVeIAROpZWZuYVVy4ZsuZCLRLmZV6+3pJ3kwjLCYFLTUSmfV049yJOkYeR7mMkYZNv9/hz0LUn0ROqJO5CUWjPaCnqqEJCU64z2tH5CdPadmfEUtIw3BiKl3yXlm0RftnFK0V9+LSJhZF3OOgWeB8wJBhdD+3caNnbbXDiDMSgwDZlwe5T/LBuKKnkBcujfjw+YSsmle7c/1AWAROsVlHo0LL6szAedgBAm2p58ic6WwMynipXmInUNbps9UAuQm3XfpbvrA7n2jJPESL6f4/hwrFDWGyiBYt5rAf2AQaThfaQWwz1gtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSsfMyNa31xPLL1ResPY6VwCrxhAsZwOMr/2nLy+o84=;
 b=DmTn+RUyKXj8chr7QKD5SOrHhvl6ZX5YTudLKhRt1D7RcQs4j5DK1IV/wjhAc0Lq57MG+o0MFCAYllPCyNTqkFPAtphHHvY6tdzmj6az5pANKrxHh6uVZiMfKru2GqPZVHVfh8Nz9QACMhLuI7RHBsy8HghH5Xa/atkF87BNGMe6nLErWe8gI/6RO8NtMAJsEMRQ0ApPkPzGnjt3EbyMd02hgn3meX9QTsZ6IgG7mZSUyG9T5o3X+UDrfWz3PB7P1NvaA2pEcNuMOCnNdJuA+veReczpcizlvR/KY4e2w48Udq3u9ci6Gigf+VVKqFT6Rux8MbnFmiz3ZUfrArN6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSsfMyNa31xPLL1ResPY6VwCrxhAsZwOMr/2nLy+o84=;
 b=R/qGqOJlS/W8nV83HtqH5HvFKLfdgTNCXjdNA1oFbjrv2RQFJSWwqtORjKVZuULCo1lBsXNTIFX6Yu9wee1JJVtHRqkTkmmzkMx3GzwSMAHgBsrI5MJuJRcPmT+eOJKs+L6gDqbdY8/cGlGXZSdv7XUshCxJ6Vuga8USiA0qgAY=
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com (2603:1096:820:d5::5)
 by TYZPR03MB8439.apcprd03.prod.outlook.com (2603:1096:405:73::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 09:23:01 +0000
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af]) by KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af%3]) with mapi id 15.21.0315.014; Mon, 17 Aug 2026
 09:23:01 +0000
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
	=?utf-8?B?RGVyZW4gV3UgKOatpuW+t+S7gSk=?= <Deren.Wu@mediatek.com>,
	=?utf-8?B?SkIgVHNhaSAo6JSh5b+X5b2sKQ==?= <Jb.Tsai@mediatek.com>
Subject: Re: [PATCH v1] wifi: mt76: mt792x: fix memory leak in USB TX path
Thread-Topic: [PATCH v1] wifi: mt76: mt792x: fix memory leak in USB TX path
Thread-Index: AQHdJK1heE8l2MUEok2UUq3cXQH8oLaRnLMAgAiRggCAB1uJAIAAgOUA
Date: Mon, 17 Aug 2026 09:23:00 +0000
Message-ID: <cc88df518b020bf41685861a28d4e2c81b08f8ad.camel@mediatek.com>
References: <20260805073812.1433126-1-eason.lai@mediatek.com>
	 <20260806222922.30384-1-lucid_duck@justthetip.ca>
	 <af39515e4277cb0c8079ed172ac8e0fccc106063.camel@mediatek.com>
	 <20260817014140.68399-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260817014140.68399-1-lucid_duck@justthetip.ca>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB7079:EE_|TYZPR03MB8439:EE_
x-ms-office365-filtering-correlation-id: 0720ec2b-fdf5-4ad6-13de-08defc412253
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info: XmLZrTsPOLYCmoA7GHB/Y+Cxx8qM52SMk75ElR3/JE8yNiFWZMZLZ2W7hEl8mzpX4OyvDuNpkEaVDIq6yYM39yv7YEzV5XWtYsXGXMh6D9TwqFQUSUi62+PjYFie5UiUiGGg1xr0tiK6JeVZURcyam/85RB2HQbIC85C8Ri3neBm1Z9mKdkK2ND/2SsOCzmgLBgfYKBCf2ti8xls+UifgOBaJALKi8V0apGOUmJLxCeB6nP2aiYZcNudu7ATIFNotyAsBDVrbm1kgErgcXPjGxp7gDErVgCgkxsUagpyYvZJMe7s2kc4YNEDqXW7XomNK+1qLFmcmse1G3jd+FeLO0kvs3CbGcmDp3RoFmNlhYOzMjyo1jwDqxE0t6AkEo/S665I5CtEkMjcQZE3PbDMQlC7BXrdVT8judZncJrLy5oxJAlr7FlMkG+V5mMPAKhVWGnry0J/glrMWFoVHOZAaYfRNYV4mrcdNxHeeYYJj+l0FoN5D88RTHnKt2iM2kwiNBwrrCyRdK1QRolmKEZie38i7SBzpGjavRtw08H9IBIrAOpd8kuKpTe4XJlwYwCRxR2Nw6P/tVzd3r1PHUYY4QCZoLveZ1NaYJjThNyXq9shOTnEPh1fS1htbM9NCmOAYK37NLm59dt4jRql4gxGL7wv1Qd8IUTHuqkYwFudvx520MOjf6yk4ub4k4hFtkN1Hfw+gSuJe/r2jN6RHOSDafQkN+Aut1NgMdDUFvwSmDs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB7079.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THNjcDkxUk85OG1JQzRETm56aFRtOXNiSzVRWTZOVFVhdzRPT1hwN1BVNmEx?=
 =?utf-8?B?d056enJWUGVWM1Vwdk1NWlNpYjZzN1lVM1RxemJHU3l5NEdRSEtBcU9GUmli?=
 =?utf-8?B?S1ZORFUvVHRzQityaDJWSzlMRldFbG85MWpKeDNJMVoxaVFQbHltb09NaVdk?=
 =?utf-8?B?UW9kZ2F4TDdsdXVjZjM1RGtOYVY3VFVIV05vZVNTUGU0cVlEbWZWTGFzMXlL?=
 =?utf-8?B?R0RRSmRpYU9BYndFNFJVZmhhNEFINzRSc1lsSTE4TG0yK2dWdTlVUDBDbWY4?=
 =?utf-8?B?WDlZNUREWW1jbUZQYkR3cUlMSDArc0o1bDYrdVR1QnFxa1V0dmpmcDVLSy84?=
 =?utf-8?B?NDRINWxpZE5lYkNPMTVHY2JjRVByeXk5OXUrTUVSWFIyL3hnWVhleExXa0wx?=
 =?utf-8?B?N1YwTGRtMGlNeGVvd05qcklPNXI1QzlxVzJyTjRoNThvL3RaVHhkWUxRUmFy?=
 =?utf-8?B?MENnNlJ0QWtQUldlUTZoRjBOUGZydm5KS05pdHpWQ2xpRS9MbEVHK25iem0v?=
 =?utf-8?B?NjVuaitkM3VFWjVoWkRLYkZPU3BaQ0JXVW9XS0FpTGlSZy9SSzJqbStXZEZ1?=
 =?utf-8?B?RFJIYUZTUzBkR3FsTTNwWXdKWTEzNFo0eGpHS2s2V0xwc0Rpa29CREovNXZP?=
 =?utf-8?B?RUhyaGRjbThTYVdSMGRqQTZzMmxCZW1CS1VqWVVDb0VLa3RDT21PNnU1Rkho?=
 =?utf-8?B?RDFEbis4a25GT2FIQm8xbnVQMGFRN285ZVIycEFVWTZPdEtwcFhBQ1dQcDla?=
 =?utf-8?B?NXo4WWR3dk5oVlUyOWk4eFR5ZURzMWlmK3huY3dwUUFJTVl0dGFJQ3pnMHV4?=
 =?utf-8?B?Nm14VXA3Z0p5ditmdTRvbUF2MWl2ZU9iVlFCOGh2aS95OS92cnhka2xkeDZq?=
 =?utf-8?B?ZGtvU08wZ1p1ZzhXWVpRRDdmb25hQWo0ZXgwUmJRVGJyQXNTeVcxY2pWVWVJ?=
 =?utf-8?B?WjYvVTdOUjR6eEd1ZEQzWGRzMzh2ejNtOHE1ZU5LUnJZSGtlQWszM3VzdnJR?=
 =?utf-8?B?WlVYUWxvZTB4SjR4MWtBaDhpZ2R3ZmFVOTJyVndBOVNrQXhBT2tuaEttVnJ3?=
 =?utf-8?B?NndscGdSVjM4dUUwMmFBUHZ2V1JKeGVNMkV3MlgvWDdDWEZTRHorTk1Fdmt3?=
 =?utf-8?B?TWFadUJJL1RyK1k5a2RQdzFzTE5MYk5SdzBVWFJGRTl0b1Z3bUFidWZWV3do?=
 =?utf-8?B?dFd2UHdMUGoxVGFVUG1KR2N3MWZ5VTJVSUh3SDZ6M3VtUGZmRTlTeGNLWkVC?=
 =?utf-8?B?MGViUkpITWpMTmo3Q1NaYUJpaGFDQ1ZWVXhSUWpibUI4bVVubERCTytDTDhk?=
 =?utf-8?B?OG1IeVJCK3R6YXozU0JjcmZYb1VpM1FqTVJ0SHdsVk9DejUvdituSzg4M2hD?=
 =?utf-8?B?UXMxMzIvWUxTQndnbWozc1F4NGkxcmFXM3V4L0wxUkdndVhyK1ZDWW9DSVpF?=
 =?utf-8?B?UkhUdURvQmhEZlZLZFltK1RWRHh6b29UUG1jRHVjZWVqVmI1NFZpVzhHTy9r?=
 =?utf-8?B?R1V3TjgzVzUxUkh6OURScGxsK1hLNzlXUFg2a1Q1bHdodWErVE5oSTl5R29C?=
 =?utf-8?B?cGwyaVdpWXFWSFFvdUJPU2Z5NUhCU0srUzRHb2thOVNoZ25WTDF0ZUNVUzdD?=
 =?utf-8?B?SVhDYnIxcTNHanBaZUR3Y2RLdGcyalpUcXVzT2ttQUhXSnFMRVVsQnNOSHMx?=
 =?utf-8?B?d0Z3bElPeUxMb3VDcWFmMTdOOGRvcTlZbGc2cm1sS0V3Ty9VQ2lVRytTSngy?=
 =?utf-8?B?QTY1MW5jVjUxU2QxTmdOby93U0hYYnNLRFQ3eFB4Z0JuRDhwK0tJdmZkNUsv?=
 =?utf-8?B?Vk5MdnNxVjc2dlpxY2phQUxWVDIxTFE2Ylk1RmRMZ2s2M3liTmxYeDM0NWtV?=
 =?utf-8?B?K2VadmNiMk9zVWErMDQ3MjhqNGVQTzdWMitCQTVJVTYwWmxOZmUxWE56ZDg4?=
 =?utf-8?B?Zzl1SEhETjFYZ21PNHNQcHVxSW1aQ1dZbXJSOEc2WGczekFTd2o4QXkvQml3?=
 =?utf-8?B?eFZtYXAzZG81Wkk5QlhySXlleUZORElDUklkblRlSVp1dHM4Mkw5WDlRdmUz?=
 =?utf-8?B?aHpvZEYyeGJWQmZrVGlaZWw1d244ZWxQemh5NDQybGNDVEhmdFdsd0NzTi9m?=
 =?utf-8?B?SFBPYlF5RXJKZWt1TDloUWlmenlMN1lkZnBwbnhwMWZGWDdCZ0krTHFnVzRq?=
 =?utf-8?B?UXlmVE9Hb0VRUG8xaTlVQm9ValRveEpBVWRBWEhiZDJjdWtsZUtGNjZaQ3J6?=
 =?utf-8?B?S2hMV2Z2OE84L2FvcXZabWtUMjdlUGlJcExJUTFSK1FPNFppVnlYZkV5b3F1?=
 =?utf-8?B?Y0V0b2ozKzBtdGpFMTFBNTF6ZnI4YVN0d1dnY21obGIybElncTIzQVBBc2pS?=
 =?utf-8?Q?+ejMENfRhfnE+0uo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD36560CF888734F9D6BE641665D13B0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: lp4YXf2VclvfCVfGrWpF5qNhVh/xU7NBdMDGPe3Hc9gYc7FEnFw3SuJBJeMTmclOGSmkCC1RpC2QhV1zro4MzvJxk1Vj/N1YAVeElszIyf3CQcWaXlPoJjEQw70tIvgwe5/wLnWr8XjRlC0Cc9zLBU7nxMGGjPPwlfwqJz8m9CcYdFM9bQjKAEzcpHEPTrWcI6f39gcbvHiwJiB3ejaXTbY0tpsSyWum9/MsGuClOx9ORh6UqmOOECvPvbRXt8bveOeYNJbRXoQYW6tqDxJFAzl/tgW/Dn8bH4E2DcRAkc9EnwGxeO5TCeCFeZjEHR4BZaXIR1SSgot1z7gKg9Ewpg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB7079.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0720ec2b-fdf5-4ad6-13de-08defc412253
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2026 09:23:01.1750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXzq0z/JqMEyH+UMwjd3GLPnrHvl3alO8p+IUN2gRMnQb1oo89Fr4ABRtp2Vv2ly5gvDerpYMddgQkfyIpP5jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8439

T24gU3VuLCAyMDI2LTA4LTE2IGF0IDE4OjQxIC0wNzAwLCBEZXZpbiBXaXR0bWF5ZXIgd3JvdGU6
DQo+IA0KPiBtdDc2X3NrYl9hZGp1c3RfcGFkKCkgY2FsbHMgc2tiX3BhZCgpLCB3aGljaCBmcmVl
cyB0aGUgc2tiIG9uDQo+IGZhaWx1cmUsIGFuZA0KPiB0b2RheSBtdDc2dV90eF9xdWV1ZV9za2Io
KSBjb3JyZWN0bHkgcmV0dXJucyB3aXRob3V0IHRvdWNoaW5nIGl0Lg0KPiBSb3V0aW5nIHRoYXQN
Cj4gZXhpdCB0byBlcnJfZnJlZV9za2I6IGZyZWVzIGl0IGEgc2Vjb25kIHRpbWUuIFNwZWNpYWwg
Y2FzaW5nIGRvZXMgbm90DQo+IGhlbHAsDQo+IHNpbmNlIHNrYl9jb3dfaGVhZCgpIG9uIHRoZSBz
YW1lIGV4aXQgYWxzbyByZXR1cm5zIC1FTk9NRU0gYW5kIGlzDQo+IHNhZmUuDQo+IA0KPiBUaGUg
cHJlcmVxdWlzaXRlLCBpbiBtdDc2X3NrYl9hZGp1c3RfcGFkKCk6DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoCAtwqDCoMKgwqDCoMKgIGlmIChza2JfcGFkKGxhc3QsIHBhZCkpDQo+IMKgwqDCoMKgwqDC
oMKgICvCoMKgwqDCoMKgwqAgaWYgKF9fc2tiX3BhZChsYXN0LCBwYWQsIGZhbHNlKSkNCj4gDQo+
IEl0IHJlYWNoZXMgbXQ3OTI1IGFuZCBTRElPIHRvbywgc28gcHJvYmFibHkgaXRzIG93biBwYXRj
aCBhaGVhZCBvZg0KPiB5b3Vycy4NCj4gDQoNCkkgaGF2ZSBzdWJtaXR0ZWQgYW5vdGhlciBjb21t
aXQgdG8gYWRkcmVzcyB0aGUgVUFGIGlzc3VlIGluDQptdDc2X3NrYl9hZGp1c3RfcGFkKCkNCmh0
dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC13aXJlbGVzcy9wYXRjaC8y
MDI2MDgxNzA5MDAyOS4xNjc1NTItMS1lYXNvbi5sYWlAbWVkaWF0ZWsuY29tLw0KDQo+IFdvcnRo
IGZsYWdnaW5nIGFzIHdlbGw6IG10NzZzX3R4X3F1ZXVlX3NrYiBpcyBub3QgYSBtb2RlbCBoZXJl
LCBpdA0KPiBoYXMgdGhlIHNhbWUNCj4gdHdvIGV4aXRzIGFuZCB0aGUgc2FtZSBtaXNzaW5nIGZy
ZWUuDQo+IA0KPiBJIGhhdmUgbXQ3OTIxdSBoZXJlIGlmIHlvdSB3YW50IGEgdjIgdGVzdGVkLg0K
PiANCj4gRGV2aW4NCg0KSWYgeW91IGhhdmUgdGltZSwgcGxlYXNlIGhlbHAgdGVzdCB0aGUgdjIg
b24gbXQ3OTIxdS4NCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC13
aXJlbGVzcy9wYXRjaC8yMDI2MDgxNzA5MDE1Ny4xNjgwODktMS1lYXNvbi5sYWlAbWVkaWF0ZWsu
Y29tLw0KDQpUaGFua3MsDQpFYXNvbg0KDQo=
