Received: from mx0a-0024c301.pphosted.com (mx0a-0024c301.pphosted.com [148.163.149.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB6F47140F;
	Tue,  1 Sep 2026 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.149.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251776; cv=fail; b=Ls6hXakVP64aXZ7DUrx9LsrlwHsVdNuXYgBKe/OAQcaoEUCr2BNbL5SdK+U/0Z6wZGyoPcq1e0usSzNcprvACdVQcKF7U5wCpfCrJ6McUo9FEek1L16fpXG17ytrefK+O+QR/a1tNOa7NaN+q3HLR5H0A2kE5Q26ppdcKb7gjxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251776; c=relaxed/simple;
	bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fqWBnEqAC/zvchlqnXOa1XtYbkrQ4I8t4SmaXGmC/wu9E9HBIqaryrte081NlhXi77T+8wPQ9iC0i+Pgox+mhHhPpIws7f3cV2FPEsJaP8aTlRcGSUluGM0vWr2IqUmTG0rNfBfwAGzR213IMzU+uk/n6SWiBPCP+VmQP/HIRVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=a8RDRY1l; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=D6lbGZvT; arc=fail smtp.client-ip=148.163.149.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="a8RDRY1l";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="D6lbGZvT"
Received: from pps.filterd (m0101743.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179Iim1246428;
	Tue, 1 Sep 2026 03:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=; b=a8RDRY1lxbKw
	Eq6HJmaS6ZLu7uMELQhDt57sJz01YuG7TroYAcnq/GqTSv5CyFozP4q+bmH7AkXn
	DftctHoahLfNIjtN2M6hFcRsLxNHxXFISMzLLFpye0BRcQglKVtOVJ9iDxL0IdZc
	gzesmnk+soXTHjS9dS7GRFQTgxBHQVyw57ESiUEUSlDd42tmHMBXnFT9ZH/pokvU
	HRFBQ0FVoDqnfvqBOrLiKaa87js1agtL+JmP1X/9jSQHjX98a8s8vEF4YvU2Mz5h
	sY7AOn9X2K5vXmhnvXs8aF3Vw9eKlr3z/76U2i5WlCUFCNOCRlnNb/qW8sIMYI1m
	22ZHJdixSw==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020114.outbound.protection.outlook.com [52.101.56.114])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gbur6nrym-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 03:36:03 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPRGjJsnvtkABHJ+QXfNTQP80drsMQr/bsiOKz5xaiYnkP2l1X2FaD2bMcHSImnyBau2HOinFEfagDSFnz4GwwXc9w32dntEHUI1cWxEbExc9oFKO/tagjv0kbVyR6fzcLPU7LNftoaf+lpV3vHaOhJbyMiIMeMQBewq/4Vbaf9zy51Yp9N7qmrJTbLm7jHXRZeOK32jBSugbMw3S7tdkXfnIkI3XG0WFVY5M0BUIQlT2aCVVA/I3NE3q1OXE6mQ9NqZiRcXF6RBY4RUxpH9bhT8542N4BnoWu8tppFlI4xBR1QOQ/4NDYC6V2PPTn4LiS70Agpn+SgRBvSmN1qAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
 b=IyKaUyOEZitBHXVohWhoK6ZU+3vtvGGCcf1o/UiEfDr8H0P2BTBg/YzwgGyLcEeuVQo9MCEPMUYP196lSli9i79w/PQ/gHUnBkw4aKf7r0eaF8BNEE9BusLxZLx4LVlf1lqpnUxiOiPTtNm5f8iZKpEVK6+7Yjyj4aIpXpve2khboqJiR7J+zODEo+C8CkzI4pkEBm4BmoKYwhOO/ysGsFshYB0zjcJT4PWu8JJAFXl3glmGmxOur0h82Mot4QSx4P0+3AnUZgyGP2tZwIh56TPdfFERcB9FawxqlhCOsIvhXcwWYi6JdtlAXorHdsHjuaLZi9Gkgz94YZ+kP2C/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGdFBa/aYqMgLb3ablLrTFoS3M01ci1K+VRkqH7rrGI=;
 b=D6lbGZvTicGDp5QQkEPW5H84khgtVUmf+WbzB66prCCA+F9ohQkgVroDBYC+uOzzNQvOunMsvGLfgwJwloerqcceb0NeYQ3TidO/GRh7wf64rcvV/uTsiNoZyiiwhJH529rdl6KT15Yk806TgVD4CJdXfW2ScT3uCWS6RN5WKCQ=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by LVXPR11MB9778.namprd11.prod.outlook.com (2603:10b6:408:386::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 08:36:02 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 08:36:02 +0000
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
Subject: [PATCH wireless-next v2 2/2] dt-bindings: net: wireless: wfx: discourage OOB IRQ with SDIO
Date: Tue,  1 Sep 2026 10:33:20 +0200
Message-ID: <20260901083548.113131-3-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901083548.113131-1-jerome.pouiller@silabs.com>
References: <20260901083548.113131-1-jerome.pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: d08802b9-49fd-4c99-b07a-08df08040e55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|23010399003|1800799024|38350700014|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZQTgOb3MMxGcprV3Zo4cp/mJw8wOsqGyo/uF5cgbHISUiCFBVBQZ7yVITgduRrPES5qJ6r2ISONhciSLXkruO5EmNcZpdgto405wzGTZ+Kr9jElqArkZ+x87TnBRaNzlBtrHRfkGIVMX5hmIiMltfYq1tn4DMJGWWm4pUabsnkqsdHEmHg6CFl8Rrt9LYHIF8EbMUckvbybwzCqr0EkKHYhvtWLSaEBYyDBYgSrnu+HmOL50T0uKLVRRE2HyF22PJ3+ECAQX7m+jVJszPhOMtjexJG8iujkHSOFEv1DL7dqzoE3WY7bwXIO4ragF+tuFvE8AJ/528ozgt/748UcAFfew8ivMrbyxGop4PnMvTqA/IteConFO5RvKBQfjKo+sWSKj+ibYvUI7vhlLZwtu46my59C3E3Yp7q2Ru1hXEi08X1Zhnumh0gNyj5LXpckcFEeRK1iE/e+q9nasB2BzP3IlRGBtOtZFFvbX4ikFM9pkgM+adMHht0B611JdpQlNSzG//OZpn0OeMn3c3YNBqC1/NNJw7lo8Xf+oaOQw1b9jUr3xRGNqnOzK1S4+TmCO7YDMPPPN1WiT/ufVPORUFcCcleAiFp0IY1kfPNqYeHWGlSxCQ/YvKBsLLQeqrytsXkqYImDAQLepgdcH4HgghE5k6ymqVbwJO8iZRJ2Y66XIl+jMpbMT/4OpI6nvJkn59fVfZL0pEwGFfcqkZm/WYxPefHATQv3bIxglMi+I2wM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(23010399003)(1800799024)(38350700014)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlNrakhvdWVsOC9WVGt6R2tYeVI1cldEZW5JNWRaTUhmODZLbUVFUmN1RTJH?=
 =?utf-8?B?RXpYSnV4L0lQYVJrUVVGTklsSXlLSHMyY200QkFsVjBNVlhxNmx4cENDWDRK?=
 =?utf-8?B?T1NQR3FMc3JDdDBUa2tYOVp4bW1paUc3c2VleUlud0lHTGtOS20zdkNQekxL?=
 =?utf-8?B?WE84TkNSMGxFcmtQSVF4aGs4RFBKbWw2N04wMmRPVzA0QzdvUGg0NmRGSU0z?=
 =?utf-8?B?elVCUXc4OXo5Q2xkRzAwb1FSWk1VV3p1T2ZhRW1kaFp5SkJsOFE5ckp1VmI4?=
 =?utf-8?B?OWlHOUVpSGFyck9LRjE4dGM3cHczMjU4YmlKanhUcko5V2Fxc2tmUjZBeHg3?=
 =?utf-8?B?RWNDb29FZlM4aDlEUitrcUlRaWttOURtZmJ1TVpkangwRVJtaW41dFg0MnI3?=
 =?utf-8?B?TWl3VWRWb1Y2M1RyOWdvbnVpYUxtYkZUR0d0U0pDVUIzMHI2R2ZGa1FFa1JG?=
 =?utf-8?B?Vm9LS0lVVlZFMytkYWFnZmQ2Uy9vNHBUdjlVWXl5NW1GSEJjZVNLUlNwcjRn?=
 =?utf-8?B?TUM5VGRJdWhvbkJrQWI3Rndpdk5Nc1BNc2d5eVIzYmpoNG1nTVJGb2lRZGdu?=
 =?utf-8?B?azlseDQ3YkZNNkVsT3RvSzdON1dEUTgzbmp5NWI2eWk1eDNLZ1NaZ3JuSXd2?=
 =?utf-8?B?amFnTTVJdDNENUxXZkp5UENaandNZFBTa2dwM0pVTDFvZmJ0SVpSMm5ZeVd1?=
 =?utf-8?B?OUtQek5SaEt4STNyUFY4UzJHMDFsSEE0Nkx4UWR5WjJSS0RTbnVialhSbE9a?=
 =?utf-8?B?ZWk4RGY3RzJ0QTJtQk5KZDNRNk9NMzl1QzI2cWEremJUYWtlcTE2Z3A5eEhN?=
 =?utf-8?B?OWR6UU8wMlRFMUdVQ0ROZyt1ZFJWVHNBQlRxaEo1bHJTWlphNXh6TFE3RHN2?=
 =?utf-8?B?THErWXMzQ3cyMVhQQUx6QXh3cDNWam1jbWJ4bWpxR2dITU1KMmpIeDUwMTlR?=
 =?utf-8?B?N2ZZUTYyNDhUVzljL040ZGo4bWx5VzU4enVncFlOOXFaVDlpRHcxZXc0Rmpj?=
 =?utf-8?B?bkcwQlIvRTBtVkJ0NWV3cGNEUUF4N2JtdlFZV0RTSEJMeG1VUmkwaG1Nbjgx?=
 =?utf-8?B?R1NNVHgvV1A1dXJ3OWxsdU4wRS85N3NpYW1aa09CSU9IOU5pSWlZaUUwQStk?=
 =?utf-8?B?WGJFc2xCelpXMENkLzdYc0pQZWlTdk5xVTA5dS9Xcm9ra2FrNlhoaGdQZ1o0?=
 =?utf-8?B?dG5CMEZsa1lVbkg2emNiQVgxV3lMSWdEMnlybEJ0b3F1RzVKQkZ4V1dVNEhz?=
 =?utf-8?B?Zk95ZEFmaWZndFFCZFIzWjd2WTBqWVVaYjFhWEFDNFhoUzRBSXFnM3ZUNzND?=
 =?utf-8?B?L1drSzdpc0Zab0syc0s5OXZML3dKOUY1RndyMTE3c1k0emw1WWtzNWorL2Y2?=
 =?utf-8?B?ZXc1WFRsUUdLV21rUTlXWVpkMDE5UkxrQm51aGk3a1RrMnRDRDcza2dZY0RX?=
 =?utf-8?B?UEkvdDJUZlVGOU5OSTVKU0EwVmpVSFR3dStwWEtzUXV3TDVWdGdwck5pd2ZW?=
 =?utf-8?B?VWllRGhNWXZTejdrS05abzhSVDNOUXZjOUFFTHZqeUh2dWFzVG56RHFqdTdx?=
 =?utf-8?B?bzdBVzI2SVN4WjFuK09YbGVWL1U1QzNYeTBHWWMwUWJZK3FpamRaYWhyUVQ0?=
 =?utf-8?B?WXY3Q0xCenRSaEFDQ2J3NjYwbWlobHUrem5JUVh0V1U3TlZBT3J1REF6TkZD?=
 =?utf-8?B?QXNtdzdmcDhoMW9paE93RjlaL3c5V1NCVWN3YW1DZDlCZkhzZVpUY1EvU0RS?=
 =?utf-8?B?Z3F1WnRiRlNLM0kycWNlRk9iVnd5by9SVkVkeHZjb0Q1YWYwSEQ3WFVvZlBC?=
 =?utf-8?B?WXkrTkk0QzdWUTFmdEJRVVB4enkwd04zYmpJU1FHMllyZnhlNmJGc2o4OTNJ?=
 =?utf-8?B?Q0oreE1Zdll5S0lOY3NzeWlzWk5tN2gxZm9DWjlDSXhJT0krbXZXTmlhU041?=
 =?utf-8?B?SXVXa0IxQWVRLytLOGN2MFRZMTFGa3FRM1hab1hsZTBBMGM4MlFORWxNUE43?=
 =?utf-8?B?Q3Y3Ymt5Mm8ycmx0ei9wWDlsQWpvVyt0a2VqenIwMSsvNVA2ZURDYVdKZ1Nj?=
 =?utf-8?B?Y1ZWM0dNWU16a3phRjdHUjNLaU9RcGU2OXlTSTlEcTJQdS9JZWNMTXhoVk83?=
 =?utf-8?B?M3hXR2RienF1b1BpYlpJeTB1RjNRY0xaVWthSU5JSm5aSTJ5dkxDS0VSbnRq?=
 =?utf-8?B?aVlrL3ExZVZUQm9HNWFJMnVoZlBJTFFrMkhtOUw0OC9scisrUWVtQUc5S1hk?=
 =?utf-8?B?aGtLMG4yY2ZqZ0R1eXNuQlVIRGZKdWdTeGF1SlpvMXF3aC9nK01CSlp0Tm91?=
 =?utf-8?B?QWIyZXMzeGcvRGN2ZTJJaFNuK25DTG84YUZOcGFIbW9CSjNvTDJRUT09?=
X-Exchange-RoutingPolicyChecked:
	F+SIfyuHocpKjDxUw04rGwlYLT6qFt5ApeCvaJmF+QEf8wHxtdsYiWCJFK08vEskAQAW3kGn69qJJKP2wLABb+8zcNHmvsehodTJ6br/j3dWzPC2miDGrjRO0Pv9ffxEhalo8b9UhdhChqJSjVjuFMZt8HZUAu+etjJkEAryE55h6tsgGIAXX+rFfi2NNhwjBOejc1ySRTR+DpruA+8/YJtGN2y+RxkZ2R1t6X05h58EniY0rCbvH1mYOsxfovaslO/zaOOyS2zSi2+mV54PED+d2N5aRy4ujDbJHv2cKM2MEeoG07sLLPNZMp7nKlY0qL7Q584Zlyz5m9zwxqGeKA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08802b9-49fd-4c99-b07a-08df08040e55
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 08:36:02.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EuSkByCYx8bFdhBNDKn448CpZFmRI3XmCpx+BfObNZyYhL16tJvx/jIJFR51cfDP46vVcxyg0X2+rdXVjNfRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9778
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3NSBTYWx0ZWRfX8U56MdMNuTXq
 Yc/3Ebh4hI/hfdfsigf3nQNY8KNzCqZjhnHJQpcsvn+8Vo3v3gI+sdUb6hLQagP/UkqyqnZanbA
 qThxA+F0oqJpcnT9MAomQJ+FBJab1QI=
X-Proofpoint-ORIG-GUID: 2dlU7rSXJpnQ7tNkZFSIi5SxcjlLKJT9
X-Proofpoint-GUID: 2dlU7rSXJpnQ7tNkZFSIi5SxcjlLKJT9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3NSBTYWx0ZWRfXygwZqRQVw7lp
 MbsKx+wdwbyMWwA8qwNDzky7tgLipjDVgdbdXNfAHv9jNmzObCAN4XG0ztzvvHAJ4UERg1IDkVC
 S89YEjLH4bNiGNUvc7Y3cC6QGHUGfxgwQowZoAGcWM/9btt7t4VmC7ZOrptEHBHoaPEUs/qFsQQ
 WJVuC8mTUJrhi8n/7TUHPWFDYoUhDPyarva33he0+cjFAOo9me8LKMmHaKa7EdCSOr5bxANeeYN
 IfqtZt+X45POkJJCExVHCSNOCNkNRX5jUMD4b5Pbf/6KuW5g150BoI6qK+Lvi6GYw/XlJdBQ+d6
 ypBEgS/Q0QYCoJQftaRSW56PzsuRoXAHlsBDp1X159ZvAg7cbQ/6kVnxVswSVAOZWt8p/TZu5jY
 bwwBrR14qSsdp56/tVGJ3cRyNK6ethSABfs2weFxm9rjeILpndCqsKODY+27FHGd75oQSiNSQFd
 9z0FouvP5OWRkAE14HQ==
X-Authority-Analysis: v=2.4 cv=UIHt2ify c=1 sm=1 tr=0 ts=6a968e73 cx=c_pps
 a=+29CLaFxg23VDaVrfDag4g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=6KgOrB_2K63Cyhqxo4vW:22 a=2AEO0YjSAAAA:8 a=3cI6r80fLADfETk40vkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010075

VGhlIFdGeHh4IGRldmljZSBwcm92aWRlcyBhbiBTRElPIGludGVyZmFjZS4gSW4gYWRkaXRpb24g
dG8gdGhlIHVzdWFsCmluLWJhbmQgU0RJTyBJUlEsIHRoZSBkZXZpY2UgYWxzbyBzdXBwb3J0cyBh
biBvdXQtb2YtYmFuZCBJUlEgbGluZS4KCkhvd2V2ZXIsIHVzaW5nIHRoZSBPT0IgSVJRIHdpdGgg
U0RJTyByZXF1aXJlcyB0byBwb2xsIHRoZSBjb250cm9sCnJlZ2lzdGVyIGR1cmluZyB0aGUgZGV2
aWNlIGluaXRpYWxpemF0aW9uLiBUaGlzIHBvbGxpbmcgaXMgdW5yZWxpYWJsZToKaWYgYW4gSVJR
IGlzIHJhaXNlZCB3aGlsZSB0aGUgaG9zdCByZWFkcyB0aGUgY29udHJvbCByZWdpc3RlciwgdGhl
CmRldmljZSBpcyBsb3N0IGFuZCBvbmx5IGEgcmVzZXQgYWxsb3dzIHRvIHJlY292ZXIgaXQuCgpU
aGVyZSBpcyBubyB3YXkgdG8gZml4IHRoaXMgaW4gc29mdHdhcmUuIFNvLCB3YXJuIHRoZSB1c2Vy
IHRoYXQgdGhpcwpzZXR1cCBzaG91bGQgYmUgcmVzZXJ2ZWQgdG8gZGVidWcuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4
LnlhbWwgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJz
LHdmeC55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVz
cy9zaWxhYnMsd2Z4LnlhbWwKaW5kZXggNmMwODg4YWU0YzRlMS4uNjBkZmUyNTdlYWRjMiAxMDA2
NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9z
aWxhYnMsd2Z4LnlhbWwKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTUwLDYgKzUwLDkgQEAgcHJvcGVydGllczoK
ICAgICAgIHVzZWQsIHRoaXMgcHJvcGVydHkgaXMgcmVxdWlyZWQuIFdoZW4gU0RJTyBpcyB1c2Vk
LCB0aGUgImluLWJhbmQiCiAgICAgICBpbnRlcnJ1cHQgcHJvdmlkZWQgYnkgdGhlIFNESU8gYnVz
IGlzIHVzZWQgdW5sZXNzIGFuIGludGVycnVwdCBpcyBkZWZpbmVkCiAgICAgICBpbiB0aGUgRGV2
aWNlIFRyZWUuCisKKyAgICAgIFRoZSBoYXJkd2FyZSBzdWZmZXJzIGZyb20gYSBsaW1pdGF0aW9u
IHdoZW4gdGhpcyBwcm9wZXJ0eSBpcyB1c2VkIHdpdGgKKyAgICAgIFNESU8uIE9PQiBJUlEgd2l0
aCBTRElPIHNob3VsZCBvbmx5IGJlIHVzZWQgZm9yIGRlYnVnLgogICAgIG1heEl0ZW1zOiAxCiAK
ICAgcmVzZXQtZ3Bpb3M6Ci0tIAoyLjQ3LjMKCg==
