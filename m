Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA482FC876;
	Tue,  1 Sep 2026 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259406; cv=fail; b=LYHdrlBq2EfUASPuM/nhmdWB5KsVq570oiejK9Zxb2FwnoUneoCKUdHKm3Wf+QhYBZpn/WjJ121wjtKF0q1bJg50FO35UNl3O1YIv8pVMb4fToz01gs+79Bf/fvj/soRAxtVrur5wLCoG2Q1xfO0KYv6y2gX7xmxmBwBAfdlj5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259406; c=relaxed/simple;
	bh=jm0wKMj65OMEvwS5MPeRVP3JKvkOk0LWtBimU95z8fA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fMy3RNM32eUtnbMl5a4vLxacEezT+AHUC74WHAx/mENapGCxs6aPJoWBUEgB+TLibVTYLSQjUtrO9cwf+nFwc4/vAmEQkiVYYwUa0Rmxta9S62utASdD0kq4dIOqVxhIxx/KTQBWbBuFJkkBqNl73R/en2NtPobrmJyiIF6lQts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=HVfGgbVX; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="HVfGgbVX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoQ8bWR/fifs8OYtucPwspBzEyWHg/earjSptB7uoU+gnjBIKu6dqeVYSKvAWtKpPd+i1xelkyv7n4SDWuEtlOC/9yZmKQ3hfovxD+UANRKvtkwp2mfn4STBit2zorNbCfsoS9Szwwpr4EgeX7Dq1iCrBFzmrjlVWdByPWPm+kL1O+CDd2fwjP2tp9i0QK4tGJX4F0OmW7r/QX7btOtoOWZWk3glZI/PHMv+MEAhl3Zx2pALgiN21zcCbww3TH5elSgMSZCPMqmrQS2RzS1WYSKXOLwCRczWELckl5RInTojac61Gon7denZK0srso1Lu+dNHMAXktfgwmf5iqCyWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm0wKMj65OMEvwS5MPeRVP3JKvkOk0LWtBimU95z8fA=;
 b=U15cG3K0Z12GLACTFH5CvMN6LzU7+QZ6UGlgU+rKk4kzyderXErp0HILcLaxr4KB2LMfSpqS9+x2sK3eBSjK5HqsZHvgk7HXPKGygaIInqcLlAD5F7iFLRTDtSjuRIGTtzZfmy19KftTTKqnF/LRQ4v6oX+4h0/KCvaNbXR+bfTmNIjRQAZX2pd/u3Z8+BWJJi/bi2U8GzA6LVgCNkd0WZ6l5jDxhqfXdMj0UgjPmUigJRJh2edRfzfjVUKvAnNkAZGo+wsbuU+QPZq6tjSDaCTzQDWgkzPqSLC5XvSafjnXAwgn98hawbnfK8HUE0gTVXWpabRM59BryCCDSA6Bfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm0wKMj65OMEvwS5MPeRVP3JKvkOk0LWtBimU95z8fA=;
 b=HVfGgbVXmgaO3iENCDSpB/ucqUbxweYg2FCdw33NVYaB3l+whXdEDq6ANvCLlm+SQymtAOqiaPqtchD8Q7lTLy0jwCkcP3Zl8YknMAm5Uc+cOgsy2IcgKXXnyHMgYoYxQThGezK2Xq4J3nwDnQFLHRay5Su5SL8ai3N5CfUbm0UtybFXsdDdWZ4NFFkHVpdLrBBELFRpkemC0P8Pgf7SBj3981hdTc4N94YMqLSKgUftt87AHOnIrde2DSWkGAzoz6R/RhU9d2fXsN/GKU2JFwFXY/12gAKWnk21xxIeaR4Pv3C95e0f/9XDjIZ5hNHAdnCdI+DiCHlFUZdN4gLyyg==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AS8PR10MB7898.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:63c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 10:43:22 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9126:d21d:31c4:1b9f%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 10:43:22 +0000
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
Thread-Index: AQHdOf61ROW9oNnohUyNV8CU6ceGeg==
Date: Tue, 1 Sep 2026 10:43:22 +0000
Message-ID: <cc4de4e40e3ca50e7288be2b9067802576567c25.camel@siemens.com>
References: <20260901083548.113131-1-jerome.pouiller@silabs.com>
	 <20260901083548.113131-2-jerome.pouiller@silabs.com>
