Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013045.outbound.protection.outlook.com [40.107.159.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1E3CB571;
	Tue,  1 Sep 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266416; cv=fail; b=HhHrNXWJLUdD3F5P7X8w+rsrz4+c3YKvOx0tkarAuivwIwRwRTI3Iz5v3ZYwAKps0sfXdlsr5V7s7kq5dEXy2yecc+H7U2EQRH0SkhwxhDoiNooGIgqLZWhB6tzjLVZTRbSlUW5PzRKF8pQy08Er0SuAUedXfJHl5GZh18TVEMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266416; c=relaxed/simple;
	bh=bmybxzxFC95i1IsqbLRF32XK1kHqhXnZIYj6KaBChWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QVRhSmUKvpTYiSQODbV5QTHwHSVxZx/deZQ+pRoKLK7hhpjcWp9/T8YAZg/+RneN6IIwfRzFzQiYxvjszLGrg1hJbTb2b9EwRcqgdcGbD4Xxivi60UQh1z5f2+7DthFOTMTWTRRK9WNh73qJNdhVDjhNkPk/xTi+Td+HFW0yUgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=XwI9OSqh; arc=fail smtp.client-ip=40.107.159.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="XwI9OSqh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6uADikylHD6sl0324tZHaEOzk2rp3AiMv4YKrXFkukTDy8TbtPR0owT5WIev7p2xg/MqdAzdpzhBg1PQMdTtnq9k1Oat86v9J/r9pzod71CT/8E8hiziWGAKnDVeRveD6z/f+2y9xxsmzkK0W+KrMoMCUpKSjB933PmtCwP1RnzOpINGJGF9A2mKcj+Dov0LMxpAGgpihuDjuFukGfby9JFtH5pkT4I8RaiRmoYT4E9OVxkap0kf4L1o0b9HjeFSamU1vpAYEkWXjJ4H8krwBzyl8U8rCKdZDpoy9xVGX/VvW6xb3qri7yGd9Lc2XzaQDEbkOaiV7y0r9mxMjCIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmybxzxFC95i1IsqbLRF32XK1kHqhXnZIYj6KaBChWs=;
 b=JSteNUXhLwM4YC7BR12iHKcIxnniZzS4TC7yLqbha/B48r4OK9F7nrmoilJJ+wCPwi9fmwJEepzpPVQV40rtHQ1u5Vq3v73F67l21u5ed/hOmqI7nUXxPLmx0edirIxnQFcLb31W5g/TdxP+d0U822+TIAWdcluAAR4P0DeVJ4T2STqeQ26WYI/4DOv/iMS9a8aFoEOQzwf1Z+LC9tUpTYG68kgyzSK1AG4pb+w9vjOfAhtsmwQUEg5Zi2rtFrq85vfuFiEggi+4amVo+X6aREvliHFFpVHKwrI+Di3qKIiTwdvnh5O+POCEgLtfB4qnUv1m0lxA+0+rV0CEeHSIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmybxzxFC95i1IsqbLRF32XK1kHqhXnZIYj6KaBChWs=;
 b=XwI9OSqh4CELxlfPkyxqJX4Ee0FaTgPpMEPkYzlyDTC5rEJBxywIq2Up3KIt/CFXQYotYmw2d1mZj/g9Rc+gD3+7XruMcJ9ZbzGupxrQm2/9bRM4Yt1LQ3/4kGOoDqQzbGgsvEngBTAt8qkEZ4zEOPoZnZ/8k21+SuHlgB/qb630DCcbTyK/kbDCisnRmM39/bF3Czm4WsXB/TsafrFVqJlhO6ggVDLFhIZezcTfkmExR12z37MGTiNZch/hq41Kw0nw2g0/BfxTN9qahqnQ//yRn6O4Gt/RkLr4/XFr2m3cCYKj4tp08odSvHogvS1Il001GrQQLxQK8vSI8iz9Qg==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by FRWPR10MB9505.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:d10:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 12:40:10 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 12:40:09 +0000
From: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"jerome.pouiller@silabs.com" <jerome.pouiller@silabs.com>
CC: "linux-devel@silabs.com" <linux-devel@silabs.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: wfx: fix possible device hang
 during init
Thread-Topic: [PATCH wireless-next v2 1/2] wifi: wfx: fix possible device hang
 during init
Thread-Index: AQHdOf61ROW9oNnohUyNV8CU6ceGera5qg6A
Date: Tue, 1 Sep 2026 12:40:09 +0000
Message-ID: <ae1623bbf3e0945b37f39c031f65810b2cbf9f89.camel@siemens.com>
References: <20260901083548.113131-1-jerome.pouiller@silabs.com>
		 <20260901083548.113131-2-jerome.pouiller@silabs.com>
	 <cc4de4e40e3ca50e7288be2b9067802576567c25.camel@siemens.com>
In-Reply-To: <cc4de4e40e3ca50e7288be2b9067802576567c25.camel@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|FRWPR10MB9505:EE_
x-ms-office365-filtering-correlation-id: b5bfa58a-b77b-4425-f28c-08df082628fc
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|4022899009|23010399003|376014|10067099003|6133799003|56012099006|3023799007|22082099003|55112099003|18002099003|5023799004|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 +8D9zrKRQoawuSN6zrSypC7UZjjmZM8MJgDzz3ukFSEuYRToHixmPy1RdZ+SBA8/VTzV1c5EcJgvBdI8ocsSCBrsfEwFTtQaDXdm8+cT9XW0+GCoh1bNondFFaYt3YK+QCtLJOBy8hK7JWKysZNVs8goQQ27J2DxW8n50bs/bQOb23ecQc/EBkWMDVtMzFu1pYtI8jga4fhx2M2X+JalQVPUd5eWfJXfNB2cTb4ahNTupINjnX85n+SbnL8OZH24jh5RvTutwHGAp43LCh7+EC/1nA5LIJN2oLtrspBSmELDyP0RChVIqwy5gAHm8vpHBK6Iijv4snV5FsA2vd2HUWaXsFGw06YawQerFzMr7BAnlWyuk5Ne31ZEY7jUyWe4erNfZVztCIryPl0AQ61yrULTDIbW1HdsA361iDTQpgXK8Pv6US2gI0A6+06MXxA2hFVFeY2XkrJpzws5q5YituzcFTycHEZ4bDg2wWF42QzrpcoJpdRhFzav8S7FgKUZQMKpty+cvO+LB7FzIzJNc3yauP90kxIwdgefzGFmRsGqXFc1okoBweUJRGcPA7E9BcSgWWT5CuD8poupqmL1Oe80xDyG5UdHFYdV8PRDiaTI5fkIeQU6YeXL1vIxRlGp2DkJJDKthywgQkkX+n8IPsXJiWOj3czQiNd2I9dpSqY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(4022899009)(23010399003)(376014)(10067099003)(6133799003)(56012099006)(3023799007)(22082099003)(55112099003)(18002099003)(5023799004)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V3lHZEpudmI2cjkvQVpqQ1dpVERaWXJMMHFOcThFcVJJV3I0WnQrUldYMHpR?=
 =?utf-8?B?bCtWUWxoNHJxVHQzNTJMcmROeHg1RmwzenFtMTUvYkJIUHlvcUpOMytzWU8x?=
 =?utf-8?B?QllJUlZGc1U1SWpFcVduV1JRMGMwQ1ZFdVRld0dnWVVtT0tmMEZWcjRSbk9O?=
 =?utf-8?B?RW53VzNONndsUnZrNWNMZTd4eThTUlRNM2RheE5wQzY2S2Z5VHdpRjBkWVI1?=
 =?utf-8?B?OFVLaU9zWlhsWks1ckJVY0pEUnhBVkJYMzAvWWU3ck1taWd1YVFvZmJFY0lP?=
 =?utf-8?B?QzEvd1k5eFNVeTdPOVZTV0dQVlM4M3VnaWV6SWpuYi9OYkZSRDNxOWZCbkZu?=
 =?utf-8?B?VDRhTFY2L05zbEFpTWV4K3dkZlNsVWVBS1ppanlET3lJK1lLZVZtbTUyV1RN?=
 =?utf-8?B?ZWhWSXphUldQbEZiVngvM29VL2FLNGUyQXMwV2pHQkkrL0RDZ2puUkNxbXBo?=
 =?utf-8?B?ZU5vUWJyZElEb2RxR2V1SGo2TTREd2FIWWdYK1g1bEpKUmVnNE5WWUpyKzBn?=
 =?utf-8?B?dHN0R1pYdEt2UDBwNkpXZUFUUDhVaDNOTVVEOWx3QklGK25ERlI3b2ZpZGpR?=
 =?utf-8?B?bTRPU3VUYm9vV0IzamFPVWJnR3lJRmJWNDFESnNrWTRRYUlmSCtHMi9LYmlt?=
 =?utf-8?B?aUpVTVEzSlpzOFRlOFAwM3U4ZkVZRVgvanM4eEYrZWpXUmNDby9vbHd4aTFu?=
 =?utf-8?B?dXFTdnJhd2lZYWE3bTM1bFpUNlJuczhGVGdZYnVFSkltc2NzVkt6Q0hqQW1B?=
 =?utf-8?B?TUE3R05XSjRtNHRxaHJibXZnVkVVd2Z5c04zQUZ5SDZBYzlacGo5SHI4NTZH?=
 =?utf-8?B?eXhPaCsyd05ZWm5XdTJ1U0xJSElhMjJTYlAyazZuck11Q3BRd0kwcVJOYlZw?=
 =?utf-8?B?LzZPdGZGTkZCM3ZRRW9MUWtWbHFaNlNDWmhDZFZZRlBFWjZQOGw4NkdyR1VV?=
 =?utf-8?B?ZU9VUW9WRVk0Rmw0YWFycmxnd3ZBdktHTFMyWjJhQ2l5NXBSbEZiWkpIckpC?=
 =?utf-8?B?cEtpOGlaamFXMW5UL2dyTlp1eUJwZ2JjTDRDTlBNR3NLWG8rdCtKODhmVXYw?=
 =?utf-8?B?V2VBVHUxVzZFRHlmRHRrNUt5aTlTemYyWkJzRWJTUmhmRnN5WVlGSSs1YlBG?=
 =?utf-8?B?MHIrOERwaVBFTzBIS3lVallOY1NEVEpzcFBEc1IwcDgwaE91SXNSRlpZOE9v?=
 =?utf-8?B?a0xSTGI2R2MwUDQyUlR0cUdtam8rdXJPbS9VNk5sczJpenBGUnVoNHpWa2d2?=
 =?utf-8?B?RHowNGZUZjZHNmI4VjljS3JLTWtPcVVCcDB6WjRFVVhDTFpOSDhQaXVqdE8w?=
 =?utf-8?B?d0w1UXVEdk93blRIaS85RTJKN0VLYU00NUZ6LzFxRWU4eGVMSmZRUzFHd0Er?=
 =?utf-8?B?RmVNWThMenpnOGltLzhTRkN3Yjk2bit2NWdKVjlMNTZ3bHA3d0tsT2o4elZZ?=
 =?utf-8?B?aDVwOU1NMHU1ZE1QNllWNWd4U0p0M0VZcUhqUGQ3LzlOWm1CeXJMZjJYOEkz?=
 =?utf-8?B?ZW5lM3UyVGpsdWY5ZE85UGtONGVhSjNGTnozY0Z1TzVDYUgxNzhEN2YyRGsv?=
 =?utf-8?B?ak1ESldzai9vYUo1NnF0Q0svL3B0Z1J2NjgxQkdPQ3hsaW9GL2Q1SXZxc3J2?=
 =?utf-8?B?R2kvVGlETHdTd3c5dnA5ZXEyY09nb3EzT1E4K0ZzQ2taTG82MHQrbnhmZ1V3?=
 =?utf-8?B?SHl6OHBaTmIyakp5Y3g0cElSQzBNSkExdHBpLzFOb093Umg1VVFCKzAxTjJK?=
 =?utf-8?B?T1U0UGZqa1JGa2MvRExGOW5oZWhvejRCUmVQN0RQdEZhVVZlcWZwNzd3Qmxj?=
 =?utf-8?B?TFNDaHlQZFczekFBVVVJdE44YStmQmZjQ1U5QU5nMmRFWHh2UW5qZGwrQ3dN?=
 =?utf-8?B?eHhzR0V6aGpPc0VxdmJ2SllYWnEwcnRsZU5vV1NLa1kxRWZMNGtvVDVYdEZ5?=
 =?utf-8?B?T1A5NHpFNmRialVEUnVKQjdBZThVdkdTVk10RkhtRkVoRk05UzYrWmpYQ3pt?=
 =?utf-8?B?NUo1T3RzdUJ0ZEIzdDc1c3pIZ1YzempVVHVQWHhLSmowMFh0T01iR2tCVVdI?=
 =?utf-8?B?YjBUSnN0bzRGTFp3YUJURm9OWnpCR1V2cE80QjlHZmEyVTNETmdRZis0UVA4?=
 =?utf-8?B?dloydDBuRWlYWTFLY2UrbnRSeC9XR3N4RGI2Nll2QzB3Y3hUb2RHZnZLdzJM?=
 =?utf-8?B?Nk5SckcxaTBNMnA2MThWcjZsUFZjSjRoM1VpK3g0NGFsQ24yb1dvd2h5eVNx?=
 =?utf-8?B?S1FjQmRqVlBzMEF2VXQ5TzBCRTVZS3RyOFBzT3B1eGlZK1VEbEEvdFpLaHBo?=
 =?utf-8?B?cmwwcjJtRWRiNXo2bjB5MDI1RUw2ZkNtQW5GWldaaWEyVTdwNzRHc2hIT3Z2?=
 =?utf-8?Q?qONAc6wKlnCbHsLY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB5D1E3220F0984D81C931C558279945@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b5bfa58a-b77b-4425-f28c-08df082628fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2026 12:40:09.8960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F7YhIFViuWz8x2sCVgoo9qsDVkHIJV+UyEUcrJwnq6jbHilA1hplk2pDlypTJ8l/HaN46qyRs2Msm0HdoCRqd9nR/njicEZzJWQ2yAjCLxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR10MB9505

SGkgSsOpcsO0bWUhDQoNCk9uIFR1ZSwgMjAyNi0wOS0wMSBhdCAxMjo0MyArMDIwMCwgQWxleGFu
ZGVyIFN2ZXJkbGluIHdyb3RlOg0KPiBUaGFua3MgZm9yIHRoZSBwYXRjaCEgSnVzdCBvbmUgcHJl
LWV4aXN0aW5nIGlzc3VlIGJlbG93Og0KPiANCj4gT24gVHVlLCAyMDI2LTA5LTAxIGF0IDEwOjMz
ICswMjAwLCBKw6lyw7RtZSBQb3VpbGxlciB3cm90ZToNCj4gPiBUaGUgV0Z4eHggZGV2aWNlIHBy
b3ZpZGVzIGFuIFNESU8gaW50ZXJmYWNlLiBJbiBhZGRpdGlvbiB0byB0aGUgdXN1YWwNCj4gPiBp
bi1iYW5kIFNESU8gSVJRLCB0aGUgZGV2aWNlIGFsc28gc3VwcG9ydHMgb3V0LW9mLWJhbmQgSVJR
IGxpbmUuIE9PQiBJUlENCj4gPiByZXF1aXJlcyBhIHNwZWNpZmljIGluaXRpYWxpemF0aW9uIGRl
c2NyaWJlZCBpbiBjb21taXQgZjAwZGMxZDc4OWUxYw0KPiA+ICgic3RhZ2luZzogd2Z4OiBwb2xs
IElSUSBkdXJpbmcgaW5pdCIpOg0KPiA+IA0KPiA+IMKgwqDCoCBXaGVuIHRoZSBjaGlwIHN0YXJ0
cyBpbiBTRElPIG1vZGUsIHRoZSBleHRlcm5hbCBJUlEgKGFrYSBPdXQtT2YtQmFuZA0KPiA+IMKg
wqDCoCBJUlEpIGNhbm5vdCBiZSB1c2VkIGJlZm9yZSB0byBjb25maWd1cmUgaXQuIFRoZXJlZm9y
ZSwgdGhlIGZpcnN0DQo+ID4gwqDCoMKgIGV4Y2hhbmdlcyB3aXRoIHRoZSBjaGlwIGhhdmUgdG8g
YmUgZG9uZSB3aXRob3V0IHRoZSBPT0IgSVJRLg0KPiA+IA0KPiA+IMKgwqDCoCBUaGlzIHBhdGNo
IGFsbG93IHRvIHBvbGwgdGhlIGRhdGEgdW50aWwgdGhlIE9PQiBJUlEgaXMgY29ycmVjdGx5DQo+
ID4gwqDCoMKgIHNldHVwLiBJbiBvcmRlciB0byBrZWVwIHRoZSBjb2RlIHNpbXBsZXIsIHRoaXMg
cGF0Y2ggYWxzbyBwb2xsIGRhdGENCj4gPiDCoMKgwqAgZXZlbiBpZiBPT0IgSVJRIGlzIG5vdCB1
c2VkLg0KPiA+IA0KPiA+IENvbW1pdCA1N2FhNTU3ZjExMGQ5ICgic3RhZ2luZzogd2Z4OiBpbnRy
b2R1Y2UgYSB3YXkgdG8gcG9sbCBJUlEiKQ0KPiA+IGFubm91bmNlIHNvbWUgbGltaXRhdGlvbiBh
Ym91dCB0aGUgZGF0YSBwb2xsaW5nIG1lY2hhbmlzbToNCj4gPiANCj4gPiDCoMKgwqAgVGhpcyBm
dW5jdGlvbiBbd2Z4X2JoX3BvbGxfaXJxKCldIG11c3QgdXNlZCB3aXRoIGNhcmU6IGlmIGFuIElS
UQ0KPiA+IMKgwqDCoCBmaXJlcyB3aGlsZSB0aGUgaG9zdCByZWFkcyBjb250cm9sIHJlZ2lzdGVy
LCB0aGUgSVJRIGNhbiBiZSBsb3N0Lg0KPiA+IA0KPiA+IEhvd2V2ZXIsIHdpdGggbGFzdCBhbmFs
eXNpcywgaXQgc2VlbXMgaXQgZG9lcyBub3Qgb25seSBpbXBhY3QgdGhlIElSUS4NCj4gPiBXaGVu
IHRoaXMgY29uZGl0aW9uIGhhcHBlbiB0aGUgaGFyZHdhcmUgaXMgbG9zdCBhbmQgd29uJ3QgcmVw
bHkgdGhlIG5leHQNCj4gPiBjb21tYW5kcy4gVGhlIG9ubHkgd2F5IHRvIHJlY292ZXIgdGhlIGVy
cm9yIGlzIHRvIHB1bGwgdGhlIHJlc2V0IHBpbiBhbmQNCj4gPiBiaW5kIHRoZSBkZXZpY2UgYWdh
aW4uDQo+ID4gDQo+ID4gQ3VycmVudGx5IHdmeF9iaF9wb2xsX2lycSgpIGlzIG9ubHkgdXNlZCBk
dXJpbmcgdGhlIHR3byBmaXJzdCBleGNoYW5nZXMNCj4gPiB3aXRoIHRoZSBoYXJkd2FyZS4gVGhl
cmVmb3JlLCBpdCBoYXMgYmVlbiByZXBvcnRlZCB0byBvbmx5IGhhcHBlbiBhZnRlcg0KPiA+IGEg
ZmV3IGhvdXJzIG9mIGJpbmQvcmViaW5kIGluIGEgbG9vcC4gVGhpcyBleHBsYWluIHdoeSBpdCBo
YXMgbm90IGJlZW4NCj4gPiByZXBvcnRlZCBiZWZvcmUuDQo+ID4gDQo+ID4gRm9ydHVuYXRlbHks
IHdmeF9iaF9wb2xsX2lycSgpIGlzIG9ubHkgcmVxdWlyZWQgZm9yIE9PQiBJUlEsIHdoaWNoIGlz
DQo+ID4gcHJvYmFibHkgdmVyeSBtYXJnaW5hbC4gVGhlIEluLUJhbmQgSVJRIGNhc2UgYWxzbyB1
c2VzIHRoaXMgZnVuY3Rpb24sDQo+ID4gYnV0IG9ubHkgdG8gc2ltcGxpZnkgdGhlIGNvZGUuDQo+
ID4gDQo+ID4gVGhpcyBwYXRjaCBsaW1pdHMgdGhlIHVzZSBvZiB3ZnhfYmhfcG9sbF9pcnEoKSB0
byB0aGUgT09CIElSUS4gVGhlIGJ1cw0KPiA+IGRyaXZlciBub3cgdGVsbHMgd2Z4X3Byb2JlKCkg
d2hldGhlciBwb2xsaW5nIGlzIG5lY2Vzc2FyeS4gV2hlbiBpdCBpcw0KPiA+IG5vdCAoaW4tYmFu
ZCBTRElPIElSUSBhbmQgU1BJKSwgdGhlIElSUSBpcyBzdWJzY3JpYmVkIGJlZm9yZSB0aGUgZmly
c3QNCj4gPiBleGNoYW5nZSB3aXRoIHRoZSBkZXZpY2UgYW5kIHdmeF9iaF9wb2xsX2lycSgpIGlz
IG5ldmVyIGNhbGxlZC4gV2hlbiBpdA0KPiA+IGlzIChTRElPIHdpdGggT09CIElSUSksIHRoZSBi
ZWhhdmlvciBpcyB1bmNoYW5nZWQ6IHRoZSBjb250cm9sIHJlZ2lzdGVyDQo+ID4gaXMgcG9sbGVk
IHVudGlsIHRoZSBQRFMgZmlsZSBoYXMgY29uZmlndXJlZCB0aGUgSVJRIGxpbmUuDQo+ID4gDQo+
ID4gVG8gY29uY2x1ZGUsIEluLUJhbmQgdXNlcnMgYXJlIG5vdyBzYWZlLiBVc2VycyBvZiBPT0Ig
SVJRIHdpbGwgYmUgc3RpbGwNCj4gPiBpbXBhY3RlZCBieSB0aGUgYnVnLCBidXQgdGhlcmUgaXMg
bm90aGluZyB3ZSBjYW4gZG8gKGFuZCBub2JvZHkNCj4gPiBjb21wbGFpbmVkIGR1cmluZyB0aGUg
bGFzdCA2IHllYXJzKS4NCj4gPiANCj4gPiBGaXhlczogZjAwZGMxZDc4OWUxYyAoInN0YWdpbmc6
IHdmeDogcG9sbCBJUlEgZHVyaW5nIGluaXQiKQ0KPiA+IFJlcG9ydGVkLWJ5OiBHZXJhcmQgU2Fs
dmF0ZWxsYSA8Z2VyYXJkLnNhbHZhdGVsbGFAc2llbWVucy5jb20+DQo+ID4gUmVwb3J0ZWQtYnk6
IEx1a2FzIFN0b2NrbWFubiA8bHVrYXMuc3RvY2ttYW5uQHNpZW1lbnMuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4N
Cj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYmguY8KgwqDC
oMKgwqDCoCB8wqAgNiArKy0tDQo+ID4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4
L2J1c19zZGlvLmMgfMKgIDEgKw0KPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dm
eC9tYWluLmPCoMKgwqDCoCB8IDM0ICsrKysrKysrKysrKysrLS0tLS0tLS0NCj4gPiDCoDMgZmls
ZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+IA0KPiBbXQ0K
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWlu
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L21haW4uYw0KPiA+IGluZGV4IGRk
YTM2ZTQxZWVkMTMuLjRlOTlmZTdlNWJiNzggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9zaWxhYnMvd2Z4L21haW4uYw0KPiA+IEBAIC0zOTksMTIgKzQwNiwxMiBAQCBpbnQgd2Z4X3By
b2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQ0KPiA+IMKgCQlkZXZfZXJyKHdkZXYtPmRldiwgInVu
c3VwcG9ydGVkIGZpcm13YXJlIEFQSSB2ZXJzaW9uIChleHBlY3QgMSB3aGlsZSBmaXJtd2FyZSBy
ZXR1cm5zICVkKVxuIiwNCj4gPiDCoAkJCXdkZXYtPmh3X2NhcHMuYXBpX3ZlcnNpb25fbWFqb3Ip
Ow0KPiA+IMKgCQllcnIgPSAtRU9QTk9UU1VQUDsNCj4gPiAtCQlnb3RvIGJoX3VucmVnaXN0ZXI7
DQo+ID4gKwkJZ290byBpcnFfdW5zdWJzY3JpYmU7DQo+ID4gwqAJfQ0KPiA+IMKgDQo+ID4gwqAJ
aWYgKHdkZXYtPmh3X2NhcHMubGlua19tb2RlID09IFNFQ19MSU5LX0VORk9SQ0VEKSB7DQo+ID4g
wqAJCWRldl9lcnIod2Rldi0+ZGV2LCAiY2hpcCByZXF1aXJlIHNlY3VyZV9saW5rLCBidXQgY2Fu
J3QgbmVnb3RpYXRlIGl0XG4iKTsNCj4gPiAtCQlnb3RvIGJoX3VucmVnaXN0ZXI7DQo+ID4gKwkJ
Z290byBpcnFfdW5zdWJzY3JpYmU7DQo+ID4gwqAJfQ0KPiA+IMKgDQo+ID4gwqAJaWYgKHdkZXYt
Pmh3X2NhcHMucmVnaW9uX3NlbF9tb2RlKSB7DQo+IA0KPiBBdCB0aGlzIHBvaW50IGVyciBzdGls
bCBob2xkcyB0aGUgKHBvc2l0aXZlKSByZXR1cm4gdmFsdWUgZnJvbSB3YWl0X2Zvcl9jb21wbGV0
aW9uX3RpbWVvdXQsDQo+IHNvIHdmeF9wcm9iZSgpIHdvdWxkIHJldHVybiBhIHBvc2l0aXZlIHZh
bHVlIChhcyBmYWlsdXJlKS4NCj4gDQo+IEJ1dCBtYXliZSBpdCBkZXNlcnZlcyBhIHNlcGFyYXRl
IHBhdGNoLg0KDQpJIHdhcyBhYmxlIHRvIGNhcnJ5IG91dCBhIHNob3J0IHJlZ3Jlc3Npb24gdGVz
dCBpbiB0aGUgbWVhbndoaWxlIGFuZCBhdCBsZWFzdA0KSSBkaWRuJ3Qgc2VlIGFueSByZWdyZXNz
aW9uIG9uIGEgc3lzdGVtIHdpdGggU0RJTyBhbmQgaW5iYW5kIElSUXMuDQoNClJldmlld2VkLWJ5
OiBBbGV4YW5kZXIgU3ZlcmRsaW4gPGFsZXhhbmRlci5zdmVyZGxpbkBzaWVtZW5zLmNvbT4NClRl
c3RlZC1ieTogQWxleGFuZGVyIFN2ZXJkbGluIDxhbGV4YW5kZXIuc3ZlcmRsaW5Ac2llbWVucy5j
b20+DQoNCk15IGNvbGxlYWd1ZXMgd2lsbCBnaXZlIHlvdSBhIGZlZWRiYWNrIGZyb20gYSBsb25n
LXRlcm0gdGVzdCBydW4uDQoNClRoYW5rIHlvdSENCi0tIA0KQWxleGFuZGVyIFN2ZXJkbGluDQpT
aWVtZW5zIEFHDQp3d3cuc2llbWVucy5jb20NCg==
