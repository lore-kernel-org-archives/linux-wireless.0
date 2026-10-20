Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792482433;
	b=CDVQ6n489SJPtRD0LxYXULl2e3jSxkysA497Ci+Wo4V5D4VMWeGVyNYOAOOIZBU+rG8M
	 lBw9XIuBk8E2yDPreZ4fdVmBjTCzCZkOeVyyiW96bcqqSWAIIL6OBiDtO74othiTy26OW
	 rBO91k+ZcQnlL59zutpa3rGvBHp0+N3CIghnxRFqfXcUUQmOubJczHiJ+BaHOExEnU2cf
	 kpTFonEuqVVzv6aMLFwjGmYjJ393Qx+/8B1X7HLnWE/5mSjDz7ORO5265a6UyzhTSuV39
	 UOuLXvkPBQ6LmWEQTPJomNS0WhMqfFhG+SFGqrnzZ/Q9UO8HBeTW4HmLnVF+oSawEBw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482433;
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
	bh=nqJObZHs2j9Ul4rTCtQS4VgpX1Ejv1qyOL9QYLaf1j0=;
	b=zY+HOkM1EItL3mvQ0Yr/Lr4ccW0oWZusgGpG+K1VDd9ecLXXpl4Rzocfeu44SMVwfVZn
	 Z2gfDsIup5q/53T+vD29iXQ+MK2o1DoXGw/GC8xJtKHMS/wd49pYVZclXYleKfWKkFgGT
	 IjBI6zx1t4E103AuNsNq9nceNT482CcEQL5T5FlB+CGHocznin4/D1NFejtmiy1i9mHd7
	 UN7gY7g0KYC+hXc4TheyjdZLaAK6rApbArKTh95UXvIi30j4XSNPrnM4cXFPjtuQSLo8v
	 r/sWL9Hdx8CxHkX9TtCA8hxKCKBP5Z8BEitVLPtK68RgYDAbvDQwxnAXgkhc8fR7zhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L+2wVR8K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF8F606A319;
	Tue, 20 Oct 2026 07:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BF8F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L+2wVR8K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792482432; x=1824018432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nqJObZHs2j9Ul4rTCtQS4VgpX1Ejv1qyOL9QYLaf1j0=;
  b=L+2wVR8K1mzZVPTBX+cl8bUoLB/eII880h6o+UFGKqDGZjxj44OFFRG0
   ZoQqNmpH6fc9YBg89HqNr9XPikySNe2EIDuXgdAehMEzaF6EEkcFEFeL1
   z6uJr9yi1MAiJmxI9dBksp0yKHETB+hR/XHfmAe6QE6sMWhUkhIWlo6Hg
   EVDsJzdctJA5nZl5QwB1nqb2It4b0Qc0HLsaWEVtH+Do0+qlA2eUpQTnB
   YaYlrc1jGnzV8fPFwfDkEU14yf/LAMybJbSsTbLiZEgb8zokpNT56pS73
   xcR5pQ3l1O8kjg892L4OpJCr3Goibhoiue0onnW3U9gzv50u/S0bCE8DZ
   w==;
