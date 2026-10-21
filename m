Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792594650;
	b=wkY1pYZI1+uKlZZ+0jXIWFFjD8mRhv6x0VwEGvAHUIudDhM25MFgLIIFt0f8TkwvH7Gf
	 y2evg9WWQMEjP567nA/r47KRt+3ohirLlW8C8WwdbLh3m9xxlOMSjth75EvchE22HVh0p
	 ErIyG9W0P4ZgCURnUt9LBMCxlNadpQLz/eJ2EzHGx1aAvXPTdtvkFYFPf1INd/pFO0R3u
	 Mb6pfUgVOGgn5bWsqZW14+hytDWsOngiLdNDhlgHJpCkcCMW8u1ZYcLilbmViy4jcm1wh
	 pdQcV6pZupQ2dQ5iwPp5ieeuW15NLpoah75JT9GxJth9Ok6+M7Akxg4+JORqtuY7ZFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594650;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=pxPz4dsD7KBNS5GpMosBUNNirTxxaUoPfbHceUQQVE4=;
	b=fH4IvaHJPQryWAB2myl2NzxvxIgrMXrr193VjrFgiGew697lu0UW6B43FNkqu/+uMy+/
	 BLtdONdWB0jlgtRjcM0+CUWTvafaftKkHosLJIVGpZXq4wyySCJmXJl2mXHyaGLMemylR
	 BycVg/3PTstqV5t6+pvUgUbVrqCc8jPiDCcl08qzvShEqPZ+/IgrEA30hhplUOVkTLHNg
	 ZqH1bZLHjgnSfLXPjkyCbODMJg5wBrDF0yReCha3ZSJIeXkTVv2Jgl5PE+MIP7nC7vldP
	 VnpYRhbGIO+8SPmQjw8yHu3pHFISWLaZc29dIeTnBfHQv6w3tqvFlHtMyK0DGkQy9YA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="ea/fW3do";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.65
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F010606A31B;
	Wed, 21 Oct 2026 14:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F010606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ea/fW3do
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8SPBIk+w8IFAhmJcyTTcUZBhiDyW+ZEIHBIVlSYsCmAhoukBThOmsfJScmJq71D0jPUWXSl0mvtKZh/NzoN3xXg/K+/fvNzlqhdbHP5d2fxqXW2+ZMHjKPGjMS9cczSCejNVky3QJBB6r7QIZQ2KYN6lfLmI0aDY3acJNxGAJcljlDXSPaZP3sAMfAQ4+xXUgSVPria2dGu5NGiP+GgsIbrmEYjqnUnejw2HN07EhIcf987/s68ecV149O3N+F8gxs8zi9obDhGiEdn7VVlM1c0VVFAEFLGmJe4RdyIBXJmGkUlzbtxI/M72ntPFmiGFXtcRAxIyFy3BVkz0SU7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxPz4dsD7KBNS5GpMosBUNNirTxxaUoPfbHceUQQVE4=;
 b=qOITzNaLKwHyMP5LFscRBZ3/e96JFjlcb4CqCA2VUbeYIOsEviNaQqrmT2Raalysg4vgs52AGtiWv5djeHgSShLZEbepPjUxe3b4/Nwa6tB00PA1zgkKjh7cmGyQAuDMVyAlKGTzc4lJQ+6Ztvc2ODKGfg1hgKinzYbgjUDyRhzK1OOQ68Z9j3NwSPbmbrRJF85KeqezwAAgdko+x/U94S2ol5yHaGCaWzcR1j7OdmWxKeCMMeIOVNRqKqdsvN8BUKD9xOTt15y7ta6NB0VrPbi7FL2S1hY8GQeK+1ejggzkeN2lx2NWKzYAZQOoHhM6b4r3LAe71s7g//9/dRjp9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxPz4dsD7KBNS5GpMosBUNNirTxxaUoPfbHceUQQVE4=;
 b=ea/fW3doDx3G0fo4VC4mA7oLjXSLvzaA3zGZxg3kYMGBhy5poKkbS+9w1ckUyKblFyQbfk4+AaIBNk4/Xq75LKBZ1rBI1jJEFgtMEYEo6g5RZ3VR9tR7BxBqdi0c/jbumVe8NBaVH9cSALlp89rU4qD1733dN5l3pr4Rh0IHzxUb45YB4hw8PGWSuAyiP3jFdQQOOutJ3UKcnnsx/8gQTg64+I4yqabqNF8K6G2NifBdKO8J11fUehHKJtW7TLCABeApmD/V1UnfWkNculsARbekNwRJ4a4Ffj6u3cUCDJ8JOeNX49UWvyGwD892zMp4CZygSD+BKuFr727j7KEXqA==
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::648) by BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 14:57:25 +0000
Received: from DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe]) by DS5PPF266051432.namprd12.prod.outlook.com
 ([fe80::9cef:7e0f:2134:13fe%3]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 14:57:25 +0000
From: Cosmin Ratiu <cratiu@nvidia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Tariq Toukan <tariqt@nvidia.com>, "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>, Carolina Jubran <cjubran@nvidia.com>,
	"kuba@kernel.org" <kuba@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] wifi: wext: Limit notifier event flushes to the device's
 netns
