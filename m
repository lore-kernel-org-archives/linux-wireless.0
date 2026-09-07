Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013061.outbound.protection.outlook.com [40.107.159.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830239183B;
	Mon,  7 Sep 2026 06:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762059; cv=fail; b=jFfjpZ/10d6bwEoKfrflaK5Koe5ZF22vKe4aCt51tJu+ig8I+3pWXkLQ3oT4Y24GFaf7p224vAoCBW7Gz2V32dQhjv+bRDLa+OBl+zeKQWE6CODcCZULUva+aVnwqt+o75kLG1zR+DAyiEFCYbVUWXZPtxnCaab2be5R3K9uqmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762059; c=relaxed/simple;
	bh=wbcb+ZPOGz2BB3jERENhvam/bb3z+vO06cIDuWa76Ig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ef4UEZcnEsJ1XXgFUEN3vkb70EJSfMjnbXeisqta/nYbkpFeXrFcqtp59Zl6qE0ljuR8wr8tcuTw1ubu9A0T4L9sm4zRkj8P6BhkO8DBELxkNyUmHlyVVC+NomxbARcE8TGvj/udM4K8w1NjsCXmeu/1g1CpSZBgqP8/lsGbrdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=ohJN2KrT; arc=fail smtp.client-ip=40.107.159.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="ohJN2KrT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bIm6e0PWwDvLUQHNMU+aHKua5Sn7QH2Yzf3mx1g8Z3PEeY9rl35ably4J8b8Jpf1yI8Kj2eMWXQq4qwaG/2HzCFDBZsaf/1bovl507vVQMqTFK+8wqozL0qgOCoQAmJK/DSrPC/Jzp1a57EPE+38Tq0WEuTFNMB5x3CEHw3MUk9DIHZJpcAoxxoFTj7wRDLsfZXXAbncsm/BmB0siwjQLDqi/pwE1+mRbf+kJkB+uheb0tRbDrhDPwBeaWuzZhHeJtffp3ZCVrN42GvL+OMbsCrXp0prmDlSfn7jAcEb8VqZCxkCCCURQ7jY9E4WpbASkJWkKFbDPyT2bkKetLonCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbcb+ZPOGz2BB3jERENhvam/bb3z+vO06cIDuWa76Ig=;
 b=aAVWfs7/e71LJ/UU0ZYW1Ux5eZVLlDQOj19KHI+5+ubQCx9+9zSc8k86Ms3C9rLEVd6qo7/4PIe1MRfJ8RnXPRcZ3LqlDlt3ng56EcWQm7ul9/H8IAH3/A+Q/zAOAtmFK8qM7bxKwG00rhdpi9XoTgIVIVF+az9SZ0YbZEZsZoYdCL8iik3Rzhm3HcrjrTBRN7wPk/UUQmy9IcFKMEKE0DMPdFsQoxp53G0hWZGUU0AckuqfYihGCb/1bIybGlnSX47vi0+lPfkz4RGnYnstOhJj+jNC11DVK82Qq8h6P4N2D0gc7JOQqV1bX5277K8jdEG6DetD97+1w3Em8JBu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbcb+ZPOGz2BB3jERENhvam/bb3z+vO06cIDuWa76Ig=;
 b=ohJN2KrTVWJIFFj8tjjxRvlop2XlBsgl2INangNQUKArWcPanzerrbpxG/pIj7kdIM5G/fvYmGhVrG44Wav8+NY3WfD49o/mZFtbkYGHB0GQdpvdDefByCwLjEMZ9yuHS20cOwrLLZsrdj9+95f4KhqlYi7DKc7UkmZavP5qjNWn/eOWwVDIj/fyKgoAGgIlDiPb0Vy+I7D8MuvwtmPZSatyG0fg+swkrVZ1udQNBZsw6IlJTzZh7ExDWj58FObV4HnL19VfJ1WvIdNGqpTkaXPot5E/79GFZXWxeB1ZPFBSH+2fqjQtH/dtTbysF0Gh4WUnKxmG8KjYU3u1+pF6LA==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AS2PR10MB7576.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:547::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 06:20:54 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 06:20:54 +0000
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
Thread-Index: AQHdPkElQKU1Z0Oid0ySBfSWgVrH27bCpY+A
Date: Mon, 7 Sep 2026 06:20:54 +0000
Message-ID: <afd87cc3d8703bd107740396a8b38d3a24720335.camel@siemens.com>
References: <20260906204831.949692-1-jerome.pouiller@silabs.com>
	 <20260906204831.949692-3-jerome.pouiller@silabs.com>
In-Reply-To: <20260906204831.949692-3-jerome.pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AS2PR10MB7576:EE_
x-ms-office365-filtering-correlation-id: 73905936-554b-4f06-2392-08df0ca82c26
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|4022899009|11063799006|6133799003|56012099006|4143699003|10067099003|55112099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 Ee1xfiyahkvH5poYCYqyN/XfEH+UMSNZhHST1+gUmhj6Rhat1qHnbEeXh4R2P5E6/z5T2M86MsrYC9RSXzTg1vl4P3z2Nrwuv/Uf7rEvpBECHMr3PkJm+rQ8xrdPk/NgA2Du6YoBSSsOhm7xpya+Is35dsiI9OdWI+7z9ri+Xp8mE9qYGtYmkEyPpmv8y2owGOIOlvdfIAEtjXUIQZvnRdKDbpdHRkuPe8ksaHXyev1y41LLH0pa+tYOxivyMGYyEfCuSs+ArB7rzZQodlq0sVX5aZkb5JnfzXgTVD1kvs1T8R+u/I27GLHbxUekRXBdSwdWlMHBXrO1mZ6ePzIp5F0YJLPdyVlsQIJx3tzBTH/r45oFP84TFO6emV+P8Fmpr15h5hD5FtVP73PP5qmcJuyVMJYeCP2QG44D9nLJQULDn74WRjKzRdj0Mr+2PLkyPDFC8mAjCCw9cF9xXV90T6meVeaVJmMH2igooa/8HR8ZfhJ5q9Mz4rAxnvN6gBWXM18NMx+CVNgUqyDMUe4wUHGIpLAt6/TOGsKFH+ow6uckvXqOCdPB2ChqB8FAbW8r85YdDao/CaAp5cy5YplN66tchiZpPBUzF71uESWlokvERqH/zpLMA7X6FkhwGNG9Enb0durtbNwtq33yV2zeiFXQl1uWUEO1D2hrV3KZrzc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(4022899009)(11063799006)(6133799003)(56012099006)(4143699003)(10067099003)(55112099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkErYm4vZkhORlVtU1pFQXppQVNTS2hGTThSc2M5TlBkRXkyMDhEK3FKL2ZY?=
 =?utf-8?B?K0JPc2psYTlmNlg4TkoybFhHdUhHOHBhOEVXR016Ky94OGNiYzlsZ3JnaDVj?=
 =?utf-8?B?UDRIUHVxM2R0dm0yMTBMVlU4VHIvdnA3Z0pMZHZaNnpuVHpPQUphYjRPUTNi?=
 =?utf-8?B?VFM0YUUweUMrZ3BmQmc0ZG5XdDlSQkR1NXVJQXBpOVdGbHZrUXA5MFBTVERp?=
 =?utf-8?B?akEvcThSYU9PcnFyaFdGSXU3bTAzY1dZOUttU2dnKzFUUkxkb01PN29TWFZP?=
 =?utf-8?B?U0ZHZHR6azZMSk44dW9nRUZTQVhKWTZ2RjE3cUJsVEt1QnhJcTZYZDIweVha?=
 =?utf-8?B?N2ppcXNsK1NVMSsrL1BJRGIycWdKd2xGOExRMy83ME9DNUJMODFocW80V3NX?=
 =?utf-8?B?WSs1RDJ5YUxzd2hobHZ2b3VpblVaa1Y4TDNPZE5oclFJRG5rMkFieDkrZUhq?=
 =?utf-8?B?a2dpNG5IblMxOWJ1V0V3RUx6azFqZDZyQndpdU84djRmUytsQk9hQlZqbU44?=
 =?utf-8?B?M0lVbEZHenZSRzE4WHF2NUNkK0RQS1lVa0krUEhTNlFhbjJpY3lYU1dkdWNh?=
 =?utf-8?B?TXJUaEtzMlhrSHBMU3E3Z3dlNmZjWEVGSG1IMW9GejRqTlJySGxaKzFLRzB0?=
 =?utf-8?B?UnQ2eW9uMUk4YWlLczEwN1F1c0VLY2UzRGN3VVVIeGViVCtCanhhczhtS1Vp?=
 =?utf-8?B?YXgraFEyd2t0RGtIdHdIVG9udkducjlkNDI3cGRtcEhFSWFSTmFiek5vZGNS?=
 =?utf-8?B?TzBCd1l2SVZ1M0VuVWFqZEJFREUyVHU3aWo3bFZKODg2anBuVjFXM0NTUG5w?=
 =?utf-8?B?YzdSbVZ4VThYNWQyOWFOS05XWUhUKzFYOEFwckpCN2pwYm1tQ29DVU51M093?=
 =?utf-8?B?K2VzcTV1d0J1M2MwNnFMZGVCMElmUzhKUUl1dVhaRFJRUlZBNnJHWFpTcTlo?=
 =?utf-8?B?K2t5NEp6VTE5ckxyMmh6eEFpa2JOQXVRQ0pTWWRQeFFSN0RVQ1QrMXNVZXhM?=
 =?utf-8?B?Y3hFY2kvenV2dlltQXo2eFJCd3RmK0VycndlYTViQlFqcGEwTzJCalljNTBx?=
 =?utf-8?B?OHp6a2o1aEJ0TXdubmJGbVdlVmltKzMwd2F3UUlRR2JZdjZjajdkWGJjVm0z?=
 =?utf-8?B?eC9iSjllWnhTNnBmcjd4RDFsSExMZ0FLc0VkZVNsN3FGMGZhWjltaGlwN2pQ?=
 =?utf-8?B?VEVTZXUxTmxZOG5KNStWWm1tUXRSQWt5aDR3YjN4Y1QrVTlVcEU3REZ5L1hN?=
 =?utf-8?B?b1FwYml1QXJORjl6WE9ETi9OOW9tSi8vSXhYa2tyOEdaMDIxcDYxcW5RSXFs?=
 =?utf-8?B?MTUyRHo4UGxtTDdmWmhlSVJYREp6Qm4xWDRNbFEvK1pRZEdYUFZnQWVQL3pS?=
 =?utf-8?B?ZGc5cnROSmMxTkozUzJVd3hMWFpBcU54M2NyMk5sMzhieTZIZ2E3enVIZmJx?=
 =?utf-8?B?WVBoNG5IVno0SUlFaGtKMXB4WDZEdHhHMjRhVTZ6ek5CSVJRVDR2VUZMdlVI?=
 =?utf-8?B?aXRwTEZrc2w3dk13bmlWaFRhcXNDVHZaclZhR0RhTGNabStOV3RwSWhHVUFk?=
 =?utf-8?B?U3NNVG5FbWUvclBBeUhRYmNpSjNqckpjeGg0dFpaQ1BpRlhKSHA3a2gyWkw1?=
 =?utf-8?B?c1NHTlY3bmVhMjMvc0RTTkc2Ymg5a3dnTGcyVTRhUUFhMmcydUhSQlM5YWRw?=
 =?utf-8?B?emhXdEY0UDkvTEg4V2s3WjhGaGwyQzRvTUxLaEd4am80OUppeVpPR1lxL0NO?=
 =?utf-8?B?VlpGWWNBcXYwbk1ZeGw1akZrQ2lTTVNHVFV0OTBwTE9mZUZxY0E4YzVMdVJE?=
 =?utf-8?B?M3IyMFpXeDl4d01VeXhtVmZ2RDBaZHY1UU1OVU0yczZzbGRHamovZjJzM3U1?=
 =?utf-8?B?a1VKdGovVmxHdEpGcTNUTFkyNWU2Y1B5WTJGcS9BSjI5Nm9EUTMxUWxlU3Z3?=
 =?utf-8?B?bTBrRmtwN3ZJaExaTDhYWkRTNTFpWm5pbW9IU2wraVpCekRhTWVuYTRjT0Y5?=
 =?utf-8?B?OGhsdUdJdm1kOHQ0cWZocmpUczFGLzhRWUpORzluNEF1bThwU1l1bHNsbDhk?=
 =?utf-8?B?V1JRcDJaUVBtWnlPYkpiQjhpNnY4KzNZVnNSSzFvZS82d3Z1dUo3SE04MnZY?=
 =?utf-8?B?M2VCdEptYWVvMUZhT1phUkVsQWV0T25qdDc0VWU0ZmsvMTRMUTdZZHdGYTlv?=
 =?utf-8?B?M3pQSElTYmhHbjg2eWhXREUyenZjRTA1SXppeW0yS25pSW1qRTRzYWs3Wnk1?=
 =?utf-8?B?OFBIZWNMdVZQTFRLaXlsb0VCa2tFYUdzVWxLOERWM0l3b2FmeEJmNUhZYzdm?=
 =?utf-8?B?b3cwREY0S3hpRUdFaExjTUJTMWExbEY0SzB4eW5oaWRiWmNJNEhqcGJEWk4x?=
 =?utf-8?Q?H7jboXoOpreZaqFE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A02B1715C42B44782743BE4094B6615@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 73905936-554b-4f06-2392-08df0ca82c26
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 06:20:54.4336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIcFMyBJ6wh0Bh6mRh3XVAhnAAlmQKoij8VmYdR2oWX+E583Gydhng6r6IEWE34j136Wd4FuaqYi8hJRCfqpqRuSggxJ/4C8ZqIDIpWHMW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7576

SGkgSsOpcsO0bWUsDQoNCk9uIFN1biwgMjAyNi0wOS0wNiBhdCAyMjo0NyArMDIwMCwgSsOpcsO0
bWUgUG91aWxsZXIgd3JvdGU6DQo+IFRoZSAnc2VjdXJlIGxpbmsnIGZlYXR1cmUgaXMgbm90IHN1
cHBvcnRlZCBieSB1cHN0cmVhbSAodGhlIHJlZmVyZW5jZQ0KPiBjb2RlIHJlbGllcyBvbiBtYmVk
VExTIHRvIGltcGxlbWVudCBpdCwgd2hpY2ggaXMgbm90IGFuIG9wdGlvbiBmb3IgdGhlDQo+IExp
bnV4IGtlcm5lbCkuDQo+IA0KPiBJZiB0aGUgZmlybXdhcmUgZW5mb3JjZSB0aGUgJ3NlY3VyZSBs
aW5rJyBmZWF0dXJlLCB3ZnhfcHJvYmUoKSBleGl0cw0KPiBlYXJseS4gSG93ZXZlciwgZXJyIHN0
aWxsIGhvbGRzIHRoZSB2YWx1ZSByZXR1cm5lZCBieSB0aGUgcHJldmlvdXMgY2FsbA0KPiB0byB3
YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoKSwgd2hpY2ggaXMgdGhlIG51bWJlciBvZiBqaWZm
aWVzIGxlZnQNCj4gYmVmb3JlIHRoZSB0aW1lb3V0LCBoZW5jZSBzdHJpY3RseSBwb3NpdGl2ZSAo
dGhlIHplcm8gY2FzZSBpcyBoYW5kbGVkDQo+IGp1c3QgYWJvdmUpLg0KPiANCj4gd2Z4X3Byb2Jl
KCkgdGhlcmVmb3JlIHJldHVybnMgYSBwb3NpdGl2ZSB2YWx1ZS4gVGhlIGJ1cyBwcm9iZSBmdW5j
dGlvbnMNCj4gZm9yd2FyZCBpdCBhcy1pcyBhbmQgdGhlIGRyaXZlciBjb3JlIG5lZ2F0ZXMgaXQg
KHNlZSByZWFsbHlfcHJvYmUoKSkuDQo+IFRoZSBkZXZpY2UgZG9lcyBub3QgZ2V0IGJvdW5kLCB3
aGljaCBpcyB0aGUgZXhwZWN0ZWQgb3V0Y29tZSwgYnV0IHRoZQ0KPiByZXBvcnRlZCBlcnJvciBj
b2RlIGlzIGEgbWVhbmluZ2xlc3MgbmVnYXRpdmUgamlmZmllcyBjb3VudCBpbnN0ZWFkIG9mDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXg0KbWlub3I6IEkg
c3VwcG9zZSBpdCBzaG91bGQgaGF2ZSByZWFkICJwb3NpdGl2ZSINCg0KPiBhbiBlcnJuby4NCj4g
DQo+IFJldHVybiAtRU9QTk9UU1VQUCwgYXMgYWxyZWFkeSBkb25lIGEgZmV3IGxpbmVzIGFib3Zl
IHdoZW4gdGhlIGZpcm13YXJlDQo+IEFQSSB2ZXJzaW9uIGlzIG5vdCBzdXBwb3J0ZWQuDQo+IA0K
PiBDb3BpbG90IHJldmlld2VkIHRoZSBjb2RlIGFuZCB3cm90ZSBzb21lIHBhcnRzIG9mIHRoZSBs
b2cuDQo+IA0KPiBSZXBvcnRlZC1ieTogQWxleGFuZGVyIFN2ZXJkbGluIDxhbGV4YW5kZXIuc3Zl
cmRsaW5Ac2llbWVucy5jb20+DQo+IENsb3NlczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
L2NjNGRlNGU0MGUzY2E1MGU3Mjg4YmUyYjkwNjc4MDI1NzY1NjdjMjUuY2FtZWxAc2llbWVucy5j
b20vDQo+IEFzc2lzdGVkLWJ5OiBDb3BpbG90OmNsYXVkZS1vcHVzLTUNCj4gU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpSZXZp
ZXdlZC1ieTogQWxleGFuZGVyIFN2ZXJkbGluIDxhbGV4YW5kZXIuc3ZlcmRsaW5Ac2llbWVucy5j
b20+DQoNCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMg
fCAxICsNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L21haW4uYyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jDQo+IGluZGV4IGI2ZmQ5ZDRjMWY1ZmMuLjE2ZDVi
NTFmNmYwM2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngv
bWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jDQo+
IEBAIC00MTEsNiArNDExLDcgQEAgaW50IHdmeF9wcm9iZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikN
Cj4gwqANCj4gwqAJaWYgKHdkZXYtPmh3X2NhcHMubGlua19tb2RlID09IFNFQ19MSU5LX0VORk9S
Q0VEKSB7DQo+IMKgCQlkZXZfZXJyKHdkZXYtPmRldiwgImNoaXAgcmVxdWlyZSBzZWN1cmVfbGlu
aywgYnV0IGNhbid0IG5lZ290aWF0ZSBpdFxuIik7DQo+ICsJCWVyciA9IC1FT1BOT1RTVVBQOw0K
PiDCoAkJZ290byBpcnFfdW5zdWJzY3JpYmU7DQo+IMKgCX0NCg0KLS0gDQpBbGV4YW5kZXIgU3Zl
cmRsaW4NClNpZW1lbnMgQUcNCnd3dy5zaWVtZW5zLmNvbQ0K
