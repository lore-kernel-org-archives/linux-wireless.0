Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874734E73D0;
	Wed, 14 Oct 2026 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983548; cv=fail; b=TpmroKC0aLD1QDfXSnHZe5R8bTobfuaWbG1EcPzH5+y/TM8zeyDmLs4+X3YLXZ2dNryor9ztVWY6jlLQClcdhP1CQ6P2ypz1sVIoMGr3v7OMd3TeEvF6GkAn2/nLFjwxVWPYS6/8eGtsUmC/R2rBxt9YnCnvMa7xxxlubXIfDaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983548; c=relaxed/simple;
	bh=RUYVMWvIaqsb4X8xkjHKfhD6DuOZQ1bj/tfuaBu2DUs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l9jHbjqJBzymLCpgHZoP2W66hmIdchxxURruM1+IB8fF6gGxJL9lYT2R5/wyl5pVxpZ7oSQnAD0yCFrzbKoJ0FHfKsiffnc2XiP3X/qlw7sTYbGywiDSYE8UJq534q4DMdsCWKRtRVK6zRN6aagK4koiZjaEoKF5qJh8jKGZNTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K8WREQk9; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K8WREQk9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791983545; x=1823519545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RUYVMWvIaqsb4X8xkjHKfhD6DuOZQ1bj/tfuaBu2DUs=;
  b=K8WREQk9Ng97d/3RkqDVNNnlmU01jmuCy0DRNy6bjZ4wzlrxekAXYrko
   p8nVCJUdCksgYHxYdWsUqaUgGByaqiHBCFK+2Y/Ma4WlV/2ftHocCqFFB
   ATwScGpPpxAgdYzvltsV1HNsZckyy1IumSXm60HMOtcrrSoCQ7kF5waDG
   JrT1tc1TtG/8iMefKAILzJuEVkFZrKvuRDVJdfL97qVu6vNzX0wtXOfJJ
   blY7kJYpGqixeetlQTfYs7v/7kifIE7Gbaqs3zZSJQhBCyclVqNfHmcyB
   RDfxIhBrYH58L7qVmhQP2VJUXce8/wzSdQS/Dir84Xdvs7FF71jbKoADJ
   w==;
X-CSE-ConnectionGUID: PPzDSf1gTFKMsDE3NwY9Ag==
X-CSE-MsgGUID: KMZqJy/HR42WuQz/eowmyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="633508"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="633508"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 06:12:24 -0700
X-CSE-ConnectionGUID: 9qvtx2WoSBqrm9XuRqr99w==
X-CSE-MsgGUID: O57j9FryQHe+cdCkfrn19Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1519573"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 06:12:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 06:12:23 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 06:12:23 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 06:12:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYexRh6jx+I2j7XcJZWoWV6XTD1SbMvFgZvLXshUKStc46oLAOhhbhuMvy/IGPhriS5Wfa+I0QYnnQOhZQXG9e8c9qCnZo5/MZ5mrYwvkyi05PqcK1vuuvaGkmn4yUCFTQKOc0ea4SAswiPRnI3/iAg/1FXDeccwz0DjnAX5amBKxgm0RgfMlme9SrjjLKiKwbACrCsCElbSm5X5zksBX4o7bUTb4sbS4Czb1FAdiQy8v0SYPT0tB5aGTYvUrybLhSXMzpCR/R2GDktfFS9d9aQbrhs4z0ctwgpcmALSD1u68jrgL5Xs7SebZBfkBnKXUgpn9nsjxRICEk3slszqqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUYVMWvIaqsb4X8xkjHKfhD6DuOZQ1bj/tfuaBu2DUs=;
 b=GgBWdM0afutcSKU6Cu/qYHB0bhBlOspVIOnpCqAZq4dWee7vjGnzXsh23pg8MjOXE1Mk9CWoIf1ZGeH711Np9jAXrYo3j3VsglV96la7WBP0ta09xoreehCu/71CfV5pJ1g67wn3olsCaxdeJsMC96lomO8SkJT1f5qXdbzBj6OUIJduRPisrDR8tydnI7+qhN+hClyHm1+oAWZO08AAVONc1ByMDJvHVIJRcREVJF60yBRTk6UaeRTAnPoLF2bfh3Y6Hs/SzkzXNhlqY8xW7F8/TpxJzG+6aZI1grQjeXccDOfXhKCiKO2yGFTdxqAnjGBEsc//fiDayRVkGpcyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.24; Wed, 14 Oct
 2026 13:10:25 +0000
