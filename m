Received: from mx0a-0024c301.pphosted.com (mx0a-0024c301.pphosted.com [148.163.149.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E983367B98;
	Sun,  6 Sep 2026 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.149.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788727748; cv=fail; b=YF0+n+qPV8a1qMqABjMmz3OCnXb3E2McerA4w0ZOI+9/6rpfrTpt/2cZ9d1Dxs4tJHvd/M9yUZWSvMk6mhBp05Llg5A6VU7t/zVweZgB3+QELCVvWA4VfK2L2y/UBQi2HsEe0RqBlrKg/IPqupVZDZm+OYAJXGfJ8zlEJCgJfVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788727748; c=relaxed/simple;
	bh=VCmb1a+esgcqmTOairS9QMt59uvESjiscCs/TnSlg+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tyN2Ok24j45bYvPrfaUk6eENJ60b26teKu1lhwLBSP3Q53gvUFzrZT8DumB6dcS4SrR7vd6Y1GAAtkFJo1/QLXwBpmzFd4ijgTSjabzuBKNIaMiqgPo9Uyhuc/4jlBkYad6BrB+utRuUcWSPvCSQvK84Ga0BpG0iL/EkihiDSOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=YRmQSlyj; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=QirvHpZF; arc=fail smtp.client-ip=148.163.149.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="YRmQSlyj";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="QirvHpZF"
Received: from pps.filterd (m0101743.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KMDw73190266;
	Sun, 6 Sep 2026 15:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=VCmb1a+esgcqmTOairS9QMt59uvESjiscCs/TnSlg+E=; b=YRmQSlyjod71
	oO0G4l1T949D1HQctjq6nHqCMoM0IUxJPGlOSx3r6GEyOXjKXWVvpPAP/yD25Cpi
	s6X18HCtSdPPt+WN2FDAc/q+IkU3WBNQLh0bLIm2FLd+bcUC9WTvhDrjkUvOpHAF
	kw5Oilx7p4TvlEYwosAfjEnD7hFuJgvwh7E6Sy2/eleNsnkXC5Z99JTFkhNhj6VC
	vloblxsrf9guM/NqX9zB5Hy+HhA2JtjwkE0cB1L/ol9jeqpPFXyo8bRDZph1lwTv
	DtpGOB9E6bJgH3CBJXRnbqJYYc+UK08YHLxtmCwzrWuovAfnhQXCHCKy8hnrv+B8
	9F9x6AsToA==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022101.outbound.protection.outlook.com [40.107.200.101])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggfd8hksn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 15:48:52 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ly0BqTP2KMfZQIbFqXYe5oPI87H4Ho/KAYbAgb8Q/danvsLqgl+miCovJPbEn/Lu+UJI3Ez62JpIJcIe1IyqU9fIqkytffbFqjS1DHJhWLUjbZtK1GZQx/drd7D9igX0ObG5E/1URqvewOdXCinjHMKRU8aIq4/pT1YtsHJV1r3ITq7Aid9zsMpuqlilBUrnfpgnzop7sq9XQxrhnNrRXjDbev1s+bwjGhX5EV2UHCMWUvSaKNqpxQ5NJmblqNAj3+2CQvp41SNngO885zO+y4NEvZaHqiHZm6jfYyakPFacqvvwuFfpEsRQ/BbI4PPUaiV1jge0zXdeIGnlWaKfow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCmb1a+esgcqmTOairS9QMt59uvESjiscCs/TnSlg+E=;
 b=T53fbB7wsdEzoM/X2ZpbzTP/Hatqnj5FTjAKPJE4Nq1SlalfACtROrq5AS+hw8jqXMrTeGNAcSI+LooswkKIQ628DzgBewqBjRGUU7gnjtAEhTSYdeX8On5YoeCqd6qr7N2210/PdWHvdPazWocgaQMyvqk7IS93kkqe6kZxDzOtQbA2UAHGfNBWKtddS/Lj4GuhRw/6kkurOH2jlsb13A1/Oaqay4hO61NzdMr/+tq5mbQKxXQow7BLT9fQAC0rr+IRem4VElNFtFoKsPacYPgKjVThGu5XkwZgx5VlrustiAfUQJgHJp09/18xVDcYudy2ZuGUyrMMEOlyPofz7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCmb1a+esgcqmTOairS9QMt59uvESjiscCs/TnSlg+E=;
 b=QirvHpZFj1yXqJpQwHzxyWbyVO8X6AsQzrpIs3R02c6MIDmjC68zEhzS/2NAp+6/LsmJP+2KE9hsmUMxV/qpuXbkIjYgHA1w5DrPqjgU9CP7gmkekZZz4mT+b51F08MtZMeTMHvpm85dRp6mucwb6QcPmwqMV/BHFB4iYDxyXlE=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by SJ5PPF82E3BEA84.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 20:48:51 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 20:48:51 +0000
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-devel@silabs.com,
        Alexander Sverdlin <alexander.sverdlin@siemens.com>,
        Lukas Stockmann <lukas.stockmann@siemens.com>,
        Gerard Salvatella <gerard.salvatella@siemens.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Subject: [PATCH wireless-next 1/2] wifi: wfx: fix use-after-free of the cooling work on device removal
Date: Sun,  6 Sep 2026 22:47:28 +0200
Message-ID: <20260906204831.949692-2-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906204831.949692-1-jerome.pouiller@silabs.com>
References: <20260906204831.949692-1-jerome.pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PA7P264CA0356.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::9) To CY8PR11MB7779.namprd11.prod.outlook.com
 (2603:10b6:930:77::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|SJ5PPF82E3BEA84:EE_
X-MS-Office365-Filtering-Correlation-Id: 06231279-e1ef-427b-3832-08df0c584178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|52116014|1800799024|4022899009|10067099003|56012099006|18002099003|22082099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	eOO7DEU1cw54tLnOyyR+Nq2VuHj6To7ljw+5nG9ASw4tERiJHl6q/+ur/AwrBXc2k+R3kZXYQhn1JmUJ0Ml5JRTHIilUnxb6bhpxQWMJbdLcmbF2npCOgneXE2GGbkbQPHZJuUYDLfo0DNeKip7J7SZR7MqkBU+ssAs4ZuTwlfjFvyCywugwAsM+sy+YS32+HlaqVeDLNwCUwPDgBeEglJxNzu+PnXmtFqfXpnJ0gFDRQHmkghKQKkOFz5pm4j5s30mwp7B+9gl3d+VPct8OnJrrtV9Rvi3CDBUv/8nQ//FHqqdj37ZZPAVmGwue5wlvEnbEy1cRgJPLoI4PIgMVlkvRW3WUlpo4tvoAotzNrYM7D3/2qqBFW+aqeENjJ9rYlgOwZ0WocSHEDQjmKb68QaLopT5W4i23nAKwMiI30xjy6atCNPsedMxuDOVT90kL+6KunjKUs9zYqfitJJta1MoUcK2LUCpS1L44Agc+BhqkxmqTNi5/lnFbddmPApwJ55uwB9cyT5fK449xOGdFckAD2LEzCcASFDWKbcXUdHPrdHWbywsxzsWh8pVi6wGMG8TeUpgoPLmpWBl4TF1oADrhfxuzFzJUt0Ni7AloSBlh3fE7okD7nbCgLpaCkn58gXxSVVF9g+tFbWiWqj6q+KKklpGijCJki5SEj9BKF2s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(52116014)(1800799024)(4022899009)(10067099003)(56012099006)(18002099003)(22082099003)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RExrNmJTQlJmcGRmdmtQbTZEQXlLdEpPdVVYSUZkWGExbXlvS084cEY5SERJ?=
 =?utf-8?B?VjhQOHNvdndrbnpyT20vcFRuVmRLNTAwTGc0LzFhZXc3dncwOXIyaXhidFBM?=
 =?utf-8?B?WWV6Tk1LR3A4S1ROZ3lycjBRTmRVcXFEY250UkdiRDFKU1pOeDlONmhPNGpB?=
 =?utf-8?B?NnpueGRDSVhZTXAxbTdMSjRkYjNyMHVvNmxPMU9Lb3k3SktDd0FMcUR4dzR1?=
 =?utf-8?B?VmwvZXZtdmxtcEZLZnBLVkdnbm1mUjNRM0dLbnJtMk9HTWZxY2MyWWxaL1BG?=
 =?utf-8?B?amFyUERWV3FoVlRGUkdaZUN2bE5wa3pTQ1hhMlVwUXhSU3FIcXRTTks5dWZU?=
 =?utf-8?B?aUZMSlBTWE9BZGNhbHFpOWlyajlWVkcxYkdORVpHVkVmek4zQmQvMXowZTUy?=
 =?utf-8?B?bkRDbE4vT3B4NmhjUzlvWDJqWDcySDM3TXFOZWVmZ2hKN20rS0lFYnduQjVq?=
 =?utf-8?B?NUNyMWMxUmZkdWovRm44dmg4Wm5HaDRBdHByVmtuZWdET0V0U3FoblpyOXk4?=
 =?utf-8?B?MmU0eXB4U2M3VU1iUzJyVnVSb2ZOWUIzcnQvTmRaaFVGZlF2R052YzgwdU0w?=
 =?utf-8?B?d0hXeDc4cE93WHFyZEVXNGc4aGFQRUovVG1UOXdyaXpVcVRhb0ZwYmRjZXlU?=
 =?utf-8?B?TTlQYkl1RXZON1Vsc2RPZDBvQjZQYm4ycWd1UFo4UC9oUktNS2toQWxNQVZB?=
 =?utf-8?B?VElVME9lNVAzYmduMFJVSGZKU1UzWmpSMUNYVW1taGVnbHNkZUZXY2FYL3ly?=
 =?utf-8?B?ZnpjcCtyVytmYjlQSDF6djB0VXV3RElRWFZoK0NPaU5IUlk4SEZNWWxTVnZo?=
 =?utf-8?B?cy82VDRKT2lzWXRsYTZMRytJQm40VlZ5SjN1MWJQY25OVzZZOUNMR0QxSEk1?=
 =?utf-8?B?QmlpN1FHUUp5NGFJNXErQmZvSEdndnhmdTB3RWtsY2VlYm5mR0FvRmpQZ2po?=
 =?utf-8?B?VjZZRzhYS3lOSFAwWDVBTllVL1BwMlV6OS9iY0RvMzJEWVhlc2RsUUJtWkhB?=
 =?utf-8?B?OGhTc2xSVWs3bVFPZlVsbDFBMFFpc2NvUHF2SnJRdUZJVkJnM3NncWdiY1hM?=
 =?utf-8?B?NUo0RHJZbjUvb1VhUzlrRWFCMnBLU2RwcXo0T2hlclExc0h0d0xUeEsySDJL?=
 =?utf-8?B?OTNqeGxZSnU3SDdrYUNVZ21EMUpYTGxQb3oySVhQaGVRR0ZkRkxhdWx6Nytv?=
 =?utf-8?B?M0dYYlFvUno5czdEUFRLWndpSEdoV1BhWElXNUg3bi9UcGd3ek5MMVlDZU1U?=
 =?utf-8?B?QkZ6Vlh4YlRqSENkWHUzR2FtbVBudWhvYkhZazNTazFsbytXVWk3K25VRmlq?=
 =?utf-8?B?RHFQZFVKVDJieDRlcU1kUWRmNmpTT09xN2VINkM0NUF3NXRBeElLNnBCcFYr?=
 =?utf-8?B?UEIvQ1MzbTEyQmVWUnpCUTJEa3hjSnlSdnViQklTbVVKVmZPY0h1ek1FdGl1?=
 =?utf-8?B?RXpwQzF3VVZDMHFERUJZTU9OQTlaakhqNzU3VGlHSXp2T0FQZEowR2FDWjlq?=
 =?utf-8?B?M21rZkw3MXhVTHV3WlZRQ1RrYlJxNXE1V1ZkcXRNbGZ5Y3picU9vL1N5ZG9L?=
 =?utf-8?B?VUh5bUMrMXJGQlg2UUZXN3JQekxWbVpadFBia2lMZzZ6VWh1YjNqWjZPTlQv?=
 =?utf-8?B?SFhUM1FDb1lyUFBrV0dscmhNdjMwaGpldXNpbXNYUWtjKzhtdndsbVB2QVlp?=
 =?utf-8?B?VDZ2dVNHcjlZME5Xb3Vpd1lMU3dIeTdtS3dNZzQyeWU0bnZMN1pJdU1abnJz?=
 =?utf-8?B?STg2TW45dXpSYUFaVmdrMHgvZTRwQk9TQ3ZlaW0ycENGYzdJanYrbUZkNVpp?=
 =?utf-8?B?L0RSQWRoS3o0VWVXV01Iemo5MWRpSWRPSXFQU1dUL3FQMlRMTk5ObVl4UUt5?=
 =?utf-8?B?M2ZoZUF5Unp5VGN1cVFpVjZrUmx5RDcrWjZCSzRXT2s4NGlRTW51VDR4ME1R?=
 =?utf-8?B?RHVyREdSMWRWZkgrcG5RRnhjRW96S2t1OTMvSjBpSTZMNVlKMThzU1YzQVdr?=
 =?utf-8?B?RVplMFl4YWNBUkZFV29jdkdXRWNubE9CbXZueG9BWHpNbUxJeDNqdXB5ajNT?=
 =?utf-8?B?SmxMM1FwT1FGY1RPMlRCRVAyVmxUMERnMW4zSk1oSG1NOGlKclBGdTVDVWhJ?=
 =?utf-8?B?djZyRk1JRXNJWWJLT0pJcnp1d1M5SEZGK2VTS00yOEVQTnQ2L0xZY2JCK0tE?=
 =?utf-8?B?RHpEeDlYTU5ZaGtFVlBhQ3N2MVpncEVFbnJ3VzE0cElyNmtmcTgyOXNGOFM1?=
 =?utf-8?B?eGFMYStIRG8vN0g1b1VCYjZlekhXajV2NTUvci9MLzNwaStqbEVUbVlZcys1?=
 =?utf-8?B?TTVPcTFnZFYxSkc3b2tUem9OclZKc3F5RGQ5ZkZNZkgvQUtwNXZVaUFBQnpQ?=
 =?utf-8?Q?h0VreSYdA8Vic73hRiBx+VCP/C1kTq/EfpyC2qIg6NMTH?=
X-MS-Exchange-AntiSpam-MessageData-1: FXPgC3jFmURrbQ==
X-Exchange-RoutingPolicyChecked:
	ksNiHanOIpzC7yon5tgO/zK5LmGq6PNZZ/Z7FeiDdu1Jtj5xupdJKgLxnusFskAU6c9qLXJapbTJ3d+8i/Y2W4vlbXewGuf+3AcsfZS2E2uN5W+WwJMYFaLC8x04fN1TGAaKZlhHtxTMaL2Th9sVm3rbrH5XJpbQ9QBZZnjjOwNgkOeiCuA7t1M8qpiKGeG/2FxA8R+ibX8jHhhIwN1XxGHkRVLNK3fw5eUn2kJLQgzShBTZVYF7Pc5VONC7jAhOxEbFjJXYGgZuPZo+4/1F4tHJzEKNLDeBWyHB5c1uYqVGEpNPUrdQwJSxrzP+XzPZAjO4BGupHV6LtQb5ijL6AQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06231279-e1ef-427b-3832-08df0c584178
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 20:48:51.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxGojYcgVJFzuWlfB2qESPUuI642vMx161qJj7sN6Fk8SYzWB4D4uYxwkZDqyXANQIeJ8hopCR+uvOl6Ort8Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF82E3BEA84
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX3wpKsH4Pwigo
 2xSMI2gSO3f3pkdyAUKzZRboiIIiUPP5o2jxRPr8jOUhvGqFl7xs//prhusnL9R98xQehgqn0ZV
 aQQJ1m0FIuHdQUv4asMqP+Wlmz0NajM=
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a9dd1b4 cx=c_pps
 a=aqjypfCBT7xgBBIDtMg2Ug==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=6KgOrB_2K63Cyhqxo4vW:22 a=2AEO0YjSAAAA:8 a=9xQQrGsFNMAwkceGwCQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: PpqeT0CsHW-InEB5QY7wJ6C-wHBdmQIZ
X-Proofpoint-GUID: PpqeT0CsHW-InEB5QY7wJ6C-wHBdmQIZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX5taUivEfZw2q
 jzpuzSXxZ47ZpGZWyKj7+R3wOXdlgNkyuPyikppIA8lxES2USKwjQSEzwwdrL3CDxihRyFQcvZP
 rK1j4EvqbHgUrIU1MsRAXniCRO342XKAsiNL+O5gZXcNPeE7cDUz02jLgdKQyiGFogWU8KUnWHB
 vHjCQiiiNNRgcLmDdNE+pTnZXFbCUqNGUOe+8SJ1pL29CnNdBl0t8HRwEZK13DZWMlbJAbQmQ89
 Sz/t4LPO9/Hq7njvbaGOQQ9s32LbRXg3o0ciH2m0Y0t0vSPFkdKahU6WCVUWRsm/MgyuUWfCpvn
 7ldR0bkT93CM5SdtxVP5E/+9JTw0UM31SuJOn1rOoaw4wt5oPgT/08eQjHj9XY6WHHdvaDgtWuB
 tQPhV4pDN7vL/oeKTaO+bvR3IxUS2rJrfe8gY68880elr8Rpmyqoo0b5d/1R1VrX9bkstu70Cyo
 gRGQ3rIr4bkGBaHzy3A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-06_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060233

V2hlbiB0aGUgZGV2aWNlIHJlcG9ydHMgdGhhdCBpdCBpcyB0b28gaG90LCB3Znhfc3VzcGVuZF9o
b3RfZGV2KCkgYmxvY2tzCnRoZSBUeCBxdWV1ZXMgYW5kIGFybXMgY29vbGluZ190aW1lb3V0X3dv
cmsgd2l0aCBhIDEwcyBkZWxheS4gSWYgdGhlCmRldmljZSByZWNvdmVycyBhIG5vcm1hbCB0ZW1w
ZXJhdHVyZSBiZWZvcmUgdGhlIGRlbGF5IGV4cGlyZXMsIHRoZSB3b3JrCmlzIGNhbmNlbGVkLiBF
bHNlLCB0aGUgd29yayBkZWNsYXJlcyB0aGUgY2hpcCBmcm96ZW4gYW5kIHVuYmxvY2tzIHRoZSBU
eApxdWV1ZXMuCgpIb3dldmVyLCB0aGlzIHdvcmsgaXMgbmV2ZXIgY2FuY2VsZWQgd2hlbiB0aGUg
ZGV2aWNlIGlzIHJlbW92ZWQuCmNvb2xpbmdfdGltZW91dF93b3JrIGlzIHF1ZXVlZCBvbiB0aGUg
c3lzdGVtIHdvcmtxdWV1ZSwgd2hpbGUgc3RydWN0CndmeF9kZXYgaXMgcmVsZWFzZWQgYnkgd2Z4
X2ZyZWVfY29tbW9uKCkgKHRocm91Z2ggaWVlZTgwMjExX2ZyZWVfaHcoKSkuClNvLCBpZiB0aGUg
ZGV2aWNlIGlzIHVuYm91bmQgZHVyaW5nIHRoaXMgMTBzIHdpbmRvdywgdGhlIHdvcmsgZmlyZXMK
YWZ0ZXIgc3RydWN0IHdmeF9kZXYgaGFzIGJlZW4gZnJlZWQgYW5kIGRlcmVmZXJlbmNlcyBpdC4K
CkNhbmNlbCB0aGUgd29yayBkdXJpbmcgdGhlIHRlYXJkb3duLiBJdCBoYXMgdG8gYmUgZG9uZSBh
ZnRlcgp3ZnhfYmhfdW5yZWdpc3RlcigpOiB0aGUgImRldmljZSB0b28gaG90IiBpbmRpY2F0aW9u
IGlzIHByb2Nlc3NlZCBieSB0aGUKYmgsIHNvIGNhbmNlbGluZyB0aGUgd29yayBlYXJsaWVyIHdv
dWxkIGFsbG93IHRoZSBiaCB0byByZWFybSBpdC4gT24gdGhlCm90aGVyIGhhbmQsIHRoZSB3b3Jr
IGNhbGxzIHdmeF90eF91bmxvY2soKSwgd2hpY2ggbWF5IGluIHR1cm4gY2FsbAp3ZnhfYmhfcmVx
dWVzdF90eCgpLiBTbyBpdCBoYXMgdG8gYmUgY2FuY2VsZWQgYmVmb3JlIGJoX3dxIGlzIGRlc3Ry
b3llZC4KCk5vdGUgdGhhdCB0aGUgVHggcXVldWVzIGFyZSBpbnRlbnRpb25hbGx5IGxlZnQgYmxv
Y2tlZDogdGhlIGRldmljZSBpcwpnb2luZyBhd2F5LCBzbyB0aGVyZSBpcyBub3RoaW5nIHRvIHVu
YmxvY2suCgpUaGUgaXNzdWUgd2FzIHJlcG9ydGVkIGJ5IHRoZSBTYXNoaWtvIHJldmlldyBib3Qg
YW5kIHRoZSBmaXggaGFzIGJlZW4Kd3JpdHRlbiBieSBDb3BpbG90IChpbmNsdWRpbmcgdGhlIGNv
bW1pdCBsb2cpLiBUaGUgdXNlLWNhc2UgaXMgZGlmZmljdWx0CnRvIHJlcHJvZHVjZSwgc28gdGhp
cyBjb2RlIGhhcyBub3QgYmVlbiB0ZXN0ZWQuIEhvd2V2ZXIsIEkgZG9uJ3QgYmVsaWV2ZQp0aGlz
IHBhdGNoIGNvdWxkIGNhdXNlIGFueSByZWdyZXNzaW9uLgoKRml4ZXM6IDFkNTJkMjk5ODNlNWQg
KCJzdGFnaW5nOiB3Zng6IGFkZCBzdXBwb3J0IGZvciAnZGV2aWNlIHRvbyBob3QnIGluZGljYXRp
b24iKQpBc3Npc3RlZC1ieTogU2FzaGlrbzpnZW1pbmktMy4xLXByby1wcmV2aWV3CkFzc2lzdGVk
LWJ5OiBDb3BpbG90OmNsYXVkZS1vcHVzLTUKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy93ZngvbWFpbi5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvbWFpbi5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMKaW5kZXggNGU5OWZlN2U1YmI3
OC4uYjZmZDlkNGMxZjVmYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJz
L3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMK
QEAgLTQ4Nyw2ICs0ODcsNyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQog
CQl3ZGV2LT5od2J1c19vcHMtPmlycV91bnN1YnNjcmliZSh3ZGV2LT5od2J1c19wcml2KTsKIGJo
X3VucmVnaXN0ZXI6CiAJd2Z4X2JoX3VucmVnaXN0ZXIod2Rldik7CisJY2FuY2VsX2RlbGF5ZWRf
d29ya19zeW5jKCZ3ZGV2LT5jb29saW5nX3RpbWVvdXRfd29yayk7CiAJZGVzdHJveV93b3JrcXVl
dWUod2Rldi0+Ymhfd3EpOwogCXJldHVybiBlcnI7CiB9CkBAIC00OTcsNiArNDk4LDcgQEAgdm9p
ZCB3ZnhfcmVsZWFzZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAl3ZnhfaGlmX3NodXRkb3duKHdk
ZXYpOwogCXdkZXYtPmh3YnVzX29wcy0+aXJxX3Vuc3Vic2NyaWJlKHdkZXYtPmh3YnVzX3ByaXYp
OwogCXdmeF9iaF91bnJlZ2lzdGVyKHdkZXYpOworCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygm
d2Rldi0+Y29vbGluZ190aW1lb3V0X3dvcmspOwogCWRlc3Ryb3lfd29ya3F1ZXVlKHdkZXYtPmJo
X3dxKTsKIH0KIAotLSAKMi40Ny4zCgo=
