Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEB61DEFE8
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 07:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785655452; cv=fail; b=hu2ILNiR+H+KDavsCemykLyaWvbgLfwdTkBmsdYsFNYnVqYnl4oLAzt7U+LDVm5u4rnNUCYnuLN+17szdywxYIVXF2Es2aK3dR876Iwt3uClNIKEE6SzW9cNsRdRAGyRE4pl65WF2LPhnfsvPQF2uzIjBm4fZRxHq/GrrPufVlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785655452; c=relaxed/simple;
	bh=3xllj+UcMPaOfJrBgS8mSl0kx0KGK4U/CQAYx6c5APM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j/FlGS7DzUU9SODZ9OLKZeF+YXbs7O8o9N/B5UPmTjT6VSk8dvfEzXumeUBl4hWvCiCHhaXH0cE8VYs88iUhtRAiKLr52ZYMM8RHY+oUVOUmSzMTnmj74DK66c/7I+XQO3Az5chcS7LhpriNvtBR5QBK4omZVOTRY74nJ30FxJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJ+p8moo; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJ+p8moo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785655451; x=1817191451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=3xllj+UcMPaOfJrBgS8mSl0kx0KGK4U/CQAYx6c5APM=;
  b=SJ+p8moofvAFmrZ1sm3ycXI18LettxzfOP6iDmh5ngoqgEEt7mY7rcA+
   D6GThAUXGLaGUrc7m/iD0QlW/+lIAcx7/v3Gpsf/nvZ3SrbAc0kwsvLmb
   0NAizmncgwsz/atgt6FAjF0kC+bjDQeXYMCbR76ozo4YDS2Ucs/VyAHXt
   tZ8KjeDiE51GcLpL1OZrHuA8wg/y3AcuoTEbQtGQUB9QMMT2o4PuiMJQZ
   YpgbwxKnt/MoBxNMv1EcpR3VZ6G2zwAnomtMK67IjEbt8sCD89O6dANOQ
   QwEao6ftz4Yro64mv+qmFILk/zbxmMLttfGU8x+0mtmgpcAyE6/4h7LQZ
   Q==;
X-CSE-ConnectionGUID: NtkgS6UHShuK1QzVL3kIWw==
X-CSE-MsgGUID: UuHgAXPST6qrOBZEcjLTzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="85991639"
X-IronPort-AV: E=Sophos;i="6.25,200,1779174000"; 
   d="scan'208,223";a="85991639"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 00:24:10 -0700
X-CSE-ConnectionGUID: eEcjp4EpS82ZMkFMgJX5pg==
X-CSE-MsgGUID: G3YhiGeaQi6uXXd+eaUBQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,200,1779174000"; 
   d="scan'208,223";a="256626988"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 00:24:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 2 Aug 2026 00:24:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 2 Aug 2026 00:24:06 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 2 Aug 2026 00:24:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dc3HNhnNJR0rWstVDr3lOhh6z0ZAAsnnwchQFvaS3lJC1BdEWwAj3PvZfpfecqxN4TEYi3IqSPv2Jk3j2z8M2KPOH79IB5qsbJpV1DTxJ5M2+mO2WvLwALfMYEdYyz2SOJ5MX0KTSeJVHg8WRUJwL/ublrNd5Xnj0KLTgF00fgMkd5J2owYppDaDgj/6zAQQjoS78qiRavTYJh1euFW4Xid7KyZ1e87whFlxRTGafmrtSRU8XCGqt4sp6ncE7Tb/DkBNLO/n5TPN/VaIp86bMbK3I17Lz5IrfwPBw46egVE/mkqWe5RY4QJFQw6Xi5ocBfTdsM+NaXXvIHtnDMfCfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGRTNfYuHrK4aGdXOzs7IFSCru4f2SfvrAxAckm2DxU=;
 b=UWpSh84aFUEPRI0+Z3kYScl9ApgLDBW6FXFB7zEHXujOEKJwifdYOwqtjOkeeBbpIzC1kl3S6Llu2uB1EDM2Xg6hsMAQhQXPvft7fgQh08q4OhioV5wgeX0rchWSnoJjgqVTMaxhUw5midg2dU6iIxzZ47RmFm3vKYTTuXhYaCLPNYqF3LHF7H62Rs5JYrSt5IbL9otHlmCINzO+QKMKrAdP2lLq0dlerl3/6z0wJisPgGcFpoz0HRsUpW6zldb9F/U5SweQM96iB14z2LHhqwb0bL3lduMY6SQcDJ7DNvdW/YPKbWlUIz4RJ7r+G6ikPoubqpRV7AR73RJfEZgnCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) by
 PH8PR11MB9697.namprd11.prod.outlook.com (2603:10b6:510:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 07:24:04 +0000
Received: from DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2]) by DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2%2]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 07:24:04 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Chris Bainbridge <chris.bainbridge@gmail.com>, "Grumbach, Emmanuel"
	<emmanuel.grumbach@intel.com>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
