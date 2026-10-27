Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793088478;
	b=eki53YBpc/Vr9f8rNY4FvHgAbsuxSWpq+Ag+KTshR/JgbF7ld2j9Rl63D+mx3Gi1/ICp
	 B8Syd3qzgUzMxXkR0XY8k+JyiB1pAtLpS4C3Qh8JdurdFoQGSUkCy0MxNUh8UARBJnCHL
	 hxu0dU54qGzuC9Fc+arR+K3kFjsyIok0Atw8RhFDjPWLS15O7CTifc2E3LdFdunf8Njlz
	 V/QW/9nNrUamklABITccuihgRgTXkyKEB+ghd1sG88L49HbvSWrq4NOhGA1gHlZsaYH78
	 K0Dp2COQNU1gIgzEXst3K4GYA/mhHj3rb2s3Gd9HtIOWeklP4Hs0/9p4uCaRsdoPn5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088478;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=ZgQDe+8xFlV/T+vP2As+/iJzGF+aSk5vMM10JzO8VNQ=;
	b=RczkHz9l3S6iy2SfbXH0hf+ZmXVOzvur9+W4Tt1qQa9nPP2cRI7uwRobKbBALGBP8bs9
	 dvQdkERhKaXsXc/u+genzNkZMcQCWNdze+UX0vz3wBZc/G5XDVhw/Y94xVj26sQ+gksNr
	 BlBq57B9HCTGcBT8N0EvN9YOdAAokjiiwK5T92RuNSbdxeIPrr9ycnZnW7BEnrJeAFAXm
	 vtsn6YtojDLBoNncOgHpwJbjJV//da1MW4Cb3dQpDiNrJO6ywSMttM7hcOha7NG8oNAfy
	 M0SjWiTjJm3pQ0ouv2l0vp8opu+Z3XQs+FEl4JNlWiA3zvB5SqMAT7/UJ3nFqC8tc+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="BX/WuBzY";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26920606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26920606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BX/WuBzY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793088477; x=1824624477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZgQDe+8xFlV/T+vP2As+/iJzGF+aSk5vMM10JzO8VNQ=;
  b=BX/WuBzYBS/I6TsGDl0m4ETKHCPazboZfbs2N88NbsGAQ9uFeJiT1MqQ
   zmZaDBVsaV2LAoq4cg4MT2pQ9ev8ln1ME4zQVezAA0fuZcxFFsguthe2/
   xTsubtPCNSFib+PZRdX5pzbhluuUuWzYiEP6YY5z9TIzxCjEhdledJB1x
   cnOLtIyT4+S3O4TEoABUse0ngxEseBOhRaEYplt4Ap+505Bzwfx9DvB7+
   UhmT+WCcCyfAeLLODPUs7Wrqgow0Fs4Y5NuMXxC9marHIGlR4gHjTv5nT
   0MApJq1uBrpVX9JbYLDZYdoU6Uly11j54c05ulyBhAFR+M0Ke9pLWfZwZ
   A==;
