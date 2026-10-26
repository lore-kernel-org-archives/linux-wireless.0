Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793046194;
	b=KkHJLBr1oFsucfjqRYU1Vf+NjatqUCKut1lzoBM94Jze2yhysVnDoMuKy8siCDAv/EZb
	 zKR+eoHgMWAGcwBpTzS6Ba1iBHpcz7aSu92uf9iqsqAMuqpxaTD9yH8S/CKLNE/Kn72P/
	 SYO44r4gkoi6Zd3j3IV9HJQD4iN0iF5rXIjC3WSywfdYHw3RptasimHvPZdXKPs4dYkec
	 0d/v1g7KTCZD0WJfodif97RnlxIxe3c5xQoCiKMUJRqMAEJBFuPc4dp8rEjaIuWCmZAMP
	 xZSBjyP6uXRuV495s2ux7dklif40rqzmqPpkIGVDncqK/laNEiicWHFnucv+CFu0fNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046194;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=UCl3K8psr8Vs+3h8f0bILWWiLhi29sIWs5L0E7XPWRU=;
	b=OeBs6ah2MyzFixWQVvgwQjJchQgbzgPBs/9Befyn4RJV969rPfgwqUZxgDozNPgTPZ7d
	 hQaY9KDLcDxnPkS4NBoYv5cQf+qQazXhsrLLAHmYvlpvpD7SYioFpu3ToKXO6pvSD6LU7
	 hlenFNYLBVxw8pjOyTsy84gdHfUFdFWCss1du/roAgeIx0b1w7ElQmsgTsyuBEQ4OZkvP
	 tpVGu3+KC1ILYgRn7TgmtU4LU8rnfHRG4ykuEhT+VGoCRnDfF6c0fjbrYmA3LSgM7/rUk
	 gXHtGdiKCRUCHGHu/sA4ZH1+wsr0lQAFNnjvhnp6ZO2osLPhzHL8nZ5Jp9NAtLBvEtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iabExpNP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510BD606A31D;
	Mon, 26 Oct 2026 20:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 510BD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iabExpNP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793046193; x=1824582193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UCl3K8psr8Vs+3h8f0bILWWiLhi29sIWs5L0E7XPWRU=;
  b=iabExpNPK+594vx/YqxRfsqln4+QDj5cp7ixursrgAYNUsNYQBpZuQRt
   l/QPHVBz8wwQ0+5Fhb1KRFCGtUX5yMtOb5yiXKauNKkGH80ujoS23fY0H
   q5a0cOeHpuk6OCyj2+nTxAt2VomAOZOwGR3B4adOQtKA+jqHvIGdvdPsJ
   64PoXEoWP2KGpcdzGEkELleFCU7HGTPoVz6KYLoPzUgjdQSZxQelWlDPF
   8G/Y8cI4DsyXXU9TKimz9eVKo2mWy0w3NkwX3AL7dxAQAo4GH1l/tgVJs
   6LoL7G8QQRoGR6qNsHi/Ea6y+WxRb+MlR/EUq9s8LQWhBX2TVQiJbNW/h
   A==;