Thread-Topic: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
Thread-Index: AQHdIQ6/+BjK2xGmcEyX4zwNpHwL6baKXVYw
Date: Sun, 2 Aug 2026 07:24:04 +0000
Message-ID: <DS0PR11MB78800B96A0FE637DC5390E4AA3D62@DS0PR11MB7880.namprd11.prod.outlook.com>
References: <amzVtgQb2p-_nShU@debian.local>
In-Reply-To: <amzVtgQb2p-_nShU@debian.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7880:EE_|PH8PR11MB9697:EE_
x-ms-office365-filtering-correlation-id: de7ceb71-9d7e-498a-a234-08def0670853
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|6049299003|23010399003|366016|1800799024|38070700021|4053099003|56012099006|10067099003|11063799006|5023799004|22082099003|18002099003;
x-microsoft-antispam-message-info: rIq9m1m3Ovh6fjjYChMZFPqipfIcG8zrnR3Oi6Wvv6SXuJBwCkPUBPGdv1GmCfw3KKqSs0xkwHAxFhpwWhhFHPOFvqS7P86G1HsgG1AWpWB2azq8l99LkJX2kaM6fkExichH0A9veJqh7FoLHZzBe/yV2Imv66Vj5sIdKADAhbeX2IBHBdBSZR9Z/Q1sYv70g1imye0juqbujQ0iV+p/R7JkKSmnpRuoKLaODMFkMDUmkczh2aFDDgTi7ItwoZ12otWyB3amyosaOuSN+7rrBXFIOzQbDdXO7WuD5PziG0APxblPYXbdg524nFyttTX2eku0w7RSjeiJ/MCmb2qtYn52kK8CuwvYbBYSUndgTGAi0plil9FHfE8khXjRyDWIB20bAr3jg8LMtehyu8jEIjgVxcxaWU2tsWNNuNO/hgzPaRIj4one6YFqegvPiibemkbNes84uPhhD3CTFt80jIRDES30bi8c68cIAdX3nukjUxHEooMecsZsqWWXoz5v/k30NsoisFfDaC7/H3o4vbNMzOb95OO8Mf4N4NwrGb/1o/ZZxxNi9pqgeemN+zuSm3K4uenepsEY4OCEBbx0nlK2xA7nCT5v9hwdbUZtenXDMoD1xEUZSDhEt5MXq2ybnn1knx24ZQHwhCzcGvZZFjWlIL8WRnysfptWToMBmPY1YQqnxjEDh8r32aJwig9BH460p3wl2FJ2Ojuok82VXcGy9Cgxa+TAVBMXvZVUIo4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(6049299003)(23010399003)(366016)(1800799024)(38070700021)(4053099003)(56012099006)(10067099003)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGRRQmVBVEwveitORFFWVnVkSm1QTWNIK2R2bkl0WVNrdGtRVElIU1BrS3pK?=
 =?utf-8?B?eUtzSGNTWm5NUk5UYlNhWlN0bCttZ2NGUkxSU1JsUTBWa2RJZkdpN0pSdmN4?=
 =?utf-8?B?ZytuZGoxOVRQTGZDT0FuZ3pNWFpJQVpicVBKSE9lN2YrbkZET3pHdERyaEdI?=
 =?utf-8?B?RTd2OUxDWjdyOHpJR3BqckVmTlhMUUhYUytFYlFGemFKeVF2a1VTbGZidlJn?=
 =?utf-8?B?OWJ6Y08zRWFqd3BOcSthNXVQSEYrZHZibGpOanY5TG8rMzJoeS9sOG9IUFR2?=
 =?utf-8?B?U3o5TFhTTXo1bE1wZmpiMDZrbDhOUW9WVDZEVklIYStQT1dxRWltY29pb1ps?=
 =?utf-8?B?SFlva1NhRFZQakhQY0Q5ditHaGNEMGdDUHQ0dlNnQldEYnNqZjUzbDAzTS9u?=
 =?utf-8?B?WEl2MnFYWTlFV3JUanFrMlRuQUgrSzhMaGNWVHpsODdLcEkrRVZBZFBoMnN1?=
 =?utf-8?B?QlVEVStQRldBaU42dHZ3MTdRTTZTakpDRkJKU1RXUXhZSmF2TGROUSs1ejVu?=
 =?utf-8?B?WnQ2VExEMlJrZjNkcDV1c3A0TXJnc0tRNnZDQTNFMHUrdWNmYitKNmNJZm1R?=
 =?utf-8?B?YUxHYmJSUzloVlo5S2IzSmY5NzJNbThIWkNYSjA0YzQ2N003dnlTckZ6MG1P?=
 =?utf-8?B?dVZSRjh1bFhuNERoVCtZMGUvb3JkZnEzSHBJc0ZuSEFieG5peXBMQ3dkbFBt?=
 =?utf-8?B?Zm9ibzhhQXJPeXl0elNLaU5zMFdIS3FNdjNUOUVpQzY0ZitkL1VNQzVKaktj?=
 =?utf-8?B?R1UrYXgyd0xLS1czUGMxNkNXbDRCZVNucVpJWXIvbzZVWVAvOTRBVXJUTzZS?=
 =?utf-8?B?SVNORjc1d1lsc3ZMcWgrRXdYMTJpbEVPcFdsRU5ud01FbG0wRFhibHpFVXlh?=
 =?utf-8?B?NFFVRDhmcmhteGlqUnliSXVGTlZKdWRIVmpYSU45aWhQeHp1SldGbmwvL2h5?=
 =?utf-8?B?NFc1ckV6ZUp4RVFUZVdDcURWYWNLQ2VWeGxOZE9sTUxnWEpiSnFScHZvQ0kv?=
 =?utf-8?B?Y0k2Vks3aTErOWtVODhvVUNHcUYvMkVZRzY5dk1oSEtycDVXNTJCYldDK2JU?=
 =?utf-8?B?VHR3VFZ2QmM5bU9RelVGL3lad2ZPWXRFVmMzenVjOEFQQlUzangxRlplM2Zn?=
 =?utf-8?B?ZmIyTVZBVDlJVFd2a2pvY05TUFZyUXcxelB1YUFTVGxCTkpzR0ZsSmZJczZ6?=
 =?utf-8?B?R2tLRVY1TURmTnhVd0VYNnIyVkMxalk4enpsYml2bm5XSE1SS1dlSDhxVHV1?=
 =?utf-8?B?SUV0RVpDOUN1aGJLSEp6aWZmdWpzdnFDMkdHb1JMdGQzSkVHUm1ud1RscDBW?=
 =?utf-8?B?RDJkWVRwbVlZQ1Z3dVBXYVBkUVVodHE4WlFIMEVnZnNHaWJvcC9BanVocGkx?=
 =?utf-8?B?Q0M2WWJyTXZpN3BJVGV3TzVuR0ZjMzdhRDZOOWwvdy9HQVB5K3BrYjAwVVBy?=
 =?utf-8?B?RGNMTVIyMDd4dEtTeUM5RllUL2cra3BpYXZJUS9SSFI2emVCNnJzdCs0Mk5x?=
 =?utf-8?B?dkxQajgycEdWd3NsaUVtTUh6cWRFdDhSd3QwKzFvNk1pdXlUL0EzTjdTYWU1?=
 =?utf-8?B?eUIwM2lTMXhWa2FYRU5IcDVCTE5xRkhLU3k1V0t5aHlGS3hSVnE0OWtmWW5i?=
 =?utf-8?B?dU5RcmQ5OURqQW9DRkZSSjBhNmZSYU5wQkkxMjhTTnl3eWJKQmJ6VVAwK0gx?=
 =?utf-8?B?TVhzMFFveEswYVpTQ01vMXM1THl0OWlHclVXOXpvaGRBZkp1MUYzL2tLUit3?=
 =?utf-8?B?cjhSY1hkVUxIUmlEeDlOTUdGRm9mZnJES1I0dmJ6K2x2TWFSc04wdm9vK2NH?=
 =?utf-8?B?MXhQdHpNdE52d2ZpN2lhTmVEb2YxaHErV0hRZnV4SnZxcEJGQVVuUHhCQ1lQ?=
 =?utf-8?B?QXpZNVVRdkRlWVY3Q0hmZ0ZaNEZFOXB5Q3lLVlA2bHJVeHNDanJLVGVPNVVz?=
 =?utf-8?B?MHIydlplYjFoV0JFK1pWVGRPTXlVYnZjaTBiYjFRYW0rdURzd1hDd3lxK1By?=
 =?utf-8?B?VERqL1JyQXVPN2l5OG5PcTVlTk5abkRrWWtsdFVBanpMQmdMRzlhK3hGY3Bp?=
 =?utf-8?B?ZW5sYVkzU0xGb2pVQmYxZlh3L2loOVVndHlPMmlleU9kdkNoeXk0TDNPYnNO?=
 =?utf-8?B?YW5RRzNsSEVmTUJyWU51RmlSTW8rUWw3ZCthRXlvcnZia0lNZ1R0Wjc5MmJt?=
 =?utf-8?B?WGsrU1o3aDRqcVFhQ1h2Z0U1aVp6T0l4akF0cFJXMk9haG5zZE5HZStMSlVu?=
 =?utf-8?B?ODRSRk50N0hFTXRZQkVOYmVwY1pEbDc2cE4vM3lmMEIrRnZGUnlzTFQ5NTRY?=
 =?utf-8?B?TWViTWpnMFJUdTVIRGJHZGpiZkdHVXZYdHZDMHlEVitwMDdzblZIOTlJT0xv?=
 =?utf-8?Q?jESNxOiwZW5GXoek=3D?=
