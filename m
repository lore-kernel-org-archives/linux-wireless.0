Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB331448392
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791117615; cv=fail; b=c1CkaeSoRYKMmAT+fbHy0pN2zJu8u3HsQNNtEirWgXXahdIJOh9xdYUZBlbxgJXzEf0cQ86LBtVhuDCXICmC2byzn0OyYUBYaQ99F9G35iNfo0Kfp13MvL1pt4dp7CvSbz6l4iV2iq48yui01Sw/lHiu0gYbXaPY7+YN0xLMHDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791117615; c=relaxed/simple;
	bh=ZlGZa2EoinZbTP/3V5mWA5HH8DDDTiK+OBvv3EQ/1Hc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XvVRNyg2HuwI/LH3pE8jAa3M3EYboK6Yn9+7sG+4a674Nh3l3gM0az++W2n0s5pXUmlE1NCTjJHI7Ll6/fwUkDk3dbZdSIqWHVD7mST2KSyHyWYw9qI31ETtaQ/5A89M0rQggMtQz2w3am02t2qLf7FcRa3B5qK4Mq6pZwK1sTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WWH7slE9; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WWH7slE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791117613; x=1822653613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZlGZa2EoinZbTP/3V5mWA5HH8DDDTiK+OBvv3EQ/1Hc=;
  b=WWH7slE9FAyE9NjQgAfjKbpuLiVUiWCUuP6FAMn9IHA1OofaFQIhakMA
   W1Kk9EfgpLEHfw+TY0JjqxUtYxpmVy8oKY98tf3oaTiUi9HG6AD+1/zZz
   wBh1jY5qq3oryM8qVnXja0JknDIAf+HsEkyPVWPbM/S67VfBDFp5m6+AC
   0f8EdEUxJxl1BZmYo3u8G478LUQLVU3Poe53g48HeycRLVIQDVCxS5yDp
   9hmyEiT0dXhTwpX4Kzq+Hxy6yRp6mG3vDQwv93boWVVtKa/mKO75FHuAB
   aj7Fg7KZfZ5ncCyAEkZHOL7ws8f7OCoA+UdTd5dd4KGCk77Ro+0lc87uA
   Q==;
X-CSE-ConnectionGUID: 7zqJP0xgRPeLTF/SJY2XeA==
X-CSE-MsgGUID: ui6GcwUPRsijZyYQqlcF1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="91019595"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="91019595"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 05:40:13 -0700
X-CSE-ConnectionGUID: JXRnfLNHTl6uyJ/QSLqqAg==
X-CSE-MsgGUID: LqtaS568SgKfKs4GjWlKiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="602784"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 05:40:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 05:40:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Sun, 4 Oct 2026 05:40:12 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 05:40:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zWwQhVy/eyRSAX6P7AOUIEVvzvc19Bd0sytE6vYuUPaMq/mJJSg0gGi3rNmT4pGewkRR6sngjRcH4C7Ed7eGYtGig/44IiJKWTNhVyaPKEO1PKi/SVlt3WLU2bFQvQnLJBNrS3HVuClOzHdhz0JaqrR/cdj1fYyjoI9ph6RGyMSI4U4XA/w8bRRu+/Y9vRAUIjKFMYo9XdNDdZDla5Uo+zxUq784xWjIuyWOTZ+b7HPBXN+VnEL6/ETSmIVZCy89WXN0xFAjiSuh2clas5va8RGD0nK1hpWqCU1zN3r2XpHTqKSHe4cBTTpYzHlCZPV9j+aNfrp+bq6ufAvyFhhEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlGZa2EoinZbTP/3V5mWA5HH8DDDTiK+OBvv3EQ/1Hc=;
 b=Yjb83kHmHoy46houkVwM3LSvMU/+M6PVuO8i124lpOQcvJ4DGxwGKTuo/f2+oJhVFi+dAg5QtszSXHeE0y7w5tumyWBWm5sDN8IOWSpgzOYi/S3dYNNy6h9Prt63wAB0TdJMXVsebN0SI4Z/PK+9PjsSKQCkOa2gAWQj+Jg8tfWqdnPYzO6Jsc6dSPiwIjwGpdlGWtpH089WuTBkpFvfiZ8epY3M1TRnmZtqBVZaHG7d0zqsvHRY5aRa9cv04UWzAWDB1hNWyeTqVSZENT1pGajONuB/nLNTNUlRG3hE2d76qHcnsTBp1WwCN4zA58e8MDlBGEW4ocriLT6Ks425Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB9526.namprd11.prod.outlook.com (2603:10b6:806:4c5::19)
 by DS7PR11MB6294.namprd11.prod.outlook.com (2603:10b6:8:96::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Sun, 4 Oct
 2026 12:40:08 +0000
Received: from SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05]) by SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05%5]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 12:40:08 +0000
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>, "Korenblit, Miriam Rachel"
	<miriam.rachel.korenblit@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH wireless-next 4/7] wifi: mac80211: nan: allow Rx
 registration for NAN beacons
