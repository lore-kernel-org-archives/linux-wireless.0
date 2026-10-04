Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8293043991E
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791122088; cv=fail; b=fhG+sRBqLG48X5JuR+p9dejzBh1mVkXrJ9vFxZWDxNqeJZgoVILmd2AFqOYvsu8LAaHIeiIXGLI7J0TW52QpTF+jpMuXbFhygrgdD2Zj8SUk3d3TnqKqT0z1n5JyvbUeZ9Wq3f81gvypydQkBRB5LZR1x2Bbd1BRKWnlWdWCW0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791122088; c=relaxed/simple;
	bh=z5aUXWS8EwjrjDI/I8Sq+JO5N2KsrAyjI6r9WOs18UU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A9Rd6lDgnBv9S1Rx/gunxzxm6kcz0IwkzAlvdF/nA/hELNjRAUTkvwi6oPKdhPdcK5GrIPqJDz9QcAuQkgbJQIrxvtdwjtTafeMap/FnmYh3/TVpcwXYjQlKyKwkFkz4YJ21IguXU2WesECp7yR24WEWf62KO3SAB4MM/ureWYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRaGoxuO; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRaGoxuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791122085; x=1822658085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z5aUXWS8EwjrjDI/I8Sq+JO5N2KsrAyjI6r9WOs18UU=;
  b=jRaGoxuO+geEUWLC8H5a4pYji0zOx9JZMD7Y+w8M8YKAxn2fUPnBflI4
   hA6HhNLma7nXcDo+nIvUyk+9aUlN60KaMOk1lATXYH7BSti3H9zGn5HzW
   WSkBR3oftUn30mEn8KA8Q2qFgveFRXhTOJIFoxEEV4FWVjZcty6yLBtyL
   JetjAjuYMFZjIaxemRiAfRw6+i/dganMvAm3pSl8Kg9MQzh4ZUUHrckVz
   lDOacRzMoQO6iTHPTEUbC5JrYJjMObtUBrm9AEYI+Xdg+qDZA+LVWbexK
   q5E/L+dzHu3mYweFrIZng6mxUpYfVD9ASbWnzPzW4gjlu32Z7Xws1SoHr
   Q==;
X-CSE-ConnectionGUID: RCTMxEo7Sq6TXlhi7z6Bag==
X-CSE-MsgGUID: pwbSqjm+RFCyEBEg9nu6sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="117333936"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="117333936"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:54:45 -0700
X-CSE-ConnectionGUID: Q7Btx34iRACv5sQiCdpNzQ==
X-CSE-MsgGUID: 6H+gvgmITMqfBaJ9HHdH0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="612250"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:54:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 06:54:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Sun, 4 Oct 2026 06:54:44 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 06:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwC1DsO3zxuboK84yEjrf8UYT+62oTa+VCAeKSKIgjN22oUtSuSBS+LaWpAN0RTwfxcHOo89suS25U21Y2CVOcAEAO2yXbHBog13RVXxwjEiY961nwXhGNNViLHVqlMfHTgNgGdJiDEIjV3GKzLssLuuugfppQBaL+78FhJrPRpv/QC3DlitDaF/czJPb4G8o/M6rFjsKQtraG+uW/ItClJZIiG2DA+9f/FSED3dwSwz+bczBD+rcpsC2nKCNLoKkAV1SKy9kyVF3L9waw4D4Ku6e7cgVteP5lR0+Vl6WqXfxQC/v/Hx7MR/NW/hY9si047KMKbs06btNFWfEBJRhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5aUXWS8EwjrjDI/I8Sq+JO5N2KsrAyjI6r9WOs18UU=;
 b=etlr+qmGC2ZYzcBx0+spRsAYyHnDxYY3rQvq5GNh9THXI3w11oMMz/nB6VtrewF2KUc/etJQQGAhs6Qs8w09fpDYJlClqUKkrS3IqiMGNeyGZ0JO7KTrISmOvKWGZJZ1Ln0/+EHcVZ+zCMhpRcyQCA2NaGAk2mJApz8PbUjeIZn8DYyhT93pTBupOttQ8CPKatgc8Ov/t9nHcOZnAK+X38eo+pmp6SRp9C3Am/TiXWox7o4x3q3siqyxDYaNBEBOX9yWhMBFWPeLVmHPWEM8tYlOyoDRPEtIc40sPRbw02CD9n85gwQ7VZR6wIWYG3kCgB500IwFmjxPFWtiai6pBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB9526.namprd11.prod.outlook.com (2603:10b6:806:4c5::19)
 by CY8PR11MB7339.namprd11.prod.outlook.com (2603:10b6:930:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 13:54:37 +0000
Received: from SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05]) by SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05%5]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 13:54:37 +0000
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 00/11] wifi: cfg80211/mac80211: add NAN Instant
 Communication support
