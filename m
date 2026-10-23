Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792745484;
	b=bqTKR/nymcFEDXzu9EXRNfGBMd19Z9ut0ESp8xVL8jqxvVLuYhv4cPZ/shmODMBZistd
	 1Pu1zSghAf5yapudMTPbG1+NAf5s0erH1SXucKLxqCuHioVLXGDCZEz8nJ+roBsho+Inv
	 yKjlXZVchS57cHUMuLZ2LegNrVn5ytn1bSZZ2LbmL6PoCDjH+XywsooziLUqbRPt2nwhj
	 Po5dFlsuEQaHI5q1JDMGkBaZb/ulu/j48hMnBjeJbl0bRCKmEp59tit+RRdl/ndbxlwZc
	 A2AWL87TG3tBFHa1jtye5cEHnmAZ9IXHq2RA/ChvLq/nYym1DAmnVmdnqZmsHn6/1xw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745484;
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
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:Content-ID:
	 MIME-Version:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 Content-Transfer-Encoding;
	bh=A4ThtHu4+7Nz8wD6uCQRaWFg/m4Ne/HG6rRp3yFj8+8=;
	b=n0HTAbrsEly62H+vCZtaKBApmCi0puo10kxEJaE8cgOzdWJqbBrFegI/wQmqo8q8G6eC
	 n2mGBV16kMFvucQe7h45mugaMWXAMZbdUs55g16Ad4aNqN+nWiJ1Uq48T35RAQ2/LWhnL
	 KKKFIz4g69XLnaRI4/Q6wozZ9T1pP+84kc5eg6pXwpD38I7CuNdg+qTom4jzNe9Sb5wJg
	 J2e1XfqCiugrDgWPvb+2VFN316LF5LeLXl5BGlJjDL04FcTEKxFRZfHYyMvox39Y6CFfK
	 RcP5oGt66FUPf+ZiUdZO8OxM15RW/IDR/RflU1PmF23vx7x8N7z2mAIK5XoplMPW7mA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GyDTSXQN;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6A606A32A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 08:51:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BE6A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GyDTSXQN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792745482; x=1824281482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=A4ThtHu4+7Nz8wD6uCQRaWFg/m4Ne/HG6rRp3yFj8+8=;
  b=GyDTSXQN/0kn77Xk43N6chQLT3xdKUUc4+cpNSPLTomyuufziNioulUT
   SGC094H1UGpY5M6w5cmKZ7uZy0QZ7BgI7I2OPkIePSvbMs3oTxdqJ6jqs
   Ncp3F0etBDv8f50AN4RyfehTZD+oeZMbIiNVMAxYEUJ6m5bMohKiVkvzV
   xHuIPIxUfprZZUl06LdYKWViJf+v1+PhFHWNTlDe30smeYplEQJ6NgHvs
   +OKrKwnnKOnkBQJypVvdXLPxzZCV3xVLLz1qbg8HnMSsoGrJoiT+rTulD
   LFC4PjobbrWxXP2eFMwy3UyOnCGLGnCRibGcRC3+FMJzqNzHJA5e07oSd
   A==;
