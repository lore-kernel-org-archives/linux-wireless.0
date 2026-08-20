Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ABD35E1A9
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 20:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787259362; cv=fail; b=XJCemCak4cHtPfrE7oNjiNFms0vnX0852/Y3WucVFaozrltvc26W5WfmJJwn1SQhcgGkBkR1dhgLE0q46aCa+Cy4K/u1/8QduIfq7DARIUjS+f2wf6cR246EtyKjqq+0hqLAtaUEF12uKxUgW+dV6+0iX3MwjkLc+lRn7OOgHbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787259362; c=relaxed/simple;
	bh=htdHYOMwOlZtCMFoWugDvn/+S6LkGG3xIXYPFnId784=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uLVVefaCZZaoL1FXlfx1bQRND7vwSNPZ7jkdHFnbP4Yj7vRMUFaxdqkWbZWscxUx5eE2RF1+cV6QLXjs312Rr0BIBu8pxc+O5PThKPXBfnxXiZYMKJvtk9XNZ/9c/xpJixsuEg5NxAKyonNMJQkbLlprBTh5XZTbHeKp48N3RYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EXAJTLxU; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EXAJTLxU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787259361; x=1818795361;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=htdHYOMwOlZtCMFoWugDvn/+S6LkGG3xIXYPFnId784=;
  b=EXAJTLxUTWoqwXGkJpslrQdWKZU5/Ms1o5midBMqfF+Lt1vKeYdnPIfw
   WceVTTZWCrDWSQ/J9w1p2Hq9d2aCBvOarFZQzxTmxNeYcUHbQG5M6PoYP
   DBATOqaYheJnYBELNTBEQ5p8CkcXxLm8idLgxiqnGDPOqsa6Zdg8euSd9
   BBFUMFikztWt0gKGfzr7x1xXdv3v9qruGljA4wjefcbqVvG82JOVl9kSW
   7e8EuIISpUkyb4aqvmVau85p/yhPhtUO+/GfnSD150rnNndzYNPYDzuvW
   baYGUqBgA3r5dDieVBTKnObeRbmg4o8+U2JueAHU5AmnUxudcEubwByFk
   Q==;
X-CSE-ConnectionGUID: fc/2nAXPQyi2c0fLcxV5IA==
X-CSE-MsgGUID: rdHrunCSRpqT/TDWiiyw1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87572412"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="87572412"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 13:56:00 -0700
X-CSE-ConnectionGUID: skiJRNxCTyereDkUMlSRrQ==
X-CSE-MsgGUID: vezCse76TZCQgQmWPULDqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="262423183"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 13:55:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 13:55:59 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 13:55:59 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 13:55:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i97w1sEctp0+24qiDRk0ehyC9MhHSho9oZ/AfWdawc1KsJbaWYuR6yZeOvPXg902USlUGD4nRgHIZwnmYgMbUdIlEpNI3OMSakNAFkBQOPK4vgZWvGvtQ5uSAt9f2oBnlCi/fIKMHtYRrOriP/HM9cyAf3QyurYbn8p4vcJFvvmHTbHOMrvtN4iHq+hE9M2dNbmQ4Pqp9ocr9QTcB0fY47HgsCs/WSngfxg+GCvRAPLGY3+3w2d+gk4kUrh8OocOMN5xswxsr9/Ras3HcCE/ncKLekG2TquLJTQ84XJlaZNuKCiOBXAqllFNnKNnNVNG1eSeFdAOjDoqdKBZ1JPhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htdHYOMwOlZtCMFoWugDvn/+S6LkGG3xIXYPFnId784=;
 b=AfRO05udPMAMtOGh4609RZzExgFosooFqEn5LSQaHUcAvGWTYUqLlS+cGR71ocX7Gtq4joGqpZF1BJcx8KDSBhdPfEjXBh7Gy43dV1TgZoVLUuflobXNQYHv4aCd5pJYuJTOT3NgrXDrTyrssS/z8vhd+GxqKGFXxoijcIbSSWEeRqSBvQfbMmQV6p5VD00w6i9IONrOrSXTefRt4v5lmP6JawhLuPqyIqd2OZ1/On8jPGmMmm4oJ3syXw7o+e7ClrQJijkCtew8AzB805riI44ou51Azjzc0NGublON6+wLtblnNLXpDPr6gYJkQdOVF7NUnEpFbmX/PlKJsLjjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) by
 IA0PR11MB8335.namprd11.prod.outlook.com (2603:10b6:208:493::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.9; Thu, 20 Aug 2026 20:55:49 +0000
Received: from DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2]) by DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 20:55:49 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>, "Dreyfuss, Haim"
	<haim.dreyfuss@intel.com>, "Damary, Guy" <guy.damary@intel.com>,
	"kyle@infradead.org" <kyle@infradead.org>, Josh Boyer <jwboyer@kernel.org>,
	"Hutchings, Ben" <ben@decadent.org.uk>, "Yang, You-Sheng"
	<vicamo.yang@canonical.com>, linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi firmware update 2026-08-20
