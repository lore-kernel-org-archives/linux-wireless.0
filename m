Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D302417D99;
	Thu, 13 Aug 2026 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633883; cv=fail; b=M1E2Dnz6ZcIT+uJnRlWk+/ex80/QeaE2o1EkT+AyAi51VC5FFltEmpVHrEqwBY3RAeWkM0gk55wuHUXtEdrJA3A5B/Rz30tGN8rvj/t+8SmBV/DDKMIpHZFljjZX/6jekky2D7VNPlsdejLho2+vELbZzsgaqeMRS9/KiHnLy8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633883; c=relaxed/simple;
	bh=d8Me8Gcf5Jf9IkHBt4qLAmvSmBYwa5Wa1726aCn+MBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dva36JN+hnI9Z93ip+K9gz2AwHlxrXvnqtEoLYPsEABjHAoJ3ERPc6eL5xr28ZUMajK+4CnR42mbhyPCSfr/pk2t+ruOSU3PjnmweO5Tq8BeREKpQ2R1WMM2GxgAYImR2L7aLItVneFaaK11t7ra1aHiTNvu0Gr4szzOZqijTGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aIlVrsdG; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=pGNX+jUe; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aIlVrsdG";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="pGNX+jUe"
X-UUID: 392d9ffa972911f18dc8c9802ae25ab1-20260813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=d8Me8Gcf5Jf9IkHBt4qLAmvSmBYwa5Wa1726aCn+MBY=;
	b=aIlVrsdGMh9PMdlogmBpoouzezxPJOvt/KnSB4thV0Cgio+MntwtK9+VDeBMvCIi65Q1p2MmG4KGKtMgqYnfqYI2oFVzrxRNQTccfJMC5bRtBP9p3WQU0Cd2uiPN3TGOl6CVJqIxKxlK6pFb0vs6CfvG9H4TJfiJauZi7a9qZ1o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2bdf5a24-1456-4ce3-a8c4-a8b4c671271a,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:31cff8a7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 392d9ffa972911f18dc8c9802ae25ab1-20260813
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <emery.hsin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 329216483; Thu, 13 Aug 2026 23:11:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 13 Aug 2026 23:11:12 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 13 Aug 2026 23:11:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djX44oSMW+WVTQK0IHG5eIIdrnzjMuSm5iKoddc7BK/lB+eFRSmOQZdRDZHvSid+h1mc/7FtL63AMftUXS0THjrkSsvrxOi73w/J7vNakv3NI9m0RXkAwmg1kyd/8wmpBKgDz6zR4V4T2+IcwXWwxfCL4lnr/owAGjupnhKayAN+mioi9eCGXSmgUkmBrhYL9fcCsEtYTL1gsLbQcvYz6zrnoEYt2fvaqjw5DohoEqQ7Ns5NLuX7MnLOVQBoOGbL6fDAsWdE+SEcgUK8k8nqojXRDzzQy/xu/yZfW/opEQhHxGNfogpX9jY8LcXlsyzHX8IN0c6ubMr3TcSvrFcQ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8Me8Gcf5Jf9IkHBt4qLAmvSmBYwa5Wa1726aCn+MBY=;
 b=uwClEbOfdr2+iaiWF5LQlWTJPiHj3ok6tfCwPj099gQ4YnT0AphXr2lM4ddGn110upIXx6rQUqCf4X5LLs9x6hmy/cNC7hAiahw0jIXeyrHH70jygyE5kWlW9+3GBhsI5XIEvnoAAvwGv4Gz63XVnHCHAGXztPZDvg4K228MDw2oRJvFJ987WYHpc3iHBKYW97g0uTOaAFK5TGHwvd9Lb7dQ6IWFXC1T3AvZATdSHvyDJr+Y+NyFxFkBatHNoaqGEhtbIQ366cA68CAU9fa8HLSwJQu7REftIaHN9/UDTGtxC2j/yd+BJTR26nbEjMLbFsjTYqDF5AJbFHh2vo9tEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8Me8Gcf5Jf9IkHBt4qLAmvSmBYwa5Wa1726aCn+MBY=;
 b=pGNX+jUeHK+xd6oKTiudlLkL1RdcZsx+lQsd976lhu95xADDOW8e41IdeMKx+omd6ERPuxR+G5bpR+zMhWIzaQZgq12fdYaBSPyy57NSJp+BG+n+32kMfTPe7b33oxaftx0zqYmO7l3tX/lNl6DcIUWWYRa4LWP25foKf1m1eQQ=
