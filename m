Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F49391E52;
	Tue,  1 Sep 2026 08:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251772; cv=fail; b=WtEU9MXRm3blQiLduNv2NydX9COKypt/0PK6r+Z8WN/oRkJ7zYN0GDVx2x+Em0fnvZcufY2m7MgLXDt3tlQXwav7q70Gg0ErGjfNBOwhVdqpW67jPnrzRVt1u64l2IpU3rGlPlnPYXIzpvcLB8tRAwLnRQLep81QTuPH2kV21DM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251772; c=relaxed/simple;
	bh=WAVIkFZppOiVlruJsgnRMD3x2vA5CL49gK/kmeQD+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tAPldf75qPPHkErhwJB8Fh4rH6ft1gWMfR/RGvdtHWqWCzQ6jbKMMGTy6Kx5UdGTz3JSx3ei6+euZpx4mc+QOyQJQa8gX7TVfoSHqiLwJWcR2RHsxiswGOuZ4m4nN1RbkUhjFgR9uNGyXfO4YLl2duNq35PhLUpn/t4HofXsuIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=ljbqyay4; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=JrdeUxCs; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="ljbqyay4";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="JrdeUxCs"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179US5748245;
	Tue, 1 Sep 2026 03:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps12202023; bh=WAVIkFZppOiVlruJsgnR
	MD3x2vA5CL49gK/kmeQD+C4=; b=ljbqyay4L+nvRTZ0GBED6JyrEY1Tjb1F6eMy
	EOPDf2KlyPbw21TakPZw3nHVRH39dlUBlhDmLmzJZDjdyEGrx7ZiXRHjXJ90mRl7
	coeZDM5ZThmLvWxCYr4zeibmuNNVB58v6AEmdsQmsXinVAM5+6fw0gpQkGocvo2Q
	KFgq/IsK+55ZONZj/QQL9d7UznumhLIviDbeqwSCs4BmKZ+kY6wmetl3852u1sYc
	ZDDKffuaRHevHODGA6dfwqbRvbtpDIYdhAkQJqPNZJqglwynTwpmiMFgLmVaHyBo
	XTu5pEabFvCSYSzup0FgKLK3g1JKzbka9Lko/Wk2CmYouh+CcQ==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020086.outbound.protection.outlook.com [52.101.56.86])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gbrx95w70-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 03:36:00 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3It8Se/BpZ7Fwu4Tcfg9lHKj2Jzj+IAeagb1Llvn+R822S7ikACgqYGCkljo6T96IiPke8pdg1wyseWEtFc0GDeos9+gsvQRRb/1jaCCRsvgVUGqNFuNYFMbNgB3jepZsMdmD6WG/Ljmd1xdcPOnRb8MHP6wZd/SrYweS5UELUMsmaFCqJbrwSLPycu57U/IZF4xLHmQmxL+C2v2Xjm9yp8xQJEaYiqx4M9+v7mAhkgxQLqknmvGXW/ipTxQ7i3lXr6UGKnNX1NeegoW7WWOLRUx5xgA+dxQPhKUhr31R0yEusWmWWNstVbpvfwnO+8W/VMwFgqn2M9+LOtAWjXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAVIkFZppOiVlruJsgnRMD3x2vA5CL49gK/kmeQD+C4=;
 b=ClYo1ZBg/LYvmLMw2r/FlNWxsrnhJbFmq/L0ksb7BsV8rNWQbZWZrbBoFpgMOHBmQPYfZGFOK1J+6Id2PciAy5xVoJMlZU+XojeaOd0u5JyPouBrpFdG8pLDiRjFyh2LLrx/bpYzmIYhdpkX9KDPHeTKt4LtHiVyAVdMrKS4aOYsmrB2DohDjnCG5o+07P15g033IEYSsSO+FWx5kvMk9t17mJD7OOpHJj/PxSaLmmh2syg+UYh2ehLLQ92Om3dLL4FQVewaL6HnTWOB9c7B09mpiwsPwJs6I1+L0diIisUDvQI/Izoj2KWsXvOPMqiXplu/JZlkk62Hj2NnmjK9PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAVIkFZppOiVlruJsgnRMD3x2vA5CL49gK/kmeQD+C4=;
 b=JrdeUxCsaq9E459Qf4wLOc8MMLQDxR3Y00imv732w8fNVa8VEC+Nn+3X8ldPnD1NgNs+YZ5q2DTYIA2qQ1AP+mGwUu8UOfLQdRnr4fby29fdV0OzlVru3eslnOUklSl5ZFoctW5nCxRPkrF1cweWy1Aw9msMXj6bHxiDdwsDMnM=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by LVXPR11MB9778.namprd11.prod.outlook.com (2603:10b6:408:386::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 08:35:59 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 08:35:59 +0000
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-devel@silabs.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Lukas Stockmann <lukas.stockmann@siemens.com>,
        Gerard Salvatella <gerard.salvatella@siemens.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Subject: [PATCH wireless-next v2 0/2] wifi: wfx: fix possible device hang during init
Date: Tue,  1 Sep 2026 10:33:18 +0200
Message-ID: <20260901083548.113131-1-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PA7P264CA0175.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:36f::12) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|LVXPR11MB9778:EE_
X-MS-Office365-Filtering-Correlation-Id: c2324a0a-1485-44f5-3ce0-08df08040c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|23010399003|1800799024|38350700014|10067099003|56012099006|6133799003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	QadDvxOPj/UQVeFe/mcrnvoOi6rneBd6r49l5HbJoPPRzCVshXZg23XhJXoTrQF3KWrNgubqomfsqudClIYkYh8+OxkFh/5Ett4HN0wp+yeukN9/2ofU52egVahVecqCNeIS3M7VsBsmrHri7qld214XQF0WBsvjWYmqaZ1HnQG4BRbjJOQg0BgX8iqKIfrlkNOTtqYNFkvIOQdbo4k0M0zvw5TvK4cgw8P0YeB0fffRdoJ21igGdzt5pDsadNJ/JZigKyy8QnXlr5/s4ZL5y9U1/pcSBTsGk5DidrQht6U/zuTChdDUddgwdA+/9zp8t/3z6GINsn6kXOc3jpYLla4KVeviu8KHt9/ptdfzZTgWae9/iuRrX5gtu03KZH0onx+Z6ceHY1avfhv80t1FyYfbYmIOXYgBjeTxpv/82lW5s/pOqQ8qMIuFwWkT5hV5GYmZpFl/7G3Xlq2aofYFUZlmuhyszV21diR06rHIn4N1PLdPhK2xVkcvzJ/Z0P53clEjfKND7c+tj7DkjW3lNsgTco1u/866Rsxr5UK0v2TCtmPmVhvlwp+kTKzOU8TbIFLEaOuwyPz7XWaCmH8NdR43ZRIiw0VJG34xLj9MxUW6Wj/5k6HE34I78QoEoyfZPaKuBz5H5xoqt8mXsfQf4GXsGi6/Ht/Jtw7/Wx9lxQEwQ+Ws68VpkKiuqTxDKZZPUin0JgkPM4wLjzhYnWQHwGMYdBhQW9oSIxnZmDU91K8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(23010399003)(1800799024)(38350700014)(10067099003)(56012099006)(6133799003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUp2WTlHQzFVU3dDeEZtSGpmZXp6Q3J2ekxNUXBJYXd5c1dVRi8yWUVacjB3?=
 =?utf-8?B?QzBkWnFqMTRMRmc0YzZNdnVnb3JDck5qTXpadWZCbTErZjBDQ0cwTVhzZjZB?=
 =?utf-8?B?QkJjcXl1Y3FWWHpjVkZVbXBZKzlyQ3k3bER3cjB4dGxwTms5NGpIcXJiakln?=
 =?utf-8?B?NWxjLzRNNGNabnV4TWQvbjJRSUpON3hZM21vbVBZei9RSGlFRGNSbGMzNGpF?=
 =?utf-8?B?TlRBMFJEaTFYSnZjcWtqMlVtcFY3Wnl5b2lGZlZoVTJrUFVpeGEzQ0U2Q01B?=
 =?utf-8?B?eHluTG9xbldkR3ZzWkdpMzRaNFBIMWxManordnJTQVpoSCtqMmhCeVhyUEdp?=
 =?utf-8?B?MHFtMU1OYVE4WmhaTlMwT3dxN1pIWWJxSThTbERsbzA2UFVtUVJMRUNWa0Np?=
 =?utf-8?B?ZS9wY1lwWHE1aC9iSm11Y0JFdFg0NWlvbGtqUnQ5eEk4VGlNS2prRldWMGhR?=
 =?utf-8?B?Um1IeFJROGF6UmdmYlZlU2ZLaE5MT0w0SnB4VnhSUDA5SU94b1FHM3p0dUNX?=
 =?utf-8?B?MHVQb241b3VXUUcyREpuYkFLOUtPVkRaZlQ5UVJEWVUxNzY4NXRxSnM1ektw?=
 =?utf-8?B?ZHhsWmhUcm5YWHI2QytuWGhaYk5kQmNDN3FCR1hleVdhUjAycFYxZFA5Z2ZX?=
 =?utf-8?B?NWdRQzdwVFJLRmRGa25XV1plRWlxbElkT0xoYzBjZkdWdG1wdzJIbkF0bTF2?=
 =?utf-8?B?UVRyY3RoZjNFMCtQZWdWUWVwVVQyYzl5U1FORHlVMTJNVEFHWW1uOHV0MW1y?=
 =?utf-8?B?eldYUG5NbE9zMnBOSWE3QlVnb1IwTjJ6YTlJR3pvejc1UGhtbGdLOTlaVVYz?=
 =?utf-8?B?akgyd3pWY3loVDVSVHN5N2xMQ0pqSm1QL016V1VLQmlEQ0l1Mkdxd3RMV3Rv?=
 =?utf-8?B?bXFqM2FRS2d4SVBrYkh0QW1KZFJka294UGdnSHlqdHJkeUZtSk42djNZZ3Bm?=
 =?utf-8?B?TDhOR2UvQVlDU2g3YkI1KzBoQUJQMkkwd1RoT3RGUnJUYzBqL3pReGVJWkN2?=
 =?utf-8?B?cFZZVVFKdW0wWFFTR0xRWnY1T2NjeVJvbm1MR2JYYmxyMk1HSlBNU29hUlB2?=
 =?utf-8?B?ZDMvQVcrK1JmWWFUeGJFRDNNZk1jcGh5MzFORmxSMDY5UWVOZWJ2ZVdxTTEr?=
 =?utf-8?B?QzJFV215RHNlUEI2RHZRL3NoQTE1bDIwclBLYnVJbWxxUndtbVhNNHV5ZTVR?=
 =?utf-8?B?OWJSdVhxRjZmZ3FMQVkzSXBFaUJub1Z1cnhMd0pGV2lVWEl0SWYzQ1B6UmNG?=
 =?utf-8?B?dDB2Y3N4OGJSbm9LaE11TnpYWVdPalE3N1psYzA5UisvemRkRXRDSTllU3Bz?=
 =?utf-8?B?dEhZdnNtQ3U3VE84S0hCSlJWZ1ZkZ2dsMXIxQ0FUR0x4Qm5DcDVpOGxPeXFR?=
 =?utf-8?B?ZnEvWjVxQUtXaXhJYndYMzUzWjNQbkdTQkUwNzF2LzMzRUpkM05FdHpHS2ds?=
 =?utf-8?B?SGdmV2tRME9rMS9iVWt0QjJVN2ViTzBuMW1vV3dtRDBTN2pwTnVSVkd0VlBY?=
 =?utf-8?B?M005R29ZRjVZM256MzJKaVdYZEdDbEtQbEpLTEFDVEd3Rkc1RzM4KzVjQWcx?=
 =?utf-8?B?YkxibEZXWE9PT2Y4OWF6YnVHam56RUp4cHVZQm1TVUw0SEVOSnpnbzdWU0cz?=
 =?utf-8?B?RDFHQXhES1BZVU0reUlxeTBOTk5BS3NScWN0cTBQS3dBMEpqNEgxQzdmR1or?=
 =?utf-8?B?L2huQ01hY25oL3NDUjFsa2ZxaWFHNkpudHpGTTdDK0JLOERNR0FTOW42eXJp?=
 =?utf-8?B?RDNjVSszNko0SlpLRjZmZ2JnajlTSE1rQmVkUm5NcmY3K2szSzZCd2hKcmVL?=
 =?utf-8?B?M2VEYkI2Mk83Y3lZenV2NlZiYnR3ZkxPd3U4bVRDZE9NbGRmUTdIc2M5VlN6?=
 =?utf-8?B?aUFsR0RndmxTKzdCeDE3K2htNG8vbWhjYU52ektkclNqTlY2bXFTM3Q3aFhn?=
 =?utf-8?B?VW9nd3lXWUg1bjZQR3FXQ3ZtWFpUWXJ6MHpCOXk1YkFNUm9HU0VWVG1kbnJH?=
 =?utf-8?B?dWlMcHZGNi8wV0lpcjUvSlBvZFc0L1F3KzRGZlVtUE9zZDBoK1VSZ1p5dEJ5?=
 =?utf-8?B?S2M5dWxJVkpQQzdJbE5RMXZqUWZDQ2llTkFBd1JCUmhSeXd3d2dZenlmNnVF?=
 =?utf-8?B?V21Hbnc5ZzZYbzUyZHdzQXlqSHZWd1c4b0RKZ1Q2QklVNWRQaEtFRFZLNkNa?=
 =?utf-8?B?YitsUVpTUzN2UEcvRDBMZ0NZM2lLNzdTOWxPcmtGRUVETW5nY3p5dE9JRXBH?=
 =?utf-8?B?Zkh5MFF0KysvOS9JYlhuckRJS0UwS0RXd29qd3hHVlpadnBYcytja2RHTmRU?=
 =?utf-8?B?Y3hkUWVudVB0ZW9WVkZXYnBVUzgvaUpaQXdFcHZWZEJYNzZzaXptZz09?=
X-Exchange-RoutingPolicyChecked:
	3/uImcasnvhp+IWj9O4x6GjGujiSbmb9rao2NHoFo0Cgit/dnni8elT6QUfKgXWZfXHFkFMC+rw+2CO/27jJohJM1POSd7pyJ196NMrQwNyvbXz2METcKFrLnMhFDsqfommq+6sReUTBD3kV9Cv13i5COWF3qW5m9r1gkEvqzYAMC0zowjS4DpdfK4vcp2d15SwNtCZQk9jlTHh2kinLPupFWb15y9I471XZKYIo/0IkbILH0kNxzgrNW7wCbj+K9r3KLanI4IA8RAqccsZsxyXQNTTmBcmnkKCb+F89uvYF09vjfGrainK8ES6GU+yrcwBI2tqu8UBEyOHdSde1pQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2324a0a-1485-44f5-3ce0-08df08040c3d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 08:35:59.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBSFHBZspKBfmpZlgAy/Wxd89wofCYTdMKQJ29qKOkrRvZQNcaOOq/XFYwGtcpREWAlbhpEvvGtYjal0cp9jpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9778
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3NSBTYWx0ZWRfX8oN6c90Lsiye
 uev6XQ1NojgMlbrPugaSaPvzAqF5NluBscBBeyLJHlYtgocS7sIcxOQeNB4YHzb5sfoiMiSNpz5
 ZoKvWlNwtwvGVMG8KyZbOtiY3fyB2tO4XmsTmISEq0G25CM6gvDJJldSTFuvItN6VacJcP7CwLb
 YUl0cA5rrbC5JDnH4Qo+rKImdoXV+ahpmOM3CdlfqK0LEBIb1IBMchYKMrKBunqC8fHXyDTmXl6
 /iJjkwu31xCFH1tb92H4x/IDuqvqWUerOLaabQjCxHL2KG4LIyJaN3U69EtIKgxnF5VRWD/u77/
 ZKAGd72kw1r8Tw39G0zS7Dk7nANu7n9/daQDgPpctwutaecP0RYRQPMd7GyxdDRjTcoMS5jsVhb
 ldO24fnJW9bE8JRMVJJiH15iOBi2Fn2633vDI7vBkuswzM6cOhobwAnWOvqUxmT62eyN4W/4Ggk
 ebXA1rWKteC/jh6B3Jg==
X-Proofpoint-GUID: gX3Z9Bjd9BcPwUJrAbVrIJ5NMQ6dMQ4q
X-Proofpoint-ORIG-GUID: gX3Z9Bjd9BcPwUJrAbVrIJ5NMQ6dMQ4q
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3NSBTYWx0ZWRfX/Nk/+TlTArmx
 F4t0EE+K28zxIdQLo/Phyv36bsXKv7/YVd4CN0KGimPDBQzaxYjIU4HDeSlvll2Tc4ZHCouIZuM
 UNm0ETTONO2w0zf9FDh/RaYaVVm6F+E=
X-Authority-Analysis: v=2.4 cv=fMwJG5ae c=1 sm=1 tr=0 ts=6a968e70 cx=c_pps
 a=WS7M4Vp6MtIIvztawIUZGg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=IXT2DV1lbWpSFN5LiBYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010075

VGhlIFdGeHh4IGRldmljZXMgcHJvdmlkZSBhbiBTRElPIGludGVyZmFjZS4gQmVzaWRlcyB0aGUg
dXN1YWwgaW4tYmFuZApTRElPIElSUSwgdGhleSBhbHNvIHN1cHBvcnQgYW4gb3V0LW9mLWJhbmQg
KE9PQikgSVJRIGxpbmUgZGVjbGFyZWQgaW4gdGhlCkRldmljZSBUcmVlLgoKVGhlIE9PQiBJUlEg
bGluZSBpcyBub3QgdXNhYmxlIHVudGlsIHRoZSBkZXZpY2UgaGFzIGJlZW4gY29uZmlndXJlZCBi
eQp0aGUgUERTIGZpbGUuIFRoZXJlZm9yZSwgc2luY2UgY29tbWl0IGYwMGRjMWQ3ODllMWMgKCJz
dGFnaW5nOiB3Zng6IHBvbGwKSVJRIGR1cmluZyBpbml0IiksIHRoZSBkcml2ZXIgcG9sbHMgdGhl
IGNvbnRyb2wgcmVnaXN0ZXIgZHVyaW5nIHRoZSBmaXJzdApleGNoYW5nZXMgd2l0aCB0aGUgZGV2
aWNlIGluc3RlYWQgb2YgcmVseWluZyBvbiBhbiBJUlEuIFRvIGtlZXAgdGhlIGNvZGUKc2ltcGxl
ciwgdGhpcyBwb2xsaW5nIHdhcyBhcHBsaWVkIHVuY29uZGl0aW9uYWxseSwgaW5jbHVkaW5nIHdo
ZW4gYW4gSVJRCndhcyByZWFkaWx5IGF2YWlsYWJsZSAoaW4tYmFuZCBTRElPIElSUSBhbmQgU1BJ
KS4KClVuZm9ydHVuYXRlbHksIHRoaXMgcG9sbGluZyBpcyB1bnNhZmUuIENvbW1pdCA1N2FhNTU3
ZjExMGQ5ICgic3RhZ2luZzoKd2Z4OiBpbnRyb2R1Y2UgYSB3YXkgdG8gcG9sbCBJUlEiKSBhbHJl
YWR5IG1lbnRpb25lZCB0aGF0IGFuIElSUSBjb3VsZCBiZQpsb3N0IGlmIGl0IGZpcmVzIHdoaWxl
IHRoZSBob3N0IHJlYWRzIHRoZSBjb250cm9sIHJlZ2lzdGVyLiBBIHJlY2VudAphbmFseXNpcyBz
aG93cyB0aGUgY29uc2VxdWVuY2VzIGFyZSB3b3JzZSB0aGFuIGRvY3VtZW50ZWQ6IHRoZSBkZXZp
Y2UKaXRzZWxmIGdldHMgc3R1Y2sgYW5kIHN0b3BzIGFuc3dlcmluZyBzdWJzZXF1ZW50IGNvbW1h
bmRzLiBPbmx5IHB1bGxpbmcKdGhlIHJlc2V0IHBpbiBhbmQgcmViaW5kaW5nIHRoZSBkZXZpY2Ug
cmVjb3ZlcnMgaXQuCgpTaW5jZSB0aGUgcG9sbGluZyBvbmx5IGhhcHBlbnMgZHVyaW5nIHRoZSB0
d28gZmlyc3QgZXhjaGFuZ2VzLCB0aGUgaXNzdWUKaXMgcmFyZS4gSXQgd2FzIGNhdWdodCBieSB1
c2VyIHdoaWxlIGJpbmRpbmcvcmViaW5kaW5nIHRoZSBkZXZpY2UgaW4gYSBsb29wCmZvciBhIGZl
dyBob3Vycy4KClBhdGNoIDEgcmVzdHJpY3RzIHRoZSBwb2xsaW5nIHRvIHRoZSBjYXNlIHdoZXJl
IGl0IGlzIGFjdHVhbGx5IHJlcXVpcmVkCihTRElPIHdpdGggT09CIElSUSkuIFRoZSBidXMgZHJp
dmVyIG5vdyB0ZWxscyB3ZnhfcHJvYmUoKSB3aGV0aGVyIHBvbGxpbmcKaXMgbmVjZXNzYXJ5OyBp
biBldmVyeSBvdGhlciBjYXNlIHRoZSBJUlEgaXMgc3Vic2NyaWJlZCBiZWZvcmUgdGhlIGZpcnN0
CmV4Y2hhbmdlIGFuZCB0aGUgcmFjeSBwYXRoIGlzIG5ldmVyIHRha2VuLiBUaGlzIG1ha2VzIHRo
ZSB2YXN0IG1ham9yaXR5Cm9mIHRoZSBpbnRlZ3JhdGlvbnMgc2FmZS4KClRoZSBTRElPICsgT09C
IElSUSBjb21iaW5hdGlvbiByZW1haW5zIGFmZmVjdGVkLiBUaGVyZSBpcyBubyB3YXkgdG8gZml4
Cml0IGluIHNvZnR3YXJlOiBwb2xsaW5nIGlzIHRoZSBvbmx5IHdheSB0byBib290c3RyYXAgdGhh
dCBzZXR1cC4gTm90ZSB0aGF0Cm5vYm9keSByZXBvcnRlZCB1c2luZyBpdCBpbiB0aGUgbGFzdCA2
IHllYXJzLgoKUGF0Y2ggMiBkb2N1bWVudHMgdGhpcyBoYXJkd2FyZSBsaW1pdGF0aW9uIGluIHRo
ZSBiaW5kaW5nLCBzbyB0aGF0IG5ldwpkZXNpZ25zIGRvIG5vdCBwaWNrIHRoaXMgY29uZmlndXJh
dGlvbi4KCnYyOgogIC0gU3Vic2NyaWJlIElSUSBiZWZvcmUgd2Z4X2luaXRfZGV2aWNlKCkuIFNv
IGl0IGF2b2lkcyBwb3NzaWJsZSByYWNlCiAgICBiZXR3ZWVuIElSUSBlbmFibGUgYW5kIElSUSBz
dWJzY3JpcHRpb24gKHJlcG9ydGVkIGJ5IHNhc2hpa28tYm90KQoKW0NvcGlsb3QgZ2VuZXJhdGVk
IHRoZSBpbnRyb2R1Y3Rpb24gbGV0dGVyIGFuZCByZXZpZXdlZCB0aGUgY29kZV0KCgpKw6lyw7Rt
ZSBQb3VpbGxlciAoMik6CiAgd2lmaTogd2Z4OiBmaXggcG9zc2libGUgZGV2aWNlIGhhbmcgZHVy
aW5nIGluaXQKICBkdC1iaW5kaW5nczogbmV0OiB3aXJlbGVzczogd2Z4OiBkaXNjb3VyYWdlIE9P
QiBJUlEgd2l0aCBTRElPCgogLi4uL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4Lnlh
bWwgICAgIHwgIDMgKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYmguYyAgICAg
ICAgICB8ICA2ICsrLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzX3NkaW8u
YyAgICB8ICAxICsKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jICAgICAg
ICB8IDM0ICsrKysrKysrKysrKy0tLS0tLS0KIDQgZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9u
cygrKSwgMTUgZGVsZXRpb25zKC0pCgotLSAKMi40Ny4zCgo=