In-Reply-To: <20260901083548.113131-2-jerome.pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AS8PR10MB7898:EE_
x-ms-office365-filtering-correlation-id: 43d93903-5778-49b3-eb6e-08df0815d808
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|4022899009|366016|1800799024|23010399003|376014|22082099003|55112099003|18002099003|56012099006|3023799007|38070700021|6133799003|4143699003|11063799006|10067099003|5023799004;
x-microsoft-antispam-message-info:
 gO2WvSLyr8vwm8rH8YO4jDIrWwDtgd2qNI9Dm5WfZe+4UwvqmKtQmgp9hYxn+s5bZRKhoNE+5lduXYiayvTbZcH6wpv6KIas0PXO9NEwmSi0h+X3voE6cU1Mo09pMexPMlLapcwSdswrEM11JtjXo2yIbW0u5CUshLUovKl1qMniPEAe1h8ckhwrX3irIlwIvmGlJvzu+C+sbucjOVgJWCMfeYcjvMxPYSmC1TPsngxaIlQIy/AdEHLUfGST49XGOKZnRoK8sTrr62Hp6eEDvVgrfnmvXkpl6on/5bR82WkPI3cP1BsKyjw0/Q4HvhaJELW6TFzBCX65cP+UDvTMkrcTdgQtoAX7uN7ATAmQ3WQG4UX0fAhp6iHJySCgFNSk7n+RQe4k30o2c5yEPo+bq2QB7gViCmYtzVeIlCFKMiP/qYYWnBq9Py8RAqt4/Id4xu3lmqajoKn8SOvKksb96SYE4nK1iXUz8R1YHfh6OF/8TrMq3kO/pMbfhGVIpTcrd4+m++sP46nuKFDPa1L8rngMn2Su28sRNkI3XCgAj7wnvF6xI+pUK44J28xUJ2Tdsxi8K4cRi9l5jWO1cTWV/8mZe+peoIeYd1pmxnNzLXHLSLk1GT2OnIfnA13I48r/rqXAw7EJ99HAoIBF7oDJ8gv+x6QAxdgmcwm1qxZy9pk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(4022899009)(366016)(1800799024)(23010399003)(376014)(22082099003)(55112099003)(18002099003)(56012099006)(3023799007)(38070700021)(6133799003)(4143699003)(11063799006)(10067099003)(5023799004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NHRrak1LdTdGT1IwVS9tNFd6WUVlUmVOajNsZnNCazJrYUNUVldlTVgyQTcr?=
 =?utf-8?B?SVhuc1F1Vy95ZzRpQkdNTThNbmFoMWg5ckZYMmNzRENNQ1YyNzJidDFQNFFy?=
 =?utf-8?B?T1BHU3c5c0J2V1dZRHhZMDI4TGZGWXZIM0xmU2lSQkdPK1lVcGNVMWREMzBL?=
 =?utf-8?B?ajFCcDlPU1VjMzNlOXlLamZLMGRDNWRHU0sxZVdKWUtxQXJvYVdnWE9PMkRn?=
 =?utf-8?B?dHdJVEJraWNmZEFiNlFkU0JKa2dWeWxUOUZUakZwTFlxSGx3MmxWUGI0eHpo?=
 =?utf-8?B?b3NkbkhDN1hkeXZYM3RTUmhKWWNHWUdHdUVrZVZzWlRGNXNtTkdHZ2I3ZU5R?=
 =?utf-8?B?bjBJYWpBRlgvcDdqSGpIaW15RzFJRWtXOEhrZE50K21oWC9DbVhreVl0R2JL?=
 =?utf-8?B?dkFWZ1JRSHhNL0E3UmxMaDhmRUV6Wm04aXRSdm9wZ1hlWVMzZHFab053Qjha?=
 =?utf-8?B?ME1OUnhMZ2Z3T04xVm9OK3BIWmhKb2J4L0RERklGMWFGRmowMEtYSlRiSFB3?=
 =?utf-8?B?YURqZjJBQjVYVTU4MWEyOFNNWDJ2OXFPaHNEM0VpNU1XV2NpZU5hYS9WdWFZ?=
 =?utf-8?B?Y2pXWTlyRkRqbWlEcTZ0YTZ0ZTJlaXZkTUZodWxTK3JwVkZFYktGVm52WWhV?=
 =?utf-8?B?VTJOQW5VRXRGRVFGRTNvY2xJV0x1UnRWeHExYnZlRHVKbG81VXkzU1I1Y1hk?=
 =?utf-8?B?YitjOURiVytCMERCSmg2OFlrcitrV21NTkZmQVNnTXA1MklsMlVDMnNGZmg3?=
 =?utf-8?B?V3ZrR3ExR1plckRvZWdWZ2NiTWR4WlBEUHYxeU5nRndDZWxPRnJFMXlhWStD?=
 =?utf-8?B?Ykp4bkRKaFZlQXc0YWdCYkhYdXZja1lqSzhjV0ZTMWw5M3JpU2ZLQXhqMjA5?=
 =?utf-8?B?Y1VNV1hmNmlPYVNIakFGYUNKS1M0R0FDQUtOeCtOZ1ROZmI3RWl1YlBISjNE?=
 =?utf-8?B?a0ZBc1M1SjFHdzlPQVdNVVZ4RDVGVjRYVFlER1EyaDJLaExsQjZsa1VZRGpN?=
 =?utf-8?B?L3pKRnFWNXVQMm90blZ6NUZCM3lXYVlZdjFGSkVEbUk1Q1VpZTBjcHpkbmIx?=
 =?utf-8?B?dGNzNDg0NDVCeGUydmF0K05wb2xHRm9pbW4xNWxjRmxxVW5LUDM1N2E1M1VM?=
 =?utf-8?B?N1JzN1QwR0NOaWx4STgwWUg3citjcnNDY3g3UWlPb3Urd2Q2YnFYZEZQblZI?=
 =?utf-8?B?Q08rNldWUG5HQ2tVTjFVZGJWUGNYdHk2Z3lLdkFvNHJkQzFmWkRiWjFuMCt4?=
 =?utf-8?B?YzJQQzJPZnRLaUZrMkUvZE5HTk1vQjVGUENITU5VZ1I4emZwUEVsWTRTd0Zi?=
 =?utf-8?B?cGJIZjg1YmFYblJEcTVLdDlvS3dFUHhDeE9FR1RCd25MZnRmZnpqVXpLZi82?=
 =?utf-8?B?dTVFTlByWnowZTA2RFpzbElPTU44b0VmaDJGOVRjZ2RxNVVQNFlHenEvWkFo?=
 =?utf-8?B?ZCtIb0JJYTZmblhmVVU2OVYvNjFYcjRDR0ZxWDZiU1A4Z0h6UzhyOWNxUnJr?=
 =?utf-8?B?aDd1U21FdE4zSU9xd0tOQ1ArMzBVZFpkUFAwWXN5bk8zYktDOUZhWk5kUW1l?=
 =?utf-8?B?RVhZWDgyYTRMdE5FUFEvQmhhZTFqR2VoajFpNURLZWduamFpMlBiY21YUFQ4?=
 =?utf-8?B?WmxVWC9DWE1ycENYMTdlcU9QR3pMd2VlL0I3RTlsbEhwSk9WRkdDdjJab2tH?=
 =?utf-8?B?SzdIUTN1K2MvYUlPRjVuczRuK1RRUGMxZ0lCc2YyYjRrempHUGVjMm1nQ2Q0?=
 =?utf-8?B?MTNnVEVPa0drWUdiU0I2QVplNmhMeXpPWkc2cmJHTEZGOFM5Qm5TN2d1TlNt?=
 =?utf-8?B?S21BVzZaZHhtczZRdURsSmRoeVBISkJweHQySHplUStMcEUxUnZ3VHNoZXA2?=
 =?utf-8?B?L0NsM1czai9NTDVUZHZZNElaZGF0UDFUVXFLdVJKWFhFZG9wNnN2T1N0MkdF?=
 =?utf-8?B?ZjNDQ0lFTm9ML05CQzVOK01kY2UrUHRpc21wb2FoYWlQNDY4aFZ6b2FJamNz?=
 =?utf-8?B?WHA0ZXJ6UDhCdXNPTHI5Z1g0V2tlSU1ma3owMnFSL2ZyRHdCYzNxUjJqTks0?=
 =?utf-8?B?UFNKbnFQQ29kQ0pNL0VzSmhLS3E5akxWZEVsNnUvSDRvMElpeHhhK1BLRE1a?=
 =?utf-8?B?akl0TGJ5U05qYnJIOWdzZVJMU1RSb3V0V0dmQ1gvZFp1ZVZOeDNBZ24vMW0z?=
 =?utf-8?B?ckZWVE9ZaDJGVXJlcmgyNFF4VmhSUC8yelVpOFpDaVUvMG12RHI1MlJyOWha?=
 =?utf-8?B?eTZFNWZqNGw5ZmMvMlFvU0NlNnhNWVF6VEdnWElYMDJEZ2VzcXI1RGVwajdr?=
 =?utf-8?B?STBIRWlSbWVNelVqWEdJcklNMmVIb2dNVXZyY3M5Uk5iR1ZmUmZHaWltckRy?=
 =?utf-8?Q?RAgdqyVc/dcg53LQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15DDB2500C221440AD731191470BAB9C@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d93903-5778-49b3-eb6e-08df0815d808
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2026 10:43:22.1401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rAxKCcqIqNlG3BnU9V58jB5iB5rqJTqbZ5EQVO8M4l49a78M19SDCnTZiG39neqixAt9VCxUpUDPcKF/zIL9tkUwskeoJ9I9//x8XgooY+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB7898

SGkgSsOpcsO0bWUhDQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoISBKdXN0IG9uZSBwcmUtZXhpc3Rp
bmcgaXNzdWUgYmVsb3c6DQoNCk9uIFR1ZSwgMjAyNi0wOS0wMSBhdCAxMDozMyArMDIwMCwgSsOp
csO0bWUgUG91aWxsZXIgd3JvdGU6DQo+IFRoZSBXRnh4eCBkZXZpY2UgcHJvdmlkZXMgYW4gU0RJ
TyBpbnRlcmZhY2UuIEluIGFkZGl0aW9uIHRvIHRoZSB1c3VhbA0KPiBpbi1iYW5kIFNESU8gSVJR
LCB0aGUgZGV2aWNlIGFsc28gc3VwcG9ydHMgb3V0LW9mLWJhbmQgSVJRIGxpbmUuIE9PQiBJUlEN
Cj4gcmVxdWlyZXMgYSBzcGVjaWZpYyBpbml0aWFsaXphdGlvbiBkZXNjcmliZWQgaW4gY29tbWl0
IGYwMGRjMWQ3ODllMWMNCj4gKCJzdGFnaW5nOiB3Zng6IHBvbGwgSVJRIGR1cmluZyBpbml0Iik6
DQo+IA0KPiDCoMKgwqAgV2hlbiB0aGUgY2hpcCBzdGFydHMgaW4gU0RJTyBtb2RlLCB0aGUgZXh0
ZXJuYWwgSVJRIChha2EgT3V0LU9mLUJhbmQNCj4gwqDCoMKgIElSUSkgY2Fubm90IGJlIHVzZWQg
YmVmb3JlIHRvIGNvbmZpZ3VyZSBpdC4gVGhlcmVmb3JlLCB0aGUgZmlyc3QNCj4gwqDCoMKgIGV4
Y2hhbmdlcyB3aXRoIHRoZSBjaGlwIGhhdmUgdG8gYmUgZG9uZSB3aXRob3V0IHRoZSBPT0IgSVJR
Lg0KPiANCj4gwqDCoMKgIFRoaXMgcGF0Y2ggYWxsb3cgdG8gcG9sbCB0aGUgZGF0YSB1bnRpbCB0
aGUgT09CIElSUSBpcyBjb3JyZWN0bHkNCj4gwqDCoMKgIHNldHVwLiBJbiBvcmRlciB0byBrZWVw
IHRoZSBjb2RlIHNpbXBsZXIsIHRoaXMgcGF0Y2ggYWxzbyBwb2xsIGRhdGENCj4gwqDCoMKgIGV2
ZW4gaWYgT09CIElSUSBpcyBub3QgdXNlZC4NCj4gDQo+IENvbW1pdCA1N2FhNTU3ZjExMGQ5ICgi
c3RhZ2luZzogd2Z4OiBpbnRyb2R1Y2UgYSB3YXkgdG8gcG9sbCBJUlEiKQ0KPiBhbm5vdW5jZSBz
b21lIGxpbWl0YXRpb24gYWJvdXQgdGhlIGRhdGEgcG9sbGluZyBtZWNoYW5pc206DQo+IA0KPiDC
oMKgwqAgVGhpcyBmdW5jdGlvbiBbd2Z4X2JoX3BvbGxfaXJxKCldIG11c3QgdXNlZCB3aXRoIGNh
cmU6IGlmIGFuIElSUQ0KPiDCoMKgwqAgZmlyZXMgd2hpbGUgdGhlIGhvc3QgcmVhZHMgY29udHJv
bCByZWdpc3RlciwgdGhlIElSUSBjYW4gYmUgbG9zdC4NCj4gDQo+IEhvd2V2ZXIsIHdpdGggbGFz
dCBhbmFseXNpcywgaXQgc2VlbXMgaXQgZG9lcyBub3Qgb25seSBpbXBhY3QgdGhlIElSUS4NCj4g
V2hlbiB0aGlzIGNvbmRpdGlvbiBoYXBwZW4gdGhlIGhhcmR3YXJlIGlzIGxvc3QgYW5kIHdvbid0
IHJlcGx5IHRoZSBuZXh0DQo+IGNvbW1hbmRzLiBUaGUgb25seSB3YXkgdG8gcmVjb3ZlciB0aGUg
ZXJyb3IgaXMgdG8gcHVsbCB0aGUgcmVzZXQgcGluIGFuZA0KPiBiaW5kIHRoZSBkZXZpY2UgYWdh
aW4uDQo+IA0KPiBDdXJyZW50bHkgd2Z4X2JoX3BvbGxfaXJxKCkgaXMgb25seSB1c2VkIGR1cmlu
ZyB0aGUgdHdvIGZpcnN0IGV4Y2hhbmdlcw0KPiB3aXRoIHRoZSBoYXJkd2FyZS4gVGhlcmVmb3Jl
LCBpdCBoYXMgYmVlbiByZXBvcnRlZCB0byBvbmx5IGhhcHBlbiBhZnRlcg0KPiBhIGZldyBob3Vy
cyBvZiBiaW5kL3JlYmluZCBpbiBhIGxvb3AuIFRoaXMgZXhwbGFpbiB3aHkgaXQgaGFzIG5vdCBi
ZWVuDQo+IHJlcG9ydGVkIGJlZm9yZS4NCj4gDQo+IEZvcnR1bmF0ZWx5LCB3ZnhfYmhfcG9sbF9p
cnEoKSBpcyBvbmx5IHJlcXVpcmVkIGZvciBPT0IgSVJRLCB3aGljaCBpcw0KPiBwcm9iYWJseSB2
ZXJ5IG1hcmdpbmFsLiBUaGUgSW4tQmFuZCBJUlEgY2FzZSBhbHNvIHVzZXMgdGhpcyBmdW5jdGlv
biwNCj4gYnV0IG9ubHkgdG8gc2ltcGxpZnkgdGhlIGNvZGUuDQo+IA0KPiBUaGlzIHBhdGNoIGxp
bWl0cyB0aGUgdXNlIG9mIHdmeF9iaF9wb2xsX2lycSgpIHRvIHRoZSBPT0IgSVJRLiBUaGUgYnVz
DQo+IGRyaXZlciBub3cgdGVsbHMgd2Z4X3Byb2JlKCkgd2hldGhlciBwb2xsaW5nIGlzIG5lY2Vz
c2FyeS4gV2hlbiBpdCBpcw0KPiBub3QgKGluLWJhbmQgU0RJTyBJUlEgYW5kIFNQSSksIHRoZSBJ
UlEgaXMgc3Vic2NyaWJlZCBiZWZvcmUgdGhlIGZpcnN0DQo+IGV4Y2hhbmdlIHdpdGggdGhlIGRl
dmljZSBhbmQgd2Z4X2JoX3BvbGxfaXJxKCkgaXMgbmV2ZXIgY2FsbGVkLiBXaGVuIGl0DQo+IGlz
IChTRElPIHdpdGggT09CIElSUSksIHRoZSBiZWhhdmlvciBpcyB1bmNoYW5nZWQ6IHRoZSBjb250
cm9sIHJlZ2lzdGVyDQo+IGlzIHBvbGxlZCB1bnRpbCB0aGUgUERTIGZpbGUgaGFzIGNvbmZpZ3Vy
ZWQgdGhlIElSUSBsaW5lLg0KPiANCj4gVG8gY29uY2x1ZGUsIEluLUJhbmQgdXNlcnMgYXJlIG5v
dyBzYWZlLiBVc2VycyBvZiBPT0IgSVJRIHdpbGwgYmUgc3RpbGwNCj4gaW1wYWN0ZWQgYnkgdGhl
IGJ1ZywgYnV0IHRoZXJlIGlzIG5vdGhpbmcgd2UgY2FuIGRvIChhbmQgbm9ib2R5DQo+IGNvbXBs
YWluZWQgZHVyaW5nIHRoZSBsYXN0IDYgeWVhcnMpLg0KPiANCj4gRml4ZXM6IGYwMGRjMWQ3ODll
MWMgKCJzdGFnaW5nOiB3Zng6IHBvbGwgSVJRIGR1cmluZyBpbml0IikNCj4gUmVwb3J0ZWQtYnk6
IEdlcmFyZCBTYWx2YXRlbGxhIDxnZXJhcmQuc2FsdmF0ZWxsYUBzaWVtZW5zLmNvbT4NCj4gUmVw
b3J0ZWQtYnk6IEx1a2FzIFN0b2NrbWFubiA8bHVrYXMuc3RvY2ttYW5uQHNpZW1lbnMuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYmguY8Kg
wqDCoMKgwqDCoCB8wqAgNiArKy0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dm
eC9idXNfc2Rpby5jIHzCoCAxICsNCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4
L21haW4uY8KgwqDCoMKgIHwgMzQgKysrKysrKysrKysrKystLS0tLS0tLQ0KPiDCoDMgZmlsZXMg
Y2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQoNCltdDQoNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMNCj4gaW5kZXggZGRhMzZlNDFlZWQxMy4u
NGU5OWZlN2U1YmI3OCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJz
L3dmeC9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWlu
LmMNCj4gQEAgLTM5OSwxMiArNDA2LDEyIEBAIGludCB3ZnhfcHJvYmUoc3RydWN0IHdmeF9kZXYg
KndkZXYpDQo+IMKgCQlkZXZfZXJyKHdkZXYtPmRldiwgInVuc3VwcG9ydGVkIGZpcm13YXJlIEFQ
SSB2ZXJzaW9uIChleHBlY3QgMSB3aGlsZSBmaXJtd2FyZSByZXR1cm5zICVkKVxuIiwNCj4gwqAJ
CQl3ZGV2LT5od19jYXBzLmFwaV92ZXJzaW9uX21ham9yKTsNCj4gwqAJCWVyciA9IC1FT1BOT1RT
VVBQOw0KPiAtCQlnb3RvIGJoX3VucmVnaXN0ZXI7DQo+ICsJCWdvdG8gaXJxX3Vuc3Vic2NyaWJl
Ow0KPiDCoAl9DQo+IMKgDQo+IMKgCWlmICh3ZGV2LT5od19jYXBzLmxpbmtfbW9kZSA9PSBTRUNf
TElOS19FTkZPUkNFRCkgew0KPiDCoAkJZGV2X2Vycih3ZGV2LT5kZXYsICJjaGlwIHJlcXVpcmUg
c2VjdXJlX2xpbmssIGJ1dCBjYW4ndCBuZWdvdGlhdGUgaXRcbiIpOw0KPiAtCQlnb3RvIGJoX3Vu
cmVnaXN0ZXI7DQo+ICsJCWdvdG8gaXJxX3Vuc3Vic2NyaWJlOw0KPiDCoAl9DQo+IMKgDQo+IMKg
CWlmICh3ZGV2LT5od19jYXBzLnJlZ2lvbl9zZWxfbW9kZSkgew0KDQpBdCB0aGlzIHBvaW50IGVy
ciBzdGlsbCBob2xkcyB0aGUgKHBvc2l0aXZlKSByZXR1cm4gdmFsdWUgZnJvbSB3YWl0X2Zvcl9j
b21wbGV0aW9uX3RpbWVvdXQsDQpzbyB3ZnhfcHJvYmUoKSB3b3VsZCByZXR1cm4gYSBwb3NpdGl2
ZSB2YWx1ZSAoYXMgZmFpbHVyZSkuDQoNCkJ1dCBtYXliZSBpdCBkZXNlcnZlcyBhIHNlcGFyYXRl
IHBhdGNoLg0KDQotLSANCkFsZXhhbmRlciBTdmVyZGxpbg0KU2llbWVucyBBRw0Kd3d3LnNpZW1l
bnMuY29tDQo=