Content-Type: multipart/mixed;
	boundary="_002_DS0PR11MB78800B96A0FE637DC5390E4AA3D62DS0PR11MB7880namp_"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PSiN3ZHr4oTW/y/DBQYXpf+rL/h5GQiuzOnpeQUQu8owfvJELG2ZcQ2i27GwkETrMbuPDnLfU6BhEPMiErRA6z9txP9BaOfpyHJUNbPwdyrIy77L64NRl5WKADbp6PNeT6+i1XvVNXUlJtNTZ5aH8ABvSLEwcLT+T4Dc37feoIoZNH6qYqj/8r8SbGm/dwHBhQq1ppw65KKh3OSJH8zqLkXdshKnsL2umTLM8QomPCHexPN78XAl+YYxkAXDwrkMvo1c/pVm+SP9LvdIyZP1nYIL3ObUv+Xr0jXUBZyOiJLjAM1zpVwxF8jTsqqLypsv4rUD1Ia1kB6aQlnVamnIDQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de7ceb71-9d7e-498a-a234-08def0670853
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2026 07:24:04.4566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OvUKAiolSuGM07u9sGJjLWDvPNYtB1gNkXW7qyXBgtUOFEDwIYw1Ltk/E9z5DeIaow/La8TE43XiMoKUpFC/C66xih9VkHSXR2PLAq0zczu5D8ozRM7sgqsUJcM6He1p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9697
X-OriginatorOrg: intel.com