Thread-Topic: pull request: iwlwifi firmware update 2026-08-20
Thread-Index: Ad0w5hIi8T8NI6RAT6W4ycMrHcrcjQ==
Date: Thu, 20 Aug 2026 20:55:49 +0000
Message-ID: <DS0PR11MB7880714C679851B993EF9E45A3A42@DS0PR11MB7880.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7880:EE_|IA0PR11MB8335:EE_
x-ms-office365-filtering-correlation-id: 319dcf28-6a2d-4369-d799-08defefd6a09
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|38070700021|10067099003|56012099006|18002099003|11063799006;
x-microsoft-antispam-message-info: CpEzfs9MhWFhLcx0zbH7lz8WifmOzNgMB7CbSwCYnoBUhPOfD+oGeOQU9RyRUnRLgyFHajqWCgQmooAhy6awh5Q4oite6ior/Ck5+VFHJ2YhVMkYiwyZFJnWE4T1kcXfyBuN1YUcrRjyTpvFvrG23cC2aDps5VVZouJY9AIGM9n3VpcrFv8Q9WE+2/FKrTL1owj9wU7oWdUKnYgNEE/BU6yvPULi0SmUeDbfvJ5xgYfvO4luXLB/cMXYjJmSXXFxkYNgWSH+47sntSjelhAccdTxKqH1NGjfa62hxG1VWSK694p8ndPYRRDKjmskOuxr1upfKIkuCzXIZaTQCHQXq+7mdGubuIP++HD3nd0O0HclahPZN2dE6HUFa/VL0CjOG4pcN2zz2OpSm/DpbxukbqVxnkCK2E7mhOW3SjalCuNikYgOsr3SmWxaANrOKUzOUQ4r5SWCObNqE0lrmMcLFdZtGp5yCAH+HxRt5lplhiDn6rzCL3xVhf42eubDNWwcDoqvWikEITgqYuing1mC8U7z9C69nPtRd9WJvvzMFra9h7SBGTc9BldoyGXWro3pXBRjm6luGd1ATY9BQO5fldbd4hPY7gPcYHVCcwjWOsQ1S1yzBZMoRsuLefpE+P3WvVptaMgCQMnVWSU6j4TRqySfV4jGZL5vgPUzMF1/jnKlm6jKlmSsYG8pgBe3c4oeNErOwjLXkVCqNzetVClPEVVowoiLN43qMFX2Xz8kWTg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(38070700021)(10067099003)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEZrbEpZbjMyL0Q1dE9sV0h0a2QxV0N5SC9BRWJ0TVN4T1pjTXhsRk5CNStJ?=
 =?utf-8?B?aHBYcVlqVnVidG1XNVJ4aWxqYkZYTDBzWHVlSHlNdWNxd3J0NW5LNkN0dFVn?=
 =?utf-8?B?VmVpQyt2VWxnK1llTGtmWDBnVEFrVzdTekJhbm92UDRjMmVPckNFYmt3K0N6?=
 =?utf-8?B?d0trSWZ0anMxY013enRXbDcxdFVBR0ZYVllkMGZiYzJBOWFZL2xXK2hPdUZk?=
 =?utf-8?B?azBoVEdrOGFPcHV0OGpPUjNOSHpGMTN2YllNdXYwcGJJTitNM21ma1hvUEFh?=
 =?utf-8?B?NXprL1A4NU42cnhRU1lJck1VQUc2U3dRWTVYTUN2Szd0UFVxZ0R1VUdSZzNN?=
 =?utf-8?B?Z1FuYWNsSGRKMTMxSjN4NkhoaW1UT09DbDFlVGtaN21LWlFQS3dUQnE3V1Rp?=
 =?utf-8?B?OFZLSTluS3IxZGdpd1MvWWYrMTlGclpRSWJnNUtCenBxbnd3ajdVL083dFJv?=
 =?utf-8?B?VVBwMldjbkFsWkpXaWxRTVhuaWRLTnZWdkI1d1kwKzdiMHlJVDN6cSt3dkNx?=
 =?utf-8?B?TXl0blc1M0xiSXhoT2xWR0RITW9PaXBaUCtPbnoxcHdPR3U5UTJWQVJuL0dO?=
 =?utf-8?B?VTFXS1lRa1d5VFJJU2tVVDNBblhjUEs3YTdkcWYwT3Uydm5mN293VHpFN3dZ?=
 =?utf-8?B?S0xVK2JPREU5UXB6RUQxa01KUkpUemxKUGZ2OStFSXp1QlBqY1NvbVVEWlJj?=
 =?utf-8?B?WkZSSnIvajJ0S3ZtTVJmSXpOaVM5UmgyRGhaSlgyejRtSStpMWt6cklCOUdJ?=
 =?utf-8?B?YW5kZUpKb3FNRUh5ZmtSWVAyeHplRis1M284NitSeG1zUXRxemRwMWtvN3Bw?=
 =?utf-8?B?eVBYak9IWTg1a0xUK0ZWWGpPN0Z4bGdwWDBhWDVwSEhYWklNL0t3RmVHeGNR?=
 =?utf-8?B?emVhSnJEb2xqeWlTQ0NBekhjR0hudkRXNy9FNXYzZHV3T3JnbEdnM0R4R25s?=
 =?utf-8?B?cGhQcm14TU9aTVIwaUxEaEx5MEhNQXhvUkRqSjh0WFJOcmhPM3NETkU2bUk5?=
 =?utf-8?B?dzVLNW1scEtQR3JLa09uM3V5REVYMnlLS2FPREsxcjVTaU9TZDVHaWttaytl?=
 =?utf-8?B?QnVqVG51c3hyeVBLdXQwblI4SVROdkwvV3pqaG5qVnIzcVlGTXlQMGdyL1h2?=
 =?utf-8?B?TDk3TWxuazBEa01tNWdHbzU2NVg3U20zdGRNSDdKTXlRR2dvbmJBTUVUNUtW?=
 =?utf-8?B?Z3FRb21NR2FFRThjTmM3SWREWklYL3RvVUsyRC9mQTlmbVZRajJEbGhBNEhG?=
 =?utf-8?B?cnVXc09ncEpSdVp1K3lSUGVqRWxpVTh2UmF5QlA4cFJQQWxodGhkQnRGZjNZ?=
 =?utf-8?B?Y1h5ckZ0dGNsQlpoc2I5dHNUcVBrSnBRZ1NJNXhjUGZyQ0Q3cm9LeHdZb3Q3?=
 =?utf-8?B?dXdVSGdMT1lFRnBBQ1pvSW1vRjNLaWpXQnRGd2ZEZk9hbjMvVVUxMjFycFdI?=
 =?utf-8?B?TzloNzcxZGtFWk8vRDI1bVBvd3ozZllsYks4RCsrQ2F3MGdGWis4YmpZaXMr?=
 =?utf-8?B?QnUySTloTDZOemtqRWdONXJVd05DQmdLY0pUMmtsVk9keURQY3Noem9yN1FU?=
 =?utf-8?B?elJ5T3VVdEtKZjlpcWE5SElYTzFQYmJBM0tIRjd6UVhubUZnSy92WTQ4ZFdp?=
 =?utf-8?B?ek15Y2w0bW4zYnFHZTNObkRDTEVaQXlJbzZuNVdEM2RKNDNlNmlodmFReWc5?=
 =?utf-8?B?YTNCc2NuWnFqdHRLQm9TaTRjWWpDZm5PK1VnM1FWZ0M5UStIOGs3MkxFMS9k?=
 =?utf-8?B?alFHbkxGY2phZFMzaFZSSTdPbXR3aDMvdmNDSWtINXBWQzc1eTlnQjZqNmcr?=
 =?utf-8?B?OGRvOXRCK1ZSUUZiNGhKZDlKMWZJQ3BoWTdOMTBEWTJ4bU9vNDhpcUN4djVw?=
 =?utf-8?B?OGp2Q3pvQndRS1JvKzh2Y1BOaDE2NlVJNXlNeEI0TGV2cHdKVWZQRDQ4ZEpJ?=
 =?utf-8?B?bmRnbFhXT2V3KzRtcXlvYXhpVGtpUmdSVFg2aGdLMVhMYnhiZDNYbHdCVW44?=
 =?utf-8?B?V1Qvb0d2NEh3VnJjejhIQm83UUJuamg2NzR3b3J5MUN5Q1hOYmF1bERxbXpx?=
 =?utf-8?B?eW5vQXhaaHBhWnJ0NVJWcUZLbG9BdzVTa1BpZEF2UFcvR1RxV0lXb2hkTmF5?=
 =?utf-8?B?MERmQ2ZsRFdGeXcvUWpWN2t3SE5oMFMzTXhaTE1pa3FWTXEvUU41THg2bHlq?=
 =?utf-8?B?S1lNMDhrN1NtN20vaWVpSGg3SW9NUGQ2Ulp6b2xrTUdVaUZOZmpndlRyOHRE?=
 =?utf-8?B?SVpWamw1WTdMZ3ZCVllJT3pjUWhtRWFaME5HUEQyQkx6WmdxK0hCcDYyN3ZC?=
 =?utf-8?B?dVM2eGpKOGpkTnJBODRiRElUSkthYmdTQXNKUFNTSWVQakFvVU81Y1pyRnY1?=
 =?utf-8?Q?ruoniDU1z7MZ1w58=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: HqpTO7O3GB5oeXhODwF+PUGSz0uFyvPBh73Pei/HlzZeL2765WgIsWujmSZPXtI1ywGr0ZdGLHcVMngNVMHfO+HOoioQMEUJA8FdQ3LG4thrv+AVuBkBOMy5zvfSVw24F0O8HAC7kS+UbOT4UBMCQcG30CQaWeYULT139g3BZ9VViO066EGTx5STD9Icj7AHBLx6rjleqgSI+hfBsOo6eTGWEJC3ojL6WN8Kz68xh2ezJgELFk3Unm3yAdRQIEc/t7V0YMMFYfty16Ba1wOdlH8RRyw91Doki2Dzf4v/8/defURwqK2zZ6Pe2hnlxCDbcpVRATMj78tybL7lwJdIpg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319dcf28-6a2d-4369-d799-08defefd6a09
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 20:55:49.1784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: inyBB9gT2o7OhMJIOL4WqeWWZLLI4G9h/7Q1qtB8DsA3Juarpr9S3jzx1UDx6Z1jpyXvNTGwapij8Ub+1sWcPrFq4UmGA336R0eCIChVNrWAK/pGOq5lDEkdMCE/6HVD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8335
X-OriginatorOrg: intel.com

