Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496CA486B8B
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865954; cv=fail; b=YlY9fjPlu9AdUuH34+bd5K56PKK2VXC+7B5fLp3xY7Js/WROLYP0wE0jhtR5NS+DuYSXnYWqtFQsT3dfgbgX1nSBXC8otHDsjDQS1gVD+VsjvEwSOM6AjqBycHwk6HRsd4N7sS6z92u+ObQHnT8ILX38QhsvAEVbPeDRTT1J1U0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865954; c=relaxed/simple;
	bh=85GzhTEp1l9IA1OSbmiXLF/z2K60qUt/VpXlbQk5uko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EiF122LnZSoQfmXCYJhQ5g45yt/QIfBnVVRfkKvgtIGC6EaUmnqwb5nG0eEbJwJbClqhS+zc13WrYgchx5eynWyx6KuV0sGfoj6e6FwbXSlP+pTzFyzX17yu2EBad7U5hvWtLCc/W46wOIuN0h9dmJEC+3r+k/kUPjM+1IWg1Eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2D4Pnt7; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2D4Pnt7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790865951; x=1822401951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=85GzhTEp1l9IA1OSbmiXLF/z2K60qUt/VpXlbQk5uko=;
  b=e2D4Pnt7IUmFw0tv83n4JEZnYkL6VBmsN/7pTfMhZlX+4AFrnIhgTCqg
   sJT8DEHH7EqeD72YIGWSzUJAGue0gFtqFPROze4AESJM3rGAJPA1I3B09
   KqWKcj1Q0ysMIK2+zatTO7wBTGWP1XicAb3sJLVVD4a4DsvjCAEhqTGJT
   Tt3AsAgno1SW9QgMB3sF2d/Bd5EDuP9o0lgVkVsbO2fkUOXxUpOyd4vdK
   0vRE+wxF074MxW2xA06JYxIXaE86RURYWAYqUUyrNskjxSNsBBl3dIU2f
   w6soaDDSN6Kwv5uIAI+QuNWvNT1XUxmKTtz2tZnu8n7jmczxmhOmw8T8u
   w==;
