Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020127.outbound.protection.outlook.com [52.101.69.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF83E0230
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134644; cv=fail; b=DGNrGtRFEPd6XEeJhlQQGEJAIzRNlWTVUYR0zQ5ugc0e0iMGTjvihkH/ZQW+A8Of9sglm74p/4CcKRFhUDZsjmiAHUqXWNDjdeDrzPCvAUnAk1QjJ4Bu7K5BjZGzgij0k331k15wzQIicweyIaPSJ8AUBYUm85XKwRhz4Nq4Sn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134644; c=relaxed/simple;
	bh=vJ9CdzTR3yVukEZS70kqtREajK9A8s8HRyKnoFH8+KA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=X4o/suOhNCpm8mUPW488LKMKDqcF+o3njFPNX8NWwklG29LmqeBxwMSROmc9mMdQP2iDEHZ6h+w2K9X9MHaZdYI9wD3qdM7GOn8aUPHxq5nsZiZTBcbj55WAF2Mp7Bim73LS02Is5hWHDeSSI5rIThMFZUn0stAYwxRBYEgsNB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=dirac.com; spf=pass smtp.mailfrom=dirac.com; dkim=pass (2048-bit key) header.d=dirac.com header.i=@dirac.com header.b=VifRrH+e; arc=fail smtp.client-ip=52.101.69.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=dirac.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dirac.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dirac.com header.i=@dirac.com header.b="VifRrH+e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZgllBfq4BWg/qy3u8iFLr6BML9Kr+A9XG+jTi3zYy3pnSe36klKINmq461Y9yjootouEGhFiMZxnr57z4b1+pV53uHJUyziF39ZNHAeZ+ygKrmpOyF1uCOM9ZFE/zkaFeKqxKgVwTHjiAUPHnRB/7MnK2dLZhXExmw9OZeXRFoR2z5y5t6Wjq8sZxxBESOEMvuC6CPrpiIrko7J8P8uvo9mxI4aGqbx4gMwFvUbqbc4MXXGYHfnkvblq3R/82KVg9qjgaYK7QLXrG6IljRxi7rTsuIvioNZ6VFMO9nboU+8DDF0tbaoB6/gGMxrwZm+65llxG+BrQtiWqtbIvWSS5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ9CdzTR3yVukEZS70kqtREajK9A8s8HRyKnoFH8+KA=;
 b=O2v42IwJCsHFNNn+YjqdBg+OnvAt0vH9sTveaS+UnQE+N9tN86qmMkaVqtTjAdrLl3f4EpepsOXcAZMZMHNM04iMjNx13VXpABjOWXu3ZgRlFhYW2S+S+WKcIO0kChlzdU9NaCVhXRGdLjKdkrMYkl9e52cuLIW3LKrrzyyahiB7Qizmq4v8gs5IyGJsDfQkCuCYzHI18FBubrxY4nyGtH+h/ynxCJxmtTNJDQ2c6SwyWm4M0vU7NLAdKSfOkPan40KL0zGz8zvQGL2uXoYQQeFTLA7D6JZpC92LMS7EFpp23//MXNF39DntcEj7lwK5u2BHBXYW0uavvmeRhSGVHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dirac.com; dmarc=pass action=none header.from=dirac.com;
 dkim=pass header.d=dirac.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dirac.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ9CdzTR3yVukEZS70kqtREajK9A8s8HRyKnoFH8+KA=;
 b=VifRrH+eC+ZmaV6bgEUrU/pZpb49Fvb3MtBoSVqLv+0jUjQ+VfAM4Hi3YKNTeRRA6fvx1/mJq3YHZGVBg3rqwJ4QfywmwVQUk2LbZZZiweMHnMwOqA8C29zZlLCwricauHri6Ym3XqlNNx6snn8eqYuSbvrwpNY5VOE0kY6rGPRfsuQup0MdUce2+0PS166fRt+FODVmtVX4aA868bDD6VdJwFTe8DSdEJYlCTHzyfUu1czMA3WL7wx0PKkXfNBG7olEphlAFpqxK4OVuaE/l5MEw6D6CRSP5vF1t0l5cggsv/Fr3699bl4+cVyiXpYi6mvy45k77kNaVCHSXbAYsQ==
Received: from DB9PR02MB6537.eurprd02.prod.outlook.com (2603:10a6:10:21b::6)
 by AS8PR02MB7224.eurprd02.prod.outlook.com (2603:10a6:20b:3f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 07:10:39 +0000
Received: from DB9PR02MB6537.eurprd02.prod.outlook.com
 ([fe80::ccf4:6d57:26c9:a343]) by DB9PR02MB6537.eurprd02.prod.outlook.com
 ([fe80::ccf4:6d57:26c9:a343%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:10:38 +0000
From: Robert Bielik <Robert.Bielik@dirac.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: unsubscribe
Thread-Topic: unsubscribe
Thread-Index: Ad1dPW4IWP2aJxtIS26eDHnjqKAJzg==
Date: Fri, 16 Oct 2026 07:10:38 +0000
Message-ID:
 <DB9PR02MB65376E7F8B77C29DF9410929FA9B2@DB9PR02MB6537.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_ActionId=77a19648-6c4b-4bd5-8110-13c68feeb6eb;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_ContentBits=0;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_Enabled=true;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_Method=Standard;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_Name=Public
 - No
 Header;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_SetDate=2026-10-16T07:10:23Z;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_SiteId=266f25c5-75d4-4d97-8f44-8d816a1f6a35;MSIP_Label_fd3935fe-d888-4438-9b9d-d409c213a7b9_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dirac.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR02MB6537:EE_|AS8PR02MB7224:EE_
x-ms-office365-filtering-correlation-id: 60bdbb05-e8c2-42e3-53d5-08df2b549522
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|4022899009|366016|38070700021|56012099006|10067099003|18002099003|55112099003;
x-microsoft-antispam-message-info:
 FtdPRWI/4lbq3LhiVONVYMaH/Ezpn/T3Z5LRLOfok3ESJwqgM7r1734HpLRCBWxbA8bjVjCve29CdcrEx2YqeuwJV7fs9B7RRhHoEaki+dfUJz6B/tKuTiC2F7lpyy3Ex7wbr8JnsWd83/L1YCmc9gt/d9XSBXeC4qCnipSp0R0zmdQQcs1W5EcBTY7QSvXVtetgVJ5eGLYFDTgDk0xTw/xT0UhzfbqZRM3p9p4kmvxSP9WOmYUyRbP95bjvzLyvTvMucAm2cYRD2AbCddP5sDjGLHsWaSGlIAucGy6X/NRX3hKzVYXkqbYMpRUii6w35wJi0zcM6r6tEAZMhToKkadaoNjlvH5ADARw8wb8SAHkpULqSkmEGx0Chdcuqu5RdW0TbxkZGepGxHvtIdKWOEzN3xKIAuWw02gyoqH2kIndn1HNc3jEhagTCESUekZaI54q86dYM1jQ+GlYkYywSmmu9v/kDdmm0XnsxR7P82cCDN/31XEDQBawJhHboLMe7GkUHvtvAQtL1ZMalmQMhK0kTkztcWwY4OFrtzP7V15a3u9pWz6fsRi4B8bG0RjH+uAuBrH4tCpTwcrK+P9lwX/4VbO+tv866XHVw1oD0KtOXdyPJi6jMSEEuPqBGbjUn7PxBULAY5SRTfrMOAi99lDJiydHe2Up6jJ81nkcG8kaDROVvgBEo1EbJnI1/P1w3Uh09jcZ6flqsDETK+IUZ295MvIy7lubpXOBJHf/WqI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR02MB6537.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(4022899009)(366016)(38070700021)(56012099006)(10067099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NVZINno5L2t2Tk1DZjlYaXNsV1ovNzdXK1JrUmpaa0YzeHNXQ0hVa04zRVRv?=
 =?utf-8?B?dHpaSnhiNWdjY3RYUHFpclJiYkNFMTZZY2d1K09qblFXczVQWjFhUnRDQk5r?=
 =?utf-8?B?bm1zOTVHQ1B3U3FqcGtUYk1yVHlpTUhpYlFxNG1KNndjL3c0eVlxeHMyU3Y3?=
 =?utf-8?B?MW5GRnhlOTRqSUwxNFhQcXB1d1ZpZmp6RjBpSklPYm0xYjZzZjZta1ZzbmM3?=
 =?utf-8?B?SThSNGFhbzdVWFVhMndGOWdZVlYzSEhzZHByRUR5VWp4MkNxay91NHYzcS9Y?=
 =?utf-8?B?Z0ZxeXp3QmM3NkxBODEzcFFNazRCWk1neFpVWjRZRm5GenFrZ09OT284dkt3?=
 =?utf-8?B?NkgyM1BrTWsxUmRKK3lZb3BBSFUreFp6T1pyaE5jSlUxNllZaDdGS3R2aUtZ?=
 =?utf-8?B?V1NtWGRvSHRWZTc2NXRST2RyZzhkT21BZlV0MGRDYkwrZXNGZktnYm9JZkpR?=
 =?utf-8?B?NVRDWkJPVUVOc0RnaWVmc1lCdy9pYTN6SkZwZTdSNG92bFhXL0srdkVEaFhL?=
 =?utf-8?B?VmNZWXd3WndHV1h5VzJZTTVnTFFpeDY5M2Y0UzRGZENQa1Q5eENwekFHYTAv?=
 =?utf-8?B?SXZzRkdWNnlMbm9xSzNzRXlhNzdncVBZVENwTnpJcnpzL3BNVGdsVk42aEN4?=
 =?utf-8?B?VGZJOXZvMFY3YURmRXZPUDZhQUFQSHV4QUdIdWtwM0QvVVA5NHlZZjdhTHE2?=
 =?utf-8?B?SDVEUnJCUkV0ODc0b2UrZEZLVGZYU0R4K2V4S2xmeTg4UGxUM3BwSHZUNXJv?=
 =?utf-8?B?d2tvTGUwclhPcmtSY200TGxUZjl6MStFYzdHdE1rczE0bk5oZDdwNWhmSnF4?=
 =?utf-8?B?SzFoaGZldGQ3b1JSbmJoK3VOUFdNbnFDWnA3YkNrUmpkOVRKRWgxVHBuL3Y1?=
 =?utf-8?B?OG9DNDJham85b291dEJDT2pkNjYxeFBpK3JwUzVsM0Fvb043L1ZsdDZEWk45?=
 =?utf-8?B?ODlOYXREdDJYaG15NEV6MlhVYndiRTdrYkwwaXVDdEphcFREcHVPc2g1WEZB?=
 =?utf-8?B?RXhkR1Excmh2R1JZUGc3MWpJMVN5TmZPMVFvSTZwQ0hDZHVWeGNkWTRNaXFX?=
 =?utf-8?B?enpDdlJSVW84bloySDhndUk0K0o2cEtQY2FOemZXZkdWSGFzK2Q0cjd4a2xI?=
 =?utf-8?B?Snlzai9VZUxUcFFWank4L050TStkVFBYeUlZbXMxSHVoQVNicXFRVTd6bTJT?=
 =?utf-8?B?eUZVZC9Xdlp1SVFEWndlcXZ4cmVqOVNFVnJ3bEZVZzlsWnhJR29ydzE4cjZP?=
 =?utf-8?B?dnBmdjdBL2sxQjBiZXBJbHdTVWdSYmpuZFpVYkE3UnZuWTlScTI5SGFhdWox?=
 =?utf-8?B?WlFLNU9xWmJLK2cyaDVXcEkxQkFJak5NNlBOVll0M1Z1OXhDOEd2OGxiNWhR?=
 =?utf-8?B?UmdjMWVNV2xpTHo3UkZXREk3RGNBY3dhaTU0MW42M3oveStWZGVUUXVMZnQ4?=
 =?utf-8?B?a1NiYVcvUE9SYzNMMDdqK012TG1KWlUvN0UzejlkdjlERTdFY0RGRUFwbXdP?=
 =?utf-8?B?SFlvSHYvVkh2aVZ5cmJNQWQyaGRjOERXRUVUVjlqaEdsMGpQQU1GMFNGS1Yw?=
 =?utf-8?B?REZiTWVxV2I5VDBBVXZPS2pBVThhZEtpUnM2NDltTUdZZUpNdjRpeDJUQUxx?=
 =?utf-8?B?TGNqUkMybXFXa09WYzA2UGZ1KytUKzBncHRCMFFmZWhOeW5QNXBwWm9xS2U1?=
 =?utf-8?B?MHE2VXBmTXpQWDNXeEdYZ1kwcEg5Q3NSdjE1cXZHZmJDOTRuL0NyR2pUNDVh?=
 =?utf-8?B?T0grdjAzSW9raXoyMU55dVhJT3pYMHVDZmVBeWRwbHpPWXEzMVMzTXRHMWVo?=
 =?utf-8?B?d2NFTllZVkYzcVVtUUJpSlVKMXZhb2J5OHpEVzF6NEJuY3lOaGZHSmZLclhH?=
 =?utf-8?B?R2dRV1BTTFBFNDNUOFhLQ25rUFFaRVVZZ2l6Y1BST3JCY0s4S0FHTzlnemJG?=
 =?utf-8?B?THVqRGdsb29TZXRzQlFnUUsrOFZkbFY1UjhPb24yLzkzWm5hSGt4b2thNTJS?=
 =?utf-8?B?M3ZxelpMUm5KWitkOFd0QkozMWZWcHgwZmx1VDBNYWErT2cwRXFWbEJ6Y3Yv?=
 =?utf-8?B?TTU1R0M1RzJTWDdKYmVTNncwSmVEb05qQVBZYytsaHdrd0U0ZmR6OEZwbEJG?=
 =?utf-8?B?MDFWcjBSdTMzL0NJNktIamxXOU5jVkNJTEV0dWNSZXNraCtLUEFiUDIxS3ZT?=
 =?utf-8?B?TXZwOEM3UzUxSjdkODlvcW41eVZBWUdYeVhSZi9YbVRqUXA0V2tBSVZkQVR2?=
 =?utf-8?B?cWVlendYVGlTWmtISzdyeGpmSnR2eVRIZDlJNFJDZTl6ZGYxdk9pUEdHcnV5?=
 =?utf-8?B?eG12SHpocHN5OVpGSFlWRTA0YmFRNklubnQ5aXJ5U0owQ3FQSjJvQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: dirac.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR02MB6537.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bdbb05-e8c2-42e3-53d5-08df2b549522
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:10:38.9137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 266f25c5-75d4-4d97-8f44-8d816a1f6a35
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+cp6sdmnigWqdtezOcKvI9uG/I6lNVT//IDGjk0zcwkj1jf6zV/C8Z0pxBwvKaGPPPxQrAmOwqLMMcNdEMV9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB7224

dW5zdWJzY3JpYmUNClRoZSBpbmZvcm1hdGlvbiBpbiB0aGlzIGVtYWlsIChpbmNsdWRpbmcgYW55
IGF0dGFjaG1lbnRzKSBtYXkgY29udGFpbiBjb25maWRlbnRpYWwgYW5kL29yIHByb3ByaWV0YXJ5
IG1hdGVyaWFsLiBBbnkgcmV2aWV3LCByZXRyYW5zbWlzc2lvbiBvciB1c2Ugb2YgdGhpcyBpbmZv
cm1hdGlvbiBieSBwZXJzb25zIG9yIGVudGl0aWVzIG90aGVyIHRoYW4gdGhlIGludGVuZGVkLCBh
dXRob3JpemVkIHJlY2lwaWVudCBpcyBwcm9oaWJpdGVkLiBJZiB5b3UgcmVjZWl2ZWQgdGhpcyBl
bWFpbCBpbiBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGFuZCBkZWxldGUgdGhlIG1h
dGVyaWFsLiBGb3IgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGhvdyBEaXJhYyBoYW5kbGVzIHBlcnNv
bmFsIGRhdGEsIHBsZWFzZSB2aXNpdCBodHRwczovL3d3dy5kaXJhYy5jb20vcHJpdmFjeS1wb2xp
Y3kuDQo=
