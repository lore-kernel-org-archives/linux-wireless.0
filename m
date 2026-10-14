Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF7B4EDCD6
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791972287; cv=fail; b=r5iAGkKzdmPQKJceWgUItni0Zv6jNll2UQg0wdh288jucnqW1pPXuydnX8datOFaPSIVVO9tGfyGUk5T79Ef4OVemwFScoJDrqONKPKh7xKWSvz6yJUAIrv9oRWo0Hbd58CXYfTxRXgY3PFw4kMFE5uq31B0fHKma7cbFcWEXdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791972287; c=relaxed/simple;
	bh=6GJ36TS87bweQdipBQnPeQRBsCnIc/Z3H4ozALOXlRg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s4TgNbQ8dNzZuOjy+L87c7IvxK/HWCW+qocPNs26zsQh5S8dAjV6cIocsBgEWGENvFSYuBaXiUcIDGoR+sx8Lx8rGdtNg+EP0BYRkoPyIGO99/VWY8Vj2OI35oEMMcFYZnTJsgv/C/V220RgXwipvtcUxTVbHHo1QKhqkcPAfeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8AvTWzG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8AvTWzG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791972285; x=1823508285;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=6GJ36TS87bweQdipBQnPeQRBsCnIc/Z3H4ozALOXlRg=;
  b=B8AvTWzGtKa08XdFZF4dYjZASkWbf4fYwSHxF5firVc3qzgf6xXsMwEt
   CnHe8pYwnwvB6RZXOqA1oAC2pc2NzyjuI9yZy0fVzXbooe/nOa6CIeMPx
   0r+xEtG0wU3UV13zOwWnnevISlZ9v3gZM2l3XnGDO5ojRA9vC/IorXS9B
   7qZZbf4r1fgWFY/ffn4vvcLfg9yL09Hk+gTv7OBL5/YIXtMnBiZnoPdmi
   s29KCaN55phJ6A/c6oUK0kGxl2zaxq2eMY7v7z7ScM0ZekvmLBbz3uW/Z
   WUkiGiw6rdkARDp9G8NftiHp/TCiz3fKensYP9F9suzwKhkwkKcaFH4lY
   Q==;
