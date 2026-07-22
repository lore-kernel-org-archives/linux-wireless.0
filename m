Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F9045A287;
	Wed, 22 Jul 2026 11:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784718107; cv=fail; b=rQ1yI5JOwfT1H4ZY5kgB4ixTcivk19ndm6z9QOdBU6NVRlHC0hp4EgAC4eorsOiE2kxQPPYt0iAWlPo6vS4DOL1/kHUsQ7N+PTi5jPrgz2mPgVVIducQfkqc0EzCh4pdMNORyk6ZCZmN9NX/hpxFxvaMIQO34oXp7xnAVdhF3Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784718107; c=relaxed/simple;
	bh=phoo4pYnJVkrVWucIm4aItWcbgVpBdWkn+tTp8ASYW8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PoPvcSCoLeB0t4lxAUikI313CfAgwnXovqaKAOD/twgispQnWY0Bizxvy978p5p9RdfptenvyUmLLyjYA/RXjkxIlDKf3ceze9jTX7IpAUjRyfgesAovB0fCoLvNkr0FSjvm184HlyKvfJGUlPd30ndKzW/odTjiNj2/kK+QQKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGjhkFXV; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGjhkFXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784718105; x=1816254105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=phoo4pYnJVkrVWucIm4aItWcbgVpBdWkn+tTp8ASYW8=;
  b=LGjhkFXVGHzlIJoJ4cnzmm9NAsi86GUjky8myUo5BuyXD17fw5LL3smd
   3aV8OMOo56b2HVyMSr3rVY/EC+QJ45U10cdbLsJ+RAOHXDkkCXWZEaXB3
   hQ7dzmoKb1Kq+e2PImHvz90Sw3c6qjYHtV3FbKQjnCDiIpsjGcY5HWEmm
   AhINJfYOA2hJwjU4hMp/F9le10fn4ICZq/Iio3vBJaYStb3jS/zI5b5Nf
   XsfJ5qhfCFrIoe4p/9+GTOs+bJtLRk52vdKU2OrUEZ/cl89qIy9Za1N00
   38ZAc3eCKDO0MiM6lz+PPiDLNKq5nVO64qjrNnUJfVIjTpLuWIhewP0uY
   g==;