X-CSE-ConnectionGUID: OL3U5/JVRxydQ9OMDfHZHQ==
X-CSE-MsgGUID: 0o4fuBT7QYGGtJmogDQnLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1624417"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1624417"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 13:23:12 -0700
X-CSE-ConnectionGUID: sC8z5YmgSkmvD2YBUE2yzQ==
X-CSE-MsgGUID: qYOZZnCZSrWPzgcg2qDVaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4750071"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 13:23:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 13:23:11 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 26 Oct 2026 13:23:11 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.34) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 13:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pUs5Y3cfGB0oWHJYkuUZA48a/fMpdo5WyBbUHVhufV1lf05NFkgbpgesSw+euqxlylAj636xmmDnxzEDnAvs8dQSvAEBKcKqV8J5ZWW9Psdhzkbmh8B63rYCVWJgYtXkkquezenmFG1iikzfHTtYzdZiZbHHjOcJxbCyY4oEJ4GMlEtF1eZQVieiZMluew2RJHcNWPU3FrOH8dEfisYOmJLwB70huF/wtHa9u/dNd4ddCGYanU9HFGKoLgyg0LxrsyxgFhlwu2ZDJHLMboXThywekDLpub5KCzD2XSiJkZsD13vqRtXvaaj/xAwKMYoEsEX9iNOoINDHyC0OjH2/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCl3K8psr8Vs+3h8f0bILWWiLhi29sIWs5L0E7XPWRU=;
 b=pcqT9OTQED5IUfJ1y0VUeLpSOByygdBTX24PaQl2FE8tyqGBysT12jxrMCjElB9FOwkyF+R1cLtc2afomUJJAcle8MtSujFoV/WKwMKagpJUXu/49CRd9PaVc6dB1X0ULJS5JLqDcwF6lU2+TbL5eMVNnWyQZJMWVCcZ7raa/kw4QYHE5IE9WKRfc0Uh5BBkE1UPG8bjnFk+tdisYWCLHN+2F9eDLy03WozJd1oat7j/gshGw5DB2Vo9ccJs694Itjh3pp7vVMiDaxCzX70Uzuj7T8ua4gksalyGMmvQrVYnZr5OVw23TWHu2vyxK2nrTyc32C7DzSh5dPd0sFheLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by IA3PR11MB9226.namprd11.prod.outlook.com (2603:10b6:208:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 20:23:06 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 20:23:06 +0000
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "helgaas@kernel.org" <helgaas@kernel.org>, "denis.benato@linux.dev"
	<denis.benato@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "Korenblit, Miriam Rachel"
	<miriam.rachel.korenblit@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Kimelman, Ofer" <ofer.kimelman@intel.com>,
	"kernel@lists.opengamingcollective.org"
	<kernel@lists.opengamingcollective.org>
Subject: Re: [PATCH 1/1] PCI: Disable D3cold for Killer BE200-family WiFi on
 MSI Claw A1M
Thread-Topic: [PATCH 1/1] PCI: Disable D3cold for Killer BE200-family WiFi on
 MSI Claw A1M
Thread-Index: AQHdZNcoQeMglT3JGE2biUzC/VXqRLcQK22AgAAF9wCAABRygA==
Date: Mon, 26 Oct 2026 20:23:05 +0000
Message-ID: <755a06da8b884d838254af1b8991954540967986.camel@intel.com>
References: <20261026184813.GA342157@bhelgaas>
	 <76481816-6b21-4f45-8949-144342faf39e@linux.dev>
In-Reply-To: <76481816-6b21-4f45-8949-144342faf39e@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (3.60.2-2.fc44) 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|IA3PR11MB9226:EE_
x-ms-office365-filtering-correlation-id: 55087bd2-92d4-4bfd-8969-08df339ef187
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|22082099003|261026121527099003|56012099006|11063799006|4143699003|10067099003|261021121427099003|261021135927099003|261009223027099003|261022105027099003|261022075727099003|38070700021|261026140227099003;
x-microsoft-antispam-message-info: xbCLFRhIh+CgJLT5ywbTh6hmoJhQyEjYa1Tlgkbw/ZRV0nEHYie3JmXJu+D/bZo/1Xj7GgqBmIN5t/nzLHjB9LovgAxRdOeCA6s32iEaYK9eA5K4cI7NXt3ZFvwpY97WVpV9qjyXfPow2g4tkzQnQLU1PqriFyze3/35uszsfdAh4fOrxK3FiV+m5H2BmR+2APVI5K6h8vhttqbmzANNJA3TeJ4rITCzk3jHYhZe2b7NZsYVySG33s0c5dg7RaMY90pcm2tD9vByf95OsL63BcLQmECxNnQDuWf/65ZbGda6ZhyVBJ8JSMXkx0TqNM6VpLwkkznwjsNc16Q2UjoCiXEz10XuuCDMJSUUXQr5xfO0NjSCvNR7zEmCZCk4a47vJDeETQw3qpESAcnIijf9LXi5ZUroWWphsVZtKm0kuc2xMKROxCRjnHRDxro08rECCLDce9D06xSch0pSeJ40NjKgj+3/j5o+P0ZoZ0P1jeaZg047H+FI8KucWx3nOOlYvN6CzbePErq9i/nWISNJOpmuc2u9pF/7hIpWAT96m2dNccG3gvlMaCZ/j3QsjptHW+ZKO4v1UdjZIqg25wlPzdVcxu6FPWVye2Cexjy+pTxk8kC891HVt800TTPF95g2JRVCW3GrPKwj7QyaYiHNGs7YXdUGPAm+o13BNqUSeeM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(261026121527099003)(56012099006)(11063799006)(4143699003)(10067099003)(261021121427099003)(261021135927099003)(261009223027099003)(261022105027099003)(261022075727099003)(38070700021)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjhpOW9Qa0V6U1puV1FwYU9xZWJmcVdVaFhRYko1cmNNQmNxRFJnSHhnbzBM?=
 =?utf-8?B?UUVuRjNEWisyQS9jV2N1YW94VzZ3TDlSbmsveFFkaDI5SU9IeDZjMUQ0V2Vh?=
 =?utf-8?B?YlFXeCs4TnJjU0xZUmZwc0tBVVBPdFdleTVMTFBRU2E3WkJScmtRM3JFNzhG?=
 =?utf-8?B?VmtTUmNlZ09xNUc5MXhieDlVNTd3OWlxanpsTS8zNEh6a2g3M1Iyb01SOWhX?=
 =?utf-8?B?ekkwZCtlYURtaWtOVFVNSURHMFc3dmE3VVJ2L3BZSzNZcXYvSk4wWEZzSFE0?=
 =?utf-8?B?ZkEyS2ZnTlVnWXBUS3NUZDFUOHlQdW93NVhMYjQxbFk4c2V2MGRtZy92dUhm?=
 =?utf-8?B?UHVKMVFPR3VoWU5mRkFIbE90eFJpV0dOeFoxRUZYNXdRRWc4V2lvbEtyUUtX?=
 =?utf-8?B?cVNWZ05rdC9iaDg4aGVBY21XYURWRzUzeHNPVlFTbE9mcmtuSVlySUU1alpJ?=
 =?utf-8?B?bnRId3R6ellvaXI5M0w2cjA4QUF5UlV6NlpoYU1FekJVYmtHdlZXc0QyTG1X?=
 =?utf-8?B?TkFpUTFuUDExeGtsVElPVUk1VlJ5UDNsK09Ddkc1b0V3OWQ4cm9aYk9Qdzl0?=
 =?utf-8?B?UkpYRGRPaVcvMWwyTmdpS3NkSnA2a05xS3dma2c5RjVTdmYyc2JZRHhlcFFt?=
 =?utf-8?B?OGR6S1B6RHF2djZ1YUI2NXBzc0dVYkxlOTdYTXNDZHJncUdiOEJOQStNNnpQ?=
 =?utf-8?B?L3h2MEc4c3F2cnhtaytYRUoxZEZXekdwTWV4ZGtjMUczRzB2Q2tVOGdBakZK?=
 =?utf-8?B?VVRWT1M1N3dwbi9qUndPbEhpSDd5Zm5KNStVeEpqaXZnQlVCZGlIbGp4OGdZ?=
 =?utf-8?B?WkVZaXpNM213d0R3VTBpU1h2OFIvQXRTZUdETHQvYTFObUNnQUZPMHJtb0Uv?=
 =?utf-8?B?WUVZSkhSVkZ5T2ZVM2ZJMVB0UDg3SjZ5dUtrY2t4bmVCeG4xbU9obzJzUTY5?=
 =?utf-8?B?QkNWY1dRZHBMeTZlSjJ1TG9RRUs5QW5zODBJVkRTbjBCanhBdUVnNTZONHpT?=
 =?utf-8?B?YzlSWVZTODNuNDY5NS91SCtzZnBRSE5Yd2Z0WUtBUjZ0bEtyS3JmWjJyNXV4?=
 =?utf-8?B?TXJ3ZTExdjNpYVRUTGsxakdibXdqOERqVUxhWDJOSi8yQ3NpQ25mYStaa25q?=
 =?utf-8?B?T3hTa2REcTFyelF5OWdVeUFGZGVZN2owOWZySmJDaFNGWmJhT2lrL0hDVGI2?=
 =?utf-8?B?UVJLbnNiTGNKOWo0cXhPcmtyZ0tUeG9oM2lUenpoQTJLbm8xcnAyMk1yRjMr?=
 =?utf-8?B?UXNZSWJhL2pnSnpsTUdRUnlYVEtjb3NYcmx2MjlkQTVnNjVvd3lLZUF0dTlZ?=
 =?utf-8?B?NDRzNE9JOE9uT2lyalFQYzhoc1FGdXhwT3ZwM1EyNnNFOWsrdjEvVXh3Mytu?=
 =?utf-8?B?ZXhaVTVsTVNkUis3UDlPWGN0VFA4ZDBVbUk1S2Vwa1RtUTQxbHlvTTEySk9w?=
 =?utf-8?B?V2tSK3pnc1lDMENkbFVOWC9ibjBDSnAxaXhsem81RWgyS3RmUkdTWEw1SXZS?=
 =?utf-8?B?bERoblFwMm9SbmJVMExnNjdyVDV3ZU5LcDVLdEhRL2RzTStJTE1SQTlBaXo0?=
 =?utf-8?B?NzlUZ0RvTG82MVJaRUVwd1JISkFnMG8xN1lydkd2RU1jWEMvQWI5Q1NRVHkz?=
 =?utf-8?B?eGQvUlRpNk4remJLUlNHV0VtLzRNc0IrODNvaFdmcC9xcVBlRE85WmJDcEUx?=
 =?utf-8?B?ZnZFdnJSOE80cFA0M2lpajVlNGR0bEtTeXhuNzdwUGJMcE5rTncrckppQzBR?=
 =?utf-8?B?V2FFNkUzNVZrZDhzUy85dUZ0S3Y1c1o2SjN2ZUJsV1RiMkxqdkx1SnpNeU9m?=
 =?utf-8?B?UWZlMWxQdTlXc0JjVmdmc240Sm1BZ1lwUnFhaUU0ZDducFRVT2FRVnpmejBi?=
 =?utf-8?B?cEpNZW5LZ2JXMHYzcjFWTmFLZGNycXBSeEdrZXpGTlhaa1RpcWFzVEx2NXpX?=
 =?utf-8?B?NFFPSFozSmxpWlM4UGhHNmE1Y1RYbUZpZjhNU09YSXJYb3AwTUo3UllackVY?=
 =?utf-8?B?UkZ3UlZ2RjFQLy9mRjVSTm0zQklKUmpHZkFDdHlST3VscVkvUjBmSEZTelA4?=
 =?utf-8?B?Rm5rdThKSUlXZTh5ZENEbUkyek5ZbGNXeVpHVTdrV2R0N1lQZUloMWlVZndo?=
 =?utf-8?B?Vmp5UG5hVFZmanpCdmtPUDcreXd3bXlaQ0kvbkM3TjdjLy9PWWExY0tJb3E3?=
 =?utf-8?B?RG4wdGRHYll5OHRuQWd3M0V4cFB1UVhKNFlxS1JqRi85SUFWbys4eVRRSURR?=
 =?utf-8?B?VXRiMHRXZ3J2YXQ2Z3RUM0Nad0o0bkoySmJBSWN3L0MxQ2JEUkc0VGlDR0tw?=
 =?utf-8?B?bVlSNFlONG9ncDkrbXZlNTFuajIwUG9LM1hKbkdyL0VmUTNRQ0t5V285Z3VJ?=
 =?utf-8?Q?6brM5UrXR1Lj19cQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50DFD237E6E50045BBAB72BC7D9B346A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mnnAqq7z+UquvuFqfU13ONFZnwDZXQYVnK1KNkYOODlvLioslSBijCKDAnmBqwfGtN0Tag0ZBoHc18r5ubEC1T34WEjy8UmlCrM+lLouQEhvWP8Xt4KyA+S3RyHypU3CSUPNre/bOJOftoEjt5+Crbs2009edLbubwmT3VACCJwMPGVy73ZfeoZtLHj2sZgXJCpRvUG6S2w5sJg36hT72QzF+l1CtAluLf1uJXpR1Dz0ynRe+kfJIIQ3DIUacZi7JssrAwwxQDX1qM8hSCO8QYF/GdJGVwMpgrx1KzVlgvi3fYmKkjrT9LtfzvPJrzFG//m4y1r8qMRfGHUWek/AzA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55087bd2-92d4-4bfd-8969-08df339ef187
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 20:23:05.9210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7irQRbj5Xs5TEdxpKAOg6if3C+2R/1S5Ay9AVGhGnC/Kw/KVy6sG04emjmSzGnYuMwDbYE/QDJruCLesmBmPZjeY930D2RYlsUecHaBrGtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9226
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTEwLTI2IGF0IDIwOjA5ICswMTAwLCBEZW5pcyBCZW5hdG8gd3JvdGU6DQo+
IDI2IG90dCAyMDI2IDE5OjQ4OjE2IEJqb3JuIEhlbGdhYXMgPGhlbGdhYXNAa2VybmVsLm9yZz46
DQo+IA0KPiA+IE9uIFN1biwgT2N0IDI1LCAyMDI2IGF0IDExOjE4OjEzUE0gKzAwMDAsIERlbmlz
IEJlbmF0byB3cm90ZToNCj4gPiA+IER1cmluZyBzMmlkbGUgdGhlIHBsYXRmb3JtIHJlbW92ZXMg
cG93ZXIgZnJvbSB0aGUgV2lGaSBzbG90DQo+ID4gPiAoRDNjb2xkKS4NCj4gPiA+IFRoZSBLaWxs
ZXIgQkUxNzUwIChJbnRlbCBCRTIwMCwgODA4NjoyNzJiKSBpbnN0YWxsZWQgaW4gdGhlIE1TSQ0K
PiA+ID4gQ2xhdyBBMU0NCj4gPiA+IGZhaWxzIHRvIHJlc3VtZSBmcm9tIHRoYXQgc3RhdGU6IHRo
ZSBQQ0llIGxpbmsgZG9lcyBub3QgcmV0cmFpbg0KPiA+ID4gKCJwY2llcG9ydCAwMDAwOjAwOjFj
LjA6IERhdGEgTGluayBMYXllciBMaW5rIEFjdGl2ZSBub3Qgc2V0IGluDQo+ID4gPiAxMDAgbXNl
YyIpIGFuZCBldmVyeSBkZXZpY2UgcmVnaXN0ZXIgcmVhZHMgYmFjayBhcyAweGZmZmZmZmZmLCBz
bw0KPiA+ID4gdGhlDQo+ID4gPiBjYXJkIGRpc2FwcGVhcnMgZnJvbSB0aGUgYnVzIGFuZCB0aGUg
bWFjaGluZSBtdXN0IGJlIHBvd2VyLQ0KPiA+ID4gY3ljbGVkLg0KPiA+ID4gDQo+ID4gPiBLZWVw
aW5nIHRoZSBkZXZpY2UgaW4gRDNob3Qgd2l0aCB0aGUgbGluayBpbiBMMS4yIGR1cmluZyBzeXN0
ZW0NCj4gPiA+IHNsZWVwDQo+ID4gPiBtYWtlcyBzdXNwZW5kIGFuZCByZXN1bWUgd29yayByZWxp
YWJseTogdGhlIHBhY2thZ2Ugc3RpbGwgcmVhY2hlcw0KPiA+ID4gPjk5JQ0KPiA+ID4gUzBpeCBy
ZXNpZGVuY3kgYW5kIHRoZSBjYXJkIHN1cnZpdmVzIGV2ZXJ5IGN5Y2xlICh2ZXJpZmllZCBvdmVy
DQo+ID4gPiBtdWx0aXBsZQ0KPiA+ID4gc3VzcGVuZC9yZXN1bWUgdGVzdHMgd2l0aCBhbiBSVEMt
dGltZWQgd2FrZSkuDQo+ID4gPiANCj4gPiA+IERpc2FibGUgRDNjb2xkIGZvciB0aGUgQkUyMDAt
ZmFtaWx5IGRldmljZSBvbiB0aGlzIGJvYXJkLiBUaGlzDQo+ID4gPiBtaXJyb3JzDQo+ID4gPiB0
aGUgdWRldi1sZXZlbCB3b3JrYXJvdW5kIGRpc3RyaWJ1dGlvbnMgYWxyZWFkeSBzaGlwIGZvciB0
aGUNCj4gPiA+IEFYMjAwL0FYMjEwDQo+ID4gPiAoODA4NjoyNzI1KSwgd2hpY2ggc3VmZmVycyBm
cm9tIHRoZSBzYW1lIGNsYXNzIG9mIHByb2JsZW0sIGFuZA0KPiA+ID4gbW92ZXMgaXQNCj4gPiA+
IGludG8gdGhlIGtlcm5lbCB3aGVyZSBpdCBiZWxvbmdzLg0KPiA+IA0KPiA+IElmIDI3MjUgaGFz
IHRoZSBzYW1lIHByb2JsZW0sIHNob3VsZCB3ZSBtYWtlIHRoZSBxdWlyayBhcHBseSB0byBpdA0K
PiA+IGFsc28/DQo+ID4gDQo+IA0KPiANCg0KSSdsbCB0YWtlIHRoZSByaXNrIHRvIGhpamFjayBh
IGJpdCB0aGlzIHRocmVhZCB0byBzYXkgdGhhdCB3ZSBoYXZlIGENCnJlZ2lzdGVyIHRoYXQgd2Fz
IGFkZGVkIGluIEJFMjAwIHRvIHRlbGwgdGhlIHdpZmkgZHJpdmVyIHdoYXQgaGFwcGVuZWQNCnRv
IHRoZSBkZXZpY2UgZHVyaW5nIHRoZSBzdXNwZW5kLiBJdCBpcyBjYWxsZWQgdGhlIHNjcmF0Y2gg
cmVnaXN0ZXIuIFdlDQp3cml0ZSBhbiBpbml0aWFsIHZhbHVlIGludG8gdGhhdCByZWdpc3RlciBh
bmQgdXBvbiBfaXdsX3BjaV9yZXN1bWUgd2UNCnJlYWQgaXQuIElmIHdlIHNlZSB0aGF0IHRoZSBv
cmlnaW5hbCB2YWx1ZSBpcyBubyBsb25nZXIgdGhlcmUgYXQgbWVhbnMNCnRoYXQgcGFydHMgb2Yg
dGhlIGRldmljZSBoYXZlIGJlZW4gcmVzZXQuIFRoaXMgYWxsb3dzIHVzIHRvIGtub3cgaWYgd2UN
CmNhbiBzdGlsbCBleHBlY3QgdG8gaGF2ZSBhIGZpcm13YXJlIHRvIHRhbGsgdG8gdXBvbiByZXN1
bWUuIFNlZToNCg0KICAgICAgICAgICAgICAgIC8qICAgDQogICAgICAgICAgICAgICAgICogU2Ny
YXRjaCB2YWx1ZSB3YXMgYWx0ZXJlZCwgdGhpcyBtZWFucyB0aGUgZGV2aWNlIHdhcyBwb3dlcmVk
DQogICAgICAgICAgICAgICAgICogb2ZmLCB3ZSBuZWVkIHRvIHJlc2V0IGl0IGNvbXBsZXRlbHku
DQogICAgICAgICAgICAgICAgICogTm90ZTogTUFDIChiaXRzIDA6Nykgd2lsbCBiZSBjbGVhcmVk
IHVwb24gc3VzcGVuZCBldmVuIHdpdGgNCiAgICAgICAgICAgICAgICAgKiB3b3dsYW4sIGJ1dCBu
b3QgYml0cyBbMTU6OF0uIFNvIGlmIHdlIGhhdmUgYml0cyBzZXQgaW4gbG93ZXINCiAgICAgICAg
ICAgICAgICAgKiB3b3JkLCBhc3N1bWUgdGhlIGRldmljZSBpcyBhbGl2ZS4NCiAgICAgICAgICAg
ICAgICAgKiBBbHRlcm5hdGl2ZWx5LCBpZiB0aGUgc2NyYXRjaCB2YWx1ZSBpcyAweEZGRkZGRkZG
LCB0aGVuIHdlDQogICAgICAgICAgICAgICAgICogbm8gbG9uZ2VyIGhhdmUgYWNjZXNzIHRvIHRo
ZSBkZXZpY2UgYW5kIGNvbnNpZGVyIGl0IHBvd2VyZWQNCiAgICAgICAgICAgICAgICAgKiBvZmYu
DQogICAgICAgICAgICAgICAgICogRm9yIG9sZGVyIGRldmljZXMsIGp1c3QgdHJ5IHNpbGVudGx5
IHRvIGdyYWIgdGhlIE5JQy4NCiAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAgICAgICAgICBp
ZiAodHJhbnMtPm1hY19jZmctPmRldmljZV9mYW1pbHkgPj0gSVdMX0RFVklDRV9GQU1JTFlfQlop
IHsNCiAgICAgICAgICAgICAgICAgICAgICAgIHUzMiBzY3JhdGNoID0gaXdsX3RyYW5zX3BjaWVf
cmVhZDMyKHRyYW5zLCBDU1JfRlVOQ19TQ1JBVENIKTsNCg0KICAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKCEoc2NyYXRjaCAmIENTUl9GVU5DX1NDUkFUQ0hfUE9XRVJfT0ZGX01BU0spIHx8DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc2NyYXRjaCA9PSB+MFUpIHsNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgSVdMX0RFQlVHX1dPV0xBTih0cmFucywNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiU2NyYXRjaCAweCUwOHggaW5k
aWNhdGVzIGRldmljZSB3YXMgcG93ZXJlZCBvZmZcbiIsDQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc2NyYXRjaCk7DQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGRldmljZV93YXNfcG93ZXJlZF9vZmYgPSB0cnVlOw0KICAgICAgICAgICAg
ICAgICAgICAgICAgfSAgICANCiAgICAgICAgICAgICAgICB9IA0KDQpOb3Qgc3VyZSB0aGlzIGlu
Zm9ybWF0aW9uIGhlbHBzIHRob3VnaC4uDQoNCj4gSGkgQmpvcm4sDQo+IA0KPiBQcm9iYWJseSB5
ZXMsIGJ1dCBJIGRvbid0IG93biB0aGF0IGhhcmR3YXJlLCBvbmx5IHNhdyBnYW1pbmcgZGlzdHJv
cw0KPiBhcmUgc2hpcHBpbmcgYW4gdWRldiBydWxlIHRvIGRvIGp1c3QgdGhhdC4NCj4gDQo+ID4g
SSBzdXBwb3NlIHRoaXMgaXMgYSBmaXJtd2FyZSBwcm9ibGVtIHdpdGggd2hhdGV2ZXIgaXMgc3Vw
cG9zZWQgdG8NCj4gPiB0dXJuDQo+ID4gdGhlIHBvd2VyIGJhY2sgb24/wqAgQXJlIHRoZXJlIGFu
eSBmaXJtd2FyZSB1cGRhdGVzIGF2YWlsYWJsZT8NCj4gPiANCj4gDQo+IE5vdCB0aGF0IEkga25v
dyBvZi4gSSBoYXZlIHVwZGF0ZWQgbXkgYmlvcyAob25seSB1cGRhdGUgYXZhaWxhYmxlKQ0KPiBi
dXQgdGhlIGlzc3VlIGlzIHN0aWxsIHRoZXJlLg0KPiANCj4gPiA+IENsb3NlczogaHR0cHM6Ly9i
dWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMjAyMjMNCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IERlbmlzIEJlbmF0byA8ZGVuaXMuYmVuYXRvQGxpbnV4LmRldj4NCj4gPiA+IC0tLQ0K
PiA+ID4gZHJpdmVycy9wY2kvcXVpcmtzLmMgfCAyMSArKysrKysrKysrKysrKysrKysrKysNCj4g
PiA+IDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3BjaS9xdWlya3MuYyBiL2RyaXZlcnMvcGNpL3F1aXJrcy5jDQo+ID4g
PiBpbmRleCA3NTcyYjM1OGI1MGYuLjYwMTU2ZTZjM2U0OSAxMDA2NDQNCj4gPiA+IC0tLSBhL2Ry
aXZlcnMvcGNpL3F1aXJrcy5jDQo+ID4gPiArKysgYi9kcml2ZXJzL3BjaS9xdWlya3MuYw0KPiA+
ID4gQEAgLTY1OTMsMyArNjU5MywyNCBAQCBzdGF0aWMgdm9pZA0KPiA+ID4gcGNpX21hc2tfcmVw
bGF5X3RpbWVyX3RpbWVvdXQoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ID4gPiBERUNMQVJFX1BD
SV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0dMSSwgMHg5NzUwLA0KPiA+ID4gcGNpX21hc2tf
cmVwbGF5X3RpbWVyX3RpbWVvdXQpOw0KPiA+ID4gREVDTEFSRV9QQ0lfRklYVVBfRklOQUwoUENJ
X1ZFTkRPUl9JRF9HTEksIDB4OTc1NSwNCj4gPiA+IHBjaV9tYXNrX3JlcGxheV90aW1lcl90aW1l
b3V0KTsNCj4gPiA+ICNlbmRpZg0KPiA+ID4gKw0KPiA+ID4gKy8qDQo+ID4gPiArICogTVNJIENs
YXcgQTFNOiBkdXJpbmcgczJpZGxlIHRoZSBwbGF0Zm9ybSByZW1vdmVzIHBvd2VyIGZyb20NCj4g
PiA+IHRoZSBXaUZpIHNsb3QNCj4gPiA+ICsgKiAoRDNjb2xkKS4gVGhlIEtpbGxlciBCRTE3NTAg
KEludGVsIEJFMjAwLCA4MDg2OjI3MmIpIGZhaWxzIHRvDQo+ID4gPiByZXN1bWUgZnJvbQ0KPiA+
ID4gKyAqIHRoYXQgc3RhdGU6IHRoZSBQQ0llIGxpbmsgZG9lcyBub3QgcmV0cmFpbiAoIkRhdGEg
TGluayBMYXllcg0KPiA+ID4gTGluayBBY3RpdmUNCj4gPiA+ICsgKiBub3Qgc2V0IGluIDEwMCBt
c2VjIikgYW5kIGV2ZXJ5IGRldmljZSByZWdpc3RlciByZWFkcyBiYWNrIGFzDQo+ID4gPiAweGZm
ZmZmZmZmLA0KPiA+ID4gKyAqIHNvIHRoZSBjYXJkIGRpc2FwcGVhcnMgZnJvbSB0aGUgYnVzIGFu
ZCB0aGUgbWFjaGluZSBtdXN0IGJlDQo+ID4gPiBwb3dlci1jeWNsZWQuDQo+ID4gPiArICoNCj4g
PiA+ICsgKiBLZWVwaW5nIHRoZSBkZXZpY2UgaW4gRDNob3Qgd2l0aCB0aGUgbGluayBpbiBMMS4y
IGR1cmluZw0KPiA+ID4gc3lzdGVtIHNsZWVwIG1ha2VzDQo+ID4gPiArICogc3VzcGVuZCBhbmQg
cmVzdW1lIHdvcmsgcmVsaWFibHk6IHRoZSBwYWNrYWdlIHN0aWxsIHJlYWNoZXMNCj4gPiA+ID45
OSUgUzBpeA0KPiA+ID4gKyAqIHJlc2lkZW5jeSBhbmQgdGhlIGNhcmQgc3Vydml2ZXMuDQo+ID4g
DQo+ID4gRnJvbSBqdXN0IHRoaXMgcGF0Y2gsIEkgZG9uJ3QgdGhpbmsgd2UgY2FuIGFzc2VydCB0
aGUgTDEuMiBsaW5rDQo+ID4gc3RhdGUsDQo+ID4gY2FuIHdlP8KgIEFGQUlDUywgdGhpcyBwYXRj
aCBqdXN0IHByZXZlbnRzIHRoZSB1c2Ugb2YgRDNjb2xkLg0KPiANCj4gRnJvbSB0aGlzIHBhdGNo
IG5vLCBidXQgdGhhdCBpcyB0aGUgZGVzY3JpcHRpb24gb2Ygd2hhdCBoYXBwZW5zIG9uIG15DQo+
IG1zaSBjbGF3IHdoZW4gSSBlbnRlciBzbGVlcCB3aXRoIHRoaXMgcGF0Y2gsIGNoZWNrZWQgdmlh
IHMwaXhzZWxmdGVzdA0KPiB0b29sLg0KPiANCj4gVGhpcyBpcyBzdXJlbHkgYmV0dGVyIHRoYW4g
dGhlIHByZXZpb3VzIHdvcmsgYXJvdW5kIG9mIGRldGFjaGluZyB0aGUNCj4gZHJpdmVyIGFuZCBy
ZS1hdHRhY2hpbmcgaXQgbGVhdmluZyB0aGUgZGV2aWNlIGluIGQwLg0KPiANCj4gPiANCj4gPiA+
ICsgKi8NCj4gPiA+ICtzdGF0aWMgdm9pZCBxdWlya19tc2lfY2xhd19iZTIwMF9kM2NvbGQoc3Ry
dWN0IHBjaV9kZXYgKnBkZXYpDQo+ID4gPiArew0KPiA+ID4gK8KgwqAgaWYgKCFkbWlfbWF0Y2go
RE1JX0JPQVJEX05BTUUsICJNUy0xVDQxIikpDQo+ID4gPiArwqDCoMKgwqDCoMKgIHJldHVybjsN
Cj4gPiA+ICsNCj4gPiA+ICvCoMKgIHBjaV9kM2NvbGRfZGlzYWJsZShwZGV2KTsNCj4gPiA+ICvC
oMKgIHBjaV9pbmZvKHBkZXYsICJkaXNhYmxpbmcgRDNjb2xkOiBzbG90IHBvd2VyIHJlbW92YWwg
ZHVyaW5nDQo+ID4gPiBzMmlkbGUgcHJldmVudHMgcmVzdW1lIG9uIHRoaXMgc3lzdGVtIik7DQo+
ID4gPiArfQ0KPiA+ID4gK0RFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfSU5U
RUwsIDB4MjcyYiwNCj4gPiA+IHF1aXJrX21zaV9jbGF3X2JlMjAwX2QzY29sZCk7DQo+ID4gPiAt
LQ0KPiA+ID4gMi41NS4wDQo+ID4gPiANCg==
