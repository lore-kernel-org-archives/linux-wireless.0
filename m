Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010037.outbound.protection.outlook.com [52.101.84.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED92E403150;
	Mon,  7 Sep 2026 07:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764752; cv=fail; b=TCEICY7HmPjUby4v5EwYWS37pLEXb/I9A5kAOL196Ok1BQWr27/M3/wzhI0QoMQE7t5Lv4PWieibpuX2EG7ar7sDq15bSsHLD+piRZ+kYfqiHOc5fyn20xIwrHAx2PaattUgxwYjAbvYVyVOKJVkzMEHSz+CR7DE/cuXqdbF+qY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764752; c=relaxed/simple;
	bh=+KB1Z0f9vdknj7f1HJ4x5j7PL5r+A7kEXtcLUsCgMYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H5EHnU02dEmQeujjhb9XTt7TsOGpvm0SFHtAfelR3nQH542Bc0B4TX71nlf8+M4XsHyo43ztb43wDl/QbDOBK+nmd/nz2VwGSK780b36qms9ZbOmythY0G+z+NF+wjvMHlYLJ8gD4VBtiaKSCV623nf2TmD+3zhJYlXSIvF0jRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=eee8vKjF; arc=fail smtp.client-ip=52.101.84.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="eee8vKjF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z011Xyzvp8ZXuMjgUAERZund3QXhmO4UM+Dffb6/yfRxjAqJgNSGp1IP8oMD2XVvxa3joSHlAATtAUvgdtFJM8tvVR1nuVPhsDwWkr47a/l8M0Ma8VY0iJnZiOYMwOyXzEfQBVL5sE5u0jNo4j0mXzY7CTDCIC/OL+mtVrqYUTD9LF841A6CqZCgvpr49wElAzZ7VHwpYalWzwfVzkXQD6iaAO6aRIgJkVAT0uXNDqaHI9LQAJNqW7IM4MjYgjiffDdcqjVu4fcaFsIK4UM8IuzHPuSdswXj1l0/xqkHclqdpnjOwwEXKC9l5ShNRcwu9XDo0Nqw2VMMy2lAnKV3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KB1Z0f9vdknj7f1HJ4x5j7PL5r+A7kEXtcLUsCgMYg=;
 b=P6SdQD1W1YAjcutaoauEG1aIaLGX39SiWwsGiuE9LzfXSos79PjTiV6yDR4h06cQM9jY1lpBAh9yC4ybaeHQjFzPaypFIK3lCewjtxx1q1RQQu7dRw4HY91DG8ZqNYnqIxiAEdttqWbJOpE+o40vd2rldnYgjmCJ6L0BtsV7tQAcOy0hiXUO6Yn7oQzQjFGf7xtnqiTgqrhyJfIh4rN3GU+6OZtLYZvlQEMUUYPKuHq0OwWuXe5uUF1JfKrqKGxGU2FBdJbCwuNOYtMf0Nc/eKKcyjdH7iJNvkEdlrw/YxkmyFmiJZgicQHIX3BVyx+mANTkgRl6iNRFBq6UjX5kuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KB1Z0f9vdknj7f1HJ4x5j7PL5r+A7kEXtcLUsCgMYg=;
 b=eee8vKjFld5f+RGOPhViXQtJVH/cOsP3j9YgsnmI66dfS33Vfxiejlb8JLGvj6mL6TVKOe6wnX7/vJRlJQidgKkNSZniDMrmSN0eFp+tU3ZhCB5n9c9lZpZe9NLWi+d78fGVwGaKZu+DXS5Ot4EbEzq52clGfSaoajmAeqaTt/99EZMaeSsqPLatDlWnxLkd5lP8OVP8f4yJW4K7sUK/6V6DiTZ/PwV0dwvFSElhQgRVA3wOmdjuKMOyM3LIrpRs5ng8vhQIKwZrMzAJm7/zxd2MZzTergCNmscttNRcV01BZ2PJo4tMHddKY7cB5O46vnTrqWYQnbPpq2E0GwRVNg==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by DU6PR10MB126760.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:50b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 07:05:46 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 07:05:46 +0000
From: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"jerome.pouiller@silabs.com" <jerome.pouiller@silabs.com>
CC: "linux-devel@silabs.com" <linux-devel@silabs.com>, "Stockmann, Lukas"
	<lukas.stockmann@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Salvatella, Gerard"
	<gerard.salvatella@siemens.com>
Subject: Re: [PATCH wireless-next 2/2] wifi: wfx: fix error code on
 unsupported firmware
Thread-Topic: [PATCH wireless-next 2/2] wifi: wfx: fix error code on
 unsupported firmware
Thread-Index: AQHdPkElQKU1Z0Oid0ySBfSWgVrH27bCpY+AgAAKvgCAAAHLgA==
Date: Mon, 7 Sep 2026 07:05:46 +0000
Message-ID: <62cf4817d77e05091705df4126b860c7822b64fb.camel@siemens.com>
References: <20260906204831.949692-1-jerome.pouiller@silabs.com>
	 <20260906204831.949692-3-jerome.pouiller@silabs.com>
	 <afd87cc3d8703bd107740396a8b38d3a24720335.camel@siemens.com>
	 <3424781.oiGErgHkdL@nb0018864>
In-Reply-To: <3424781.oiGErgHkdL@nb0018864>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|DU6PR10MB126760:EE_
x-ms-office365-filtering-correlation-id: ab02ff74-e71b-4747-0fe9-08df0cae70bf
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|56012099006|11063799006|4143699003|22082099003|18002099003|55112099003|38070700021;
x-microsoft-antispam-message-info:
 Jd2KLs15WxSViyjaNOweXnyzeYEPC2bbNUd+c15ZpUsdVWUYQ44Cuizt0/WR0l8HhmSMzjs3VqpIGGQrFZNSSJT48q3Y2qVOV1eeYdO1xAdb1+frd+UV+OqUhs3v74yfQPJpLEANKr/33K3F6/+wBZ6/4UuQMwRsPssbUPsxcuSdPVvIQvm0jKTIKxSWgokhscv3PHFKqBOw8b3Clt/9CIIC3not0RtIeSIEZYmYKo2hBLRX5+hpnK4IndDK87lf+OBFG/mE1EOCIDTpoMa7GEsrUnfveWApXZ21dqnFuNJ9JschI9io0stn4o04LBpB9AqyY+lxVhT1HvdTWomKTGVLR29ZGOpRr+cT82y87H+TVZT/MGXN3WzV7/jqvDBgbXuBWmhiFMoAXLTG9eJmt7NLlSw93tU4ioDIjWJhCBp3AcZn5EzUr7k+WxToZpxJDVYiGd1qJ1gTTMrZY04U0WNFcCbLPvSQukP8PiERUxE/MsK40v1qUwPdeN1r25z2iqPW+kRRvmVp1W/ffiGQRDjG9z+i4FUzLp0yffTNJdi1M9U5jMrytlKNAaLDdSf6xb4+KpmQ/9Io7rN3NvOx30TuRDl5LAvEaTawOi5IKPjoVUcxuXp8Hjz2TAzeAJQOQGRehkeMklDdKSuBHL6zqkygvAtSPGugVxZCiXRV7Vo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(55112099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHJ5aW1Vb20rQXQzc0NkcWJNam9RRldjTFU2K1VrSlA0NWE1c0RyZVRVdG83?=
 =?utf-8?B?TXFkQjRKQWNobFM1UnFBVVBxdkFaekhHeDR3VTdhZnF0Yno5SVpHL0xnUUhL?=
 =?utf-8?B?UXVHdzJsSHFxWEV3d0RFbTYzTllvQlVDTEtPRDJBMVUzWXNOVml4a0FPMVIw?=
 =?utf-8?B?Sy9tK05vRzRVLzZ6R2FtaE5TM3gzb2c3b1p4Mi83UWVKWmlzUjA4YmlUeGtw?=
 =?utf-8?B?THpKZkZNVHUwOFZqV0FsVnphaUtmcU5JclFZeDU0M3Y1ck9qOHRUMTYxb0NS?=
 =?utf-8?B?VGNQd1RiL0ZGUGZydElQcUpxeFNVdXJpYUpralFiZlluaVZZczJNVSt4dUs5?=
 =?utf-8?B?ek5rdUlqT3gyclNKdnhXTEtDQlFId2pyUm9XcVE4U1lTS20zSVNid2tzKyt4?=
 =?utf-8?B?L3VTckRPV2pEMUNMOVQwS1hieTVsc2VvYWNXQXV0K0dtN2cxSkpJUy9ENzQ1?=
 =?utf-8?B?TVhKSnhCYXdiVTJQWWlQbGJscFBnOXhDdUxtY1pCSHMyc29wM3E5VktFdVAz?=
 =?utf-8?B?TkFCaW9SWllRQldCdXQvL0dzalBtZTZyZk1PQTIxa0kvd202NXNXcjdMd3Zr?=
 =?utf-8?B?c21CK1Q0MWR5bXFUMmdqSEprVzYxZFVqWGlzd0krMHNVQ1NhRVo1TlJ2alRv?=
 =?utf-8?B?QmJvclJUeW1VSHozVGYwZ2dyV2dPb2szRElidDcwbzZkNHZLb1lwaUkvcFQw?=
 =?utf-8?B?NDE2OHYxMnkwZmN2RmR0RUtkQ0h0R1pxQ1VBUzdRWmJKbE1QbHVrb2VMMGhh?=
 =?utf-8?B?N3RScFJzWk9CZDh0cEdUbjBpekJ0YnVJSDc1Mmo3SzZhcjdHaWRGSkFDUHFM?=
 =?utf-8?B?cFMwczRFZUFFU2RjVWoxWXV3T0QwL0JmYzBCMVR4bzNUSW1zTTNnME1yTk5Y?=
 =?utf-8?B?OHc3RTkrYUxwZEI5OGZoVVpXRlJUSVVwaXVYM1RQc1hhMVdPSTdIRENDSVpw?=
 =?utf-8?B?MDdEK1JCTURvdFpwM2xPUHB4RmRqWmFkMXg5ZU5yMXlUVGtwZmVONk5kSzFG?=
 =?utf-8?B?MEoxZ004NzQ3MHI3TW5FYzhadVgyNG1iSzJvaWU3MGFqOXFyUmVYT09mbEc5?=
 =?utf-8?B?bDZDNnRnQlFUK3c2MUkrL1psdDlMTmJ4K1IxZlk1cHpscXgwNlRrSG03TFYr?=
 =?utf-8?B?OThSVU56OE5TVElkaUlXSDQ1cmkzNXUxUTNGWnVKV0UwaXJaTFI2THEvR0Mx?=
 =?utf-8?B?TGVpeFlabGlvS2dISWladmpsRWQzamZhMGZkaFJOY1gwSU9xNHBCT2F0S01E?=
 =?utf-8?B?dVlDZVFOVWljaTdrcUxHR3R6YkNiVjgyZlBVelZlNTJWTjYrRXEwdlNEVlUw?=
 =?utf-8?B?ckVLeU1odk5tQXlrUFcrblYxZFp5WHM4MmJUUVZwZDNzNmh3MlBzQU81WG1R?=
 =?utf-8?B?dDlMbmhteGYyMHhzV1dJNHRzYXZjWDhFTW1rd2poYXFsRlhLZlhFL3BNMHpU?=
 =?utf-8?B?UElIbUpKbDZLSC9LMTlxandMR1dxNTZtWDBSVTd5b1EydUVXbzFnbk1CNXJX?=
 =?utf-8?B?QnhPSmI4TEZoUGllaFJvQjlCWjNUQ0VIVzNjSmNJQnh4WjkrVWpQa2R2b3Zt?=
 =?utf-8?B?ZFFJS01tZlRCbmFnV2xBZ1IzQlM3VmdKei9qbHhKNkI1RmFKODBwcVdGWXNZ?=
 =?utf-8?B?cFExZ251WWQ2dWVoTGJ4NHFLbEhlVWE2N3J3R3FoY2VXWTFUTmdiNnFzNE9q?=
 =?utf-8?B?dmRiSzl5Z3gxSUVoNVNDTXZIRDNpMy9wRjByOFM1c2VYMEtMdlJPV2huZk8r?=
 =?utf-8?B?d242S1E5REVZNmhBdm44dVkrS253SUZPTnVmL3E0VFFNYWNuSVk2ekdTSmdD?=
 =?utf-8?B?bHBZZjB0VlJiWDN5cFJoR3o2WWxzYzVybFRCNk0rSnZPWG5aaVhsTDRCcnhW?=
 =?utf-8?B?N1RpanJpSDNmMEhFT1kwSVNZSTBaamF0bzFOSXBRMEdoVHlxZytCVVVrS29Z?=
 =?utf-8?B?b0tiUU9wcnJsQ3ZmaEIvdmFRQVBSLytSNTU5RjFkdXlYQlN5dXAvQThtVS9Y?=
 =?utf-8?B?R0tBWDRNUDFHRlpxanVYeFBIVHBjVWJ2SzRFQXNIQ2p4L2w0eVYrZEN3bHE5?=
 =?utf-8?B?SmttZmdKWW0wdVQ1aFlnZnN5cmZ3clh5YWdXTHlpdjBTdmFBcFcyTjdZMC9G?=
 =?utf-8?B?N2FtVEE2VExLUUlyNHpSeE1jcVJ6WG5mVWVGc1JWRGc4ZHFQMTh1YVRHMnd1?=
 =?utf-8?B?YzFsdWxMQzBMNlUrS2ppKzVSR0JtV3BGREhZYXZsSjZBaDZWck9XVThzeEFV?=
 =?utf-8?B?UzBhU2I3WXFEWXFmNFB6N21nM0JpL1piRzR4UVlUVXlIQWQvbThteTBFNUFr?=
 =?utf-8?B?cGhpdE03Nmx0VWdTS3U2VnBlVlJ6RVpFQ0Q2YkU3aFlTdHFuZEtiUTdLaEN0?=
 =?utf-8?Q?pLxy7H5dedcfNICM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F41246176D17D34EA642922C755B7ADB@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ab02ff74-e71b-4747-0fe9-08df0cae70bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 07:05:46.4220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6cGgcFtuV4Rr559jycXgihNzcITLs2N2KfN40DBCQLFVCmUyrKmaTR9WXrUFbsTKw9cM2heeZeJTHPXsGQ+fP1rfj8fof+vI9bK5EH/SwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU6PR10MB126760

SGkgSsOpcsO0bWUsDQoNCk9uIE1vbiwgMjAyNi0wOS0wNyBhdCAwODo1OSArMDIwMCwgSsOpcsO0
bWUgUG91aWxsZXIgd3JvdGU6DQo+ID4gPiBUaGUgJ3NlY3VyZSBsaW5rJyBmZWF0dXJlIGlzIG5v
dCBzdXBwb3J0ZWQgYnkgdXBzdHJlYW0gKHRoZSByZWZlcmVuY2UNCj4gPiA+IGNvZGUgcmVsaWVz
IG9uIG1iZWRUTFMgdG8gaW1wbGVtZW50IGl0LCB3aGljaCBpcyBub3QgYW4gb3B0aW9uIGZvciB0
aGUNCj4gPiA+IExpbnV4IGtlcm5lbCkuDQo+ID4gPiANCj4gPiA+IElmIHRoZSBmaXJtd2FyZSBl
bmZvcmNlIHRoZSAnc2VjdXJlIGxpbmsnIGZlYXR1cmUsIHdmeF9wcm9iZSgpIGV4aXRzDQo+ID4g
PiBlYXJseS4gSG93ZXZlciwgZXJyIHN0aWxsIGhvbGRzIHRoZSB2YWx1ZSByZXR1cm5lZCBieSB0
aGUgcHJldmlvdXMgY2FsbA0KPiA+ID4gdG8gd2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCks
IHdoaWNoIGlzIHRoZSBudW1iZXIgb2YgamlmZmllcyBsZWZ0DQo+ID4gPiBiZWZvcmUgdGhlIHRp
bWVvdXQsIGhlbmNlIHN0cmljdGx5IHBvc2l0aXZlICh0aGUgemVybyBjYXNlIGlzIGhhbmRsZWQN
Cj4gPiA+IGp1c3QgYWJvdmUpLg0KPiA+ID4gDQo+ID4gPiB3ZnhfcHJvYmUoKSB0aGVyZWZvcmUg
cmV0dXJucyBhIHBvc2l0aXZlIHZhbHVlLiBUaGUgYnVzIHByb2JlIGZ1bmN0aW9ucw0KPiA+ID4g
Zm9yd2FyZCBpdCBhcy1pcyBhbmQgdGhlIGRyaXZlciBjb3JlIG5lZ2F0ZXMgaXQgKHNlZSByZWFs
bHlfcHJvYmUoKSkuDQo+ID4gPiBUaGUgZGV2aWNlIGRvZXMgbm90IGdldCBib3VuZCwgd2hpY2gg
aXMgdGhlIGV4cGVjdGVkIG91dGNvbWUsIGJ1dCB0aGUNCj4gPiA+IHJlcG9ydGVkIGVycm9yIGNv
ZGUgaXMgYSBtZWFuaW5nbGVzcyBuZWdhdGl2ZSBqaWZmaWVzIGNvdW50IGluc3RlYWQgb2YNCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXl5eXl5eXl4NCj4gPiBtaW5vcjogSSBzdXBwb3NlIGl0
IHNob3VsZCBoYXZlIHJlYWQgInBvc2l0aXZlIg0KPiANCj4gSSBtZWFuLCByZWFsbHlfcHJvYmUo
KSBpbnZlcnRzIHRoZSB2YWx1ZToNCj4gDQo+IMKgwqDCoCAvKg0KPiDCoMKgwqDCoCAqIFJldHVy
biBwcm9iZSBlcnJvcnMgYXMgcG9zaXRpdmUgdmFsdWVzIHNvIHRoYXQgdGhlIGNhbGxlcnMNCj4g
wqDCoMKgwqAgKiBjYW4gZGlzdGluZ3Vpc2ggdGhlbSBmcm9tIG90aGVyIGVycm9ycy4NCj4gwqDC
oMKgwqAgKi8NCj4gwqDCoMKgIHJldCA9IC1yZXQ7DQo+IMKgwqDCoCBnb3RvIHByb2JlX2ZhaWxl
ZDsNCj4gDQo+IFNvLCB0aGUgamlmZmllcyBjb3VudCBiZWNvbWUgbmVnYXRpdmUNCg0KeW91IGFy
ZSByaWdodCwgSSBkaWRuJ3QgcmVhbGl6ZSB0aGUgYWJvdmUgZXhwbGFpbnMgdGhlIGRyaXZlciBj
b3JlIDstKQ0KVGhhbmtzIGZvciBleHBsYW5hdGlvbiBhbmQgc29ycnkgZm9yIHRoZSBub2lzZSEN
Cg0KLS0gDQpBbGV4YW5kZXIgU3ZlcmRsaW4NClNpZW1lbnMgQUcNCnd3dy5zaWVtZW5zLmNvbQ0K