Thread-Topic: [PATCH] wifi: wext: Limit notifier event flushes to the device's
 netns
Thread-Index: AQHdYWpeg4JX56h4BE2f/Sg+OqSmL7cIFhaA
Date: Wed, 21 Oct 2026 14:57:25 +0000
Message-ID: <1f19a52be17394943b4269606719ebfc5cc99226.camel@nvidia.com>
References: <20261021144111.611840-1-cratiu@nvidia.com>
In-Reply-To: <20261021144111.611840-1-cratiu@nvidia.com>
Reply-To: Cosmin Ratiu <cratiu@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS5PPF266051432:EE_|BL1PR12MB5825:EE_
x-ms-office365-filtering-correlation-id: 3392aaa2-3cce-4ab6-8da6-08df2f839e26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|22082099003|18002099003|10067099003|261009223027099003|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info:
 fvLVJFRFVhHl1SeqmUc8V7P+0lrY9Vhyz8TYBEvbeuB8ZoyH8UTtLtdqlCNN8HF9f3mgiH39H0QJKg/nmx7OL6w966Qr4gyrFrxIsz7PhsvVkqiHggsShto34Wy67T8dcePHIsWndY7II22IVUFuP+MwrtXdXV/cX+a4dgd1XsojLMwWUfYly7/xQUICK7UCoj+IBuxYplxaEecfqmLviMWKR47pzcQnJFIHBqQA+GoZsutTJGjFAjmXQBgR/LzAyy5BhMQ1ulAH2hnOb6t+vMbztC5wUYhBRlOhyrZT2OydDBZw7WOqkZv92CQAzaGsRGw4ypmEmZ5eyPCzyVW7oE6aUezO7as3R2CxzTzbHbx4rp8O6epqkb1xVlPpcvBHqkiRrQTDAF9r3UGNHVc+DYJQ5mB474/SXL7U8fxOujXkQHGXgqTaUMEraPtx15WQcMbXJ9w2f8PQry3QDSqpK7uzsJaYTd6VMZdyoNHqG56dT0Er+p9J9nHJYxaSpMUKg4C5FsCJFz75a8SnkFXEO50uA8vcBEHkzRMLOkYS4w2JZnaUumPNUp0nFcJfHhbuMIx76oQvaTycGVuUEx3cW7DkopVBKszfdmt2+p8IwuVXoYfzdB398v+Ibj4EO+EucnvGv9610YMoUjuaW/5los3qLTeRJVL9UIm0uJTR+nHZkAAqyTCZ8GqE+AxDkg309uHIELvibGl0mXfjhk7qYKOI8sep/uboA5XxlPf/4aY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPF266051432.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(261009223027099003)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXRneS9Ydll2bmFJWEpESXN1OUNmVE1sbEd2Vk5BMitOSzJsZGlDNjh4M1VH?=
 =?utf-8?B?aU5xNGovOFE3UXVFeFgvaUhLKzZqaGQvYm16Y28valNuTXorYks0Q2FaQmQ0?=
 =?utf-8?B?SDh0TjI5cVdtelVxdDRFMHF4VHlkakNtUnZ2YWJvOStYbFIwMGFnVjFGQmRx?=
 =?utf-8?B?dmY3RUpiN0dYYm5rZlpBVXVPbFJSNmJra1FScDhTRG1GYmlPZFk0cnNCODh3?=
 =?utf-8?B?cGJQQjhpY0MxZmk5dmRUYUQ3bnpZZm1FNHc3Sk5WVjlaYzFCbTRJaDRPSHR2?=
 =?utf-8?B?WnBXVHF2aVNlS0xVVFh0b2ZzVEN3cTExdk1tY3pQRy9UYWlQK0o2UENDWEdW?=
 =?utf-8?B?RFBaUGRrMjV6bjhyUndibHNreHZUNFZsamkrSmhDMFlzQWNZc0FyUzdBNEVR?=
 =?utf-8?B?QmFEY0xWeDNLUVNBTWUvajB3SlhLQUJWM1AyWFZ3R3l5aDcxdkFOR2dIdnY0?=
 =?utf-8?B?K0dUSXVpa1dvZzZ5TWRLb0dxSmJTd3N2V3BxbkRqcFVGTFVONjRaN2JrU05r?=
 =?utf-8?B?R2tPL05Edld1M2ZjU285cGdoYUZ4SEJLYVVpZisrNzhSZHh0bURvam4yNEsv?=
 =?utf-8?B?dGRIT1hJN3dKN2RvZGJod05iRWp6K0wxcWE4V2xZWUxpaWZ2ei9vY25GSWNi?=
 =?utf-8?B?amlRZjdpc3hvL3NSaXgyZmJvNUx1MDJzK24vWS9hMWM4OFFWbjJjVnd5M1g3?=
 =?utf-8?B?QkdSWEI1TTBXUzBRVy9udUtSQ1RXck1KdVBSOHQ2Sk9QWi9oc3lrUFBia0px?=
 =?utf-8?B?cXp3TkxGZzBHNTNMallZUmRMckRnRVNZWEFDTGxrZHBJTzYrRUxVWlRqZ2xN?=
 =?utf-8?B?SjhuTXFRRU1ObEJ1SkdLcFhrVnYzUmdwV2R5cjEzZnBTMWI0eVpjWFgydU5n?=
 =?utf-8?B?a3J6dGhFenJSaktpZDhadllkVHByNE56Z0ZUTjNUN3dtSXhLd1N3RFluVTN1?=
 =?utf-8?B?R3pwVWZranpVMm1jNVJxVm15bzdiWlpyaFNrd0NKQXdrb01wQzlsRE5DamNs?=
 =?utf-8?B?WWV3eFFIUDNUaGZ3YndBcEV2QkFseWR5ei8vOU9UK1ZibXF1emFZTXpRUXEv?=
 =?utf-8?B?bTZ0UmZmK01KekJhSjRVQWJxMEhLVDhHZklGNGJnd1FyQjFGY1Bzb2lkM3Ft?=
 =?utf-8?B?SG9tWFgrUW8rZURTYUFvTUoxRlpaSWVKZ0pBcmRCTHF2WE9rakNqcTJuZGdF?=
 =?utf-8?B?M2xYUXd6T2h1RkhQMHJQLzlHUFFDcklVVnR0KzJseFFKSjNYb3pJeSsyT1BP?=
 =?utf-8?B?N0YxWXdMQXc1eHpPTTlEMmpkZDY2NGg1c3hwNXVkQ0IrTUt6SXJtYXFVMmx4?=
 =?utf-8?B?Qmk2aUhvRUF0ZEwvM082V1B5ZlAwVUJZUnVYNE8wME1XWnpZNkl2M09YS2RJ?=
 =?utf-8?B?cUx5djBucERXVFUrNHZwV3ljMXhWeE1SdUgwVmI4YWhDdW9qUTBaZkJ2VTlR?=
 =?utf-8?B?TW1DcU9hc3YvR1NycFZxeGVhQXNYNUZqN09NV0ZDSkFSL3FvQjZNL0JoTXM3?=
 =?utf-8?B?Qy9CdU9UU2xzUWh3YWtxVzJPMUtVcWNiLzlWY3NMYVR4VGRuUHlZZTlRdVlT?=
 =?utf-8?B?V1VXU1FlNUN6Z3B5RTN5eUM5TDcvU0dWcmJiMVhSQnAvaVVlandwVE9JMUxz?=
 =?utf-8?B?d0VGMkNBU005cGhBQlgva2NGcDRGNmw5YzhLVEFheGV5ZWJhRmRzWVJqeXgr?=
 =?utf-8?B?OVVsQVRSSWpNaHlabFRXUEYwK0dpTUdpT2J1M085NDhEdU01VUNSMEpwRjRL?=
 =?utf-8?B?dG01QXNQVnEyR2ZEMFR0MlhyckZtejlzY09Tb0pXR1h6LzQzM1pwVGxkTC9Q?=
 =?utf-8?B?cFVFVnVNWEQwaWZsRVNzZDN3WThtd2tSclBlMjBWU3FVOWZRdVVqaW1DQXhy?=
 =?utf-8?B?Y3FqOEtzbFBRbkt4d2hVRzdlaHdmRmdmOGFwRjVuUkV2NzFlU0xnOHBKOWNY?=
 =?utf-8?B?OFRlU3hzbnl6ZDV1WTdpanBLeG1oYVZpNjdabjhibVBEYkFBaHN3RS9kSmQ1?=
 =?utf-8?B?YXNpVlZMTWo5bmNOc2NqdUc0azNBNlU2NC9EYUlmZWVnSVdjay93U2dtSGhq?=
 =?utf-8?B?UUREMWFNM05Zd0QyNGFSaTZOL1BEMk9jT1JHS1BhS2U1YVN0c3dlNkIzaXAz?=
 =?utf-8?B?SStZMHZJU2tuckFWTWxjdWNvZkhQcXV3eUdBdU85RUNmRnYxb2hSTHBvSWlp?=
 =?utf-8?B?ZVJFSlhadUE5dVAwM2VRbkRpVG5BZHhPL3dxVGlIVFlFQUlBdVFSRTFuZ05m?=
 =?utf-8?B?eWpZMzNLWE1Hd29GTmlkSUM2a1MxWlRzYkxOdktGeUVaMW0zc2xJUFZkTXdl?=
 =?utf-8?B?NElvTnZZMkhUQVhEMTZOWnd1Z2FVait5cWpvdXk2VjRSN05xa3M5dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90FCE945EFA3C74A9D4FD40C161AE4DB@namprd12.prod.outlook.com>
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
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS5PPF266051432.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3392aaa2-3cce-4ab6-8da6-08df2f839e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 14:57:25.0121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XPZiQ4NJu3RkrLQpqWP7uPvK/WndLB42XFsAzrwx1cEgy2pmgUwJIK7g9Y1Xre/gb7qlSpjqZH5EqO8WOvBNlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825

