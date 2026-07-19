Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197438E8BB
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 10:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458725; cv=fail; b=p2plF/OnSpyYmDg6jjTsUEURUylby5XNTuZVk5kNEsqzijrGKkB+NdDxCpQvZPC5+Q8BjWGsOlny9EBjtHGLzvHtuuQq3yotM1H9dtDuBPrsPIfnBQv0otDe/QYckbWIL6WHVvns24c9+HdD9kDGTjHsjmgD6s6gyoxuqkzfRKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458725; c=relaxed/simple;
	bh=kUOUNIa5zY25UlLm3DSgSD7qAQ7m6KGz+GgxXem99dM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B8nDyQW8YrLZwqYjmYhKRVaa5iNTP6SNbii+C/PbNo4vmzZsYBDj1jRyMz/Z9twl1WEnXuAxqgiAQFe2a3Np6GoBK4tPnoZgzTbDtWl7IlO/eI1jiZ5ivb1sTXhDvF20GSpwleCrZHLMcURSqcZWlItrBBj3EJFS7NQyVCTgCSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mcW64E81; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mcW64E81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784458724; x=1815994724;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=kUOUNIa5zY25UlLm3DSgSD7qAQ7m6KGz+GgxXem99dM=;
  b=mcW64E81Lse9BkVe7a2H8YU6A9DxU1TDx6FXySItgiSqFNHhC6eaSVzx
   n6VcGffRRitsCfwjpX6QitYzCdqUlBg91+1i+Y+nJpU8Q87PIAo1xekoT
   02gZr7Sd+7wAxxsWeYetVi6rp+5ouZ6io2gX528+NzUyUdE4Y0uWBFW6/
   d34brHlhBo4q2BhKg8PYxQqSioAyoNrqmR3GlQjkyfaNdbfoHws1R7dyS
   IJ445/z7JG+Ecz3LWZtFbfVy9YryR415iq0LRo88MT9wVwIhT+h5mnZIp
   rINQgYWCd7EtKxw181MJFDcHzk8pdbxpSJdyEaID9EBp5VHAQIwYASKJZ
   g==;
X-CSE-ConnectionGUID: 4hS/PgWlT2OHshWPfhRrzQ==
X-CSE-MsgGUID: mXMKEbPoQZ28jIee0lHzLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11850"; a="84918121"
X-IronPort-AV: E=Sophos;i="6.25,172,1779174000"; 
   d="scan'208";a="84918121"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2026 03:58:43 -0700
X-CSE-ConnectionGUID: M9VEgPPkTMOno19WMmMF2A==
X-CSE-MsgGUID: cY7d0uDJRs2CMABvWYrc4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,172,1779174000"; 
   d="scan'208";a="256631694"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2026 03:58:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 19 Jul 2026 03:58:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sun, 19 Jul 2026 03:58:42 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 19 Jul 2026 03:58:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uybe/K0iWC0tsIBeNjddD/YBFu1OX7R5Zhr4/EjRFX23FNBsamwzwwgxKwtwnbdFEzJudo+tZqyjmikHB2VlATWpBFSdTc/VnfSb1kvhjKDuwRQh4OTpPErH7Sh+78oU33VxOAWUiGdCUq1dz48hT68awEHKiyoCyO0Li9ehy+oehLJ4PPLqnV7qYRQkJ8SNmh2cd0wuUSvsqDHBp0Eu/El4V3TI7dwITe3JeJcgcN67Mwjwrp/5DPPhQAl1OZ9PBxOl9RMuktq+USftJhws058C4Vrg6HZl7Mqy9D5kMXOcS+KC/D1lOsi/2vkiNyfl2N9ttWygCi24dKmknQmG7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUOUNIa5zY25UlLm3DSgSD7qAQ7m6KGz+GgxXem99dM=;
 b=GDw12XzTh6QyixPAhUf6YY9hF///me//V/avEnKOtXhSMI5pUwBmEgtqu1yUhVHBg5aKIav44nhhbyPKhZ5p60WfzSlusT7+jF/djF+0YKEFcSMMxsroqQaLbDvezdr/MGfHAsUkbyx10WbEInZV47l5pjJGwssNbElSTsKUDLLn+l+dAH6UDTGAHNUAFn3KgA4qVK26nRwyGoor8CkD0VffD9rEQvgshpxRuBORbhw/9oX1/BfLYBu3n2gPrXS6jEWM7hwo0I+HUDv2LMqBKeX6hQrzgpQqdaDSnaO6CuvYp7dZwaQxFS3dPsDmQiO7yTBfSpYGz8vsHqxE1bNmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) by
 LV3PR11MB8743.namprd11.prod.outlook.com (2603:10b6:408:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Sun, 19 Jul
 2026 10:58:39 +0000
Received: from DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2]) by DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2%2]) with mapi id 15.21.0223.015; Sun, 19 Jul 2026
 10:58:39 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>, "Berg, Johannes"
	<johannes.berg@intel.com>
