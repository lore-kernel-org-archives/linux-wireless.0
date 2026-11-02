Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793603863;
	b=HPfxMLGsB7sBRaZ9FZMPBb/mGN7DvdURGfdJOEeZ7WFmP5WmjJs+dr/NiEm1rNn6AF6H
	 1vVXksfR72JziQPzL1pALkQgIc4Xf9wdC4tBT2Ymol7jaZnj0WQheiNxjjDnECLzv0Lf8
	 drbVdbMUdIBC4WOH3JceNV+YyiTiNfWqfFafgQaq6V8YlayWbLInvNWVDQ1SEJnx8jVbm
	 2XpdrdJBAjMAXNi+Fe/SRYx9sWVgTNSaSqFft3Q1rEnC63WmrlyywCIZel4iy3/1Xnnaw
	 XOqgGg9KEWQ4ugn+FKEoy+QURGKA/p40hl7guwv1y1d3iXJ7ToGd3EBE4SHLVglQkuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793603863;
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
	bh=ioPT3XZk+S+ikZjH+fxBpawkLBfFW4PA1H6IDLT3BPM=;
	b=QnfWZNlKxShTNX3/pg73pexy6XOicOuphdP1FRIMDFBHXUwwEf3aSNPAnVVMZEBFNCOu
	 fd9Hrz8F7G1h0G5OiFvRIaoV6tfcISGR/VqdulsOOF5tsZcvx+S4alfl9cl74A6wAaGdQ
	 vtasAMWk2glLsRedTU7QYpLS1FXFUqCj7811fOZZ8Z8zht+pfXNcrRZfQTj1WZIvvO/0V
	 vD0sS27WjaH47nmrt8Lro27RAYJ6GqZelFh2dlC3E6CIy9RSx9xm9CWmTa/n/YSl8VAZP
	 cKnvG7UUrduCE4yL8DAI0BQ7erSJz391Z/tD0PeffSZvc5DTMldDktCh4cL4kbcVJog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=aFJ22g9e;
	dkim=pass header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=o4ENLaVG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168C2606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 07:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 168C2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=aFJ22g9e;
	dkim=pass (1024-bit key, unprotected) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-mediateko365-onmicrosoft-com header.b=o4ENLaVG
X-UUID: 77062286d68d11f18dc8c9802ae25ab1-20261102
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=ioPT3XZk+S+ikZjH+fxBpawkLBfFW4PA1H6IDLT3BPM=;
	b=aFJ22g9e+EMdhh44hqjaaRWdb/103fDdu9IPDsOWGSFgmH3F93LReoihzzDBew9LH5raJuYvyAcUyxEA9t+TMT4nsGZhy5rdMjjWeJaDi7xeBOOzGgDc+8Sv4sR112MgyAiEvxa4pyCKklwbEKsocA+tXzQq1Jv888XFwI9AUIM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:492b7817-d920-4f10-9787-77f0a387a00b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:495468a3-2f6f-43d1-a751-2a61c87fd6c5,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77062286d68d11f18dc8c9802ae25ab1-20261102
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 525178300; Mon, 02 Nov 2026 15:17:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Nov 2026 15:17:28 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 2 Nov 2026 15:17:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjTFESbr9/qEEDA86Z/DgdyKo4fRxI0ZKUhFVpul0+ULRG/NsQQgd7nii96n+CheIrmWWa1Bzd5iDXNIcVdGuKcd/J2c34G6OiEeyG17AN6G298Ly9eyOcBVow3zszE/dTF1tw/Ocu16EOB7MX73yr2TlvcfrUsZWhd3taydFj7c6UDaRleG+j/Zx2OO1Esb6QpJ1avwGx2zmmFPim45KITYeguRgiJ4LZLkg+01FO/115Pz+ZAf5JRAy0YhZcoVr+LrzyyUMJVY+dkzBZ35gK05z21jiUMkXlBZcLNq+5RQk4iDyKydHz/GlVmwoxDsp4qBLsDK6NBMgk6qYzMm5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioPT3XZk+S+ikZjH+fxBpawkLBfFW4PA1H6IDLT3BPM=;
 b=UF6lWFD4X/nsdkzGTxPjFpqIrC96R2GtAOtpxXbWLUY7knjBfBLf6vCHpV+hkRLZKfABhbzUTgshUaU6BS/yjeGHRXxggxku2zLJJ+HOxvnsbphr/xXaLZO0QA4+b2aIbkR0o3vILSxoq2rzMgxPfWbvLuroVXVog+vzJdJHUQU5ExE+0oysDvcKwiiNTnkAom2mtr+yyKJJDL2+fokXcmoY3BH+J8FsC9/0/Sn6dZiJF8bEqI0zEa7zA/n/yZGzhyuj8dVw4TwmWzFRq1eeU2gln/4UQc0pydcsYlf3g81oDRZSYuO/TNnf610YHGvS4osXIBvPt9QUIecgUrs9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioPT3XZk+S+ikZjH+fxBpawkLBfFW4PA1H6IDLT3BPM=;
 b=o4ENLaVGXRXfAVEAJn4qjCkBa+z17gYLvgH4apZYHFo4el9wpnc+7dQgFyUH8ebmzhUUr6PbUhdC007EMBSbAvEqFuQHyHB3pRSHUjmNvTxUfsmJMrbRP6dVOAZvyEUyVjI4nfFVQd6pEow0V9JpP/AkDYcyH0UkUleFq1MkqD0=
