Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B9F38239A;
	Wed, 14 Oct 2026 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974784; cv=fail; b=RC+IufVZNO6jmKEAnA5c7cDSn4EMdKlIdc0ZUodXS1drIWuFhpyA8XWX9oPlgADzIEtW+EWRqBr2k5nYyAB/YswvCRPGKLvqTDT82El+6QGZ7/W8lyxCFh145kkLowwBzFxFY+sXO4NPsCoY2od+hBoRpVxYvrL7ex6SlD6TuLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974784; c=relaxed/simple;
	bh=zTndezTWoWyueQcuZ15QQzlbRqs9uhykARVjJLQzdHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JnMFAYN65+UlmxV/30Wpbez/wDzXH/NFTjca8nGDWmC38N4YS5eN7oa0/FH1FzVICI5BJC4Gy7OrBy9LgQXfUhmO33u9NqKnHkGK6/RQfXSw+XOmZdjbgftJIn8BH+gz83ub/pxamGCByqUzq1ywE7Dnn2Eijs0PkyU9iUeKy+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rexp5t6V; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rexp5t6V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791974783; x=1823510783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zTndezTWoWyueQcuZ15QQzlbRqs9uhykARVjJLQzdHY=;
  b=Rexp5t6V9NVsS/GrN+anItuVkr9XeT4aRG+zdZcfELpi4kAYebwqbLPQ
   12IDAuRrWI9AOFlrflGaXTXV/2vmZHIVL5SbbStAu+rxqVxwtdslsCmgR
   ZdX/gnPhCaCO3fsGLa7ER795/K7RuubnfZ8phstBiixVC1iuMObUpZO+y
   59rGtUafmpcKAsk19kMbPOpI95J0QzgXp8YzCtEglwNARKR8LkU6u/C44
   JUozh8iFyfu7gY9r0grGHSRoWVvmxPMvk1biLY6k9nlu4AhfjJVgGbvNn
   B7waVFuOr+Y1jYgCDrXLXbL3BmuJIFI9GAnLyt5/i+hqOOGafeCYrH0Ni
   A==;
X-CSE-ConnectionGUID: ck4FB0tlTLKrPKCHaQ9RDg==
X-CSE-MsgGUID: oDhFMHtQQ5ma3e4crKfU2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="823332"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="823332"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:46:21 -0700
X-CSE-ConnectionGUID: TsmYIE0HSPO6qRLdNLAHmw==
X-CSE-MsgGUID: DfPRRtd0Tr2hpmxfLv/ZhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1366267"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:46:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:46:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 03:46:20 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:46:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPfjSkCnkmDLsc3O4rEo6kV9vpilgGjmK0cvkYnMISzKfX8ehqTwocC5q7pfRPZxkzRjp1Padd/i/Qg7t3q7OkVq/GHkAoFUUb75TlJFt9IGxr+bJFVSFAJxGRYxqh741SMI13huLLyUDE8Nb7j9WvNcRUPpPxwfl9Sb66+ircGF0rur45ZJbxW7yLXLkeJMH1mEPopC08+gieMD8/Ew8f84Cg/JT3nIrMc7acLzQAb2GHlSNWAbagP49wckNyAVgRporgu2MvPJ0dTnp6fbDfH88ARvD8Tvu61tPPRmqcZYCYNVFlAfMvX8p83jjZIGdAGlQK+q2vh5Ri+imivIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8mmPwRIABnrsKiXD4IPUSwX4Yvq109B8wM72ld8W5A=;
 b=Srm96dW6xBG1BMNp2/t9UI9DroqBLS8IvmEs8bH6Tc/nnkhLl+qASDIA+7YFa2nypmAQmVI2vySkHe5l00gE9VRy07IBhS2ejMiUd8oAu73i2YVUOAT1Kqbat/bAOqgNf/viYukMgYxyLYLlqfdGvs3IfmaZYpV4kX4e5RpHxr7ymUn2vOyrk55JwOUyco5LUT+/hc6V43vWHni3gcKZ2Vz/CukfV8u29v+OKt/Dc5AB1zKIrf/om9FFNzXRBOJzm/tZwxjVBM9cnxJ6HFntPwXUQQzodkVsEJTvGmP60Xikn88n+nF9mLZ6FOLE7sRLgqPOQgIjulsWwJAJqv9BdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::31) by SA3PR11MB403611.namprd11.prod.outlook.com
 (2603:10b6:806:58c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 10:46:18 +0000
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f]) by DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 10:46:18 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
CC: Ajay Singh <ajay.kathat@microchip.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S.
 Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, "Donald
 Hunter" <donald.hunter@gmail.com>, Eric Dumazet <edumazet@google.com>, "Ido
 Schimmel" <idosch@nvidia.com>, "Keller, Jacob E" <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>, Kory Maincent <kory.maincent@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>, Nicolas Dichtel
	<nicolas.dichtel@6wind.com>, Nikolaos Gkarlis <nickgarlis@gmail.com>, "Paolo
 Abeni" <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan
	<shuah@kernel.org>, Simon Horman <horms@kernel.org>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, "Willem
 de Bruijn" <willemb@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v11 6/6] selftests: net: test AF_PACKET multicast
 dumps