--_002_DS0PR11MB78800B96A0FE637DC5390E4AA3D62DS0PR11MB7880namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2hyaXMgQmFpbmJyaWRn
ZSA8Y2hyaXMuYmFpbmJyaWRnZUBnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVseSAzMSwg
MjAyNiA4OjA1IFBNDQo+IFRvOiBHcnVtYmFjaCwgRW1tYW51ZWwgPGVtbWFudWVsLmdydW1iYWNo
QGludGVsLmNvbT4NCj4gQ2M6IEJlcmcsIEpvaGFubmVzIDxqb2hhbm5lcy5iZXJnQGludGVsLmNv
bT47IEtvcmVuYmxpdCwgTWlyaWFtIFJhY2hlbA0KPiA8bWlyaWFtLnJhY2hlbC5rb3JlbmJsaXRA
aW50ZWwuY29tPjsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOw0KPiByZWdyZXNzaW9u
c0BsaXN0cy5saW51eC5kZXYNCj4gU3ViamVjdDogW1JFR1JFU1NJT05dIGl3bHdpZmkgSU9fUEFH
RV9GQVVMVCBhbmQgTWFzdGVyIERpc2FibGUgVGltZWQgT3V0DQo+IA0KPiBIaSwNCj4gDQo+IDBl
YWExZjI0NWFjMCAoIndpZmk6IGl3bHdpZmk6IG12bTogZG9uJ3Qgc3VwcG9ydCB0aGUgcmVzZXQg
aGFuZHNoYWtlIGZvciBvbGQNCj4gZmlybXdhcmVzIikgaW50cm9kdWNlZCBhbiBpbnRlcm1pdHRl
bnQgYm9vdCByZWdyZXNzaW9uIG9uIG15IGxhcHRvcDoNCj4gDQo+IFsgICAxNS45NzQ5OTFdIGl3
bHdpZmkgMDAwMDowMTowMC4wOiBBTUQtVmk6IEV2ZW50IGxvZ2dlZCBbSU9fUEFHRV9GQVVMVA0K
PiBkb21haW49MHgwMDBhIGFkZHJlc3M9MHhiZTlmNTAwMCBmbGFncz0weDAwMDBdDQo+IFsgICAx
NS45NzYxODRdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBBTUQtVmk6IEV2ZW50IGxvZ2dlZCBbSU9f
UEFHRV9GQVVMVA0KPiBkb21haW49MHgwMDBhIGFkZHJlc3M9MHhiZTlmNTQwMCBmbGFncz0weDAw
MDBdDQo+IFsgICAxNS45Nzg1MDFdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBNYXN0ZXIgRGlzYWJs
ZSBUaW1lZCBPdXQsIDEwMCB1c2VjDQo+IA0KPiBUaGUgY29tbWl0IG9ubHkgY29udGFpbnM6DQo+
IA0KPiArICAgICAgIC8qIFRob3NlIGZpcm13YXJlIHZlcnNpb25zIGNsYWltIHRvIHN1cHBvcnQg
dGhlIGZ3X3Jlc2V0X2hhbmRzaGFrZQ0KPiArICAgICAgICAqIGJ1dCB0aGV5IGFyZSBidWdneS4N
Cj4gKyAgICAgICAgKi8NCj4gKyAgICAgICBpZiAoSVdMX1VDT0RFX01BSk9SKG12bS0+ZnctPnVj
b2RlX3ZlcikgPD0gNzcpDQo+ICsgICAgICAgICAgICAgICB0cmFucy0+Y29uZi5md19yZXNldF9o
YW5kc2hha2UgPSBmYWxzZTsNCj4gDQo+IFRoZSBpZiBjb25kaXRpb24gaXMgZXZhbHVhdGluZyB0
cnVlIG9uIG15IGxhcHRvcCBkZXNwaXRlIHVzaW5nIGZpcm13YXJlIHR5LWEwLWdmLQ0KPiBhMC04
OS51Y29kZS4gU28gSSBzdXNwZWN0IHRoaXMgaXMgbm90IHRoZSBjb3JyZWN0IHdheSB0byBjaGVj
ayB0aGUgZmlybXdhcmUNCj4gdmVyc2lvbj8NCg0KWWVzLCBzZWVtcyBsaWtlIHlvdSBhcmUgcmln
aHQuDQpUaGFua3MgZm9yIHRoZSByZXBvcnQhDQoNCkkgYW0gYXR0YWNoaW5nIGEgZml4IGNhbmRp
ZGF0ZSwgSSdkIGFwcHJlY2lhdGUgaWYgeW91IGNvdWxkIHRlc3QgaXQuDQo+IA0KPiBBbHNvIGNv
bW1lbnQgIzIxIG9uIGJ1Z3ppbGxhLmtlcm5lbC5vcmcgYnVnICMyMjA2MDAgKHdoaWNoIHRoaXMg
Y29tbWl0IHdhcw0KPiBzdXBwb3NlZCB0byBmaXgpIHJlcG9ydHMgdGhlIHNhbWUgIk1hc3RlciBE
aXNhYmxlIFRpbWVkIE91dCIgZXJyb3IgKGFsdGhvdWdoIG5vDQo+IElPX1BBR0VfRkFVTFRTLCBw
cm9iYWJseSB0aGUgYmFkIG1lbW9yeSBhY2Nlc3MgaXMgbm90IGNhdWdodCB3aXRob3V0DQo+IGlv
bW11PXN0cmljdCkuDQo+IA0KPiAjcmVnemJvdCBpbnRyb2R1Y2VkOiAwZWFhMWYyNDVhYzAzZWQw
YzYzOTQxNTkzNjA1MzI3MjZmNjY2ODExDQo=

