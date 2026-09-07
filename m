Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB0D2BDC1C
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788803007; cv=fail; b=J4ylEGP5vP6t4uLp7NK/6ky39MveCtLOHisvmpuQ7ovQpjg5ARAtGsA4/g2FtKubmmmJdhwRBONPfNVRx3rlkH0Dfe/ZhwjOl8NtJ6P30L6C3GyImd1XkC4DIySYzGy84C4WwZ1dStjdW7QIHeDq62Zbb7xQTUDUSyuco6BFuQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788803007; c=relaxed/simple;
	bh=6az6JLS2GhFIjU3wOIZH25edRoD+aTEsrHY+iyI46H4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgvnjyNETJcFhAMqI31EVM8lQcoH8GXTi6VV0gD0wBdf0+a6PPw3A9Zha8Nw2KqvNr1XsQkKQ86ammglhb87EW9UoMLMBN2jZNbd5XX54ritJvCv/VCpSDyLgk6Z9QprCxQvZWdHqymTV9WLPtgfu3Vw5xhSp5mHI+ODnpU3JS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxE46X6o; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxE46X6o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788803005; x=1820339005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6az6JLS2GhFIjU3wOIZH25edRoD+aTEsrHY+iyI46H4=;
  b=AxE46X6oZKsyUU90m+vj+wiYD1jJPglgzc8abWvq9YdhM843dlbN4KEu
   BwWqzs32Iph1+bPm+dqJuJJaGCsptapjGKsx5fkeYCTYFS4DFA2Ge2rxu
   whL0QDZYk53/jwmZFsFasDvO9o5/h4ZQgem40Zf0vorkzqps5PVDsXrXW
   sAWX8tzLKdX+8xdEJFQ6anbbEW3Sh0kGCAuzwmQtZ1OY1nOzoQq3riHqz
   1i2Jgf2eU6fP5wIFnOm4ICZD3dlAx113vEyxAgNQfRL/hokdv0/nrF2Sa
   T1ndgyz3B/DPti5T4qTkMlWyO36pQ0X9OaIBH27jA7iyORPkxB6l3kvz0
   g==;