Thread-Topic: [PATCH net-next v11 6/6] selftests: net: test AF_PACKET
 multicast dumps
Thread-Index: AQHdWeeHYYEkHxl7jkmpDKzzU7rKYrb83osQ
Date: Wed, 14 Oct 2026 10:46:18 +0000
Message-ID: <DS4PPF7551E655208F2C4C3F677E206BA1DE59D2@DS4PPF7551E6552.namprd11.prod.outlook.com>
References: <20261012011707.3378-1-sigefriedhyy@gmail.com>
 <20261012011707.3378-7-sigefriedhyy@gmail.com>
In-Reply-To: <20261012011707.3378-7-sigefriedhyy@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPF7551E6552:EE_|SA3PR11MB403611:EE_
x-ms-office365-filtering-correlation-id: 18724d0a-0e0d-4a94-5c00-08df29e060f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|6133799003|22082099003|18002099003|10067099003|38070700021|11063799006|4143699003|261009223027099003|56012099006;
x-microsoft-antispam-message-info: 9w/6jSd+AjlDiaoXJFb+/eFbpU7nOJfItIOkf4Uciqp53WyxtAkSkY0I4J9GWvF9PNmhBJK5pIVXWyIC5cR9ITmfribxiaMorFp7roKLqA0OhYG+YUtOQ4bPaEzbCZ/WuznX1Thc2nsCzet2g3ke0vfOYRf5XyeYlrkBJAF0tA4p6lcrQfsWQRe2ZSxlOKztCOeVKBiNxhwh31QflY3VWc/uj1iS0HBrnNEUxhN97JqinA0MCCynrAgkyhkrjbrfhfzZQVosQP5aVzvgLDVTJveLURlriI1/1refTFYE9117cOhdgnL1mttpbn2kKYkriCAy+3v2/JOUxVCe4OAI6MMQDSAMmHQTcAkezryDJMma1kWUbkNa1f05f41n1yV261fOw3AynPZAQbxIZqSJfjLMMQeP+eAsUt7A5wUnZY+qUsWPucVBn0E8tmmOifN5IKU0ZxwTdfW1wxs8ALkj0SVUvkZs7N8N86FybOoMdjEdbWC/3SD6LlOWyJQLrss2ecbzbiPM8up9WJQsRLGxTpmJn2I305F78L+1/s9Spw6RGAA+0BRyqcSbGQ02yZsNgYtpQL7DgqCJFAj16Hvo1eTSuENuv3Am4KrzJy08yMiK/pysDAVYMSMvFGRDUsJlIeXTlJfvsiXTtwQDqzGipZDe9UMU9xbIdHQksw97JkIh2A2C0EyCkCPEmaOiy+WZCzX205+jx/xSH9AcZvWIUhe5OaiifW7ffEFvSYTkJVQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF7551E6552.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(38070700021)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sSX/8B87gxS6H8D6W+P6KMZNTpf3n3TF6Cjxo/bF4Bk/G272bNkXkB6OCrUq?=
 =?us-ascii?Q?z93oEFixkq1HGBCus2FaipaI8GJ4Wu7kxCfhDWJZLM+eSdVeCED4fraa0Zgp?=
 =?us-ascii?Q?eUQ1Y2WMmh3p8X/aFahBldDH9VoRFSyCFnHgw9Fao8fcbVSw1meeY9lN672n?=
 =?us-ascii?Q?cQx1s8NaxntDn14io7BdnEBkN1hCoCLPG8wVvlxRiWbGixyCw2zgOrC7iwuJ?=
 =?us-ascii?Q?zWsE76wA9tLqU2TQk5vm7lc2R3FFKa2RIxOmJpp+spCL92ImckB7jjXlxzda?=
 =?us-ascii?Q?9g+DoBItXzdFRU7DH17P1DS/DmAVb2v1f0QlwIMonUgQI/yrQo+uD+X26OMx?=
 =?us-ascii?Q?FqdsXlwtJJYcv5bQHVQq/Luikrb58CdumJvMtyAN00FnORAVr1J1/2TEHoEg?=
 =?us-ascii?Q?5UBuvPzqi3LcX9dxWGcuIcARARNBZ5AhNP6WV8+Qj0xWAg6HPLV5BC7xWP6l?=
 =?us-ascii?Q?Zx04EISnWzvc7hHdML4f332kBNPMU1sKuVaHts+a6vU6T6mRwp1O21soLTZQ?=
 =?us-ascii?Q?HFd7zK7lfmHqDl/IlFQI/z+MQKyWhv5C/oluahAp5RKGTm9TNg/2ZdKkyYtU?=
 =?us-ascii?Q?O/sw3fmEEEBT9kugif8Vl34CldeGRcqN4N4AEILSQXPSBWGlxnXhTc13QYYv?=
 =?us-ascii?Q?w5fvYFLVDtCQ8ImivLteEW707d7Ju7soKYt4FCUTb3Ouc2wRXFj6eZdI9b9M?=
 =?us-ascii?Q?7PIIJlQMfb6v3c2LPaZRqicowX7bEt/8+Sv60ccVaB6Xaho0goMuNcx0Rv4L?=
 =?us-ascii?Q?LvaRPo3NuWAlzZiOKOw7ZUPY9edWidV+Fm+LpbWSnBA9X74AgC7vQc2Vnodj?=
 =?us-ascii?Q?r//BARJQDjiAdTY3QMZ4E8p1H+yXkxHLORAGaB+f0tk7Lnq9IfBg6togF70U?=
 =?us-ascii?Q?OJy96dtp0Yg9yb9RTwgZY4JmqmzbmZn/fyfcS3yy/dcUWhURrBhmqmE8ZJAT?=
 =?us-ascii?Q?xZhM0poCMfoHyevgWC3w3ytuWpl6X9+8YVzvZ7wWpaSdOyOqMod7E7cjf7Fc?=
 =?us-ascii?Q?U3mERPDH3PxLPvarDExbShYvFn0wQX6Lpoqhxe4OziXX1iiLY8pUEmi7srE6?=
 =?us-ascii?Q?XfARDlwO736sqrvkTaw50OlA5iqriQGIP0oeF8DHvmssnAsIUjHq5ZZvO1eI?=
 =?us-ascii?Q?fahKEk9rdpnTS2CO1LWspVplA67pUDwfZIh3m0IPr47sf8eMFVUQF57WNRi1?=
 =?us-ascii?Q?RKNSWdeIDY6uxu5XOLxrtOrLU8tcRnh6uSdmYlSviYbOZ1p0PvgxNRQoyjvm?=
 =?us-ascii?Q?3KvvasCsexfeLaGjz8HikK6xJnRNH+e1uQGyc/kV8fYjDVU1MxMuKDXKJwrz?=
 =?us-ascii?Q?Y0i2amexBtgnGawLQtiHPPSnqhX8CEB2SniQGW1754pTc5RR7aIkCcDJvYTB?=
 =?us-ascii?Q?f7OVK4x1UGMXu9B/4Io9/slchNjlpVmQrFQwdKtEaRnVk5QfcXDFTtr1ncpp?=
 =?us-ascii?Q?u/CuIODDIFgFZtjQd2Uekhjf1LQo7SMvFGGuZFmw54KW52cCYloFenC6acO2?=
 =?us-ascii?Q?CkJLU/w5X7SVjKnIvPiK3L2HsVknXQJE0j79hNL4l1uJadugsMoPBRbC3TVy?=
 =?us-ascii?Q?anDx0tu7L9/HTUAqoUzdeA8McFO2HMVHDArvsyzb9Gs0uqHeQCW+clMoxMu/?=
 =?us-ascii?Q?Je5lrUJhGd7AKFM9dg/oLHqwHkDe+5zC1zV7ZfQ0aAkwfnNhjcyFNNecyF85?=
 =?us-ascii?Q?iGHnAcYf1T2aF/fhzAskTTH6FUba4yvR6IoZ+VVfjmHbvfedryPN3punAV3d?=
 =?us-ascii?Q?ytofAFJz9/E3BuGtppJ5IhfULhAqcmg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: N8qGpwpbLDZ0HMGwf3n69DNoCwLQv6GAqo+v4YjvGlJBae8Jji3IYGExckEw4IaEP47bxQl/wsF68Yv2dEd8nyr226cXN0X6gv+5UlMxcR/eD8zKxdHcxrPeO3dO4yO2+XZDVZl0cKsNUyE6GP9mwDBIWS2iGUinGEId665mb9u3AyEYLxw/6x9MTxRXSkdohfyFe+68sXmF9YscMXytf2wgTF4smRBM0WjDFoKZLz+8K+cKb3RyONaxawx9BdN1aHvGwWc5PU2FAhpCFxvTTT+UAl0/WOfc6WkUnJv5ONuONrpLeS772N/SfCwJaR4CGlSpFK/chEiizGQtjTSOrg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF7551E6552.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18724d0a-0e0d-4a94-5c00-08df29e060f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 10:46:18.5261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bvW1Vt4avfdA2BKaqztnS2qlBc2NKQe2fq080+6m5irEE3VqMqgsqiNvhNcou1cPqcorKwMQCCkHFK9kiiPG1pNXbCKkaZmmMljPM8eQ8vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB403611
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Yuyang Huang <uyoko90@gmail.com> On Behalf Of Yuyang Huang
> Sent: Monday, October 12, 2026 3:17 AM
> To: Yuyang Huang <sigefriedhyy@gmail.com>
> Cc: Ajay Singh <ajay.kathat@microchip.com>; Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com>; Andrew Lunn <andrew+netdev@lunn.ch>;
> Claudiu Beznea <claudiu.beznea@tuxon.dev>; David S. Miller
> <davem@davemloft.net>; David Ahern <dsahern@kernel.org>; Donald Hunter
> <donald.hunter@gmail.com>; Eric Dumazet <edumazet@google.com>; Ido
> Schimmel <idosch@nvidia.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>; Jakub Kicinski <kuba@kernel.org>; Johannes
> Berg <johannes@sipsolutions.net>; Kees Cook <kees@kernel.org>; Kory
> Maincent <kory.maincent@bootlin.com>; Kuniyuki Iwashima
> <kuniyu@google.com>; Nicolas Dichtel <nicolas.dichtel@6wind.com>;
> Nikolaos Gkarlis <nickgarlis@gmail.com>; Paolo Abeni
> <pabeni@redhat.com>; Sabrina Dubroca <sd@queasysnail.net>; Shuah Khan
> <shuah@kernel.org>; Simon Horman <horms@kernel.org>; Stanislav Fomichev
> <sdf.kernel@gmail.com>; Vadim Fedorenko <vadim.fedorenko@linux.dev>;
> Willem de Bruijn <willemb@google.com>; linux-kernel@vger.kernel.org;
> linux-kselftest@vger.kernel.org; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: [PATCH net-next v11 6/6] selftests: net: test AF_PACKET
> multicast dumps
>=20
> Dump the link-layer multicast addresses of a dummy device and verify
> that ifa_index restricts the dump to that device, that the all-hosts
> address joined on link up is listed without IFA_F_GLOBAL, that an
> address added with SIOCADDMULTI is listed with IFA_F_GLOBAL and
> IFA_MC_USERS, and that IFA_TARGET_NETNSID dumps another netns.
>=20
> Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  tools/testing/selftests/net/rtnetlink.py | 73 +++++++++++++++++++++++-
>  1 file changed, 71 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/net/rtnetlink.py
> b/tools/testing/selftests/net/rtnetlink.py
> index dc8c77db48974..5534ade056a5c 100755
> --- a/tools/testing/selftests/net/rtnetlink.py
> +++ b/tools/testing/selftests/net/rtnetlink.py
> @@ -5,13 +5,18 @@ import socket
>  import struct
>  import time
>  from lib.py import bkg, ip, ksft_exit, ksft_run, ksft_eq, ksft_ge,
> ksft_true, KsftSkipEx -from lib.py import ksft_not_in, ksft_not_none
> +from lib.py import ksft_in, ksft_not_in, ksft_not_none
>  from lib.py import CmdExitFailure, NetNS, NetNSEnter, RtnlAddrFamily,
> RtnlRouteFamily  from lib.py import defer
>=20
>  IPV4_ALL_HOSTS_MULTICAST =3D b'\xe0\x00\x00\x01'
>  IPV4_TEST_MULTICAST =3D b'\xef\x01\x01\x01'
>  IPV6_TEST_MULTICAST =3D bytes.fromhex('ff020000000000000000000000000123'=
)
> +ETH_ALL_HOSTS_MULTICAST =3D bytes.fromhex('01005e000001')
> +ETH_TEST_MULTICAST_STR =3D '01:00:5e:01:01:01'
> +ETH_TEST_MULTICAST =3D bytes.fromhex(ETH_TEST_MULTICAST_STR.replace(':',
> +'')) ETH_PEER_MULTICAST_STR =3D '01:00:5e:02:02:02'
> +ETH_PEER_MULTICAST =3D bytes.fromhex(ETH_PEER_MULTICAST_STR.replace(':',
> +''))
>=20
>=20
>  def _users_for(rtnl: RtnlAddrFamily, family: int, grp: bytes, ifindex:
> int):
> @@ -105,6 +110,69 @@ def dump_mcaddr6_check() -> None:
>                  s2.close()
>=20
>=20

...

>                ipv6_route_del_reason_expired,
>                ipv6_route_del_reason_ra_withdrawn,
>                ipv6_route_del_reason_absent,
> --
> 2.43.0

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