Received: from DM4PR11MB7349.namprd11.prod.outlook.com
 ([fe80::4356:92dd:3e35:8e30]) by DM4PR11MB7349.namprd11.prod.outlook.com
 ([fe80::4356:92dd:3e35:8e30%3]) with mapi id 15.21.0472.016; Wed, 14 Oct 2026
 13:10:25 +0000
From: "Gaur, Yogesh" <yogesh.gaur@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>, "Korenblit, Miriam Rachel"
	<miriam.rachel.korenblit@intel.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>, "Gaur, Yogesh"
	<yogesh.gaur@intel.com>
Subject: RE: [PATCH iwlwifi-next] wifi: iwlwifi: pcie: return a real errno
 from read_config32()
Thread-Topic: [PATCH iwlwifi-next] wifi: iwlwifi: pcie: return a real errno
 from read_config32()
Thread-Index: AQHdW9m6mGnGB8G1f06v4ZbC1i7ybrb8/ueAgAADuSA=
Date: Wed, 14 Oct 2026 13:10:25 +0000
Message-ID: <DM4PR11MB73495E446C07D90708D31C77EF9D2@DM4PR11MB7349.namprd11.prod.outlook.com>
References: <20261014124357.2569535-1-yogesh.gaur@intel.com>
 <3d2fde6558449d82dec7c9eef8cb4c6e4e464dc8.camel@sipsolutions.net>