IEhpLA0KDQogVGhpcyBjb250YWlucyB0aGUgZmlybXdhcmUgb2YgY29yZTI0LjcwIGZvciBhbGwg
c3VwcG9ydGVkIGRldmljZXMuDQoNCiBQbGVhc2UgcHVsbCBvciBsZXQgbWUga25vdyBpZiB0aGVy
ZSBhcmUgYW55IGlzc3Vlcy4NCg0KIFRoYW5rcywNCiBNaXJpDQogLS0tDQoNClRoZSBmb2xsb3dp
bmcgY2hhbmdlcyBzaW5jZSBjb21taXQgMDE5OWM1YzJiMzIxNDIyYzllNzE3ZmUwZGI4MmY1ZWU3
Nzg5MTdjMzoNCg0KICBjaXJydXM6IGNzNDJsNDU6IEFkZCBDUzQyTDQ1IFNEQ0EgY29kZWMgZmly
bXdhcmUgZm9yIFNhbXN1bmcgbGFwdG9wcyAoMjAyNi0wOC0yMCAxNDo0ODo0OSArMDEwMCkNCg0K
YXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoNCiAgaHR0cDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9pd2x3aWZpL2xpbnV4LWZpcm13YXJl
LmdpdCB0YWdzL2l3bHdpZmktZnctMjAyNi0wOC0yMA0KDQpmb3IgeW91IHRvIGZldGNoIGNoYW5n
ZXMgdXAgdG8gMzA3MDYwYzFjYWMxZmVlNzM2Yzk5YzdiOThkNDE4ZjM4MWE3NGQ5ZjoNCg0KICBp
d2x3aWZpOiBhZGQgQnovU2MgRlcgZm9yIGNvcmUyNC43MC00OSByZWxlYXNlICgyMDI2LTA4LTIw
IDIzOjUwOjI5ICswMzAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpSZWxlYXNlIEZXcyBvZiBDb3JlIDI0LjcwIGJ1
aWxkIDQ5DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCk1pcmkgS29yZW5ibGl0ICg0KToNCiAgICAgIGl3bHdpZmk6IHVw
ZGF0ZSBjYy9RdS9RdVogZmlybXdhcmVzIGZvciBjb3JlMjQuNzAtNDkgcmVsZWFzZQ0KICAgICAg
aXdsd2lmaTogdXBkYXRlIHR5L1NvL01hIGZpcm13YXJlcyBmb3IgY29yZTI0LjcwLTQ5IHJlbGVh
c2UNCiAgICAgIGl3bHdpZmk6IEFkZCBIci9HZiBmaXJtd2FyZSBmb3IgY29yZTI0LjcwLTQ5IHJl
bGVhc2UNCiAgICAgIGl3bHdpZmk6IGFkZCBCei9TYyBGVyBmb3IgY29yZTI0LjcwLTQ5IHJlbGVh
c2UNCg0KIFdIRU5DRSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDU0
ICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdS1i
MC1oci1iMC03Ny51Y29kZSAgIHwgQmluIDE0MDY1NzYgLT4gMTQwNjU3NiBieXRlcw0KIGludGVs
L2l3bHdpZmkvaXdsd2lmaS1RdS1iMC1qZi1iMC03Ny51Y29kZSAgIHwgQmluIDEzMjMyOTYgLT4g
MTMyMzI5NiBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdS1jMC1oci1iMC03Ny51Y29k
ZSAgIHwgQmluIDE0MDY1OTIgLT4gMTQwNjU5MiBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lm
aS1RdS1jMC1qZi1iMC03Ny51Y29kZSAgIHwgQmluIDEzMjMzMTIgLT4gMTMyMzMxMiBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdVotYTAtaHItYjAtNzcudWNvZGUgIHwgQmluIDE0MDY3
MjAgLT4gMTQwNjcyMCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdVotYTAtamYtYjAt
NzcudWNvZGUgIHwgQmluIDEzMjMzMjAgLT4gMTMyMzMyMCBieXRlcw0KIGludGVsL2l3bHdpZmkv
aXdsd2lmaS1iei1iMC1mbS1jMC1jMTA3LnVjb2RlIHwgQmluIDAgLT4gMjE1OTY2MCBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1iei1iMC1nZi1hMC0xMDAudWNvZGUgIHwgQmluIDE4Mzc1
MzYgLT4gMTgzNzU4NCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1iei1iMC1oci1iMC0x
MDAudWNvZGUgIHwgQmluIDE1ODQ3NDggLT4gMTU4NDc2OCBieXRlcw0KIGludGVsL2l3bHdpZmkv
aXdsd2lmaS1iei1iMC13aC1iMC1jMTA3LnVjb2RlIHwgQmluIDAgLT4gMjAzMjMxNiBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1jYy1hMC03Ny51Y29kZSAgICAgICAgIHwgQmluIDEzNjgx
MDAgLT4gMTM2ODEwMCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1nbC1jMC1mbS1jMC1j
MTA3LnVjb2RlIHwgQmluIDAgLT4gMjE0MzI5NiBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lm
aS1tYS1iMC1nZi1hMC04OS51Y29kZSAgIHwgQmluIDE3NTI3NTYgLT4gMTc1Mjk3NiBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1tYS1iMC1nZi1hMC5wbnZtICAgICAgIHwgQmluIDU1MDk2
IC0+IDU1MDk2IGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLW1hLWIwLWdmNC1hMC04OS51
Y29kZSAgfCBCaW4gMTYwNDc5NiAtPiAxNjA1MDE2IGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3
aWZpLW1hLWIwLWdmNC1hMC5wbnZtICAgICAgfCBCaW4gMjc4MjAgLT4gMjc4MjAgYnl0ZXMNCiBp
bnRlbC9pd2x3aWZpL2l3bHdpZmktbWEtYjAtaHItYjAtODkudWNvZGUgICB8IEJpbiAxNTM5ODMy
IC0+IDE1Mzk4MzYgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmktc2MtYTAtZm0tYzAtYzEw
Ny51Y29kZSB8IEJpbiAwIC0+IDIyMzU2NTYgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmkt
c2MtYTAtZ2YtYTAtMTAwLnVjb2RlICB8IEJpbiAxODExMjEyIC0+IDE4MTE1MDggYnl0ZXMNCiBp
bnRlbC9pd2x3aWZpL2l3bHdpZmktc2MtYTAtd2gtYjAtYzEwNy51Y29kZSB8IEJpbiAwIC0+IDIx
MzgxNDAgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmktc28tYTAtZ2YtYTAtODkudWNvZGUg
ICB8IEJpbiAxNzM2NzkyIC0+IDE3MzcwMTIgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmkt
c28tYTAtZ2YtYTAucG52bSAgICAgICB8IEJpbiA1NTE3NiAtPiA1NTE3NiBieXRlcw0KIGludGVs
L2l3bHdpZmkvaXdsd2lmaS1zby1hMC1nZjQtYTAtODkudWNvZGUgIHwgQmluIDE1OTE3NjQgLT4g
MTU5MTk4NCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1zby1hMC1nZjQtYTAucG52bSAg
ICAgIHwgQmluIDI3ODYwIC0+IDI3ODYwIGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNv
LWEwLWhyLWIwLTg5LnVjb2RlICAgfCBCaW4gMTUyNzAwMCAtPiAxNTI3MDA0IGJ5dGVzDQogaW50
ZWwvaXdsd2lmaS9pd2x3aWZpLXR5LWEwLWdmLWEwLTg5LnVjb2RlICAgfCBCaW4gMTY3ODg2MCAt
PiAxNjc5MDgwIGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXR5LWEwLWdmLWEwLnBudm0g
ICAgICAgfCBCaW4gNTUwMjAgLT4gNTUwMjAgYnl0ZXMNCiAyOCBmaWxlcyBjaGFuZ2VkLCAzNyBp
bnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW50ZWwv
aXdsd2lmaS9pd2x3aWZpLWJ6LWIwLWZtLWMwLWMxMDcudWNvZGUNCiBjcmVhdGUgbW9kZSAxMDA2
NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLWJ6LWIwLXdoLWIwLWMxMDcudWNvZGUNCiBjcmVhdGUg
bW9kZSAxMDA2NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLWdsLWMwLWZtLWMwLWMxMDcudWNvZGUN
CiBjcmVhdGUgbW9kZSAxMDA2NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNjLWEwLWZtLWMwLWMx
MDcudWNvZGUNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNjLWEw
LXdoLWIwLWMxMDcudWNvZGUNCg==