X-CSE-ConnectionGUID: 4Zxh+nV5Snq6iBTwXy4oEA==
X-CSE-MsgGUID: ncqcMacnRA2Dyjq8q+2/Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="102298571"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="102298571"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 07:45:45 -0700
X-CSE-ConnectionGUID: 49VFHfIMQMy676f25UOI6A==
X-CSE-MsgGUID: 0VnNSOvxReOcBweLf9kpyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="24298"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 07:45:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 07:45:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 1 Oct 2026 07:45:44 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 07:45:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Czxot3a1hRNtdNquJJ5YEN+W6NOFUsfcRZWXPrrOLYFXkes0fZlrnxJHfYwGCoCyRqijDLM+H4igY2zOCMi7eh+VYmc4aG2M/EgSIwlr87SL9u37OKqYz+SzRzagb6DwXrVMPwH5b+QQKHR06xVUAGnXphWIKL7eHdzewZDQqzYw4VJbQl5ATtw84W/zmN7ve2o8OI3kF8XLrQ6TdjjI6FHHAr8Y+z3Bs7VgEjOEcSNXH21EODNkfeLxz9+ZiXNkXWUGjC7zDnyAlrzjJ1nS1X0EwClkRv82vd7hkNg1r4UQozU20ziWCOK4Dm/U/yodxhJI3ku8WufRGIrHrUWXjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85GzhTEp1l9IA1OSbmiXLF/z2K60qUt/VpXlbQk5uko=;
 b=zJB2Pt2JDj0hdZWWRo/FrRGfeh6MtaEAshpkscgK9d7Eh9nkpQLlYfyTgKOEbUDZsujTVqYZYiG1VSlp+vvhcDNFOH38PuiPJfLIq8VaQyJtkAduOg+WLUOmYfvS4DVP58qhJHU398VHnHX3f/0MGBRdIsM/hrAgl6/Z4bTLYF/icVqzb/EIf8cGm8+1pBeVEC2h7yKJebEgrkvHUjMjRVeVHIvRQYnvuuzEGwnPsHIFHF6PQ2Hp34yrrmNSRRmuLaXA9iHLpr88NhcyVMyZ86z+d3vT/MiWIA9g76h6C78HTGYZJeRxglAbZYvHTbJoK1nWBjsKKeT9AexG5emgWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by DM4PR11MB8179.namprd11.prod.outlook.com
 (2603:10b6:8:18e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Thu, 1 Oct
 2026 14:45:41 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0451.026; Thu, 1 Oct 2026
 14:45:40 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Miri Korenblit <error27@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Anjaneyulu, Pagadala Yesu" <pagadala.yesu.anjaneyulu@intel.com>
Subject: RE: [PATCH v2 iwlwifi-next 06/15] wifi: iwlwifi: fw: harden UEFI
 reduced-power TLV parsing
Thread-Topic: [PATCH v2 iwlwifi-next 06/15] wifi: iwlwifi: fw: harden UEFI
 reduced-power TLV parsing
Thread-Index: AQHdTdqyF2DbIJwX0UO0jkclQ/aJybborntA
Date: Thu, 1 Oct 2026 14:45:40 +0000
Message-ID: <IA3PR11MB7213131CF570152E567C71A286A38A2@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
 <20260926201527.2552432e98e8.I570750f27d9530d4c76922d2699a272d9c60a0ab@changeid>
In-Reply-To: <20260926201527.2552432e98e8.I570750f27d9530d4c76922d2699a272d9c60a0ab@changeid>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|DM4PR11MB8179:EE_
x-ms-office365-filtering-correlation-id: 7b111a96-76fe-462a-d17d-08df1fcaa9b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|38070700021|4143699003|6133799003|10067099003|11063799006|56012099006;
x-microsoft-antispam-message-info: uQ8yAmGM2WkpB/FRfn66e9/J1Gv72U13IiVSIwZwP1UGpkxaEv3/7G0EwAJGMaR4Lc0+AV8Hx9s6ZJR3xWYqotKhdnX/BfkCua3ehTiirHWsoY5BYSVtOsx03VHahTLgB56FqgOpWrNewKQRzA+ITLK/qUWPSyllGuZpC1ZS1OXbKJARatI6vPcJui70hc+TLLGpEJsTIbOocoSxHjXWGRKqwTXnJMxEyoAuxrrhuRxgA6s6GXJW4kwoAvG9tkZm3NUyFD0rtiBensUBBsC41SQBTSegEr1bxrZQCOE0gfmj4a+vec9xzaFWiZKtoCOtxMUnXTPDkxPTKPN/wQIpajSRDhQ4WmFYGtEEEbh75Lk1cmkYnqYKRzLAD5SWN72c9evXJbdSLpP4WFHBDysD3tjvhp8sverU+NjyCZDPLwedO7kiy2m22US820OJkjwhyGAlTtc8eON002Ofv/rDy1uGQrXYRAsyc3Uufeasxe4LC/i70TxY+XBE5XZ2s7v5mnXY2ueYuNa1maAMKszUdwNlIfSLgVL3rYbA7PsmT7bRAz4+bGB3EaOBNkjdMOOO+PEzR8EFUAfbArq1oBCNMXFw7ROnOBNbrQdVuE/kfkFgqf16VUoyEL6ixgWaWYG0QP81BK/R7O3ob1X7j1BDXYqtUsWndb6EokvTc9aJNil/W7AkkwEwGZAFIrHmnAoFF8qXGYK1rcuuo1tiXqkhCP726KGRA/23w539PQ6KqhI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(38070700021)(4143699003)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWg5QURUMWpkTGhSakhLM2QrdGUrUmFXdjZaN0RHdmE3SEc2SzBjdFE2SlZu?=
 =?utf-8?B?MUFzSGtpSjdFcnJqZWd6bjVGUGxLMHlINXV4UmdIbHBMWjY3Qlc0NStHY1VZ?=
 =?utf-8?B?MHl3ZC94aGJaZG5MVnk4bGVUK2Jsc3ZraFdpamhHaWV2MVFRSWFLbGJtaTlZ?=
 =?utf-8?B?RFkzZ0RvdEJ4M2tNdHpabU9tUW84SENRdUdKNEQ3YUlsQ0VYOG1jQVducGp3?=
 =?utf-8?B?aGZvcGtqSmF6Tk5TeGlmSEw4THZUK2w4TEoyZjBxblIwYmczaWVIdDdmcVV2?=
 =?utf-8?B?QUthNENST3JOQURVUGdDZWhCUmh0MGFudjNyMHFNR3RjYnlpZVdNUGtGRFRi?=
 =?utf-8?B?aDZndGt1enpJaURBa2FPWERUZStpMnRUZmMrTmhjak4wN0pzNDNkNmhDUGdX?=
 =?utf-8?B?R3ZjbHVqTXErTlg3ZGZxeEdsT3hPZUlaenM0M3l3ckRXYUhzem1kbjBlckxB?=
 =?utf-8?B?VldMZWhQUnNHRU55NzluWVM3Y2RyVktIam9wdVBqTlh5SHB2b1BveFlVR2hv?=
 =?utf-8?B?bUlDNlhpS2NucGVJZ0UxODRtQVlpYVVENk1tTEx2ZU9LcWR6c3YyQ0xiMFdX?=
 =?utf-8?B?RVFoekdXUUtOTFhoUFlyVllZYzVMdC9lUXhYcUFPK1NtSkdiRkdUVVQ3V0dC?=
 =?utf-8?B?K1A5WEVWNGFrL3BjdnUzcGw5akoxUGp4T2VQS0UzTnk0SVVJUCtLaXV2YnRH?=
 =?utf-8?B?WENZYi9OUjg5KzNqQm1wUEwzcFY1SDh1SHVEMUR2Z1FwUWMzdWJwSVFmcDJE?=
 =?utf-8?B?NTQyVUFZRVVkZVlybWlxLzlnTForMzVHZUZRcUVPTThuaDNsRmN4RGw0K0M3?=
 =?utf-8?B?bzRKSGVSOU01UmUvUlJEYzRhWmpIZW4vMjdOcmNBV2F5ZGVhRVU2eEZTWUVq?=
 =?utf-8?B?NUhsZGVxRStsZDE1RUhOZmRMM3RTOG1nOThpY3RNVXBsbTlmcVBSSDJ2cXNo?=
 =?utf-8?B?dTBna3NDWE5SUDFvUHBVckpYcGZHcUJDM3hMMUtHOTJOV0dPYWJaVU1Hejg4?=
 =?utf-8?B?b1N3NEE0Q3JyZ2lDVkhvVHEwWE82U21NZ1NncndUelFTVEhCZmY0M0ZLeDlh?=
 =?utf-8?B?UVJ3TVBRWnRNc2tHQkI3V2xqd2pSdVNBbHVhdDBZSUw1dTRCUWxqUEJzTGhQ?=
 =?utf-8?B?NXMrRjlLdGxXOG9CckE3dEFTS08xS3BnNjZ3cDgvNFA2UHBtZm5pa2RUWGFC?=
 =?utf-8?B?eks3azNIUkE2MXgrR2tIUVJVaDFSQ2dwUFdDRHAwd2JMdXdicnZwcXFyWnVU?=
 =?utf-8?B?OVBiSVNaMHJjUzkzeHhwRHZHUjdGQUFVTFJEQzJPdUQ5VW1RWnJBWHRVVWpF?=
 =?utf-8?B?cEN5cHcvVGU0czJ0cisrZ0RTQU9DZDJxejg4RzZ6NUJWMDFOTi9yTURibSth?=
 =?utf-8?B?Z3FsdGJNUk15RjdzbnI4bUdqOFI5QmVIS0I2U1pqbndaVUZLTzZla1BMTnBK?=
 =?utf-8?B?L1I1czNLMUM3MTJveWUwdDdiNWxlUjdjendsbmxXTkNRaHp4TW4wMURQMk1k?=
 =?utf-8?B?MEFmNFg4VTNUenpOeG5iSFhJRGt1R210WFBwMHJlVEpUUGtPTFVZZUtOeWg4?=
 =?utf-8?B?V2VCYXUyNUxZSWNaalJ1UjQvbC9CS0cxbUw3OXk2OHRXUjhXZFRkWWtLUGRm?=
 =?utf-8?B?aWxIWnRRVTZZMUw5dTgzamVCbFpzQUVyQ1FIRVp3WVBYODRZRk56a0RjMjlk?=
 =?utf-8?B?d20rVDVvWkVKL21sSTIyUzJxeXVsZ1kvOVNOVUVldmtXR2VKUFZ0N0cxTWNB?=
 =?utf-8?B?ODkyamZSeGFCc3czUlhUWDhUUjdYdUtvTHVtclU0WjZhaHpHZXNldjJEcHRa?=
 =?utf-8?B?TjhNK0ovTHNLMmUyK3ppd1ZKVU4zL1ZTQ2o2Q0dtTE5TcDVZem5rQk1UaFQ2?=
 =?utf-8?B?ZG1PMU90bTUvZHZsVXZwNUJuVGRTaVVCN285TE05VG5TcnczMHJCV3UwUysw?=
 =?utf-8?B?ZUVYOUswUGpiTkZKNlFSLzBld0JVblZ3MkowWEpNOWk3dEJCYXhBSG1WQ3A3?=
 =?utf-8?B?dXV0Y0M2azJPclNJaWxPSHVlL3JUM0hqMVFoWmRIT2dqZmVCNmNQS1JCTWNF?=
 =?utf-8?B?MXo2N3NyVHM4eFhrdVdYTmdIUStsLzQvbk15bkpvM2dPRDkvbnBNQ1hFOXhp?=
 =?utf-8?B?T1RiaWQ2SXVjTFhPV0tPRUFJNGo2YVNBbjdYZVVYaTVUU253RjF5YVY2SXdU?=
 =?utf-8?B?cjAzYXFFK0Y4KytWbnBBNGxvRXUyUkFXcXI5WkRyMGp6SE82R3pya0F6aHlS?=
 =?utf-8?B?TWZMTjZtRDFKOTdNRFgzM1k3WnduTFpVditMRXdnVW5aYmFUYnk1djZ4cmh3?=
 =?utf-8?B?TlFFVkJ3WmZLZFpYS0pGT1RtZGhNenEvSnJzcmdmaFRsOWloYXVoUXJFdytw?=
 =?utf-8?Q?zcaxHZKt9v75pHss=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: I6FGxyIQMGSRkb9Ac/j2i0wKr2XyCuufj81SHygVHI8cXSjd/HFEa+lN33HPiwugvGthl4zXgNOnPkUx8qT/TW9vimEDBmJ18g3vUvoTIUyABO7dz3oLSDDHk7umwmPjbNdQ5KGs/KtqRPiyX+HG9a2hSomN0Kh48D3HFIZENYLhlE11spGuYsq27ku5b358q7m90Iek3AZUKlP/3IPEbHVHWezu3mV3bYq9fnfMBbZB1IJNzqfZkNFUwLFlEwixsWamqSl/OkIpLNUh6G80mB/ssUK+zM3T6W7DOe7xQ7H/xfIpO9x9uk9z2t0mrCD0NOL3vf0LiDEqGKeX1DgGtw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b111a96-76fe-462a-d17d-08df1fcaa9b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2026 14:45:40.1202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PLHJlrhU3kyT/+pASEI35JskHv3ktunYv0/fLeVd3jJZdQG/atIkjheYDPrtU/ouYhqcHkRoFZ0kKaXoU2TGTVrxAzK74d1KFXi0zkNO6QSKfHecaK/8R9NPeZfZBXff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8179
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWlyaSBLb3JlbmJsaXQg
PGVycm9yMjdAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgT2N0b2JlciAxLCAyMDI2IDEx
OjMyIEFNDQo+IFRvOiBLb3JlbmJsaXQsIE1pcmlhbSBSYWNoZWwgPG1pcmlhbS5yYWNoZWwua29y
ZW5ibGl0QGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsg
QW5qYW5leXVsdSwgUGFnYWRhbGEgWWVzdQ0KPiA8cGFnYWRhbGEueWVzdS5hbmphbmV5dWx1QGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIHYyIGl3bHdpZmktbmV4dCAwNi8xNV0gd2lmaTog
aXdsd2lmaTogZnc6IGhhcmRlbiBVRUZJIHJlZHVjZWQtDQo+IHBvd2VyIFRMViBwYXJzaW5nDQo+
IA0KPiBDb21taXQgZTY4Zjc0NTk0ZmRiICgid2lmaTogaXdsd2lmaTogZnc6IGhhcmRlbiBVRUZJ
IHJlZHVjZWQtcG93ZXIgVExWDQo+IHBhcnNpbmciKSBmcm9tIFNlcCAyNiwgMjAyNiAobGludXgt
bmV4dCksIGxlYWRzIHRvIHRoZSBmb2xsb3dpbmcgU21hdGNoIHN0YXRpYw0KPiBjaGVja2VyIHdh
cm5pbmc6DQo+IA0KPiAJZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9mdy91ZWZp
LmM6MzU0DQo+IGl3bF91ZWZpX3JlZHVjZV9wb3dlcl9wYXJzZSgpDQo+IAl3YXJuOiBkdXBsaWNh
dGUgY2hlY2sgJ3Rsdl9sZW4gPCAxMicgKHByZXZpb3VzIG9uIGxpbmUgMzQ0KQ0KPiANCg0KVGhh
bmtzIGZvciBwb2ludGluZyB0aGlzIG91dCENClNlZW1zIHRoYXQgdGhpcyBmaXggd2FzIHdyaXR0
ZW4gYmVmb3JlIHdlIHJlYmFzZWQgb24gdG9wIG9mIHRoZSBvdGhlciBvbmUuLi4NCkknbGwgZml4
IGl0Lg0KDQo+ID4gRnJvbTogUGFnYWRhbGEgWWVzdSBBbmphbmV5dWx1IDxwYWdhZGFsYS55ZXN1
LmFuamFuZXl1bHVAaW50ZWwuY29tPg0KPiA+DQo+ID4gVUVGSSByZWR1Y2VkLXBvd2VyIHBhcnNp
bmcgYWR2YW5jZWQgYnkgQUxJR04odGx2X2xlbiwgNCkgYnV0IHZhbGlkYXRlZA0KPiA+IG9ubHkg
dGx2X2xlbi4gV2hlbiByZW1haW5pbmcgYnl0ZXMgd2VyZSBiZXR3ZWVuIHRoZXNlIHZhbHVlcywg
bGVuDQo+ID4gY291bGQgdW5kZXJmbG93IGFuZCBwYXJzaW5nIGNvdWxkIGNvbnRpbnVlIHBhc3Qg
dGhlIGJ1ZmZlciBib3VuZGFyeS4NCj4gPg0KPiA+IFZhbGlkYXRlIHJlbWFpbmluZyBieXRlcyBh
Z2FpbnN0IHRoZSBhbGlnbmVkIGxlbmd0aCBiZWZvcmUgYWR2YW5jaW5nDQo+ID4gaW4gYm90aCBU
TFYgd2Fsa2Vycy4gQWxzbyByZWplY3Qgc2hvcnQgUE5WTV9TS1UgVExWcyBiZWZvcmUgcmVhZGlu
Zw0KPiA+IHNrdV9pZCBmaWVsZHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYWdhZGFsYSBZ
ZXN1IEFuamFuZXl1bHUNCj4gPiA8cGFnYWRhbGEueWVzdS5hbmphbmV5dWx1QGludGVsLmNvbT4N
Cj4gPiBBc3Npc3RlZC1ieTogR2l0SHViQ29waWxvdDpHUFQtNS4zLUNvZGV4DQo+ID4gU2lnbmVk
LW9mZi1ieTogTWlyaSBLb3JlbmJsaXQgPG1pcmlhbS5yYWNoZWwua29yZW5ibGl0QGludGVsLmNv
bT4NCj4gPiAtLS0NCj4gPiBAQCAtMzIzLDggKzM0MSwxNSBAQCBpbnQgaXdsX3VlZmlfcmVkdWNl
X3Bvd2VyX3BhcnNlKHN0cnVjdCBpd2xfdHJhbnMNCj4gKnRyYW5zLA0KPiA+ICAJCQljb25zdCBz
dHJ1Y3QgaXdsX3NrdV9pZCAqdGx2X3NrdV9pZCA9DQo+ID4gIAkJCQkoY29uc3Qgdm9pZCAqKShk
YXRhICsgc2l6ZW9mKCp0bHYpKTsNCj4gPg0KPiA+ICsJCQlpZiAodGx2X2xlbiA8IHNpemVvZigq
dGx2X3NrdV9pZCkpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eIE5vIG5lZWQgdG8gYWRkIHRoaXMsIGl0J3MNCj4gYWxyZWFkeSBj
aGVja2VkIGJlbG93Lg0KPiANCj4gPiArCQkJCUlXTF9FUlIodHJhbnMsDQo+ID4gKwkJCQkJIklu
dmFsaWQgSVdMX1VDT0RFX1RMVl9QTlZNX1NLVQ0KPiBsZW4gJXVcbiIsDQo+ID4gKwkJCQkJdGx2
X2xlbik7DQo+ID4gKwkJCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCQkJfQ0KPiA+ICsNCj4gPiAg
CQkJSVdMX0RFQlVHX0ZXKHRyYW5zLA0KPiA+IC0JCQkJICAgICAiR290IElXTF9VQ09ERV9UTFZf
UE5WTV9TS1UgbGVuDQo+ICVkXG4iLA0KPiA+ICsJCQkJICAgICAiR290IElXTF9VQ09ERV9UTFZf
UE5WTV9TS1UgbGVuDQo+ICV1XG4iLA0KPiA+ICAJCQkJICAgICB0bHZfbGVuKTsNCj4gPiAgCQkJ
aWYgKHRsdl9sZW4gPCBzaXplb2YoKnRsdl9za3VfaWQpKSB7DQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBeXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KPiANCj4gcmVnYXJkcywN
Cj4gZGFuIGNhcnBlbnRlcg0KPiANCj4gPiAgCQkJCUlXTF9FUlIodHJhbnMsICJpbnZhbGlkIFBO
Vk0gU0tVIFRMViBsZW46DQo+ICV1XG4iLA0KDQo=