X-CSE-ConnectionGUID: aZt///wNRieWegLo1P3NPg==
X-CSE-MsgGUID: OHz1xR/vSkOBfHhviNMvBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1170128"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1170128"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 00:47:12 -0700
X-CSE-ConnectionGUID: oXbQoSu5S3WH/CGuqNZLIA==
X-CSE-MsgGUID: gcdVr0t2QLqg0UuKFvp7UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2818068"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 00:47:11 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 00:47:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 00:47:11 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 00:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SH/Dl1ACcjM+TZZpXm9q5IcoD8HwFAr/FoyAOXxPE9gVcAV/h1jQZaTHcG4mIxWlITefkJlyxsNBTBF+5fVFsZeuqAB6j7t0EFGQnn5LLNZuBYHESvuZI/UHUsZ3yPGe5hgjnE351Zd7BrQlbmJCBPneHMlqYLL6rNKuHJuHGPC+ViH3SzkWfnJyuzDA/KsD+ZnqUE5AdOvgOrGteSgrCICCzP0aMbF0eAPATJbxJDwA/vLfCbXMlDAioBHyW/t5t76QM/gAN47gkCnjDFvApDbEdaHzWXCWVjLZpZYfJ1hWCBQ40Z25lczL4L+AU4XIjZD2X3jmGFybtC/tF1z34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqJObZHs2j9Ul4rTCtQS4VgpX1Ejv1qyOL9QYLaf1j0=;
 b=TgloZM08K2bIZqt4Gel9mfQrvSzjvfJ5LVCtVKWDf9qmYsaz4EzNCk2hLyt58G8TuPw5rocApVRVvibcbJ49tFsUm9YMg15CXq6IHGU8s88QnEqncgDZuFDf+tSV1h8pTFrzyABIb50pWfdhmN2u8fyvZyl+QeQNdeeSo8ppKd01V/dNvcFRS3ci8GUanK5lHGebkVDcH22PT/fAyvP9uOV8y9ARPYWozexbq5cuMviqYkUEAzdKP2r2WVG4aQU90oYxmzU/l982bv/HmMSZvCP14joso0FsUzLW9CIMW2hiBZ64EdW/9hhmBn8YeyDGzK0AC0uQhV0eHKuceehFdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 07:47:03 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::e642:c73c:6d80:5083%5]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 07:47:03 +0000
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "lee@kernel.org" <lee@kernel.org>, "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Coelho,
 Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
Thread-Topic: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
Thread-Index: AQHdTzDiQZA6DUx2oUmTls11GUnH9bbjximAgABFnwCAAbY0gIAgYHUAgAAMM4CAAAFZgA==
Date: Tue, 20 Oct 2026 07:47:03 +0000
Message-ID: <cbf2c9297ab7ff1b2ef5fd98876e952fe5a52e7f.camel@intel.com>
References: <20260928100508.3487525-1-lee@kernel.org>
		 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
		 <20260928142434.GA2112133@google.com>
		 <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>
		 <20261020065830.GA1206986@google.com>
	 <591baf4f5983a2205550523a792681dad4b77b66.camel@sipsolutions.net>
