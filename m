Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75A466B0C
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790150378; cv=fail; b=TR7HMvhkA9RLMrJCSjjFWnsDjvHF4/AZaSVA+IYDqjAMsNi1qYE9EYjowhWnOYnkpKWaWVh1pX6jqBnPzrFEEFfwWV8L6//O+fJrloao4XS6twwrjpb0fHY0PMvUHk8WciXxwsyR1CGML9vSdte6vpDPrFNWxgCvlp6jskyd2q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790150378; c=relaxed/simple;
	bh=72eGv1BB/qT+H4XJliYWhpoCACNXkbKL9is+jLdq7Vg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sBheFI44b1nNDy1rOZIjwa8bwOJiNajCJ8XWlIgjAYyhVeL+Kv2Xp66XZxG2gS9tRvPP9hykm2KI2h+AQJYGOBCve07oQB/baBjiK/w746sAEg/HdPeGQVa7AyF1k1/hmjaRYAWtWMTPy6UnLik5aP1A/KGA+wxINyifSqyGvLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUrGIayE; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUrGIayE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790150374; x=1821686374;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=72eGv1BB/qT+H4XJliYWhpoCACNXkbKL9is+jLdq7Vg=;
  b=hUrGIayEx5TkXkeBYKKqEU+x2+bHerklMnr9L4TWN6OhPXxjfy3i3qEB
   t9Zoc7FeJkDvytagaoiEgBSSgvIy3H9vBdqvfet0B1tRYNKuvHssfWQce
   d+hlay4NNVmSctWgH7fRWHvYkdnxJ+9N3xSEXx01h+68UN5mGINd7/Q/R
   MmkM6l9kLxFCcXKl8crrXuxAIDmGoYlP4Jktfk9/hDGncLqMwtK7xSqYD
   zKCmRbrxwxsZ/67scoPYrQNBnHTqghEVF5EZW3XyyqIwMGMRuF52oqwow
   mQgc9z1zYrEuw1hwYnVGRveb0c8cm8qdJOLDMZnsUrQUihAoDLP78Wq/6
   w==;
