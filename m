Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72A62D9796;
	Mon, 12 Oct 2026 10:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800306; cv=fail; b=cs7ugX7TI9rwyWEIs/baE1EPaRSOQx9XvwECWTr577lRwiy6cva+hXc2d/pO7NzVhwJLZN0k6SE2ItCZzql1sYOzuFy/r7kqfk5SRKDbdk8dpBJ+PQsrXz+9zUtdIOtPBjFrjAyXmnl+NGVC+AyojuIi9G0T54viN+jFH3u46hI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800306; c=relaxed/simple;
	bh=G2/09FQG206s9OnWQOzI53aSylYoqthQ8UEknGYrc6s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L+Zuzt8mJNMZ9bmBkwKqj0pFctnZyZHK5UYlrA2yeDBgC2ufGZRHWlprk5FvQx3g6hnTZqc2fAulGGxBZ4/SOIl1r7H5/hN0+7gPXs1ADIU47OJIXUIbEN9pc/FwXIprxQ+8O6Q4SZWMVkXs4O0ysuvxZwRYmWlJAlzilxQh1AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kv9V09Zj; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kv9V09Zj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791800294; x=1823336294;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G2/09FQG206s9OnWQOzI53aSylYoqthQ8UEknGYrc6s=;
  b=kv9V09ZjBnD7Dgz97vQqD43qdG2I0m1OMRJH/4s3st4SfTGACE0gilWv
   XgGmHWt29/9XQzOarpVBcdBkQi/+GpY69EVRfFt0iWDjlkAbCmDzU5qdI
   Nt5pSeH4xp0r37SZ+OuUgt+a5gwoVb66Fy3I4wzkK2cPrxaSWKY4af9M6
   XzLdX9xBglUdHEAm7yikC7rjZwU7ULOC9vMOjMvW+AZkQFWDU31svgzav
   BLSpNCZg7QmnKE6vvU5yq4kpIjcfq95bPHzbaS+LekxtBtpkdb+V/5hx2
   3c3Z/+uYXC8rUNRnHrACvPEivx2arN4P2GfLvAo7x1EPvjF3zpDNIQJ7v
   A==;
X-CSE-ConnectionGUID: wEYVCaW9Rd+e3l/6maKYqg==
X-CSE-MsgGUID: ytDl+8xoQfGzPQ8ZLJnAFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11932"; a="513694"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="513694"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 03:18:09 -0700
X-CSE-ConnectionGUID: Umz+q0qvQp+ouPIjNsYI0Q==
X-CSE-MsgGUID: aqV/27dtS76f+h8J6kJ/hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="840198"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 03:18:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 03:18:09 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 12 Oct 2026 03:18:09 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 03:18:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sERnEhA6qCJ9XwQRTh19iWs9RJovSJugvAjMq7g8sz9Hz32OZC5drQrwi6D2hxgpShNRM79KLSFdrEf4i0ZoTeTFDOLV97T1oO80nI68bCEVQSAH3WXK+9uETWtLnKI42yPM9OFwbyHMFe6vvveBRhrJ7TbLv9uFv4pHBHzl4Y0czUt1n7Vw4hJObhkWa/IBzJEuSg/rrEDJkhgN75IqclGWDtPFeNC9Uce4SkFUnKNxcVLCfZRkbTBPue2Mp0N81N3b9D2+37g4mlukfppcZLHJaDjWccWO7RLNzu5iSwS/AaLd1UkPSZPpW7nGT5oFqvKyyWqeuu/eqVDTg0Gwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2/09FQG206s9OnWQOzI53aSylYoqthQ8UEknGYrc6s=;
 b=TCtHMBgFEbVNGCnq6/qFlBcjWqS9L7nbb42Niqmkszaks2ibB0oLjWB8B877ecBeVkYPGsIPoIwvpSm7fDPIJqsYc1hFkzrCIuzHPZYq5lrC8xBhOcCqi3xtkZ5iM1L1etYmZHnNLj1C6Jgt/uOfrkgzTItvvm1GWDPX3xekiAmBaKfjFCqBkv1OMM8JRvR9dqXb/ZDvKyMJvR79GOi6Rpu/ag1LzcjzfZSVmfvZ6chiB9v+0Be//QY5vnFkfrTafpS1/dbZlv08b5tBSXJSd6Zr3+W4WQJMQKrnmqYjAHkeqkbpHyRmDO1/ja4Ak+BhbLgbT2TwhvqFptGVDQd3Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by DS4PPF691668CDD.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::2a) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 10:18:06 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0496.020; Mon, 12 Oct 2026
 10:18:06 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: "benthecarman1@gmail.com" <benthecarman1@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, benthecarman
	<benthecarman@live.com>
