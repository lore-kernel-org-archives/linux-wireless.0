Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C38C38B15B
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 05:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993911; cv=fail; b=QEDythkweupxOp7ncFheBK9dadEiB+8kiEqtKBrptzLTZDoGUXmXz3sKxPR8m6l8scCB+fW2z1MhJpw6+sRc7Ji6OJnQAgdUcgCoIABQkyzDbc1qVTv+RcZ0rL0ErgUqCarU+b7mm1cGg8Y5ssZIq9NopGzwamFQl3RYQxrVTnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993911; c=relaxed/simple;
	bh=du9ItVDQdRugEdB3d+HzkteWTG2MNbeUsxoj2cEJ6Bg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h4IqBOX+C7LlEFuYBX7ZYABsfZHdsLvrDOtUYEtnSfVSoX08d9oB8RXLI4M40G3pZw2ywyGmADlkNPqfPweKf8sduRchSMfzTf51n9OSR4juu9tXUmTL4TkpbP/Uobe8pPl1nNv8ZTs6HsshuLOiHkTdQvKdEwvTcu2yg4E+om4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ML6mbWSh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ty444SUG; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ML6mbWSh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ty444SUG"
X-UUID: 2c410278915711f18dc8c9802ae25ab1-20260806
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=du9ItVDQdRugEdB3d+HzkteWTG2MNbeUsxoj2cEJ6Bg=;
	b=ML6mbWSht1PujuUVOMW/4wIIpLvwzgiBEWxIYYDbrwWV3jV8Zmhlyy9m+laP478CLiFuV1EAag4boRv4e78Hh2RWb7tV+vBPE29+573Xg/PlYvSxpGwGRMFl5hwNi/Npym2B1VTWq8SGRzVs6A60O+/8VrS5IWULjqkgwUvkUwM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6d6b7321-944d-4043-bab1-510e7098ce34,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:dbaf94f1-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2c410278915711f18dc8c9802ae25ab1-20260806
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1407547049; Thu, 06 Aug 2026 13:25:01 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 6 Aug 2026 13:25:00 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 6 Aug 2026 13:24:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDHc0bqltRGYebyp95AurFg78VP8WuGQMrCKWr/BcBw6tbcvXjgjdJ8+a0VPgsmnlDkGkMS/wd6GIkPEmw5jjO6JVD7ipxlfsdaLtbKbu14kjgD0L9HJNgDXTp49U7sN2S0mS1Y0NgJ5QwLJ9YXsMPYw5TTDP7ilqp++lL/wtA5P85uJgannDxmkMArkaILL4aWlb3tFg+2iswqmKidJg8ow6KEFedZU09nzDrD6V9l78mTrQDZ1NKXu4mxOP+89up71fNbIySY4MwGvmlmrWHweX8+zk1ooTF0mRHtN/SgaCaZrvF17y3mHmqDbC/4aq5LEhPmkoTBTYKICH2Q+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=du9ItVDQdRugEdB3d+HzkteWTG2MNbeUsxoj2cEJ6Bg=;
 b=lyl0XcrrweKJoLZfwcAzHoSxk8SvaNtHJvQJReD3FTQ2c9J4fAyk2ikBrmAI9rGGncxEQ/4PGzrHXunT/2jsSgVMuoeJszROjK/gFpnmrvuLzIxWiHWfHYaOmlT5RyzWFZ71TLF3ZirM7ZH7xsmRaPcJK7AFrFEOl2PE/ZLyfSU6Rxd6/KlETPfJsPE70Hs94DsesGbLwr0lF6OtgNsPgePSe3fBy7k/O+IY9xm5ZMuyDkIunYikpm2H/nAtFXmE90GCE9HnoV/Z2vLiRaVIbko8kSCjaTiLr/7yUMngejWE7TsrkhNNzeouFoMzaliVvvXZd4u/NC6txrEdJVj/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=du9ItVDQdRugEdB3d+HzkteWTG2MNbeUsxoj2cEJ6Bg=;
 b=ty444SUGhuOJtvbLjuj41HdSKNpTUR7absJ8IMYz+OdWAIAwEzdBhti9I+vw1FEGmKz4LotyvDzcMLj0c4F1mvLiOFUw9bUzr4qNWrucCWmD8Z8HvwXzJR2v1xlK/c1GddQCcJlG+egi9Af7AkKyKBKlX9grctue92h+FKT5gWQ=