Thread-Topic: [PATCH v2 00/11] wifi: cfg80211/mac80211: add NAN Instant
 Communication support
Thread-Index: AQHdVAPuAkZKoDr5H0GOPnaUsq17kLbtZDgAgAABEKA=
Date: Sun, 4 Oct 2026 13:54:37 +0000
Message-ID: <SA1PR11MB9526B4A283328E63156D97F5E9972@SA1PR11MB9526.namprd11.prod.outlook.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
 <696ff630bcdc7295d9de88ad7583b9aa136111f3.camel@sipsolutions.net>
In-Reply-To: <696ff630bcdc7295d9de88ad7583b9aa136111f3.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB9526:EE_|CY8PR11MB7339:EE_
x-ms-office365-filtering-correlation-id: 5441f4de-5652-4a80-8430-08df221f078f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|38070700021|4143699003|56012099006|10067099003|11063799006;
x-microsoft-antispam-message-info: nfJ6X0zqCgHqlArzALDPeGNY6F6R/HUT7DwcEmZ4lhe33neu9sZEhDfDikNxkwRhKaflPXjOPbi3NIKJMbX66CbN2PgHl5VUI+9DVO2pbWy3p4sE1MXaCfWJ3m5KQsKQzERFZULmSDsSUSGcFy4VJsa9nM6XOAApd+ZcVigyCfsJgubls9GHCZvCFEe6drq1fEPoRpo7lSJjAfYYKJ8RXOX437zmF8UO+EjfJve5rdiY4FvUjQMx1cdDmrJRE7ihOn3TBYft6sFyFIW96YpXdQ7NdBMyfY78U2ZiAWYguIkfmZ8UfdeMSBjNYnyfRJ1Ij5PMewCLigYbQay3c1F4ueYYAtfeKu6MDFfbFfpXEgiXCIDUIWnOiLokeGF8GQu6ZunIoTnC1VzcKhSkB/lG+iz16DNhbmoxWfpb1NNXgXGCDiw3eRugfr1maTIcI/vK9O1q/5duTCh4WerWvvL3fp5j0GlwdFWvo29E7vXVkWD36tudOt+/a6H3eVWVsrC+mNii0dZugSqYJ9+eA63VVGPlRBX1tB1N7iEcRmjFXMQeeJ9+p5KF7617VUx0/aUusq3CxPFyC/jihpu0DG7h7Qs3ekjSj/d4VGaIZfUC3meX34NYP5DrO/OzGZH4HI7JCHlAhOF90rh8XNViGETiCg8kgMhCmq+AiXv+uXhCW6jjZOCRldFBD6sKx6V4eAtm4HLQkQwjtMyqs/rQrPI+9RrihrDRvAmBMbqxn/AGkHk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB9526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(38070700021)(4143699003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1NLUzFMVUcxTXVKWWJUcDJaUFFoWU1oemVWVG4zMGMwQ1d1VVpldUhlZkI5?=
 =?utf-8?B?TUprWVZPMUtmazVDOHY5ZlVwSDBSUDVVWDdKbTNjY1FLM0x0azlKdzM0cHE1?=
 =?utf-8?B?Kzk5SktGeVlKdEUyN1I2RXRWYXZYb2U1bE01R3lNR3hXMmFzQ1BXMjlEMEZP?=
 =?utf-8?B?VTBCZ3FodCtaSHgvcFE5Z296UUY4cklUbk45dzFpcnBNSWVvWnF4TjB5NkVC?=
 =?utf-8?B?bnJSSitUWHJ0TzVaaUNPNFIwZ2dVM1YxTU4rYURXRENucFFneFVQNUFoRXB1?=
 =?utf-8?B?SXFzVmZyNzhKR0ltaVVuTldVYXhXcnJqTFpPQWxDZC9QWE0zZEQ4WFNTZks2?=
 =?utf-8?B?RkY2LzVKOTJZMzgwbTBtTmlUM1RmQmhmN3FKSHFYb3hsa0tqN1ZMWVVTWE5t?=
 =?utf-8?B?b3ovOTQyb1BYamcrelRqR0V0ZXhwOU5GQlpPdnJjZUpzK1lDNnJLN0VQeE9W?=
 =?utf-8?B?RnBndzd4NzIvdlQ0RmZ5azdlRWRtT0h2b1RHL2Fpcm4rRlJyVUtWOTk4VkhY?=
 =?utf-8?B?RHRTSW82N0FmWmdRT0JMbGhEUXNsQnMwR2MzUnQzYkpaSHM4TlYvR0gwK1Uw?=
 =?utf-8?B?RnJ4dEN6RS82V0lDSU9kRjRPOEo2cHhha1BtZHZCdmpQRmlnTS9jOTM2OUVV?=
 =?utf-8?B?bEJVT0s3WmtlNFdqRjBOL0pvblZ0NWJXUms3RjdhWENVa0psdlVTWmtvdkFM?=
 =?utf-8?B?eWxVZzJBdXdSSW0zYmtsdTc5VWhTRkpuTUROZDJnSk5HRlFKTCt6dElMbjVY?=
 =?utf-8?B?NWhobWQvcHU0VDdORXo3VlhoOHBxRnZNci9PSVdPUW1kWTNwMTNGdG8zaW54?=
 =?utf-8?B?cUFpckZUZUdOcTRTRHMrL0puVCtzK2hLYkNVTGxUbWYzR3V4Y3d5SkxyRnE1?=
 =?utf-8?B?ck5tdXhpcUd3bGtJWVhRMHE0azd5Ykw0eEh5MzFCQXExUEtsUGRPemZVRHpl?=
 =?utf-8?B?ZnlGa0dwWFY0Mk9ZL3pXZDEwME1tZkFDdEd3R2oyRU95UDc5S2wzcGluQ21v?=
 =?utf-8?B?TE1RUmJHanFmeHFmNlo4ekNCQ21DZFpoMlZrUmV0SThoOEJkUENKbnIrYlBG?=
 =?utf-8?B?ZWtBWld3L1VsaWlTU3MwcXIvT2NIdDhsM1Jwd1o3em1TVkhrUVNVckticEpV?=
 =?utf-8?B?OW03OGxsQlBqYWwwVloxYmZ1THNJbk1ueHpqZTIyRzUwT2ZLRXcvN09Wb2Nq?=
 =?utf-8?B?Z3ZrNDFlUmdLVmwzSm16enBQV0I1bEFTc3ZRbk1zSGVnZFkzTlRDbm1tcTJk?=
 =?utf-8?B?NG56M01QRlR1MlVEWUtoakFSYytIOTBNRWRuOHhESGZMdTBkRFM4Sk85Sk1Z?=
 =?utf-8?B?NjYyUEdmbDYzeUYveStBM21UeW1nQmR5ci9vdzAyaE5yLzdNNGRvOUtTalFN?=
 =?utf-8?B?LzhqMTltdUQzdGs5aWFYTzlYRFhieUk0TXhkVSs3eTdyY1hXN0JobjRzRzdG?=
 =?utf-8?B?NmJJVjhLVG5WYW1uUmw1aUJEZnlRa3FMMmZOUXNFZ3B5a3g5ZFNqd01UNTVN?=
 =?utf-8?B?eWxNN3hiWFJWY2kzTjF1NmlaV25RZ214cU8zYUMvTjNJQUJWRUVUMXNra3N2?=
 =?utf-8?B?VFZjN0F5YXpGY3N3bCtod3JRS2hsbU9kaHEwcEptVUdvaDNobjVRUVg2b3Zi?=
 =?utf-8?B?amt5N291MTZ2K1BudmJEdmZUaGM0L0dFeGF2RnlVOGNhNW01am12NU1lWUxl?=
 =?utf-8?B?N2VWdzlKaDc0TkYrT0FVT1BvdlU2ZDJGRmdBM3lWbXR4M1Y0aWRWdHdvclJj?=
 =?utf-8?B?NTJDTEY5RzZScHRsUzJWRnl3Mk5XaTI3SUE1QUhkNVIxbTVqbG9OR29ld2R5?=
 =?utf-8?B?VlF5QjdlMzUwcDhoaVdyVHFTZlN4ZG5ELzVkSkI5RTVROHdrcnVKWGNkNTN3?=
 =?utf-8?B?cHJ6bjRJRW1WRXpGeVVKV1V2ZkN6TFY4bUtKUENiVVpzdnByejUvNVIwdWxI?=
 =?utf-8?B?Q29lSm5BWncwc1E0d0FKMm9HczlNS01aYW04ZnNhV29kUjlzcDFVSzBNNmRk?=
 =?utf-8?B?a2wxb0MyRnZKVTEyQnc5UGlzYkFiMmFZamNXLzdHQW02L3hQS3d5d0NRK3lz?=
 =?utf-8?B?Qi9NK25Bc0RHZUpsOHhYL1pMa0g4bE1pZkM1N09SSVRkR1JrRGdkdTJnRnZD?=
 =?utf-8?B?YTk3Mkw3L2UveDBRVmJyVW1BTFlNbVM0eENYZURJUDdTd2x6VUxFdm5EV0VO?=
 =?utf-8?B?d3BwL1RMZnZEYjFicWdPdVM0aEp0aDBiVlJVVnlOSHdEV3dRWE9EUGhMeE5I?=
 =?utf-8?B?SEVldGtjUWhXcWxPNVlLWTF3Q1lqTW9aTHJnS0VFQU1RT3A2NkJKQjIrOWhj?=
 =?utf-8?B?eTRKd3haTGVWL3daT0hTSzZhZ3N1eTF6RGR4TTduejFQODhjQVRYUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PC6PLyedgwA9BhLeGZm28N3KdJtcUD5Unff+Xr9t7r/37BfAK7/7PMONGqSpqZte/aKy0+5qIyPTYbb9/Rycx122WD9gDkwry8TqsRnBOGr6VyMPYPveoKgJ0F8I5h33tNmIUDY18JnEVJI/ytepn2ZQ1s9EW6dZVgRQ7JaEGc+Bx/6PuIBxypBgKhgq4/MtYJujipTVBKj4sxRJ42/B0Le9SsWvYjrbsST/oGsQPuMwhO3VHTMK/ekac/prgK/jiPvJNiYhi3aUPW3TsN18kpmfdtjJ4wSyrwxoVwtEJ6ju8Cju8h0CldfdkMxmqm1/ypZrSNIxpCHmX/K0IHqjzQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB9526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5441f4de-5652-4a80-8430-08df221f078f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2026 13:54:37.5671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eg4Xo+VKVeIxgiTRQJO2wHP4dWsYkWF/AzNdj0GpRJXpPiYqUZs3rKUgu1m3FmVYZ+Lq2Pj6QvN94qqPfQu8GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7339
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8
am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogU3VuZGF5LCBPY3RvYmVyIDQsIDIw
MjYgNDo0MiBQTQ0KPiBUbzogUGVlciwgSWxhbiA8aWxhbi5wZWVyQGludGVsLmNvbT4NCj4gQ2M6
IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYy
IDAwLzExXSB3aWZpOiBjZmc4MDIxMS9tYWM4MDIxMTogYWRkIE5BTiBJbnN0YW50DQo+IENvbW11
bmljYXRpb24gc3VwcG9ydA0KPiANCj4gT24gTW9uLCAyMDI2LTEwLTA1IGF0IDEwOjQwICswMzAw
LCBJbGFuIFBlZXIgd3JvdGU6DQo+ID4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBOQU4g
SW5zdGFudCBDb21tdW5pY2F0aW9uLCBpbmNsdWRpbmcgaHdzaW0NCj4gc3VwcG9ydC4NCj4gPg0K
PiA+IENoYW5nZXMgaW4gdjI6DQo+ID4NCj4gDQo+IFRoZXkgYWxzbyBubyBsb25nZXIgYXBwbHk/
DQoNClNvcnJ5IGZvciB0aGF0LiBJJ3ZlIGFwcGxpZWQgdGhlbSBvbiB0b3Agb2YgNy4zLXJjMS4g
SSdsbCB1c2Ugd2lyZWxlc3MtbmV4dCBhbmQgcmVzdWJtaXQuDQoNCklsYW4uDQo=