Subject: RE: [PATCH 2/2] wifi: iwlwifi: mld: Fix injected 5 GHz legacy rate
Thread-Topic: [PATCH 2/2] wifi: iwlwifi: mld: Fix injected 5 GHz legacy rate
Thread-Index: AQHdWGED1e+0g1n2C0ajtWD33unYxrb5tGGA
Date: Mon, 12 Oct 2026 10:18:06 +0000
Message-ID: <IA3PR11MB721313DDD0AD2D12E04E07FB5FA39F2@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20261009-next-v1-0-b370f5302d27@gmail.com>
 <20261009-next-v1-2-b370f5302d27@gmail.com>
In-Reply-To: <20261009-next-v1-2-b370f5302d27@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|DS4PPF691668CDD:EE_
x-ms-office365-filtering-correlation-id: 7550e2fd-9b30-4783-e825-08df284a1b77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|10067099003|22082099003|18002099003|38070700021|11063799006|4143699003|261009223027099003|56012099006;
x-microsoft-antispam-message-info: nf+HiS4THTQUJPEZdXaxylHnGUg1/e3VpgPds+hgEivS58UqPiGw1bnElPSh4pq6+1yfit00GdtrF87Pc+nu/lKM/x5P5SE0YEjI/EqzB8JYoYCCGv+YA3n84j8AwIQ4/Q/ZgyP+ef9VVNR+U4Iz0lvw0wM0LZ7qu6TfE8CKFRvl54gNg8ESl/U8fv75cTrB1yDrJE2s2PbupDcLwyA0XtjdqTkjY2jBRsB0TyGw1uWwrQIICDn9Z8hCJXijaFyqo31V68pudr4uXoC5Nqb+cUECFHvjd5sUoQ7FVYupg5idI9cDrDZx5MgOcVjxuI5zLee1dfsQM8ZWJPQ1QmcPq6X6Okmd0a/C5MkSon8naSGtFiU6Y5qEhkJ3GS2JDYdLsm/tFIaYoOXwZAUvOWpuoU9hgi2z5z76iWSu1se/UxwsPKaf8htply15DU2sxC6LeposRD7S4lbxb8S7ZXnn8tYzIql92eg4ZmbFPSE77OX2yZdgSq1TlUSQezkUTw106YWCZT4AQSF2Grn5GIhsnhdFD9qwaZsOLhMuxZMPPIngTn5vZvWyRVGgVuagaQDkF2UcbeUHHcRjJ7F0IXV0VOs/0H8Lwzh6HsXWJhHEiQhyp3G0lN7GBSzO+GxGwLtN+VBhUDliQYgya/tQfNOg1163alPEaN0SFFE95wTJ9kKqcNabJJKOOR4wLWY8M5jj4pgny1Ukr4wXZdYh4pthPp8oCEb0/4oWrVRCcJEE9NM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(38070700021)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlI5Uis1RXZBQkJpazM5ZDdFOXpYL09JSUttK0JNZGkybjV1emIyUzRrSFl0?=
 =?utf-8?B?TkJMTm51TkRaa0ZZMW4zaUJ1WmRUQXcrMDVLSkpBRlp4MFQvZ2o4V00wSExw?=
 =?utf-8?B?VVVkNmNYU25QSW5GQnh5cHliaHMzdkxEeGJqTTM5OFdmSTVHcVFQY0tlR2dK?=
 =?utf-8?B?WFJuUjIxdyt5ZFBVQUhtQjFUMXpEcVJ5cHFzQnpRRlNwb2tSQ1VjUktKaUx6?=
 =?utf-8?B?SVl3ekE1cS9EcGlxOG9qZG5PSU0xRGs3RW9qNHpkYkRKcjNvdHJNdEhCY1ZU?=
 =?utf-8?B?NTF0SVZXNFVKempkRUNzUHMvcFBBTEczbTdiZGpWOGgwMXFSNXRMTjhkN1ZP?=
 =?utf-8?B?bk4vNkVRSW1qdXhuSXpLSmEwWVlpMW14bXA2bDJseGdKUzgvQVQzdWZjRzdO?=
 =?utf-8?B?UUdGa0RuZlRkREhmZ0Z3cW5EVVpzOXhhMkdLd3BCOEEyQVNxZHZQTW0wN2pC?=
 =?utf-8?B?d3FjSHY3ZnZUN1JBNHRZTDVQZmZzNE04TG85VEM4VTY2RXhyOUFtditwRWln?=
 =?utf-8?B?ZVJoVnZFcENzZmxadzlzV3pEMVltaDJ5UWo2d0t3bXpMS0lqaWxaeExwOU5z?=
 =?utf-8?B?K0ZJdDJ4M3AvM1pNblZaNXp5Y2RzYzhXbGkySlI3Z1hrT1psU2xvbE5IU0Iv?=
 =?utf-8?B?SVdYMnpjd016SGdHbUJqOXRXdVExK05BSE9WRUNPcm1JMXIwa3N3bmZiV2JJ?=
 =?utf-8?B?bS9uN2FXKzFnajJ0N2EvWjc0alpZSEhnV25uRVpxekVzdVdvU1NkUk5vendU?=
 =?utf-8?B?SVA3UmxTYTVDQjVZdlhQdGRDWjNubUZQQmp6eVJaSkhxRU83eDVKcFdDQnJY?=
 =?utf-8?B?c1dldFpmTnRWcW1rek5FUW53b2RkUzM4b1dCQm1IM2ZUakZtU2twQW5OWUV4?=
 =?utf-8?B?SWhBTHRTc09jSWdpNnVJdm81czlKb2ZEaWFGUHhJVmI2dHd2QlhmTFFjbFpV?=
 =?utf-8?B?ZGxXV2FPN25KTHlPSlVsaGRwUTc5bmtkWXE1NTcveTk2Si93TFZ4bkdmanhE?=
 =?utf-8?B?Wi9lYmlJVXpWbGZsQ0U2SWtUOHNOaTJtU3p6b0wrRTNTWnNzakU5c1hIbUZp?=
 =?utf-8?B?dUIxem02YlpoSUsxY3AvQ0lYZUpISVdpTDBDME1tUWRQZ08vZExnMEh4ZHpx?=
 =?utf-8?B?Y05jM0xsTk05V1NVc3h3SFZINnhITmZjMWpYbEhLYTVOaWtVcEVMVUlxbFJm?=
 =?utf-8?B?dTBORnJKQXI0b2QzZFl6WTVBVUpxUUVoSFcyK3JOODZsb05hTGlyYlU2RlVV?=
 =?utf-8?B?ZStGTjFHN2JHcTFhSFhuOVlYN3FpUVlPUEhFRWJLZlB6YUVmbEtLaUVZOHNR?=
 =?utf-8?B?cElmQitHY0hldVFWYWpVaGdRYU9sM0J2THlxZEpkY214ZDMxZEdmWjY4NTdw?=
 =?utf-8?B?MGp5bFV5c096cDVqOGlPMGZEb1dFaFQvWjFLWUUzTjFrbjZFVEZjUU1Bei9L?=
 =?utf-8?B?anp3cXpSQUUwemU4NjAzTnpydnU4aXBZVGdaR1R2SXhGd0JZUDlTNElxSGJO?=
 =?utf-8?B?aFFKNWp3SnJ6TzJBV1lleWgwbFV5eGNZajFSUGtDSmpnN3RQNSs4ZXRYVTR5?=
 =?utf-8?B?UjhYaWtYYXdOWk4yM2tuUFVMSE1mZlhxL3gyMEQrN3dxY0dqSzVHbFZxUHJt?=
 =?utf-8?B?QTc5OExXYUhHendQSVZZdXd3aVY3R2lJdDNQMEJpdFNIUGgyZXkyUk9XbUZR?=
 =?utf-8?B?bHhVOS9aUmZhaWZCb1g2bUZqbEMzbWd0TzZMcEwyNjFtZ082REZ4WkxZRkZz?=
 =?utf-8?B?YnNmYVJ2MTlWdTNyRDJhaDBWSmtNK3JjZWwvOFFOeTBCK2UwQkhXb2oyN3BU?=
 =?utf-8?B?VWFTc2toN1hGQXdvbWxEY3lvRXd1Sy85d1RLcGhEV0xOV3hQSS81SDc1dGZJ?=
 =?utf-8?B?OVJ6OXV4N3VFbEJpb1hHd3BVS1hwd3c3RGZ5b2dsYlFZL0FGYVNOYWl1eGpI?=
 =?utf-8?B?OG0zckpsdElmUXE2d0FNdUdLSDhuZGliK2lxY2lUWWFQWnpHSkk3VGxXamFH?=
 =?utf-8?B?U0NmcWxXUlBCWnZSTnc4NG5QZFVhQ1ZaNGZFc3ovcDNGY2tEVnhQVXY1OHEv?=
 =?utf-8?B?OU1INmZQQjVCWVNDTVRSQW81dEgwVldnb2VQWm1RN21CZEVUQ0dweWY5L0Zi?=
 =?utf-8?B?RFJNZFBuUHhVTlZZbzdFV1hPUGRUS0JTTk5CMGQvNDBFZ0hUWWZTUStPaFd4?=
 =?utf-8?B?NUNyRGFINVdHbmcvZTJMZjJKb3lzY1hmR21KVXdIaE4wN0tUaEJaeXA2RzNV?=
 =?utf-8?B?ZDl3aHZ2dXdHaTZqdGc0TFQ2S0FLNFo2ZnhScWZsSU04bGR3YkpOSmdtSU42?=
 =?utf-8?B?VUtXckpxU3JxVU11WUlZSDJxWEFybG5ERFRlRG8rQkV6dHFYL3FZOTR5djQ4?=
 =?utf-8?Q?+rMG9cBF7tLAmf2c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: rMBlLG7wHaCGgP4OxNIY88Rp40qZVb4e/ng1G03KnzRm16uvlpHLKWC6C0eoM4962LNOmkHyRNLXI14X+NqEX3Uib9LPkRcZ+dgqsTow55vr8nGiWDQEbv38OIHIrhopBihPzQyCD3rGULAQRIWbIdxuYs5YwU7R9A4gGhhfe6Yv3itBAeO3kMg+gqU5QcRr8N1yLpxzUlp8GFEoXKBwzkhYffFsL/krVK04iiHIZ/3ZcfS8LyYtmgypaAU3AZYya0h3/PE1UwUOawPWUYTNJIGV55JlWveGQXJCFXykBxfoxp8V4w7Fa/lpp/2T2SrRL48QuF1+TADuKaPP7clgQQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7550e2fd-9b30-4783-e825-08df284a1b77
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2026 10:18:06.3192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9My00AAGerbOStOne+CMzqQfPp57Iw5N3mRfVaZ+wvH8jUmTgHobIgmyi8MK2z6ggC6lkMAQZvZj5768EDSPkMM4/Wp0hwGZe1QcYfDPh3Ghi4vN7668Daf0/0pQYh2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF691668CDD
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogYmVudGhlY2FybWFuIHZp
YSBCNCBSZWxheQ0KPiA8ZGV2bnVsbCtiZW50aGVjYXJtYW4xLmdtYWlsLmNvbUBrZXJuZWwub3Jn
Pg0KPiBTZW50OiBTYXR1cmRheSwgT2N0b2JlciAxMCwgMjAyNiA1OjQyIEFNDQo+IFRvOiBLb3Jl
bmJsaXQsIE1pcmlhbSBSYWNoZWwgPG1pcmlhbS5yYWNoZWwua29yZW5ibGl0QGludGVsLmNvbT4N
Cj4gQ2M6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+OyBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IGJlbnRoZWNhcm1hbiA8YmVudGhlY2FybWFuQGxpdmUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0gg
Mi8yXSB3aWZpOiBpd2x3aWZpOiBtbGQ6IEZpeCBpbmplY3RlZCA1IEdIeiBsZWdhY3kgcmF0ZQ0K
PiANCj4gRnJvbTogYmVudGhlY2FybWFuIDxiZW50aGVjYXJtYW5AbGl2ZS5jb20+DQo+IA0KPiBp
d2xfbWxkX2dldF9pbmplY3RfdHhfcmF0ZSgpIGhhbmRzIHRoZSBsZWdhY3kgcmF0ZSBpbmRleCBm
cm9tIG1hYzgwMjExIHRvDQo+IGl3bF9tbGRfbWFjODAyMTFfcmF0ZV9pZHhfdG9fZncoKSwgd2hp
Y2ggZXhwZWN0cyB0aGUgZHJpdmVyJ3MgcmF0ZSBpbmRpY2VzLg0KPiBPdXRzaWRlIDIuNCBHSHog
dGhlIG1hYzgwMjExIGluZGV4IHBvaW50cyBpbnRvIGEgYml0cmF0ZSB0YWJsZSB0aGF0IHN0YXJ0
cyBhdCA2DQo+IE1icHMsIHNvIGEgMTIgTWJwcyBpbmplY3Rpb24gb24gNSBvciA2IEdIeiBnb2Vz
IG91dCBhcyA1LjUgTWJwcyBDQ0suDQo+IA0KPiBBZGQgSVdMX0ZJUlNUX09GRE1fUkFURSBvdXRz
aWRlIDIuNCBHSHosIGFzIG12bSBkb2VzIGZvciBmcmFtZXMgdGhhdCBhcmUNCj4gbm90IGluamVj
dGVkLg0KPiANCj4gRml4ZXM6IGQxZTg3OWVjNjAwZiAoIndpZmk6IGl3bHdpZmk6IGFkZCBpd2xt
bGQgc3ViLWRyaXZlciIpDQo+IEFzc2lzdGVkLWJ5OiBDbGF1ZGU6Y2xhdWRlLW9wdXMtNS01DQo+
IFNpZ25lZC1vZmYtYnk6IGJlbnRoZWNhcm1hbiA8YmVudGhlY2FybWFuQGxpdmUuY29tPg0KUGxl
YXNlIHVzZSBhIHByb3BlciByZWFkYWJsZSB1c2VyIG5hbWUuDQo+IC0tLQ0KPiAgZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tbGQvdHguYyB8IDExICsrKysrKysrKystDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbWxkL3R4LmMNCj4g
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL21sZC90eC5jDQo+IGluZGV4IGZj
NTAxYWMwYy4uMzE3NTczYjVlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9p
bnRlbC9pd2x3aWZpL21sZC90eC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvbWxkL3R4LmMNCj4gQEAgLTU5OSw3ICs1OTksMTYgQEAgc3RhdGljIHUzMiBpd2xf
bWxkX2dldF9pbmplY3RfdHhfcmF0ZShzdHJ1Y3QgaXdsX21sZA0KPiAqbWxkLA0KPiAgCQlpZiAo
dTMyX2dldF9iaXRzKGluZm8tPmZsYWdzLCBJRUVFODAyMTFfVFhfQ1RMX1NUQkMpKQ0KPiAgCQkJ
cmVzdWx0IHw9IFJBVEVfTUNTX1NUQkNfTVNLOw0KPiAgCX0gZWxzZSB7DQo+IC0JCXJlc3VsdCA9
IGl3bF9tbGRfbWFjODAyMTFfcmF0ZV9pZHhfdG9fZncobWxkLCBpbmZvLCByYXRlLQ0KPiA+aWR4
KTsNCj4gKwkJaW50IHJhdGVfaWR4ID0gcmF0ZS0+aWR4Ow0KPiArDQo+ICsJCS8qDQo+ICsJCSAq
IG1hYzgwMjExIGluZGV4ZXMgdGhlIGJhbmQncyBiaXRyYXRlcywgd2hpY2ggc3RhcnQgYXQNCj4g
KwkJICogNiBNYnBzIG91dHNpZGUgMi40IEdIejsgcmVtYXAgdG8gb3VyIHJhdGUgaW5kaWNlcy4N
Cj4gKwkJICovDQo+ICsJCWlmIChpbmZvLT5iYW5kICE9IE5MODAyMTFfQkFORF8yR0haKQ0KPiAr
CQkJcmF0ZV9pZHggKz0gSVdMX0ZJUlNUX09GRE1fUkFURTsNCj4gKw0KPiArCQlyZXN1bHQgPSBp
d2xfbWxkX21hYzgwMjExX3JhdGVfaWR4X3RvX2Z3KG1sZCwgaW5mbywgcmF0ZV9pZHgpOw0KPiAg
CX0NCj4gDQo+ICAJaWYgKGluZm8tPmNvbnRyb2wuYW50ZW5uYXMpDQo+IA0KPiAtLQ0KPiAyLjU1
LjANCj4gDQoNCg==
