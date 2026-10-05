Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2783F2F60B2;
	Mon,  5 Oct 2026 07:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791185148; cv=fail; b=meSJs2qS3sCuRXKtzzgWZiazzP5rJuYiACG2AoS4zTogIJnglczvzpG1DC7WUonQHU1UtVHMpAoGrk9kHzj52+LzjB0yay1CT8akNOwHmU075cpVEcN3LIKPnL/nxoGA6Fc6Z/ddgJ5ex8XBJeU6IXxjv69ugMOn+z7PAkwDHCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791185148; c=relaxed/simple;
	bh=NTT2gIe4PtFsB7Q5D4tL6dgxObh8aBGz3CgEX+HvH8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kCbnGxNXKqA62JX7kdBuusqrZLx0BiRstEuJTUDXu3PEc7jZsGllNBlVDUWfWQbAeOCET+A02+O4/gESo4+Ey1kH1gEw64wipLUssCLDc6HJz3B+18oLCIZB18ACfBJ/XsjiE6jcvjTPFw2XIeNnxFJb/1kt2Ch/d7MH+KDX2jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISRfE7js; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISRfE7js"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791185147; x=1822721147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NTT2gIe4PtFsB7Q5D4tL6dgxObh8aBGz3CgEX+HvH8o=;
  b=ISRfE7jshwXgk1DfFDhyz2/rYLQUcvk8SinZXI4/JO86MhLmNipRKcEJ
   L/x/BIe6OHHBrwRX0zDZmOd7d3Siwb6Ty8a/cCj5LhzU2xLmLDXF/u3ar
   HRrmZR4j5oaJ6AVf4Rj1Oxrxg1tDIPwn2XaQL3C0Y6SkFXUqfFdhm3Abk
   FjDuWhWCFORxFEr7+9xoWFdSfbYTGYijbSxDTvmvUFRxTdBbr65cYv7Em
   mTRiFM9vZWK+IAOUWnADm/gcn8HU0SgnHtpIUpKkdvCxz5krj0ewtmh6Q
   W97Gl5asDDloGfj0Ur1gYkIKDjl9yH6jdahRx8IxAekaDq6ewtp0vBz8g
   g==;
