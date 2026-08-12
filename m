Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C4402444
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786526435; cv=fail; b=frI0ksWx9n2kGeNc8G/MmoU6BeIMP/rtlnboriVzFyDupTPeux9xla2iYeJQOqivFmQslwRuHRQ0usWCMtZeuLz14YCmQxbg5GTBAO3tSsBqG/TJOPMxjjGJZ5+CQyFntAr56SgJF5Donz/6lRDt3YbFMBSZ74Hqr6f81UeR3Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786526435; c=relaxed/simple;
	bh=xlXy+u4do+B/l7koLlVJvROzvXj+n7eX0m1H25h5dlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iGhkBmFpdQhhMgNFVAjytd0EMIfFFDtCdIkwpnOAUSEOxnq7nskmrfh47TTVjZL6oYsVfpgZgPT24Oyc1Z98gPg+3MsXPEkdQI0m6HK5LHoaAOsySg+pOaEy/qaCVOoCzyLPofHd3R1Yh1zYVYvIumKJZCHRg4EY9Ux/8f+CGoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tGeKbLLX; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=aaVfAop/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tGeKbLLX";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="aaVfAop/"
X-UUID: 09bfd5bc962f11f1b1788b6acf885367-20260812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xlXy+u4do+B/l7koLlVJvROzvXj+n7eX0m1H25h5dlg=;
	b=tGeKbLLXhZ9W7wnxTs04VxJ7ow79UPwtgxxrazYPJWaqYoKDsjQGYtGPZeUSYw7xavUQbCDYuLT9NGn2OUxZ8iKfK2s2TdgQmTgePTBtU1unF03DCosQdMIx9NSbxi30MHVa2F5rvdYFQFxxE+HyktL2BNGg586+ryjd/OfsUJA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5a295479-06b7-4d75-a57a-c93404fba226,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:90bd889d-c4cf-4797-9cb2-7c4736dae244,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 09bfd5bc962f11f1b1788b6acf885367-20260812
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 916035625; Wed, 12 Aug 2026 17:20:19 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 12 Aug 2026 17:20:18 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 12 Aug 2026 17:20:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKMJFYK6WBW4q6ZqFyiJbeH6EbjueGXlEeeemHogBHegJvoJLim6UrYkNYnJJQmd0xWQmfFhToijK9/G2mYFpF6+QcjK3t1rlCLTkFzD4F7dX63vTQlTEiDUbL6SJdV2K+zAs7xswLDa52YCPISj4GMiXr1JQULw/C8zl0yBmvuX4tqmqSZgH87K4VPUiHHlhMg5IWQsAdLskFBIKI5Hd5jxaeOSySBmHnKC2waOF/+9kkU1KSTwQB9Lv7iq9HbjFN3DA8OPpWBoMZIgCDG3dZ3X0Y6/AkcwzHJJ/uRtwcXyRKzAHTNDJwRRWA2OhOPJ7YaL05t6k/bC+pqGYyW2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlXy+u4do+B/l7koLlVJvROzvXj+n7eX0m1H25h5dlg=;
 b=ku81dWJibJlpDGfO+zYyh+O5vf+L6J2Gl+nUO7xkAyynWXGoSW/PSCC3akc1F/SNL0LxWORdLZOpES2nusOZOa66iwakKz014D8M2+QR5CxoSK7Gv6nZ8E8jpnJu/qrnkBeGp5zezvAzv5J88Bf5UEUREvNGFyB+P9lXZxZyLurIZlsqwLfFf7dR9TXIghv7tFhr9IZzUHG9pkpVk6vUK5k/jIxGIO+WiKXHwr1+kcnR6N6ael8uHH6lwdsKqcLokb3e6A81bk62HObJla6f0lsm+u+xnTQ7bP8wmqhFJmoGjRxyNScZ7SQTNe+3XZGQz+mBvXMt+nvAny8xQWUIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlXy+u4do+B/l7koLlVJvROzvXj+n7eX0m1H25h5dlg=;
 b=aaVfAop/iUvLdkva+M6lCSwb63anvZNbiBnFhaTvW+r0BrmgBGPaanIp5pmohrV6tIBI/ScYYqxykQjztPzXRBH9gJx+pPKm69Tig6R53fs0KVr9uqbuuVA6oBdouHoQ8UkqXaqErLOreEPcqxooJ5n/htttlf+MsAD59ADBzQc=
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com (2603:1096:820:d5::5)
 by TYSPR03MB7761.apcprd03.prod.outlook.com (2603:1096:400:40e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Wed, 12 Aug
 2026 09:20:15 +0000
Received: from KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af]) by KL1PR03MB7079.apcprd03.prod.outlook.com
 ([fe80::9bd3:f66a:efd4:f6af%6]) with mapi id 15.21.0292.024; Wed, 12 Aug 2026
 09:20:15 +0000
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
Thread-Index: AQHdJK1heE8l2MUEok2UUq3cXQH8oLaRnLMAgAiRggA=
Date: Wed, 12 Aug 2026 09:20:15 +0000
Message-ID: <af39515e4277cb0c8079ed172ac8e0fccc106063.camel@mediatek.com>
References: <20260805073812.1433126-1-eason.lai@mediatek.com>
	 <20260806222922.30384-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260806222922.30384-1-lucid_duck@justthetip.ca>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB7079:EE_|TYSPR03MB7761:EE_