X-CSE-ConnectionGUID: 4caGuxreQuCFSwXJrlwT+g==
X-CSE-MsgGUID: WyQTdxNqRVqweBvt4DYQlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="600737"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="600737"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:04:45 -0700
X-CSE-ConnectionGUID: AgOTjHhoQiCivEq7xD6l0Q==
X-CSE-MsgGUID: Rq2nlFxSTHW6x4fw33fbUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="3235988"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:04:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:04:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 03:04:44 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:04:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H57kXvCEpF1g3KZNWSatMoWVFdpXr5FIeChRfbT6fafg8q5t7hjQDtwBuw/lxhA3yiez1ndOTQmJDUXGw7bd3CPG2NbGH5wmj5e9LSvNil4XhK3izfGkfNuO3b7LUZGnox/wWh2dDvAxp1eOer6f6LGeDA31hPRHXw/G44NUwCna7HzuqU4+J2YK0ZKh1/vjkiZGaOlv5rV3XVtpxK63UnAetU+uoJPhwR8nsV8UvcKw5LH2g+em+L/oLq+fS3mBN+BrN5NUESHlmQ28KTup2R6WKL6iPICOJ2o4VAIAQx7LOKnebg5jmg0g3PiJUBAnD1Mr6z0uPtXSDR5XEFDkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GJ36TS87bweQdipBQnPeQRBsCnIc/Z3H4ozALOXlRg=;
 b=UKQuIVtSOqgTv3jl2QWx5Y8UPha3q5gemZlKgRqIGlY+cynmXKZ0E6PflJ6RyjxXQ4XHvGb08bSJAQYTb1b2tHu2w9WV6COAePHf9C5bdEI/pl7y/DUI0je2TLwI25EdR70Md63gknPtgF54wMHI2JYZcDXDfecrPCHIVsFTpcETThVfFYMmxTph06hxiUXmRiRZ5Tdl60r1/LZNKHHe+Oq1QjddhbucmJE5e30YXGq6v1ikqd3is31KkYzMICxcGBtfLIku3iqufvaxkuosCN/Qaw0+k72JTR4Gl7SdQYtXfxC6sv6WvFR3T5cavKZ10hK/VherEGckAjSXolII5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by MW4PR11MB6887.namprd11.prod.outlook.com
 (2603:10b6:303:225::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 10:04:36 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 10:04:36 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless
	<linux-wireless@vger.kernel.org>
Subject: RE: pull-request: wifi: iwlwifi: updates - 2026-10-14
Thread-Topic: pull-request: wifi: iwlwifi: updates - 2026-10-14
Thread-Index: Ad1bwBLREib4sUovSxuHArSIc7ODWAAAloYAAAA6LLA=
Date: Wed, 14 Oct 2026 10:04:36 +0000
Message-ID: <IA3PR11MB721313B4A0B0E07F4AF7F596D7A39D2@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <IA3PR11MB7213130F93D66D28E04328C3C1A39D2@IA3PR11MB721313.namprd11.prod.outlook.com>
 <655328be546511b780c15e96c5076846f2f30631.camel@sipsolutions.net>
In-Reply-To: <655328be546511b780c15e96c5076846f2f30631.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|MW4PR11MB6887:EE_
x-ms-office365-filtering-correlation-id: a2c26e02-eba3-471a-6be6-08df29da8da1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: 7kqG9lmzO+ow/JDcOE4zrcoHCbRHcII3lWbH0aZiRhfy1CM7TyF9cTgwTSd4OR/x+5VjpRnDByErjFNG7iH4nazewqntVuOnh/2WlmfM7xd6FB/9dDtjD9QDDdPA1grryIroQB0GCKLRd9bCRWPBdrBL8lh+HU6B9QXdO6Q7gkkBzNfnV226OGePQGOp+U9vWh7GQtjoC/lIzXJdvhLcOjE55hq+TlplRPueF8J0stoYtCJjWiwQyOCIC3F1Si79sO0g4EY/Jj2PXnkyK+t9MDfdP6X+PK7dtOludW5E23tShUpelA1leTeE3ytjcVmdgvmNrWyxtDsqwJCoH2EFwOSEudogClCScBqr7hYVnnBm9/Vapgsrn+hTG5b9ahKcURkruuo+LWmEPWtGWl6hkDG0QKIMfhQPbCcTdpOQg/WCKb5HoMBVUrTjabXUFkbcZNzqXkOISQ70T12upTwpwHAASAQgg1pvcH5o49RJUERPrO9wZCA+HcyyKS3miW/ual1RfV/FVw4ywLkhLSp91PFp4Ulpl+1uPTE9Rbquk7/e4yQ3Z7NuxE3+KpurJokXml6cPMYx5VlU7JxdP9fcImQxExzKTii1wJlVLExKbFl+00UsY3CmG4uMLxQ/nyGV88xrgwXcGPi8dMKLNDsYM4L06aGjqsOPDHZX9hlzVY6wd7vPjfrVcPXJRFrtlCyPHEOaOp/Bvhd15Vt55tbNLhI4S53gQ/iMVMKUCths1oo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTU3QTcyVnpuSWE1NTZDK2xNRlF3MGU4bVpGbURjbGlkSTdZZDIyRnhoWnlj?=
 =?utf-8?B?K1ZWNDhESk9PMHJ5cnNzWnBMMzh4bmJlVHdWQ1BFRTJWU2luUVYrMlBDL0E5?=
 =?utf-8?B?NmxnTW4wcmZwUWxheUNZR1NoeDF4TW81K0RpRjVyVWROQnVWQyttTENGTzNT?=
 =?utf-8?B?ellDZnBBQmZPZUlSR3JXdXRPWGVoZ2loNElQV01RYXF1OTBhT0FLTjc1MFVJ?=
 =?utf-8?B?YmEvdndZZ25xV1VnckpSQUtTNXc0WVpiU0pQeGk3Qk1TQnh0ZEM1ejZRSk1w?=
 =?utf-8?B?Vngwdm0yaDFGNDU2T2ZYSjNaeTUyaERjaVh0RXdOaFV6R0dodGpJVzdOdW1t?=
 =?utf-8?B?SE0yaHJTQjVtWThwTEZuSHRLZHpNSzR5RitPRzFvdlViRTVwOEJ3V3g4SDlt?=
 =?utf-8?B?Wk1HVzNHc3BCVHFiZmt5Y3JWOWdVdCtuNW9PSkRJVXliU3FySEUvdEQraGM2?=
 =?utf-8?B?MFhjeFBHYmZUNHd4cUFOVHA1T0NoTjUwaFhIRUh2RW5LMDFYVXE2dGMxOWJ1?=
 =?utf-8?B?VVBqaTM1UG1mVE16T3pmb044SmUzQ3VlUmp2ZzNKSmRSVmFwMno4UjhGVVcv?=
 =?utf-8?B?RnRTcHYrQnFIS21zdUE5T0huTkgxSTlaYzl0RmtBeHQyNWQ1dURwdUlSSnhP?=
 =?utf-8?B?cFk1bSt5L1FnN21GTmFBVTA0Uk9pSE9ISU1UTit0WE9wSVpOdUZteFN6T05x?=
 =?utf-8?B?LzJVU0dqTEluclpiYnNucks2S1M4bEJ0aThUSThhNDVzQ2Vzck9Sd29rOTE0?=
 =?utf-8?B?UVBzQk1FN2U0MlJYUkt5MlNKQ1I3RmNhbnhkUHk3K3p4ckJhTmt4NTV4eGlM?=
 =?utf-8?B?dDA4R0hFak93S3JTRW5vSk1vckplSXpSYWNnTlhaNHkxV0dKbDcxdkM4WmQ0?=
 =?utf-8?B?RFl2aS9saFZyZFl2M2NzTnkxbDRkQ3hyK1A5QjRGcU1DNzhHd24wYVpCMUp1?=
 =?utf-8?B?bzZBVllRYXl4R000U0JiWi81MkoyamZyWXQ5eEVWYUtFZ3NBY1hReWRjT1NF?=
 =?utf-8?B?S0c2SXdHWDhlZmNMT2dFVWJUVytBVFpWdGJXM2RkTXU3WUJiNHFnTmtoNXF6?=
 =?utf-8?B?OGk3YW1mSnRiL3A1Q2xsTVp5a1dYYURIMVF0eG8zZEo0NmNGQmtIYUd5MlU0?=
 =?utf-8?B?Zmk5dlVHWmFqVjdPcUxvbHpubGFjQlhiK2ZZT3Q4eXJiOERvWUpEUXU0NHFJ?=
 =?utf-8?B?dTB3U0JSRGRFSVFsSXlQYi93Qng4YjloQVZwUG1HZFhnMVNoeldTa1RCRjNj?=
 =?utf-8?B?SDlQTjF4TVllbVdSNCtnd3FZSkI0V1o2MXZ1c3cyUG9ZdHdyUVMxRlRFYmt0?=
 =?utf-8?B?K3FtYVc2dTZpc0ZrRmhtY0NLTmsvMDc1bW9SV1krMDM0SW1iTFZBZVdlNWda?=
 =?utf-8?B?bmg2SnYxYkRxdkxwSjhkRms2SGw3a3psNU1DMytCbWdZNi9DdjRSR1Q2N3pv?=
 =?utf-8?B?cjNZaThqTEFoVWFPT29VTjUyTyt1R2pIZXA5UTBUOVJ2U1haNEpWbU9jQURV?=
 =?utf-8?B?alA5d3ZXbDJraGNTa2oyd2g5eGU0ODN1UHJHQ3VRbGJGem50cXhVajlQWUJV?=
 =?utf-8?B?NWhySnNicUFQbGZ1aUwvYXBySzB0ajdIQTlFV1lCWktBUWFGVGcrUFg1MERu?=
 =?utf-8?B?M2YxdmVsaEdIZWhseTZBTkY0bUdtSzB4TDBWci93OHJDMDVLZWJ1VWhOYU9O?=
 =?utf-8?B?c1NlTGt0TUFvUVlhMzFZWHNpQTBNbEUwRnF3MUdSc1JLTndJazVVcmJ2aFMr?=
 =?utf-8?B?cUFSdHF3WWpCcTQwSE1NUUVNSE1NVlRWVVNBdEFsYVF1aGdTWFMrWCt1OTBW?=
 =?utf-8?B?MGllOFJpQ25KblhCZzBkcmZnQ0MzYTZ3Ty9VZzBDTVhkM1ZUWWhBcndSUC9Z?=
 =?utf-8?B?RzhSMnNtRkttZjl3MUdNb2tYS3Jub1paYVFmSVRmU2I3ZXJsdnl0RnpuWEoy?=
 =?utf-8?B?NnBvTG9Ua3RsN2JGdFlXQ3BFM2NSNVpCRVR1NnRpakFEZ2NtajlxQ0dITitY?=
 =?utf-8?B?YVkyeEY4aDZEQ3NNOXdRSnVTQ3ZpWlcvZVhkc3I3RmxNV1NHSGpJUldKWWdh?=
 =?utf-8?B?Vm9uT1JDc1hmNUkzU3ppYnFVaXcwNEdwRDU1N2NrYmQ1YXRXS25yWDc0RjEz?=
 =?utf-8?B?VUEvU21CNWVvaGxpV080Ly9uYlFaTXdRLzM5aU9Ed0Fza0EwNmE2MWhVOENB?=
 =?utf-8?B?VkZZYllTNEZxLzh2Q2M2djFzWmxrdnFsL3RLQm9tNjBuTHFEazRERmkyQ203?=
 =?utf-8?B?RXZLVnNETzdCandSTzM0L29YRWVyTHBiRktDVXB0R0tXMmtrQUJYTzVJSDAw?=
 =?utf-8?B?L0wyWEp1YlQxSkFKSTNEcUtYUUtVcDhmSHFmeFRoRTdob3VERWpYNW9DKy80?=
 =?utf-8?Q?yFCqVlGL+VXg6Y3s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 4GNd4e9bSqISkrigDQJ8XujedU3/dxLTx/GYUwy4DEdKEei8Bh13z3j3nRO639pcEtX4oCZ5QFgNmL82tyXvmPzd8D+DJ/CxuxsWX8wgcu0fKRwEAoxX3aIPWvcn9oImTo8f4nsFABaYb9c16ZDy4NgRb9bU4oWzRhqnRf91jRu8SsGD95NUBz4CARrI3P5ErrUEKEikoi5jq5m1AQiC91waF2VHVP1lJas8E2iQq9scnWheJxtw+4CFwNEqWv6S4jU/afe9VRE1D4l0ir93EzrXoWQPKwir/x9iv36Dhwcs2AKx2/6ABRFTgyNB4DMjm8Ek8zplkCxUuLdrc+t0SQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c26e02-eba3-471a-6be6-08df29da8da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 10:04:36.5420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HPFbS14VZrJh6sJ8e6MSFujCTRj0GzztbuO2DiLbOnhTEP/46EIc7uAiXwYbiuSWUBgIjh9IE11v+YTMdkrwZAC6lY/+FRptZXCrP0KJ8eCzkxhq1pobVdcnqVwOtone
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6887
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8
am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDE0
LCAyMDI2IDEyOjU4IFBNDQo+IFRvOiBLb3JlbmJsaXQsIE1pcmlhbSBSYWNoZWwgPG1pcmlhbS5y
YWNoZWwua29yZW5ibGl0QGludGVsLmNvbT47IGxpbnV4LXdpcmVsZXNzDQo+IDxsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBwdWxsLXJlcXVlc3Q6IHdpZmk6
IGl3bHdpZmk6IHVwZGF0ZXMgLSAyMDI2LTEwLTE0DQo+IA0KPiBPbiBXZWQsIDIwMjYtMTAtMTQg
YXQgMDk6NDMgKzAwMDAsIEtvcmVuYmxpdCwgTWlyaWFtIFJhY2hlbCB3cm90ZToNCj4gPg0KPiA+
IEF2cmFoYW0gU3Rlcm4gKDEpOg0KPiA+IEF5YWxhIEJla2VyICgxKToNCj4gPiBCZW5qYW1pbiBC
ZXJnICgzKToNCj4gPiBEYW5pZWwgR2FiYXkgKDIpOg0KPiA+IEVtbWFudWVsIEdydW1iYWNoICgy
NCk6DQo+ID4gRW5kcmlrIEVpbmJlcmcgKDEpOg0KPiA+IElsYW4gUGVlciAoMik6DQo+ID4gSm9o
YW5uZXMgQmVyZyAoMjMpOg0KPiA+IE1pcmkgS29yZW5ibGl0ICgyOSk6DQo+ID4gUGFnYWRhbGEg
WWVzdSBBbmphbmV5dWx1ICgxMSk6DQo+ID4gU2hhaGFyIFR6YXJmYXRpICg3KToNCj4gDQo+IEkg
Z3Vlc3MgSSdsbCBwdWxsIGl0IHRoaXMgdGltZSwgYnV0IHRoaXMgcmVhbGx5IGlzIF93YXlfIHRv
byBiaWcgZm9yIHRoaXMgbGF0ZSBpbiB0aGUgZ2FtZS4NCj4gUGxlYXNlIHNlbmQgcHVsbCByZXF1
ZXN0cyBtb3JlIGZyZXF1ZW50bHkuIEkgc2hvdWxkIGhhdmUgbW9zdCBzdHVmZiBpbiBsaW51eC1u
ZXh0DQo+IGZvciBhIGZldyBkYXlzIGJlZm9yZSBJIHNlbmQgaXQgb3V0IGFnYWluLCBhbmQgYXQg
dGhpcyBwb2ludCB0aGF0J3MgaW1wb3NzaWJsZS4NCj4gDQo+IEpvaGFubmVzDQpOb3RlZC4gTXkg
YXBvbG9naWVzLg0K