T24gV2VkLCAyMDI2LTEwLTIxIGF0IDE3OjQxICswMzAwLCBDb3NtaW4gUmF0aXUgd3JvdGU6DQo+
IFdpdGggbWx4NSBuZXRkZXYgaW5zdGFuY2UgbG9ja2luZyBlbmFibGVkLCByZWdpc3RlcmluZyBh
biBJUG9JQg0KPiBuZXRkZXYNCj4gY2FsbHMgdGhlIFdFWFQgbm90aWZpZXIgd2hpbGUgaG9sZGlu
ZyB0aGUgaW5zdGFuY2UgbXV0ZXguIEl0cyBjYWxsIHRvDQo+IHdpcmVsZXNzX25sZXZlbnRfZmx1
c2goKSB0YWtlcyBuZXRfcndzZW0gdG8gd2FsayBldmVyeSBuYW1lc3BhY2UsDQo+IGNvbXBsZXRp
bmcgdGhlIGZvbGxvd2luZyBsb2NrZGVwIGRlcGVuZGVuY3kgY3ljbGU6DQo+IA0KPiDCoCBuZXRk
ZXYgaW5zdGFuY2UgbXV0ZXggLT4gbmV0X3J3c2VtIChyZWFkKSAtPiBHSUQgdGFibGUgbXV0ZXgN
Cj4gwqDCoMKgIC0+IGV2ZW50X2hhbmRsZXJfcndzZW0gKHJlYWQpIC0+IG5ldGRldiBpbnN0YW5j
ZSBtdXRleA0KPiANCj4gUm9DRSBHSUQgZW51bWVyYXRpb24gdGFrZXMgdGhlIEdJRCB0YWJsZSBt
dXRleCB1bmRlciBuZXRfcndzZW0uIEdJRA0KPiB1cGRhdGVzIGRpc3BhdGNoIGV2ZW50cyB1bmRl
ciB0aGUgdGFibGUgbXV0ZXgsIHRha2luZw0KPiBldmVudF9oYW5kbGVyX3J3c2VtLg0KPiBUaGUg
SVBvSUIgZXZlbnQgaGFuZGxlciB0YWtlcyB0aGUgbmV0ZGV2IGluc3RhbmNlIG11dGV4IGluDQo+
IGlwb2liX3F1ZXVlX3dvcmsoKSB0byB0cmF2ZXJzZSBjaGlsZCBpbnRlcmZhY2VzLg0KPiANCj4g
VGhlIGFsbC1uYW1lc3BhY2Ugd2FsayBvcmlnaW5hdGVkIGluIHRoZSBzaW5nbGUgZ2xvYmFsIHdv
cmtlcg0KPiBzZXJ2aWNpbmcNCj4gcGVyLW5hbWVzcGFjZSBXRVhUIHF1ZXVlcy4gVGhlIG9yZGVy
aW5nIGZpeGVzIGxhdGVyIHJldXNlZCB0aGF0DQo+IHJvdXRpbmUNCj4gaW4gbmV0ZGV2aWNlIG5v
dGlmaWVycyB0byBwcmV2ZW50IGRlbGF5ZWQgV0VYVCBSVE1fTkVXTElOSyBtZXNzYWdlcw0KPiBm
cm9tDQo+IGZvbGxvd2luZyBSVE1fREVMTElOSyBvciByZXBvcnRpbmcgc3RhbGUgaW50ZXJmYWNl
IGZsYWdzLiBBIG5vdGlmaWVyDQo+IG9ubHkNCj4gbmVlZHMgdG8gZHJhaW4gdGhlIGFmZmVjdGVk
IGRldmljZSdzIG5hbWVzcGFjZTsgdGhlcmUgaXMgbm8gcmVhc29uDQo+IGZvciBpdA0KPiB0byB3
YWxrIGFuZCBmbHVzaCBhbGwgbmFtZXNwYWNlcy4NCj4gDQo+IFBhc3MgZGV2X25ldChkZXYpIGZy
b20gYm90aCBub3RpZmllciBjYWxsZXJzIGFuZCBtYWtlIHRoZSBmbHVzaA0KPiBoZWxwZXINCj4g
b3BlcmF0ZSBvbiB0aGF0IG5hbWVzcGFjZS4gS2VlcCB0aGUgYWxsLW5hbWVzcGFjZSB3YWxrIGFu
ZCBuZXRfcndzZW0NCj4gaW4NCj4gdGhlIGV4aXN0aW5nIHdvcmtlci4gVGhpcyByZW1vdmVzIHRo
ZSBpbnN0YW5jZS1tdXRleCAtPiBuZXRfcndzZW0NCj4gZGVwZW5kZW5jeSB3aGlsZSByZXRhaW5p
bmcgc3luY2hyb25vdXMgZmx1c2hpbmcgZnJvbSB0aGUgbm90aWZpZXJzLg0KPiANCj4gSXQgbWF5
IHNlZW0gc3RyYW5nZSB0aGF0IHRoZSBmaXggZm9yIGEgbG9jayBjeWNsZSBhY3Jvc3MgbXVsdGlw
bGUNCj4gc3Vic3lzdGVtcyBsaWVzIGluIGEgY29tcGxldGVseSB1bnJlbGF0ZWQgcGFydCBvZiB0
aGUgY29kZSwgYnV0IHRoaXMNCj4gc2VlbWVkIHRoZSBtb3N0IGp1c3RpZmllZCBsb2NrIGN5Y2xl
IGVkZ2UgdG8gYnJlYWsuDQo+IA0KPiBJc3N1ZTogNTMzMTAxNQ0KPiBGaXhlczogOGY3YjAwMzA3
YmYxICgibmV0L21seDVlOiBDb252ZXJ0IG1seDUgbmV0ZGV2cyB0byBpbnN0YW5jZQ0KPiBsb2Nr
aW5nIikNCj4gU2lnbmVkLW9mZi1ieTogQ29zbWluIFJhdGl1IDxjcmF0aXVAbnZpZGlhLmNvbT4N
Cj4gQ2hhbmdlLUlkOiBJOThkN2U3N2ZmYzlmYTBjZTcyMjk2ZDkzYzIwMGRhOGZlMWRiMzc4ZQ0K
DQpTaWdoLi4uVHVybnMgb3V0IEkgZm9yZ290IHRvIHJlbW92ZSB0aGUgIklzc3VlIiBhbmQgdGhl
ICJDaGFuZ2UtSWQiDQp0YWdzLg0KU28gdGhlcmUgd2lsbCBiZSBhIHYyIHdpdGhvdXQgdGhvc2Us
IGJ1dCBwbGVhc2UgbGV0IG1lIGtub3cgYWJvdXQgdGhlDQpyZXN0IG9mIHRoZSBwYXRjaCB1bnRp
bCB0aGVuLi4uDQoNCkNvc21pbi4NCg0K