Subject: pull-request: wifi: iwlwifi: fixes - 2026-07-19
Thread-Topic: pull-request: wifi: iwlwifi: fixes - 2026-07-19
Thread-Index: Ad0XbWNpT5UEd+8GQ2Gp1XbJkKSITQ==
Date: Sun, 19 Jul 2026 10:58:39 +0000
Message-ID: <DS0PR11MB788036309485FDFE39BADD87A3C42@DS0PR11MB7880.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7880:EE_|LV3PR11MB8743:EE_
x-ms-office365-filtering-correlation-id: 9a0ab0ee-da22-40c4-8784-08dee584b0ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|10067099003|56012099006|11063799006|18002099003|38070700021;
x-microsoft-antispam-message-info: ZV8XnjG6VMYeEx0fkHWxO+2u9e7M4WjPd8ee72ENYMxHAaOZ1jV6YXkbKBsZQ1ic+2Z1O43lWkjpajs4yrz73zVDyD52pa4WN7kmYkDn/S6cDuzVHmaM6pG8/7ry7kOWc/JnFNeHVqmmh1cRt8+MuvVKFUh7lIgKWV+ddLB3Q8eeqEFEYqjTPkq3imd+dFVm1I/0MJgKVNhyTLV00akRii8L3jwOMCNZSHL2NprC4KkqV29+yAz38AlyVSmdFzKZnkGHjtcYju7u3+GY2SZ6JM+hSdOfkj671xSEaXjhjiZmSDT3CxmDizhxSOQqLUSBAF+NS82HKkwKW/xdkZEZnv0UxpQxwFw+KOXcGGe3diezWWbQeTEehisqLDgyGuUgS22ovH7XxsoE+JwuDExA2DJYZNpKPglxvCaIzmxl723mqaljg93dC6RteZeIno9UhggxQBZA94qpRRuKZfWz9/L9UkeiS5zc0CQCmICTGNeGr4wVWqhV78tiPTUa/Yb1NeTXdndl3xLJAyYgTjmCrJcONhq3wV3thjkofTDO3MmKEOKzio0kcpzew/divfekdl2ZWAFDRg0YEIiDb4pCCXAYqhkoMT2hsw8jyzA3KT+GhcakEbvbFnewdcYl/+fimToklvOdilE9qWd1273Fv9NILUAQgX5jRRLavVDv470GL0Og+Malh6DNucO9PPBVIvs8FQOMapndEReU2KwAblCoRv3cnKEdyegj8ztW3oE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enduSFVyN1pSRW5LWnlpNjB4c0hLZ1JlRktvc3Q5dXUvaHllcldBNFRHZmk2?=
 =?utf-8?B?Wi9BNk1PaXZlcFduWXUyd2NkM0FoVEZqajVmOU5Bemo2S2pGSE9ITGl2bERS?=
 =?utf-8?B?RXprUEZGK3pQdVFGZFFzdjZ2VXExTVM1dGlSRDU5dDBnWDExKzFQeVpydnZI?=
 =?utf-8?B?elpmL092SGtVTjlvZVdINWo0dHRZc2tBcUVEbElKeVZRaXhHWkVlTzk4dU9m?=
 =?utf-8?B?Z0JZSWVWMEZ2Q2o1VE9aY0M2bktLK2t1aS8rcm5lSHkwV0g4a2tMWmJwK1Aw?=
 =?utf-8?B?cUg5dHUrSXJOR09LYmtpZ0UzR0hGSVBaOFVSS2ZsME9QME52a1ExN3lnajRj?=
 =?utf-8?B?WlQwYlJYRUJXTk9KNDFTU0kvb3Z1Z3JTRDFXRjNJUjZHaWs2WVVmZ3JkYWpU?=
 =?utf-8?B?NnJiWHdiOFNBcjl3elVQcXk4ckx0QnhDcHNlclhqSGJ3MEpLSmY1RXlnNEha?=
 =?utf-8?B?NWtRWTRkSGlYVUcyZWZLRkF1b3piMmpBVWZVeHBBTjg4ZmJvREJzU1ZwOUt3?=
 =?utf-8?B?VUwxa3gxSWJNMkVFWUN6eGVXNlpNNUhXbjc2Z1NMYzhEQlhVRkV3NVZ4aDdw?=
 =?utf-8?B?bU10azdBWHV6TjdQS1pOM2FqdW80M29RWHdHOWZ3S01KcFBDSXN6b0RHSStR?=
 =?utf-8?B?MFQzSkFsdUVuMWpOQ1FRb0pkK043MGpWd3BFR2p5L2ZCWDNyc1lyWmp4bGZm?=
 =?utf-8?B?ckhOdkNxZW1mZy9GN3ZLY2ZhYXpoWlNOQnlqdVg4M1dsM1E3U3Ric1dORTVP?=
 =?utf-8?B?elUzMHUyazJNSXJGdmxUZWZyTDVSSitoYnZQWHBNQnB2eTN2UjUvdDFwZExu?=
 =?utf-8?B?ODBmSE9jY2pZdUpORGxpSHJtdHBXKzRORGRHRGVqbFNjMWNLSkQvYVY0NXMr?=
 =?utf-8?B?bFdnQ3FsNXR3N2FFWVU1NGxhdXBuejhIVmczNURCbUIxdnlkeFNKdU5iOUZl?=
 =?utf-8?B?Wk5iVDdxYVNBdWNhSWxOaGtHc2hHc3BJcDBQWGpZdHE2TUpnY3VQYXl1ZHo0?=
 =?utf-8?B?eWE5cmNqU1lOWFI0NWdBNzJkbjhuRlVHODhTMXZmNDRZeUh6cjg3dVQvS3J2?=
 =?utf-8?B?SG8rb21EbHpQQ3I5d0pEbUdWOGxVdFdXVkJQL3pCdjRaZjFtREZ5UlRyam5U?=
 =?utf-8?B?Vk9FQ05oUUxhVGFvZFlPK08rT0NyRVc1N294MEFOZ1pZakorQ3pGVUF6VTRv?=
 =?utf-8?B?TGtFQmV1U2xFWDZwVFNQbE1qZzYzeDlJSzlpcUpVZzdEdVRmS2JEeHpSaTVT?=
 =?utf-8?B?akY5d09FSmNsU3Z4bk84MG1mVFFYWXUwQmdTTjJSS0tWN0ptMjAvemF2YVJM?=
 =?utf-8?B?MHoyQUdtbG1lZzlYL0xNZzAyTUNlRVNlOS9tZElJKzU3TlVZSkYzbUxwWHZh?=
 =?utf-8?B?NTdsNDZUMi80Z2NBb0owOGhIVjFrd01uTGNEZlFBcTBKV0dMdFhGYnRXOUpO?=
 =?utf-8?B?NlkvcWlHQm80YVl4OFowcWxHT1RJNlNzd2tvMHFQekF5a3FHT1BVNFZtZmpw?=
 =?utf-8?B?NVROQm1RK3pxRnU0RW5CU0VuVzRCRHJlT1ZBWGFUU1JnWGdkR2JkeE5sVmdP?=
 =?utf-8?B?RW1QOVZyUFNNVXl6Y2gxVzVCV3RVOVk5MTFjMis3dDl6L3ZHSFBiVzAraXlp?=
 =?utf-8?B?Y2JqNmlKSzZ3Mm4xeGh3ZW5KcndFQ2w4T3QyU0t0RlNFWkdjRVVUY295RUx4?=
 =?utf-8?B?MnBCYndXRkx4Y1BZNEt6MDlrNUZpMURLSHJIOUtJR0lzT3Vuei9mMnByT2Q2?=
 =?utf-8?B?dExCdWR3VnBzUFZmYi9LUVV4Vi9iOXEwQTMyR2Urd1lOKzFHNTY2NnQ4Q0cz?=
 =?utf-8?B?RWgzdWExMFpSS0dMSVBYRW5MUjJVVGw0N09GdmpuZGVPTEI1c2d6bXJ6WStE?=
 =?utf-8?B?VnhTRmhvbzJva2dRZ215czVLTE1ybFhOQmNuYUV4Zlp6MDV6NjdqOUdQa3dr?=
 =?utf-8?B?cDhhbXBLNFFxSjNlZTVoU0oySFNRMklkWVFvanpkbGJqNTlrU2RZMWtRcmxV?=
 =?utf-8?B?Titxd05BdVFEZWtGZ0hSS2dYOE8yc1RFZUh3TlVZckdFZ01NWExEcjNnSHFI?=
 =?utf-8?B?QXg2aHU0SXZhalhzdFk3bnhFeHZCdjBPbWR0ekVQc3dBck80R2QwU1F6ejV5?=
 =?utf-8?B?M1Z6bjRqKzQzWFVNdGtSQlNuWGhYS0RXN1VMWnA4cXo4em5SVTR0dWdPdkFo?=
 =?utf-8?B?ayttUTJrUjc4YVJONnoweW4yRC82LzdYZGdnTGxqM01nTXpzaDhhVXFlektV?=
 =?utf-8?B?N2d4YUd4QVppK3Rwa1pEWG9NSW5OTEY4YXBzMmFwVDV6NUE5bW0vSS85RldP?=
 =?utf-8?B?S01tTGpoOFFQdFRIUDUreHBoT2NLNU96OTQ2b1BnZWFPbEN1dCtzTHExc1JL?=
 =?utf-8?Q?R4+2Hno11wgkeEzo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Ett4Hq9GAZ0Fbo0rMSJ4+vnVj2cvxI8L/jOWCtxJfBG2Y7eCBCMaMg9tOpFA4OBLnpmTBDK3BLNyGE7+EmEiar+kb8jgRtaqKD3eqLJkpEPkZvd6Hdk9nodEnLb73B66KZ2S5821E4+DxrB3TYMrwO1eCHkJ9sFACwp2UxT7Dl0igLC853JcpZKUpdh67vW8LsUkJVaKzzFx25EU5qdJsKRHTDRkiozXepZVrvDlyXGs1wk+zPu4NWp/wfbA0FdkyT8sMHXo6YN+ynAmbdTdm6d7+38ehyVB6qoXyHwAk2rrBntUkyLF8eiviFk9L/lqfdL9rkn8C5i93lFQBn3UNA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0ab0ee-da22-40c4-8784-08dee584b0ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2026 10:58:39.5200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RxPBl28CNBnpmKK52m9pCUHAbpv9BpsXk/yxioOAx9Cy35W6hbGxYz1kIO1TkOrDJh2v7+N9UizPXPoDAUgcetY9UGpeZYAhysgjnTh0Hf/AbIRAn3PHvl1Fpm+jRuA/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8743