X-CSE-ConnectionGUID: lHvFzSzkRZKd4NqC/PsGYA==
X-CSE-MsgGUID: 5USh1eJiQ7qfqPb1XO1Hnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="106724151"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="106724151"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:43:25 -0700
X-CSE-ConnectionGUID: px4nMRj2Qhm9msklBPIpXw==
X-CSE-MsgGUID: 7dVqOWN3RXqSVa8fCYqLYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="309005061"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:43:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 7 Sep 2026 10:43:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 7 Sep 2026 10:43:24 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.47) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 7 Sep 2026 10:43:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvIU72jznw/Dt7zOTuOtRI1osvWO+z3c1mIgXwA0eCs9KX/EDgj7KTGTwfTqyNKiQN5CnSpSqZnKkeN+JttrBEtwEbdiptgP99HVqDdLWZJoYX5N99qgh3YzYEONSJiA3EFJB7djqo19jOjol3vDL2P73O/znw7GURav33BbfbKCSZy2DGAGPi+wxtYLtc4hJJCgpZhayqBioDr2n6BXq4Ce1YXhz7qnKnrmOSTDt2zLFp66bwXvwQvi14l0asiLKxt/XcQYbDxSaNkeb+gwPML5hsRzA8/9Ve9b1Py576dlbYaawxjd28b8nOUtVWM8TOH/WOlsxTUCxPX10vsHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6az6JLS2GhFIjU3wOIZH25edRoD+aTEsrHY+iyI46H4=;
 b=co3J6PWd8+f4NBd8PvOVhp1pDmF6sLqNyGg/7CJyy/D7TvoOdliXy/xgY4kecInbFi19zchR1JYMeLoL3IX4yoweCBU0z1IrL0Mmhf0FfBFQQvQvEZOiX9A9AZHeNEHr1Hhevk9haDd9xrFqOqm1grQVa1lcacFmTOH084oOx9zW4MZV4PiT+o1ulMkBaVAYqhXZyM1Iu1fIg4INgA5GwAyuNWPlGUosJTJmoAgWxg/o4P/zCUeH1m8Xfi2BBxWpcH2lcmBilOIEglxIqVasyA4LfsdUFzJvHqJA/Wa5vw8QCwmnnDUrs/8YKcsCIvSsggEMBkI+yDlI4GjMkH2ibQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by DM4PR11MB5278.namprd11.prod.outlook.com
 (2603:10b6:5:389::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 17:43:19 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 17:43:19 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: RE: [PATCH wireless 1/2] wifi: cfg80211: add
 NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
Thread-Topic: [PATCH wireless 1/2] wifi: cfg80211: add
 NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
Thread-Index: AQHdPu9MW8rCuQq8e0C8wbnyIIxUerbDYpIw
Date: Mon, 7 Sep 2026 17:43:19 +0000
Message-ID: <IA3PR11MB72131353C87665C254A995D428A3B22@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
 <497398008538f1be822d348bb80c726ebb0184be.camel@sipsolutions.net>
In-Reply-To: <497398008538f1be822d348bb80c726ebb0184be.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|DM4PR11MB5278:EE_
x-ms-office365-filtering-correlation-id: da776dd8-556b-4f5e-1be9-08df0d07813e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: gbmL9fxt6j0b2A9mWugpzh9LVOvazUeXDA2udXYgnfM07EofQs+oLwjKDbRZBf0ahVpWkAygPfdJ7SWLSh6m1k6a/sO9YQIuzD7qu7ohFfr+B0AL2h+SUSPfrZHbHu2YSLAQHixKVB3fs3ou9ImA1laUAsjJMvWu+V0qas7nJQGYKg1UfgW4Kvgs9VFjwLDRNWYLU4vg/9IWzY8iVd2+tvEtipRDXWNzJDx60CrZiHNIhH10Bgeb9btQmOc1BlgyUQnNfZBucS6kyfTbsRSxdWKj/U5NDjWlptIt7ZK16+xYajVp+hUljyOqxglfbO2Wc2ixn4gZMs0iTX0yukF7qs50QW3Zis9lDgjsY+xEHvKxspHMAov2GyhiaIgz9sWS/k0rAVZCroG75qj7T3WLTmCh7LfpPTIcGoTgEBETya6J2vutX/BEhhC+JQu/YfUvBnIJpYTseCejsRuUB3xjfdMwc0I+nC20w2lCaf/irtp6mDJc6zmtMz32i0AcBEaqnrzA/nZGYvJeFEcll/Tj3sKK3foG5bhI1KUw9RaEt7lYj3l7FULOVYdvrJOhBX67IxVxzXkp7eupQ7zi92pMEW7gYGTY5aXjyndGFbzB/x+A5FB3ErUVOlwB2sIEig+0XNzhFi4yWJNhDfvxDUmYsVlOpILlGfbdgkm6LBuS+XRYMsIDgy/MAyHZlw9Tn6NdBM6FylWgnU1Pu2KMOKo8zhErXaeJEmfViSxyX5pG08w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXhjQmpkL25rcTBJY3E4K2N5OTlRcDRXN1VZMWswWW4xaytPMXJsd2F6WHJT?=
 =?utf-8?B?aFRrWWtJOHRDL0VCRGczbCtXNU5CWkozTjFqVE1td0dKNXJyRkJpOVhMbzhV?=
 =?utf-8?B?UUZrWDZlelRmTzhXandmSGJsWUttZXh2RVE2cUVURjRIZTJGdjVjbDY1eUJE?=
 =?utf-8?B?UDU0WmRzNkc3M05UNDI4STVjNk9zeG9NTFMvWkVtcHRIcXg2d2d6V1AzbitV?=
 =?utf-8?B?RVhBRmV6VFZRZ2pLWCtGVTFLdjdWbEVzbWgzb0tDNDZuUy84Y2I5b3h6RGNT?=
 =?utf-8?B?Njc5aFRmcHRnQVB4QUxYckE5cXpPL3ptbXFGQWgvbTUrRkRoSVc1N0E0WGdq?=
 =?utf-8?B?N25kbW0rQkl6eng5WjcxSVpjU3MzL2w0MFZmZXEzNjUxRXVzSGdFSWlySGgr?=
 =?utf-8?B?LzhYRVVXbGg5YXM0TVpybUsxMWtMYjJrMzBjQU5hd080L3czNFg0MTF3c3BW?=
 =?utf-8?B?WHZYbzZQRjNqeGVSdXNzVzgyaUhjQTYrUHEyeEd6N0JrSWZtMHIySkxHR0t1?=
 =?utf-8?B?c2dtNzY1OVk3cHNBY2lVWXYwZzR0bllPalV1alZOQmdIcFBsNDAybkNVcDB4?=
 =?utf-8?B?anNaOVdxVXdZVWJlZ0p3UGxLMlhhdDdDNGk2Y2dMY09EWlZUQlRhSm5xZUQ3?=
 =?utf-8?B?QTNNQnU0RGl6M3I5ZUs0dHIwOENzT1hrNnVsaktoNisxaXBHK0dmZ00zZWJJ?=
 =?utf-8?B?M2QxU2pGbTIyUXppNVZsakh3blh0VWZCZy9oWCtxbmQwVzdHbDFobDhDdjdi?=
 =?utf-8?B?Y0RZZS9INGFRK0hpVjhLM0RrbjRVSzdKenNIQmRhNDFwZUk2cDdjSGVMelVa?=
 =?utf-8?B?bUp3UVlKb2VwV0hxdU9mWjhTYVQzc2FYRjh6Tzd2TGJuTG5xNjI5Uk1Xelk3?=
 =?utf-8?B?cWJwQ0FmZUg3eUEvc0tyc2hnM29pZm50U29rbjlOcTNTK3VXMUFqdkVmcm1r?=
 =?utf-8?B?NTl0Y2xWR1V4WDF6dy9qcEhqZkdQNEhZTkRSbVR1d0lZa0JQelJ2VWRqNTll?=
 =?utf-8?B?MUduL1lmVzJOWjhlQVNGZ0NBSjRlZ2Vwd3grWnZhTnI2ZHUxREtmcGQ0T3k4?=
 =?utf-8?B?MHgrREhjYTQ4K3hNTU1pWkJBNHBLUkpwTjJVck5VS3VzYm9JWXlUMHNJT1Jo?=
 =?utf-8?B?QVJNdGpyQ25XSVZmdDd4RmxhOWZHWXJyR2R5SnlCWnhaYWxkUzkxMjBySlBu?=
 =?utf-8?B?Si9JSFlYcEx2OThiKzY0Q0NIZEZaaGtkU2dPVVg4WWd5SzBNRi8vaHZXNE1q?=
 =?utf-8?B?dXg5VmNiY1kvYW96QURPTWo3YlBHL0V3Q1JEeXIyK1o0OUpqS1YrenlLQ1k2?=
 =?utf-8?B?V3hVQ1FFcDFEUElmd25wVUdCR0RPZDFaZWUwSmJscHViRjlOS21nczZWYWlC?=
 =?utf-8?B?UzFKSjhGZzFPa3hIcEkrTHZRdU5mVkJxa29LV1VhNlVtZDREZnhJRklzbTJF?=
 =?utf-8?B?aUxxbVpwT2EyZXJBclZiSHgreTR3UFhOQTlhRlpWSllWdXlldk1aTzBvNTJT?=
 =?utf-8?B?aFlBdGVzV3JSVnRJTFdJWkNzN2xraWFJbjlBV1pqemw5MFNqam1pSjhLOENn?=
 =?utf-8?B?TlRYamRHUzBSenJHUU5uK01LRUxPcGNTVjNha2pqVlMrbzIyUlI5SytTS2Ew?=
 =?utf-8?B?WUJUbTdtd0ZiNkZVVWtJOWZrK0NtZTN2bm5TZWlkVXlsd1dNS1U5TG5OM1dT?=
 =?utf-8?B?RjEvQ1prZ2lrSFplcklWOVhzNU5PMnltWHN5alBhc1NxMlMvbkx6bFJqSER1?=
 =?utf-8?B?b2g1MjBJVEVjSTRvUUVYcStBVVZBQzMwSWtYRDZPYmxUT1N1d0dSWWhOOW1N?=
 =?utf-8?B?L0Y5eVZORW45V2orSy8zdlI3T2doYk8veU5hdlBZczNnek4xeUZxdEtlVEk4?=
 =?utf-8?B?aFVYWlFvWDNXVGxmS3ZBbngrVDVuMURhcit0RFl1VEdmV0lxbmVKallTbmNS?=
 =?utf-8?B?U1pxSUNYbzlaT1UxSXVrVk1YdEdWd0xkR1c0R2lVSGNhWGpGTlpPcnpIQmFK?=
 =?utf-8?B?OUNTOHdLZkZpY1UwZ1pDc3kvL2kxN0N3cTU0Rk52OEpDTXpiUStPTDFUb05B?=
 =?utf-8?B?K2ZBVFFOelVIYnRTWFl5THN5UndvQWV5SkNGKzhWdWxHRUE4V1IvS1RjUVEr?=
 =?utf-8?B?OE5vKzhMYnZZcVdtY1k0L2dnaGFxbmZKNmJkRitwbkdpNU5PTDVXcnBiQUFq?=
 =?utf-8?B?WkFWS0tCRlZmbFc3ejVDaU0zYUZLSFN1RFlXb25jZEtCR2VjQmQ0Y2JZNGEz?=
 =?utf-8?B?RHBXZ0Q4YmJ3MWVWczV5NnRZVkJ0TVN5UFV5QllMZGpDU1RXNmpONjNHb0Uv?=
 =?utf-8?B?VE51azQ1UGJkM1FvRkxnZGpJei90U2haeDJYK0NYVzViRGRKTDVHK1dNMHFQ?=
 =?utf-8?Q?R10RURQ0/s7p06dM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Nx7mA+JlAnftdMwTseIrPuKFjB4pB+2OPecsqqABg/GqRCorUpPV+GI6oqSsEHUnXx+ESLkoluiTmrwG9RdyWMueZaLa2NkMbSZ2PRlXf5hhIFc9duu80N4lCDu4J3hkF9OZ+83C4YxfY9Kx/7KEpmsuCKPttzXe+B10zYNWFxdB/1kd0FX5kUtQfVPkXGaE4yjJKGpX3hP5IuXV72SXbQm8ZmnEGncMxDa2nlty6SxyrWuIb24UtyKPwjKnjqk557WghEu+Zt5olfxvBte4CghgV/oKZamAxpsG8wrkjoa9JS9A0BVNEkObKCtkl/yLn4MRs5eXDAd8D8SNHHrm3g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da776dd8-556b-4f5e-1be9-08df0d07813e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 17:43:19.3988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3mJJC8j1tTDQz6z7kpz9hlE1fZw16UNs0JVMYr4TNWISkAeFxTbJw/NPeyjRXkvTC56Cd0EDfS5tLp8Ogg348FV0bcJx08MHA8/uiO57jgg1XN5lewEt+9xarqVjc+B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5278
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8
am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogTW9uZGF5LCBTZXB0ZW1iZXIgNywg
MjAyNiA4OjM1IFBNDQo+IFRvOiBLb3JlbmJsaXQsIE1pcmlhbSBSYWNoZWwgPG1pcmlhbS5yYWNo
ZWwua29yZW5ibGl0QGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVs
Lm9yZzsgT3RjaGVyZXRpYW5za2ksIEFuZHJlaQ0KPiA8YW5kcmVpLm90Y2hlcmV0aWFuc2tpQGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB3aXJlbGVzcyAxLzJdIHdpZmk6IGNmZzgw
MjExOiBhZGQNCj4gTkw4MDIxMV9DTURfTkFOX1NFVF9OT05fRVZBQ19DSEFOTkVMUw0KPiANCj4g
T24gTW9uLCAyMDI2LTA5LTA3IGF0IDIwOjM1ICswMzAwLCBNaXJpIEtvcmVuYmxpdCB3cm90ZToN
Cj4gPiBGcm9tOiBBbmRyZWkgT3RjaGVyZXRpYW5za2kgPGFuZHJlaS5vdGNoZXJldGlhbnNraUBp
bnRlbC5jb20+DQo+ID4NCj4gPiBBZGQgYSBuZXcgTkw4MDIxMV9DTURfTkFOX1NFVF9OT05fRVZB
Q19DSEFOTkVMUyBjb21tYW5kIHRoYXQNCj4gbGV0cyB1c2VyDQo+IA0KPiBJJ20gbm90IHRha2lu
ZyBhIHdob2xlIG5ldyBBUEkgdG8gd2lyZWxlc3MsIHRoYXQncyBub3Qgd2hhdCBpdCdzIGZvci4N
CkkgYXBwbGllZCBpdCBvbiB3aXJlbGVzcy1uZXh0LCBhbmQgd2FzIHdyb25nIGluIHRoZSAiZ2l0
IHNlbmQtZW1haWwiIHN1YmplY3QuIFNvcnJ5IQ0KUmVzZW50Lg0KPiANCj4gam9oYW5uZXMNCg==