Received: from KUYPR03MB9952.apcprd03.prod.outlook.com (2603:1096:d10:92::16)
 by SI4PR03MB10102.apcprd03.prod.outlook.com (2603:1096:4:2b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Thu, 13 Aug
 2026 15:11:09 +0000
Received: from KUYPR03MB9952.apcprd03.prod.outlook.com
 ([fe80::421a:44ad:de71:4bfd]) by KUYPR03MB9952.apcprd03.prod.outlook.com
 ([fe80::421a:44ad:de71:4bfd%4]) with mapi id 15.21.0292.022; Thu, 13 Aug 2026
 15:11:09 +0000
From: =?utf-8?B?RW1lcnkgSHNpbiAo6L6b5om/5a6jKQ==?= <Emery.Hsin@mediatek.com>
To: Bert Karwatzki <spasswolf@web.de>
CC: Felix Fietkau <nbd@nbd.name>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-next@vger.kernel.org"
	<linux-next@vger.kernel.org>, =?utf-8?B?SkIgVHNhaSAo6JSh5b+X5b2sKQ==?=
	<Jb.Tsai@mediatek.com>, =?utf-8?B?RGVyZW4gV3UgKOatpuW+t+S7gSk=?=
	<Deren.Wu@mediatek.com>, =?utf-8?B?TGVvbiBZZW4gKOmhj+iJr+WEkik=?=
	<Leon.Yen@mediatek.com>, =?utf-8?B?UXVhbiBaaG91ICjlkajlhagp?=
	<Quan.Zhou@mediatek.com>, Ryder Lee <Ryder.Lee@mediatek.com>, Sean Wang
	<Sean.Wang@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?TGl0aWVuIENoYW5nICjlvLXnq4vlhbgp?= <Litien.Chang@mediatek.com>,
	"lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: RE: [PATCH] wifi: mt76: mt7925: remove wm2_complete_mask from
 mt7925_irq_map
Thread-Topic: [PATCH] wifi: mt76: mt7925: remove wm2_complete_mask from
 mt7925_irq_map
Thread-Index: AQHdKzRAZqVrgMT3UUCmYyoES4mcEbacEuDw
Date: Thu, 13 Aug 2026 15:11:09 +0000
Message-ID: <KUYPR03MB99528E99554A9EE51239B575FFDB2@KUYPR03MB9952.apcprd03.prod.outlook.com>
References: <20260612075042.2577193-3-jb.tsai@mediatek.com>
  <20260813145741.8047-1-spasswolf@web.de>
In-Reply-To: <20260813145741.8047-1-spasswolf@web.de>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-dg-rorf: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KUYPR03MB9952:EE_|SI4PR03MB10102:EE_
x-ms-office365-filtering-correlation-id: b0c43337-8994-42aa-3832-08def94d1b3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|22082099003|11063799006|56012099006|3023799007|4143699003|38070700021|10067099003;
x-microsoft-antispam-message-info: WVRiXfXCU9PkHYPJ+fW30zYFOdzm44FoqDS75imqKuXueEbo9rtZ3kbDAxeU2UYrg5MLh297SQXB8Hv8DUPXtCrIuTWiha5ZTvUtLeKhIgVA8ZLaWkmT4jJrTYbIMJuhYxYfXKaP14mncxVyKGU516z53EjrKoyF6CBzXuSuPaWAyhOlTU6nnKcpz/cue0N6/617NI6qEecjcPl5wNcjpJcdG5SrhUL5luwOsHwAojvorRs5fqOWHVTsYZCb58MnRYPtup+NBEy3E/wQXncdbdBD8AvO1pfcntBSVPYGQCikng9yqkIEhVKGq+DPAWLiGSe74XDtk4Quzo2+bW8h2LQIM2gM7hl3zT0esW4ACmcDOhg9MZMFMP9ETnzUWkqqPDaScKKr+j+B3DNukrMTBNVTydTag5RvxTnpaWTYkhaIYNt1CHZijzfrwcAFZEmSAop53BT3MeF+eAWW/8pGlYC+OoIlyZHDfoRLI0UI4xwljC3/Frnac29uqDScVQRuJWdNkE01tGz+3t7PTgcV+VlWlfq9w3mZosOqngQij8Ed/6/Dvsu1adYSQvc/JF2CAXvkVTRqII3wIXswyxe7XsCG4OL2+QayMAkaG5d4jEsij5pdOd3honnZnNszKeVUkTu/EzNhGgQhQ5EUp4LMEYwNWxl57nQJj9nViOX+MIOyc42YeN5deEsE9OeULMFV9+ylYPPUxS8AuCad9woZvXgw2XK6MRqXl6ty4lBZ1nE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KUYPR03MB9952.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(4143699003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NE43ckZXQ1ppZUlQcDkzdnZ3N2sxRUhsUmZVVUdKcjB4NnZaeG44akJNMzMv?=
 =?utf-8?B?WnZnQ2lsMHdFMmZqWE8vVm1KVmpDbFU0UjZuSXNXTmxXRFhOWG1QNFNib09W?=
 =?utf-8?B?K001K085SzI4V1cvY1JTOXdyWmVZWENGNlFnclJCM09UOUQ5YndkVGtEc1lJ?=
 =?utf-8?B?V0VEQ0diS05USUxCNytJRFlocjEzUVFMRkZPV09zb1pUc0tMUTIwRFRYQkNy?=
 =?utf-8?B?UW84enRVTDF3WG85K09KZllSQlZSek1hUzJrRWNXR1dPZ2w4OWJtR3pKKzFY?=
 =?utf-8?B?UTFEa0cvcUwvaEhKTFhvWDR4ZDkvQVo3aVI4NUlGUm5EajU2QU5hbFRLQi9B?=
 =?utf-8?B?dWVwdXZ0RFprM1R3bkRmdFNPMUJVWmVUeDhvb1ZiSm5kcTVTL1FkUU1mWGg4?=
 =?utf-8?B?UmtNUHNDSGZrdktrRmRXTDk3R0FIZnpsRXpBMHBEUFViMWp2ak0zcVMwS0Vv?=
 =?utf-8?B?M3ZxdFJwY3lGL1RRZkFnR2duY3FId2xxN0MrWkcxelliNVJqcWZaRUx5VjN5?=
 =?utf-8?B?bytwN2hTVmprNktQRXdZTVU3ay9BMGtCNlRIL2xnSGpNaU1Ld2FoY0RBTUxX?=
 =?utf-8?B?THBUQUpoS3RqTGlKNFJ5cHlVaTBnOE5GMkhjQzBxTnpMYUR0SW13MHI2S09x?=
 =?utf-8?B?R01ITjZvVmNUeFlxajMxcEpCUTVFVElZdkhNRzZTWG15dnpBc0JxRVA0K3FV?=
 =?utf-8?B?cHJ6NWQ4Z05TR2M3RVBDRWIvUzhMM293aUhrcE9qcE5ON0hIemYrQ1VIMld4?=
 =?utf-8?B?bE5PMDZmRkJrRDFIWloxVFI5VzhFRngyRGhZZ3BwRmhMU1JINm9BUys0eHd4?=
 =?utf-8?B?ejdmSVBKRTV5S0MwMmJUUENTc2k4ank2V0dlWERQbXc3b0owYjI1ZHkvVnNa?=
 =?utf-8?B?b25iZHhzSFJRODExQ1QzTERnWmdtMERqbHVsd3BuZ0MvdWR2UGxIdHArY3Zi?=
 =?utf-8?B?OWxTK2U2Z1RqemhrTENLUVFGVksvME96bVBMT2VicUpvdktnOE40R1I5NEt1?=
 =?utf-8?B?M0s1ZHJUWFowTmRGV2ZmaVB0U000djFHYkkxZ0oyajBlcWFhTFF5dFBuNXB6?=
 =?utf-8?B?N1pyaTNsUnVGUkc1UWJTREcxSy95eUF1ZnNaRmxpVHdnZWZQeWtjSUpScDBo?=
 =?utf-8?B?cmd0RkdIV1VqeFhTR2tzNU1teUo0WFUyWkRLQTVDMjZSVUxlN200VkszY2JW?=
 =?utf-8?B?cW8wY3NHRzh4eTEyTlI5NWYzNW92bGJKRG5pbTN5NlRyZEhyWGNFU1o0N29k?=
 =?utf-8?B?eXF1aGRrNjVEUG1pTDg5ZjVxYy9pdUNISlZ0OXRzT0JrTEY3NExDdmwwN1Ex?=
 =?utf-8?B?QUlWRU1jQmw4dUxnUnhaV1NDdDEwTWxxbEhkdTR2VzhqQmpFTjRUdWw5cldv?=
 =?utf-8?B?Rjl6dzNwc3hjSTF0Q053ZC9nNi9FK0gxN25FMGhaK3dDN2xDK2x1T1p2cmlF?=
 =?utf-8?B?V015L0hZc0FhR1VxNXYxejUrU0J6elRSVGFlUFR1Z3crSDdSTFk3Kzk4ZHYr?=
 =?utf-8?B?R2FVcDFabWxVZXVOVnFER1ZPdlJSeE5GdTBRMHNVeWsyc09vRWs4Zi9xZWpu?=
 =?utf-8?B?NDg5MGRTaVp3WlE1SVNsK29zZ1ZHazl2dWhKZXQ3SHFDOXc4V3BrY2Y3WXVk?=
 =?utf-8?B?L2FETHJhcGtTamFCVndZRXNmWTYycTZoc0NRak50Nk9sT1B4cEVsTlJnQk94?=
 =?utf-8?B?a25OdzUyTHpzUjdhTitISXVhdUptS1h3NE9uZ1dmZTgxWG1CejJxQTRtd2pD?=
 =?utf-8?B?bHBKODVWSjl5dHpIWStEWHVCeWFSUGlSZXJNSFJ6dlBaRnpTZnRLbFFVTzRz?=
 =?utf-8?B?VlRJMHF4K2hSSXQzTDZMVG9acjlOYmhsOGYvOGNKNHAya2tLcGRpYnoxdy9M?=
 =?utf-8?B?Z1RzYmlXMk1kNVVGZ1RTeFpxQ2syWDJjYlFQMHo4dndNcjRHdUMvbmpLc29C?=
 =?utf-8?B?SHpjZnFFOWRPRk01ZTNJZGR3UXF1UXIvcm9BVHNlTXh0Z25SYUkyYWZheit4?=
 =?utf-8?B?TFR6SW40cDNBRi9Bemdua1ZDbG11STNRRlNIZHFSam9EQzdrMzNpVG1NMGE4?=
 =?utf-8?B?QXdWaTZHT1ZHbWVuamRzNTVvSmtZZnJwOSsxM052bUdYUzRjS0R4Yzd6VjJM?=
 =?utf-8?B?Uzd1azg4NWlQZ0xjQWFFMnpXdjN5VjVUWlR5UmhaNXhZd2lBN281bzZ5YWc1?=
 =?utf-8?B?RlptdDV6M1ZITTRTRFMvY1diL0xlSnJPQzlHaURsU2R4Ujlickd0SWdyZUI3?=
 =?utf-8?B?WFVnT3BUNHBkTnNBdk9NVFJFVWNtTW5USEtybDQvb1ltYWlzZys4dDg3NVVL?=
 =?utf-8?B?b3kyWWozV2x1azBHbTF4eWdrVDkxbzFRL0g4ejJXV2tmcG8rNHdVdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZJY9nEUgyNaov1Z9nQ93omyOIW6YUCFa11Iqc0gT6Hfcg22pm4Pdts5vjEn0qc1qVHMRzNOV82z160P8ezNwIGQMsq20/qqLKD8Jh99oPJiTvhPgKTJj/YBeYzImJBpkBIONuAMGSFRVX5yIbKFmpTJOcav0VKhLZ5OWGx2EqoQFKJGSSqhXu1WlimCFk/Mngw/qAmtaYJi4/02gb35xc38Ms3gq5oK/f6rvtvuotWwQyYf8wR7c/LqLIP6MqQWg0/0f0BqRSojvf7zwzVoFzD7MWMkhpzFPWSfRSrQKyBtHFd1waCDfp2BFUHkNWA1O7IVF/7z7bat5FgZbMFkxgA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KUYPR03MB9952.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c43337-8994-42aa-3832-08def94d1b3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 15:11:09.7971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6MxdSEWuvo1z/CuzHMI38hHEiJoEmNwogkn1Ms4mJJwx6n2CJciiqLUNs/epDTa/RZShUcso+oe39AlBNyq5eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI4PR03MB10102
X-MTK: N

SGkgQmVydCwNCg0KVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLiBBY3R1YWxseSwgd2UgZW5jb3Vu
dGVyZWQgdGhlIHNhbWUgaXNzdWUgZHVyaW5nIG91ciBpbnRlcm5hbCB0ZXN0aW5nIGFuZCBoYXZl
IGFscmVhZHkgc3VibWl0dGVkIGEgZml4LiBUaGUgc29sdXRpb24gaXMgYmFzaWNhbGx5IHRoZSBz
YW1lLg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNz
L3BhdGNoLzIwMjYwODA1MDkyNDA5LjE0ODk0MDEtMS1lYXNvbi5sYWlAbWVkaWF0ZWsuY29tLw0K
DQpTb3JyeSBmb3IgYW55IGJvdGhlciB3aXRoIHRoaXMgaXNzdWUuDQoNCkJScywNCkVtZXJ5DQoN
Ci0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBCZXJ0IEthcndhdHpraSA8c3Bhc3N3
b2xmQHdlYi5kZT4gDQpTZW50OiBUaHVyc2RheSwgQXVndXN0IDEzLCAyMDI2IDEwOjU4IFBNDQpU
bzogRW1lcnkgSHNpbiAo6L6b5om/5a6jKSA8RW1lcnkuSHNpbkBtZWRpYXRlay5jb20+DQpDYzog
QmVydCBLYXJ3YXR6a2kgPHNwYXNzd29sZkB3ZWIuZGU+OyBGZWxpeCBGaWV0a2F1IDxuYmRAbmJk
Lm5hbWU+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LW5leHRAdmdlci5rZXJuZWwub3JnOyBKQiBUc2FpICjolKHlv5fl
vawpIDxKYi5Uc2FpQG1lZGlhdGVrLmNvbT47IERlcmVuIFd1ICjmrablvrfku4EpIDxEZXJlbi5X
dUBtZWRpYXRlay5jb20+OyBMZW9uIFllbiAo6aGP6Imv5YSSKSA8TGVvbi5ZZW5AbWVkaWF0ZWsu
Y29tPjsgUXVhbiBaaG91ICjlkajlhagpIDxRdWFuLlpob3VAbWVkaWF0ZWsuY29tPjsgUnlkZXIg
TGVlIDxSeWRlci5MZWVAbWVkaWF0ZWsuY29tPjsgU2VhbiBXYW5nIDxTZWFuLldhbmdAbWVkaWF0
ZWsuY29tPjsgbGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9yZzsgTGl0aWVuIENoYW5n
ICjlvLXnq4vlhbgpIDxMaXRpZW4uQ2hhbmdAbWVkaWF0ZWsuY29tPjsgbG9yZW56b0BrZXJuZWwu
b3JnDQpTdWJqZWN0OiBbUEFUQ0hdIHdpZmk6IG10NzY6IG10NzkyNTogcmVtb3ZlIHdtMl9jb21w
bGV0ZV9tYXNrIGZyb20gbXQ3OTI1X2lycV9tYXANCg0KQ29tbWl0DQpjNGVkZjllM2UwZTUgKCJ3
aWZpOiBtdDc2OiBtdDc5MjU6IHJlcGxhY2Ugc2hhcmVkIHJ4IGlycSBtYXNrcyB3aXRoIHBlci1j
aGlwIGRlZmluaXRpb25zIikgaW50cm9kdWNlcyBhIG5vbi1OVUxMIHdtMl9jb21wbGV0ZV9tYXNr
IGVsZW1lbnQgdG8gbXQ3OTI1X2lycV9tYXAuIFRoaXMgZ2l2ZXMgYSBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UgZXJyb3Igd2hlbiByZXN1bWluZyBmcm9tIGhpYmVybmF0ZToNCg0KWyBUMjAwMV0g
QlVHOiBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLCBhZGRyZXNzOiAwMDAwMDAwMDAw
MDAwYTk4IFsgVDIwMDFdICNQRjogc3VwZXJ2aXNvciB3cml0ZSBhY2Nlc3MgaW4ga2VybmVsIG1v
ZGUgWyBUMjAwMV0gI1BGOiBlcnJvcl9jb2RlKDB4MDAwMikgLSBub3QtcHJlc2VudCBwYWdlIFsg
VDIwMDFdIFBHRCAwIFA0RCAwIFsgVDIwMDFdIE9vcHM6IE9vcHM6IDAwMDIgWyMxXSBTTVAgTk9Q
VEkNClsgVDIwMDFdIENQVTogNSBVSUQ6IDAgUElEOiAyMDAxIENvbW06IGt3b3JrZXIvdTEyODo0
IFRhaW50ZWQ6IEcgICAgICAgIFcgICAgICAgICAgIDcuMi4wLXJjNC1iaXNlY3QtMDA4NzYtZ2M0
ZWRmOWUzZTBlNS1kaXJ0eSAjNzQ2IFBSRUVNUFRfUlQNClsgVDIwMDFdIFRhaW50ZWQ6IFtXXT1X
QVJODQpbIFQyMDAxXSBIYXJkd2FyZSBuYW1lOiBBU1VTIFN5c3RlbSBQcm9kdWN0IE5hbWUvUk9H
IFNUUklYIEI4NTAtRiBHQU1JTkcgV0lGSSwgQklPUyAxNjI3IDAyLzA1LzIwMjYgWyBUMjAwMV0g
V29ya3F1ZXVlOiBtdDc2IG10NzkyNV9tYWNfcmVzZXRfd29yayBbbXQ3OTI1X2NvbW1vbl0gWyBU
MjAwMV0gUklQOiAwMDEwOm11dGV4X2xvY2srMHhlLzB4MzAgWyBUMjAwMV0gQ29kZTogNzUgMDcg
MzEgYzAgYzMgY2MgY2MgY2MgY2MgYmUgMDEgMDAgMDAgMDAgZTkgNzkgZmUgZmYgZmYgNjYgMGYg
MWYgODQgMDAgMDAgMDAgMDAgMDAgZjMgMGYgMWUgZmEgNjUgNDggOGIgMTUgOTQgMTMgODMgMDAg
MzEgYzAgPGYwPiA0OCAwZiBiMSA1NyAxOCA3NSAwNSBjMyBjYyBjYyBjYyBjYyBiZSAwMiAwMCAw
MCAwMCBlOSA0YiBmZSBmZiBbIFQyMDAxXSBSU1A6IDAwMTg6ZmZmZmE1M2RjMjUwZmRjOCBFRkxB
R1M6IDAwMDEwMjQ2IFsgVDIwMDFdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY5NTFl
OGQwZTM0MjAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwIFsgVDIwMDFdIFJEWDogZmZmZjk1MWY2NGYx
NDVjMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDIgUkRJOiAwMDAwMDAwMDAwMDAwYTgwIFsgVDIwMDFd
IFJCUDogMDAwMDAwMDAwMDAwMDAwMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDQgUjA5OiAwMDAwMDAw
MDAwMDAwMDAxIFsgVDIwMDFdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAw
MDAwMDQgUjEyOiBmZmZmOTUxZThkMGUzMDIwIFsgVDIwMDFdIFIxMzogZmZmZjk1MWU4ZDBlMjY4
MCBSMTQ6IGZmZmY5NTFlOGQwZTBhYTAgUjE1OiAwMDAwMDAwMDAwMDAwMDAwIFsgVDIwMDFdIEZT
OiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmOTUyY2NjOGIzMDAwKDAwMDApIGtubEdT
OjAwMDAwMDAwMDAwMDAwMDAgWyBUMjAwMV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMyBbIFQyMDAxXSBDUjI6IDAwMDAwMDAwMDAwMDBhOTggQ1IzOiAw
MDAwMDAwNTA2NDFlMDAwIENSNDogMDAwMDAwMDAwMGY1MGVmMCBbIFQyMDAxXSBQS1JVOiA1NTU1
NTU1NCBbIFQyMDAxXSBDYWxsIFRyYWNlOg0KWyBUMjAwMV0gIDxUQVNLPg0KWyBUMjAwMV0gID8g
bmFwaV9kaXNhYmxlKzB4MTgvMHg0MA0KWyBUMjAwMV0gID8gbXQ3OTI1ZV9tYWNfcmVzZXQrMHgy
ZjgvMHgzOTAgW210NzkyNWVdIFsgVDIwMDFdICA/IG10NzkyNV9tYWNfcmVzZXRfd29yaysweDk4
LzB4MWMwIFttdDc5MjVfY29tbW9uXSBbIFQyMDAxXSAgPyBkcm1fc2NoZWRfcnVuX2pvYl93b3Jr
KzB4MWMvMHgyZDAgW2dwdV9zY2hlZF0gWyBUMjAwMV0gID8gcHdxX2RlY19ucl9pbl9mbGlnaHQr
MHgyOWEvMHgzYTAgWyBUMjAwMV0gID8gcHJvY2Vzc19vbmVfd29yaysweDE5OS8weDJhMCBbIFQy
MDAxXSAgPyB3b3JrZXJfdGhyZWFkKzB4MWEwLzB4MmYwIFsgVDIwMDFdICA/IHJlc2N1ZXJfdGhy
ZWFkKzB4NTUwLzB4NTUwIFsgVDIwMDFdICA/IGt0aHJlYWQrMHhkMS8weDExMCBbIFQyMDAxXSAg
PyBrdGhyZWFkX2FmZmluZV9ub2RlKzB4MTAwLzB4MTAwIFsgVDIwMDFdICA/IHJldF9mcm9tX2Zv
cmsrMHgxZjkvMHgyYjAgWyBUMjAwMV0gID8ga3RocmVhZF9hZmZpbmVfbm9kZSsweDEwMC8weDEw
MCBbIFQyMDAxXSAgPyBrdGhyZWFkX2FmZmluZV9ub2RlKzB4MTAwLzB4MTAwIFsgVDIwMDFdICA/
IHJldF9mcm9tX2ZvcmtfYXNtKzB4MTEvMHgyMCBbIFQyMDAxXSAgPC9UQVNLPg0KDQpSZW1vdmUg
d20yX2NvbXBsZXRlX21hc2sgZnJvbSBtdDc5MjVfaXJxX21hcCB0byBmaXggdGhlIGlzc3VlLg0K
DQpGaXhlczogYzRlZGY5ZTNlMGU1ICgid2lmaTogbXQ3NjogbXQ3OTI1OiByZXBsYWNlIHNoYXJl
ZCByeCBpcnEgbWFza3Mgd2l0aCBwZXItY2hpcCBkZWZpbml0aW9ucyIpDQpTaWduZWQtb2ZmLWJ5
OiBCZXJ0IEthcndhdHpraSA8c3Bhc3N3b2xmQHdlYi5kZT4NCi0tLQ0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL21lZGlhdGVrL210NzYvbXQ3OTI1L3BjaS5jIHwgMSAtDQogMSBmaWxlIGNoYW5nZWQs
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlh
dGVrL210NzYvbXQ3OTI1L3BjaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3
Ni9tdDc5MjUvcGNpLmMNCmluZGV4IDAyZWYwOWRkNzk3ZC4uZDJjMGE3OGFlOWYyIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MjUvcGNpLmMNCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3OTI1L3BjaS5jDQpAQCAt
NDkzLDcgKzQ5Myw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXQ3OTJ4X2lycV9tYXAgbXQ3OTI1
X2lycV9tYXAgPSB7DQogCQkuYWxsX2NvbXBsZXRlX21hc2sgPSBNVDc5MjVfSU5UX1JYX0RPTkVf
QUxMLA0KIAkJLmRhdGFfY29tcGxldGVfbWFzayA9IE1UNzkyNV9JTlRfUlhfRE9ORV9EQVRBLA0K
IAkJLndtX2NvbXBsZXRlX21hc2sgPSBNVDc5MjVfSU5UX1JYX0RPTkVfV00sDQotCQkud20yX2Nv
bXBsZXRlX21hc2sgPSBNVF9JTlRfUlhfRE9ORV9XTTIsDQogCX0sDQogfTsNCiANCi0tDQoyLjU1
LjANCg0KSSBub3RpY2VkIHRoYXQgbXkgZGViaWFuIHNpZCBzeXN0ZW0gcnVubmluZyBsaW51eCBu
ZXh0LTIwMjYwODEyIHdvdWxkIHJlc3VtZSBmcm9tIGhpYmVybmF0aW9uIGVpdGhlciBkaXNwbGF5
aW5nIGEgZnJvemVuIEdVSSBvciBzaG93IHRoZSBtZW50aW9uZWQgYmFja3RyYWNlIGluIGRtZXNn
IGFuZCBmcmVlemluZyBzZWNvbmRzIGFmdGVyIHRoYXQuIEkgYmlzZWN0ZWQgdGhlIGlzc3VlIHRv
IGNvbW1pdA0KYzRlZGY5ZTNlMGU1ICgid2lmaTogbXQ3NjogbXQ3OTI1OiByZXBsYWNlIHNoYXJl
ZCByeCBpcnEgbWFza3Mgd2l0aCBwZXItY2hpcCBkZWZpbml0aW9ucyIpIHdoaWNoIGludHJvZHVj
ZXMgYSBub24tTlVMTCB3bTJfY29tcGxldGVfbWFzayB0byBtdDc5MjVfaXJxX21hcC4NClJlbW92
aW5nIHdtMl9jb21wbGV0ZV9tYXNrIGZyb20gbXQ3OTI1X2lycV9tYXAgZml4ZXMgdGhlIGlzc3Vl
IGluIG5leHQtMjAyNjA4MTIuDQoNCkJlcnQgS2Fyd2F0emtpDQo=