In-Reply-To: <591baf4f5983a2205550523a792681dad4b77b66.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (3.60.2-2.fc44) 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7494:EE_|SN7PR11MB7419:EE_
x-ms-office365-filtering-correlation-id: 4c38a562-018d-4031-d1fc-08df2e7e54f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|38070700021|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info: HGsC1C86R6/lQA71MaHN4pfmf+otY4lzMM2/yy2iWaimYOqz2lS7jg8AGe51yyNBqf2MpV7jW8OytSOrqsFcytPZJDwyLNocl2pMdEs3Zxr7FduNQhYfj0SIWod3DUQpLf8qWHn7UO85otQooPq0M5gdyLeh2j3i/jTQlNIPVOhgJN4Q64/6Jxk8N+U29PDi3KkDv+g69K+itQq3OO7DYXoUSj5ZCA22u+ca6i5o3ub7lNsMXkDqeSLtcohWRAj8DHPq9XOtVaZboFpzKCIXkVyZu3NxGr5IoOjgksScjF/dtH29kenfMlelAWYpIiDNpM5DPWEuK9/a9e5dlCG67o2X9+EslbjQ8K0K7MDCcU3T6sEM4paA3Mwbu5Bbe2DHjtIQ4O3/C0JjDXW7Kyo1sD9DFZtaqVSyzo6At6M7Cd/lstTXxGIcQQqBMOzpdBB5anVqeRLGh2g+w6zybSRsfx/TDAEE4ci6u6gZ/BCYuzzJT0nEIelInQZGjM2ulsvfI5lqDZjtJfmckiZh2CtAL4+0UuNM+KFQrS7+my2LFaC5cnVj8mjVEKSDHJ/MOkjDDgF0kjteS6/WB0Jg4HNAC+vXkbC8hegkwhzltic5J86DVQlVWP4+T7R9x163Vhg6tzKtqNGR6aXmSd1BraW3TZ+6vmHaJ4M914SDjmhK+JHtW8vJ15z9ztRBcMSdI0r181vKOh72mp1I+RKvh9IYceQXTAn/mwB2qa8grLp7M7Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(38070700021)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXZubXF0ZWx3a3FQaXIyaVpUcytKaUtMSFlKeU1MbTNtUm5KYVp4YjVXa0Yw?=
 =?utf-8?B?Rmc1T0w1UUErblF2YnhxNnZOVjZrM243dWFzV2pFdW1ZY3NkOGlhM0xsOTRt?=
 =?utf-8?B?ZFo0TjhLdzN4ZzBLWGZFTVZudEJURUFPNjA1RDlRdXF1ZDdoUFlJeTZEOU9s?=
 =?utf-8?B?SmlQMEcrOFQ1Tm9FbFljcU5xdklqTkYxMDV4TkNMdzJNY1RXWHJYckRkdTRn?=
 =?utf-8?B?ZDNSUDEvYkYrRHY2bllGdGkydCs5L0VEUXN6N1dWRUxQVXJtVTJubVdCY0xJ?=
 =?utf-8?B?Qjh2dlFCQ1RYR0tNY2VMbHZpNU90VFd2Nkdsay8yam9GUERrM0dTNlJzN1V0?=
 =?utf-8?B?Tm9CS2tvcmZlVVFBMjJnR2JZNUdrYUp2S2REL0JKUXVXL1k0QXFPbUlwR3M1?=
 =?utf-8?B?ZUZUYmVNbGxOS2NXT3NyNUQwcWJGaGNGVmlFZW9ybDREd2dRelhld0pTbUJo?=
 =?utf-8?B?ZDlEWjVaQjV6ZTQ1NUNwcWhlaHlPRUJkM1ZxQnUwNlM0TUxrTU5UWGs2TURF?=
 =?utf-8?B?Y2VMNVpNRGNOWHpwVytMMTAyK0U5dlVFLzlGb213RllPY0tKVkVUMWo4Q1Zq?=
 =?utf-8?B?R2pRUGpTVmNLaWtObHdlbDc1R1kvKzlnL1orMkhURUdJdmdVdVdBMzFHcXBD?=
 =?utf-8?B?QXE1QjZlVGlycFkrN1E5UDlqeXBrd1ZYWkR6dHU1R3lOOGEyMDFrdzBONnRY?=
 =?utf-8?B?amFVZVNDSHlFemVpeDJ3bit3SmVtZ1U4ekpLVmFQRGRySDhWRWRZVmQxUTNX?=
 =?utf-8?B?SHlTQ0NhMW85ME4vZnhHeTRYQlJtTXZ5OURqZmdQNkJXMndSdVF1UnVOVVpl?=
 =?utf-8?B?SU4zb0lxZmZzUlBWcTljT0FWNlA4UlRhMUdYOEZnYXhaYUJHNFI1YStkc3pk?=
 =?utf-8?B?UFZHSFh1eTNLQTVEZFM1SGhnZkhKaUp1ZmpCZ2ZZQ1U0WmJhUE91T2NMcTgz?=
 =?utf-8?B?TzJKTTJvVHJPZkVubWV2UFBaMXJyT2FBUm5EMXJ2dE55Y2hQYVBpbHdVWUh6?=
 =?utf-8?B?L0hJSGpJQmFyVVM2L3JqdFhSS0F4YlRhdTdmQzMvOEl4WloxdDJoc1pWeW5r?=
 =?utf-8?B?QjYxK0c5MlMrZDBMS3UrZFZqd0VhVm5ZSlVncG5KaVpBU3Z5RTNVM3JBR3BW?=
 =?utf-8?B?QnZlWTR6YmJjbDgveVJWMmtHMXgvT3IrYVNKb0VHYzhGQll3QWRKWkJqSVRL?=
 =?utf-8?B?Q1hzblJtWjBQNzdQcVpiZzRVL1MvdUJxKzQ4YUMyWHcra2N5WGdpZkpzT3N3?=
 =?utf-8?B?NHB6U1NDY1FrbUQ0a1AwSGR4OHAxVGFDdUVOSW1HNkpRSU9Tb0RsY2F3UWFW?=
 =?utf-8?B?SklPcHFNRk1RRUgzS1czTmZtbndIS3JMdExnenhzcHZPUnRmbGlQU3hneHE3?=
 =?utf-8?B?eDdvWHBGWitmY202QUtqeVozOEE1WUt3UTdrcXMwS1U5NFRiSVRHdlJ2azh5?=
 =?utf-8?B?OFRpSWZmUXNiTjFHVXQyc0pyNXIyaXBzdHZtZlRIVHllVU9Jc3NpdmJyOVhB?=
 =?utf-8?B?RkNIVXFTZFFNNWFmdWNwbXV1RDhyVHY0SWg1VTRBQjlSUWJZamdka2Zzdm1k?=
 =?utf-8?B?K25YaERiOEd5QStubGY2Z05GTTdVM2ZJRE5LcWlQTXU4R2FSRThLVzB5MVln?=
 =?utf-8?B?WFozYjdUN1BPM2FZdkREM1pFUGt5Y0FmVDA4cHJ1VUF2OFdTZ1JGbUhxSjdr?=
 =?utf-8?B?RHhDckdrVHdxQi9qWVZvN3ZIZTQrcEFPblpnMUsrOVJoY2k2RkJ2MnBLYmxV?=
 =?utf-8?B?dDRJOEhkam9nZUdFa1dEUDRwUktaMzZtclR5NGQwTDBja1NlQ3ZGM0hLSUll?=
 =?utf-8?B?UFdUcjRUOWdpMW5HeHpudDhVSngrS2VjNDgzVEptNVR0V042b2YzbGx0MnI1?=
 =?utf-8?B?TEdsblBrNHN3NjRYSnlyZ1dwbXMxQ3p4UitneGlKZ2dzVHRxV28wUFJWUnhq?=
 =?utf-8?B?SUFGLzlCN2M3WXJzTjAxOVNqNHVZeE1GZTg3UlZZRWYvU1N3NSs3cldNZ2F6?=
 =?utf-8?B?ZkYxS3h2UDdNWllmeXJpd1kyZFpuN05mQjdiZ3F4a3lTZWl6T01kQ0djRHJo?=
 =?utf-8?B?T3JJRVk0Rno0OFFDL0JEazA4WkhqV0dLM04rZlRXdHdQSUQvdFNqSldoNjhs?=
 =?utf-8?B?SkJGcy9YMUFVT0xWbE54OHI3QXE2T01URklyMDFRTVlZUFFUcmRFamo5QmFD?=
 =?utf-8?B?Zi9CN3BmRms0MDh2STdRYUl3cWs5QkNyZHZPdndBTSsxUWU4MlBhUWRLcXVF?=
 =?utf-8?B?WStOS3lUMkRMbzlYeFd5RDRaL25HUkZUV0hnU1ducGJPelRaV1UxKy8ra0RN?=
 =?utf-8?B?VTU2czNLVGhlcmlXSkt1amo2ZlNlZzAzSDhHcllwUjhQMXZJSGNMUnNBNzEx?=
 =?utf-8?Q?pgEFAOrdO36wtKLY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA7F6DAC946DB14D9C967E87E270266E@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: BCMttiI2eIK/tunL/AGW8+JgBU4DiPTM2gNZRpLEOX3TjWWm3DpocwqGc3qkzc25R54sgehr/8zossn+wiZ6+RtO7wOV4oA+Ulz572SkbyjXGXuRLFQscoqO/jeKmhSa2AMcyBmERFGVzlFKNS02N0nnYAfstlQRm89oDs92WpG+KZG5+vodO+ZHruJtY9lSD1zPk4BmCOouThstGFMSdV5C6u0FO3JcnKuBshNCudF0eEDBXteZZvLwfIT6xbsp4aYwR2jzv+ixCoshzvz7mBrkQKICZF/0p/xAzpcNDEDd4lSUjy38bNU7F+TQH3wpwXy5hKnn+dR1cQwgM3dEMQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c38a562-018d-4031-d1fc-08df2e7e54f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2026 07:47:03.5553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9VmmZGOYFHeZkpVvKdzgpjPrK8pu+OqCUvfYMlmKRpmWD+oa6j944XPPp2JWYj4kpncn6BqN+K2UazTqmS0oKf1+2esBU4tkQ4pjkZ8ZpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTEwLTIwIGF0IDA5OjQyICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUdWUsIDIwMjYtMTAtMjAgYXQgMDc6NTggKzAxMDAsIExlZSBKb25lcyB3cm90ZToNCj4g