X-OriginatorOrg: intel.com

VGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCBhMGQ4MmZiODUwNTMyNmNiYzUzZGM5
YTBjMDhmOTdkMTExOTdiYjMwOg0KDQogIE1lcmdlIHRhZyAnd2lyZWxlc3MtMjAyNi0wNy0wOScg
b2YgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvd2lyZWxl
c3Mvd2lyZWxlc3MgKDIwMjYtMDctMTAgMTY6Mjc6NDUgKzAyMDApDQoNCmFyZSBhdmFpbGFibGUg
aW4gdGhlIEdpdCByZXBvc2l0b3J5IGF0Og0KDQogIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2l3bHdpZmkvaXdsd2lmaS1maXhlcy5naXQvIGl3bHdpZmkt
Zml4ZXMtMjAyNi0wNy0xOQ0KDQpmb3IgeW91IHRvIGZldGNoIGNoYW5nZXMgdXAgdG8gZDEzZDVk
Mjk5YzExYjdiZDMzNjJkNTY5MmM1NjIyNWQ5ZTE3NjY2NDoNCg0KICB3aWZpOiBpd2x3aWZpOiB2
YWxpZGF0ZSBTRUNfUlQgVExWIG1pbmltdW0gc2l6ZSAoMjAyNi0wNy0xOCAyMjozNzozOCArMDMw
MCkNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0Kd2lmaTogaXdsd2lmOiBmaXhlcyAtIDIwMjYtMDctMTkNCg0KVGhpcyBQ
UiBjb250YWlucyBxdWl0ZSBhIGZldyBmaXhlcywgbW9zdGx5IGZvdW5kIGJ5IExMTXMuIE5vdGFi
bHk6DQotIG1pc3NpbmcgdmFsaWRhdGlvbiBvZiBUTFZzIGxlbmd0aA0KLSBtaXNzaW5nIHZhbGlk
YXRpb24gb24gdGhlIHJldmlzaW9uIG9mIEJJT1MgdGFibGVzDQotIG1pc3NpbmcgdmFsaWRhdGlv
biBvZiBmdyByZXNwb25zZXMgbGVuZ3RoDQotIHByb3RlY3QgYWdhaW5zdCBkb3VibGUgZnJlZSBv
ZiBSWCBwb2ludGVycw0KLSBhdm9pZCBkb3VibGUgZGVyZWdpc3RyYXRpb24gb2YgdGhlIHR6b25l
IGNvcmUNCi0gdmFsaWRhdGUgZmllbGRzIGluIEZXIHJlc3BvbnNlcyBiZWZvcmUgdXNpbmcgdGhl
bQ0KLSBmaXggb2ZmLWJ5LW9uZSBpbiBXTEFOX0VJRF9FWFRfQ0FQQUJJTElUWSBwYXJzaW5nDQot
IEFkZCBtaXNzaW5nIHN1cHBvcnQgZm9yIFVOSUktOQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpBdnJhaGFtIFN0ZXJu
ICgyKToNCiAgICAgIHdpZmk6IGl3bHdpZmk6IG12bTogdmVyaWZ5IHNjYW4gaWQgcmVwb3J0ZWQg
YnkgZmlybXdhcmUNCiAgICAgIHdpZmk6IGl3bHdpZmk6IG12bTogY29weSB0aGUgY29ycmVjdCBU
SyBsZW5ndGggZm9yIHJhbmdpbmcNCg0KRW1tYW51ZWwgR3J1bWJhY2ggKDMwKToNCiAgICAgIHdp
Zmk6IGl3bHdpZmk6IG12bTogZml4IGFuIG9mZi1ieS0xIGJvdW5kYXJ5IGNoZWNrDQogICAgICB3
aWZpOiBpd2x3aWZpOiBtbGQ6IGZpeCBhbiBvZmYtYnktMSBib3VuZGFyeSBjaGVjaw0KICAgICAg
d2lmaTogaXdsd2lmaTogbWxkOiBkb24ndCBwYXJzZSBhIG5vdGlmIGJlZm9yZSBjaGVja2luZyBp
dHMgbGVuZ3RoDQogICAgICB3aWZpOiBpd2x3aWZpOiBtdm06IGZpeCB0aGUgRkNTIHRydW5jYXRp
b24gbG9naWMgaW4gZDMNCiAgICAgIHdpZmk6IGl3bHdpZmk6IG1sZDogdmFsaWRhdGUgcmVvcmRl
ciBCQUlEDQogICAgICB3aWZpOiBpd2x3aWZpOiBtdm06IHBhcnNlIGJlYWNvbiBub3RpZiBwZXIg
bGF5b3V0DQogICAgICB3aWZpOiBpd2x3aWZpOiBtdm06IHZhbGlkYXRlIE1DQyBoZWFkZXIgYmVm
b3JlIG5fY2hhbm5lbHMNCiAgICAgIHdpZmk6IGl3bHdpZmk6IG12bTogdmFsaWRhdGUgc3RhX2lk
IGluIFRMQyBub3RpZg0KICAgICAgd2lmaTogaXdsd2lmaTogbXZtOiB2YWxpZGF0ZSBzdGFfaWQg
aW4gQkEgd2luZG93IHN0YXR1cyBub3RpZg0KICAgICAgd2lmaTogaXdsd2lmaTogbXZtOiB2YWxp
ZGF0ZSBtYWNfbGlua19pZCBpbiBzZXNzaW9uIHByb3RlY3Qgbm90aWYNCiAgICAgIHdpZmk6IGl3
bHdpZmk6IG1sZDogY2xlYXIgdHpvbmUgb24gZmFpbA0KICAgICAgd2lmaTogaXdsd2lmaTogbXZt
OiBmaXggc2NoZWQgc2NhbiBJRSBzaXppbmcNCiAgICAgIHdpZmk6IGl3bHdpZmk6IHBjaWU6IG51
bGwgUlggcG9pbnRlcnMgYWZ0ZXIgZnJlZQ0KICAgICAgd2lmaTogaXdsd2lmaTogbXZtOiBkMzog
dmFsaWRhdGUgRDMgcmVzdW1lIG5vdGlmaWNhdGlvbiBwYXlsb2Fkcw0KICAgICAgd2lmaTogaXds
d2lmaTogbWxkOiB2YWxpZGF0ZSB0eHFfaWQgaW4gVFggcmVzcG9uc2UgaGFuZGxlcg0KICAgICAg
d2lmaTogaXdsd2lmaTogYWRkIHN1cHBvcnQgZm9yIGFkZGl0aW9uYWwgY2hhbm5lbHMgaW4gTlZN
X0dFVF9JTkZPDQogICAgICB3aWZpOiBpd2x3aWZpOiBtdm06IHZhbGlkYXRlIFRYX0NNRCByZXNw
b25zZSBsYXlvdXQNCiAgICAgIHdpZmk6IGl3bHdpZmk6IGZpeCBwb2ludGVyIGFyaXRobWV0aWMg
aW4gaXdsX2FkZF9tY2NfdG9fdGFzX2Jsb2NrX2xpc3QNCiAgICAgIHdpZmk6IGl3bHdpZmk6IHZh
bGlkYXRlIHBheWxvYWQgbGVuZ3RoIGluIGl3bF9wbnZtX2NvbXBsZXRlX2ZuDQogICAgICB3aWZp
OiBpd2x3aWZpOiBtdm06IHB0cDogZnJlZSByZXNwb25zZSBvbiBzdWNjZXNzIHBhdGgNCiAgICAg
IHdpZmk6IGl3bHdpZmk6IHBjaWU6IHZhbGlkYXRlIEZXIHNlY3Rpb24gY291bnRzIGluIGl3bF9w
Y2llX2luaXRfZndfc2VjDQogICAgICB3aWZpOiBpd2x3aWZpOiBtdm06IGZpeCBvdXQtb2YtYm91
bmRzIHRpZF9kYXRhIGFjY2VzcyBpbiBCQSBub3RpZg0KICAgICAgd2lmaTogaXdsd2lmaTogbXZt
OiBhZGQgYSBjaGVjayBvbiB0aGUgdGlkIGNvbWluZyBmcm9tIHRoZSBmaXJtd2FyZQ0KICAgICAg
d2lmaTogaXdsd2lmaTogbXZtOiBmaXggYSBwb3NzaWJsZSB1bmRlcmZsb3cNCiAgICAgIHdpZmk6
IGl3bHdpZmk6IGFkYXB0IE5EIG1hdGNoIG5vdGlmIHNpemluZyB0byBmaXhlZCBtYXRjaGVzIGFy
cmF5DQogICAgICB3aWZpOiBpd2x3aWZpOiBib3VuZCBhbGlnbmVkIFRMViBhZHZhbmNlIGluIEZX
IHBhcnNlcg0KICAgICAgd2lmaTogaXdsd2lmaTogZGJnLXRsdjogYm91bmQgYWxpZ25lZCBUTFYg
d2FsayBsZW5ndGgNCiAgICAgIHdpZmk6IGl3bHdpZmk6IGFjcGk6IHZhbGlkYXRlIFdHRFMgdGFi
bGUgcmV2aXNpb24gaW5kZXgNCiAgICAgIHdpZmk6IGl3bHdpZmk6IHVlZmk6IGJvdW5kIFBQQUcg
cmV2aXNpb24gYml0bWFwIHNoaWZ0DQogICAgICB3aWZpOiBpd2x3aWZpOiB2YWxpZGF0ZSBTRUNf
UlQgVExWIG1pbmltdW0gc2l6ZQ0KDQpQYWdhZGFsYSBZZXN1IEFuamFuZXl1bHUgKDEpOg0KICAg
ICAgd2lmaTogaXdsd2lmaTogbXZtOiB2YWxpZGF0ZSBTQVIgR0VPIHJlc3BvbnNlIHBheWxvYWQg
c2l6ZQ0KDQpTaGFoYXIgVHphcmZhdGkgKDIpOg0KICAgICAgd2lmaTogaXdsd2lmaTogZnc6IHZh
bGlkYXRlIFNNRU0gcmVzcG9uc2Ugc2l6ZQ0KICAgICAgd2lmaTogaXdsd2lmaTogbXZtOiBmaXgg
cmVhZCBpbiB3YWtlIHBhY2tldCBub3RpZmljYXRpb24gaGFuZGxlcg0KDQogZHJpdmVycy9uZXQv
d2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9jZmcvcmYtcGUuYyAgICAgfCAgMSArDQogZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9mdy9hY3BpLmMgICAgICAgfCAgNSArKw0KIC4uLi9u
ZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9mdy9hcGkvbnZtLXJlZy5oICAgIHwgMzMgKysrKysr
KysrKy0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2Z3L2FwaS9zY2FuLmgg
ICB8ICA0ICstDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9mdy9wbnZtLmMg
ICAgICAgfCAgOSArKy0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2Z3L3Jl
Z3VsYXRvcnkuYyB8ICAyICstDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9m
dy9zbWVtLmMgICAgICAgfCAyOCArKysrKysrKy0tDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9mdy91ZWZpLmMgICAgICAgfCAgMiArLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L2ludGVsL2l3bHdpZmkvaXdsLWNvbmZpZy5oICAgIHwgIDIgKw0KIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2ludGVsL2l3bHdpZmkvaXdsLWRiZy10bHYuYyAgIHwgMTMgKysrKy0NCiBkcml2ZXJzL25l
dC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2l3bC1kcnYuYyAgICAgICB8IDE4ICsrKysrLQ0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLW52bS1wYXJzZS5jIHwgNjQgKysr
KysrKysrKysrKystLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkv
bWxkL2FnZy5jICAgICAgIHwgIDcgKystDQogZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXds
d2lmaS9tbGQvbWFjODAyMTEuYyAgfCAgMiArLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvbWxkL21jYy5jICAgICAgIHwgMTAgKysrLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L2ludGVsL2l3bHdpZmkvbWxkL3RoZXJtYWwuYyAgIHwgIDkgKystDQogZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaW50ZWwvaXdsd2lmaS9tbGQvdHguYyAgICAgICAgfCAgNCArKw0KIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL2QzLmMgICAgICAgIHwgNDYgKysrKysrKysrKyst
LS0tLQ0KIC4uLi9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vZnRtLWluaXRpYXRvci5j
IHwgNTUgKysrKysrKysrKysrKy0tLS0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3
bHdpZmkvbXZtL2Z3LmMgICAgICAgIHwgMTAgKysrKw0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2lu
dGVsL2l3bHdpZmkvbXZtL21hYy1jdHh0LmMgIHwgMjUgKysrKystLS0tDQogZHJpdmVycy9uZXQv
d2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vbWFjODAyMTEuYyAgfCAgNyArLS0NCiBkcml2ZXJz
L25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9tdm0uaCAgICAgICB8ICAzIC0NCiBkcml2
ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9udm0uYyAgICAgICB8IDQzICsrKysr
KysrKysrKy0tLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL3B0cC5j
ICAgICAgIHwgIDQgKy0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9y
cy1mdy5jICAgICB8ICA5ICsrLQ0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkv
bXZtL3J4LmMgICAgICAgIHwgIDUgKysNCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3
aWZpL212bS9zY2FuLmMgICAgICB8IDEwICsrKy0NCiAuLi4vbmV0L3dpcmVsZXNzL2ludGVsL2l3
bHdpZmkvbXZtL3RpbWUtZXZlbnQuYyAgICB8ICA1ICsrDQogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aW50ZWwvaXdsd2lmaS9tdm0vdHguYyAgICAgICAgfCA0NSArKysrKysrKysrKysrKy0NCiAuLi4v
bmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS9jdHh0LWluZm8uYyAgICB8ICA3ICsrLQ0K
IC4uLi9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2dlbjFfMi9yeC5jICAgIHwgIDkg
KystDQogMzIgZmlsZXMgY2hhbmdlZCwgMzgxIGluc2VydGlvbnMoKyksIDExNSBkZWxldGlvbnMo
LSkNCg==
