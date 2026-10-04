Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9B843C7B9
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791119568; cv=fail; b=UvQzIXe48tD2zSms6VdSBJNw2SDXAyC3KJyiIPqSWPwSPEFrULKr3fAzdrADP4FVL4eI+VMfaG+pDpc1elbFzXvectmLQYpVRyfgtGICwz2G0oV8CJe7z3Vd2vbbqU2wAfDzA7IFgD1lLYB81eaQOq+14ha07sqjZDZTJAY3jBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791119568; c=relaxed/simple;
	bh=/MVgduCQIxkbbb5IV38wJTFqBrO+cfM5hFyEJhdIbEg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pie5IRgQY/KfBBA9b9kKOEe0Swc0u+MRfh6RXVE1FRVZ2zNGrIDVS0UFpD4zpjK2xl+Ms3rcvV1NvXoXL6eOuZGo4DWhqYw0/TIoM0gwVnuqcyfbzVoKfEgpmGVIN8u7JI4sCGrG0YmsU9UlDIEQvH0CzdOScGJg1Hmm63g7j+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BV8lCL6u; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BV8lCL6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791119567; x=1822655567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/MVgduCQIxkbbb5IV38wJTFqBrO+cfM5hFyEJhdIbEg=;
  b=BV8lCL6uEbmhq/VmfM8vOAc+iRxKTO0hSDQUUwotiBnmGeOTyZB455hr
   HVqBYT8gesEAXSn3cPRtbng0QWAkRPe4/xexxeNHezJ6osQpD9pWh6BQ8
   1Dh8+pSwAv5Msg57suhUCQgfu95ec8Ilv2LoFh+0QDG0dqM8JbYkYJBOQ
   lz5RZpeX++4vialZo5P47snMkPKIYJJqCFtDjOwXTjaKVskdzJxN7j7v9
   A10enMLfG2ZOE+JIm5kayCeiK7ouO+hmbWZx6ZzLgO+w0KLhkwPjKlFoN
   Svw8jrJIgYxBrWMAiGA1q8oJ0sEKpNFvXJ9gyx5uJNsn9nh7nabXAN4Q2
   Q==;