X-CSE-ConnectionGUID: SNCk9h7JTcy/4ZeY+UBpQg==
X-CSE-MsgGUID: 5aMh2da3TKWv1pTyvNn4Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="85203131"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="85203131"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 04:01:44 -0700
X-CSE-ConnectionGUID: OJFlMzK3Tj6R9orWIoYXDg==
X-CSE-MsgGUID: S9B1c0FjSbeAX8a2aP8Rfw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 04:01:44 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 04:01:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 04:01:44 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 04:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LE/mHE/JJWLHVLxER9nVTzyXgm4QHAd0wp9qwovocQQ2hM0ZBMFHLrFWoQLYGlJoR1g+zLm7V2ncAQEjbID7+mMOiAhhK1CtbTN5U3Wb3PKkZ2EdB2nwBBQa8OlskBk6ayQS5H0Ym6tR3guSuH8VnmORytWMnqdK3bRmVOJZ3oUBS+F0nck5MwjBSId7hGAzcpUS5qjlpAPw3dx2NbkgJFZydfyRy8Ka8mYDWgpW7WVJyumHsfjcPkkrQv5b8F2JOlW+IagIFlUG5x9AXraYesRxriL0w0BjstQAvgg+TF4/1PCla3KqMJypLjLA/Y62kv2O/5DESyF283ERKo2n7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phoo4pYnJVkrVWucIm4aItWcbgVpBdWkn+tTp8ASYW8=;
 b=p3wiDkFK6Kesli5dWBWRLaHp2T3Yo/0Go4PD+RvFEpaSos5m33scgq91FGbYhG5kEjbs/2fDT3d8hBZwNYMs+tdP9oQFZ8Do1sfmffL/WgvXPgcxbRU7z3onX2ydMuXY1KV2shjD+2qGnDFizfLCK9vJ34N84w71/G7Qv1AwhySZRyMmJa0sB0QpY+u3x5RH3vwFQNnKXHBgC9LefuA+pjbOUon6HmrDMKVqAQKGmJfU0Dw0PbD3VO5t/KtJv55a6zJ/1JqRGW/n9E9rAwM5vePCvvcH67bgUPNDuXB0WkszIzcSZYvaicCbQfIg8jlg/v6jTIpDhyvG9s47kcSpWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by SJ2PR11MB8538.namprd11.prod.outlook.com (2603:10b6:a03:578::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 11:01:40 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 11:01:40 +0000
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "lukas@wunner.de" <lukas@wunner.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Korenblit, Miriam
 Rachel" <miriam.rachel.korenblit@intel.com>, "helgaas@kernel.org"
	<helgaas@kernel.org>
Subject: Re: [PATCH] PCI: Disable NoSnoop and Relaxed ordering for Intel
 wireless BE200
Thread-Topic: [PATCH] PCI: Disable NoSnoop and Relaxed ordering for Intel
 wireless BE200
Thread-Index: AQHdAUruh/HWEZwEC0iMA6tK8iUSn7ZIqESAgDDn+QA=
Date: Wed, 22 Jul 2026 11:01:40 +0000
Message-ID: <9eeb29c6b7986797eec0af6c7ef42cb8c9feefd2.camel@intel.com>
References: <20260621065451.21650-1-emmanuel.grumbach@intel.com>
	 <ajecdx3HYj5rqJBZ@wunner.de>
In-Reply-To: <ajecdx3HYj5rqJBZ@wunner.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (3.60.2-1.fc44) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|SJ2PR11MB8538:EE_
x-ms-office365-filtering-correlation-id: f9d50f2c-281d-4bd3-642b-08dee7e09ba6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: M6TUtoze5vQ/FslngSaQ7NrpJlrile3HFx1rw97krCOcHT9ut5DOWGRTYKdgBBcqq8nCIZXOnChHMJlsWoOCx3bsCkaBoIfQInQhbno00vYacAbQm3hZ7jWU7Ni18168X2e+PHu0SbC88Pgb/pA6woC8GXi+AVhnN1YuPh7efxOZlW5NnkfB9i4mUKIf/rbwFKixqgHF6reDK6sAbm2DfJ3bF4wHZfrepvZnvKss1ynD+rUdw8lEHXXDVxf7zg8slw6X3pNsknb+oxvB3PTq7QeuVqQydHsH89ml3y/mgvyBilAl+EVye8vcCTG0GK+TVMWTywaOz4Qf1eEXYPFmFl18scaVZ5iwpC2r7QyJZKVcac3yOyrMyWUtK/YDo+4wKxuL0gxEpEHtzGeD/Y1jxfzSR8MCpZDIlqrM4arc22o3VjUteSBKjB10nemIvVXZQCXKjqMUnA1D+J/8fScAk+M6lkh2QZNzMAKJXASr8mIS1orTXG6mLfdhUpd4KoFrgtz1OU546LQlgJyzFO9bzmyITHOBEk7iBpiyCGl4wudIfdWcSLGPrRmnK+gEbv7Jz1ScmLiE/Ie/ZjZiF3FLxuVE0vcoDQjKt0YSd4Og5tlf6gclswxO4MolCsE8/ViUUcOWdDu+OSF4wEXFqAqA3gnKgtDliHOKbBi/Mjy2EvesG45fuwZJeKLNZEDo9KqibTPaAx/71VxgJx/FoB6gc2mrS9IUCNZFUWq0hrYwpPI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHZLeHNPZlljMUE5VW5qVzVtT3UzWEtyaWlxVjZWNkUzbWRidU5BMU1TeTUx?=
 =?utf-8?B?N3ZNYm1sNWJhV3FoaXB0bU9UMGpvTHR3ZzN5ak9yWUpTZ2tUL2ZPc3hZWG1S?=
 =?utf-8?B?YTdTQXNmNWNtRzVVZnN6clJQUVp3bFpXVURkYVRSNWREVC92ZVlldVJJU1hU?=
 =?utf-8?B?Q0dmbk96ZlQxZk9hV3gwSzlFWXBwTDFMbHdRNldLWnp0a1lCbG5yejYwYkxu?=
 =?utf-8?B?a1h4bDdBYTN4RGJJTitXSkFETnBPY3ZjUURqbFU5OXR4WFJUci81ejE1R3J5?=
 =?utf-8?B?M2wrTXFKVTBIWDN6NldyOWMyZjdQc2NsdTIxdS9UaUZLV0hYTWhLZEJwbEZO?=
 =?utf-8?B?VGllSkNJckppS292Y2hKbTZKdDNZZjdmZlFqb2VVanpqeHJqbTZMdnlqZXI2?=
 =?utf-8?B?MkdSWVlLRjRoRHdGVzNaWUxVOWp5c3UyZkxyQlkwU1RtT2Z6Ym9NeENiajcx?=
 =?utf-8?B?Ti9uUVRKSnNzUmppQ25zcUFSSVVZQmhKUlJQelFWMk0zdUtOYys2L0ZneUxz?=
 =?utf-8?B?YWJSQWpwUllTVWMrb01TNkVXK0xLVlNrcGZBZkIrZ3RNSUtDc1Q5SzVlMSsx?=
 =?utf-8?B?RFF0VUtKcUxGTEMzdGhJSTRUZUplcXd2TzNVUFRiVnV0SlErU0tIcDlqTmJy?=
 =?utf-8?B?ZlI2K3MxOFBydCtkNUZ4UkxWYmlSTCtsRlhDeFJ3WnpjWWt4TzJMQmJGOWdi?=
 =?utf-8?B?clV4MGd3RGVaNDNpWmszdUs0a2NNUjM1NjRPblJMVHBhNUNYbkY0OVFiSG9H?=
 =?utf-8?B?Y1dtdHc0QjhBL1F6UUxjaE56d2EwbThMRlZ6TnFzMUN5MFI5Z1ZiaHdoWnlT?=
 =?utf-8?B?TVJseXVJZlJWVDBnTGJONzBONGtYOUlEYzZGUlM4LzlwenlmUTZyV25VRjVx?=
 =?utf-8?B?NU1taU8wM09UNTFKWEt1QnFlQkFvZk5KWjNWZUtqYUY1aHVBRkJsNVcrY2xx?=
 =?utf-8?B?V3dCZ1ZERXdZVExqVDdvQWdrc0t6bzVJbjhwWVROaHU5NTJaZXNXUnZ2MUgy?=
 =?utf-8?B?MEZFWDFBanF3aHdPTVJFcmorVExzZDlYd0ovZWR6UzAzaVhvcjJMRGppbTdK?=
 =?utf-8?B?b2JqSXVSYTMrYkR2anE1V20wTHhhMms0dXdDSjRiazNpNFhLdnhqQ05YUzky?=
 =?utf-8?B?emh1aEF0SmFHWnlRTlNVWEhSMTFuR1I5V1NqWlNlUEhSeUVSdVpuL1hFUE96?=
 =?utf-8?B?ZTEralQ0QXN3bDh2R1dLWWR1NmRKK3drbWZZcGhnY0dOMDdPNjZHSXhzbkRC?=
 =?utf-8?B?ZWV4Q2ZYei9ldjlBb0d4SDZHVTdGSUU4cmdTTFZ0QzNZZzZkQ0hxNktvamN1?=
 =?utf-8?B?SnVvaE1zdjBnNHNrcWt5cnZsV0lPRXp3a0g5cm45NjUwZEMwTkRLNkNtTVVZ?=
 =?utf-8?B?SzduTTRLdGhKODAzTnVhbytlZDZwcGlYM1BocnpGMUowSmFKMWNDUXoxaW9v?=
 =?utf-8?B?NklPRFJlOTNyZ0NPc0NKdmNvRXI1cDRFRWxMeTYxZnd0UHJKR3NCN09aY05I?=
 =?utf-8?B?V3lyZmQwYnpFNHYwcnU1aEN1QTF5QkdsWHJjc0pYdmlhRWdmeW9ib1daY3ZE?=
 =?utf-8?B?YzJaNnNvYTFVaDhLaVpZMVM4Tk10aVhHOVF1OFljTXQzMHgxTms3NGlBd0tT?=
 =?utf-8?B?YlBNc0lGdnhLSXVjbW14NWt2MmVVTThnTm9DMU16WnJOVTJTMnpKcG5NVWoz?=
 =?utf-8?B?Z3psdjRnelFPSXo2MlFCNUE5NmJGL095dEtmY2w3QTVXQW5QdXZ6WkV4RmRR?=
 =?utf-8?B?ZGNyMTVQNlRLa0MvTEFkMC9xSFJneDdaMmtuZEJzOEY5aWpVSnlKWm4raVEr?=
 =?utf-8?B?OVhZbit5OWUramNHSTJmVUd2RVRSRnRTV2V1WU9yYzBpUC9DZHREcXZsbWM2?=
 =?utf-8?B?SDN2WTh4K29zSFY2N1dBV2wzYzQ4MWtSV2RTa3NiNFpNQnU2Z1hGQ09QaHVS?=
 =?utf-8?B?ZjJoTDNkZ2lldlEwWkdyWStXaXdDY3JMaG1CL0QyM0ppZDNQakJPOXJCTmhS?=
 =?utf-8?B?aGlXU0N1b01UK3BjemFQY1FvcEcyU3kxU0N5MFA1WkVkSWUrVzlLek9YMS9I?=
 =?utf-8?B?dEgvNUNtSVhDejBWY1VZdndKVlYzRlB5WFhvUTZRMHFrY1N2ZWVsZjlxaTBS?=
 =?utf-8?B?NWI0Z2xEQ3ZhMEpzY2dHS1d2eHoyZEp2OFVDazBjVEI5OWlaRDFtUE93QzM3?=
 =?utf-8?B?ZE9Ud3k0NGYrcDN4VWl5ejJJQkN4OTNBbWNHbVZoN3QyQWFzdXJ6SEozN1A2?=
 =?utf-8?B?eDAwdVh3dmhnTE5qTWtnVTZsNm5nRmFHalZNcDFJdlMrbE5kTzdneFNkK0pq?=
 =?utf-8?B?ckJZY0lqeitvSU5MSkcvZ25KRks5T3gxQWJMYmlvQ2NCU0tJaE9SODZmQXI1?=
 =?utf-8?Q?Cg+W8729zukrfd1E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EFBFF7404B80247B07B42E8AD47E810@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: pO+rLVIv7znPUTGbJwDuKfWjsP4nfTtpwW59zvNyrFXYDYlV7Fa/c8dROgj3OYNhhXXRuKwMJXKeXLJrbKXTaqeci7J3Gjd5yXfwv52QXJ/ilNG7O3B1zBBzIX4+u5YFI9LmCR2lLdp357WX6fxh51GWK3sgjwGeEXU33kwGpVjsK3EMrZdY3boQRB4wG47HjiQMIykP5ZsoPDjHfwO/gb64+pVirINohRnTUfwluM8meEHBU81WH2P2VZNSXm/LlpZybNJd584k5dNBvX1/9wTKNEYaDEg/DStHLPZfiTuVgp+hz9f8LPWAvRE9C9jjI4UiPC+yyQ4r0Fnh/OWIoA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d50f2c-281d-4bd3-642b-08dee7e09ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2026 11:01:40.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jGbU4vNcvz0KaACo+s6qE1IBvAJS8fJseSlWmUnjeGNR4yJMeUAAXNmKejsdv2/7as1Ep6xmW2m7HwmxJCx0bKzDgCDuMnUpp1RAJlhCiKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8538
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI2LTA2LTIxIGF0IDEwOjEwICswMjAwLCBMdWthcyBXdW5uZXIgd3JvdGU6DQo+
IE9uIFN1biwgSnVuIDIxLCAyMDI2IGF0IDA5OjU0OjUxQU0gKzAzMDAsIEVtbWFudWVsIEdydW1i
YWNoIHdyb3RlOg0KPiA+IFRoZSBJbnRlbCB3aXJlbGVzcyBCRTIwMCBkZXZpY2UgZmFpbHMgdG8g
Y29weSB0aGUgVExQIEF0dHJpYnV0ZXMNCj4gPiBmcm9tIGENCj4gPiBSZXF1ZXN0IHRvIHRoZSBD
b21wbGV0aW9uLg0KPiA+IFNpbmNlIHRoZXJlIGlzIG5vIGNhY2hpbmcgaW52b2x2ZWQgdGhlIGRl
dmljZSBhbnl3YXksIGRpc2FibGUgdGhlDQo+ID4gTm9Tbm9vcCBhbmQgUmVsYXhlZCBvcmRlcmlu
ZyBvbiB0aGUgcm9vdCBwb3J0Lg0KPiANCj4gSXMgdGhlcmUgYSBwdWJsaWMgU3BlY2lmaWNhdGlv
biBVcGRhdGUgd2hpY2ggY291bGQgYmUgbGlua2VkIGluIHRoZQ0KPiBjb21taXQgbWVzc2FnZSBh
bmQvb3IgY29kZSBjb21tZW50Pw0KPiANCg0KSSByZXBsaWVkIHRvIHRoaXMgYWxyZWFkeS4gQW55
dGhpbmcgbmVlZGVkIGZyb20gbXkgc2lkZT8NCldlJ2QgbGlrZSB0byBhbGxvdyB0aG9zZSB1c2Vy
cyB0byB3b3JrIHdpdGggQkUyMDAuDQoNCk5vdCBwdXNoaW5nIG9yIGFueXRoaW5nLCBqdXN0IG1h
a2luZyBzdXJlIHlvdSdyZSBub3Qgd2FpdGluZyBmb3IgbWUuDQoNClRoYW5rcyB5b3UhDQo=
