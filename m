Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41382448B8A;
	Mon,  7 Sep 2026 09:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772324; cv=fail; b=d+hP/pmSXJ7kbsuf50HxQr9cexo9a7Smk2ChUA1tNT8WmKBBYsfDkQn5U/gLchm48a6ua8Mi2QIA/UcHCZr2uvngDrwbNAp7+Uqv7inUlT2YuI+3ya4wXrpoPeEiQgG37EqRxS0ClbbfrQYxIz4lLyDZqbRVXm3MUdKOx3XNWlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772324; c=relaxed/simple;
	bh=7BbH+iW0nHBx5jiSkgmH7toZzcmmv8Y4tx4r0dWw3VI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nBibj01gsvKEPpH4PUsKmXeLaE3fplAQuTcE0s0F17a56CxJzR9VDZkSR6+BZnOfEaWSIXHmUBEeEN1aW9A8hNaZR66wAqAZ9XQZMoXXrTxow7/3PZI14e4CAAVToCBQvhhGhSKIOujLcuN2gQp5sZB7E/NlyDFixpqhZKmhYl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=oqF4Bqjl; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="oqF4Bqjl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJ/W4MhC5xJUsA27jFdsEY9EwyO1k9tzlFsse+ZoXKQcsvORDk2HthPyArkrK2p3EuYo4XEfAr9UXxuGndxjGdQyIVzG6K4+UF9Se5Jx0PcgGcS9gzbtVqsebbsdaokBL69mVnI7/TefDc24lyFOjBq04IyDf1T2KPalnLqA6OI/4+uUM5QXzWqCujg6FB2EgL823ynBBX3o0li3fcMerial4F7I7j19nW1cCKmV/KNGFQycI0fqlnzYzJn6HYgVt5TUgHUGUt2GMCXcjSeNa9bC8NxEjMFBnVg+B1n8S4xRP5DbVDTBNkL+dLo0HccpjReDM8v9J7weGFiOhK/uTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BbH+iW0nHBx5jiSkgmH7toZzcmmv8Y4tx4r0dWw3VI=;
 b=KUAJu44tXhP+ji1z+h8/FOdM91EjckcJdV3Ohyge5Mm55RkoObjSWaMxIAKV0HKTb8CdYHGqaemU841WIo1W/knDy4l/UyZXW5qFCZfR7qMSGbKDH9zOZazgAzUoua3n59Ip1k9GSTymCbsCSZtvtPDil1cJ/t0eUTWWKZnmdnxdlsrZvr2ws9mHeY6oIf4LimOi9tSA0Io07ZuFA4x7eoYyMze+vrHUtqoT3nPu4bbjzslfM4kdLf/X78U/5LwdgOG+oj5EmodUN94AcFusCVG3nqCS3nKMdpMetNHpTupSgeFVE8E/krTPlj7WlYQplmKuo/g2LrV1r1FYfGp94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BbH+iW0nHBx5jiSkgmH7toZzcmmv8Y4tx4r0dWw3VI=;
 b=oqF4Bqjl9vpX+JBlzUpZ6b55E8J53rH3dKL2q02SBsVMU/ftumR6LSDlfcxBwopW/lV1Khai2OfWeNwxbXnW197ctn3ktC2KyJtNmdX3C/oShUnfJRSkaZk+D4J2UbsdDxqyTqw1mge3L0C4RNXSW5e9HnNb0be8BVFf16FXoQWJ/I9ZD7P2bfytnLEW5akEP/NTUqu9HFA8eSCW0JDNi4D+CKKmQU4Z6h83efbiC9kAecP9AZ605Xf70teqPdZlmPLO43MNDTgPhpXK5DmfwQBqRnsu1s/fySsFYp+abIkgyeQZFf68obO+NmM1lQMag49IFAj9GqODRlDf7iGUfw==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AS2PR10MB6447.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:55a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Mon, 7 Sep
 2026 09:11:58 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 09:11:58 +0000
From: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"jerome.pouiller@silabs.com" <jerome.pouiller@silabs.com>
CC: "linux-devel@silabs.com" <linux-devel@silabs.com>, "Stockmann, Lukas"
	<lukas.stockmann@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Salvatella, Gerard"
	<gerard.salvatella@siemens.com>
Subject: Re: [PATCH wireless-next 1/2] wifi: wfx: fix use-after-free of the
 cooling work on device removal
Thread-Topic: [PATCH wireless-next 1/2] wifi: wfx: fix use-after-free of the
 cooling work on device removal