X-CSE-ConnectionGUID: lG2hUahRQzOTT6b/5iT1JA==
X-CSE-MsgGUID: TZOXUgQdStCyc+1nGlbnfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="79370412"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="79370412"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:12:46 -0700
X-CSE-ConnectionGUID: 06gpDFhmSl6pvushrNIRZQ==
X-CSE-MsgGUID: LX2ZpeSIQHmF6cbABegwfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="276751772"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:12:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 06:12:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Sun, 4 Oct 2026 06:12:45 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.17)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 06:12:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdGjTumUNCRlRzuC/orgIUivJZA7lw00F1SmZwGhrl0p2bfg9c8P0ovbDz6HrvnzbQkdyHUKtI0+6FXPWpc7qkyVBv5s3wp55D+mP8QV89ZZ0A8jluXnZ3UPMQonygepRrQjNmnBuqSgXuTAlXcKNHa44+d8KeZ/O7TgmkxtbRrYypQFyfmEG+nG3DsDQFzns9LS7gCCP/9BWjxSGZkrwX9YFFh7Qr6FnSLKHsnHasb1Q9YKLBwBWIr7/Gvuj7kKSJ0y7+po9WQUc5UIQgtdNxdSPw4TXPDQdrgtN6LbbO2cYDxbWvL10JM/XSEq6dTi3SR+xcqJTQD1C9nWIl5taw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MVgduCQIxkbbb5IV38wJTFqBrO+cfM5hFyEJhdIbEg=;
 b=j+E7gd/CsxJPf/PXDDARBQdTl1SOpy4WAbbc1cVCP+NJ0iRxU3P+ixcmDK206ZAJmS6qHndfZmXGLSNMlathamdeWefd2OGFDUtP00GyFuOnzHFvqyML50lk9IV2CMFT5vkJ4eu7AYbrl5nKU+mAWOS5Vwv7m4Zqii73z2iEmOwlOTaQMRQF37K7a8ZDyz2H5KdGNICTeMg1+CaykayPN2fHEk0q7i2yittlJg5u1tNt2fJAU1aGB2BAR2kOBY7UVfENutD1T6fl/MSKb68KoNuWKgIeoxeyBR4mVYQUCU4xnPr6Noa9hEi6XQsOqwFF1HHB6j/aGcqMFuWUZzUVww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB9526.namprd11.prod.outlook.com (2603:10b6:806:4c5::19)
 by SN7PR11MB7017.namprd11.prod.outlook.com (2603:10b6:806:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 13:12:43 +0000
Received: from SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05]) by SA1PR11MB9526.namprd11.prod.outlook.com
 ([fe80::2a31:5c3e:2615:9b05%5]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 13:12:43 +0000
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>, "Korenblit, Miriam Rachel"
	<miriam.rachel.korenblit@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Berg,
 Benjamin" <benjamin.berg@intel.com>
Subject: RE: [PATCH wireless-next 7/7] wifi: mac80211_hwsim: add NAN Instant
 Communication support
Thread-Topic: [PATCH wireless-next 7/7] wifi: mac80211_hwsim: add NAN Instant
 Communication support
Thread-Index: AQHdUakuk9wUbIwfnEWEVLKHu3vUCLbp2z4AgAN8n9A=
Date: Sun, 4 Oct 2026 13:12:43 +0000
Message-ID: <SA1PR11MB9526C4B006F585C3962367DFE9972@SA1PR11MB9526.namprd11.prod.outlook.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
	 <20261001162941.7e69a74a7ba5.Ib1a57bccf328a19dc55b914ccab73d023fe0876f@changeid>
 <8f58e34fa9962d3967dfa792fa2d724db89e4452.camel@sipsolutions.net>
In-Reply-To: <8f58e34fa9962d3967dfa792fa2d724db89e4452.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB9526:EE_|SN7PR11MB7017:EE_
x-ms-office365-filtering-correlation-id: 43f6b221-9a70-41e1-8a8f-08df22192cc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|22082099003|18002099003|10067099003|38070700021|4143699003|56012099006|11063799006;
x-microsoft-antispam-message-info: XbobQJPLAaZvhY+6QkrQ3Z99lqGtjZW9jnQnbqPVVTt94kT1Lvbyt9V2ddYwQhheqAc1zwe3ru/tyvcfFzOe8Gsx79cSmmF0gSVU4epa+q2JJv8tdm10GJRd1IVowakeUR2toaBpkAGt9KeqJzuU7TalDRhp8NL3a4TOOLC1ORcwcSYXtTDCDcdEWLgLFQrp7eUsdYTgpsX+8Fv9mP/pTQ1HJudpD9tpYCCkUxM1R5XOTwqRXpovAj/44gidawwQ/KpsFX32erNKF3pZvDZy+VCpKlnTssxBFepgSr8CU6qAjZKKJ8/xJmKlXPjGNrOJxjyDfgWkq1v0pGP6iH9QkvuQrP916/u1sVt44cjN9Y1XNfsflnfsjoE7crk9aPn8Yw9kQk3vok7elnE8O75jJNZ/VijiTfpq8n6zOnwnSNdy2HUV1Yz62wI+ME/3m21p4uvsOdsdhG7u3cszsbL7AsYAwE4PHBUYVRdpKwm54xHPnWGy4yjs9l0Bj48X8pnrbagG9HcCWQselDlxeyh3WzIEVEgD9jqWyXgrPuXHOSVJ1xSmqiyr+0lzemY7cu/1M26VeX66truPF2Jr3UxZYY6x81aBpYQ0NmPAs2GV+XPEr1r6cTSWxR0BW17cn/+nB8MqoxNittIzQTS2HVsJyK3pFfIoGgxkpjg42w0sSN8nuBhJHDe80q/ptPTABsVwiYhMqP8UeFr4pwJw2m41F5Dc98YFkd9hBuqEPa1kNtM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB9526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(10067099003)(38070700021)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0diRjdXQ1g0Sm9VNXJ0TVdGYkNqZG5ZZnJoUE5GZ29YdndPSXdUS2JVL3Ax?=
 =?utf-8?B?bjFXQkVrSUhuMFdNVXRSUXhXUlNWMlcweXIySVM3UTU3OXFYc2RhajZaZ3Jr?=
 =?utf-8?B?bjZtWVdhYU5aRUIwUllsd3llOWFnR2tnSFZ6UFNFR3dlUGRPQlRRMTIyaGMz?=
 =?utf-8?B?ekRDSllqL1ROWkhXT0NXWmhQRkVnaHdJL0JDVEhKUy9pV1JaMXpMSEgzeDMz?=
 =?utf-8?B?SmFYaG1Bb0dnWGttT2s4Q2FqY0RFK3dsRUpydmdCSUVGU2h1cHVXbmRobXp5?=
 =?utf-8?B?bUxXVFBQQkgxWFNKR2M4NGxQYlhkb2tnbzh5eHhWeVlGcFpHYVhGZVBCSlV2?=
 =?utf-8?B?VWtkUEJQWWdGcy9CVWhMTmpEblEyVFZLMW9KbjU5YmZLM1NiRWViekx4djZm?=
 =?utf-8?B?QU4vV05OT2xYbTNhTkNqR3Q3ZUhpYjZMTGFUU3UvVUlKNHZCTm85UUg1Y2o3?=
 =?utf-8?B?REo2TkJERzdSMVR5WU5LTkR2VFIwRlpsakxlYStQMDFUcFBNNittNm13Z0NO?=
 =?utf-8?B?elkzV2dmeFJMdHpSd0dRRElWV1kvZ1NUam5lb1F0ajNJaXAzd2N0SE9sb0lB?=
 =?utf-8?B?TTdWZnN0TkRlcjBCOFlYK2kxQWYwT0ltMGdmZ2JaUzBKY2R5L3N0Q2VVUiti?=
 =?utf-8?B?ekJ3d2c5SjkyYkljY2ttQU5WclRlOUMxM0FZdU5FTno5Zk1WK25Ib0FzWGxo?=
 =?utf-8?B?WkVLU1RmQkZTVElTZ1QzdGlZd05qM1dmMDNhZnFReTIwcUd0cHlqUUZmTUUw?=
 =?utf-8?B?RGFlOHl3YmR1eUtZS0pUc3Ivb01zaFArL29MNzNDWGFjazhUb2FZM3ZUUWNM?=
 =?utf-8?B?T0V5TWRYSUhjb0xzNzRndjBvUU4wdDRVVjV1azBUZVVMR0JsZll0QTBIZFFB?=
 =?utf-8?B?THdSS3RSRHUrUjBBRFNTdG5xKzlIRnpxS0JGeDgwOWxkUEtHUEY4aXVHVS83?=
 =?utf-8?B?Y0s2aFdleWJ6a3JhdHd6d0RBSFF2Qk0xbnNlN2E4WWdRVDZRTlVDeFVyVXk2?=
 =?utf-8?B?OHVCUVdZd1hWTVMyM2I2Y2NPbFZ2UTVnaEVCNVBEbmJoRjdTL29kSVkyYVR4?=
 =?utf-8?B?VXBOQW1Fc0szQkRHc3lYM0FkcHhEUDVyc1NZS2crWWxESE1kNjdOWVVwMUFQ?=
 =?utf-8?B?SFUwM3pRRTJRR3pqVXFDK0RKeXJsdVZEVXl3V1pZMXJuYTN5dUtmSFRzLytW?=
 =?utf-8?B?aTRXU01oc2dYSlRSY1ZKTGQ5allzeFZUVG9kTnBOZ1paQzRGUDg3QkFIa1li?=
 =?utf-8?B?V0pCNkU3d0NMYVVHTVkxZ1dKL05pdjY4TVJJUmJYbkhIeXNpZXJIV25najA4?=
 =?utf-8?B?LzhpanlHYjNqZjRLL2NSMVVtL1dpeHE1OTV6TUVlSUY2TU9OTVc4aGNCOEM3?=
 =?utf-8?B?T0lZU1JsTjVGMGxNamEvMkQ3aUdJeUVOMjNXLzV2dzRsTFlUSExFa2F0K3Rt?=
 =?utf-8?B?czYvSTQrZC9qUGFxWVF0dEp1bHhUKzRNRDNGdXBMemtjTk93TFNzS3crMUxE?=
 =?utf-8?B?NzRCS3lMMXY3eEJqVDlwcDJFUUV1a1JvNXNCRG1KYWF6UUpSUWIwbkVQYjNI?=
 =?utf-8?B?ckFySHhMTXZCK2RiUGlKMmdQQXJyeVpsNjZiYWEzM3Y4VzlsTU5BWkgvWFA0?=
 =?utf-8?B?RlVOeEVxdzF1dStZMFE0NUJSWHFnWlpvYTFncG9nMUJzczY3YXM1QlpCY0xr?=
 =?utf-8?B?akpsaDR0S1oxd1RkbHFDbkJmSzJVMEZXRkhwRUtSVkpXWktGbW5mRjBqWk5K?=
 =?utf-8?B?Vm9sZkVMR0o4UUFKR0hEOU90Tjd2Q2ZOTUt5bUVOcUd4MWdZVmFMZFNZWWFK?=
 =?utf-8?B?ZXhtbytTOWFwZ2tTZlYrOHFBa21qQVF2ckhrZlQ5QTgzdkkzVjgrTHdvWkZm?=
 =?utf-8?B?OXZQTVM2K1YwTEk2ZkVLNitMZlZTOVMrSVJ6Y0xMcWs2LzJveFNXamd6dkhm?=
 =?utf-8?B?MlhvaVZJeGhkNTZubk9IZEwvSmV6UmE3RUxyMVBIQjhkcUFmZURlZEVtVzJI?=
 =?utf-8?B?SFdjblZ2UGo4Z2FybVphSnp1ekZSeXJ1cnYrWVZuV2JYcG1hTG1qQ0ZvSjZB?=
 =?utf-8?B?ZjFlZENqaWJiSTQrMW5LZ3ZyRDI1eW1PS21jTm9oa3dmbXhPTnNlcUQybjNw?=
 =?utf-8?B?ZHloOGdreUYyS09uMWwxY1BkTHNETHhPaDRxRWFNTHFwU1g0RG1DK2w4eVZM?=
 =?utf-8?B?d3Q1cFA3YlFCSk8vNmNha2xvRTdVVFZUYUZaaFg5MGg3L25CUit1THRhR1ZJ?=
 =?utf-8?B?Y0JSS1c5dXJOY1RUSjVCQm44cDB4enk0OWVxa3ZrZWRETm1jMC82RTVwMi9p?=
 =?utf-8?Q?t1CI9mlZYjo6v7Z2PV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: cKvEx6RPmIzIfZD+LmP5HkIyShAvwmD4CaaDtQU1G0wbolQxqSmcoCqoen5iHZ5eaM3tCJ+YDGI0R+69D0Pe6bAPSwniUsjTY5kzGjbsn6lKz/AjY8+K4FtUYKUtc0/YhNv6hWDZbDHWRTMlBXG8nP7yLD203mUVrtqLLfMU3nEvolerE8E/ssDqVtvK8f/nzAkKxTF8SSo1HbqUhQuMwKhsXOU/cx6KyACrBlD7kb0JGSpA3onK9x1dzq+RtqAcMJUsZ8JbBmRzjL0AFkqNhthIK8i7eJPEXmmLEkvXMUvGVHeePbvdwgpPDn8B9Cu7J+lks1+2HxYrbyAGGcb4jQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB9526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f6b221-9a70-41e1-8a8f-08df22192cc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2026 13:12:43.0766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOkI6nrmIgRKmjfFZr1kEJaIN94APWp5d8ULyQgnA26tw0OagyqXelp2WhDh2sEh2B7owk4LG6HbuQph5Sj5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7017
X-OriginatorOrg: intel.com

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVy
ZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDIs
IDIwMjYgMTA6MjYgQU0NCj4gVG86IEtvcmVuYmxpdCwgTWlyaWFtIFJhY2hlbCA8bWlyaWFtLnJh
Y2hlbC5rb3JlbmJsaXRAaW50ZWwuY29tPg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnOyBQZWVyLCBJbGFuIDxpbGFuLnBlZXJAaW50ZWwuY29tPjsgQmVyZywNCj4gQmVuamFt
aW4gPGJlbmphbWluLmJlcmdAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHdpcmVs
ZXNzLW5leHQgNy83XSB3aWZpOiBtYWM4MDIxMV9od3NpbTogYWRkIE5BTg0KPiBJbnN0YW50IENv
bW11bmljYXRpb24gc3VwcG9ydA0KPiANCj4gT24gVGh1LCAyMDI2LTEwLTAxIGF0IDE2OjMzICsw
MzAwLCBNaXJpIEtvcmVuYmxpdCB3cm90ZToNCj4gDQo+ID4gQEAgLTI2MywxNSArMzAwLDI2IEBA
IHZvaWQgbWFjODAyMTFfaHdzaW1fbmFuX3J4KHN0cnVjdA0KPiBpZWVlODAyMTFfaHcgKmh3LA0K
PiA+ICAJCXNsb3QgPSBod3NpbV9uYW5fc2xvdF9mcm9tX3RzZihyeF9zdGF0dXMubWFjdGltZSk7
DQo+ID4gIAl9DQo+ID4NCj4gPiArCS8qIChvdmVybHkpIHNpbXBsaWZ5IHRoaW5ncywgb25seSB0
cmFjayAyLjQgR0h6IGhlcmUgKi8NCj4gPiArCWlmIChyeF9zdGF0dXMuZnJlcSAhPSAyNDM3KQ0K
PiA+ICsJCXJldHVybjsNCj4gDQo+IGNvbW1lbnRzIHNob3VsZCBnZW5lcmFsbHkgaGVscCAuLi4g
SSBzZWUgaXQgcmVtb3ZlZCBiZWxvdyBidXQgbWF5YmUgbWFrZQ0KPiBpdCBiZXR0ZXIgd2hpbGUg
dG91Y2hpbmcgaXQgOikNCj4gDQoNCkknbGwgdHJ5IPCfmIoNCg0KPiA+ICsJc2NvcGVkX2d1YXJk
KHNwaW5sb2NrX2JoLCAmZGF0YS0+bmFuLnN0YXRlX2xvY2spIHsNCj4gPiArCQkvKg0KPiA+ICsJ
CSAqIEZhbGwgYmFjayB0byB0aGUgZGV2aWNlIGRlZmF1bHQgaWYgdXNlciBzcGFjZSBkaWQgbm90
DQo+ID4gKwkJICogY29uZmlndXJlIGl0DQo+ID4gKwkJICovDQo+ID4gKwkJZGF0YS0+bmFuLmRp
c2NvdmVyeV9iZWFjb25faW50ZXJ2YWwgPQ0KPiA+ICsJCQljb25mLT5kaXNjb3ZlcnlfYmVhY29u
X2ludGVydmFsID8gOiAxMDA7DQo+IA0KPiBUaGF0IHNlZW1zIGxpa2UgdGhlIHRvdGFsbHkgd3Jv
bmcgcGxhY2UgLSBzaG91bGQgcHJvYmFibHkgbWFrZSB0aGF0IGRlZmF1bHQNCj4gaW4gY2ZnODAy
MTE/IE9yIGlzIHRoZXJlIGEgcmVhc29uIHRvIGJlbGlldmUgaXQgd291bGQgbmVlZCB0byBiZSBk
ZXZpY2UtDQo+IHNwZWNpZmljPw0KPiANCg0KSWYgbm90IGNvbmZpZ3VyZWQgYnkgdXNlciBzcGFj
ZSwgaXQgbWFrZXMgc2Vuc2UgdG8gaGF2ZSB0aGlzIGRldmljZSBzcGVjaWZpYywNCnRvIGFsbG93
IHRoZSBkZXZpY2UgbW9yZSBmbGV4aWJpbGl0eSBpbiBtdWx0aS1pbnRlcmZhY2UgYW5kIG11bHRp
LWNoYW5uZWwNCnNjZW5hcmlvcy4NCg0KPiA+IC0JZGF0YS0+bmFuLm5vdGlmeV9kdyA9IGNvbmYt
PmVuYWJsZV9kd19ub3RpZmljYXRpb247DQo+IA0KPiBTb21lIG9mIHRoZSByZWZhY3RvcmluZyBp
biB0aGlzIGNvbW1pdCBpcyBqdXN0IGNvbmZ1c2luZywgbGlrZSB0aGlzIGp1c3QNCj4gZGlzYXBw
ZWFyaW5nLiBQbGVhc2Ugc3BsaXQgdGhlIHJlZmFjdG9yaW5nIG9mZiBmaXJzdC4NCj4gDQoNCkRv
bmUuDQoNClJlZ2FyZHMsDQoNCklsYW4uDQo=
