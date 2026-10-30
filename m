Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793353332;
	b=j5U2dLlNiGPoUplp6G04WvUVZ5g19qalizvJMGO79Qz6Ok3F/Vh1q1D8tOU8Vg4MrX9t
	 RlYRlOD1RN7mumszwSwpAXEMFmJZrUh9f2DjAFFf8LQmXnNI26llGqfPmUU1b4ZdnXJrZ
	 d47Z14KcnijysSfms3KbBTBYSdXWpEB7F4gEf1NWm1GYdAqIthM1U/82XxTk5BIh7qGNS
	 U+smdjytl35qTLQgZmzO0FB8CZ16Zu/F57K54LN0ep/YuU9NBF+QEQuDg+w6lhcFFYMo0
	 lWp9+GH/kKvS5FMzKkaf+0DK5/JyU6+XNgFRoVRoeFCOrgXdq0ODqOINuzjutZn7ikA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353332;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-MTK;
	bh=nE203Ehfh2yYvSr1Z8eV0iQfe32QzO+G920rSx0rrfk=;
	b=iYFib8SRlZDTSp9y3bTGwGu/3qYau0xXbVvAzMH0kL0sbMq+8M9EJjXXqdv8QvjQimgI
	 qQ4QAhbVBfIU1IDNWtOiG+zbJzfqCGzeA+OzCSZ2aNUjaJCCHnbV47fVhAyXwd6o1E/hl
	 r6lCgGw7jTqReaxN7pKNNGdVulCliDDCFrdA8xsoxEBF75nBVR+vagLRwPUciVzRAjULU
	 OG4WI/fv2mIQ8Iyma/3RDTGnCURfZBmZv7S3DV5OPrLYWYC2xe0TlKQHdkT82WjRxNKxU
	 0/EvsrRJZiQsAfQ1AfmiJNEjNoROIGBlvTpuxJDU1X9Hyf42A17A4SFNykJafUtpdJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=beXYYp20;
	dkim=pass header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=pgsmY+9K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328F7606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 328F7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=beXYYp20;
	dkim=pass (1024-bit key, unprotected) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=pgsmY+9K
X-UUID: 297798aed44611f18dc8c9802ae25ab1-20261030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=nE203Ehfh2yYvSr1Z8eV0iQfe32QzO+G920rSx0rrfk=;
	b=beXYYp20btV+1ezz4jc5FCxaiUOnuI/lAQrDKa0G4I92Djo1nAk+gmMFgwsKKh1h+nmoa7/sVDHnXeKQHHAMiqN91adsDXAH3b7vWCW423lClSvVJc+UDPnmrCL1tIKSUrwp/q86OrNHjp1AgiGZVVUPGL42HaPw6x9/ZkEJoOc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:2f710599-af0f-46d2-884a-fe03201f8bfb,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:b0318ac,CLOUDID:260ce8ec-b50c-48b5-b20a-bfe3130e16d3,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 297798aed44611f18dc8c9802ae25ab1-20261030
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1575561613; Fri, 30 Oct 2026 17:42:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Oct 2026 17:42:02 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 30 Oct 2026 17:42:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qK4Nddb1FWItxG6NHRUK+pWHItbCiBp2B0m0MtpCy3VmEGhqAXw8K0Bktr4IwuqawH9KGybYH7v+g8Q2zRWkN7z0zd0UqsnpqdHS4uOY8T5PnVqBVRsixqISmCVAR2CYFTgX1tVCUnbHD8+k6dZ4PYa/YTYX3ZGW7Aw4ej0nk7pagU8G4hsILhS8T+bib2XAxPPA+PShK05ibuaHzA/oSAW1tDxuau040lfg/kgrfzJBbj3a2isYjG0z0mmxNrYeHalfnb90K3dDdt+JWfxuL99BAXVT7NeHBxbixnlDZ762idoOjb59kBqmHKUzo/Uq1IfOP1RvQsiEfKXmcbBu6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nE203Ehfh2yYvSr1Z8eV0iQfe32QzO+G920rSx0rrfk=;
 b=MPlHVsydBy7CIOyOyJfYF2W5cGPFkuFNEX+rIhVxf102hNntaRBAJtkxyDmByjJQoH+rXiBUqc2pSfaFJz7CHhzpa6vKeaaBTZrTKq509dT0vxdayiq2FLAsDlrnVIxyB7DkLqVAKtnqW7twglSkeoQhQ9vELs4mHtpf8UaJ3R3ew+gz9UDhl3C1fOnb+HaqSnim5SYH3wbLCGfFsPTjSZpyes7aG6OhEu664rTWQ3mLbcrZZTKnZ6p2iIDvG8UjuLm/tQJQ5kRhRtT0N7qcivXyKjobiOcHpvfhNhvDeSeBM9HuWmIHA1EUP8Oj+TP8hPe1o0M+Bti4MBoT8Kgn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE203Ehfh2yYvSr1Z8eV0iQfe32QzO+G920rSx0rrfk=;
 b=pgsmY+9K1JYcYSsTlXpAzlYkWrYOdSqI9Bs4JiOXmHvvVcOHkGDFPXAtRwN036U8Xrb2j+NJ2mNTEBCIgHpJWUroAmKSQL+hLDF342/YaSRV7QIL/nUBG/vaHdA0Y+b14XiRlJnsIy2VLz/VX54rK9xZziC8CjG4BCQdfn+VvTs=