X-CSE-ConnectionGUID: FDG1WO2NSs6+yJoJd3206A==
X-CSE-MsgGUID: A+LuckHjRTaYwdnIvYif1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1658604"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1658604"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 01:07:57 -0700
X-CSE-ConnectionGUID: IALQYM7XS3+yBqHfAjO2zw==
X-CSE-MsgGUID: yC8TR2FxRqS6B0vA8sQCIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4598050"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 01:07:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 01:07:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 01:07:55 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 01:07:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsZ+rYVtWK2fqF+P/QVfaswTA7k6JTHCckj3wz8bFJJqIKAkICu6NINEjoq8Iysn7v63iKz9fqSpdEOsniRIdpDhR81jJF2i+oqHPjASdhsukS6MLEviBfqR+VCgrw4JknlDQAEy1Uavw2250+9SbDkmZOuH0BRdJEteQ1E2q/E42hMo++xuUcyUsbWywVJsSekS34J3mWfiN6W/cy/jNU1LJkCSKGOLGn2hfX2h85LiCk9+OXN+nqq29Ngq0cjv7vAhjFGSKyZvsGqybBKvW9d4p9rsI/62JPrcT6Mrh8wQVK6DHureyMbTZ96qlGn8es2/9jOUs+8MbUXGnV+Mhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgQDe+8xFlV/T+vP2As+/iJzGF+aSk5vMM10JzO8VNQ=;
 b=gS2Zdgu+QPmkqddfOpDADmEKTEjYTnz/dGSRku6x/3ydy+6Gy9g/tb+VIv73iHFO4R7hWQCqxv/P13ZC38HzSSFREiRAkx1eQL5hvjJ9TXwY9zZKDj7tuR3IZW3jntw9SQTqJVp5GeAi/bIlBkP1rICeuLP8vFrOvL7IblyR7xImw7QYFPJJVZUWL/hMpcNYcuqbV+T+PqTl600dF++WCKFDdu18TlLp5xvL/BzjVfhI2q3UduXNWBqqVLftkiJwLERa3KHoxljhC4iUT6RIKeOOIzJGbNfPQ1OpkOzZaoGyN0D5UTVjtR56qSb/E2b9ythdXN02/l/CYro3/kzY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 (2603:10b6:208:626::22) by MW4PR11MB7031.namprd11.prod.outlook.com
 (2603:10b6:303:22c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 08:07:52 +0000
Received: from IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805]) by IA3PR11MB721313.namprd11.prod.outlook.com
 ([fe80::ece9:28d9:25bf:5805%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 08:07:51 +0000
From: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
To: Thorsten Leemhuis <regressions@leemhuis.info>, "Grumbach, Emmanuel"
	<emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Linux
 kernel regressions list" <regressions@lists.linux.dev>
Subject: RE: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-channel
 320 MHz regulatory flag
Thread-Topic: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: honor the per-channel
 320 MHz regulatory flag
Thread-Index: AQHdUL1a9virzEDqhUCE0e/wso1R1LcRL36AgAADIAA=
Date: Tue, 27 Oct 2026 08:07:51 +0000
Message-ID: <IA3PR11MB7213131F7C0C0D8D69A0A80E6BA3602@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20260930122439.f8a1ea3af242.I282fab02ab2f183633df0f070229fb5a2d5c9ec3@changeid>
 <20260930122439.08094e4c344f.Ic0a4bf544fd6ebaf1fc62b40bf463bd289e58cf0@changeid>
 <9a92165c-93dd-42a1-b61c-b494008f45b7@leemhuis.info>
In-Reply-To: <9a92165c-93dd-42a1-b61c-b494008f45b7@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB721313:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: 734efe63-50ad-4dba-b5a6-08df340165c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|22082099003|18002099003|261026121527099003|11063799006|56012099006|5023799004|4143699003|10067099003|261022113327099003|261022105027099003|261009223027099003|261021121427099003|261022075727099003|38070700021|261021123027099003|261026140227099003;
x-microsoft-antispam-message-info: CIcoLuV4J0PI1MpQcXepo7nfg8ROXfB6bPaNn1GDCefpCO5bqbZ/HE5YkCWfQJ4g5G3STQzY+Sv8nqRgobRAewSJfWpd2xGoF2aMWBb7Kg3EffV0W3HrcckLwbWdnwisXK7zZCjCcvg22nVvDPgBzE3Qftf13csP3B9wZdJrkTCBbcU+T8Yrlcg04uqk+sHZOz23yOxReTk9yX6OGPCZSA45lTZZPcxD272GS2hYviqilXWQT8epESlncYdfq/pnQebkjKLC/O6nxpA65jzceLfmA6LmmQisg4o7dYoiYCiPbxIGMANqIcaiYJPLWSSP3luhFbvAdVBHbRmLWHJ/QMtotOxZHKMAgXShWOo32iHpbN4SfPMFpVpI30x2uQsd3Ofj8PThDqHJYgVOHXKSZpjumM3TRyqEJtdbjGlWe+UZ3vKAa4REnZvQ+UulaWgjEewHodg37THsYY9IQEbNAJT6wigjPCKb9/GMO8+cP4Pte/w5RPXkBiTWx8EaNXhqlL3UPMYUPMYtH2PWl/+PBIFlHnMw3sWF/CZ0CPbUTsBecVbjO+LEybEJbV7mhBMS8XA3WftQjgsN+bAVR9xGVIE6IgyrDmcERqp9/5a/i21E1MsklNYyO0LlkHRPWClzN0ogiekb7LJRbcHTIIyWQTlC0TjSlOc7cM8NFmNvGyiv3bXzWdUQOLeqAcrWEnoe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB721313.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(261026121527099003)(11063799006)(56012099006)(5023799004)(4143699003)(10067099003)(261022113327099003)(261022105027099003)(261009223027099003)(261021121427099003)(261022075727099003)(38070700021)(261021123027099003)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0FOSUZXeEFCOStFL3dBQVYvVVhlRXNtdTR3ckltU2lVYVMvNm9XbDFJVy80?=
 =?utf-8?B?UFdXRllMWFFYMDU4Y1RaOHorclRYNFplVlQ2bVowOWJXd0xjdGFJMG5GYnlu?=
 =?utf-8?B?TkM3U2RKV1UraUUwWEREQTU4b2tpUktoYTJLRVBjTEx5a0tlQ2NuL3pEMVZs?=
 =?utf-8?B?N1JOU3Nwd0I2QVlxdjlOQ0Q0aTJiNjUzSDROaUNOSExHRFhZNDFMbzBtZFhy?=
 =?utf-8?B?R2c0NmV3T0JKc3k5L0YvVkMweCtHS2lzeWI5b1l6QVhaSk8yQmFhbkxha002?=
 =?utf-8?B?RkhiamlNRlNKSW91MUZvdDZRRmVHN1NoakEwcGlQTWE5NzhUVUZXMGRYUU0x?=
 =?utf-8?B?MTZ3SGwveWZjYkg4SjJNZVMrMlRVMWdnOHp2UlphU0QxMGF6MGgwbThqRGNn?=
 =?utf-8?B?NXFYRjFjUnROTUlLNjBJTFhrTjNNSlFYb1FBbGdNWVpsUk1wdEd6cHJZM21x?=
 =?utf-8?B?R05vR0hDVE1CMWo5eUVZZElQSzViVElHM1BBTmhaWjltdnc3cU53SXYvSkdw?=
 =?utf-8?B?ZWJOaHJNWWFJT0lLdC9FZUMrc0Z4ZmpXQ2gvci9RQTZyQ1FzaERUN3dzbXlJ?=
 =?utf-8?B?U1ZoM0FVMXk0VW5GUHlJYUd1SkphV3dYU0lWbWppSzloTjBjVENlNFUvbkE5?=
 =?utf-8?B?TGMrcGJWajJCMU95N0RYOXZXS2pMRVZOY1grZzJrcktZcHI5aTFaRVdmTGJS?=
 =?utf-8?B?UlVhUjV6NGc2aktOMWlURkVuVjJ0czNJWDJ0THBMOHg2TmVnSjhNY0UwNXow?=
 =?utf-8?B?TzNpNWtDUlM3R29Bc1ZLdGRTUTg2QXM2QnVHNm5GYUNoYXZkbU85K29FV0Zi?=
 =?utf-8?B?Wmx3K3YvVmtOMnlBdUlCby9vQnJsbkxIMllNcWlqR3haQUhlemFXaS9neWdD?=
 =?utf-8?B?RldrU3R2SDNKa1NxZmZVZXp5R2ZKNHhRQUYrMG1UNCtPZjhVSHM5WHJBL1VH?=
 =?utf-8?B?cWdSc3dOSUxIYnRtQTFKMUhjUXJSN25RQklBRVpNVTVBdDNFTmhTVitMQ1Ba?=
 =?utf-8?B?L2JwaHJ3a0l6Mm1RQi9LYi9uYlNSYkh6MThOYWNQYW5xcGhNdnhSOWUwR1JI?=
 =?utf-8?B?MzRHY0xnTDVLVnZjTHFtY096UVkrK0pkZHl6Tkxvci9MdXRNcmxxZ2RscEl4?=
 =?utf-8?B?UnhpRDZ5Ym9va1JuUG1qVmtwU3hET01qQUpQN1VtakRhS2c2L1hmTm02MnVZ?=
 =?utf-8?B?VytmbFNVQzJ1RW0xaW1WWldKdWd6Qnhqck53SXRwZnM4MW0yblFzb2RXNk9r?=
 =?utf-8?B?V3M1TVNvYkJSRGErTlYrWGZMU05GaFJkRUtQY3Q5V2k3ZkNzOThreTV1cW1B?=
 =?utf-8?B?OUVyOWFUaVpJQUp2OUliWVp0WEl3ZEJ3NGRVVDQrbHB5WDVoWkEyVnJhV3Fv?=
 =?utf-8?B?a25TTFhRcDd0ZHlxcHZLaEhxNzl0cStQTkpzUElkNmNyd3hwSlBEMnpjOUFV?=
 =?utf-8?B?KzdtQ053L3lTZnVIbUcyWEU2M3B0eS9VOVZJejVhL2N1SnpTT1MwcmV5TnY1?=
 =?utf-8?B?ajk5dnRqYjdoL29vaXhJclFIeHAzb3UwaTM5K1FvNnhwUlZSUlViUGNOUGVs?=
 =?utf-8?B?eEhHUFYrN3Z6YXdmZmQ4SXB0ZGRtZEh5ZVA2TktuWDRWUmd1Q3dLUGZjdHpx?=
 =?utf-8?B?UDQ2TS9BcS82WVBwS0dmUXFJdXdpNmNSQWxyT1FkelVwbzMreTdmbzBsSC9k?=
 =?utf-8?B?cG1Bc3lhUk0vbXg5UE9WeGVTeUZ5dVV0MnJ5VWY4V1F2bVE3UkJySXdXdjhH?=
 =?utf-8?B?WDlqQnFoV0Vnblg5bUUza3FHanZjVGJ3NGlmVTdObG5FeTBqUWpxYkl5UTc3?=
 =?utf-8?B?Y0ZEamUxa3lzNERaVjVvZ2E2K21NbEpzTFFPbkVDa3Njdkh6TnBZd1dqRHY4?=
 =?utf-8?B?QXQ2K1hDSFRIK1F6cjdCVFVMbVVsZUE4cy83RFVEUG5mMkFOSmxNRXUrZHlX?=
 =?utf-8?B?SE5jTTIzalFOenM5eDZEb1o4aEdteWUwazkxZTNjNW5ZWjI4UnFVZmgzcWxm?=
 =?utf-8?B?RVRsT2I3SGdJcFVqSzZ3SGZSK3MvT2ZIc2ZiZGc0b1k5TmROOVh6NlphZGdD?=
 =?utf-8?B?V3lVWHB3bURSNkRNODc0ZjVYYVFJcWErZmhuU2Q0RDdIT0hySEVXcWJ5akFN?=
 =?utf-8?B?VDlTWmg0SUVQaVlUZ3FuOXVva2IxbXBUQk0ydzlJc1VlSGN5MGlaNVAwZ21S?=
 =?utf-8?B?blk3UkZTK0hFVU9SVG92VWJsbmlpeFlIclpIbVhENUUwb1QvOWdVOGQ1UDk4?=
 =?utf-8?B?SmY0b29pYlA1WXE5K0Urb2pqRUpjcFRmYVpxeGlHRnVoOE5uYkFKSWQ2Z1dp?=
 =?utf-8?B?b0ZOY3JxVTJodTlZRjNncEFNNUFPVU56NExXeC8zYzZJWTA0QTBOQ0ZTaXZo?=
 =?utf-8?Q?1Vbsc/3n8u7cO9Bo=3D?=
Content-Type: text/plain; charset="utf-8"
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
X-Exchange-RoutingPolicyChecked: dEuvRA1z4NHBoSH6vf8TCXOI4veifM5jLcY4HOXGfZFvqG0RWI1bad0R+8uoi3nybyqpcpr+Addj7oDl+0bjoSXxAa+2xLuKnDj9TmITiJaeyQ7b7svgkU3U8bgy4wYDLWREtj83fH0ggk+mhhjAIi0nkqtiiVHoJNR/uP/Y79qs76AfxNiZA+IFvd32ADGcD/ncP57zM3lEhjLSzDnXX8g5trs98ZAsurVRUVfKNknIWZxN6Ch3UEmd+XUsYP3/A7zzmV8ggFwJPLXc7tqznKKchDAS7cTnSeBa2t4hwx5EylU69v5gAC/6g+rP5arDQAfn6SSbqJm4++rExrhHuQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB721313.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734efe63-50ad-4dba-b5a6-08df340165c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2026 08:07:51.6737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UPT1Ze4Ul0GUiRMUju1ad0peJjuoaYP/SddzlZWEz0sT5vWQ8O+bCYDMY28bU5N/FQ4rrg5HOh0rEr8KMwZZe+xm9HYurQ+2N+rmIUjdWowoYJSi4Vb1IQ+fS3mhirSM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGhvcnN0ZW4gTGVlbWh1
aXMgPHJlZ3Jlc3Npb25zQGxlZW1odWlzLmluZm8+DQo+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIg
MjcsIDIwMjYgOTo1NSBBTQ0KPiBUbzogR3J1bWJhY2gsIEVtbWFudWVsIDxlbW1hbnVlbC5ncnVt
YmFjaEBpbnRlbC5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IEtv
cmVuYmxpdCwgTWlyaWFtIFJhY2hlbA0KPiA8bWlyaWFtLnJhY2hlbC5rb3JlbmJsaXRAaW50ZWwu
Y29tPjsgTGludXgga2VybmVsIHJlZ3Jlc3Npb25zIGxpc3QNCj4gPHJlZ3Jlc3Npb25zQGxpc3Rz
LmxpbnV4LmRldj4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBpd2x3aWZpLWZpeGVzIDMvNV0gd2lm
aTogaXdsd2lmaTogaG9ub3IgdGhlIHBlci1jaGFubmVsIDMyMA0KPiBNSHogcmVndWxhdG9yeSBm
bGFnDQo+IA0KPiBPbiA5LzMwLzI2IDExOjI1LCBNaXJpIEtvcmVuYmxpdCB3cm90ZToNCj4gPiBG
cm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwuY29tPg0KPiA+
DQo+ID4gV2hlbiBzdXBwb3J0IGZvciB0aGUgTUNDIHVwZGF0ZSByZXNwb25zZSB2ZXJzaW9uIDgg
d2FzIGFkZGVkLCB0aGUgQVBJDQo+ID4gY2hhbmdlIHdhcyBpbXBsZW1lbnRlZCBvbmx5IHBhcnRp
YWxseS4gVGhhdCB2ZXJzaW9uIGludHJvZHVjZWQgdHdvIG5ldw0KPiA+IHBpZWNlcyBvZiBpbmZv
cm1hdGlvbiBhYm91dCAzMjAgTUh6OiB0aGUgZ2xvYmFsIGNhcGFiaWxpdHkNCj4gPiBSRUdfQ0FQ
QV9WNV8zMjBNSFpfQUxMT1dFRCBhbmQgYSBwZXItY2hhbm5lbCBiaXQsIEJJVCgxMiksIGluIHRo
ZQ0KPiA+IGNoYW5uZWwgZmxhZ3MgY2FycmllZCBieSB0aGUgcmVzcG9uc2UuIE9ubHkgdGhlIGZv
cm1lciB3YXMgcGlja2VkIHVwLg0KPiA+IEJJVCgxMikga2VwdCBpdHMgcHJldmlvdXMgbWVhbmlu
ZyBpbiB0aGUgZHJpdmVyLCBOVk1fQ0hBTk5FTF9EQ19ISUdILA0KPiA+IGEgbGVmdG92ZXIgZnJv
bSBvbGQgZGV2aWNlcyB0aGF0IG5vdGhpbmcgdXNlZCwgc28gdGhlIG5ldyBiaXQgd2FzDQo+ID4g
c2lsZW50bHkgZHJvcHBlZC4NCj4gDQo+IEp1c3Qgd29uZGVyaW5nOiB3aGF0IGhhcHBlbmVkIHRv
IHRoaXMgcmVncmVzc2lvbiBmaXg/IEl0IGZyb20gd2hhdCBJIHNlZSBzZWVtcyB0bw0KPiBzaXQg
aW4gaXdsd2lmaSBmaXhlcyBicmFuY2ggZm9yIGEgd2hpbGUgYWxyZWFkeSwgYnV0IG1pc3NlZCBi
b3RoIDcuMyBmaW5hbCBhbmQgYWxzbw0KPiB0aGUgbWFpbiBuZXQgbWVyZ2UgaW4gdGhpcyBtZXJn
ZSB3aW5kb3cuIERpZCBpdCBmZWxsIHRyb3VnaCB0aGUgY3JhY2tzPw0KDQpObywgaXQgd2lsbCBi
ZSBzZW50IG9uY2Ugd2lyZWxlc3MgdHJlZSB3aWxsIHJlLW9wZW4gZm9yIFBScy4NCg0KPiANCj4g
Q2lhbywgVGhvcnN0ZW4NCj4gPiBUaGUgdHdvIGFyZSBub3QgZXF1aXZhbGVudCwgdGhlIHBlci1j
aGFubmVsIGJpdCBjYW4gYmUgbW9yZQ0KPiA+IHJlc3RyaWN0aXZlIHRoYW4gdGhlIGdsb2JhbCBj
YXBhYmlsaXR5LiBXaGVuIHRoYXQgaGFwcGVucywgY2ZnODAyMTEgaXMNCj4gPiB0b2xkIHRoYXQN
Cj4gPiAzMjAgTUh6IGlzIGFsbG93ZWQsIG1hYzgwMjExIGJ1aWxkcyBhIDMyMCBNSHogY2hhbm5l
bCBjb250ZXh0LCBhbmQgdGhlDQo+ID4gZmlybXdhcmUgcmVqZWN0cyB0aGUgcmVzdWx0aW5nIFBI
WV9DT05URVhUX0NNRCBhbmQgYXNzZXJ0cyB3aXRoDQo+ID4gMHgyMDAwMTRGQy4NCj4gPg0KPiA+
IFJlbmFtZSB0aGUgYml0IHRvIE5WTV9DSEFOTkVMXzMyME1IWiBhbmQgc2V0DQo+IE5MODAyMTFf
UlJGX05PXzMyME1IWiBmb3INCj4gPiB0aGUgY2hhbm5lbHMgdGhhdCBkb24ndCBoYXZlIGl0LCBz
byB0aGF0IHdlIGNhcCB0aGUgYmFuZHdpZHRoIGF0DQo+ID4gMTYwIE1IeiBpbnN0ZWFkIG9mIGFz
c2VydGluZyB0aGUgZmlybXdhcmUuIFRoZSBiaXQgaXMgY2hlY2tlZCBpbiBldmVyeQ0KPiA+IGJh
bmQsIHNvIHRoYXQgYSBmdXR1cmUgYmFuZCB0aGF0IHN1cHBvcnRzIDMyMCBNSHogaXMgY292ZXJl
ZCBhcyB3ZWxsLg0KPiA+DQo+ID4gRml4ZXM6IGU5YjYzMzQxZGMxNSAoIndpZmk6IGl3bHdpZmk6
IHVwZGF0ZSByZXNwb25zZSBmb3IgbWNjX3VwZGF0ZQ0KPiA+IGNvbW1hbmQiKQ0KPiA+IEFzc2lz
dGVkLWJ5OiBHaXRIdWItQ29waWxvdDpjbGF1ZGUtb3B1cy01DQo+ID4gQ2xvc2VzOiBodHRwczov
L2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIyMTY3NQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEVtbWFudWVsIEdydW1iYWNoIDxlbW1hbnVlbC5ncnVtYmFjaEBpbnRlbC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogTWlyaSBLb3JlbmJsaXQgPG1pcmlhbS5yYWNoZWwua29yZW5ibGl0
QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXds
LW52bS1wYXJzZS5jICAgIHwgIDYgKystLS0NCj4gPiAgLi4uL3dpcmVsZXNzL2ludGVsL2l3bHdp
ZmkvaXdsLW52bS1wYXJzZS5oICAgIHwgIDcgKysrKy0tDQo+ID4gIC4uLi93aXJlbGVzcy9pbnRl
bC9pd2x3aWZpL3Rlc3RzL252bV9wYXJzZS5jICB8IDI0DQo+ID4gKysrKysrKysrKysrKysrLS0t
LQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lm
aS9pd2wtbnZtLXBhcnNlLmMNCj4gPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdp
ZmkvaXdsLW52bS1wYXJzZS5jDQo+ID4gaW5kZXggODYzZDVlMzU4MTUyLi5mNGRmMDA1MTRmYjEg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9pd2wt
bnZtLXBhcnNlLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZp
L2l3bC1udm0tcGFyc2UuYw0KPiA+IEBAIC0xMDYsOCArMTA2LDYgQEAgc3RhdGljIGNvbnN0IHUx
NiBpd2xfdW5paTlfbnZtX2NoYW5uZWxzW10gPSB7DQo+ID4gICNkZWZpbmUgSVdMX05WTV9OVU1f
Q0hBTk5FTFNfRVhUCTUxDQo+ID4gICNkZWZpbmUgSVdMX05WTV9OVU1fQ0hBTk5FTFNfVUhCCTEx
MA0KPiA+ICAjZGVmaW5lIElXTF9OVk1fTlVNX0NIQU5ORUxTX1VOSUk5DQo+IAlBUlJBWV9TSVpF
KGl3bF91bmlpOV9udm1fY2hhbm5lbHMpDQo+ID4gLSNkZWZpbmUgTlVNXzJHSFpfQ0hBTk5FTFMJ
CTE0DQo+ID4gLSNkZWZpbmUgTlVNXzVHSFpfQ0hBTk5FTFMJCTM3DQo+ID4gICNkZWZpbmUgRklS
U1RfMkdIWl9IVF9NSU5VUwkJNQ0KPiA+ICAjZGVmaW5lIExBU1RfMkdIWl9IVF9QTFVTCQk5DQo+
ID4gICNkZWZpbmUgTl9IV19BRERSX01BU0sJCQkweEYNCj4gPiBAQCAtMjgwLDcgKzI3OCw3IEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCBpd2xfbnZtX3ByaW50X2NoYW5uZWxfZmxhZ3Moc3RydWN0DQo+
IGRldmljZSAqZGV2LCB1MzIgbGV2ZWwsDQo+ID4gIAkJICAgICAgQ0hFQ0tfQU5EX1BSSU5UX0ko
NDBNSFopLA0KPiA+ICAJCSAgICAgIENIRUNLX0FORF9QUklOVF9JKDgwTUhaKSwNCj4gPiAgCQkg
ICAgICBDSEVDS19BTkRfUFJJTlRfSSgxNjBNSFopLA0KPiA+IC0JCSAgICAgIENIRUNLX0FORF9Q
UklOVF9JKERDX0hJR0gpLA0KPiA+ICsJCSAgICAgIENIRUNLX0FORF9QUklOVF9JKDMyME1IWiks
DQo+ID4gIAkJICAgICAgQ0hFQ0tfQU5EX1BSSU5UX0koVkxQKSwNCj4gPiAgCQkgICAgICBDSEVD
S19BTkRfUFJJTlRfSShBRkMpKTsNCj4gPiAgI3VuZGVmIENIRUNLX0FORF9QUklOVF9JDQo+ID4g
QEAgLTE2MzEsNiArMTYyOSw4IEBAIHUzMiBpd2xfbnZtX2dldF9yZWdkb21fYndfZmxhZ3MoY29u
c3QgdTE2DQo+ICpudm1fY2hhbiwNCj4gPiAgCQlmbGFncyB8PSBOTDgwMjExX1JSRl9OT184ME1I
WjsNCj4gPiAgCWlmICghKG52bV9mbGFncyAmIE5WTV9DSEFOTkVMXzE2ME1IWikpDQo+ID4gIAkJ
ZmxhZ3MgfD0gTkw4MDIxMV9SUkZfTk9fMTYwTUhaOw0KPiA+ICsJaWYgKCEobnZtX2ZsYWdzICYg
TlZNX0NIQU5ORUxfMzIwTUhaKSkNCj4gPiArCQlmbGFncyB8PSBOTDgwMjExX1JSRl9OT18zMjBN
SFo7DQo+ID4NCj4gPiAgCWlmICghKG52bV9mbGFncyAmIE5WTV9DSEFOTkVMX0FDVElWRSkpDQo+
ID4gIAkJZmxhZ3MgfD0gTkw4MDIxMV9SUkZfTk9fSVI7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLW52bS1wYXJzZS5oDQo+ID4gYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2l3bC1udm0tcGFyc2UuaA0KPiA+IGluZGV4
IDllYmI3MmQzNzI2YS4uN2IxMTY4MmY1ZDQ1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLW52bS1wYXJzZS5oDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9pd2wtbnZtLXBhcnNlLmgNCj4gPiBAQCAtMTAs
NiArMTAsOSBAQA0KPiA+ICAjaW5jbHVkZSAiaXdsLW52bS11dGlscy5oIg0KPiA+ICAjaW5jbHVk
ZSAibWVpL2l3bC1tZWkuaCINCj4gPg0KPiA+ICsjZGVmaW5lIE5VTV8yR0haX0NIQU5ORUxTCQkx
NA0KPiA+ICsjZGVmaW5lIE5VTV81R0haX0NIQU5ORUxTCQkzNw0KPiA+ICsNCj4gPiAgLyoqDQo+
ID4gICAqIGVudW0gaXdsX252bV9zYmFuZHNfZmxhZ3MgLSBtb2RpZmljYXRpb24gZmxhZ3MgZm9y
IHRoZSBjaGFubmVsIHByb2ZpbGVzDQo+ID4gICAqDQo+ID4gQEAgLTgyLDcgKzg1LDcgQEAgc3Ry
dWN0IGl3bF9yZWdfY2FwYSB7DQo+ID4gICAqIEBOVk1fQ0hBTk5FTF80ME1IWjogNDAgTUh6IGNo
YW5uZWwgb2theQ0KPiA+ICAgKiBATlZNX0NIQU5ORUxfODBNSFo6IDgwIE1IeiBjaGFubmVsIG9r
YXkNCj4gPiAgICogQE5WTV9DSEFOTkVMXzE2ME1IWjogMTYwIE1IeiBjaGFubmVsIG9rYXkNCj4g
PiAtICogQE5WTV9DSEFOTkVMX0RDX0hJR0g6IERDIEhJR0ggcmVxdWlyZWQvYWxsb3dlZCAoPykN
Cj4gPiArICogQE5WTV9DSEFOTkVMXzMyME1IWjogMzIwIE1IeiBjaGFubmVsIG9rYXkNCj4gPiAg
ICogQE5WTV9DSEFOTkVMX1ZMUDogY2xpZW50IHN1cHBvcnQgY29ubmVjdGlvbiB0byBVSEIgVkxQ
IEFQDQo+ID4gICAqIEBOVk1fQ0hBTk5FTF9BRkM6IGNsaWVudCBzdXBwb3J0IGNvbm5lY3Rpb24g
dG8gVUhCIEFGQyBBUA0KPiA+ICAgKiBATlZNX0NIQU5ORUxfVkxQX0FQX05PVF9BTExPV0VEOiBV
SEIgVkxQIEFQIG5vdCBhbGxvd2VkLCBAQA0KPiAtMTAxLDcNCj4gPiArMTA0LDcgQEAgZW51bSBp
d2xfbnZtX2NoYW5uZWxfZmxhZ3Mgew0KPiA+ICAJTlZNX0NIQU5ORUxfNDBNSFoJCQk9IEJJVCg5
KSwNCj4gPiAgCU5WTV9DSEFOTkVMXzgwTUhaCQkJPSBCSVQoMTApLA0KPiA+ICAJTlZNX0NIQU5O
RUxfMTYwTUhaCQkJPSBCSVQoMTEpLA0KPiA+IC0JTlZNX0NIQU5ORUxfRENfSElHSAkJCT0gQklU
KDEyKSwNCj4gPiArCU5WTV9DSEFOTkVMXzMyME1IWgkJCT0gQklUKDEyKSwNCj4gPiAgCU5WTV9D
SEFOTkVMX1ZMUAkJCQk9IEJJVCgxMyksDQo+ID4gIAlOVk1fQ0hBTk5FTF9BRkMJCQkJPSBCSVQo
MTQpLA0KPiA+ICAJTlZNX0NIQU5ORUxfVkxQX0FQX05PVF9BTExPV0VECQk9IEJJVCgxNSksDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvdGVzdHMv
bnZtX3BhcnNlLmMNCj4gPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvdGVz
dHMvbnZtX3BhcnNlLmMNCj4gPiBpbmRleCA4NTM5MTE5MDBiZmQuLjVhNTA4MDdlMzE4MSAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3Rlc3RzL252
bV9wYXJzZS5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS90
ZXN0cy9udm1fcGFyc2UuYw0KPiA+IEBAIC0yLDcgKzIsNyBAQA0KPiA+ICAvKg0KPiA+ICAgKiBL
VW5pdCB0ZXN0cyBmb3IgTlZNIHBhcnNlDQo+ID4gICAqDQo+ID4gLSAqIENvcHlyaWdodCAoQykg
MjAyNSBJbnRlbCBDb3Jwb3JhdGlvbg0KPiA+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMjUtMjAyNiBJ
bnRlbCBDb3Jwb3JhdGlvbg0KPiA+ICAgKi8NCj4gPiAgI2luY2x1ZGUgPGt1bml0L3N0YXRpY19z
dHViLmg+DQo+ID4gICNpbmNsdWRlIDxrdW5pdC90ZXN0Lmg+DQo+ID4gQEAgLTEyLDcgKzEyLDkg
QEANCj4gTU9EVUxFX0lNUE9SVF9OUygiRVhQT1JURURfRk9SX0tVTklUX1RFU1RJTkciKTsNCj4g
Pg0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IG52bV9mbGFnX2Nhc2Ugew0KPiA+ICAJY29uc3Qg
Y2hhciAqZGVzYzsNCj4gPiArCWludCBjaF9pZHg7DQo+ID4gIAl1MTYgbnZtX2ZsYWdzOw0KPiA+
ICsJc3RydWN0IGl3bF9yZWdfY2FwYSByZWdfY2FwYTsNCj4gPiAgCXUzMiByZWdfcnVsZV9mbGFn
czsNCj4gPiAgCXUzMiBzZXRfcmVnX3J1bGVfZmxhZ3M7DQo+ID4gIAl1MzIgY2xlYXJfcmVnX3J1
bGVfZmxhZ3M7DQo+ID4gQEAgLTM2LDYgKzM4LDIwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbnZt
X2ZsYWdfY2FzZSB7DQo+ID4gIAkJLmNsZWFyX3JlZ19ydWxlX2ZsYWdzID0gTkw4MDIxMV9SUkZf
QUxMT1dfNkdIWl9WTFBfQVAgfA0KPiA+ICAJCQkJCU5MODAyMTFfUlJGX05PXzZHSFpfVkxQX0NM
SUVOVCwNCj4gPiAgCX0sDQo+ID4gKwl7DQo+ID4gKwkJLmRlc2MgPSAiQWxsb3cgMzIwIE1IeiBv
biBhIDYgR0h6IGNoYW5uZWwgdGhhdCByZXBvcnRzIGl0IiwNCj4gPiArCQkuY2hfaWR4ID0gTlVN
XzJHSFpfQ0hBTk5FTFMgKyBOVU1fNUdIWl9DSEFOTkVMUywNCj4gPiArCQkubnZtX2ZsYWdzID0g
TlZNX0NIQU5ORUxfMzIwTUhaLA0KPiA+ICsJCS5yZWdfY2FwYSA9IHsgLmFsbG93XzMyMG1oeiA9
IHRydWUsIH0sDQo+ID4gKwkJLmNsZWFyX3JlZ19ydWxlX2ZsYWdzID0gTkw4MDIxMV9SUkZfTk9f
MzIwTUhaLA0KPiA+ICsJfSwNCj4gPiArCXsNCj4gPiArCQkuZGVzYyA9ICJSZXN0cmljdCAzMjAg
TUh6IG9uIGEgNiBHSHogY2hhbm5lbCB3aXRob3V0IHRoZSBiaXQiLA0KPiA+ICsJCS5jaF9pZHgg
PSBOVU1fMkdIWl9DSEFOTkVMUyArIE5VTV81R0haX0NIQU5ORUxTLA0KPiA+ICsJCS5udm1fZmxh
Z3MgPSAwLA0KPiA+ICsJCS5yZWdfY2FwYSA9IHsgLmFsbG93XzMyMG1oeiA9IHRydWUsIH0sDQo+
ID4gKwkJLnNldF9yZWdfcnVsZV9mbGFncyA9IE5MODAyMTFfUlJGX05PXzMyME1IWiwNCj4gPiAr
CX0sDQo+ID4gIH07DQo+ID4NCj4gPiAgS1VOSVRfQVJSQVlfUEFSQU1fREVTQyhudm1fZmxhZywg
bnZtX2ZsYWdfY2FzZXMsIGRlc2MpIEBAIC00MywxMQ0KPiA+ICs1OSwxMSBAQCBLVU5JVF9BUlJB
WV9QQVJBTV9ERVNDKG52bV9mbGFnLCBudm1fZmxhZ19jYXNlcywgZGVzYykNCj4gPiBzdGF0aWMg
dm9pZCB0ZXN0X252bV9mbGFncyhzdHJ1Y3Qga3VuaXQgKnRlc3QpICB7DQo+ID4gIAljb25zdCBz
dHJ1Y3QgbnZtX2ZsYWdfY2FzZSAqcGFyYW1zID0gdGVzdC0+cGFyYW1fdmFsdWU7DQo+ID4gLQlz
dHJ1Y3QgaXdsX3JlZ19jYXBhIHJlZ19jYXBhID0ge307DQo+ID4gIAl1MzIgZmxhZ3MgPSAwOw0K
PiA+DQo+ID4gLQlmbGFncyA9IGl3bF9udm1fZ2V0X3JlZ2RvbV9id19mbGFncyhOVUxMLCAwLCBw
YXJhbXMtPm52bV9mbGFncywNCj4gPiAtCQkJCQkgICAgcmVnX2NhcGEpOw0KPiA+ICsJZmxhZ3Mg
PSBpd2xfbnZtX2dldF9yZWdkb21fYndfZmxhZ3MoTlVMTCwgcGFyYW1zLT5jaF9pZHgsDQo+ID4g
KwkJCQkJICAgIHBhcmFtcy0+bnZtX2ZsYWdzLA0KPiA+ICsJCQkJCSAgICBwYXJhbXMtPnJlZ19j
YXBhKTsNCj4gPg0KPiA+ICAJaWYgKChwYXJhbXMtPnNldF9yZWdfcnVsZV9mbGFncyAmIGZsYWdz
KSAhPSBwYXJhbXMtPnNldF9yZWdfcnVsZV9mbGFncykNCj4gPiAgCQlLVU5JVF9GQUlMKHRlc3Qs
ICJFeHBlY3RlZCBzZXQgYml0czoweCUwOHggZmxhZ3M6MHglMDh4XG4iLA0KDQo=