x-ms-office365-filtering-correlation-id: b9a2cb18-708b-4d87-4877-08def852eb7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|56012099006|5023799004|11063799006|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info: gdso4PCE7czAe+V7QjmqoZoqyru02TlHUjAFMnRtOqKAx6dcJwQLpL+Jtc3h2pYwLjj6w8a8AVnxzU7fIpQIpt9bU31/i90bYmRvxS0Q3IpXy/uq13iBMLJo3atGIt9dRHSnCQhZnhoCHmfKFmZ2suJvfz5ZbOaG4rHBGZ0JY7dpMFcilT3WTmZSwwJ412ttblJTfWr9+X/zOoLjh6MRH7ZsPZ0VbJJGW8TjhlM3hlzS9CT1o5GxnkIudZHwU8lt9bD7JOmNBRsQpUfv5hnsYCjpcrDx2ilIRDba8M2fX0W2TT/h+CMKNHVaXqD+gOTA6yrxI+s9lYFPTlGZxQuPOau2ij86HV0g69BInulWXlvkFsgwM85VWgfepdrZJ8/8MktYxM4tlVuKnFq6LyTgXUKe9Hst/5L3/Ew3nqVi0sO+lxP9U01RRGJbjgiSDpAIlq9hWryr6QWpRoIT9tFm00lfU/TzUkqSFmAK82klhgCs4euPHSkejICWRixjWu22FiNd91QLIWEy547NSxRFcSAgtuL5XFI5SQU9+X0J4FvqxBLtfEOiXTRUOnO71OA05tVRmIhR73pvF7EQzD7tOgQL1jJw7byDcKnimexK3Ac5V2UvYpzLcy2ju6uH04SmF6dC1URxs3D8wpNuzCZKoxJHemYSv6P/UVWQCIlbK0PXyRm6UJpJtAiIQoi8S7ysrZCu3kkGTdHedZLCrdajaiafBtSRPLKC7pUb+H+gBSg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB7079.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkpGSFRVZmhpa1lDYkQrdjJXVUxvYjNIYmxiZHBJWFZVN1FXWlZMVmNoeTBW?=
 =?utf-8?B?RzhhM2JWNmUvMm5zdFlKRmwxSlN1di82Zml1Z01Tc0JFNU1RdFhCS3FDcEl5?=
 =?utf-8?B?dEIwN0ZyNHhIVDd6SXZxYjBsNndLRlVXTTlWSldyUFRWMUJrbEdRU0FPa0xS?=
 =?utf-8?B?Y3F2ZU1Wb3d6K3kweDB6M3JwQ0VybWdsOHhhTE85dTZHKzF5TXR4N1ZYeTk2?=
 =?utf-8?B?bDJVb3FJRldpQ3lFMUdiN0FHRzhzY3dJNnhXbjJqVENnYmJGd0dVYy9qL0VX?=
 =?utf-8?B?TVltMWd5T0VIZ1k4bmgrYUU3QndXbXIzYmUxRFg0QnRLbFRCYVVrTExMeDVN?=
 =?utf-8?B?RXRnMm15QlZVQ1FKL1g5N3ZEcERLN1ZQWmgzMk1xRG1VaFg2cXpxMEJSRXJ3?=
 =?utf-8?B?c2hSRmtuRWg0SThXTlFhN1BnMmg0ZmVlQ05LNTcwbjZtY2FUNytVVStueHds?=
 =?utf-8?B?Q3ZtaEQ0YWVXWm9aMTNEZ1E2ditvVHlGSjh5Y2VrbTdtdjU2MXNCb0VhaU9S?=
 =?utf-8?B?MjNZejhQVUp5YlBYamFadnRiWWg0UVF3eVVnUktRMVJuQW81SmV4SUJRcDBK?=
 =?utf-8?B?bTl6am44VWtmUXJ3K29EZCtOTGxvMjFZMFdvdnU3T2ZLTFRmeWZ2UkdldzNk?=
 =?utf-8?B?T1hlUG9IRGdPTlBKcFovVFRWVkZrUlpFNzZ2THVibDU2YWRaMmpYQ1o1ODBR?=
 =?utf-8?B?RjdMRG05ZzdFblVtNE5TU2grZzBiSUt5REpVeklvNkFpVU9lQmpXY1pWbTM3?=
 =?utf-8?B?U00wU2ozLy9lS09VWGQxQ2kvVU9tS3kwNWJsY0RvSWZDTmdYWmEyL2p2M01D?=
 =?utf-8?B?eElSQVB6ZS9hZEVoOEM3djM1eEJyVGo0RWkyK2ZzS2diWWx5REdTZGpSaHFn?=
 =?utf-8?B?YjZULzI3aW80TG9pZ3hna200QjhEdDRFZ0hBdFQ4SE10ekU2UkhmcCtkQkVu?=
 =?utf-8?B?VnJpM2ZrUmcyM3FPVnl6MUllL2NjNGs0VVBzdkRHMHJrNVlNTkhweDE0Visv?=
 =?utf-8?B?WkpUM1pEcE5KRVZhdHViWTNJTGRWRjdTWjJ2ZjMzbHRETUZObWRGWHRzTFFm?=
 =?utf-8?B?NjR3S0hESXEwVFBRK2N2TlE3NTg5Q3QvenY0WlM5TXpWN3pWNVI1MDJkRmgx?=
 =?utf-8?B?NE9aRzBITjFRVEt2L1U3Qmt0QkMwTk5EWmlrWG1RcVFBbUVRNlZJT0tldDFQ?=
 =?utf-8?B?U1A5bGVKNFFoZUk5MzlkVlN3ZFJPWFFiTFBrNnJmOFZhckdZaW1JTTNIb3d5?=
 =?utf-8?B?TVBXdkFtQjNOTmpIWElSWFlCMGdidHJWZ01QVzhuM042NzY1eWNFWW85SnFx?=
 =?utf-8?B?N1ZNeXZ5NFBZNmREQWFsQ1hML1ZBQXhEeUdRTDc3Sy9ZdnhkOHM5Y1BOdndJ?=
 =?utf-8?B?UnI2bTBJd3kzQjFVa1VRZUVnRng1bEV2RjRZSDRDOXlEeUl3R09uNEJNZTVk?=
 =?utf-8?B?ekVya2FhMFdwRGNNZDBvWlFxbHpxdlp0T2hxRmZ4OEV5REJEVjB0QlNjWDNB?=
 =?utf-8?B?eUJjRGo2b3ZITGNNZjFOUWJIaHJuVVVmRDBmdWZCNzRYNXF3dDNtd01NdkF4?=
 =?utf-8?B?VWcwQlY3cFR1N0l2UWd1bWZRZDZYNTd5Z0FOMDM4d0hSWE9vWGNDOUE3S1pz?=
 =?utf-8?B?QVVHM1oxYjFvcmMvOC9BNUFWUDB2a2l0cWFtdVNQSnJXWFZwZGdBMXFweCsz?=
 =?utf-8?B?ODB0RlUvL0RSLzB4WUw0L0FNTGk4SG04Lzl5azRtajA4TTlRQ0RRTDdSWmkz?=
 =?utf-8?B?VnFZTHVoQlg2MDl3YXhHcUhnNWIvWitMQTREMzdzOVpLc09jLzRSVHpWUTJp?=
 =?utf-8?B?QVJzbStjVXhGcE5Ga2NTM2llNFBtWmJxeUxIbS9EUTdKa21pWnNxTTZvOURX?=
 =?utf-8?B?TmJyQ2Z4YWl2MmhGM3l1TlYzbHloTE5LUGRQcVF4djA3TjJ4WmY1bk42enU2?=
 =?utf-8?B?a0E3ZmF3VGxFNVRuekZqSk9TWmRVSCt2aHJtN1lVeWRLczdIbzN3ZWFlbmZ4?=
 =?utf-8?B?SWUrdmhlMWExOVJxYUFzWFVmdkpPMlkxTzRQMmlBQ0lmcGpDVU93YW9oRU5J?=
 =?utf-8?B?czBiSEhLMitCLzdNa05URCtadVM5Y09NYm04MkxMMlJyV1p6blFxdEhkM1ky?=
 =?utf-8?B?TFcwM2xya2JXNCtHcnhXRVhwYTdMdFUvYjdMNEkvdUppRTBVMnVub3VjSkR1?=
 =?utf-8?B?L2Z4YmJMb3FJa3ZTUjYwd1owcjlLa2hZM2NJOEpkQ3dyZSsrV3VVeS9zaXRv?=
 =?utf-8?B?MVpqM1VocTgyZ05raFFIT2VnMU11dVJadTRBdm10dWJLMUxjR1dKWDRubXFZ?=
 =?utf-8?B?Zjd5VnVkYXcxMmpMYmsxQUlHVjNyZkthUE9Wbit6WmFVdmxDZHFjb3lrdVNE?=
 =?utf-8?Q?W1b1nYHMrj9ixoXM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D781CFD130D0C047A6B0591D4CCBAE9F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZOERb/cLy6ybv2KQOO1EwlAIN7QBrkwOP3DIFus583w8I5FdfRg1CZ191uGRlEbco9hzqKJLCuzeHXuGOsax0EjWYZxqnNDoSOkZ49KuxsYCzdjwr0FLtC//lSoULcdYjD0bPRmoqjCNByBxVaGEqKm0nEChvj1doksvG+Zz7CxzhtIlAqNHyA8M8YwU4TuV34a8qojKlqXzVmvttBWBwh8Lvu80Q3OeneRPXb3E4zdJdRy4liUJq3FOPoA6J/mezI++gg908/I9ZJW4HIp+R6b2bqxRIXYbsW5ByEFg+d1U9QRdvZdFBJq7hBQIVjp65DYWRy6XuHsjO7k04Y5R2Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB7079.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a2cb18-708b-4d87-4877-08def852eb7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2026 09:20:15.4596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7H6fLb3/pBcc8N5oBS/Rm0vnXgtHI1hUemn7uWpxMzdRUWEdDEsEFakRqscp2xd0aH77oAMxqdgtBaB/17ZJAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7761