In-Reply-To: <3d2fde6558449d82dec7c9eef8cb4c6e4e464dc8.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB7349:EE_|SJ0PR11MB5214:EE_
x-ms-office365-filtering-correlation-id: 787c938d-c694-4f08-b0fb-08df29f4831a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|11063799006|261009223027099003|38070700021|56012099006|4143699003|22082099003|18002099003|10067099003|6133799003;
x-microsoft-antispam-message-info: nAPlEynkxRDA3TZseUs7RuZdr/v8WqpR+zvX5leXyFfrUH8fRRV9jVfLF4jqC3SXDZXJh5rjsVOTsMUV1LXvjqsdYXZBA41MvYfQW8Rc35oDe/QeqBjYEi8G9adbKsMlggDzFayGGhm4d+ShrJ9imlKPpv5qKlEMJngvJlnBXQtChzuEAMddeF9nwwDO7l7ipmqeOe7w3OSUJvykxOSQ22rSCy44ANdQ+w4gC0aPyZZu9FGkT85MpHv8HhEWZxCrU03BIpjJ9OqirlJRXqd0Y9m8nHwKsdBa3toDw/GYwbqbzKzrx0jv9y9rfCOTViuVEb93TnwNJNVQ0t/n+JPkhsUr/AOL1IsknQZ5vKSZZl/1dOkhTVIx2v9cuGMmAeTpsWnQsyUdUhT/7Bp2BQDF/tAKZaR2jHJjFMGCwzl1qnt2KHf0oMT+zuGIWSjPFgKQ2vXl3aCQ2YQFJAPQK7DG1g6J3gN0c/E9Iukxir6LKY9MDu5HaBHNJMaoNEWtD6BGuJQ32EMh95EQe4w981p6CKsjMoNKRkdMtUIrTkp6OSC6uMC8XhvcKFybR5aK3seEAduRPtRdcGN4VJKZzNDQLeRjNxowiRNG7Wr/bEveUTc51ZOi9lHAhaT+DrZ1Ljhvy/U1GFQ3ND+tDkfTTLWdFmyp1CbC8xNnaVdU7IfxZdXDpLsOThFutPVWlNx6bhxjuoPxK/+i9hqxMMEHrOhzL+6PU4mvWpUZ04zkkxvPOzU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB7349.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(11063799006)(261009223027099003)(38070700021)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amdMNzFtMmNscnpSS1hvS2pxOXcweFR0ZU1rcGZpSWdqMTgzNEMzUmlla1c5?=
 =?utf-8?B?OGY0SFRpcHdhMUxKTGNaZkk2ZnRtY212TFJuNTlDcTM4Z1k3Ri9BM0VJWm93?=
 =?utf-8?B?UHlUWXhwV1RxNE1hNEVIbllqYlIwK01Rc3lpRGFmTnFYTlpIMXIveFN3bENn?=
 =?utf-8?B?SnVjdVFpeDN0Mko2WlhycFpqaTM1dmpoWjVWNVlqWlN5QTZmTXJxaG9ScFhq?=
 =?utf-8?B?YkdBZjNnV0QyYmtHTldCU1ljNGN0NEZVREFDWUVKYXp0YmpidlQwZW5pQ2Rt?=
 =?utf-8?B?dmx6M05IUy93ZWdRM0p0bFBQZkltMEk4RXZoUE5pU0k2QTl0RVIyR01pM0lE?=
 =?utf-8?B?blFxTU5PTW1JSG84aitkL3ZzUmR6bWZybW12Ri9yL0wxQVliMTZiVHo3ZFl3?=
 =?utf-8?B?Wk5XWDJEbUFiMG9IVHhvTmR4ZGI1S3ZjY3FSVlY2L1JJSEN3dWUzSE4yNlho?=
 =?utf-8?B?SWRGL0ZtbHRROVpNdTlYdm1TdTMyZ09CUXE5Z2I5d1RQMUtsQkpyZDlwdjZF?=
 =?utf-8?B?RS8yakpUT2RHQ3lCN1o1K2lMQzJmQ3dlUHpmOHlyMlRWdFVJdVRZeVp5MzJz?=
 =?utf-8?B?T0NWMWdDb0prSGY1TEg1QS90bUdxRmIrNHhvSzA5WXZaRXdNSnhCV0FzZEV6?=
 =?utf-8?B?cVM1NG9VN3BYdHhaMi9JQ2h0R3FsMDdCd1FYcUlobmZ5UVVnTCtaMlhIM0Rn?=
 =?utf-8?B?cXh5UmlrMVE0eWtmcE5nTDFsNCtSeEV6djBkMTMwUVVXS1prL1VCZjJGVUhn?=
 =?utf-8?B?TUVhSWNBc3VTc054WTlaOGsxQ0hHWC9iclV4emR4WVY0OWJjZjkzbG1aa2Iv?=
 =?utf-8?B?ZS9vZTJBeHNjYXVpTWhTUms3Y1dtZVM2dm82N21qSkpEYlpkRFNIUDFhbGNz?=
 =?utf-8?B?RzBrV3U1am5oaHRmZFZIdHl1Z1NCa2Q4SG9EeWdhQittTDRMZW9aRU56Y21Z?=
 =?utf-8?B?OFA3VHJKZjd4a25hQmRTZlBpK3VCOWExdGdxbTFwRk8vMEFUZ2pBa003bG02?=
 =?utf-8?B?SlVQYVhmNVF3Qk93eGdUU285aUp6UGlZZGZTcGoxenl3REdycGlwOGMwSjZ0?=
 =?utf-8?B?b05oSnI3RFRkQ04xY0REajZZRituV2U1Wm1OZlFSR1NJMWNFV2xjVVcvUmxE?=
 =?utf-8?B?UG1UamY4d04vQTZiSFNuc25jTG9sVDFqYVUxUFIrcUR5TUY3NFBrV0xzWlJy?=
 =?utf-8?B?L050OE5mc3p3UFBmTEZJVk1yYTR2d1RKeUdhemt0aFlpdXpPaitib2NlVi9h?=
 =?utf-8?B?THd3YWF3enZUQ2x6MExINWVJSVIzT2dYYml6c3lKVXRJcGgyYVBiTjZheXFr?=
 =?utf-8?B?Z3RJWndRZVB2WkdJZUJXVVZtMGZnaHJxS3VaUXk4VEhibnp3alkwSCtnZzhY?=
 =?utf-8?B?a3BQZU1KblZSb3gweG95U3MreURHOHBvVENEdVBhWnVUcGVuQ3ZXQTdvL2hJ?=
 =?utf-8?B?MnZQRlRIMjZzeHJwV05DL2JiQ0JVMXV6cjhkbGhTWEVPajg5dngyMFBjN1dE?=
 =?utf-8?B?bW03OHVxNklWd3hFOUxXVzZlcTcvaDQ2Y3lqWVZZWW5VR0RNZ0JLaDliOUhT?=
 =?utf-8?B?cVBIZTdBN0hyRkVTMkpGcHJIR2ZqZFlCR3E4cGs1bW9QOWJWTmx6TEZrWWEy?=
 =?utf-8?B?M2ZyK1JwaGwwRGFyeWdhRlhXZG1rcGtqdmR4cFVFRjZhUkw4bnIvTGExUk9I?=
 =?utf-8?B?SFlaMEtqQittL1ZhdFgwbmtyN0hTbXdtTW5iczA2SjdWTStSMWFtS2ZuNzR3?=
 =?utf-8?B?OWgxb3hxVnhoaXllVG9Nd2tZbi8rNzVvV0tHVnFoMThkUE91ZWdQbk9hT0lw?=
 =?utf-8?B?TDJCVTJ5Vm9kMFU4MDEwN2lncGxJdEF3VVY1UnZJMjJSYlVsNFovT0c0SzJk?=
 =?utf-8?B?TjB5dTdqdDRnRE55cWFXNXJTRWd3Sy9hN0djOGxSRzRhaEV1Tnh4WGJmSzhB?=
 =?utf-8?B?UldWYTJSRmV1YWlZZHNhOWovaGFibHYzSXVoSzRwRFpqVjlqRXlFM0p6eDJV?=
 =?utf-8?B?Nk8rOCtUUDJlNHNhMkREZm91L0Q5YVdqUWtyU2V0ZHphTzBTem5jeUF2WVJP?=
 =?utf-8?B?Vmh0NWExZTBwdXpvdWxCelVaOWpMSlpnUUFyd0t1c1Fxb010QTV0WDM0c0ky?=
 =?utf-8?B?STcrZDdFeFFBd05Pd2hEOE9KN1BPbGVHZUJEWkFsYTFyK3hXNHhBUzBMQ1Yy?=
 =?utf-8?B?bDlicldQb08yTCtReHo1b0FSNWo5ZW9ob29rMUluOHNCSlUyZFNleWd2aTBw?=
 =?utf-8?B?c3I2MGc3MjhwcFdDcnhsSG1TVHRZUHZpV2xZdVJQM2RXUjE2bHdFS2dZaUpq?=
 =?utf-8?B?dUtCb0xKOUhYdGJJMVNKVVhpOGY2RW5GbVVjTGpuU3RFR2RpMU0xQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: gc08MIJSnyqTlbBoVV7iY+3n9sDBqThPwNTIajtr9g+ODdqYVKyplS4KEEv+hee7dXcG9fBDDvj2hS84jIa5yopY6GBOOB6/EbjDQ1/Pgcgy6PZPjUb8s1fIbD0+I1le0FxiX296f1PZ+Yv4C+ZB4uP0DulplJY/NgdrShXxglqEm9VWA1jeYltjd7OLHqWhny6LSmg44yhISOOXg7xocUoHjgP3ep2GwJUY+7xRvls1YPp3VTTP1sw+fSl4S6xVp9qoSz1XeTVuC5T2v2GvZBh94NtouX2kSoDfEHnq7s262G5KDXnEtDa13s/hDTtcB9MdRNnLn1hA2+cjs0ityA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB7349.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787c938d-c694-4f08-b0fb-08df29f4831a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 13:10:25.8198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wnxTdFgyslH+ocd21YAF1tyDumF//7KJirpXcI6dL9HbFOarjVEG99X2JyN1+I9N3X6WBI1GT6LZpa1lulwpBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hh