Received: from TYZPR03MB7082.apcprd03.prod.outlook.com (2603:1096:400:33c::5)
 by TYZPR03MB9717.apcprd03.prod.outlook.com (2603:1096:405:39c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 05:24:45 +0000
Received: from TYZPR03MB7082.apcprd03.prod.outlook.com
 ([fe80::64c7:4756:f39a:a4e3]) by TYZPR03MB7082.apcprd03.prod.outlook.com
 ([fe80::64c7:4756:f39a:a4e3%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 05:24:45 +0000
From: =?utf-8?B?RWFzb24gTGFpICjos7TmmJPogZYp?= <Eason.Lai@mediatek.com>
To: "lucid_duck@justthetip.ca" <lucid_duck@justthetip.ca>
CC: =?utf-8?B?TGl0aWVuIENoYW5nICjlvLXnq4vlhbgp?= <Litien.Chang@mediatek.com>,
	"nbd@nbd.name" <nbd@nbd.name>, "lorenzo@kernel.org" <lorenzo@kernel.org>,
	=?utf-8?B?UXVhbiBaaG91ICjlkajlhagp?= <Quan.Zhou@mediatek.com>,
	=?utf-8?B?S3VuIFd1ICjlkLPorLnoh7Mp?= <kun.wu@mediatek.com>, Ryder Lee
	<Ryder.Lee@mediatek.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, Sean Wang <Sean.Wang@mediatek.com>,
	=?utf-8?B?TGVvbiBZZW4gKOmhj+iJr+WEkik=?= <Leon.Yen@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?RGVyZW4gV3UgKOatpuW+t+S7gSk=?= <Deren.Wu@mediatek.com>,
	=?utf-8?B?SkIgVHNhaSAo6JSh5b+X5b2sKQ==?= <Jb.Tsai@mediatek.com>
Subject: Re: [PATCH v1] wifi: mt76: mt7925: Fix MCU command timeouts during
 module unload
Thread-Topic: [PATCH v1] wifi: mt76: mt7925: Fix MCU command timeouts during
 module unload
Thread-Index: AQHdJKwVxk3GW98kNEerOxeS/CiDmraPuzUAgADDOIA=
Date: Thu, 6 Aug 2026 05:24:44 +0000
Message-ID: <20fad8c7654d543d7b1ca11e48a6486705ae559d.camel@mediatek.com>
References: <20260805072846.1428148-1-eason.lai@mediatek.com>
	 <20260805174600.28064-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260805174600.28064-1-lucid_duck@justthetip.ca>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB7082:EE_|TYZPR03MB9717:EE_
x-ms-office365-filtering-correlation-id: 3a8922cc-09ac-4d03-1e14-08def37b067e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|5023799004|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: /MxaHJtVdjK3Dwb2e0qdUAzfRZaPDny1BO4J6msL7HeOFshN14DFgLmuqGivGROaMINGkyoKn71BrnS/q/UssDHT4K1+4jwHyOtzN09t6xQXJm95DH/CGMBUE4J+W7otwh8EB5exHBQDyfl5KMxsIPXlUKJHvMpdW9VoPcsV4vqJdKpa1ssF43XL2jf/ACxgxjj8yoR62uKpjcfLOG167fWB8jgOeU7Yg3y+XTgiGMyoIWpTNtfuu6XC4ADHvwDuRkwTThZIQNxpwpCX73DkN6snAJ9WdrTU2icnXNq1PT/O1OLFyEwZERoJUpSCG6fEwksPo06SVpONgwrqlFP/yTfbbhWVMRPfcR6NSPa/5NGlvVqDIt32TNXj12xu2kSC3VnCLvTV35TfG2+gNt9pmnXZaW69bxBM99LEx045HaBJur7x0AAcyM+F4ipQvZIMbNi7YiBgPR1mFl6kvZZn4uKPT2vvSoKWorZddmJ1FLGW4imtveeJ9FfN31U81fzY+wCMpMdLOc4x8PgPKd9jr8bEmLK46KgLiW0DIDiTqesOunL6pyyvh9FbFOAaqNKfiKKebjApJpBHOzKUc0kfuuaRFc4+8VR5BE5wcCd3JG3hN5VXUF6Etgx0BfpyeeUErli++z0gNxRMIukcYiHMgSvBdXAneAc4zXKq4+KFdb6arqCAHe0DS7l+7iFcJWbC7lyM1cR68dzA9RylMY2YrjsJ8OSTFzlwYvnEhHc1tiA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB7082.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkpUTzNORTVpUi9EWXNFaHQxenY5MkRNQWVmRFJ5ZWswZWpUWUtoWWd4VjNQ?=
 =?utf-8?B?dkg1Uy95MmNtZG1EaldLWllvV3NVaS9lVWcxaHBkN0FqSi9DTXMxS3YrdnQx?=
 =?utf-8?B?b29KMzVIZ1FIbjAvNVJQbUVGNjAxNEtJZEtXS0FKU2tXMEt3RURqdTl1aEFC?=
 =?utf-8?B?Q2RrQWI3bnBGcE9xb091eU9PWVZCcWFRTnVrdk5HdHRwV0dsOVBPZW13UTFN?=
 =?utf-8?B?THZ1NVo1akJMWjZMSnVWakFQTG9ycHozYTNENk1NbVUwUFh1MnZXTlA3Mncr?=
 =?utf-8?B?RDJ4ZXNJM0d5VmF5UDJRTUdPZWhEUDJDbU9CWXdIdngrSFJ1L2pIanlmV0Jv?=
 =?utf-8?B?cWVud1pxWUJyU0srbzFDY244ZlVMam1EN0ZSdmFRelJBOGVjY0pqTDRZclRk?=
 =?utf-8?B?eG85SGFHZzFkNjUyYkNrc3pDUHZiaUpxQi81TzBCcXd6UFZkdnluMWI0V0xW?=
 =?utf-8?B?MUNvVUZIRmFPSGtNMzd3K0hBenZaS3kzZlRReG5jcEw3ckpLUTJrcDZkNHJQ?=
 =?utf-8?B?UmN0K2ZtSlp2WXFXN0EwamlteEE5K0pQcnlUS01IZVNTeFpJSTdab1doRWZO?=
 =?utf-8?B?RXlMekhmZFFMSlc1SDU3NjBWaWp2SnRIbmY4K2YvZGhiZXpZdUVjZk9Fa2ha?=
 =?utf-8?B?Wk1GVE1MZzdXWWFremZ4aWNnenplTm84Q3FhVWNZT2VJOWRHWmt6WXVxQTd2?=
 =?utf-8?B?aEJ4cVAxREFnaTBVaUp4aGFXRlhCWU9NZEVtMm1TY0Y1QXJJNTlpNjlqQk90?=
 =?utf-8?B?SS9sQVN6QXd4d2NVSTdrRUVOMFY3WS9DNi92VG5PaWVlTGtmcXZ2Nm1yYlpV?=
 =?utf-8?B?NWh6bzJzQ2pzcEhBVytWenhrTm8xbFVLT2IxOWJBWEJicFRCUERhMzRudDhF?=
 =?utf-8?B?TWdXMlJLeENhSXBKekx4NVNRYVNhZEVLQTFCUStLRURFaDhsK09GQmc2VU5a?=
 =?utf-8?B?T3NiWUVnV0lsbUNFMGNkT2t6YTNuM2lxeXRDWmVtME1hNjV0KzM5dFM2c1JS?=
 =?utf-8?B?S0M3RUVRall0Y3djTHJRWXhTSzc1M3NUeHR5N0dlQVdlNXVaVUxnb3dsUWd0?=
 =?utf-8?B?a3owR010OVh6RlZ1STV6cThHVmJmQm5YelBoZW1zMWxickRySHF1U0JJZ24w?=
 =?utf-8?B?SEc4UnRvcjM4aDAwbm5jaFdhdzFrMjY4bXY1aWlXamlqSk1nU21OUjRuTTU1?=
 =?utf-8?B?ODVkQksxV3RYREtYMkdEQ1AxSE1VWEc4b3cxa0NmMWlJdXljeiswN1pobTh4?=
 =?utf-8?B?djF5eVVFcm5VeXIwVitjc0tsR3V3NTFUNllONHJSWDRoVEhIREV3MmlmMWRO?=
 =?utf-8?B?THFPOW02UWZMcVJmZENuekJpVE9TamNWd20xcUc1TWNmYzFHR3d4d0hCRHRp?=
 =?utf-8?B?QlpCbXo1NlpkZFlYcDdtQ2NHa3JPSm5qeDhHejlWb1VGdDNqMXRoQ3FZc1p1?=
 =?utf-8?B?Y0xwVXJrbWlCNzhqc21BVC9ZbUZPZWJUTlpqeFRsMXhGd1pMbFdob0ZtcU5y?=
 =?utf-8?B?Sks0THhkeGlobkcxdTYxOURsTFAvUU5iRS85MXdzTG4zdk1oYVUxK2xnMjNI?=
 =?utf-8?B?WGNad2VuS1Qyem0rdmhraEdMNjd3ZWowVU5XMnI1SVpUTTJnNG1DMHZCVjFl?=
 =?utf-8?B?VWFYYXdTcG5PUWV2R2NMOTVvSWRPNnBmODJyNUFXVExBSHYybnpaQ0FoYnU5?=
 =?utf-8?B?NnVhems1UmtOb3MwdXlPUEdBRzRja2RyQjFnSkkyVlpmakliRXRSOENIcksr?=
 =?utf-8?B?QStWZzNjSFRZcWR1U1lKMFhXb0xVMzF6ei9HdjZ5VmUvaWNjTnVMMkdZMkE5?=
 =?utf-8?B?Sm1Cd0gwR0pXNW9NTTJ0aXBkMjM1MEtuRWhRZWE2WkZtOTkzclRtWGJSV2hV?=
 =?utf-8?B?dms5Vit4eWs0MlljRlNWKy9LOFl4bnZtZEdoUG9tZThnQUZRb0g4L0dNNG14?=
 =?utf-8?B?NE90ZUJBNXVPWjFLU2RQY2l1L0F2dWhRN2czUVdSTjNwR0c2Ym0rZnhrbU1t?=
 =?utf-8?B?V0RNSHdvemkwNDMvVGQ4U2xkemx0b1A5bDA0bktmQk5XVHVCT294RTM1cTNs?=
 =?utf-8?B?Vm1Dd1NkcE9CdnQ1NmhLSkpUNm9TWUhNRnpONG5EMlEyMk9KNnRHK21UTmZX?=
 =?utf-8?B?UzB3QkZxNm9pK3BXK1hDNkVsYzVRdVBwSkFCSTB0WDBXYUpmK3lDdmJkc0Yr?=
 =?utf-8?B?d0E3NE1KbnhTZm4rMzBNZjB5YVhrQ2l3RWxxcTdsU0hEd1VobEZKUGMrWkRK?=
 =?utf-8?B?dmJCMTIvQzBaY2E5M05oemFHcGRiU1pwM3JONVphZm8wZUpTSDZ1SU9sYkl0?=
 =?utf-8?B?dlNWSUREZ2xqODE0cWRDV0lBbm1rbGhqUkpjazhqZnJDM1hJY29kbytVemRJ?=
 =?utf-8?Q?zLB4Q4oW5OAtCSvs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28472481C9659C4FAD5B9B0855489848@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: YZzCzKYCgxxIfkJ4yNzep0s+LwQp3s0VP8ZSa3so85FQ9yTbf3ObEW3pSkZBKkJBObPkYOCsyHieSMLr21W6hD0zp+iDnuZZP0f4Rzw0aQuA+ZS34IkLd9uOsLja0DQAnwUAP/ptoNhUDUZ5eTt4RIPXSyDTKErCnyVDvqzXxRP+fFJlzQCLUJ6iY3o22qhj2lUcOe70GWHMvvFFtgM1td+biPKuQJ2RXS+T2Rs4XKlLjIGOS9yU9IdTBeoVCQFyTQ75NgFR75WxMjiLwFGNxujtzaGaRvs6xe2fzYbSNqypJI3iexSuzsHKmwRE+BD62ar+LpUoOgkj6voDGl7a+g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB7082.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8922cc-09ac-4d03-1e14-08def37b067e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 05:24:44.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFggo+at2XmGFl/+peG7WlfJJ50GRDp82l7FIMYW1uS3hfR6lB+plcUzfmT54yQOG+GBaLWtnrBVY9wEBwgnng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB9717

T24gV2VkLCAyMDI2LTA4LTA1IGF0IDEwOjQ2IC0wNzAwLCBEZXZpbiBXaXR0bWF5ZXIgd3JvdGU6
DQo+IA0KPiBUZXN0ZWQgdGhpcyBvbiBhbiBNVDc5MjcgaGVyZSwgYWdhaW5zdCBhIHJlcHJvZHVj
dGlvbiBJIGJ1aWx0IG9uDQo+IDIwMjYtMDgtMDIgd2hlbiBJIGhpdCB0aGUgc2FtZSB0ZWFyZG93
bi4gSXQgZml4ZXMgaXQuDQo+IA0KPiBtdDc5MjVlIG9uIDcuMS41LCBtb3Jyb3duci9tdDc2IGF0
IDIxN2VlODNkLCB3aGljaCBjYXJyaWVzIHRoZQ0KPiB1bnJlZ2lzdGVyLWRlYWRsb2NrIGNoYW5n
ZSB5b3VyIEZpeGVzIHRhZyBuYW1lcyAob3BlbndydA0KPiA5OGMxM2ViNTY0ZTUpLg0KPiBFYWNo
IGN5Y2xlIGFzc29jaWF0ZXMgV1BBMiBhdCAyNDEyIE1IeiwgcnVucyBhIDE0MDAtYnl0ZSBJQ01Q
IGZsb29kLA0KPiBhbmQNCj4gcm1tb2RzIHdpdGggdGhhdCB0cmFmZmljIGluIGZsaWdodCwgUlgg
c2FtcGxlZCBvZmYNCj4gc3RhdGlzdGljcy9yeF9wYWNrZXRzDQo+IGltbWVkaWF0ZWx5IGJlZm9y
ZSB0aGUgdW5sb2FkIGF0IDM3NSB0byA4MDcgcHBzIGFjcm9zcyBib3RoIGFybXMuDQo+IEJvdGgN
Cj4gYXJtcyBidWlsdCBpbiB0aGUgc2FtZSBkaXJlY3RvcnksIHNvIG9ubHkgbXQ3OTI1ZSBhbmQg
bXQ3OTJ4X2xpYg0KPiBkaWZmZXINCj4gYmV0d2VlbiB0aGVtLg0KPiANCj4gwqAgY29uZGl0aW9u
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RvY2vCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcGF0Y2hlZA0KPiDCoCBhc3NvY2lhdGVkLCAxMCBjeWNsZXPCoCA1
OS02MCBzLCAxOSB0aW1lb3V0cyBlYWNowqAgMC0xIHMsIG5vbmUNCj4gwqAgaWRsZSwgMyBjeWNs
ZXPCoMKgwqDCoMKgwqDCoMKgIDktMTAgcywgMyB0aW1lb3V0cyBlYWNowqDCoMKgIDAgcywgbm9u
ZQ0KPiANCj4gTm8gd2FybmluZ3Mgb3IgY2FsbCB0cmFjZXMgaW4gYW55IHdpbmRvdyBvbiBlaXRo
ZXIgYXJtLg0KPiANCj4gVGhlIGlkbGUgcm93IGlzIHdvcnRoIGEgbGluZSBpbiB0aGUgY29tbWl0
IG1lc3NhZ2U6IHdpdGggbm90aGluZw0KPiBhc3NvY2lhdGVkIGl0IHN0aWxsIGNvc3RzIDkgdG8g
MTAgc2Vjb25kcywgc28gYSBiYXJlIHJtbW9kIGRvZXMgcmVhY2gNCj4gdGhpcywganVzdCBzbWFs
bCBlbm91Z2ggdGhlcmUgdG8gcmVhZCBhcyBub3JtYWwgdGVhcmRvd24uDQo+IA0KPiBUZXN0ZWQt
Ynk6IERldmluIFdpdHRtYXllciA8bHVjaWRfZHVja0BqdXN0dGhldGlwLmNhPg0KDQpJIHdpbGwg
dXBkYXRlIHRoZSBjb21taXQgbWVzc2FnZSBmb3IgdjIgYmFzZWQgb24geW91ciBzdWdnZXN0aW9u
Lg0KDQpUaGFua3MsDQpFYXNvbg0K