X-CSE-ConnectionGUID: tNzQACEISv6xpM/XEGFDnw==
X-CSE-MsgGUID: qRY1ZLO6TZW78ndkOtLrjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1507302"
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="1507302"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 01:51:22 -0700
X-CSE-ConnectionGUID: LJ820sq7Q86O1DELSgF7hA==
X-CSE-MsgGUID: Q5yVCwB+TSGR43EXS/Mcog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="5428090"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 01:51:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 01:51:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 01:51:06 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.56) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 01:51:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dp9vX6DmidyHMgzESD+nObrviwSq0NKXDG/u4I4fEo4Bno0Q4fVcGK9Ggj+xlBCRkW+FlZTbdkMM5MV1iG54E5015uiQ5dREvbeGmodWuSBb3WaRev8PUxa42/ytWUIwMslnOKAqzfanjFBQv+xH//x2YT8C0fb6JKrfoEIijShvZXaOYy9Pe//q7EeaEN2Nq2Vb8+NvV6LTPcnLHh9MV7JIFGj1wrmnXNc18fsFdyXoZFBWbIYtebUnhIZ8bUe9WPIni9KwXhbksYY1kHAU3dWn2OUkcPCBB4wNpKdXBKgpdg015k8cndkiA3Imuj1AXeSEOr19DwiagNs3iMezcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZ+gDYs/2IxqIAPvqhtYBlHsUoDBJdkmeB/HET8hEeU=;
 b=u9xgyeL8kR72C1bRMlH8ZYoZMT82kLtUH74KBh5CxsOYf6a7Bper2nIdGGxj+M8K5Z/FG9+uTCPmma1sJwHG+DE9AazJnKRQzesrAfHXha2UoZ7XH7sFRy9UHj3wDNtIUfHUtQdpv+nUun3oM21skXPnbtyp3e2NDWXQdekizVIypo5+iMf03tH55sQSYbXHNhh2q/x0oyATizLC8t3idSVmmT4K8TK8xnD/XCMw37qMdD1httQF3LtA0ohxzV8n9pzgSKnX8kNQPgG7LmF0XDUE4f3QIeE9l1RCNekZ6xc5pYrnGv5aGzWabPmPG+1o4v42Tz8Xhzni6TEUzRLEMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB7964.namprd11.prod.outlook.com (2603:10b6:510:247::9)
 by IA3PR11MB9111.namprd11.prod.outlook.com (2603:10b6:208:57d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 08:50:59 +0000
Received: from PH7PR11MB7964.namprd11.prod.outlook.com
 ([fe80::a724:969d:4145:3e1d]) by PH7PR11MB7964.namprd11.prod.outlook.com
 ([fe80::a724:969d:4145:3e1d%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 08:50:58 +0000
From: "Berg, Benjamin" <benjamin.berg@intel.com>
To: "loic.kassel@gmail.com" <loic.kassel@gmail.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
Thread-Topic: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
Thread-Index: AQHdXo0RmP6OOyNYr0KKymDPjfSdQrcK2iEA
Date: Fri, 23 Oct 2026 08:50:58 +0000
Message-ID: <5e616c87d6855725d0ac726a1de5e88a57dbd312.camel@intel.com>
References: <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
In-Reply-To: <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7964:EE_|IA3PR11MB9111:EE_
x-ms-office365-filtering-correlation-id: 07d9fa06-9520-42e2-b238-08df30e2c239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|10070799003|23010399003|1800799024|38070700021|56012099006|261022105027099003|261022075727099003|261009223027099003|11063799006|5023799004|261021121427099003|261021135927099003|10067099003|18002099003|22082099003|6133799003|3023799007;
x-microsoft-antispam-message-info: TJMneRCyg6h1KtcbIFKNAAmquzt1A/In2FTnQdzBsxG82G/82e/6G6+jSrM7iBKKf+kBneD3Qm2rdxf5IfYpwJ1nxDhn/wsRX3Kot5voRi6PstbXUguthnb6K02StISXlS8/27DB0dIUmwFtXwnsUTihn09MTI8kkN/kvwVI7yDd8ozpFzaFP09BrumcUg+umW2Z0rGR2ctUHnhTQY7kWIj8iz8Uj8hhvurX+o0mN04hP1DrJYgpeVUcOHZ+3AI2DFxCztPfpiNVSP0o1SOsW+1zdlkFxc4+//U1z8L454SzVzRjP0JXmEjRkj8fHE5QFWN6ZIhigMeCQSbWmUTWF2jrssHKnxQyAHviO8LAQiHBFOw1PY81NBhdZuSSM70RMKBtzA83vA6Zk+1udu7V32F/YGEkAhm5VfcWF9G7PaU6cdKjCQK0Ou5u7x5DClgcgZkTYrCgE568iKKzOu2O3yx7fuZdnx2iSmeAt7rAY5MXNQ52X6hOe7j/hYv9WZ/k/UOI72S2iiwCPStXCITBNVwuksJdKnGKDdqkVcOtPCKw5XrQ+DXLWidI9G82Rp88w3YuUPa3inU16d8HvahkYzJpnvc67nkvuAr9h6O+ietXMcecl4/d0kP7JpzPbTGrwIkNbJAXLseTQAV8m7yaKI/g5lQ/go1k7+Uf/tp2Fhqe7V+/6GWMLYUJiK8bK8WwKUnMLMTf/ZFXeBTdiiMF1D9dLEahPsXsm3xFi8CESiQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(23010399003)(1800799024)(38070700021)(56012099006)(261022105027099003)(261022075727099003)(261009223027099003)(11063799006)(5023799004)(261021121427099003)(261021135927099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Um0rQVlTbXlLOEQxUHQ5cmY5Sngza3VIRDdqV1NyTytiRUFtTGFtT1lYR3BD?=
 =?utf-8?B?dEtRUVJiUE1YQ1RqM0VSckRhT0NWZUpSY1NvSWpvd2dsMld6blgrUjlZeUlP?=
 =?utf-8?B?a2tQUHBWRHpHVVc3QUFJM3Y1VEQ2eE54YUJjM1I1S2pDSzVJK1duUHlFK0JF?=
 =?utf-8?B?QjBaOTdPUUtFVmNRblhRUEVIYjFyc0dsRzd6czdiMWFqL0l4WkVwKy9lL0Fi?=
 =?utf-8?B?TFYyc3R5WlVYOUlIU3RUTjBxdjZ2aU9KV3JWREJDY1QwODlISVVhMy9pck9i?=
 =?utf-8?B?QXVGL3FCcXpqZUJhTnJ5K1FpQ3pmQ0o3SEtyVGRWaDNQRWozTDJYNzg4bkcx?=
 =?utf-8?B?aEUyRzJNLzN5VGYwRzFIYVRzL1ZUNEtjaER5TyszWEJuMzc2TlBmd0E2eGhF?=
 =?utf-8?B?STh0azJzRmUwQTZNT0ZibUJxODNab3lCUzhERTBTekw1cXJQTFFyR0V4MmdR?=
 =?utf-8?B?bXVTajZjTUU4ZnlDUHVQMGYxdndyRGNSb2srTys0dHJqL1RGZnRvS2tJYkxE?=
 =?utf-8?B?Nm9ZSDV2SFIrQlVlWXR0cUVGM3YrT2RRaUtHM3JYZ1dFNzVxUXByaktKTGtJ?=
 =?utf-8?B?M2w3bjM1OHA2UWhDeXBZbllKd0NIMTYvQWVqU0VyWlNKWTV1YVJxbmZneHRX?=
 =?utf-8?B?N1FuV3JwTk1XWms4WjVEUzk0bnNCQlRmUzFua1pDblhwODRNZ2tNN3VpbCtr?=
 =?utf-8?B?andvWlVmWVkrTEtEQkw5OURqV0ZlWGMyK2VVQWZraXQ5eDV5SDE3S0hGVHhZ?=
 =?utf-8?B?eUZTU25yaHdGYjd3WTVDRTVua09sMDVsVjVSaThkQXhrdG1CWlZyNDZFOGVm?=
 =?utf-8?B?Nk1JOWZtbGsydDRVN1ZCMFMzVjFkZVNJdHVtTlFpVGhIUFY3WU93QWx2UjZz?=
 =?utf-8?B?aTZDNUxoK3NVZ2pKYmptMzgzQ05YYlpwZ3AyblBMMGFsb25ZWXpNT2RkTHNV?=
 =?utf-8?B?cnh3NVFHWWN1VnNIaHFTeGQwaG5xU1M2QmJuNW9PMEJwUHhndkpUdnZhYmg4?=
 =?utf-8?B?cjNYWkNjbWI5cDBHdEVqRlFKRm9aTXM2cGNSU3MzUnpyaE1yZkhKbTIyUm8y?=
 =?utf-8?B?RDdxOEtxelk3dDdsWXZhTXg0NmlTRU1KRisrTWhxNGNnU20yMmNHejliVVZZ?=
 =?utf-8?B?Z0dIcEo5eUY3WEdzd3hzY2Z6VUdQMmVlTlVqeDEyMXVmUWczQzR2SXoyQ1Ev?=
 =?utf-8?B?RjhNTUQxQ3FtQWZINVRtdGhLZ1dWb2JQdE1URmFDSlVhN0NzSzNGdTJXMThT?=
 =?utf-8?B?VzZYdUtOazQvK3lUWlc1QldRb3AzM3JRRzV5bE1pRUdYWXNSUlFtTzB5Wisv?=
 =?utf-8?B?ckxOL3JCMXc3SkdYQjM3QVJXNnU3dWw4Sld0M2hjdGE4Rmk3TUJ6dXhUVCt4?=
 =?utf-8?B?YkxLc3U4dkZUZ24rNXpxSm1KbmU0ZFN6b1JzeGRiVm9MTEhFbmJKamp6S1p3?=
 =?utf-8?B?QzlEV3hKSWtyTkJXeXhraFNwVzQ2TFRpYUJkNWNDa09mSVA1Q0plSGNUVXBh?=
 =?utf-8?B?YmJYbGFzb1MzUFhEb1p4OGcyM2hWc1VUT2NuVXJ6bG9nK0doRHpkWFJMYXNC?=
 =?utf-8?B?Y3ZXaHRFZ3FKcFdGRlNCNGFiVWorMjM1dHpzaG9VM2dBZmpWeDQrQWE5ZEdi?=
 =?utf-8?B?dEd6QjM0Zis3WFY4KzNlUXNjWTdKQ0FTZmJvc0orbTM5cDhHVUhzY3FuKzB1?=
 =?utf-8?B?SzVCUTF2ejBkdjRvZks0YzluMjRFRHZ1elpJU2FmbGNXRmROTlBGSzRueHlN?=
 =?utf-8?B?UnZidDR6T2NUbHFtRG9FaVJvMS9BYmVWdmtFKzlLRE5rYkF6Q2xDSkVTYk1X?=
 =?utf-8?B?djlXY05zNVVpYlQ0NVo5YkNXNkJycklkNXFNSWVVWk1ENjRwNVFTTFdYSUxp?=
 =?utf-8?B?OThacDkzamorVW5IQUk5cXVqUXVMekZMdE9DeHpGSzdEV1hEeGYyWW5TN2Zq?=
 =?utf-8?B?dllqeDdXN2t1bVdYSVpMVjNOLzdZL20xd3E2WWt3VEhDNnNlU05YTWVzWlRm?=
 =?utf-8?B?RXJrcjZaZHNxWVV5bUViS0VvUUxFd25qbi9PdXVxSDVhbm1WU0NsWmI5VGow?=
 =?utf-8?B?SlhJdCthWWs0cjdhc3kxd29LS2FVUkNCSUNZVjd6YWV0aGZzbG5mNWEyS21G?=
 =?utf-8?B?ZUEvYnl4MGVNR0gxWHQ2QmdXSFdDMkZYeU94QXZmZFBVbW52VFhMbFFNdHVm?=
 =?utf-8?B?TTdjM3pyczFyM09yeXpIbjdBTUVWVmFjMHRtdVlQRGdHOFFZODRPd2N1TGo3?=
 =?utf-8?B?NEJ1WnF6dnV1dklpanR6elVrU3FHOUU5NjNjTTFENHpHRGFnZi9hMW1mZWtK?=
 =?utf-8?B?Uit3ZHVRT0JiSG9DblRKRmpQQ2RqakRrVU5UcEJ1U3d2SkFmc21yNTdnanV1?=
 =?utf-8?Q?nkrDbJNh/Knc83h5I2n8IDPCjdLd4ebrFnHqP+JLv62Q5?=
x-ms-exchange-antispam-messagedata-1: NdtTT/e1IQ8+z6vYKjdTOKE3I5TncUc7bAk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D09300310F209428788535CD504E247@namprd11.prod.outlook.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 41nICCuTl80BOdBlKSSwkcM8u+VZAUb6N1yIm96bDYsl92TCXHOSmCVtShQq1tqiY9BSSQLfziiBCOAvJTt86h47pAEi49yq8xWtb7U7YYwle1pPZ/UBVEGJAF75wfzSEjd+GBMhFfbGTpFq4K9yIJJWMx6xwZmvVbmFKk0BzPW46kK1wcrMzoXg5Aleqyj8Oc8HNRD02FQ0ec2//APOQ9H4tRV5VBoHhBpqtKuTLN1gPnBSD5zW7JQSmtuKHObJXj9514iMvSBspggQmFKtXegythH6YhQB7tChY3oa6yr6UpHGvh3wbrBOGzjGSsh8yFQwwv/tWJFUCPRulqjpww==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d9fa06-9520-42e2-b238-08df30e2c239
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 08:50:58.8344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWq9MxYmOIzA+cHkOUXPUHvm5a1B8eIahwajriyN2LGyUq7TcVvgwy8GYT9n+tA5BT6JHiwBGlTwXXaEoR4ChA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9111
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: base64

SGksDQoNCk9uIFN1biwgMjAyNi0xMC0xOCBhdCAwMToxMiArMDIwMCwgTG/Dr2MgS0FTU0VMIHdy
b3RlOg0KPiBbU05JUF0NCj4gYnV0IHNpbmNlIGNvbW1pdCA5MzNmNWJlYzk4YTEgKCJ3aWZpOiBt
YWM4MDIxMV9od3NpbTogcmVnaXN0ZXIgYmVhY29uDQo+IHRpbWVyIGJ5IGNhbGN1bGF0aW5nIFRC
VFQiKSB0aGUgY2FsbGJhY2sgcmUtYXJtcyBpdCB3aXRoIGFuIGFic29sdXRlDQo+IGV4cGlyeSBk
ZXJpdmVkIGZyb20gdGhlIFRTRjoNCj4gDQo+IMKgIGhydGltZXJfc2V0X2V4cGlyZXMoJmxpbmtf
ZGF0YS0+YmVhY29uX3RpbWVyLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgbWFjODAyMTFfaHdzaW1fdHNmX3RvX2Jvb3R0aW1lKGRhdGEsIHRidHQpKTsNCj4g
DQo+IGFuZCB0aGUgc2ltdWxhdGVkIFRTRiBpcyBiYXNlZCBvbiBib290dGltZSBzaW5jZSAxOTI2
ZjRlMDZkY2UgKCJ3aWZpOg0KPiBtYWM4MDIxMV9od3NpbTogcmVuYW1lIGFuZCBzd2l0Y2ggc2lt
dWxhdGlvbiB0aW1lIHRvIGJvb3R0aW1lIikuIFNvIGFuDQo+IGFic29sdXRlIGJvb3R0aW1lIHZh
bHVlIGlzIHVzZWQgYXMgYSBDTE9DS19NT05PVE9OSUMgZXhwaXJ5Lg0KPiBbU05JUF0NCj4gUG9z
c2libGUgZml4ICh1bnRlc3RlZCk6IHNldCB0aGUgdGltZXIgdXAgb24gQ0xPQ0tfQk9PVFRJTUUs
IGxpa2UgdGhlDQo+IE5BTiB0aW1lcnMgaW4gdGhlIHNhbWUgZHJpdmVyIGFscmVhZHkgYXJlOg0K
PiANCj4gwqAgLcKgwqDCoMKgwqAgQ0xPQ0tfTU9OT1RPTklDLCBIUlRJTUVSX01PREVfQUJTX1NP
RlQpOw0KPiDCoCArwqDCoMKgwqDCoCBDTE9DS19CT09UVElNRSwgSFJUSU1FUl9NT0RFX0FCU19T
T0ZUKTsNCj4gDQo+IChpbiBtYWM4MDIxMV9od3NpbV9uZXdfcmFkaW8oKSwgZm9yIGxpbmtfZGF0
YVtpXS5iZWFjb25fdGltZXIpDQoNClN1cmUsIHRoYXQgbG9va3MgY29ycmVjdC4gVGhlIFRCVFQg
KHRhcmdldCBiZWFjb24gdHJhbnNtaXQgdGltZSkgaXMNCmNhbGN1bGF0ZWQgYmFzZWQgb24gdGhl
IFRTRiwgd2hpY2ggaW4gdHVybiBpcyBiYXNlZCBvbiBCT09UVElNRS4gU28NCm9idmlvdXNseSwg
dGhlIHRpbWVyIHNob3VsZCBiZSByZWdpc3RlcmVkIHVzaW5nIENMT0NLX0JPT1RJTUUuDQoNCkRv
IHlvdSB3YW50IHRvIHN1Ym1pdCBhIHBhdGNoPyBObyBuZWVkIGZvciBhIGxvbmcgZXhwbGFuYXRp
b24gaGVyZSwgb25lDQpqdXN0IG5lZWRzIHRvIHBvaW50IG91dCB0aGF0IFRTRiBpcyBiYXNlZCBv
biB0aGUgYm9vdHRpbWUgYW5kIHRoZSB0aW1lcg0KbmVlZHMgdG8gYmUgY29uc2lzdGVudCB3aXRo
IHRoYXQuDQoNCj4gUmVwcm9kdWNlciAod21lZGl1bWQgbm90IHJlcXVpcmVkIGFzIGZhciBhcyBJ
IGNhbiB0ZWxsLCB0aGUgdGltZXINCj4gcGF0aCBkb2VzIG5vdCBkZXBlbmQgb24gaXQpOg0KPiAN
Cj4gwqAgMS4gbW9kcHJvYmUgbWFjODAyMTFfaHdzaW0gcmFkaW9zPTINCj4gwqAgMi4gc3RhcnQg
aG9zdGFwZCAoYW55IG9wZW4gb3IgV1BBMiBjb25maWcpIG9uIHRoZSBmaXJzdCByYWRpbywNCj4g
wqDCoMKgwqAgc2NhbiBmcm9tIHRoZSBzZWNvbmQgb25lOiB0aGUgQVAgaXMgZm91bmQNCj4gwqAg
My4gc3VzcGVuZCB0aGUgaG9zdCBmb3IgYSB3aGlsZSwgZS5nLiAicnRjd2FrZSAtbSBtZW0gLXMg
NjAiDQo+IMKgIDQuIHNjYW4gYWdhaW4gZnJvbSB0aGUgc2Vjb25kIHJhZGlvOiB0aGUgQVAgaXMg
bm8gbG9uZ2VyIGZvdW5kOw0KPiDCoMKgwqDCoCAiaXcgZGV2IDxzdGE+IHN0YXRpb24gZHVtcCIg
b24gYW4gYXNzb2NpYXRlZCBzdGF0aW9uIHNob3dzDQo+IMKgwqDCoMKgIGJlYWNvbiBsb3NzIGlu
Y3JlYXNpbmcNCj4gDQo+ICNyZWd6Ym90IGludHJvZHVjZWQ6IDkzM2Y1YmVjOThhMQ0KPiANCj4g
SSBmb3VuZCB0aGlzIHdoaWxlIGJ1aWxkaW5nIGEgY29udGFpbmVybGFiLWJhc2VkIFdpLUZpIGxh
YiAoaHdzaW0NCj4gcmFkaW9zIG1vdmVkIGludG8gY29udGFpbmVyIG5ldG5zLCB3bWVkaXVtZCBv
biB0aGUgaG9zdCkuDQoNCkl0IHNlZW1zIHRvIG1lIHRoYXQgc3VjaCBhIHNldHVwIHNob3VsZCBu
b3QgcmVhbGx5IGJlIHN1c3BlbmRlZC4gSW4gdGhlDQp1c3VhbCB3YXkgdGhhdCB0aGUgaG9zdGFw
IGh3c2ltIHRlc3Qgc3VpdGUgaXMgcnVuLCB0aGUgaXNzdWUgaXMNCmNvbXBsZXRlbHkgYXZvaWRl
ZCBieSB1c2luZyBhIHRpbWUtY29udHJvbGxlZCBlbnZpcm9ubWVudCB0aGF0IHJ1bnMNCndpdGhp
biBVc2VyIE1vZGUgTGludXguDQoNCkJlbmphbWluDQoNCj4gDQo+IEZ1bGwgZGlzY2xvc3VyZTog
SSBhbSBub3QgYSBrZXJuZWwgZGV2ZWxvcGVyIGFuZCBub3QgdmVyeSB0ZWNobmljYWwuDQo+IFRo
ZSBzeW1wdG9tcyBhYm92ZSBhcmUgcmVhbCBhbmQgd2VyZSBvYnNlcnZlZCBvbiBteSBtYWNoaW5l
LCBidXQgdGhlDQo+IGRlYnVnZ2luZywgdGhlIGNvZGUgYW5hbHlzaXMgYW5kIHRoaXMgZW1haWwg
d2VyZSBkb25lIHdpdGggdGhlIGhlbHAgb2YNCj4gYW4gQUkgYXNzaXN0YW50IChDbGF1ZGUpLiBU
aGUgYW5hbHlzaXMgbWF5IHRoZXJlZm9yZSBjb250YWluIG1pc3Rha2VzLg0KPiBJIGFtIGhhcHB5
IHRvIHRlc3QgYSBwYXRjaCBvciBydW4gYW55IGNvbW1hbmRzIHlvdSBzZW5kIG1lLg0KPiANCj4g
VGhhbmtzLA0KPiBMb8OvYyBLYXNzZWwNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18NCkludGVsIERldXRzY2hsYW5kIEdtYkggDQoNClJlZ2lzdGVyZWQgQWRkcmVzczog
RG9ybmFjaGVyIFN0cmFzc2UgMSwgODU2MjIgRmVsZGtpcmNoZW4sIEdlcm1hbnkgDQoNClRlbDog
KzQ5ICg4OSkgOTkxNDMtMCANCg0Kd3d3LmludGVsLmRlIA0KDQpNYW5hZ2luZyBEaXJlY3RvcnM6
IENhbmRpY2UgTW9vcmUsIEplZmZyZXkgU2NobmVpZGVybWFuLCBSYW1hY2hhbmRyYW4gU2l0YXJh
bWFuDQoNCkNoYWlycGVyc29uIG9mIHRoZSBTdXBlcnZpc29yeSBCb2FyZDogU29uamEgUGllcmVy
DQoNClJlZ2lzdGVyZWQgU2VhdDogTXVuaWNoIENvbW1lcmNpYWwgUmVnaXN0ZXIgQjogQW10c2dl
cmljaHQgTXVuaWNoIEhSQiAxODY5MjgNCg0KVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50
cyBtYXkgY29udGFpbiBjb25maWRlbnRpYWwgbWF0ZXJpYWwgZm9yDQp0aGUgc29sZSB1c2Ugb2Yg
dGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24NCmJ5
IG90aGVycyBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5k
ZWQNCnJlY2lwaWVudCwgcGxlYXNlIGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVsZXRlIGFsbCBj
b3BpZXMuCg==