X-CSE-ConnectionGUID: 2iwiHW8gQDyVe3zqR9tt/A==
X-CSE-MsgGUID: nUWHJx2QROG4tmlzMSBJRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="101408676"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="101408676"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 00:59:33 -0700
X-CSE-ConnectionGUID: FXhyK/NNRkWO7wsUxt9lKQ==
X-CSE-MsgGUID: 3LpfUus0Q2OEUSVtvklFrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4568872"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 00:59:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 00:59:32 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 23 Sep 2026 00:59:32 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 00:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LS3zexYFlMfNtuRl910vY7Ay107dD+uRXbht+fPCF5Nwzjx//THmqoiIkHq27SjQZZ4uK9eifTPngDnOcxRtMP1Nk0plyvYVaTUHw8K3j6XGvtkwVbjUXnl7NymK8tAHSgFp6rLOCgv7Awosm0ApFD7V1VgTyT+ha87Yj8s+hn4AgyNB6/Qd9/RYzTOhA6VfOn8/4a9DhLNOQsqfY610X7lc2i1B1R/PNxtU+8GJFHuCvE++CiEA/1mgIihf84zioBKLo+Bye72CkrP54hbJr47hFdaWWWXXF7P2dTn8pvbh+zr/4gw0NXy/WhxvkFbf82QMCfxa0wPwVQrImGXwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72eGv1BB/qT+H4XJliYWhpoCACNXkbKL9is+jLdq7Vg=;
 b=BENRL3n4o93aLPJwEkE7eASI330nMFacOjdQ3Wlrvju6vcz22V9dhTN4EG2zDTKfNhud7d7uUFsIBdvbzwiX66TsyM4xaH0hQk0WF0he7yxpAOj6Ds0OE6vb2QtFCQtRO2r8Dgjr8nIqb2VhFglcR921U2wgVgaCzpxhF/0J3BPGdrEBW9+eB5Kd24FmtJJd7mhB1hvVCmTADLcy57o5OTvduC1N/2hKgtkv/+SF/YI/N4GCWnYbCTiLpFfHRBxh/T4YG4PdBOxFLIccNYMorNGIqqVBESelF+jtMh8Ck5IAXz+jKr9udI4uScq3kdm2MSaShuel16y/sqRUWz78ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by PH7PR11MB8251.namprd11.prod.outlook.com
 (2603:10b6:510:1a9::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 07:59:28 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 07:59:28 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-firmware@kernel.org" <linux-firmware@kernel.org>, "Grumbach,
 Emmanuel" <emmanuel.grumbach@intel.com>, "Dreyfuss, Haim"
	<haim.dreyfuss@intel.com>, "Damary, Guy" <guy.damary@intel.com>,
	"kyle@infradead.org" <kyle@infradead.org>, "Hutchings, Ben"
	<ben@decadent.org.uk>, "Yang, You-Sheng" <vicamo.yang@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: iwlwifi firmware update 2026-09-23
Thread-Topic: iwlwifi firmware update 2026-09-23
Thread-Index: Ad1LMPTVRisGhJKbQRW/8fkikxJmkw==
Date: Wed, 23 Sep 2026 07:59:27 +0000
Message-ID: <IA3PR11MB72131327DCFD903FB8A3F760C9A3822@IA3PR11MB721313.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|PH7PR11MB8251:EE_
x-ms-office365-filtering-correlation-id: 035d0fb4-9c77-4038-13df-08df1948977e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|38070700021|11063799006|10067099003|18002099003;
x-microsoft-antispam-message-info: 0kfKHck+NWAuQp6ATXHO0hiWO2qRHrda/9th6G8wdDHLHIdNgiPfljdlNntZ8eLnGN8pqjawIj7IH70DCjQP5wjyegtJ/iwkxHhvKgFNWwIXyXaefFUjdNAYP29pd8xmqaf0MHhjfb08FBJIlU6RKze5WaauUEiWYGm+Xm6DOxAtE/FUX+eCLqPXSl/00xLOy7NJvzO0DDZ0eg9iBUnRfIi/UdovKHkRa8qXh9tAKoElK+6V+3gAx8VITfoQ58Loy+gFkZsYedBkhcTt3n7QhWSRWbTOdDuYLS99FaN4psMf/JsnIlNOCjA3Ft1ot+vTFn3AkR3XVN258Qv2guKg2w+UEO1TFKQ7lagh3KRahGb64xg8OfUbESBrCKV4tTUidsrL8CywWCukXngMRm21QFWPeM2gBw+TuxaLtwpdvIlQDMljA/rLxBYMekglxHGFgES+n/iIRUJDh0YmixGQFAd945GsC9GYQEC8LNqcisqKRNJYD7gSlxFMKjpN2MdpNEaT5aLKyXbt/Z65XQNL8hk2e37oJtiVOvAvSk4eO3/yfxirB8bi6z8jRmD14iRgzO8ZEjIHCcQGihc8eF7+tGgQZISBXQJzUm29jBelKNdE/zhlGeqJ2fXdg+96u9fHiGKWgswTDWGqUqTChZcCysv60hxmn+M36wN+GLDSfHonvLUrej4bxWEVsd0kD5vLFWnFQ8V5rotjAeQhJGNG4l/9XSqzP62Yomk1QSOrMLE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(38070700021)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ynl0Y0NhNWRid29NcHVET2Q2TTY0UWFEczYwRkl3S3FDMW5aMUtBR3o5Y1Vp?=
 =?utf-8?B?WnRHWmJHSGZuUE92K0V3bFBuemY4bjhIbEVrWHFEVFc1ZDYwRGlJZjlNQzFl?=
 =?utf-8?B?d3lPL21UQmpWaEtOWGRTQjdHVGlRQ1FwL2RkVTBRMnBPMG1tQmQzakpoNW4z?=
 =?utf-8?B?NWdUOXRsQXo0OFlDd05qUTE1QjQ2YkxmMkhWRlcxQkIzVW5PSWZHdzIzc3F6?=
 =?utf-8?B?OFJDUzk3WGxxSit2NHM2SjFKaGNWc3FidDh2NzR4T2JQNUc4R1BEb1liOFk5?=
 =?utf-8?B?RHUrZjYzamppUGNpSEtqejRPWkp2TXBjcm90OUdudjNGVFlnRUZOd2hHZnAr?=
 =?utf-8?B?N1BVU2hJK2pWZnNTM3lvNFlmV08rSzQxVlp2U09NQU5OMEt0bTFFR3pXVWJT?=
 =?utf-8?B?bzNWamE2U2JZTXVhMTRkYWpHZU1EcDkvRTlMRnA1NDIyVkkxcUJydFdtclo4?=
 =?utf-8?B?RVJ0T3VsUGZBellxQ1RSWllhSWc0a0UyMUIrTkk1UGRCcVNMd1dmZnZ0ZmZX?=
 =?utf-8?B?MUNha1BMSkxEZGM0TmpCTEJrcWxjQmhZaU14dVh4VXQ1bE1CMXc3bzByTGpq?=
 =?utf-8?B?VHBjRmxCcFlGanBad3Q4eFdHalVMV2dXajVKT21xSndHemxleTRBRTFJSWRo?=
 =?utf-8?B?emNCUWJ2RXZYdFI5dFZyMlBHTHk1R0YrV3NlelN1clEwamVCZGk0R0YrSWpC?=
 =?utf-8?B?eVh1azNIU1gyL0psSzUyTFdtdGdnOVUxYXQ4c0NBTkJSbnFvRXk4dHVOREZn?=
 =?utf-8?B?ZkFlY0t0UFNPZE5DTlZ1cW9RaGJwLzRIb1c3UytSc25pVWluYTk0WHVNKy9u?=
 =?utf-8?B?S3RUNjlBVVU3dEFWcWR2NUM2ODRrTnM4YjFmRmM1ZkxIaWtOUW50Q2x1Q1E3?=
 =?utf-8?B?b3cwamlxRXhJbFZuOWtwNmhPU01BT3A0T21vRGRiZkZMTXFRVkhZTzhHSjNB?=
 =?utf-8?B?cUlNV3FDbVBVRCtNbk9iSnFOOFJ6Y0dEYWZsNWc1YnFNSWlWaDhYamxzeDAw?=
 =?utf-8?B?cUdkVHVUeHlNcG9ESHRISU1iQjl3K1FacFpacmlabldaNXJYTEpyY1d0SWI4?=
 =?utf-8?B?ZndyQ1JGbmpMd3I4VU82SU5zRG1MK0dyV2E5WkhpaTJMZlhsRXhxeDU2WTFs?=
 =?utf-8?B?SlRJdkZLcHBxVC8xZFVxTitqckExTjJ1dVVMdGdJWGVmZnN1RTBaUXlEaHh5?=
 =?utf-8?B?QnN5Mllpbk5WY2ZuOTVrZUNxREpNZDlQQjdFVktPKy80d1NOMXEvTHYyZWk5?=
 =?utf-8?B?RndsOXNKeEo1RWphWWptS3lIR3UrZjc3UUlRZVhwaWxSa3RlcFFkSFEyUGd1?=
 =?utf-8?B?L1lmUVppWFoxbVFPUkE2UjJlL0xlSExvOXZHMnJ6N1VNLzR2SzdWTzUxNzQ0?=
 =?utf-8?B?WnVKMUwrSTNVSmQ2ZmowOWlHQXBFUzhiMjdya0ZsVWJGaXJOeVF6TTlnOXdv?=
 =?utf-8?B?Q01HUkppbDBvVEhCNGNhalp3akluaEltaVFmUXRkTjZSODhEa2xsWVFoblRP?=
 =?utf-8?B?RGxsS0NCN0E4YU81YTZlRnBSWCt5bEJLZGtFMU9yR1R6NitKVSs1RWJGSmlV?=
 =?utf-8?B?ZnNPQm10eThKbXUwTmlUTzJBbWpqb3V1NWVqQlNxYnFsSkRUOHpmUmk0WWxl?=
 =?utf-8?B?OFNWR3MwOWhNdE9nWDJpSG9GS2ZvdFc5bm9RVW9QalJxdk13U2FuN0cxWmU3?=
 =?utf-8?B?QTlrcm15SjdQd250NVE1Y0FrKzNxWGRuTHNTNlIwR1M1WFdFN1VzTytrZjcr?=
 =?utf-8?B?THFsZU45Q2lzK0p2Mk9JSUo5STkyUmVtTjhOTHM3MjBDQjJkZWpUSldZMDBM?=
 =?utf-8?B?Y0dNV25oMjlXQkEwNGU1YStUMW9zUnJTOGZqSFZHMExVRDZQWEhHN1YrVURt?=
 =?utf-8?B?K3hXTU1yR2FyTGdmTDRQdXpQb2ZYNCtFcDlmYUFqYjIveFRlb0VML0s2RUZR?=
 =?utf-8?B?Uy9MdXYrMDEyMHRTOXhzYkwvUlFLOXRqYjRVdE5zdnFORUk1eUVTV1lFem1p?=
 =?utf-8?B?MzVFQk8xN3J6dUNpeUQ2eFNnV3VHNTZkeTczU0Uyb2dTY0FpRy91Y2t6RHI3?=
 =?utf-8?B?Q0RhbzdXZHNacWttNzdKVXN3REFybkp3QmtoYzdVSlZpbmVBRy9qTFQwYkcy?=
 =?utf-8?B?TTdhMFpWeXpTR3JJWUZhYml4YVVSTUorWkh2SFFGRTBZcXhFeFpqTVZnejRl?=
 =?utf-8?B?cElKYzhPL3JzYjdQSHczMXFvU2JGK2NRVmFMc0xDR3crUXhtRnM5SE55YnAr?=
 =?utf-8?B?NDB1VFhDK3ZWb0syS2lVWG5nN1gyMG1xbUxKdEN5QUpGME9VRTZjbjU4NTh5?=
 =?utf-8?B?LzhJY1AxNWJMbUFlMWVQamQ0K295bWRXNE9Pc045azBTM3phVHhlTnIvNkpJ?=
 =?utf-8?Q?JA/x/pgOapCAV6FQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: wCIhWpqk1a6EQwl4PInCdxRsl7w0FVSt7GT0rSMnsX1I5DMApCVleI5Mcg0iN//HM+oYiivZSBWN/ZXOQ6Qbuui45wEA1zz2eCJbaaHfnyuVZyuxC4AZ9VkqxlUUnLiJXuzCuQ3UuEz40Mzfbrc5phzkQJVguNQhaReTT/Fm2xQGwMf423XWOUbudr2WYCDhAQYn6+3EpGx+yIG69aZFHtedB2dOEm9HmVI/cig3vtdc8K/MGEn+21lpd4zkzCNe71mrx9AuNqkYh+4MzQU1nfKyLMEkxA3pBeZJUQNEb+A75NUKGjXSfrBZTaCDOWaCNcROJjw6JSJhFM/idiEhmg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035d0fb4-9c77-4038-13df-08df1948977e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2026 07:59:27.9450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URmUGm1+O6I0dS21g93jfVu04r1aM5lCva7PrJ2RL/Pl4oBjJlHXDkjCmfJRD9Du6JB7QaUix4s7wBAgdTTLvC8A40gmqlUxymXZHvU/mU7EfDT/pwYxNr8fO6iK0zwG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8251
X-OriginatorOrg: intel.com

VGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCA3OTdkMzRlNjIyYjIyNjJjYTA3Nzdl
OThmZDQwYjFkMjkwMzQxNjlkOg0KDQogIE1lcmdlIGJyYW5jaCAncm9ib3QvcGF0Y2gtMC0xNzg5
OTcyMDk1JyBpbnRvICdtYWluJyAoMjAyNi0wOS0yMSAxOTo0NTo0MyArMDAwMCkNCg0KYXJlIGF2
YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6DQoNCiAgaHR0cDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9pd2x3aWZpL2xpbnV4LWZpcm13YXJlLmdpdCB0
YWdzL2l3bHdpZmktZnctMjAyNi0wOS0yMw0KDQpmb3IgeW91IHRvIGZldGNoIGNoYW5nZXMgdXAg
dG8gYjcyMzU2MTQwODY2MTY5YjY5MmFkMzNhNjlhMGU1YjZlNTk2ZWJkNjoNCg0KICBpd2x3aWZp
OiBhZGQgQnovU2MgRlcgZm9yIGNvcmUyNC44MC00MSByZWxlYXNlICgyMDI2LTA5LTIzIDEwOjUx
OjA5ICswMzAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpSZWxlYXNlIENvcmUyNC44MA0KDQoyMDI2LTA5LTIzDQoN
Ci0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCk1pcmkgS29yZW5ibGl0ICg1KToNCiAgICAgIGl3bHdpZmk6IEFkZCBjYy9RdS9R
dVogZmlybXdhcmVzIGZvciBjb3JlMjQuODAtNDEgcmVsZWFzZQ0KICAgICAgaXdsd2lmaTogdXBk
YXRlIHR5L1NvL01hIGZpcm13YXJlcyBmb3IgY29yZTI0LjgwLTQxIHJlbGVhc2UNCiAgICAgIGl3
bHdpZmk6IEFkZCBIci9HZiBmaXJtd2FyZSBmb3IgY29yZTI0LjgwLTQxIHJlbGVhc2UNCiAgICAg
IGl3bHdpZmk6IFVwZGF0ZSBCei9GbSBmaXJtd2FyZSBmb3IgY29yZTI0LjgwLTQxIHJlbGVhc2UN
CiAgICAgIGl3bHdpZmk6IGFkZCBCei9TYyBGVyBmb3IgY29yZTI0LjgwLTQxIHJlbGVhc2UNCg0K
IFdIRU5DRSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDYwICsrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLQ0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdS1iMC1oci1i
MC03Ny51Y29kZSAgIHwgQmluIDE0MDY1NzYgLT4gMTQwNjU3NiBieXRlcw0KIGludGVsL2l3bHdp
ZmkvaXdsd2lmaS1RdS1iMC1qZi1iMC03Ny51Y29kZSAgIHwgQmluIDEzMjMyOTYgLT4gMTMyMzI5
NiBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdS1jMC1oci1iMC03Ny51Y29kZSAgIHwg
QmluIDE0MDY1OTIgLT4gMTQwNjU5MiBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdS1j
MC1qZi1iMC03Ny51Y29kZSAgIHwgQmluIDEzMjMzMTIgLT4gMTMyMzMxMiBieXRlcw0KIGludGVs
L2l3bHdpZmkvaXdsd2lmaS1RdVotYTAtaHItYjAtNzcudWNvZGUgIHwgQmluIDE0MDY3MjAgLT4g
MTQwNjcyMCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1RdVotYTAtamYtYjAtNzcudWNv
ZGUgIHwgQmluIDEzMjMzMjAgLT4gMTMyMzMyMCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lm
aS1iei1iMC1mbS1jMC1jMTA3LnVjb2RlIHwgQmluIDIxNTk2NjAgLT4gMjE2Mzc1MiBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1iei1iMC1nZi1hMC0xMDAudWNvZGUgIHwgQmluIDE4Mzc1
ODQgLT4gMTgzNzU4NCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1iei1iMC1oci1iMC0x
MDAudWNvZGUgIHwgQmluIDE1ODQ3NjggLT4gMTU4NDc2OCBieXRlcw0KIGludGVsL2l3bHdpZmkv
aXdsd2lmaS1iei1iMC13aC1iMC1jMTA4LnVjb2RlIHwgQmluIDAgLT4gMjA1NDE4MCBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1jYy1hMC03Ny51Y29kZSAgICAgICAgIHwgQmluIDEzNjgx
MDAgLT4gMTM2ODEwMCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1nbC1jMC1mbS1jMC1j
MTA4LnVjb2RlIHwgQmluIDAgLT4gMjA5MjI0OCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lm
aS1tYS1iMC1nZi1hMC04OS51Y29kZSAgIHwgQmluIDE3NTI5NzYgLT4gMTc1Mjk3NiBieXRlcw0K
IGludGVsL2l3bHdpZmkvaXdsd2lmaS1tYS1iMC1nZi1hMC5wbnZtICAgICAgIHwgQmluIDU1MDk2
IC0+IDU1MDcyIGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLW1hLWIwLWdmNC1hMC04OS51
Y29kZSAgfCBCaW4gMTYwNTAxNiAtPiAxNjA1MDE2IGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3
aWZpLW1hLWIwLWdmNC1hMC5wbnZtICAgICAgfCBCaW4gMjc4MjAgLT4gMjc4MjAgYnl0ZXMNCiBp
bnRlbC9pd2x3aWZpL2l3bHdpZmktbWEtYjAtaHItYjAtODkudWNvZGUgICB8IEJpbiAxNTM5ODM2
IC0+IDE1Mzk4MzYgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmktc2MtYTAtZm0tYzAtYzEw
OC51Y29kZSB8IEJpbiAwIC0+IDIyNTM0NjAgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmkt
c2MtYTAtZ2YtYTAtMTAwLnVjb2RlICB8IEJpbiAxODExNTA4IC0+IDE4MTE1MDggYnl0ZXMNCiBp
bnRlbC9pd2x3aWZpL2l3bHdpZmktc2MtYTAtd2gtYjAtYzEwOC51Y29kZSB8IEJpbiAwIC0+IDIx
NTEyOTIgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmktc28tYTAtZ2YtYTAtODkudWNvZGUg
ICB8IEJpbiAxNzM3MDEyIC0+IDE3MzcwMTIgYnl0ZXMNCiBpbnRlbC9pd2x3aWZpL2l3bHdpZmkt
c28tYTAtZ2YtYTAucG52bSAgICAgICB8IEJpbiA1NTE3NiAtPiA1NTE1MiBieXRlcw0KIGludGVs
L2l3bHdpZmkvaXdsd2lmaS1zby1hMC1nZjQtYTAtODkudWNvZGUgIHwgQmluIDE1OTE5ODQgLT4g
MTU5MTk4NCBieXRlcw0KIGludGVsL2l3bHdpZmkvaXdsd2lmaS1zby1hMC1nZjQtYTAucG52bSAg
ICAgIHwgQmluIDI3ODYwIC0+IDI3ODYwIGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNv
LWEwLWhyLWIwLTg5LnVjb2RlICAgfCBCaW4gMTUyNzAwNCAtPiAxNTI3MDA0IGJ5dGVzDQogaW50
ZWwvaXdsd2lmaS9pd2x3aWZpLXR5LWEwLWdmLWEwLTg5LnVjb2RlICAgfCBCaW4gMTY3OTA4MCAt
PiAxNjc5MDgwIGJ5dGVzDQogaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXR5LWEwLWdmLWEwLnBudm0g
ICAgICAgfCBCaW4gNTUwMjAgLT4gNTUwMjAgYnl0ZXMNCiAyOCBmaWxlcyBjaGFuZ2VkLCAzOCBp
bnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW50ZWwv
aXdsd2lmaS9pd2x3aWZpLWJ6LWIwLXdoLWIwLWMxMDgudWNvZGUNCiBjcmVhdGUgbW9kZSAxMDA2
NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLWdsLWMwLWZtLWMwLWMxMDgudWNvZGUNCiBjcmVhdGUg
bW9kZSAxMDA2NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNjLWEwLWZtLWMwLWMxMDgudWNvZGUN
CiBjcmVhdGUgbW9kZSAxMDA2NDQgaW50ZWwvaXdsd2lmaS9pd2x3aWZpLXNjLWEwLXdoLWIwLWMx
MDgudWNvZGUNCg==