--_002_DS0PR11MB78800B96A0FE637DC5390E4AA3D62DS0PR11MB7880namp_
Content-Type: application/octet-stream;
	name="0001-wifi-iwlwifi-mvm-properly-check-the-FW-version.patch"
Content-Description: 0001-wifi-iwlwifi-mvm-properly-check-the-FW-version.patch
Content-Disposition: attachment;
	filename="0001-wifi-iwlwifi-mvm-properly-check-the-FW-version.patch";
	size=1807; creation-date="Sun, 02 Aug 2026 07:22:43 GMT";
	modification-date="Sun, 02 Aug 2026 07:24:04 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4MjUwOThmMmRlMmJjNjNlNWNlMTgwMjEzZDlmYWQwNDBmNjQ0ZmIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaXJpIEtvcmVuYmxpdCA8bWlyaWFtLnJhY2hlbC5rb3JlbmJs
aXRAaW50ZWwuY29tPgpEYXRlOiBTdW4sIDIgQXVnIDIwMjYgMTA6MTY6MTMgKzAzMDAKU3ViamVj
dDogW1BBVENIXSB3aWZpOiBpd2x3aWZpOiBtdm06IHByb3Blcmx5IGNoZWNrIHRoZSBGVyB2ZXJz
aW9uCk9yZ2FuaXphdGlvbjogSW50ZWwgSXNyYWVsICg3NCkgTGltaXRlZAoKVGhlIG1lbnRpb25l
ZCBjb21taXQgYWltZWQgdG8gZGlzYWJsZSBmdyByZXNldCBoYW5kc2hha2UgZm9yIEZXcyB3aGlj
aAp0aGVpciBBUEkgdmVyc2lvbiBpcyBsZXNzIHRoYW4gNzcuCkJ1dCB0aGUgY2hlY2sgaXMgaW5j
b3JyZWN0OiBpbiB0aGUgb2xkIGZvcm1hdCwgd2Ugc2hvdWxkIHVzZQpJV0xfVUNPREVfQVBJLCBh
bmQgZm9yIHRoZSBuZXcgVExWIGZvcm1hdCAtIGZ3LnVjb2RlX3Zlci4KU2luY2UgaXdsbXZtIGhh
bmRsZXMgb25seSBGV3Mgd2l0aCB0aGUgbmV3IGZvcm1hdCwgd2UgY2FuIGFsd2F5cyB1c2UKaGVy
ZSBmdy51Y29kZV92ZXIuCgpTaWduZWQtb2ZmLWJ5OiBNaXJpIEtvcmVuYmxpdCA8bWlyaWFtLnJh
Y2hlbC5rb3JlbmJsaXRAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvbXZtL29wcy5jIHwgMTIgKysrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNSBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL29wcy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9tdm0vb3BzLmMKaW5kZXggMjI5NzM5MmRiOTU1Li43ZTQ1ODA4ZGE1YjMgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL29wcy5jCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL29wcy5jCkBAIC0xNDEy
LDE1ICsxNDEyLDEzIEBAIGl3bF9vcF9tb2RlX212bV9zdGFydChzdHJ1Y3QgaXdsX3RyYW5zICp0
cmFucywgY29uc3Qgc3RydWN0IGl3bF9yZl9jZmcgKmNmZywKIAkJIHNpemVvZihtdm0tPmh3LT53
aXBoeS0+ZndfdmVyc2lvbiksCiAJCSAiJS4zMXMiLCBmdy0+ZndfdmVyc2lvbik7CiAKLQl0cmFu
cy0+Y29uZi5md19yZXNldF9oYW5kc2hha2UgPQotCQlmd19oYXNfY2FwYSgmbXZtLT5mdy0+dWNv
ZGVfY2FwYSwKLQkJCSAgICBJV0xfVUNPREVfVExWX0NBUEFfRldfUkVTRVRfSEFORFNIQUtFKTsK
LQotCS8qIFRob3NlIGZpcm13YXJlIHZlcnNpb25zIGNsYWltIHRvIHN1cHBvcnQgdGhlIGZ3X3Jl
c2V0X2hhbmRzaGFrZQorCS8qIFNvbWUgZmlybXdhcmUgdmVyc2lvbnMgY2xhaW0gdG8gc3VwcG9y
dCB0aGUgZndfcmVzZXRfaGFuZHNoYWtlCiAJICogYnV0IHRoZXkgYXJlIGJ1Z2d5LgogCSAqLwot
CWlmIChJV0xfVUNPREVfTUFKT1IobXZtLT5mdy0+dWNvZGVfdmVyKSA8PSA3NykKLQkJdHJhbnMt
PmNvbmYuZndfcmVzZXRfaGFuZHNoYWtlID0gZmFsc2U7CisJdHJhbnMtPmNvbmYuZndfcmVzZXRf
aGFuZHNoYWtlID0KKwkJZndfaGFzX2NhcGEoJm12bS0+ZnctPnVjb2RlX2NhcGEsCisJCQkgICAg
SVdMX1VDT0RFX1RMVl9DQVBBX0ZXX1JFU0VUX0hBTkRTSEFLRSkgJiYKKwkJbXZtLT5mdy0+dWNv
ZGVfdmVyID4gNzc7CiAKIAl0cmFucy0+Y29uZi5xdWV1ZV9hbGxvY19jbWRfdmVyID0KIAkJaXds
X2Z3X2xvb2t1cF9jbWRfdmVyKG12bS0+ZncsCi0tIAoyLjM0LjEKCg==

--_002_DS0PR11MB78800B96A0FE637DC5390E4AA3D62DS0PR11MB7880namp_--
