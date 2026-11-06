Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.169.117
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793953180;
	b=CA+tFgTkFCrfY9hsPWQNtI33/ZgVuiAqsSkC4FLVZyDs8nOiiU/BipcXL/dHp4J6+FTd
	 hcAgMuqOK8KbmnqVVzzw3QITbmZ1jkw5XSCVpHsdZsV8Kbw0BssQ7Ve+uHDasXDg1GwDd
	 C1O81tXlZxmNsO6pJMblcZ0OCitr+0QQ8Xt9v0oOwyiaPkQbxQNfr8R4h/XQo0h4dc0KI
	 YfGmcXO1OnlKrEmXeZVoc6ZjNTHxNT0+RKcnbRV22THvgxuz8bTQaCaVhWwvVqXiFp3j8
	 bx2sYF44J5DS2QNna3dwvUZocKf89jx+6b2Y8zPm/AJGrraD+4FCgk3wrnYoWEFJzBw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953180;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Ju132GoRhEqaz5VJfU/BcOon/vUNXrnAheJ77I63aNQ=;
	b=IuS1J+iJmGGqzC15wK2oCQ3toAeZUvrMa9PRZ8wMQIUBhTfnWrq/28NBYoRfOyQGf0X8
	 dQ2Lb5BNWVYof3Ra/iue8zjlVGcJaVDkybcBoZq3pSTg8DxAAH1EOaTDbCrjzcoBhtOqT
	 lVkroncKomi4w5cHkXEU79bDF5+t6nuHp1RTkf8bGAI/yBv/GoUiwtYlofmj6O1JNZi8z
	 mgBdjdCYqW+H2NYpBlyZV/DEFFYcuKUZ1tuAup7IFl0IqFGL3ipjPQaSablIpprqjImfu
	 K1x8oWivbKmSyZbq4qJ9SvOmmSn+YVIjiIZ7n37AFtEkFZ2WNuv4R1VtONXL6/Pm/Ng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=sql-ag.de;
	spf=pass smtp.mailfrom=sql-ag.de;
	dkim=pass header.d=sql-ag.de header.i=@sql-ag.de header.a=rsa-sha256 header.s=selector2 header.b=dX+Ndbc1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.169.117
