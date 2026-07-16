Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CA52E9730;
	Thu, 16 Jul 2026 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199380; cv=fail; b=XU/OBjzBk1ahY4ZG7AmVI5lOOW960FzyVTX/HjBtdVVc6jPukGEaFwWim0mm/RMxlzH+xoHptX3gehqCUvmKpvkWQmKIHusNGCBXhVD6eLcy6/y70f/4gWvU3eJdcudd/Fht44GbNie1OOWhfRSqjMA+M7eTlhPZBy1AhwIkkIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199380; c=relaxed/simple;
	bh=+736OFwZblae4mhccdqbF77RcpHquHwlFKLR08t46Gk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irLqksqjXfzlghXt4oeNKboG+cCu+W+/sIvhyt7sc1bLNmcRZrNzUmdvHwCPM/V8sYzJi/WY+Dx/OjULJORs7Xo1DzERSDdvJPxfSo2v+QQnPC/2NQVod8eQ9px/VDlhAx5g+butrdf3lXvjRKKgHsPT99E2uvaLk92R27ixeqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=npDPQV+V; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="npDPQV+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784199378; x=1815735378;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+736OFwZblae4mhccdqbF77RcpHquHwlFKLR08t46Gk=;
  b=npDPQV+VZ+9won5w3z3FaVnmZCvDl6vADPzO240FUYswVF1UDgpgNZtm
   zKytaJ7d2q20/OBpYwIhVmVJryEEHu0H07dp9zv5b9wLMrMIkW+uXv8gO
   DGzXGka5LP3VzypkrRaCMqQJT+GxfjCZwl58Cs+W2t4Yyv6FOZrA8OYYF
   KDdLuZBSZ7TpZ/OpXk/jwzlelb9ji69Bt6lS4Z9UkdORXG2NGIMJpvuA3
   Ga2L4FCDmRH7Bzdz7LV7uGLyDwk4mUC3t8CyoZ4xeleYdtMV6wnvlKOS0
   w3peHLxUeBOlqNrqg6sQ8AtabDKdzLUelLErb1crQHLHtgyS+TTJBYCAA
   A==;