Thread-Index: AQHdPkEkSK3b10CmvUGfnanQmEzj67bC1VqA
Date: Mon, 7 Sep 2026 09:11:58 +0000
Message-ID: <9ae51d750e3b52e11abf87b2f4f42708f6dd9fb1.camel@siemens.com>
References: <20260906204831.949692-1-jerome.pouiller@silabs.com>
	 <20260906204831.949692-2-jerome.pouiller@silabs.com>
In-Reply-To: <20260906204831.949692-2-jerome.pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AS2PR10MB6447:EE_
x-ms-office365-filtering-correlation-id: bb14b47c-d1ec-48c9-7154-08df0cc0121e
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|4022899009|23010399003|366016|38070700021|10067099003|4143699003|56012099006|11063799006|5023799004|18002099003|22082099003|55112099003;
x-microsoft-antispam-message-info:
 IDVfTUbmhoy8S0tKld0cdmr/fOicRNxHWflzjz0OvSgjGwDKRAyUR+JoaJtLZ+OQddwn8+rDUgA1EqtE03sLCGUkL/ZyneNSfWpW03dnSM/FITJ9+bwvsI/kIfWGNUDhWH1sOV/vnZOm6BJCshFw1AEzIBNyJPwAmLCxtwBLLW/9EOL6wOrCoCP/r3feQcegiVkzG7FVKg+QbkXney6dhH1Jpp0s3BHCa7VJzi7jSwXBgCSEpJPRc99TxXrJZxwXwW5jg9+RJKRlBR5DcDxCb2j4ZlRFdv1T9+fyT+vS45iAWNam2hwUNJHXkEM4RjufICeoDciM1W6a05KT8xI+MSWW9orrLdvarQlZ4pdoROwto8cLDs2t/6xxvvppBi/dCJJ6OYZ1KPD710BsBcnFvndGqMSzCIDkD7tq0VhwC3C+DOwGnPDkSJmK9zBrJ1MK+KR+RxILNQXVyLVpznZjGGlEB1AJWpBBaA/Dos6LFiboUVIlmsQx4oXrWpzxsKS3DBhEfXWjZ4YHoD+0BFjBq+Q/Spf5Jt8ujRgMHS7f8ssyZYGFrmVIk+oB/wTX98dqxr65iJx8QRHxqww3KC9nWxBm78zGlg3fZ/wt6GZdtwvsAk4gMRi+9vVzAUE+d2Wa3VxoJFxYL2vIeVGzP6df4VMNyQEcIGXCrdQ5TjJZINI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(4022899009)(23010399003)(366016)(38070700021)(10067099003)(4143699003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003)(55112099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SzFoclQ4SVRydVYvVVZqY3g1ZVpsemd5aXdKZGxYNFRSN2hmMzMwRk9lVE9o?=
 =?utf-8?B?Tk1ySVYvMkV0SThnNTZKYkllNy9LUzc5V2kwS0dDckd6QUpGRmdITjRmdVVL?=
 =?utf-8?B?bko2MEJTTjNjQ1BhTEFCY0lZR1YwRWg0dmNObzkrMlhHUzhIaWRyaFY5ckUy?=
 =?utf-8?B?elgrOEU4QVg0Qlo1YUZGaGkzNHhZSkQ5VWFmQ1dZL0tJbjZmcENteUFSWmJu?=
 =?utf-8?B?Tzh6T3pEdVduak82V1ZoNjZVRlR4cERNREVXRTd0dnh2Vzk0NWZsdmZpNitD?=
 =?utf-8?B?aDNmT3NNTGJPemVuTlpwTFJsRlhjQzRSbTgwWVUzdkltS2EyQU5oUU9oY2NH?=
 =?utf-8?B?K1BDaEM1SDhPOFJEclZOS2JoTzFtOGVOd3l0d0xiZzFDeXViU3Mya0hwT2d1?=
 =?utf-8?B?ZWdoQVluR2FRYzZNcnAzVjh4aGx6Wkt5bk1neG9OR054TE5xWWQvMVRDV2o5?=
 =?utf-8?B?aDhKSHdCS3VNSTI4d2VHeWZROEgrTmxCTDFFWkQ0SG5UMVpoY1J4YUN5SFBW?=
 =?utf-8?B?TzBPazFmZ0FLNDZySmlQL0tFV3gwSVMzemR0dUxwSGsxWnpMTzBiWldxT3U3?=
 =?utf-8?B?L24xRUs1Q3BFUDZUc0JRdzIyaTkwcjVORlFxWFhWRmhqb1Y4bnhibEJHSWV3?=
 =?utf-8?B?cmJEZjF3ME9uQjI1eW1MVFQ4YnVudkF5eVE0b0ZwSTdFQWdPS0JRVERYZTdB?=
 =?utf-8?B?OWE5VThMalhVWWFRRmFCVXprcGJLdldrK29aZDc2a3Y0andGbWhQd2ZTNVJN?=
 =?utf-8?B?S3VXMmlmMmxiNkVJdS84YkdoV0ttdmpSc2YzUHZpOU4vb3FWZDdCM1F6Tzd6?=
 =?utf-8?B?RWFadGFXVll3TGd3QWY0OFlkVVNNRTFLSE1VU2FzSGpBRGZHNGxaVTNUUkZm?=
 =?utf-8?B?dlVwcVVobk1QeHQrL2hKU3ZxanoyT1Yvamd3SDVYZytVOG4ybnc4b3R4aTZs?=
 =?utf-8?B?VmJXQ2dyOEdVTmxBaW44QVlERHQ1M2Fzc3ZLMWx2K3hHbmhmUlRXUkdkUWFj?=
 =?utf-8?B?bTRsLzl4czlRODRzaXJkZG13TitabEVNYjBlY3J2NWl3Vkd0T0w0KzVKYjVz?=
 =?utf-8?B?YU52STFBemUwM1IwNkFuT0ZHR2pCY0h4UmhZbmJBTzJLMk5XZEZsbExpZHls?=
 =?utf-8?B?aDNzblB1UUFGbmEybDA1aGQxTjZQRkd4UXZva0JJbm5JYkhsOExpc1MzYm52?=
 =?utf-8?B?UnBIY2FrdWVUK0JQdlg2TDhhT3JKVndzMldZY2dFU2pseS9ZTDdWNHcrKzVP?=
 =?utf-8?B?WG5XSmR5aWdoUTJUSnljT3ZrRkFDanA4SFFvRjN5em0yZHJ5a0dlVTEydEE3?=
 =?utf-8?B?S0F2UVE1WCszckVJNnRmYnByY3k1azZnTnNhKzNWN2RwaitaZDFXNWdrRU5L?=
 =?utf-8?B?K1E2WVRvaG95VGtFZi9wTU4xVWl3OTNxZllrbjhFMTF1aHUvd0dNNG5tL0dY?=
 =?utf-8?B?V3JNR0M5cWlGcXpGS0JOMnhRc3N2T1hWZEd6U2lkL0I4ckt1TGF2QWozTk05?=
 =?utf-8?B?dWpZZll5Nzl1YVZtMGtFdU1rN1liSjBWMVA4T3pLYkI3UGtDbDM5YlFVc1ls?=
 =?utf-8?B?RlBvRVpmVk5sQ0RSUHFYSkUwWlNBd3BvdlVjYWRxcms2MGN6a3ozWUtUMTc0?=
 =?utf-8?B?bHM3ZUtHVlFFK3JEcEV0RmVySm9GdEpReHNIcGYrY29xaGJwRTZRbjBiM29N?=
 =?utf-8?B?aFJWQ2t6QllYa2ZmRUExaWlEdUQyMEVLTXppSm9URWRrekJ3VnptTXQ4STE5?=
 =?utf-8?B?ZWNMY1BjbFJIczhLdVhXNmVvQzVBeUFoeWZrc0FJam1sRlJVbGhSRE1ad1dG?=
 =?utf-8?B?RFpFck8rU1RPVTBMNWkrTHlqc3l4aXJGd3Ryd0gwQUpROFQ0RnIzc1VxbXNk?=
 =?utf-8?B?cW1CSlhKZi9EZUU0dTQrVWFjVFhRcENjdEh5T1hlUEVUdDI3NTFwMERDVXVP?=
 =?utf-8?B?K2tIU3ZKSkpKc0grQVlGWG9PMXNGc3N6NlJKZjdZQWxLTy9SeXQ5Wi92ZkV5?=
 =?utf-8?B?TEVQRy9MazFMVms4RzNXdnNqUjdLcFl2VHJwQ2RISnVnYWplbVUxSGV6K1Ar?=
 =?utf-8?B?ZEFZRVNYZiszNkhrdytKRGZZK0JzQXd5UUlaamo2eXY3eGlKMmJXbHdkRXZH?=
 =?utf-8?B?VjNtNTRmbEdpQU5VbGRWckttRUpxMDgrWURQcVRyS3RYNDNkd004MU9YZnVR?=
 =?utf-8?B?S0RRaTM4OEtGVVcxdjdjV2poa3dhVHE5a2l6cy85bzJUNmdScnhLSmt0TXJI?=
 =?utf-8?B?cTRlQzZtTWVRQ0gxLzdhZUxhMnNkcVRmUmk3UFVwRUxXOVgvanRmQUk0SU0w?=
 =?utf-8?B?aGNlbFV5cWdvbHJiVUxuVFA2WEtNTDlXMmN6cVBnMExONW9xdEJxamVkbjdS?=
 =?utf-8?Q?LTGofomTW6x1FUMg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E44C74203094814FA537A3323250732E@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bb14b47c-d1ec-48c9-7154-08df0cc0121e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 09:11:58.6561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2gHosgfREWkDLiT74zWapUqsx5E3lHTbSu8AoYnmksAbCJQxYQP3fks71EwL691PUqRPjB6kXaoFfgnJKtj+nFYfzHE2eiBZI3/1yAUJZ4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB6447

SGkgSsOpcsO0bWUsDQoNCk9uIFN1biwgMjAyNi0wOS0wNiBhdCAyMjo0NyArMDIwMCwgSsOpcsO0
bWUgUG91aWxsZXIgd3JvdGU6DQo+IFdoZW4gdGhlIGRldmljZSByZXBvcnRzIHRoYXQgaXQgaXMg
dG9vIGhvdCwgd2Z4X3N1c3BlbmRfaG90X2RldigpIGJsb2Nrcw0KPiB0aGUgVHggcXVldWVzIGFu
ZCBhcm1zIGNvb2xpbmdfdGltZW91dF93b3JrIHdpdGggYSAxMHMgZGVsYXkuIElmIHRoZQ0KPiBk
ZXZpY2UgcmVjb3ZlcnMgYSBub3JtYWwgdGVtcGVyYXR1cmUgYmVmb3JlIHRoZSBkZWxheSBleHBp
cmVzLCB0aGUgd29yaw0KPiBpcyBjYW5jZWxlZC4gRWxzZSwgdGhlIHdvcmsgZGVjbGFyZXMgdGhl
IGNoaXAgZnJvemVuIGFuZCB1bmJsb2NrcyB0aGUgVHgNCj4gcXVldWVzLg0KPiANCj4gSG93ZXZl
ciwgdGhpcyB3b3JrIGlzIG5ldmVyIGNhbmNlbGVkIHdoZW4gdGhlIGRldmljZSBpcyByZW1vdmVk
Lg0KPiBjb29saW5nX3RpbWVvdXRfd29yayBpcyBxdWV1ZWQgb24gdGhlIHN5c3RlbSB3b3JrcXVl
dWUsIHdoaWxlIHN0cnVjdA0KPiB3ZnhfZGV2IGlzIHJlbGVhc2VkIGJ5IHdmeF9mcmVlX2NvbW1v
bigpICh0aHJvdWdoIGllZWU4MDIxMV9mcmVlX2h3KCkpLg0KPiBTbywgaWYgdGhlIGRldmljZSBp
cyB1bmJvdW5kIGR1cmluZyB0aGlzIDEwcyB3aW5kb3csIHRoZSB3b3JrIGZpcmVzDQo+IGFmdGVy
IHN0cnVjdCB3ZnhfZGV2IGhhcyBiZWVuIGZyZWVkIGFuZCBkZXJlZmVyZW5jZXMgaXQuDQo+IA0K
PiBDYW5jZWwgdGhlIHdvcmsgZHVyaW5nIHRoZSB0ZWFyZG93bi4gSXQgaGFzIHRvIGJlIGRvbmUg
YWZ0ZXINCj4gd2Z4X2JoX3VucmVnaXN0ZXIoKTogdGhlICJkZXZpY2UgdG9vIGhvdCIgaW5kaWNh
dGlvbiBpcyBwcm9jZXNzZWQgYnkgdGhlDQo+IGJoLCBzbyBjYW5jZWxpbmcgdGhlIHdvcmsgZWFy
bGllciB3b3VsZCBhbGxvdyB0aGUgYmggdG8gcmVhcm0gaXQuIE9uIHRoZQ0KPiBvdGhlciBoYW5k
LCB0aGUgd29yayBjYWxscyB3ZnhfdHhfdW5sb2NrKCksIHdoaWNoIG1heSBpbiB0dXJuIGNhbGwN
Cj4gd2Z4X2JoX3JlcXVlc3RfdHgoKS4gU28gaXQgaGFzIHRvIGJlIGNhbmNlbGVkIGJlZm9yZSBi
aF93cSBpcyBkZXN0cm95ZWQuDQo+IA0KPiBOb3RlIHRoYXQgdGhlIFR4IHF1ZXVlcyBhcmUgaW50
ZW50aW9uYWxseSBsZWZ0IGJsb2NrZWQ6IHRoZSBkZXZpY2UgaXMNCj4gZ29pbmcgYXdheSwgc28g
dGhlcmUgaXMgbm90aGluZyB0byB1bmJsb2NrLg0KPiANCj4gVGhlIGlzc3VlIHdhcyByZXBvcnRl
ZCBieSB0aGUgU2FzaGlrbyByZXZpZXcgYm90IGFuZCB0aGUgZml4IGhhcyBiZWVuDQo+IHdyaXR0
ZW4gYnkgQ29waWxvdCAoaW5jbHVkaW5nIHRoZSBjb21taXQgbG9nKS4gVGhlIHVzZS1jYXNlIGlz
IGRpZmZpY3VsdA0KPiB0byByZXByb2R1Y2UsIHNvIHRoaXMgY29kZSBoYXMgbm90IGJlZW4gdGVz
dGVkLiBIb3dldmVyLCBJIGRvbid0IGJlbGlldmUNCj4gdGhpcyBwYXRjaCBjb3VsZCBjYXVzZSBh
bnkgcmVncmVzc2lvbi4NCj4gDQo+IEZpeGVzOiAxZDUyZDI5OTgzZTVkICgic3RhZ2luZzogd2Z4
OiBhZGQgc3VwcG9ydCBmb3IgJ2RldmljZSB0b28gaG90JyBpbmRpY2F0aW9uIikNCj4gQXNzaXN0
ZWQtYnk6IFNhc2hpa286Z2VtaW5pLTMuMS1wcm8tcHJldmlldw0KPiBBc3Npc3RlZC1ieTogQ29w
aWxvdDpjbGF1ZGUtb3B1cy01DQo+IFNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCg0KdGhhbmtzIGZvciB0aGUgcGF0Y2ghIFRlc3Rl
ZCB3aXRoIHJtbW9kLCBubyByZWdyZXNzaW9uIHZpc2libGUsDQoNClRlc3RlZC1ieTogQWxleGFu
ZGVyIFN2ZXJkbGluIDxhbGV4YW5kZXIuc3ZlcmRsaW5Ac2llbWVucy5jb20+DQpSZXZpZXdlZC1i
eTogQWxleGFuZGVyIFN2ZXJkbGluIDxhbGV4YW5kZXIuc3ZlcmRsaW5Ac2llbWVucy5jb20+DQoN
Cj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMgfCAyICsr
DQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMNCj4gaW5kZXggNGU5OWZlN2U1YmI3OC4uYjZmZDlkNGMx
ZjVmYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWlu
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMNCj4gQEAg
LTQ4Nyw2ICs0ODcsNyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQ0KPiDC
oAkJd2Rldi0+aHdidXNfb3BzLT5pcnFfdW5zdWJzY3JpYmUod2Rldi0+aHdidXNfcHJpdik7DQo+
IMKgYmhfdW5yZWdpc3RlcjoNCj4gwqAJd2Z4X2JoX3VucmVnaXN0ZXIod2Rldik7DQo+ICsJY2Fu
Y2VsX2RlbGF5ZWRfd29ya19zeW5jKCZ3ZGV2LT5jb29saW5nX3RpbWVvdXRfd29yayk7DQo+IMKg
CWRlc3Ryb3lfd29ya3F1ZXVlKHdkZXYtPmJoX3dxKTsNCj4gwqAJcmV0dXJuIGVycjsNCj4gwqB9
DQo+IEBAIC00OTcsNiArNDk4LDcgQEAgdm9pZCB3ZnhfcmVsZWFzZShzdHJ1Y3Qgd2Z4X2RldiAq
d2RldikNCj4gwqAJd2Z4X2hpZl9zaHV0ZG93bih3ZGV2KTsNCj4gwqAJd2Rldi0+aHdidXNfb3Bz
LT5pcnFfdW5zdWJzY3JpYmUod2Rldi0+aHdidXNfcHJpdik7DQo+IMKgCXdmeF9iaF91bnJlZ2lz
dGVyKHdkZXYpOw0KPiArCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmd2Rldi0+Y29vbGluZ190
aW1lb3V0X3dvcmspOw0KPiDCoAlkZXN0cm95X3dvcmtxdWV1ZSh3ZGV2LT5iaF93cSk7DQo+IMKg
fQ0KDQotLSANCkFsZXhhbmRlciBTdmVyZGxpbg0KU2llbWVucyBBRw0Kd3d3LnNpZW1lbnMuY29t
DQo=