Received: from BEUP281CU002.outbound.protection.outlook.com (mail-germanynorthazon11020117.outbound.protection.outlook.com [52.101.169.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037B4606A32C
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 037B4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sql-ag.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sql-ag.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sql-ag.de header.i=@sql-ag.de header.a=rsa-sha256 header.s=selector2 header.b=dX+Ndbc1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gaLxZpWvN9AOflFY4mu5xWD+qIZC0d2DP863/R2uTZFbZ5EYtBZ9LUPu8T2WDckFwYz6Tspz76hEurSKz+3whyH0KZ7Org0Z9b3BChLznd5xOgaOV9VQodeXCaav64SRdWMJ0/HET8IiR30gVApFiuE5acdrE0aNWITX8h52I59veiFbLTcdTlNTPAKlUofKr50drGlfpWcu83PyLAoIxi4pYtnvlUXkrsSz4vMKFezXTinIS6LM1Z8iEiAHAuJdFAJWvBvLfOwKfaEg9PRpHEqIJGpcbgloyccDnwwYUnU8UgrGS4Mi+FyTYm343aLvPmyOH1smNBHw3EQUXnfCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju132GoRhEqaz5VJfU/BcOon/vUNXrnAheJ77I63aNQ=;
 b=Yl9IphUjJ8THqz67+umu+MvOfWhAmIKtdpqUlna70/Ixfd5wXBqR6lpOJxmfTiEvH67qQjDPlskBXTJiEoJrDniW8iVhwZqokabh+9Ac8XXZ6Ye5MwsimN8jRmev4ZJbyGrSfbuZe5GyEu+vdCCSZSgTPvlSxoWOsEeDPPdoM9qWwyoptyVey2A4wvFqLUaSXr/KoKeBmmzwbW6VMUCc33XkU5gF20zKMjGFruVVsmGhd+pcwBzAEiQjp5CkD8/vvd/d9JAeJYt3gskEMLqVrwWV9mTfL/X6VMCh47/2g69oMv369wa798S+gDOaDVm27eAm/c+XmYnuP/Dnxn4Z7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sql-ag.de; dmarc=pass action=none header.from=sql-ag.de;
 dkim=pass header.d=sql-ag.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sql-ag.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju132GoRhEqaz5VJfU/BcOon/vUNXrnAheJ77I63aNQ=;
 b=dX+Ndbc1BdBdpKeGsSaSHHb5dVnn9hoWhrwDA9BX5ynWBmA6BTqAak9/e/sjUcJIox9bT+Rclk0ROdzRrPDQPZ/d9id5UOJemvLUbGLEIaHppCjkJy5aNL5zb479fQdgr+aC7eK4f1vIv0wPw28UNpwXnpBLuS77k1Uvs4nNe6Jf849ItwZi8vWTi1ufjymi7UNWYYVOxGXJV6rNpYStJYSqvm7pYdE8QCyqJgNZdZtcqxH1kGIgLvptZZC6RCewKLJQ6TLNIhm//m/rF5xuuGviw+AQKWay6PqJo5ZkGxVk8H7zAkhraVmQsFnvhITLdyD9G6RBs8XPSLbPasEiNA==
Received: from FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c3::15)
 by FR7P281MB760042.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:404::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 08:19:33 +0000
Received: from FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM
 ([fe80::38d9:66ad:9bc5:5d6f]) by FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM
 ([fe80::38d9:66ad:9bc5:5d6f%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 08:19:33 +0000
From: Sven Besser <sven.besser@sql-ag.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>, Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
CC: Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>, Ming Yen Hsieh
	<mingyen.hsieh@mediatek.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>
Subject: AW: [PATCH wireless] wifi: mt76: mt7925: add the common scan IEs back
 to probe requests
Thread-Topic: [PATCH wireless] wifi: mt76: mt7925: add the common scan IEs
 back to probe requests
Thread-Index: AQHdav2GVXOTIAgFwUeRfecjGiCMV7cguMti
Date: Fri, 6 Nov 2026 08:19:33 +0000
Message-ID:
 <FRVP281MB5672F901E7D26533F6DBCBCBA0762@FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM>
References:
 <FRVP281MB5672AE5BBD61EF0802D42370A0942@FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM>
 <20261102190811.7498-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261102190811.7498-1-lucid_duck@justthetip.ca>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sql-ag.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRVP281MB5672:EE_|FR7P281MB760042:EE_
x-ms-office365-filtering-correlation-id: 639b58b7-ab69-4aa0-0622-08df3bdeb044
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|7416014|376014|23010399003|18002099003|22082099003|10067099003|38070700021|4143699003|261026140227099003|261028144727099003|261021123027099003|261022105027099003|261022075727099003|56012099006|261009223027099003;
x-microsoft-antispam-message-info:
 037HLiKlkE1OVaA3GQL6/fmmO7duQfdrJe6FxXYUvsGzxC0p5EHDn4jHhlKR42u7SGq5xqkW0+iKFzx6dER3uOFYcOfnobuxVE8LqiDDPHkivmpyB6JuolG7iEz54ZJ1ps5Unq89ncxnbWDF2XXVRV4fwvNj8f54XB/+OLKyd3oUfMWxNj2SwFN653eO+aO/F/HVRadrBhl/eyy8x+s9A4DfKPipV6T0bJljiME8d6UFDFtomtGER/NCFUKA0khnMgwJC+pOMw/o/QxDfzdu3CR/edrHss9FKz9zLvlwRCKT3QwcexWgpr7zdJ6mVfASPqvHVsCfSrF36vwnA0KIYk446azh6LqRu/avGwG9CZywhQWIkhdco4hXyapeX/KgVo7ThehlASgPt9ZJE+E+9c+d+BK0CEqHy28AJ7wZ2ecH8uZx03uadOVeF+9N/hFpKo68ZdEGWOBzTrUW2G1F2QcRlVkjoChwW8Ay/YP/YzxbXCTSm4lCjBM9xDMDEblKlcIM6KRVxoUQp1GcymUa6UArAGW+DByIqsFSdh29fw0JsN0Nnz+N33U6AGqxTsCggBXruimcKHxN5yeamxc69MyQgg3n9YUO4+gsrfjm64QOd0yT8HuRPSu8xBOffyAkkZYxgd/sX/lPdeiWSU0X0yNgjqxwdkJVXns5vQoE5wlaLfxQr4fs7GNY1UC8SIC9ocWppXwxS4jg9szPYAMEli1POv9r21G/lhqfuTt3Yho=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(7416014)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(38070700021)(4143699003)(261026140227099003)(261028144727099003)(261021123027099003)(261022105027099003)(261022075727099003)(56012099006)(261009223027099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVl5WlNHczBaTGorN05KdmN5bTJjSDhrR2FKc0xpdkRwYU9BYnVHQlU5TXNu?=
 =?utf-8?B?MjBYbHpmVnhOK0ZJSWFCUmRheDlKbEFmT00vR0paZ092bnhJTWhONEZQOG5O?=
 =?utf-8?B?cHJKaExTc3RGZmdJSUtVRUl4bmIzNHFaNkFCS1ZWSDBSdXhEZ0EyYUNrT3Ra?=
 =?utf-8?B?Sld4bTlvWmtycVNIbmF1MEpyT0w3TW55TlZvNnZZTzhIdStHZm5FV0NJMnpB?=
 =?utf-8?B?RzE4UVRQZUVsbzhreXM5L1diZWpxTHkyS0NVaUJpWVFrUHprRGJaR3RFMnJz?=
 =?utf-8?B?ajlxd3N5dlU0ZmlVdmFjZzFSMHorZjBzQTgzc21NNU5keUdZcy9VRkFaVkwr?=
 =?utf-8?B?UEtkTHkxUitSa1dJRVdGKzVkOWhySU5obytnRThXelJ6NXdsOExsTExOZDlt?=
 =?utf-8?B?U24ybmtibGI0dmNmYXIxVVFVR0RvQjlCUnRrdDl4bmpibXFQSy9wYktwcGty?=
 =?utf-8?B?QmJKZXRwajVNQjg1MEc5cUliR1V3NkV3Q0ZSeVphd3NKbDhLQUJ6VnplMHRM?=
 =?utf-8?B?UGYrdXJ5V2pNNzR6c1N5R1lTVVFQQldXUUpNaVJ1cXJMRW9OMXdzVHFObXlE?=
 =?utf-8?B?RUpKb1hNY2ZiQk40QWJtWjJYZENpY1JSc25KMlVOTnVNdG9uYkhVQzkzVURr?=
 =?utf-8?B?K0FKVUhUQkVkZWRacWUrL0Q2bVlUeUdpbjBEa3krQ0s1ZmdMa05keitaOHJI?=
 =?utf-8?B?ZzF5YXF2bk9XbThuV3VJcm0vT1RhVnYvN2lOUUJ1NndaMW5lQUQxT2pqS2Vm?=
 =?utf-8?B?anZ6TkNhdklGTjBxdUhDVG5QUDY0RUVzWm5nZGN2QnNIbzJ4T1doS3ZLS0cy?=
 =?utf-8?B?UTJ4aGJ1akdVLzhuYk1DZEpNNU5pZCt0R0o0V1lBWHhyM3UvNk9TYXJTQmRm?=
 =?utf-8?B?SWhPN0ZJdXpYVE93L1BsZVRIbU9WeTJMdUQ5aUxyc3RvWFVZWng4dDZuTktn?=
 =?utf-8?B?MmhIVGJxZTlmYkdDdklGV3JNazBKL3F5MXpiUlRiS1ZIMm1DclA1RXFTUDNz?=
 =?utf-8?B?NUU1Wk9HSCt0T1VuOHRHeWZPV3B6SThlVlpaV3FucS9KMG81akhhZ1lncWdF?=
 =?utf-8?B?NFUvNDhINmNnbXU4djExUHFFeHhONWI0VTFVMmFsVmNuSHZoVU5PRFdLNWFW?=
 =?utf-8?B?QS9xc3BjaC91NlMrWHh3dHVwN0sxeHJlbTNFcE9hK2Q3eGxzU2RDcHZrdElt?=
 =?utf-8?B?MWVRN2wyeElFSzVnUVA5M1FGM1R4TGdYMG5YZ3o4SWpucjVoOWVxbWpRY2dV?=
 =?utf-8?B?Y3VFY3B4RjB4anc1eXB6dEl5S1FORFhGa3h5TFFFYWFJZkd1d2QyTkF1a3VG?=
 =?utf-8?B?VEcyNTBFMTZpMHRHMko1RTlaaFZNaHB6RENhU1RqMWk3OWE1WTAzZEMxdEU4?=
 =?utf-8?B?UEkxOGpNZ3NlMmt1L2F4VllZcDlXTHN2c25XQ0JQZ1FmQmkxNk5MckU1NE5t?=
 =?utf-8?B?a3pGYXJ0aU5xeTRINzR5SXhpUjY3U2s0ZGhrSGRzd1ArU2VHSVZTdU5kYUtI?=
 =?utf-8?B?VzBGNXAvNnR4VDhNcXh5dEUxSkd0QzlhcnBIemRSYzVCNDBoSE1objhiTWR1?=
 =?utf-8?B?cytVUmZTc0doTnZJc0NJY1lqYlpHOERST3VrdXMyeUtWbGRiQ2lsQ2FXWTg5?=
 =?utf-8?B?a3FvM1p4Vkw0aGREK2RRUHh1MzM1STFpU2VhN1pSa0c2YmZhbWZjRExKTlhW?=
 =?utf-8?B?czhnUVVYWUU0d1FhUDR3TytUYjdlYXYzR2NnR0dka1k0MmhHSDFCN21wT3F4?=
 =?utf-8?B?dXRtR2VGdHd5eVl5a1FwZVFsSDg4b2FxYXBZV0hKUFMwYkQraFlNSGZBV2gz?=
 =?utf-8?B?SzloNnhMaVhldS8rWjFXWEZYR2JkVE1IOFYzRFo1bnRnMUZsR1Y2Y0FBc0Jn?=
 =?utf-8?B?Q2N6OXNRcmQzQThhSVA3Z1pSRnczMVBKbk04MmtveTg4S2dVZmRyNzdCUk1l?=
 =?utf-8?B?TDROUU1zeGNWY0RpR0hRUVdWMGZxZWRnNHhsdFF5WlhCWGNmN2taWFdLbTJj?=
 =?utf-8?B?M3c0bWpzOUs4VjBKZm5YMUFmZ2tEalB1c2NWbFdFRHNjMVhEejZlYmYvdE9N?=
 =?utf-8?B?SVlyVWVJQ1Z5Z3RIbE9URVNXWmlrU3ZhaVlybW9XTldFUG9NV2h3cUc3cWFJ?=
 =?utf-8?B?b2xUdGhuUFcrdjhQRU1PSHhQVWtHUXhteVg3T1pkMVBQYllmVVQ1SFlvNjZu?=
 =?utf-8?B?V2tHK2ZCSDNsaW5NUkNURXoxaTBvU0E0SFRxUXM0ZHhqRWVubWhqbGc1N0JJ?=
 =?utf-8?B?cjRXYzZSWVNIN0RxbElzSmhKQWNaSTNyOFZsV1kvb2k0dVdVQ1RYRVNiME1L?=
 =?utf-8?B?MWRqOEFnUkhHV1lMejFlQU5LRU9henQxR012UnFhZmlhcWw4V1FUdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: sql-ag.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRVP281MB5672.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 639b58b7-ab69-4aa0-0622-08df3bdeb044
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2026 08:19:33.5811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: da8e29fc-49dc-4ba7-8111-a164e74e51bc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nT09dgGZRvHrJZirwqkEr5bnHWTQ6E6UWJWz3XGYDBYMed82DQd7hGhnG2wDKKTpzZMVczFBwEbOGq8Asl6ssw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR7P281MB760042

UmVzZW5kaW5nIGFzIHBsYWluIHRleHQsIHRoZSBsaXN0cyByZWplY3RlZCB0aGUgSFRNTCB2ZXJz
aW9uLiBTb3JyeSBmb3IKdGhlIGR1cGxpY2F0ZS4KCk9uIE1vbiwgTm92IDIsIDIwMjYgYXQgMjA6
MDgsIERldmluIFdpdHRtYXllciB3cm90ZToKPiBXaS1GaSBEaXJlY3Qgc2VhcmNoIGNhbiBubyBs
b25nZXIgZmluZCBkZXZpY2VzIGluIExpc3RlbiBzdGF0ZSwgc3VjaCBhcwo+IE1pcmFjYXN0IHNp
bmtzLgoKVGVzdGVkIG9uIGEgVGhpbmtQYWQgVDE0IEdlbiA3IEFNRCB3aXRoIE1UNzkyNSBQQ0ll
ICgxNGMzOjc5MjUsIEFTSUMKcmV2aXNpb24gNzkyNTAwMDAsIFdNIGZpcm13YXJlIGJ1aWxkIDIw
MjYwNjA1MTg0ODA1KSBvbiB0aGUgVWJ1bnR1IGtlcm5lbAo3LjAuMC00MiAoNy4wLjE0KSwgd2l0
aCB0aGUgcGF0Y2ggYmFja3BvcnRlZCB0byA3LjAgKG9ubHkgdGhlIGNvbnRleHQKZGlmZmVycyB0
aGVyZSwgdGhlcmUgaXMgbm8gaXNfbXQ3OTI4KCkgeWV0KS4gVXNlciBzcGFjZTogTmV0d29ya01h
bmFnZXIsCndwYV9zdXBwbGljYW50IGFuZCBHTk9NRSBOZXR3b3JrIERpc3BsYXlzIDAuOTkuIFNp
bms6IE1pY3Jvc29mdCBXaXJlbGVzcwpEaXNwbGF5IEFkYXB0ZXIgKG1vZGVsIDE3MzMpLgoKV2l0
aG91dCB0aGUgcGF0Y2ggdGhlIGFkYXB0ZXIgaXMgbmV2ZXIgZm91bmQuIFdpdGggaXQsIGl0IHNo
b3dzIHVwIHdpdGhpbgpzZWNvbmRzLCBHTyBuZWdvdGlhdGlvbiwgV1BTIGFuZCBESENQIHN1Y2Nl
ZWQsIGFuZCBzY3JlZW4gbWlycm9yaW5nIHdvcmtzLgoKVGVzdGVkLWJ5OiBTdmVuIEJlc3NlciA8
c3Zlbi5iZXNzZXJAc3FsLWFnLmRlPgoKVW5yZWxhdGVkIHRvIHRoaXMgcGF0Y2gsIGluIGNhc2Ug
aXQgaXMgdXNlZnVsOiB3aGlsZSB0aGUgc3RhdGlvbiBpbnRlcmZhY2UKaXMgYXNzb2NpYXRlZCB0
byBhbiBBUCBvbiBhIGNoYW5uZWwgdGhlIEdPIGNhbid0IHVzZSAoNSBHSHogY2hhbm5lbCAxMDAs
CkRGUywgb3IgMi40IEdIeiBjaGFubmVsIDEzKSwgd2UgYmVjb21lIEdPIG9uIGFub3RoZXIgY2hh
bm5lbCAoNSBHSHoKMzYvNDAvNDQpIGFuZCBncm91cCBmb3JtYXRpb24gZmFpbHMuIFRoZSBzaW5r
IG5ldmVyIGNvbXBsZXRlcyBXUFMsIGFuZAp3cGFfc3VwcGxpY2FudCByZXBvcnRzIFAyUC1HUk9V
UC1GT1JNQVRJT04tRkFJTFVSRSBhZnRlciBhYm91dCAxNSBzLiBXaXRoCnRoZSBzdGF0aW9uIG9u
IDIuNCBHSHogY2hhbm5lbCA5LCB0aGUgR08gc3RhcnRzIG9uIHRoZSBzYW1lIGNoYW5uZWwgYW5k
CnRoZSBncm91cCBmb3JtcyB3aXRoIHRoZSBzdGF0aW9uIGNvbm5lY3RlZC4gV2l0aCB0aGUgc3Rh
dGlvbiBkaXNjb25uZWN0ZWQKdGhlIGdyb3VwIGFsc28gZm9ybXMsIGFuZCByZWNvbm5lY3Rpbmcg
dGhlIHN0YXRpb24gYWZ0ZXJ3YXJkcyBrZWVwcyB0aGUKc2Vzc2lvbiBydW5uaW5nLCB3aXRoIG1v
cmUgbGF0ZW5jeS4gSSBjYW4gY29sbGVjdCBsb2dzIGlmIHRoYXQgaGVscHMuCgpUaGFua3MgYWdh
aW4gZm9yIHRoZSBwYXRjaCwKCu+7vy0tIApLaW5kIHJlZ2FyZHMKClN2ZW4gQmVzc2VyCgo=