bm5lc0BzaXBzb2x1dGlvbnMubmV0Pg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTQsIDIw
MjYgNjoyNiBQTQ0KPiBUbzogR2F1ciwgWW9nZXNoIDx5b2dlc2guZ2F1ckBpbnRlbC5jb20+OyBL
b3JlbmJsaXQsIE1pcmlhbSBSYWNoZWwNCj4gPG1pcmlhbS5yYWNoZWwua29yZW5ibGl0QGludGVs
LmNvbT47IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEdydW1iYWNoLCBFbW1hbnVlbCA8ZW1tYW51ZWwuZ3J1bWJh
Y2hAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGl3bHdpZmktbmV4dF0gd2lmaTog
aXdsd2lmaTogcGNpZTogcmV0dXJuIGEgcmVhbCBlcnJubyBmcm9tDQo+IHJlYWRfY29uZmlnMzIo
KQ0KPiANCj4gT24gV2VkLCAyMDI2LTEwLTE0IGF0IDE4OjEzICswNTMwLCBZb2dlc2ggR2F1ciB3
cm90ZToNCj4gPiBwY2lfcmVhZF9jb25maWdfZHdvcmQoKSBjYW4gYWxzbyByZXR1cm4gYSBwb3Np
dGl2ZSBQQ0lCSU9TXyogZXJyb3INCj4gPiBjb2RlIChlLmcuIFBDSUJJT1NfREVWSUNFX05PVF9G
T1VORCBmb3IgYSBkaXNjb25uZWN0ZWQgZGV2aWNlKSwgYnV0DQo+ID4gaXdsX3RyYW5zX3BjaWVf
cmVhZF9jb25maWczMigpIHBhc3NlcyBpdCB0aHJvdWdoIHVuY2hhbmdlZCBhbmQNCj4gPiBpd2xf
ZHVtcF9pbmlfY29uZmlnX2l0ZXIoKSBvbmx5IGNoZWNrcyBmb3IgcmV0IDwgMC4gVGhlIGVycm9y
IGlzDQo+ID4gbWlzc2VkLCBzbyB0aGUgbG9vcCBrZWVwcyByZWFkaW5nIGFuZCBzdG9yZXMgMHhm
ZmZmZmZmZiBpbiB0aGUgZHVtcC4NCj4gPg0KPiA+IENvbnZlcnQgdGhlIHJldHVybiB2YWx1ZSB3
aXRoIHBjaWJpb3NfZXJyX3RvX2Vycm5vKCkuDQo+ID4NCj4gDQo+IFRoaXMgaXNuJ3QgaW5jb3Jy
ZWN0LCBidXQgaXMgaXQgYSBnb29kIGlkZWE/IEknbSBub3QgY29udmluY2VkLCB3ZSBtaWdodCBz
dGlsbCBnZXQNCj4gc29tZSBvdGhlciBwYXJ0cyBvZiB0aGUgZHVtcCB2cy4ganVzdCBhYm9ydGlu
ZyB0aGUgZW50aXJlIHNlY3Rpb24gYXQgdGhhdA0KPiBwb2ludD8NCj4gDQo+IElPVywgX3doeV8g
YXJlIHlvdSBkb2luZyB0aGlzPyBEbyB5b3UgaGF2ZSBhIHByb2JsZW0gd2l0aCBpdD8gV2hhdCBp
cyB0aGF0DQo+IHByb2JsZW0/IElzIGl0IGp1c3QgYSBzdGF0aWMgY2hlY2tlci9MTE0gY29tcGxh
aW50IHRoYXQgeW91IHdhbnQgdG8gZml4Pw0KDQpObyByZWFsLXdvcmxkIHByb2JsZW0uIEl0IGNh
bWUgb3V0IG9mIExMTS1hc3Npc3RlZCBjb2RlIHJldmlldyB0aGF0IGZsYWdnZWQgdGhlIHBvc2l0
aXZlIFBDSUJJT1NfKiByZXR1cm4gYmVpbmcgbWlzc2VkIGJ5IHRoZSByZXQgPCAwIGNoZWNrOw0K
SSBoYXZlbid0IHNlZW4gaXQgY2F1c2UgYSBmYWlsdXJlLg0KDQpZZXMgY3VycmVudCBiZWhhdmlv
dXIgaXMgdGhlIGJldHRlciBvbmUgZm9yIGEgZHVtcDogYSBmYWlsZWQgcmFuZ2UgbWFrZXMgaXds
X2R1bXBfaW5pX21lbSgpIGRyb3AgdGhlIHdob2xlIHJlZ2lvbiwgd2hlcmVhcyB0b2RheSBhIG1p
c2FsaWduZWQgb2Zmc2V0IGp1c3QgcmVjb3JkcyAweGZmZmZmZmZmIGZvciB0aGF0IHdvcmQgYW5k
IHRoZSByZXN0IG9mIHRoZSByZWdpb24gaXMgc3RpbGwgY29sbGVjdGVkLiBGb3IgYSBkaXNjb25u
ZWN0ZWQgZGV2aWNlIGV2ZXJ5IHJlYWQgcmV0dXJucyBhbGwtb25lcyBlaXRoZXIgd2F5Lg0KDQpQ
bGVhc2UgZHJvcCB0aGlzIG9uZS4gVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQpZb2dlc2gNCj4g
DQo+IGpvaGFubmVzDQo=