X-CSE-ConnectionGUID: sWFimw74SKmMUHRgWUlnPQ==
X-CSE-MsgGUID: ObiOgUe9T1m24xbFqjXv7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="95457795"
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="95457795"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 03:56:17 -0700
X-CSE-ConnectionGUID: okft9UJrTG66VBVsgpGllw==
X-CSE-MsgGUID: 0DDwfk/ETRaonUs4PbpZsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,167,1779174000"; 
   d="scan'208";a="252489638"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2026 03:56:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 03:56:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 16 Jul 2026 03:56:14 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 16 Jul 2026 03:56:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JSHanWb9bcM5mNd1PanonNwNfXy8/iIeEuAYFOuX8OV9gTJKVOcbMfvNSKssu/a5xGPTkP4+RJUTuPg9BQUHHgDHH3LP8GYyLyoy5D5aPFnL7ppl6JlzFYt5rS4lv9+1/h5hVfidzi2MbWeLzZP6FVSJA5NtlQgcEQQ9eRAfbQDXziWD3081/kqEoUOZMsxSXY3VG07wVEFdjmjH7pj04SozaJJBSMq1eGV8URTdLDAWf3mcXl9G1h4tPNgxiMT9anHnDRkjpl4NMj4IwaMcFcq9n7pQAJNrB+lo+0+QJsqw+nLtd/stv9Eu54FU8IKlVHnudTK7PUynctWvy/h5VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+736OFwZblae4mhccdqbF77RcpHquHwlFKLR08t46Gk=;
 b=vJ0U+cd140tSFGo6wgflUfVF7VqrbBvzgUol/zXnVD5oqiXpQ/dcboMsFCUwFtmurMHTIexedqCcDBP4DhOOgtg2HsoGx83bzWyrig4+Jd4XXhRgEs/RWV0GI06GgW0+gnWTT5IgJyuToMBuBRaHSrCdue7O/hXW359a+RO7LVSCBdE+kp4V15HvRAsYOilqLImizE6aJaL1+beJarL7dWwmrJ38OPylpGtpOt3w7mKg+jqX28Dg3Z2D89J64oibYkpOPMFFjHpszEcdSQYWQgomG1tyBd/Ix7S9LegFaBZxT9c0pDh1NhmzJUGSR4rGhet4FeaIAQGj/woZYDbjhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) by
 CH3PR11MB7939.namprd11.prod.outlook.com (2603:10b6:610:131::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 10:56:11 +0000
Received: from DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2]) by DS0PR11MB7880.namprd11.prod.outlook.com
 ([fe80::7485:4354:e91d:2%2]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 10:56:11 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: =?utf-8?B?TWFyZWsgTWFyY3p5a293c2tpLUfDs3JlY2tp?=
	<marmarek@invisiblethingslab.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: kernel BUG at mm/slub.c:634 (kfree) when unbinding device from
 iwlwifi
Thread-Topic: kernel BUG at mm/slub.c:634 (kfree) when unbinding device from
 iwlwifi
Thread-Index: AQHdFGbavA6vvN+4lU2AaJWcbJsoz7Zu1AOAgAEhEgCAAAVo0A==
Date: Thu, 16 Jul 2026 10:56:11 +0000
Message-ID: <DS0PR11MB788044B56D71DFD7FF7B9385A3C72@DS0PR11MB7880.namprd11.prod.outlook.com>
References: <aleaCWlvrmiUcLhT@mail-itl>
 <DS0PR11MB788064B1ADCB2A98542F75A1A3F82@DS0PR11MB7880.namprd11.prod.outlook.com>
 <ali0JisW1DsSwP7S@mail-itl>
In-Reply-To: <ali0JisW1DsSwP7S@mail-itl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7880:EE_|CH3PR11MB7939:EE_
x-ms-office365-filtering-correlation-id: 9d228887-4517-4d6f-cd8b-08dee328d968
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: OrAqVsFxUA98gQf84coRGoBWUPNOEml5J+Q6Eq/LIfbwiZbeIxezWqaWDE3+zntS6AGEcXDVacqQgJjaDFQ9+7leYlVrMy1lPxfh3vKtfo4028B0FMAmZLyqz3hDkR3VhAEGExbCCvAwDAb6XdPI65O6QzUdtTHOAydIv8ro/IaciRnH+gz41Kgrow0QYc/zvbQApcLAjG+jsc6ps7pneze0u5Zw7MmKVMkkG2+hpxXd7znHRmXAGNHQAs3Xso48Mst1Z57WdkyZvDBct2PJ7p1Xt7vZcqJjX0iRAs7QK54w8B/jtWEbTWEybSK2Uw2jxagcEeIylpb7GguFG2jwG8AZS+UbfJEnAxxmhn9FhvyvoygOlCI33qtRkrqDP2yOLHMvMPyJXNZeMmAL0kUahqx6JjPEwIP82JObxaV4U+nOwhY9Urqek0QeCeKmOwphDqnazIfWurTA0+l+EYCv2vZxjPbgs4C0FYY3AdcQlVFrD8HdV7YLmRL0ntLtc6EoBFnaS3gFspEbmsH95uECCrMmeKy3W5c/6s6WhSXt3cy5cuw3tEB2HSg6TiU7FnPOBMb5V0z0gPDtDFoDHC9cpEPWpEpwJoVEpMOsWvw6hEUwRXiddPWiVgAq37SW38kGmCYqah4ndnBmsaFHEGUoc2YH2I2ipdCwyW7MDV6s6iPDlw2CXwDMaIniMl2CkZxQy/LliReX9DfWAqTGTW24FXCOO5JPDTLXV89RtNzLamc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUhwL1NTL0sxV0VUcThkS0prR3hSNVRscWdVMG1UNVcwRUJ5cklUWGgyRnNn?=
 =?utf-8?B?OUJVdDhrVHlYM1JwajlraUdnbkpsMnhpbmwzV1AxdzgzSSs5WnVGRFN3TW5X?=
 =?utf-8?B?N3E1Zi9OaGNpdGtiemcwbk9PTHQvbUJCNXVWUFpkRENwcVpvMmI5VEFxZGFx?=
 =?utf-8?B?a3NQU0pjSThsTVNhL2UrejBacWV0bUpseFpITnlpd3J3bGQyVEFZem5RN3FH?=
 =?utf-8?B?WHBManVPNllDNW9QU3RncmNXSksvNURMbHFLbnZkVGVkKzF0N2JnWDd5V21q?=
 =?utf-8?B?L3B1NlVDQTFPajBpaVNXUy85TmEydHdIVzdFUlYrSHlLYjd3ekdueE1VRXIz?=
 =?utf-8?B?a2VhK0xtQnY5U2ZRSnI0bEY5dkVhTXVHK2hoQTN1R3ZTSlNEUDNxT1R6emNj?=
 =?utf-8?B?SzlGMkZzNDlDYlJDMHNZYm5XZ0xGODRlOFBHNFJQUUl6Vk41YkNORmxhRmtW?=
 =?utf-8?B?bUZPYlRkWWp1RTUyUEZiSVVJYThxdS9uK285L1h2bjluNHBxU0hZSGpMUWJM?=
 =?utf-8?B?ZjNZVzFCYXFVNFk1cVNuMENydkZGaXBCYTBJSEZ2VmlCek5zRzNuTnBjc3Rw?=
 =?utf-8?B?dmFUZGE1aWd6b1pzYURFODNkbTQxbTlhSjdnQm03ZHZDeVFTdjJ6VzNqOW5Z?=
 =?utf-8?B?d0hUT29qR1RTQVNVUlNyTjh4R3MwdWRFZHpkOUhqd09GR1lzS1MwN2M2UGs1?=
 =?utf-8?B?UnhXOUovQUc0ZEJGTlVQUklhUFFEUW9UcWgvampSU25INmJXaDdEaEVaN0Yy?=
 =?utf-8?B?b3pLQ2JMZmtFTGpESjl2b0pTRFppZ204Rk9FZ1lIWXRJQU1GNkFsWTJVUk4z?=
 =?utf-8?B?dzdza05ZcGdxT0pyS094K2lhVms2cUZHSjhjVEcwZDNCaUtMMGc5UUgvbllU?=
 =?utf-8?B?RnM1aHY1TGFvdFFSUlJSRFQyWUd4Z05KM2R5U1FYRll6QmI5N3g0dXd4end2?=
 =?utf-8?B?Y3YwZ2d2N1lEcDZLSWp2bFgxenBZUmx4Nm0wdWpVV1NxV2JldDVlYU5GcnE0?=
 =?utf-8?B?SEJST09leHI0ZzgvSnNUTm5vV0JOdTY1K1R6bnZZWlF2WUdYd2ppWFJVSlgv?=
 =?utf-8?B?ZEtTMktFbmFiWHFKRW8zNlZRUUJZNWZVS21uSC9zaGhrRXhkY0ZCb2RUcU1S?=
 =?utf-8?B?WmNDTFBLRjlkK0EvUGp0djRiS2x6NjltcjljbFJLTDRySG9IZ2FCeGtaT1lt?=
 =?utf-8?B?M0R0TjdUZnVkL05NYlBxUWpGL0d3b281NCswYjVVbGhWK3Z3NEJHT2JFWlh3?=
 =?utf-8?B?aWhHSThIVzlaYWsxYVJZeXl2eWtWMUFuRFVLVEd4UTBkektpbmlBTkFiQ0tK?=
 =?utf-8?B?S2kwT3FLR0Npc3dnR2tEWnVLcnZERUFicis3dmYrQjFzbDNlS2xWTzVoZFNn?=
 =?utf-8?B?QW5ZaUdlVXgrSjV6d290TTRzMVpHbWJha2RUK3NOZTEvSXJhb2k2MDkvMklk?=
 =?utf-8?B?QWRjOGNUUi9rcUsyRjZyS0dOUVF6d2tqNHdJVG9HWVNiRzdvVDJnTDc4amM3?=
 =?utf-8?B?aWdFek54Mm4vU1JydWdCeDByVHhpRnJqdEZTYkJ4RW1PRW9JWXlKYlFPdWZB?=
 =?utf-8?B?UEl0WURuR1FXdzNFVzgzSVpkd2xGWUYyTnMxNkxVcVlaUUFOUDR4dXBkZnFV?=
 =?utf-8?B?ZFROVE1hTk9qSDh6WnZFRkxSU3RxeERyWEJDc1R3WUNweURCYk94UitEbGhT?=
 =?utf-8?B?dWlvdjF4M2o2Sk5obVNBU0ZnU2VncUV2VjI1VmRvWTNvQTlMa2RnSjJmQ2gz?=
 =?utf-8?B?MENsNjdFVVgxMlUxTmZHUk43QjVRVkUrU05CZ0IrQjBnYys1NUdWU1lPVWFz?=
 =?utf-8?B?STJySWFOakNkUGs4ZzE2UFQ3QkpHQjlrbzk1YytZdTV5NElBWmVyKzFQNlU1?=
 =?utf-8?B?LzArYnR0THY1a3NNOGV3d1Bhd2IzaVR5emdCbDF1M1I4dFdyZjlVK3hPOUw0?=
 =?utf-8?B?SjA0QXdIWnlHaHVPRCt0Ylh6c3VHYlBydk1xMUROWHV6V2FVUEh4NjRhY0xy?=
 =?utf-8?B?aTVCU0NBcG9TSXFXMmNqdEhNZGFwMTdIelV4WmNublpKU0d3Ui9yN2VzOElG?=
 =?utf-8?B?U2hmUldidGZoMHdBdWVkU3RLUzU4MmtvcmhucU1JVzZSaCtMQS9MdXBVUWd1?=
 =?utf-8?B?clJoS1V1emVSTnJTNXhDTE9WT3V6RE5ZK1NXcjFxV3kzZlNlVU55UXoxZ3JF?=
 =?utf-8?B?ajlnUGtWcGhORFJEOFQ1aXZEa2RuWFJHNjlVMWxYL1pKaENDWndmdElpSEdH?=
 =?utf-8?B?RGRKcVF4WWU1QWwyS1pLR3ZDNHJ1VDVGdXZ3RXhNYmVaNmQzelVSekxvSERE?=
 =?utf-8?B?K0N4REZOdTZFWmY2TnRWc0VxZmJLd0NHWUIyd0o0cWpmMUxKUWpnbGNpVkFq?=
 =?utf-8?Q?nK10DX2IKnn2cuxY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: hIOgfqc73sMXaEUusETAUoOqK3NZy1zPclNBQ2h4NmB8XeudyX1kB1XDVUcbHn0pFIgyX6JQufKjVAgcIGB9wzV+A0xn7nEezE3SHPYcjzYlzAbGXu+AYy/1KdF/OcDDttvffG9SUYqQpqWFPr2IXCJrTNZvtAl1LsgGXKwg6fhX8P8dhvmJOWeVYZMYcmQ7ThBemIaPTg9lIHJL57lSsW95k6B+RPkiBFx2QxooLa99k4XyDUHVY7OQZH9SWX76yTse0KepKBd6nJNc083tyErxzOfv9ptzm4A00DN9MoqMZgA11aQygjyt0PtMGSd/DOKoGiA/gFKDukw0XUTF5A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d228887-4517-4d6f-cd8b-08dee328d968
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2026 10:56:11.8388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eaaUBPl5SDrhZeIFV3+t4CJGbxzRd1au32xQwIakPIGgtNsUmm8Riw+ltkSwUti4GQhpRHX0cMHhDp4JWeUT5WtspsSWa3MbCdWfcuqvRGs4/ML4Swjpw9/VEnN38gBk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7939
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFyZWsgTWFyY3p5a293
c2tpLUfDs3JlY2tpIDxtYXJtYXJla0BpbnZpc2libGV0aGluZ3NsYWIuY29tPg0KPiBTZW50OiBU
aHVyc2RheSwgSnVseSAxNiwgMjAyNiAxOjM2IFBNDQo+IFRvOiBLb3JlbmJsaXQsIE1pcmlhbSBS
YWNoZWwgPG1pcmlhbS5yYWNoZWwua29yZW5ibGl0QGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LXdp
cmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZToga2VybmVsIEJVRyBhdCBtbS9zbHViLmM6NjM0IChrZnJlZSkgd2hlbiB1bmJp
bmRpbmcgZGV2aWNlIGZyb20NCj4gaXdsd2lmaQ0KPiANCj4gT24gV2VkLCBKdWwgMTUsIDIwMjYg
YXQgMDU6MjI6NDRQTSArMDAwMCwgS29yZW5ibGl0LCBNaXJpYW0gUmFjaGVsIHdyb3RlOg0KPiA+
DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBNYXJl
ayBNYXJjenlrb3dza2ktR8OzcmVja2kgPG1hcm1hcmVrQGludmlzaWJsZXRoaW5nc2xhYi5jb20+
DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgMTUsIDIwMjYgNTozMyBQTQ0KPiA+ID4gVG86
IEtvcmVuYmxpdCwgTWlyaWFtIFJhY2hlbCA8bWlyaWFtLnJhY2hlbC5rb3JlbmJsaXRAaW50ZWwu
Y29tPg0KPiA+ID4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDoga2VybmVsIEJVRyBhdCBtbS9zbHVi
LmM6NjM0IChrZnJlZSkgd2hlbiB1bmJpbmRpbmcgZGV2aWNlDQo+ID4gPiBmcm9tIGl3bHdpZmkN
Cj4gPiA+DQo+ID4gPiBIZWxsbywNCj4gPiA+DQo+ID4gPiBJIGdldCBhIGtlcm5lbCBwYW5pYyB3
aGVuIHVuYmluZGluZyBkZXZpY2UgKDgwODY6MDA4NSkgZnJvbSB0aGUNCj4gPiA+IGl3bHdpZmkg
ZHJpdmVyICh2aWEgd3JpdGluZyB0byB0aGUgInVuYmluZCIgZmlsZSBpbiBzeXNmcyksIHdoaWxl
DQo+ID4gPiB0aGUgd2lmaSBjb25uZWN0aW9uIGlzIGFjdGl2ZS4gSSBjYW4gcmVwcm9kdWNlIGl0
IG9uIFRoaW5rcGFkIFgyMzAsDQo+ID4gPiBidXQgb3RoZXIgZGV2aWNlcyBtaWdodCBiZSBhZmZl
Y3RlZCB0b28uIFRoZSBzcGVjaWZpYyBjcmFzaCBpczoNCj4gPiA+DQo+ID4gPiAgICAgWyAgMjg2
LjkwODE4Ml0ga2VybmVsIEJVRyBhdCBtbS9zbHViLmM6NjM0IQ0KPiA+ID4gICAgIFsgIDI4Ni45
MDgyMDFdIE9vcHM6IGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0gU01QIFBUSQ0KPiA+ID4gICAg
IFsgIDI4Ni45MDgyMjFdIENQVTogMSBVSUQ6IDAgUElEOiAxOTU5IENvbW06IHByZXBhcmUtc3Vz
cGVuZCBOb3QNCj4gPiA+IHRhaW50ZWQNCj4gPiA+IDYuMTguMTUtMS5xdWJlcy5mYzQxLng4Nl82
NCAjMSBQUkVFTVBUKGZ1bGwpDQo+ID4gPiAgICAgWyAgMjg2LjkwODI1NV0gSGFyZHdhcmUgbmFt
ZTogWGVuIEhWTSBkb21VLCBCSU9TIDQuMTkuNCAwMy8xNy8yMDI2DQo+ID4gPiAgICAgWyAgMjg2
LjkwODI3NV0gUklQOiAwMDEwOmtmcmVlKzB4M2E4LzB4NDcwDQo+ID4gPiAgICAgWyAgMjg2Ljkw
ODI5Ml0gQ29kZTogNWQgNDEgNWUgNDEgNWYgNWQgZTkgNjcgYmIgZmYgZmYgNGQgODkgZjENCj4g
PiA+IDQxIGI4IDAxIDAwIDAwIDAwDQo+ID4gPiA0OCA4OSBkOSA0OCA4OSBkYSA0YyA4OSBlZSA0
YyA4OSBlNyBlOCBhZCAyYyAwMCAwMCBlOSBiZCBmZCBmZiBmZg0KPiA+ID4gPDBmPiAwYiA4OSBj
OCA0YyA4ZCAwNCAwMyA0MCBmNiBjNiA4MCAwZiA4NCA0MSBmZiBmZiBmZiA4MyBlNiAwOCAwZg0K
PiA+ID4gICAgIFsgIDI4Ni45MDgzNDddIFJTUDogMDAxODpmZmZmY2ZjZTgyODBiYjUwIEVGTEFH
UzogMDAwMTAyNDYNCj4gPiA+ICAgICBbICAyODYuOTA4MzY1XSBSQVg6IGZmZmY4YjJkY2VmMmM4
MDAgUkJYOiBmZmZmOGIyZGNlZjJjODAwIFJDWDoNCj4gPiA+IGZmZmY4YjJkY2VmMmM4MzANCj4g
PiA+ICAgICBbICAyODYuOTA4Mzg5XSBSRFg6IDAwMDAwMDAwMDAwYmUwMDEgUlNJOiAwMDAwMDAw
MDAwMDAwMDAwIFJESToNCj4gPiA+IGZmZmY4YjJkY2VmMmM4ODANCj4gPiA+ICAgICBbICAyODYu
OTA4NDE0XSBSQlA6IGZmZmZjZmNlODI4MGJiYTAgUjA4OiBmZmZmOGIyZGNlZjJjODYwIFIwOToN
Cj4gPiA+IDAwMDAwMDAwMDAwMDAwMDANCj4gPiA+ICAgICBbICAyODYuOTA4NDM4XSBSMTA6IGZm
ZmY4YjJkY2VmMmM4NjAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjoNCj4gPiA+IGZmZmY4YjJk
ZDI4NDE2MDANCj4gPiA+ICAgICBbICAyODYuOTA4NDYyXSBSMTM6IGZmZmZmMDc3MDAzYmNiMDAg
UjE0OiBmZmZmZmZmZmMwOTNjNDgwIFIxNToNCj4gPiA+IDAwMDAwMDAwMDAwMDAwNjANCj4gPiA+
ICAgICBbICAyODYuOTA4NDg3XSBGUzogIDAwMDA3YjEwMjg2Y2Q3NDAoMDAwMCkNCj4gPiA+IEdT
OmZmZmY4YjJlMTljNmMwMDAoMDAwMCkNCj4gPiA+IGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCj4g
PiA+ICAgICBbICAyODYuOTA4NTExXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAw
MDAwMDAwMDgwMDUwMDMzDQo+ID4gPiAgICAgWyAgMjg2LjkwODUzMl0gQ1IyOiAwMDAwN2ZiOTMw
MjdiYzcwIENSMzogMDAwMDAwMDAwMzRmMDAwNSBDUjQ6DQo+ID4gPiAwMDAwMDAwMDAwMTcwNmYw
DQo+ID4gPiAgICAgWyAgMjg2LjkwODU1OV0gQ2FsbCBUcmFjZToNCj4gPiA+ICAgICBbICAyODYu
OTA4NTcwXSAgPFRBU0s+DQo+ID4gPiAgICAgWyAgMjg2LjkwODU4MV0gID8gX3Jhd19zcGluX3Vu
bG9ja19iaCsweGUvMHgyMA0KPiA+ID4gICAgIFsgIDI4Ni45MDg1OTldICBpd2xfcGNpZV90eHFf
ZnJlZSsweDEzMC8weDE3MCBbaXdsd2lmaV0NCj4gPiA+ICAgICBbICAyODYuOTA4NjQ0XSAgaXds
X3BjaWVfdHhfZnJlZSsweDY2LzB4ZTAgW2l3bHdpZmldDQo+ID4gPiAgICAgWyAgMjg2LjkwODY4
MV0gIGl3bF90cmFuc19wY2llX2ZyZWUrMHgxZGYvMHgyNTAgW2l3bHdpZmldDQo+ID4gPiAgICAg
WyAgMjg2LjkwODcxOV0gIHBjaV9kZXZpY2VfcmVtb3ZlKzB4NDIvMHhiMA0KPiA+ID4gICAgIFsg
IDI4Ni45MDg3MzZdICBkZXZpY2VfcmVsZWFzZV9kcml2ZXJfaW50ZXJuYWwrMHgxOWMvMHgyMDAN
Cj4gPiA+ICAgICBbICAyODYuOTA4NzU1XSAgdW5iaW5kX3N0b3JlKzB4YTEvMHhiMA0KPiA+ID4g
ICAgIFsgIDI4Ni45MDg3NzFdICBrZXJuZnNfZm9wX3dyaXRlX2l0ZXIrMHgxNTAvMHgyMDANCj4g
PiA+ICAgICBbICAyODYuOTA4NzkwXSAgdmZzX3dyaXRlKzB4MjVkLzB4NDUwDQo+ID4gPiAgICAg
WyAgMjg2LjkwODgwNl0gIGtzeXNfd3JpdGUrMHg2Yi8weGUwDQo+ID4gPiAgICAgWyAgMjg2Ljkw
ODgyNV0gIGRvX3N5c2NhbGxfNjQrMHg4NC8weDgwMA0KPiA+ID4gICAgIFsgIDI4Ni45MDg4NDJd
ICA/IHN5c2NhbGxfZXhpdF93b3JrKzB4MTA4LzB4MTQwDQo+ID4gPiAgICAgWyAgMjg2LjkwODg2
MV0gID8gZG9fc3lzY2FsbF82NCsweGJiLzB4ODAwDQo+ID4gPiAgICAgWyAgMjg2LjkwODg3Nl0g
ID8ga3N5c19kdXAzKzB4NjMvMHhmMA0KPiA+ID4gICAgIFsgIDI4Ni45MDg4OTJdICA/IHN5c2Nh
bGxfZXhpdF93b3JrKzB4MTA4LzB4MTQwDQo+ID4gPiAgICAgWyAgMjg2LjkxMTM4OF0gID8gZG9f
c3lzY2FsbF82NCsweGJiLzB4ODAwDQo+ID4gPiAgICAgWyAgMjg2LjkxMTQwOF0gID8gZG9fc3lz
X29wZW5hdDIrMHhhNC8weGUwDQo+ID4gPiAgICAgWyAgMjg2LjkxMTQyM10gID8gc3lzY2FsbF9l
eGl0X3dvcmsrMHgxMDgvMHgxNDANCj4gPiA+ICAgICBbICAyODYuOTExNDQzXSAgPyBkb19zeXNj
YWxsXzY0KzB4YmIvMHg4MDANCj4gPiA+ICAgICBbICAyODYuOTExNDU4XSAgZW50cnlfU1lTQ0FM
TF82NF9hZnRlcl9od2ZyYW1lKzB4NzYvMHg3ZQ0KPiA+ID4gICAgIFsgIDI4Ni45MTE0NzddIFJJ
UDogMDAzMzoweDdiMTAyODczZWM1ZQ0KPiA+ID4gICAgIFsgIDI4Ni45MTE0OTNdIENvZGU6IDRk
IDg5IGQ4IGU4IDM0IGJkIDAwIDAwIDRjIDhiIDVkIGY4IDQxIDhiDQo+ID4gPiA5MyAwOCAwMyAw
MCAwMA0KPiA+ID4gNTkgNWUgNDggODMgZjggZmMgNzQgMTEgYzkgYzMgMGYgMWYgODAgMDAgMDAg
MDAgMDAgNDggOGIgNDUgMTAgMGYgMDUNCj4gPiA+IDxjOT4gYzMgODMgZTINCj4gPiA+IDM5IDgz
IGZhIDA4IDc1IGU3IGU4IDEzIGZmIGZmIGZmIDBmIDFmIDAwIGYzIDBmIDFlIGZhDQo+ID4gPiAg
ICAgWyAgMjg2LjkxMTU0OV0gUlNQOiAwMDJiOjAwMDA3ZmZkOTRiYzMxMDAgRUZMQUdTOiAwMDAw
MDIwMiBPUklHX1JBWDoNCj4gPiA+IDAwMDAwMDAwMDAwMDAwMDENCj4gPiA+ICAgICBbICAyODYu
OTExNTc1XSBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwN2IxMDI4OGJhNWMwIFJDWDoN
Cj4gPiA+IDAwMDA3YjEwMjg3M2VjNWUNCj4gPiA+ICAgICBbICAyODYuOTExNjAwXSBSRFg6IDAw
MDAwMDAwMDAwMDAwMGQgUlNJOiAwMDAwNjM4NWRiNGY4MDIwIFJESToNCj4gPiA+IDAwMDAwMDAw
MDAwMDAwMDENCj4gPiA+ICAgICBbICAyODYuOTExNjI1XSBSQlA6IDAwMDA3ZmZkOTRiYzMxMTAg
UjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOToNCj4gPiA+IDAwMDAwMDAwMDAwMDAwMDANCj4gPiA+
ICAgICBbICAyODYuOTExNjUwXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAw
MDAwMjAyIFIxMjoNCj4gPiA+IDAwMDAwMDAwMDAwMDAwMGQNCj4gPiA+ICAgICBbICAyODYuOTEx
Njc0XSBSMTM6IDAwMDAwMDAwMDAwMDAwMGQgUjE0OiAwMDAwNjM4NWRiNGY4MDIwIFIxNToNCj4g
PiA+IDAwMDA2Mzg1ZGI0ZjViMzANCj4gPiA+ICAgICBbICAyODYuOTExNzAxXSAgPC9UQVNLPg0K
PiA+ID4gICAgIFsgIDI4Ni45MTE3MTFdIE1vZHVsZXMgbGlua2VkIGluOiBpd2xkdm0gaXdsd2lm
aSBtYWM4MDIxMQ0KPiA+ID4gZWhjaV9wY2kgZWhjaV9oY2QgbmZ0X25hdCBuZnRfZmxvd19vZmZs
b2FkIG5mX2Zsb3dfdGFibGVfaW5ldA0KPiA+ID4gbmZfZmxvd190YWJsZSBxcnRyIG5mX2Nvbm50
cmFja19uZXRsaW5rIG5mdF9yZWplY3RfaXB2Ng0KPiA+ID4gbmZfcmVqZWN0X2lwdjYgbmZ0X3Jl
amVjdF9pcHY0DQo+ID4gPiBuZl9yZWplY3RfaXB2NCBuZnRfcmVqZWN0IG5mdF9jdCBuZnRfbWFz
cSBuZnRfY2hhaW5fbmF0IG5mX25hdA0KPiA+ID4gbmZfY29ubnRyYWNrDQo+ID4gPiBuZl9kZWZy
YWdfaXB2NiBuZl9kZWZyYWdfaXB2NCBuZl90YWJsZXMgam95ZGV2IGxpYmFyYzQNCj4gPiA+IGlu
dGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29tbW9uIHBvbHl2YWxfY2xtdWxuaSBnaGFzaF9jbG11
bG5pX2ludGVsDQo+ID4gPiBjZmc4MDIxMSBlMTAwMGUgYXRhX2dlbmVyaWMgcmZraWxsIGkyY19w
aWl4NCBwYXRhX2FjcGkgaTJjX3NtYnVzDQo+ID4gPiBwY3Nwa3IgZmxvcHB5IHZmYXQgZmF0IHNl
cmlvX3JhdyB4ZW5fc2NzaWJhY2sgdGFyZ2V0X2NvcmVfbW9kDQo+ID4gPiB4ZW5fbmV0YmFjayB4
ZW5fcHJpdmNtZCB4ZW5fZ250ZGV2IHhlbl9nbnRhbGxvYyB4ZW5fYmxrYmFjaw0KPiA+ID4geGVu
X2V2dGNobiBpMmNfZGV2IGZ1c2UgbG9vcCBuZm5ldGxpbmsgb3ZlcmxheSB4ZW5fYmxrZnJvbnQg
W2xhc3QgdW5sb2FkZWQ6DQo+IGl3bHdpZmldDQo+ID4gPiAgICAgWyAgMjg2LjkxMTk2N10gLS0t
WyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQo+ID4gPg0KPiA+ID4gVGhpcyBpcyBy
dW5uaW5nIGluIGEgVk0gKEhWTSkgdW5kZXIgWGVuLCB3aXRoIHJlbGV2YW50IFBDSSBkZXZpY2UN
Cj4gPiA+IGF0dGFjaGVkLCBidXQgSSBkb24ndCB0aGluayBpdCdzIHJlbGV2YW50IGZvciB0aGlz
IGJ1Zy4NCj4gPiA+DQo+ID4gPiBJJ3ZlIGdvdCByZXBvcnRzIGFib3V0IHRoZSBpc3N1ZSBpbiBM
aW51eCA2LjE4LjE1IGluaXRpYWxseSAoYWZ0ZXINCj4gPiA+IHVwZGF0aW5nIGZyb20gNi4xMiks
IGJ1dCBsYXRlciB0ZXN0cyBpZGVudGlmaWVkIGl0J3MgYSByZWdyZXNzaW9uDQo+ID4gPiBzb21l
d2hlcmUgYmV0d2VlbiA2LjE1LjExIGFuZCA2LjE2LjguDQo+ID4NCj4gPiBIaSwgY291bGQgeW91
IHBsZWFzZSB0ZXN0IHRoZSBhdHRhY2hlZCBwYXRjaD8NCj4gPiBJdCBpcyBiYXNlZCBvbiA2LjE4
DQo+IA0KPiANClllcywgdGhlIHBhdGNoIGZpeGVzIGl0IQ0KDQpUaGFuayB5b3UgZm9yIHRlc3Rp
bmchIEknbGwgc2VuZCBhIGZpeC4NCj4gDQo+IFRlc3RlZC1ieTogTWFyZWsgTWFyY3p5a293c2tp
LUfDs3JlY2tpIDxtYXJtYXJla0BpbnZpc2libGV0aGluZ3NsYWIuY29tPg0KPiANCj4gLS0NCj4g
QmVzdCBSZWdhcmRzLA0KPiBNYXJlayBNYXJjenlrb3dza2ktR8OzcmVja2kNCj4gSW52aXNpYmxl
IFRoaW5ncyBMYWINCg==