Thread-Topic: [PATCH wireless-next 4/7] wifi: mac80211: nan: allow Rx
 registration for NAN beacons
Thread-Index: AQHdUakr9HUaUWc6jEqPtcqAARPElrbp1vMAgAN/VuA=
Date: Sun, 4 Oct 2026 12:40:08 +0000
Message-ID: <SA1PR11MB95268F24EE66D85B4000BB0FE9972@SA1PR11MB9526.namprd11.prod.outlook.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
	 <20261001162941.42c8f2a8e1b2.Ibb92f6652a447acbf47f5b8d654fe34a0fd845e0@changeid>
 <1327040865acb1ef04142b28b7aa6c878c692123.camel@sipsolutions.net>
In-Reply-To: <1327040865acb1ef04142b28b7aa6c878c692123.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB9526:EE_|DS7PR11MB6294:EE_
x-ms-office365-filtering-correlation-id: 454ce8ed-eab2-46db-ba75-08df22149fda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: KWgmYiUJ8Xy2ZXWDNwZwrJHrYVfOPDOQKyHyW7sQUHgt+NorOY8o8KodFAYBr1U9paoH+AsgASFKQGOyKMhzg5gR6ClKN6OYh9eccO5YlARYyvhtTce7hhMHxBN2DfsVyl8F5D22O9Ec1g/EBo7RvNlmuyk/HEUmYew4XVT24cVmvyzuodpOa5nfZndaFt9ZXSXhUTghhfKQKRwFus2aFWW2bPuV+9dVVB1AKOPE8FwwZcTWgYRwtTMn9enXA91bfEc4MRfP7txmjQG2fWVG/oBl+a36+7Kjiqi6je3XAUC1oezqMCIddP0mIBCygMh2RZMLEnwU6LsHDQ9l6IbdKR2h3Sp4Fr4ltvdYWtKIzQn58IZ5ZbdfBjCufHZtM3zS1FeQA56Cc3nwgZwTGTNEyCrc6evOOlXwp2p/qnJTF6L+aWyv7C/i/c6AUF2OTbYo6jyLKm/EhgVkOjIHmTnv/f/E3qa0UUGSAu/KGSh/7coMTT7678JXNkRBoMWkhEisiJYpP5SSV7hLwJjvV78DNozJZfbFBUrDfjaK1YncL/ySd+RH3aVPz8ZhdDUPT/CrLpnf1H2swofUc5cqb2oFO3P0MRF0AGyP+CWEDX61x2FdQST8SYjMCsf0aValbE404y1ofsNQgLvDGATGzeunlHbpvkfI4/SalfS3DAOjGNGQc5n7e2cew4pzQNFlto4oo2l5jlqwq0J9lrNqAhzxjGcZfoGKED2WT/90XL8JOns=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB9526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUZ6L2REdkxQcllVdTBJNS85elZoQWJIMzVDS2liVHJXV0JPdlNTUVlab0ZQ?=
 =?utf-8?B?L3lxTFpUWVk3cGpISjZhdytHNStnTmhDU2l1RHdQQ1lBNThnT1ZPUTZ4NDlW?=
 =?utf-8?B?Y2h0dXRFL2tsekNwdmJTWitsQk05TCsvNFM2Q1NOcUtiSVU2V3FPeElPa3N1?=
 =?utf-8?B?VEIvTytoUGloVlJYbnVXVkhMLzVrWU5YbUV5YThUMjdGS0tqUW1RZkRHQ2k3?=
 =?utf-8?B?RFJncURhQ0dvQlgxbDVINlBDcG55T3l4dldXNHZIWW9naER0OVMzd25JOEhS?=
 =?utf-8?B?dkVJS2UyZ2trY2MzSWhheWxQS2szZ05UNVMyNE85TEZEdzJoalhKU05GMUlx?=
 =?utf-8?B?c2dXMjB5UHJIaXpjTm9jUzJxcGhxOHlGRUw1ODBuOXJad1R2ZTlCbXpBNnRZ?=
 =?utf-8?B?MlhsLy8yaHBndFV2RU94RjNlRU9SaGJPM3gwS3YzZitGVng3citwWklROVg5?=
 =?utf-8?B?VHlpZDI5WWs3M24wS09kVGVMenpsS1cwTllGOVJmSkRIR0xDcStPbVZpSjdr?=
 =?utf-8?B?Y2Q3SmFmaXJwNmRzemVabytlaldhQ3NGUWJ1czNZa1AvQlUyME1YR09iNDVJ?=
 =?utf-8?B?aktuQWxHZWJlbjlmeFVPejZjTm9pUWRzZVYzaFNZRWhlMXk2dHllczlkNGJD?=
 =?utf-8?B?aElWRU1mSG5LUlRoelJtYzNCUnpRbld1cDg3b0REdDBrcm81bldScXFwV0VG?=
 =?utf-8?B?ZkVDMkhMOVQ0RzVZMS9ZdXZ0RzQ4dncweHllQnFzOGRJeFBiSEVOYUg3QVJz?=
 =?utf-8?B?K1llSjIybERzSWdCZ3l5ZTV5aFpiYVRtZTdLcG1lWDBLQTc1OERoZWFsQk90?=
 =?utf-8?B?UEU0eW1FL0lhancvaHNxVzExMmNaWkRLSnEwSGNtOEZ6dVhUMDQwK2szZGVF?=
 =?utf-8?B?WHZxSHlHcDI0UTFXWDEyQnhjekxtTmNOVEp3RU0vazRCUGFCZ3V4TXZab2x3?=
 =?utf-8?B?Rk84VHdvSzRtUCsrY05xVUJRZ3RQbE5jdHhEV2wvSnNpM2FNRkNNK21uNnEr?=
 =?utf-8?B?dzdRTjBETnkyRFBTSkRvMUpnc0d2WlVab3pieGE1NXJGN1NIVXJCSktxbXV2?=
 =?utf-8?B?c1czQ2JPSjdTSnRmRHdkUitWRzR3TDY0UExjM1VFODdQYzcrSk9iS0gwY3U2?=
 =?utf-8?B?bzc3WlBrN0hxMm5peWJ1RGJBZjhuZjBpQjQwSFpDcUxhNnRDd0J4R0drZUQ1?=
 =?utf-8?B?Z200dTdrQ085OVhPWHVlU1prTzNCQ1QrZEViNTFCNExENlZudTVrbFl1VEJZ?=
 =?utf-8?B?bEdsY2FLOW1wOENFcURQamNHK2lhVUtLVkN5T016RzM2ejdTUjNFSlp2ZjdN?=
 =?utf-8?B?dVVzZkxPQ2EybGRScXFYMFhjMVFMdUZ2TzZiaW1uVnRjNy9UVmFEQUJOQ0hs?=
 =?utf-8?B?L2x0aDV6T3JROHFNcnFORktGM3NuQzlxb0Vac2dxbmZwcUttOHFvV0Vod3hy?=
 =?utf-8?B?UjgzazdlWEVObDk0a3FIZ0IvT3ZYaVJlVzZ3Nzlpd1hJRjJPTnJ6RUZlMUZZ?=
 =?utf-8?B?a2hpU1lQK1JyRks1Q1R0R2tDYTk0OFg3ZmJOcmR4Z0tLN0ZvU2NQMDB4RWdL?=
 =?utf-8?B?RDFUSzhsb0p5S0NYYjBJMDhnVEFYNi9IM1MxQjA2cklNYmJZaEY5dGN2Yjlp?=
 =?utf-8?B?YlU1U2JyMjFSd1NEUkRNWHRIS0pUSFhsZGNnOWRncVBORFdzNTZyZnVKWXlK?=
 =?utf-8?B?L05ta3VYRDI3NW1VV2E5RFRVS1NPUFd5bW1BTEhFNHBRdHlvV0d4c0ZtYXg3?=
 =?utf-8?B?cFE3NWhjTVNiWjZQRUpqSHcxak1IdTYwNFVNWXhIU3NsRXNSWVFPOG5Ua1hv?=
 =?utf-8?B?WWpsQUNvSDBoWXlxeHc5VnpCWVJERTBVYVJEMjdtWXZoaVkxaE80Q0dMd3JY?=
 =?utf-8?B?ZnNPVVFQelFZQlVtQ0Z5SzJIWEk3WS8yUzE3b0RmK1NrVlVqVTdtY1dZRnpJ?=
 =?utf-8?B?SkhuRzhmdDJCWUM4c016M3JoWWIrN1Njc08yeWl1aEE1RkVXTThPcFp0Zlh5?=
 =?utf-8?B?b2w2TE14VGZ4N1NJN04xQkFhUDE5d0ZTZVdZUUZwTU9TYWROMXNPOWU2ZE41?=
 =?utf-8?B?UGU4M2tVUmJ3U2Y0R3EwT0hVbWJFaGtmclVPM0p5SnR2VnJOM3FVRGZoZTNN?=
 =?utf-8?B?K3FlYlRNNEk4SmpoV3FsZkFvdGV3MElKQXIzbjA0S3llY01RR2t0YTlNZ2p6?=
 =?utf-8?B?dTVxUkhOQ3lySEFmaEpZK3lRNWpCWnFSTU9rWHJzbU84VndIYVEwYm1hdGFl?=
 =?utf-8?B?RkRLeWY1ZVNIY3JEU0JJWC94Zm4wOWMvcExpczZqSUozcGZqWGtaSXhzVTAy?=
 =?utf-8?Q?pIxdrIDGLjOpIC9+e+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: aclHg5FXWb2hPRLig1XGJ1aNy4+h/+z+lkTynBVQiydIKyU//8xnQcodgg9JvSq+85jSJRqm1hAhsB9IPG8pvHMrDmY0XWd2ftLXsYXlY2fhkK6SemfizqXWCOL9h8GdQrfwGWRS2W/Zh8jjeV0CBgyaNUwxBdRUtSR99N5ShoMLCoPSAkY6xJPgHZvI+5sknz/iRpmIwEQm6EEgQyX2Ctj075GVbB7jh9AXjZioIhj+NkNiz3w9j3TWdKzi5LlZhCen6hXa9wa+phExq6VhG19BQ8CH5an0LckYu9IvgecCgHTTRut2ael3fgPTaSqP2QVtMRCtXOq9fm2EPrlO8A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB9526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454ce8ed-eab2-46db-ba75-08df22149fda
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2026 12:40:08.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nlgk7b9leAlmPpDcbGenhQQrK3u7PzGzlHX7ZhCrOfhMvykLo2B11dT/uxCDhKjs23+HZvjIaFdtWevlRXkkOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6294
X-OriginatorOrg: intel.com

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVy
ZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDIs
IDIwMjYgMTA6MTEgQU0NCj4gVG86IEtvcmVuYmxpdCwgTWlyaWFtIFJhY2hlbCA8bWlyaWFtLnJh
Y2hlbC5rb3JlbmJsaXRAaW50ZWwuY29tPg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnOyBQZWVyLCBJbGFuIDxpbGFuLnBlZXJAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIHdpcmVsZXNzLW5leHQgNC83XSB3aWZpOiBtYWM4MDIxMTogbmFuOiBhbGxvdyBSeA0K
PiByZWdpc3RyYXRpb24gZm9yIE5BTiBiZWFjb25zDQo+IA0KPiBPbiBUaHUsIDIwMjYtMTAtMDEg
YXQgMTY6MzMgKzAzMDAsIE1pcmkgS29yZW5ibGl0IHdyb3RlOg0KPiA+IEZyb206IElsYW4gUGVl
ciA8aWxhbi5wZWVyQGludGVsLmNvbT4NCj4gPg0KPiA+IEluc3RhbnQgQ29tbXVuaWNhdGlvbiBy
ZXF1aXJlcyB1c2VyIHNwYWNlIHRvIHRyYWNrIHRoZSBOQU4gYmVhY29ucywgc28NCj4gPiBsZXQg
aXQgcmVnaXN0ZXIgZm9yIFJ4IG9mIGJlYWNvbnMgb24gYSBOQU4gaW50ZXJmYWNlLiBBZGQgc3Vw
cG9ydCBmb3INCj4gPiBwYXNzaW5nIGJlYWNvbiBvbiBOQU4gRGV2aWNlIGludGVyZmFjZSB3aGVu
IGluc3RhbnQgY29tbXVuaWNhdGlvbiBpcw0KPiA+IGVuYWJsZWQuDQo+ID4NCj4gPiBBZGQgYSBo
ZWxwZXIgZnVuY3Rpb24gdG8gaWRlbnRpZnkgTkFOIGJlYWNvbnMsIGJhc2VkIG9uIHRoZSBCU1NJ
RCBhbmQNCj4gPiB0aGUgYmVhY29uIGZyYW1lIGNvbnRlbnQuIFNraXAgTkFOIGJlYWNvbnMgc28g
dGhleSB3b3VsZCBub3QgYmUgdXNlZA0KPiA+IHRvIHVwZGF0ZSB0aGUgQlNTIHRhYmxlLg0KPiAN
Cj4gVGhpcyBkb2VzIHR3byB0aGluZ3MsIHBsZWFzZSBzcGxpdCBpdC4NCj4NCg0KU3VyZS4NCiAN
Cj4gDQo+ID4gKysrIGIvbmV0L21hYzgwMjExL3J4LmMNCj4gPiBAQCAtNDUzNiw3ICs0NTM2LDEw
IEBAIHN0YXRpYyBib29sIGllZWU4MDIxMV9hY2NlcHRfZnJhbWUoc3RydWN0DQo+IGllZWU4MDIx
MV9yeF9kYXRhICpyeCkNCj4gPiAgCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAodm9pZCAq
KXNrYi0+ZGF0YTsNCj4gPiAgCXN0cnVjdCBpZWVlODAyMTFfcnhfc3RhdHVzICpzdGF0dXMgPSBJ
RUVFODAyMTFfU0tCX1JYQ0Ioc2tiKTsNCj4gPiAgCXU4ICpic3NpZCA9IGllZWU4MDIxMV9nZXRf
YnNzaWQoaGRyLCBza2ItPmxlbiwgc2RhdGEtPnZpZi50eXBlKTsNCj4gPiArCWJvb2wgbmFuX2Jl
YWNvbiA9IGllZWU4MDIxMV9pc19uYW5fYmVhY29uKChzdHJ1Y3QNCj4gaWVlZTgwMjExX21nbXQg
KiloZHIsDQo+ID4gKwkJCQkJCSAgc2tiLT5sZW4pOw0KPiANCj4gRG9pbmcgdGhhdCBmYWlybHkg
bG9uZyBpbmxpbmUgaGVyZSBmb3IgZXZlcnkgc2luZ2xlIGZyYW1lIHNlZW1zIGxpa2UgYSBiYWQN
Cj4gaWRlYS4gSXQncyBhbHNvIHJlYWxseSBub3QgbmVjZXNzYXJ5IGF0IHRoaXMgc3BvdCwgd2Ug
YWNjZXB0IGp1c3QgYWJvdXQgZXZlcnkNCj4gYmVhY29uIGZyYW1lIGhlcmUgYW5kIHRvZGF5IGV2
ZW4gZXZlcnkgTkFOIGJlYWNvbiBpZiBpdCBidWJibGVzIHVwLiBBbHNvLA0KPiBCU1NJRCBmaWx0
ZXIgd2lsbCByZWplY3QgaXQgYW55d2F5IGluIG1vc3QgY2FzZXMsIHNvIGlzIGl0IGV2ZW4gbmVl
ZGVkIGF0IGFsbD8NCj4gDQo+IFdlIGNhbiBhbHdheXMgYmUgYXR0YWNrZWQgaW4gc29tZSB3YXkg
d2l0aCB0aGlzLCBzbyB0aGF0J3Mgbm90IGFuIGV4Y3VzZQ0KPiBlaXRoZXIsIGNvdWxkIGV2ZW4g
dHJpdmlhbGx5IGp1c3QgcHV0IGEgbm9uLXZlbmRvci1lbGVtZW50IGludG8gd2hhdA0KPiBvdGhl
cndpc2UgbG9va3MgbGlrZSBhIE5BTiBiZWFjb24gYW5kIHRoZW4gaXQnZCBiZSByZWplY3RlZCBi
eQ0KPiAiaXNfbmFuX2JlYWNvbigpIiBidXQgcGFyc2UgZXhhY3RseSB0aGUgc2FtZSB3YXkgYXMg
b25lLg0KPiANCg0KSSd2ZSBtb3ZlZCB0aGUgY2hlY2sgdG8gYmUgTkFOIERldmljZSBzcGVjaWZp
YywgY29uZGl0aW9uZWQgb24gSUMgYmVpbmcNCmVuYWJsZWQsIHNvIHRoYXQgYmVhY29uIGZyYW1l
cyB3b27igJl0IGJlIGZvcndhcmRlZCB0byB1c2VyIHNwYWNlIHdoZW4NCm5vdCBuZWVkZWQgKGFz
IGN1cnJlbnRseSB0aGVyZSBpcyBub3Qgd2F5IHRvIHJlbW92ZSBSeCBtZ210LiBmcmFtZQ0KcmVn
aXN0cmF0aW9ucykuDQoNCj4gPiAtLS0gYS9uZXQvbWFjODAyMTEvc2Nhbi5jDQo+ID4gKysrIGIv
bmV0L21hYzgwMjExL3NjYW4uYw0KPiA+IEBAIC0zNTMsNiArMzUzLDEwIEBAIHZvaWQgaWVlZTgw
MjExX3NjYW5fcngoc3RydWN0IGllZWU4MDIxMV9sb2NhbA0KPiAqbG9jYWwsIHN0cnVjdCBza19i
dWZmICpza2IpDQo+ID4gIAkJaWYgKCFpZWVlODAyMTFfaXNfczFnX2JlYWNvbihtZ210LT5mcmFt
ZV9jb250cm9sKSAmJg0KPiA+ICAJCSAgICAhaXNfYnJvYWRjYXN0X2V0aGVyX2FkZHIobWdtdC0+
ZGEpKQ0KPiA+ICAJCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJCS8qIE5BTiBiZWFjb25zIGFyZSBu
b3QgYSBCU1MsIGRvbid0IGFkZCB0byB0aGUgQlNTIHRhYmxlICovDQo+ID4gKwkJaWYgKGllZWU4
MDIxMV9pc19uYW5fYmVhY29uKG1nbXQsIHNrYi0+bGVuKSkNCj4gPiArCQkJcmV0dXJuOw0KPiAN
Cj4gSWYgdGhhdCdzIHN1Y2ggYSBoYXJkIGdlbmVyYWwgcnVsZSwgd2h5IGluIG1hYzgwMjExPw0K
PiANCg0KTW92ZWQgdGhpcyBjaGVjayB0byBjZmc4MDIxMS4NCg0KUmVnYXJkcywNCg0KSWxhbi4N
Cg==