X-CSE-ConnectionGUID: H+awgT+uQQWypzlfgod/Nw==
X-CSE-MsgGUID: ibYEPD99QX6MWl9huz7JZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="90615978"
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="90615978"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 00:25:43 -0700
X-CSE-ConnectionGUID: A5lTmUP8S8KckU0dYlf1cw==
X-CSE-MsgGUID: kWD2qCCmQlOAGTx9XVe8Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,141,1787036400"; 
   d="scan'208";a="314761623"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 00:25:43 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 00:25:41 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 5 Oct 2026 00:25:41 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.68) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 00:25:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEl+xgz//wS+IhQ8aYvGRZMUtXICr5m+xEm5yo7ykfxbjxMzwyhEgRDeR7LU/xB3UoB0g99Vd2Mr+o4tnIMsdkpWzZ1ZHV7wDtgINNJwWcjXXJR2BX1rCcgSx+OUjvP35mQwkuehqog9/bIA9YC7ZHOYkneTNS1jOndYeMP42lYdNlND3SBNKAbdVQNwoySxYLpj8uT5zRIBp1fX9J9Edy8ucAcJw3vukXey1oVKpukKoGrYrDI9GKb3n3XPjuuvb3O+//YQ63A5nA2V5RfOxGdSOCpE8cs/x5F0WiYBB9cWAIrz7qGQem603I9lT2Y/8AzR/m4yL0Gt5+hJrcCbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTT2gIe4PtFsB7Q5D4tL6dgxObh8aBGz3CgEX+HvH8o=;
 b=YRr9EJ54QVm6K5wxGIuDzGvQfYTz3MtuehaoEG25AINIdl97ktkN09aNwU2hdoYZAZWlXf1vsUu/O9nTzMctoJSUoE5uhPldjWVRzVU/2oS/p6ZfZZUvB8z4Qul0NfE8JM3G6FfzwOzWUMfvpPgoCb+bCcn2j1B15xoNp23UsjbHKXbvxJDQ2AyYyOuDFlwXhlvc5B9XCJ27PBDccySdGrmXWVVI9Uj4JnR3Kwm4/7nthYimI1g56J4CLCDHx35dN+vnRCALrE14Ty7nrexqwMwj5MYks2X2OWjdswBoPpNs07DviuwxWtgWqeVwWhM8W06CVkD9f/bH55Geu+fNTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by MW4PR11MB5910.namprd11.prod.outlook.com
 (2603:10b6:303:189::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 07:25:39 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 07:25:39 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Endrik Einberg <git@endrik.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency
 detection
Thread-Topic: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency
 detection
Thread-Index: AQHdVEnUYyLGTBrUKEeSxfhQvEKLf7bujEWQ
Date: Mon, 5 Oct 2026 07:25:39 +0000
Message-ID: <IA3PR11MB7213134F2D0E081A853C7A06A6A3962@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20261004214438.128694-1-git@endrik.dev>
In-Reply-To: <20261004214438.128694-1-git@endrik.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|MW4PR11MB5910:EE_
x-ms-office365-filtering-correlation-id: c13cda97-b033-4095-5475-08df22b1db2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|22082099003|10067099003|38070700021|56012099006|11063799006;
x-microsoft-antispam-message-info: UxSW9KSYiC50dg8dII9w/LMcyfBdmpo6fGWA0tI7WWvwrdJNWshJ1vZx7BtQ7VphnXEFHl74GSEs8cyB/KlkJr/HxB+p9nK5JgZsnQfaEkwfe6SDFDDKa/0CjHZlETPPkVtWh9pjKEkhGF04z/R4dI9wFaeNtnFOjaVHzTGQ3EdfkF1LMnzLD3uv+dVEAKWD6lwYD3InpVLacSISrcbpntkVZSywgl4K9At4SylPnf4jfAyK7dz+TOoC6hviKGcgOJB97ifoxvaCTSjhnVkN3Vpk+Qy28MIEER8/i5Uwxy00lv/UYY8nY/KJnO2slsjtuGbPBKvsW9Y6ctmYsaijf0De8JGz4Hg1yKebgwTMRLVPG6ngqI5e5Imc/eJPEO5bh2pYMN83cnd9xSKXoxMRRTC7J0jgkMWSJZra48L7+gIkgz9zRGheEL6BJCy/01aFLQtZEgA89U1YWidMKfpoirh/qDos4DdQNzbfNdmMSGeZYclykHE/vojH2PZ/k55gCsGnxvxSosqFlt2lDGSqP3vAkME9XFNGbUt6sRST35Y1SJZYU2XlK0tZWFN10NtIkBbB7ozqTc5GlMT67bHVodGjQwasf3K6tT/lg9V+Xq+zDPjLQo7ZHirgr+XXxUrtr/xNCPgG61XHoIsEEmhcSI7Prq4gHobd8aHZbg6W2U47BpD/5huiytwHuLHrmd8fimJEBLEaqhgqwJNDHbOaMgl9c4YJWZYC8DwACQo1KzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(10067099003)(38070700021)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3ZRUkx5OHNqTXMwL1ExTmsrWFBSRDIrY2IrZ1Jvb3RmNVJGcjF5c3dJVXJj?=
 =?utf-8?B?dHQxWEQ1VEZ1WkU5clpuWWRHMDlvOFJrcVdVemUxVFYrUlNTMTAzeU1sY1Q3?=
 =?utf-8?B?SkR5WHJpTUQzK1I2V2lFdGJkRElPaU4zenhIK2tUaFVEN0xxK0lsTXpzRVFP?=
 =?utf-8?B?L1pPcDRYUUhEMHFBbDhyTjgzMmEzSEV5L3g2bHRZdGdrQlNZQXdnRm02ZEl2?=
 =?utf-8?B?QVlBUnRZWTdXTXNJSUM1aldTc1ZsMzVaVDRlZGd2MnBZcy9mdDdxeHRpTmxW?=
 =?utf-8?B?bTRLY0crWVpoU1YxTWhJUDdGbTVvUDBHbGQ1TGtISFBSblpHUDVQNFVzV3ZM?=
 =?utf-8?B?clR5UmRPb1lRM1BickNQdXU2UXhSUkRYeTdWOEtFOFU2Q2w2Rk9UME1qdFlo?=
 =?utf-8?B?TnNyRE4zbnZjd0VaUWdnNHZmNGFFOEhNdUF2UU5Yam1PWnFqd0lxYWlhQUc5?=
 =?utf-8?B?T0tVZ2hoT0MzVDI1dXUvUXI0ZTVyVmx4dXV2MnBZY1V1dWdETXhydk10UEpi?=
 =?utf-8?B?ZE1XdThub1NrbkZ4Sy95TnUwU3hvVzMwcWU1THJBaWFzanl5aEltbHk2R21w?=
 =?utf-8?B?QzBYNGVTWE5KNnFUZVQ2SXBLZFdPV0M2MzVJQldpU1RuZFNyNStncWM5bEFo?=
 =?utf-8?B?RWN3TCtvSVZiSkxUUEFxUzNralZBSVd0U0RjOHgzZ3V2Q0xRRUFubFc2ZytN?=
 =?utf-8?B?bWU2Tzg5ZUo4V0EvV3V6aWVIakJRYWJaRDFJS1pnNlNNMHBpUEE3bFluc2c3?=
 =?utf-8?B?SXNJQjNSd0R2Q2V3bVhCOVFOekFDUjZ1bk1JaU50TFBEMVA4WFU0anBWVHVl?=
 =?utf-8?B?QnA3aUQ1ZDNablF1NFQxcU5seXZOK29NQndrK2lycUxFWjQyS0tuVy9aVTNH?=
 =?utf-8?B?TW1LWThvNndqT3dmY3d2dHdqOGpDR29rYk1FTEIyd0FrRUl6enJQNEprSk5C?=
 =?utf-8?B?YXc5bGtBNkE2WE9iaGNRSXh6R0J6ck5ZejRMcHNpNHVCUzV0ZThvZW51SXEv?=
 =?utf-8?B?aFNJU04xcDlNQllFUC92OE5jSUxNQjJia3k5V2lzTnRGT3pkbHZxSWJoN21u?=
 =?utf-8?B?RVJUa0lWdEoyVXVFUkpCSHRBS0k1NXBNelExSXBVK09WV0YxaFlBWjZRcUVk?=
 =?utf-8?B?R0ZPNEhHVFIwb2kvUDMwY20wNkNVM1NxVnFvUzBJM0lFUUF0NDlVZ1dJbGxD?=
 =?utf-8?B?UVlGTGwxOGVoTTRwcmRvREdWK3Y4Um1QeUJuV2xpYURRTS84UmhZR3J0ZkM5?=
 =?utf-8?B?MTFSTUVhMjVXM1h1WVlKcHVIV2VqRFlWMmQwRFArZml2cWt1cXhHMUY5TTlC?=
 =?utf-8?B?N055aXl0amtNeWhzWHNQQWFhczNkdU4wK1hnMk1CWjNTY3gzR3lRTW1LNGx1?=
 =?utf-8?B?VExDNFBLL241Z0J3WDhCK09PQTltclcrN2RjRHZWV1M0VFdKNEU3d3cvbVJM?=
 =?utf-8?B?T092ZjJHc2lDWXZrWi9SWnlHdElpWWowSEFnTFEreFdqYlJodzlMVGx1b2RD?=
 =?utf-8?B?NjZ5TDRER25rOS9VczEyczVCQlRNbUxKRGJ5dG5GRW02cXFvNG53ejhFdWRO?=
 =?utf-8?B?a1YwWEg1TGVVaElycjJ4elBmT0FyV3lQVFFCazBwcTl5NXhsOHV5K0hLN3BY?=
 =?utf-8?B?Q0pNR2JqOE94VW1UWCtySEZUcWk5MjduNW93ZTYwQWViT29MLzdVV0FOUXFt?=
 =?utf-8?B?b3NlK1p1dUhYYUZoOG9zdmZ4QjF4MVpRZUUzSTVna2NtUHU0MzJlZENsbXdz?=
 =?utf-8?B?WWNIQ1V5aFBMY0tqQVpKYUZ4Q3NVZVhWSlVlQ0xNamJJVjNhVmdFYkZ1RGpL?=
 =?utf-8?B?Qm9RTlU2Wi9yQmJQakVZRFk5Zk5qbTJGTkpNUVBiYm9nMm1uVmU3czJYSUZK?=
 =?utf-8?B?Z1U1Qko0U2MxTVdRdnRGN2Q2K3hteWFzSThibElYT1lKeG84VEdMT0U0RU5M?=
 =?utf-8?B?RG1UUnZ5Q3JUV3MwSkNYRVhRaExyejllVkNZS1VKbHpIRmdqVFM5dXdhOU5U?=
 =?utf-8?B?V0I5eDB2M1pXMlF1eEVTaHVJMDdXblo1cnArUmthWTJabWtITzh3T3J0TmtJ?=
 =?utf-8?B?cXVXMG50OTU2OWhxT0tPbGFuNm80dUVxb3pRUituSEFEcGJITG1lUFlLS05J?=
 =?utf-8?B?dmRoYnU5WlpXU1ozdWZVWmZQaXg0SlV4VjNnSFA5dVFnam53eXczbXg2V2py?=
 =?utf-8?B?ekxZOW8wN21yTzhzOTNnUkZidW1ZOG9BYmwzaEhWNCtZcVJvbnFpOXBSbFE3?=
 =?utf-8?B?M0JpVzBVdDh0ZFd6R1owUWZEUlkvNHlRWnhpc3JHcTZqakhBUTJqOXB4dXBK?=
 =?utf-8?B?Q1pmRERzZ2FBWlpTTFRmSUs1eWFtZmJldng0aUhHejcxVWtvU0E4SXFJZnE4?=
 =?utf-8?Q?z4v/xYknx79ITEXU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Fr4Eu2n1CfW69YPTObjnZM8f03t0sUQCWJ9hqQyipcxVt9Vse95dc7lZn7OV3maJ64u5MuWef5Zo71wqYQCno0p0eDI8fAD1A+DcMFRgR07459s+KrhcNDCxCuzFKGwGRKBMu22LaLExN4kxuwORHDQh7BQCNUcLyzVIfQLhsEbTa8D9sjwNXmJajkdYhplnD4rgGmmxUZAHoKGJ9aTlBoct9cKyxo7sj8tPCa4/tnik+oUkJgowW6GpkptkHO6x9fTBeJ9/O/9NfYm+vHGM+D1PougGaVtdtylsldsQsZBCfNGAQZGcRcXEWfyORZqKNZmkVTsHq2QsrO6sd0R4mA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13cda97-b033-4095-5475-08df22b1db2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 07:25:39.1432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkiQQsytGOORM2tNZTx0sjL8tjG4G0j5FjHGYHr5aLHRW3JFWkIsYsotzKltMYKNxn+eC/BdPB4wI10Q8T4PmA9iJfj6JvxJzlKy+HhFtrgkZp9fhWY3Mo/2szCmD+vT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRW5kcmlrIEVpbmJlcmcg
PGdpdEBlbmRyaWsuZGV2Pg0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgNSwgMjAyNiAxMjo0NSBB
TQ0KPiBUbzogS29yZW5ibGl0LCBNaXJpYW0gUmFjaGVsIDxtaXJpYW0ucmFjaGVsLmtvcmVuYmxp
dEBpbnRlbC5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBFbmRy
aWsgRWluYmVyZyA8Z2l0QGVuZHJpay5kZXY+DQo+IFN1YmplY3Q6IFtQQVRDSF0gd2lmaTogaXds
d2lmaTogbWxkOiBpbmNsdWRlIFZJIHBhY2tldHMgaW4gbG93IGxhdGVuY3kgZGV0ZWN0aW9uDQo+
IA0KPiBpd2xfbWxkX2lzX3ZvX3ZpX3BrdCgpIGNoZWNrcyB3aGV0aGVyIHRoZSBtYXBwZWQgYWNj
ZXNzIGNhdGVnb3J5IGlzIGxlc3MgdGhhbg0KPiBJRUVFODAyMTFfQUNfVkkuDQo+IFNpbmNlIG1h
YzgwMjExIGRlZmluZXMgSUVFRTgwMjExX0FDX1ZPIGFzIDAgYW5kIElFRUU4MDIxMV9BQ19WSSBh
cyAxLCB0aGlzDQo+IG9ubHkgbWF0Y2hlcyB2b2ljZSB0cmFmZmljIGFuZCBleGNsdWRlcyB2aWRl
byB0cmFmZmljLg0KPiANCj4gSW5jbHVkZSBJRUVFODAyMTFfQUNfVkkgYXMgaW50ZW5kZWQsDQo+
IG1hdGNoaW5nIGJlaGF2aW91ciBvZiBpd2xtdm0ncyBpd2xfbXZtX2NhbGNfdGNtX3N0YXRzKCku
DQo+IA0KPiBGaXhlczogZDFlODc5ZWM2MDBmICgid2lmaTogaXdsd2lmaTogYWRkIGl3bG1sZCBz
dWItZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTogRW5kcmlrIEVpbmJlcmcgPGdpdEBlbmRyaWsu
ZGV2Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbWxkL2xv
d19sYXRlbmN5LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRl
bC9pd2x3aWZpL21sZC9sb3dfbGF0ZW5jeS5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9tbGQvbG93X2xhdGVuY3kuYw0KPiBpbmRleCBhNGRkYzMyZTI4NjAuLjM2ZGE2
MzlhZWU1NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lm
aS9tbGQvbG93X2xhdGVuY3kuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9p
d2x3aWZpL21sZC9sb3dfbGF0ZW5jeS5jDQo+IEBAIC0yNTcsNyArMjU3LDcgQEAgc3RhdGljIGJv
b2wgaXdsX21sZF9pc192b192aV9wa3Qoc3RydWN0IGllZWU4MDIxMV9oZHINCj4gKmhkcikNCj4g
IAlpZiAodGlkID49IElXTF9NQVhfVElEX0NPVU5UKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+IA0K
PiAtCXJldHVybiB0aWRfdG9fbWFjODAyMTFfYWNbdGlkXSA8IElFRUU4MDIxMV9BQ19WSTsNCj4g
KwlyZXR1cm4gdGlkX3RvX21hYzgwMjExX2FjW3RpZF0gPD0gSUVFRTgwMjExX0FDX1ZJOw0KDQpJ
IGRvbid0IHdhbnQgdG8gcmVseSBvbiB0aGUgdmFsdWUgb2YgdGhlIGRpZmZlcmVudCBlbnVtcyB0
b28gbXVjaC4NCkxldCdzIGJlIGV4cGxpY2l0Og0KcmV0dXJuIHRpZF90b19tYWM4MDIxMV9hY1t0
aWRdICA9PSBJRUVFODAyMTFfQUNfVkkgfHwNCiAgICAgICAgICAgIHRpZF90b19tYWM4MDIxMV9h
Y1t0aWRdICA9PSBJRUVFODAyMTFfQUNfVk8NCj4gIH0NCj4gDQo+ICB2b2lkIGl3bF9tbGRfbG93
X2xhdGVuY3lfdXBkYXRlX2NvdW50ZXJzKHN0cnVjdCBpd2xfbWxkICptbGQsDQo+IC0tDQo+IDIu
NTMuMA0KDQo=