Received: from PUZPR03MB5990.apcprd03.prod.outlook.com (2603:1096:301:b5::10)
 by SG2PR03MB6708.apcprd03.prod.outlook.com (2603:1096:4:1db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Mon, 2 Nov
 2026 07:17:24 +0000
Received: from PUZPR03MB5990.apcprd03.prod.outlook.com
 ([fe80::15b1:fccd:e3ae:f89f]) by PUZPR03MB5990.apcprd03.prod.outlook.com
 ([fe80::15b1:fccd:e3ae:f89f%4]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 07:17:24 +0000
From: =?big5?B?QW50aG9ueSBMaXUgKLxCqH20ySk=?= <Anthony.Liu@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>, "lorenzo@kernel.org" <lorenzo@kernel.org>
CC: Sean Wang <Sean.Wang@mediatek.com>, =?big5?B?TGVvbiBZZW4gKMNDqH2+pyk=?=
	<Leon.Yen@mediatek.com>, =?big5?B?UXVhbiBaaG91ICipUKX+KQ==?=
	<Quan.Zhou@mediatek.com>, Ryder Lee <Ryder.Lee@mediatek.com>,
	=?big5?B?TGl0aWVuIENoYW5nICixaaXfqOUp?= <Litien.Chang@mediatek.com>,
	=?big5?B?S3VuIFd1ICinZMLUptwp?= <kun.wu@mediatek.com>,
	=?big5?B?SkIgVHNhaSAovbKn07FsKQ==?= <Jb.Tsai@mediatek.com>,
	=?big5?B?RW1lcnkgSHNpbiAoqK+p06vFKQ==?= <Emery.Hsin@mediatek.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 5/5] [PATCH v4] [PATCH 05/05] wifi: mt76:
 mt7922/mt7928: send Tx/Rx statistics to FW for link tuning
Thread-Topic: [PATCH v4 5/5] [PATCH v4] [PATCH 05/05] wifi: mt76:
 mt7922/mt7928: send Tx/Rx statistics to FW for link tuning
Thread-Index: AQHdapo1DyuN4gImxUiP4nISA7/IoQ==
Date: Mon, 2 Nov 2026 07:17:24 +0000
Message-ID: a359fadf034e2077f7c92e1da6c9ce9f2a40f718.camel@mediatek.com
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5990:EE_|SG2PR03MB6708:EE_
x-ms-office365-filtering-correlation-id: a78be95a-57ab-4a5d-693d-08df38b157d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|18002099003|38070700021|56012099006|11063799006|261026121527099003|261022075727099003|261026140227099003|261022105027099003|261028144727099003;
x-microsoft-antispam-message-info: 6n9KHme/Bo+9RPFUqJMrVxKspFKhpFvZe+pVL3qi2EBDpCo1i21gw6I5ELR5UPz3F/yvgr3Ip8C62KN8cJgeSOO5/1nRS4s81QFYqxcL+Z3NGFJDb9JeiyBuxHvwQrX7HfMGNxQ39aEYucKMv1jdJ/9pCrRjqDW1VSR9nwn4/f8rNQWhS+lKebJN1NThKG7jv87k7qagckapuvIVLDH2Av7Pfc3eEIsQ0vNdKCzXoaPLlHSFMcEqihzNuo5FNLq22Y++42mGzdSSoupTVWc7l/RUfmcu2DMnwsWcBR4ADoJiYxLTsnsDDMgJ+Zq2inWiLFrxg1yhxL9wtomC1HTesKLSaQ3wCC0ikbWs4Fz3HyPpQiNoaudjoQJooV9K+j8VEHat7+M8z4kxs+bK6yEkexz9BnQ/sDTC5/529AbyR9iVNGXMhswj/vdCF28T9a7whmB76mnrmm0pZ5tYwfTkq4QMLSH2roFsn4ctRpfTYmfI4myYbuJxrtoXHiPjHOEe2bQ8I/ihdbYfsHDNiudAq+pGq6ztygMfx0p6GhEp6RnvBlKnoA4pa13hyiXcOhnB7gBmyed/6CeOUw67F8arRXBsaNpNw//MxmbO85UeeueG85Go2ErLexeTh4g0tZey7xBDKd/wxSq9zgJFzP6tLuS/HCyNb0qvJC/SBM40NABo1LsOv+CLKDXUQtgo/SqJ/4oquKnX+YqKME+B2DVgkWPhCHpHuDwZ9pXx5xyTqvE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5990.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(18002099003)(38070700021)(56012099006)(11063799006)(261026121527099003)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?US96STZTRWRrcDUvMkFtbVIyZHArUVZMT2VmSXpjUmZOTTZLV0FubGVQMlZsWVVr?=
 =?big5?B?UUs5VzBkTGZmOURuUFU1dFhkQlhzeENRWCtNS0V1MTlyZnFCaU5JUFhwRDZ6VWVN?=
 =?big5?B?dFUvNlVIaCsxYmRBdDZPbWk2dVFTVm9Rb3NvcHZhUjBCNHZCYnNJK281RUJHUjFt?=
 =?big5?B?WEt0RnFrSzl0VXU2clhob1I4RTVUa092UjhvSU51ODNlSW5hTHp4ZzBhNldWUkFX?=
 =?big5?B?NG9PWVVhK0ZwbDBPRlVkeVYvdlFITytlcGNxcm9xU1ZLeTAvYWQ0NzYrZzN5YUpv?=
 =?big5?B?ZjdPdXR0STBtazFHaS9oc2FrUHQ5UUduVkJwKzhCRk1ORlNuNTFyRkVzYUF4RmRY?=
 =?big5?B?MWRGaDBMTU1oUUJaeDRqOEsxSEtZa1VIdGZCbWJGamFKTFEvMm9ocUY4Qy9NT3N4?=
 =?big5?B?aUFzUEZ5VVV1WlRMbnFaTnVDNmM4TWhrbkhvMEZWRTU2Ym82SE81VVA5YnFMc21h?=
 =?big5?B?dERVc29BWVJSVVhoN1RQMWNXMU9vWjhiZUpVdnBRNGpNa3JFQ1NscERmOWtMemlp?=
 =?big5?B?Z3pDaEdVM1E2TlB0eEYwN1h4d1duWjBKZ3UvNTlIWkVYMnBtc2NZTFNIUDRxTjM2?=
 =?big5?B?dEhTM0lzalErb3lJTTIyUEVuVklRQ2NQMWdQNTFybWtJSDJuZ3pXaDhsMnJxSktw?=
 =?big5?B?LzR5RnEybHBHMEUwT3dQV1FicVB3a0xRNlhWMWJCdjlwQ1BLQnJwWURvTU5RaGor?=
 =?big5?B?YVdJZEtxaFczS3BtNnJKY1AxZHFPNVgrWCtoUm1OQ2pISkRBU3MrVGVXU2FmYjBy?=
 =?big5?B?clRBK2JuWGdHcjl4MERhRUh5YlM5MEJ4ZUVra2M1ZUErakRTTjhYSTAwdWN0WWJi?=
 =?big5?B?M0t0djVCQWREYVY3N3BLT21QelR5UE9HTXBIdnVNSW1rWlBlUTh5Y05ZSkRVMFl2?=
 =?big5?B?YzdZR2dVYVhXZzFKTGxRb1FxdE0wajhLN0ZERncxN1krbFhIRzVTT285ck9wOVN3?=
 =?big5?B?SUFnZEVodlh3VDdsb29rOUhzWUU0VHhXVFordUQzTGRCMUFtU3hMcWdPRnlMU0Z4?=
 =?big5?B?Q1JYYnVydXoxRzE5QUpRVGNXMStUTFJab09XRE0rYVVPSkxMZmo2ODlFWGtxUzR3?=
 =?big5?B?NnhJdDgxSlRVc2tpYzdsUmxkOXA0N0pWbXhnNjN5bWtxaUk5Y0ZReklZb2NkZldl?=
 =?big5?B?MHhhbms0QjdjMzUxMHBRTEJYRm04MmhXc2lkSUxQQ2xDaDBLS2VrbHV0b000a1I3?=
 =?big5?B?eE1tSlMyNGdZQ3lyd1FRdDB6Z1N6TnREWVE2U1hON2d6ZWFldC9qcHpIQlY4MkR5?=
 =?big5?B?bmNRdytSV01oZXQrcjdTUFRlUm80NDh2U2cxNHI1czJWeWhEa016bGIza1VScDhu?=
 =?big5?B?YkJ6UDdwV1ZGb2pTdU04WDloVnZ6VW1ZUmpKeDNPVFZUd3h3dDNYV1NFQVRobGh5?=
 =?big5?B?K3RBckRSdDRKeVRlYk1YR0xrc1hZUG9uTEN0Y0srVkt2ZGlCeGJQd0NuMkZta2pO?=
 =?big5?B?SHh4OG5IT1UyV3pvK3pZUEF1TXY2N0diMWFpaDYzYitvVHJUeklqRjRDRnNPblBJ?=
 =?big5?B?Nk44N2EySm82dFRjVFkwMXFhdHR5QlVFNWFYTFFXU1QveWJjMzlJMWd6bWZoN3dL?=
 =?big5?B?R1ZBckc5UW42S0F4T0Z5bkpSanAwbTgrU2pidjBSUGlHQmlhM0t4b05oMWpVZ0xB?=
 =?big5?B?OXpJWnVkS05PNHhNekN3NWhyVzBxcUU2a01MaC9rSjVMRUZYNDNIWGV4ZzFtWnVH?=
 =?big5?B?UytqSXJTZ2s1aW9IUVNwTzBvbkFOQllGdXZVdEFiU1Ftb3ZlTU94eXV1NUhWT2Va?=
 =?big5?B?WVJGY3FLSVcxV0NEY2pGNzNkOGswNGVpcU00bFp1MGVuWWpCbzJ5WDhSS0tydlZl?=
 =?big5?B?dkRZOXF0L085UzZXQys3cDdoWTlUZU1EYjNxV2dtWmVaSmNOTi9VNlZKWmNQWng5?=
 =?big5?B?c2dqR3hLaExDUmNNdlk3ZEpaMUZ4bW9SK1RvZXFIUG9PM0JFbkhiTTZRS2ZueC9k?=
 =?big5?B?M1VreDZaTThXQkNsbnBhN0FhbmxFRmVVc1R0Q2FiUHI1OEkzdVZmdlI2dGpJRHlS?=
 =?big5?B?N1pqZmZpVHA4dzFTZmNpaUJwSGVrbXRoN2JnWm1lS2ltWStCaU5HOEhKaDMvbjBG?=
 =?big5?B?dFVoZ1lQWkpwNkw3cUUzNysraTFlaS81a3YrcDNHQmltQWFBQ1VRejk4U3FXdkRE?=
 =?big5?B?K2VITDZXcVE3VENDeUk2N1M0bGlNT08zUGdaZk1iK2dSZDk2OWNZOE1pVW4zcjcy?=
 =?big5?B?b3RUNkRCem5JbkNDSVlEUkN4TXV6Zz09?=
Content-Type: text/plain; charset="big5"
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
X-Exchange-RoutingPolicyChecked: OgPnvQCKirvuVs7ZTTubxPfnQ/U7JhMxbwSn0zxJIMWGsYCDKjoMH5V2Zw5Gp702zVGWTAJyqaQCJ9jrvIDIKnPt3wsDEIXVObAolKXLDgCqMsv5TnY/2e5faZSUxvieNIwn4j5lL/i9pATPJNctcC7Kx5xrvnNBNUi+dqxYHDvPor2BcoRxP7wwmPP1t7O3zAkukDDxlbObp9j2M05rtGu74CVZVbJBAo/oIDyr97afhMJEeLPLH3vzUnF/5kESOYyxLmOsVltm1ItOqQG/LTg2nyHCxIqec50xnBPWEedP2xLuJdonetO35ptpTu0tLi14yDLSMt7LxcHSuFeZgQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5990.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78be95a-57ab-4a5d-693d-08df38b157d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 07:17:24.3914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anrkbVQ3yz/jOzJ3+vpXRbQvwE/Au19NAx429Z6mLxyBAJaoD3OP7Tc0b31AA0AqnHUNJtK+es5BH7XWON+3Ez7a7ylZlexQYGSqm30ZkAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6708
X-MTK: N

SGksIEZlbGl4LAoKVGhhbmtzIGZvciByZXZpZXdpbmcuCgpPbiBUdWUsIDIwMjYtMTAtMDYgYXQg
MTY6NDggKzAyMDAsIEZlbGl4IEZpZXRrYXUgd3JvdGU6Cgo+IEhpLAo+IAo+IE9uIDA1LjEwLjI2
IDEwOjMxLCBBbnRob255IExpdSB3cm90ZToKPiA+IFVwZGF0ZSBUeC9SeCBzdGF0aXN0aWNzIHRv
IEZXIGZvciBsaW5rIHNwZWVkIHR1bmluZyBpbiBGVy4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTog
QW50aG9ueSBMaXUgPGFudGhvbnkubGl1QG1lZGlhdGVrLmNvbT4KPiBBIGZldyBpc3N1ZXMgaW4g
dGhpcyBzZXJpZXM6Cj4gMS4gUGxlYXNlIGZpeCB0aGUgZW1haWwgc3ViamVjdAo+IDIuIEl0IHNl
ZW1zIHRoYXQgc29tZSBwbGFjZXMgbWF5IG5lZWQgY2hlY2tzIHRvIGV4Y2x1ZGUgbXQ3OTIxLgo+
IDMuIFNvbWUgZHVwbGljYXRpb24gaW4gZGVidWdmcy5jCj4gNC4gbXQ3OTJ4X21jdV9zZXRfcGVy
Zl9pbmQgY291bGQgYmUgc3RhdGljCj4gNS4gQ2hlY2sgaWYgdGhlIHBvaW50ZXIgZGVyZWZzIGlu
IG10NzkyeF9wZXJmX2FjY291bnRfcnggYXJlIHNhZmUuCgpJJ2xsIHJldmlzZSBhY2NvcmRpbmds
eS4gT25lIGlzc3VlIG9jY3VycmVkIGlzIHRoaXMgaXMgYSA1LXBhdGNoZXMKc2VyaWVzLiBCdXQg
SSBmb3VuZCB0aGUgZmlyc3QgcGF0Y2ggaXMgYWxyZWFkeSBpbiBuYmQvd2lyZWxlc3MuCgpTaG91
bGQgSSB1cGxvYWQgNCB2NSBwYXRjaGVzICgyfjUpIG9yIGhvdyB0byBkbyB0aGlzIHByb3Blcmx5
PwoKPiBBc2lkZSBmcm9tIHRoaXMsIEkgYWxzbyBoYXZlIHNvbWUgcXVlc3Rpb25zOgo+IC0gaXMg
dGhpcyBvbiBieSBkZWZhdWx0IG9yIGNhbiBpdCBvbmx5IGJlIGVuYWJsZWQgdmlhIGRlYnVnZnM/
Cj4gLSB3aHkgZG9lcyB0aGUgaG9zdCBoYXZlIHRvIGtlZXAgc3RhdGlzdGljcyBvbiB0eC9yeCwg
d2hlbiB0aGUKPiBmaXJtd2FyZSAKPiBjb3VsZCBkbyB0aGF0IGFuZCBoYW5kbGUgaXQgaW50ZXJu
YWxseT8KCjEuIEl0J3MgbWVhbnQgdG8gYmUgdHVybmVkIG9uIHZpYSBkZWJ1Z2ZzIHNvIGN1c3Rv
bWVycyBjYW4gdHVybgogICB0dXJuIG9uL29mZiBiYXNlZCBvbiB0aGVpciBuZWVkLgoKMi4gVGhl
cmUgYXJlIGEgZmV3IHJlYXNvbnMgZm9yIHRoaXM6CgphLiBUaGlzIGlzIGEgd29ya2luZyBhbmQg
Y29tbW9uIGRlc2lnbiBhbW9uZyBzZXZlcmFsIGNoaXBzJyBGL1cKICAgYW5kIG90aGVyIHBsYXRm
b3JtIGRyaXZlcnMuCmIuIEYvVyBzaXplIGlzIGFwcHJvYWNoaW5nIGl0J3MgbGltaXRzIGluIHNl
dmVyYWwgY2hpcCBicmFuY2hlcy4KICAgVG8ga2VlcCBkZXNpZ24gY29uc2lzdGVudCwgd2UgY2hv
c2UgdG8gbm90IGFkZCBtb3JlIGNvbXBsZXhpdHkKICAgdG8gdGhlIG1haW50ZW5hbmNlIG9mIEYv
Vy4KCmJyLCBhbnRob255Cgo+IFRoYW5rcywKPiAKPiAtIEZlbGl4Cgo=