PiANCj4gPiBZb3Ugd2VyZSBhbHNvIHJpZ2h0IHRvIHN1c3BlY3QgdGhlIGNsaWVudC1zaWRlIFRJ
TSBwYXRoIGluDQo+ID4gaWVlZTgwMjExX3J4X21nbXRfYmVhY29uKCksIHdoZW4gKGR5bmFtaWNf
cHNfdGltZW91dCA9PSAwKSAoZm9yDQo+ID4gaW5zdGFuY2UsDQo+ID4gd2hlbiBwb3dlci1zYXZl
IGlzIGRpc2FibGVkIG9uIHRoZSBjbGllbnQgaW50ZXJmYWNlKSBhbmQNCj4gPiBJRUVFODAyMTFf
Q09ORl9QUw0KPiA+IGlzIG5vdCBzZXQsIG1hYzgwMjExIGN1cnJlbnRseSBpZ25vcmVzIGl0cyBB
SUQgYml0IGluIHRoZSBUSU0gYW5kDQo+ID4gbmV2ZXINCj4gPiBzZW5kcyBhIHdha2UgbnVsbGZ1
bmMgZnJhbWUgdG8gZmx1c2ggdGhlIEFQJ3MgYnVmZmVyZWQgZnJhbWVzLg0KPiA+IA0KPiA+IElm
IHlvdSdyZSBoYXBweSBmb3IgbWUgdG8gZG8gc28sIEknbGwgc2VuZCB0aGUgZm9sbG93aW5nIDIt
cGF0Y2ggdjMNCj4gPiBzZXJpZXM6DQo+ID4gDQo+ID4gwqAxLiBTeW1tZXRyaWMgUE0tYml0IGhh
bmRsaW5nIGluIGllZWU4MDIxMV9yeF9oX3N0YV9wcm9jZXNzKCkgKG9ubHkNCj4gPiDCoMKgwqAg
Y29uc3VsdGluZyB0aGUgUE0gYml0IG9uIGRhdGEgYW5kIGJ1ZmZlcmFibGUgbWFuYWdlbWVudCBm
cmFtZXMsDQo+ID4gd2hpbGUNCj4gPiDCoMKgwqAgd2FraW5nIHNsZWVwaW5nIHN0YXRpb25zIG9u
IEF1dGggLyAoUmUpQXNzb2NSZXEgYXMtcGVyDQo+ID4gOWZlZjY1NDQzMzg4KS4NCj4gPiANCj4g
PiDCoDIuIFNlbmRpbmcgYSB3YWtlIG51bGxmdW5jIGluIGllZWU4MDIxMV9yeF9tZ210X2JlYWNv
bigpIHdoZW4gdGhlDQo+ID4gVElNDQo+ID4gwqDCoMKgIGluZGljYXRlcyBidWZmZXJlZCB1bmlj
YXN0IHRyYWZmaWMgd2hpbGUgSUVFRTgwMjExX0NPTkZfUFMgaXMNCj4gPiBub3Qgc2V0Lg0KPiA+
IA0KPiA+IERvZXMgdGhpcyBoZWxwIG9yIGhpbmRlcj/CoCBZb3VyIGNhbGwuwqAgSWYgeW91IGRl
Y2xpbmUsIEknbGwgZ28NCj4gPiBhaGVhZCBhbmQNCj4gPiBjbG9zZSBvdXQgb3VyIGludGVybmFs
IChBbmRyb2lkKSByZXBvcnQgYXMgYFdvbid0IEZpeGAgYW5kIG1vdmUgb24NCj4gPiB0bw0KPiA+
IHNvbWV0aGluZyBlbHNlLg0KPiANCj4gSSB0aGluayB3aGF0IHlvdSBkbyB3aXRoIHlvdXIgcmVw
b3J0IGlzIHByb2JhYmx5IG5vdCBteSBwcm9ibGVtIDstKQ0KPiANCj4gSU1ITyBhZGRpbmcgdGhl
IGNsaWVudCBzaWRlIGRlZmVuY2UgZGVmaW5pdGVseSBtYWtlcyBzZW5zZSwgdGhvdWdoIGluDQo+
IG1hbnkvbW9zdCBjYXNlcyBpdCdsbCBiZSB1cCB0byB0aGUgZmlybXdhcmUgYW55d2F5Lg0KPiAN
Cj4gSSBkb24ndCB0aGluayBJIGhhdmUgYSBwcm9ibGVtIHdpdGggdGhlIEFQLXNpZGUgc3BlYyBh
bGlnbm1lbnQsIGV2ZW4NCj4gaWYNCj4gaXQncyBhIHRvdWNoeSBhcmVhLCBidXQgZGVwZW5kcyBo
b3cgY29tcGxleCB0aGUgY29kZSBnZXRzIHBlcmhhcHM/IEkNCj4gZG9uJ3QgdGhpbmsgYW55IGNs
aWVudCB3b3VsZCByZWx5IG9uIHVzIG5vdCBoYW5kbGluZyB0aGUgUE0gYml0IGluDQo+IHRob3Nl
DQo+IGZyYW1lcywgYW5kIHRoZXkncmUgc3VwcG9zZWQgdG8gc2V0IGl0IHRvIDAgKHJlc2VydmVk
KSBhbnl3YXksIHNvIEknbQ0KPiBub3QgdmVyeSB3b3JyaWVkIGFib3V0IGl0LiBUaGUgcGF0Y2gg
d2FzIGZpbmUgYW5kIEkgZ3Vlc3MgbW92aW5nIHRoYXQNCj4gYXJvdW5kIHRvIGFwcGx5IHRvIGJv
dGggc2lkZXMgd291bGRuJ3QgcmVhbGx5IGNoYW5nZSBpdCBtdWNoPyBXYW50IHRvDQo+IHRyeT8N
Cj4gDQoNCkZXSVc6IHRoZSBmaXJtd2FyZSBvbiBJbnRlbCBkZXZpY2VzIHdpbGwgc2VuZCBhbiBO
RFAgd2l0aCBQTT0wIHdoZW4gd2UNCmdldCBhIFRJTSBiaXQgc2V0IGV2ZW4gaWYgd2UgYXJlIGFs
cmVhZHkgYXdha2UuIFRoaXMgaXMgbWVhbnQgdG8gcmUtDQpzeW5jIHRoZSBBUCBpbiBjYXNlIHdl
IGFyZSBvdXQgb2Ygc3luYy4gU28gMi4gbWFrZXMgc2Vuc2UgdG8gbWUuDQo=