T24gVGh1LCAyMDI2LTA4LTA2IGF0IDE1OjI5IC0wNzAwLCBEZXZpbiBXaXR0bWF5ZXIgd3JvdGU6
DQo+IFRoZSBzZWNvbmQgb25lIEkgdGhpbmsgaXMgYSBwcm9ibGVtLiBCeSB0aGVuIHR4X3ByZXBh
cmVfc2tiIGhhcw0KPiBzdWNjZWVkZWQsIHNvDQo+IHRoZSBza2IgY2FuIGFscmVhZHkgYmUgaW4g
d2NpZC0+cGt0aWQsIGFuZCBub3RoaW5nIHRha2VzIGl0IG91dA0KPiBiZWZvcmUgdGhlDQo+IGZy
ZWUuIG10NzZfdHhfc3RhdHVzX3NrYl9nZXQgd2Fsa3MgdGhhdCBpZHIgb24gZXZlcnkgdHggc3Rh
dHVzIGV2ZW50DQo+IGFuZCByZWFkcw0KPiB0aGUgY2Igb2ZmIGVhY2ggZW50cnksIHNvIHRoaXMg
bG9va3MgbGlrZSBpdCB0dXJucyB0aGUgbGVhayBpbnRvIGENCj4gdXNlLWFmdGVyLWZyZWUuIG10
NzkyNSBhc2tzIGZvciB0eCBzdGF0dXMgZXZlcnkgcXVhcnRlciBzZWNvbmQgcGVyDQo+IHN0YXRp
b24sIHNvDQo+IHRoZXJlIGlzIHVzdWFsbHkgYW4gZW50cnkgdGhlcmUuDQo+IA0KPiBtdDc2X3R4
X2NvbXBsZXRlX3NrYiB3b3VsZCBjb3ZlciBpdCBpbnN0ZWFkLiBJdCBtYXJrcyB0aGUgc2tiDQo+
IERNQV9ET05FIGFuZA0KPiBsZWF2ZXMgaXQgaW4gdGhlIGlkciBmb3IgdGhlIGV4aXN0aW5nIHRp
bWVvdXQgdG8gcmVhcC4NCg0KWWVzLCB5b3UgYXJlIHJpZ2h0LiBUaGUgc2Vjb25kIGh1bmsgd2ls
bCBjYXVzZSBhIHVzZS1hZnRlci1mcmVlLg0KSSB3aWxsIHVzZSBtdDc2X3R4X2NvbXBsZXRlX3Nr
YigpIGluc3RlYWQgb2YgZnJlZWluZyB0aGUgU0tCIGRpcmVjdGx5DQppbiB2Mi4NCg0KVGhhbmtz
LA0KRWFzb24NCg==