Received: from PUZPR03MB5990.apcprd03.prod.outlook.com (2603:1096:301:b5::10)
 by SEYPR03MB7022.apcprd03.prod.outlook.com (2603:1096:101:c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 09:41:59 +0000
Received: from PUZPR03MB5990.apcprd03.prod.outlook.com
 ([fe80::15b1:fccd:e3ae:f89f]) by PUZPR03MB5990.apcprd03.prod.outlook.com
 ([fe80::15b1:fccd:e3ae:f89f%4]) with mapi id 15.21.0569.008; Fri, 30 Oct 2026
 09:41:58 +0000
From: =?utf-8?B?QW50aG9ueSBMaXUgKOWKieiJr+ajnyk=?= <Anthony.Liu@mediatek.com>
To: Dan Carpenter <error27@gmail.com>
CC: "nbd@nbd.name" <nbd@nbd.name>, "lorenzo@kernel.org" <lorenzo@kernel.org>,
	=?utf-8?B?TGVvbiBZZW4gKOmhj+iJr+WEkik=?= <Leon.Yen@mediatek.com>,
	=?utf-8?B?UXVhbiBaaG91ICjlkajlhagp?= <Quan.Zhou@mediatek.com>, Ryder Lee
	<Ryder.Lee@mediatek.com>, Sean Wang <Sean.Wang@mediatek.com>,
	=?utf-8?B?RW1lcnkgSHNpbiAo6L6b5om/5a6jKQ==?= <Emery.Hsin@mediatek.com>,
	=?utf-8?B?SkIgVHNhaSAo6JSh5b+X5b2sKQ==?= <Jb.Tsai@mediatek.com>,
	=?utf-8?B?S3VuIFd1ICjlkLPorLnoh7Mp?= <kun.wu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?utf-8?B?TGl0aWVuIENoYW5nICjlvLXnq4vlhbgp?= <Litien.Chang@mediatek.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mt76: fix buffer overrun in pkt buffer
Thread-Topic: [PATCH] mt76: fix buffer overrun in pkt buffer
Thread-Index: AQHdaFLotV2K5pHFwUmCXwn/4UN8qg==
Date: Fri, 30 Oct 2026 09:41:58 +0000
Message-ID: 62434d97e54908f8a5e8b5b6db590588f8f77b3e.camel@mediatek.com
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5990:EE_|SEYPR03MB7022:EE_
x-ms-office365-filtering-correlation-id: 6b16df12-68e2-48da-8d88-08df366a0ad4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|38070700021|11063799006|56012099006|261026121527099003|261026140227099003|10067099003|261028144727099003|261022105027099003|261022075727099003|261009223027099003|18002099003;
x-microsoft-antispam-message-info: uPxn/XFwdxeWHCHlM2HFKwfslZlnANuJAeFOy18Nr0+nFpDmbV3WWN0wa5M7EvytLH4RpXFOvfPryTtSLhTuuJI8PlCqwoeXSX9i7nTAjj25p4Pvqvj8vy5HCqp74U/cjDrWZzlLIMJxrgpDKEFf6CAPYyMLzPU0xrCQmpfbOixbVxluhdZ13lUYDdKWnClFzjXOLzFDzJ3j//XCvQgOrQCewgWAkiV22wIIhKPoOQ6/R54WU7DY4gpo1YbGz0PgCdLt9jT0LCrSFhKJuiAKmtyT+umTtKj/wZTdI6ycRq4YuV3UHQdv+hpP2h6H8ZcBvsVlyWi9VPen1NDR3ADMXqSn/U2wIdKILz4TjQXr5pHm/WH10Vy7wX4wgSXQCt5NRBIsFzrQtLi1vGX7ZsLSyHIp0/UVy6SUItiGhqd8fnWqU/QYORBmtmPPl6KciT82uA1cZtmwvpk8n5A9UoEAhhptIHjmygky35AXxLbYvr40OqXWHnSW/rv/IeIQlMaXGOhCPBWHteH5II9Zs+EbisDZxAI/jJ4YSZwbSXOlZNlzVCCxeABTxB6k0dL2Jw4aw4KbYxHoelx1sxDFGxnJJw0zGZGwvmaX52QNv+YYfEjW2zQdxQT/vNLSc8VONX9esUWBMR6yXU7Q7CPsXmP6w5QAXk6k3cLNF5j1dt1Qnw4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5990.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(38070700021)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(10067099003)(261028144727099003)(261022105027099003)(261022075727099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1psMWcxNW03RFI1VWFJK24vN1lCclEzaEl5cXZ0RlFwb1RTcStGTjBBUzN2?=
 =?utf-8?B?Q00zN2tDUzl6eDlGUHc3MHdKRktRcHJ4OHowZTVoY2VneW1uZ0FFbFdwbVhP?=
 =?utf-8?B?dzI5bHpxZmoxVFU2WVFsT3VLaStFYzR4SWc4Y0U5ODZKaHRoalpNbXM5dDNu?=
 =?utf-8?B?YnM1SldiZzlGeGNTYS9aMGZTaVBDVjFkTW8vWmpWRXFJQXZYSHJJNEtsMFVn?=
 =?utf-8?B?NlFDNHpVTDV2bFRhclcrc3MzMXdYUG03Nkc3SVpISTN2ajVuWU9oVXczeFpI?=
 =?utf-8?B?U015ekVBNkpWc3VZZVhESFU1aERBOUtvdXNMV0FSUklLZTg2MGhxRXQvMW40?=
 =?utf-8?B?NG1rYnRsWGsrMGRtQjBiRElmRjZBQkkyZFo3cTQrL29nM2FzUkZKYS9iZ1k1?=
 =?utf-8?B?QVFrSEwvZDVidVp4WDIrMmJ0R3p5WFp2UWZFekxUcjVaVWdjUVdESzFDOWpU?=
 =?utf-8?B?bkpVbm5uUkxaL1lyUVdqZDljbHdkUTZTYkZ1TmhzVGI3bkh3WDU4a0duMXl3?=
 =?utf-8?B?TkhxbjVkd1RLNWhJbkhnWWtnVHY2U2t4MXNKc3dVZyt2ZVJieDR4bE54dk9W?=
 =?utf-8?B?VXJ4T2lJcWF0aFFuZndLRGRzL1ViaTcvUm02WS9oWUZYb0tqYUFZSElvMXRZ?=
 =?utf-8?B?WEgyOVMzV0hZYWtxRWVFdG50ZlRmbFFGbGlxczRPWjU1NnBlSG1xb3VvOXR0?=
 =?utf-8?B?RkJtQlJzdFZQaWdrRFdWN1BvcEttR1JNaXlqNnZ6MmRQVzRxTmZwajkvNU1N?=
 =?utf-8?B?OEVmWlFNMzl3SUJ1QUtqeUhDUkxOeTlTM2VZTXk0Mlo3TzlUTHdEQnFtSHdQ?=
 =?utf-8?B?SmM2UncyckpjbS9MWnhWOE9aRHFzeTYvcndmOXFwSGxpMVJ6NXNhRjNKbEhZ?=
 =?utf-8?B?S2dDaEFzNFNpZUlGY2Y4SC9QWXhiRzV3SGl1S3JEM3lRdVVkbUxqR1U5Ymg0?=
 =?utf-8?B?TGVKeGxqMEJBeWdZVERpbmduYWM5UitpdzJZMyttejZadGpiUU1wL3hBYXV0?=
 =?utf-8?B?TjhHVjZUYWdha0krQ1hraTNHWEhtWFJhOGptZ0tWMGNKN2RYTVp6R0dKTmFt?=
 =?utf-8?B?MXY2Q2x0NSt3ODdCWHRuQW8xcWIzTVh0a1RRVzdyUThrOGFLTllCbXJhS2pk?=
 =?utf-8?B?dkk4MDJGUFkwQVVib2o2bEJ1MFJNYnJPeERWRFVoVkwwa0hNdm9xc3VCWDdK?=
 =?utf-8?B?NVdvTm5yN0lsWm5FalN5alh5SzMvanh1ZnpnUnpiQzBqSFZLNExzTU93VnY3?=
 =?utf-8?B?NngzVkE3VjhSVjhNUTUyUUdKYmlTUzgyOUluSjBibFlXcTVqbUVLbEZqVHZ6?=
 =?utf-8?B?L21RZ1lIZ0dta3RPNGZPbHgwcEZNMms3d2tOOFh1cGsrWjdZQVJkVXgrNW85?=
 =?utf-8?B?aEdOdVpXNUEwSFZrV3FPbS9SOWU5M0lyeEZXQXhKOVlpQUhpT1F1Y3dzK0ho?=
 =?utf-8?B?aVV6THRkYjlsQ0FldlY1NHpCOFRuNzJXMm9WN0JCdUVJT0NpWjZRWWpPNnFE?=
 =?utf-8?B?bVZtWTBkb0xnRWRDVVM0WUlhU1drVWJHSFc2Q3EvVXNydDZXY0MxZEpPTHJi?=
 =?utf-8?B?ZkNnZGR2NUJIS0QxOXFoN1hXUzJCdndvTVNtWFRjdnJsQldlNHJMV3lSMlZE?=
 =?utf-8?B?OWk4a2ZXOHRyTEdSNVN5QnAwT1VWa0M4eHFnbnBjcWtHR2JwTTlSa0NXYzFz?=
 =?utf-8?B?Nys3dVFmM0Q1UHVkQTdlWDkxdFd4QUhYUjRqK1ZUU2QxQ29CeFN4cmVmMXE2?=
 =?utf-8?B?S1EwRzA2YXNldUc5WkZFVVc5dlQyV3F6QktaUWViYW9WNFRUajZSWHBkemxO?=
 =?utf-8?B?YUFDWXcrOGg0emhnWWZhNVptNnJzM3ZrZ0QzY3Z3eTA2a1FNMnhxRDhaMXY1?=
 =?utf-8?B?dyttM3RubzhIQ3pzT0Z3QjAzOUM1UlZkN2VIbjhuNTgvNTBTUVo2VmpBQndB?=
 =?utf-8?B?ZG5YMDQxUk9FdkdDanlZL09jMjlZSFJia0FMa3pZZHJjWWdHNnNBM2JIb25x?=
 =?utf-8?B?dmlkdG9yZDc2MG4wMlkycHN0MGtGdkdVdmNVdkZ4dERFMHR3WHdwaWw0aGh0?=
 =?utf-8?B?aDc4cVdNczUrV2RmOGg1dmx0dXk1K1g2WWF2ZVc3ZytiOHFOWlkvelBpU3JU?=
 =?utf-8?B?dGlIL01hWjQ3MzArNzYvUUdxckhJSDR5QndJRi9aSkJ3VlBqcFBQRGNWSjNp?=
 =?utf-8?B?QUR5OGZDem9Pa0hnbkoxZ0lxUDNNd3dsdUZJYzNmbndPVjBEQWMxT2xhVXFR?=
 =?utf-8?B?WkpkN3pCYVhaY3FaNkgvZi9EaFpDdXR5dlAzeFFtVEp2U29zNnd5SDJwWUll?=
 =?utf-8?B?ZUM3THdMMll5ajZDLzl5cEhYUG1RU2dnQ3FvWldQdkFrWDhwQnpTUT09?=
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
X-Exchange-RoutingPolicyChecked: XTJ+95ah9mUV2u4LZXJ1cywqN3KMvNrCfi8qcQqipylEEPnbhqM4d5JIoYrZjrc4A6QD7+Oh7o/rekE/q0IvQMRKXxzmFAAExfhihKrOjHeomNno0OIQwYIBAtv5zqvVd1Fqr2Ep6JCxy8H7H73yDtMUZRKBR0Ba9jZRnke/fri5yAnWxkIZ6wrg5ILJ+H0Adx+n7c3w7V4B7DcDNRDZaXthibFcBHrD1Ohdwbkfhrkp9V3GMj7eWhR/ZgYDkJGrxNEf3gkupqywIIUMaGCskSBiuZc6oN5RNuSDm9v9RQY+d3HtA2Q60fg/nxjq/7I+sfz6nXb56ZVhhl11IA8Low==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5990.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b16df12-68e2-48da-8d88-08df366a0ad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 09:41:58.5829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6v2Ansd7RbO+8Qbe4KcisZorcWs2oeRY8IQPLhxUkPHqmCNzDkXBYO1B98rvxA5TQDbdVkWEdRem0ZBPnYm2FiBzK94D1nArREfoXRuOlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7022
X-MTK: N

SGkgRGFuLAoKVXBkYXRlZCBhY2NvcmRpbmdseS4KCihTb3JyeSwgbmV3YmllIGhlcmUuIFNlZW1z
IHRvIGJlY29tZSBhbm90aGVyIHBhdGNoKQoKYnIsIGFudGhvbnkKCk9uIEZyaSwgMjAyNi0xMC0z
MCBhdCAwNzo1NyArMDMwMCwgRGFuIENhcnBlbnRlciB3cm90ZToKPiAKPiBFeHRlcm5hbCBlbWFp
bCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bnRpbAo+
IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNvbnRlbnQuCj4gCj4gCj4gT24g
VHVlLCBPY3QgMjAsIDIwMjYgYXQgMTE6MjI6MDBBTSArMDgwMCwKPiBhbnRob255LmxpdUBtZWRp
YXRlay5jb23CoHdyb3RlOgo+ID4gRnJvbTogQW50aG9ueSBMaXUgPGFudGhvbnkubGl1QG1lZGlh
dGVrLmNvbT4KPiA+IAo+ID4gVGhlIGxhc3QgcGF0Y2ggKGQ0ZTVjYTM0ODNhMCkgYWRkcmVzc2Vz
IG10NzkyOCBGL1cgNCBieXRlLWFsaWdtZW50Cj4gPiByZXF1aXJlbWVudCBieSByZWR1Y2luZyBw
a3QgYnVmZmVyIGJ5IDIgYnl0ZXMsIGNhdXNpbmcgdGhlIGNoYW5jZQo+ID4gb2YgYnVmZmVyIG92
ZXJydW4uCj4gPiAKPiA+IFRoaXMgcGF0Y2ggcmVkdWNlcyBpbmNvbWluZyBza2IgbGVuZ3RoIGxp
bWl0IGFjY29yZGluZ2x5Lgo+ID4gCj4gPiBGaXhlczogZDRlNWNhMzQ4M2EwICgid2lmaTogbXQ3
NjogbXQ3OTI4OiBtYWtlcyBzdHJ1Y3QgYmVhY29uX3Rsdgo+ID4gNC1ieXRlIGFsaWduZWQuIikK
PiA+IFNpZ25lZC1vZmYtYnk6IEFudGhvbnkgTGl1IDxhbnRob255LmxpdUBtZWRpYXRlay5jb20+
Cj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+Cj4gPiBS
ZXBvcnRlZC1ieTogRGFuIENhcnBlbnRlciA8ZXJyb3IyN0BnbWFpbC5jb20+Cj4gPiBDbG9zZXM6
Cj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDE3MjE0MS5tbVJtR3Fvdy1sa3BA
aW50ZWwuY29tLwo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVk
aWF0ZWsvbXQ3Ni9tdDc5MjUvbWN1LmMKPiA+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0
ZWsvbXQ3Ni9tdDc5MjUvbWN1LmMKPiA+IGluZGV4IDI2Y2RiM2YwYTk4YS4uMTMxNTg1YjMzNTlk
IDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5
MjUvbWN1LmMKPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3
OTI1L21jdS5jCj4gPiBAQCAtMjQ3OSw3ICsyNDc5LDcgQEAgbXQ3OTI1X21jdV91bmlfYWRkX2Jl
YWNvbl9vZmZsb2FkKHN0cnVjdAo+ID4gbXQ3OTJ4X2RldiAqZGV2LAo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gPiDCoMKgwqDCoMKgIH0KPiA+IAo+ID4g
LcKgwqDCoMKgIGlmIChza2ItPmxlbiA+IDUxMikgewo+ID4gK8KgwqDCoMKgIGlmIChza2ItPmxl
biA+IDUxMCkgewo+IAo+IEkgd291bGQgcHJvYmFibHkgdXNlOgo+IAo+IMKgwqDCoMKgwqDCoMKg
IGlmIChza2ItPmxlbiA+IHNpemVvZihyZXEuYmVhY29uX3Rsdi5wa3QpKSB7Cj4gCj4gYnV0LCB3
ZSBkbyBuZWVkIHRvIGFwcGx5IHRoaXMgcGF0Y2ggaW4gbGludXgtbmV4dC4KPiAKPiByZWdhcmRz
LAo+IGRhbiBjYXJwZW50ZXIKPiAKPiAKCg==
