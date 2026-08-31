Received: from mx0a-0024c301.pphosted.com (mx0a-0024c301.pphosted.com [148.163.149.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C373845BC;
	Mon, 31 Aug 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.149.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195030; cv=fail; b=ZY0gT/2meUcOmZqC8IZHT9FJJFPlvy15eRhLOSAF/GzvIfZSG460+gC8qZ4+9/5qhBbpzu/kDBmlqDyQDN9NyTJFuTbokso+/WydT0CnCcd67vyCy5RM5pTVF1L5xz+ee6GkuhbPGJvLt/Ix0JnWaV/sfpYsXSL+669ynLqaFUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195030; c=relaxed/simple;
	bh=EYaJGwSsNaUllTdvTloWyJx9r4+XOdc8Irgr6ARXK54=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=grZvdfQfdsbBGWHbIYAzBkK9bIqz457TO3wgOVqCZdq0KRum20XbYLKZLJlSrwXazlp5tmDp+70Ux6YSO9SODrj2qFdD6wVEEyXPZMhkTZ+t0SAN/29K8B/+wdfTJCOG65ISe2dOS6L2a/9icy0a6brLSoV28N0qNnpGVR7ngEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=o2uwDhSI; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=LWzpn3LI; arc=fail smtp.client-ip=148.163.149.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="o2uwDhSI";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="LWzpn3LI"
Received: from pps.filterd (m0101743.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VFibJG3756315;
	Mon, 31 Aug 2026 11:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps12202023; bh=EYaJGwSsNaUllTdvTloW
	yJx9r4+XOdc8Irgr6ARXK54=; b=o2uwDhSIYmApFTJQjlcIv1RsHCsylPHlE33n
	owPHPLltVOpsQbvupirYYf8siULGd8xxv941fd463AXGpe37EVBZv2bu5H9aEeou
	4W8UmBwvybm/n2clqEnNEhioc3+WcQaQvYTsnzpOjy0+YpwGeSlYYkKKoSWPgbAo
	zpZqj1ZKKXF1TB5aCxUY3iZIBgT3ED7i8Qs88UwOtsS4b0z1h86uZbDI81jjhIVT
	WzAlvcCOAANqneci/7ksnC4RbMj/GOcg9VkJxZHndYEQlV06r7xw44HKKijsp95P
	IqFIDs9Mh2WOmoeSU1fr/41iilsK06X3jq+0MlyodIzxu9/m+A==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022143.outbound.protection.outlook.com [52.101.43.143])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gbur6m1gk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 11:41:22 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrJ0Kq/wWkPWV4zskQ1JZVuTSls4ZHiyyagYcYkczONJksJSFLL1t14TTvYf11gfuK5XFYvynFf6pHnrS8jJVBAwjJFoT5LrltuqzSN0hyTm69qu86f8aAW8ZAH00vJYqcOcaSDhXcZkQWSlYssJehQw+x6uhzmWA8n+XUfacrWYbk/Zb8YHteWRnqJP/8ze4hV1NfndTEEAXXF/4nmUkZ0HdjWBtOjIuFGLhBLsn2v4vksjL6IyQessWqDE2YwV3W/6dtI9ZSowiNrua5iAYi338v7RK9B7/SvvPJ7jjPrl/q8JRc8Og+BPjMMG388xfkq7bRCsIbnbx3tR6hQxuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYaJGwSsNaUllTdvTloWyJx9r4+XOdc8Irgr6ARXK54=;
 b=M0exJidvJ6+j+fnStjtt9XVjCNFaSs14/7F3BbK4KYSMY3IJduOtwZy0G0p2TC8RTBd0HYFn3fGOGlwj8nWaOj9iGnnM/QIaRgPajThnkoqT6CQZ72Au6xm9pMXY2TMmcjfBeYG4vno/KaDRdhPq6KclTS5wM4p4Za1dzUteQ7UwJuFhZ1JuvBfL3JVhtbpM4gARA6pQvDc32IsX2gXhbYwyYvhISvWXIJeOhQItOxdxkge4cMifFfoAWVPz/pcv3FrdwULh7aewId8yszuhey7/KL7l9CFRYjgu1/ZVQcASpjM794YPfe+HbjRZG3IPCsYIatQgQv4lfCxcblaKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYaJGwSsNaUllTdvTloWyJx9r4+XOdc8Irgr6ARXK54=;
 b=LWzpn3LI5fkoTMuddBru/Z/FyjwP5x7w4U5CsvAul3vZRz0Ic3yeZZ1IyLzEtUp+WPSimITR/o3GAEmZOY98DgUjX7LX124LLLLePuxAlYrAjIG1n7ehS36cvjeHtxWgMqizNRN8vSBFnyyizGiv8A6vuZQK1gXFb/8Q5M5X/gg=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by IA1PR11MB6492.namprd11.prod.outlook.com (2603:10b6:208:3a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 16:41:20 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 16:41:20 +0000
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
Subject: [PATCH wireless-next 0/2] wifi: wfx: fix possible device hang during init
Date: Mon, 31 Aug 2026 18:40:11 +0200
Message-ID: <20260831164056.47683-1-jerome.pouiller@silabs.com>
X-Mailer: git-send-email 2.47.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAYP264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11f::18) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|IA1PR11MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 704c2252-063f-4ab8-f11a-08df077eaf91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|52116014|6133799003|18002099003|10067099003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	sP4wN6gQKbGJ7e4ldp7eBjRHDxOwnod/tpOpkbjb6iwoTAJyyA6Q1fGbdIUGz6u+QDgBEzwIxnmd4soUzYL2fcH0nH4OruXirEOz8rve5h7xJmwsbxXlSk1ViFhlLkSOiFmwUBAJvjhme9FtsNc9K/XlLF9FGCSpCacDQI3pGV4WFcCwLWzD2ygYamAPiTSplvr9Cid2+rbhpA2rySanrUwaIIHVcAs1ovb/Neq2F3wKAtjH6i3uW5gcQ4ypEYMO3JG2ctWZC5n1F8OYLfcsDy7WhzmsDgAeo5B+lO1sNlk9RD2g22+OUSPMt/X29b4/RiDQFo5FusHe7APvNtLna4MwLflJr8Q8FqogEJux1B8cwkeWm+EKOJ3AVCyLmfOltL5nLUt2NJ/isB04/XZL2T3xZgM98iyLcV+bWRMK795Ck+VeblKo6lxWORMxf4RXvwNMFcUXR8DiAo4l+pkauMb70TUR+wprSyxrjpZ7fPkphENWM9qFfx5qWTGmo0I5l2H3UBMUeTxV7/gNOvjHEVcnAK05dLveZcBKM8oVwzGYhkRurIaOR92WXXAqVT8b6UKpqYO3fCTUlNJmFYZ2ajV8yp723HMnF7RWMAnRwtQ4clQQJdDBJcc1qXKnCErp1Zx6tyJentmidRLMPJU7JPc5MKLfMInKSYQIlI0rcC8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(52116014)(6133799003)(18002099003)(10067099003)(3023799007)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzBHNEpFYjRWRzQwb0ZiVmV3NUNhOVViOGlyVTJUM0xUejUrVk5sbUNrWlI0?=
 =?utf-8?B?emZVUlp2dndDN25vbjRlTGhicEduTlllMk5uZGQrS3RmekxFcFBlUGE4TVZo?=
 =?utf-8?B?T0wyRTYyTkpJaDNldFg0TmhCdnZBZFJjTVVSRmpLZ0g3Unl3MU1hRXg0SEg1?=
 =?utf-8?B?WGtObEZ0SUxjUkpGRHRKb1htOVc3T2RIWkROaU5KcmVBTUxSbEg2RTFnQUh1?=
 =?utf-8?B?RlhzVXlCdi9XSWZIQ1FLekZRbmRCWUcxVGROL0NXZFpUQmpxYk4xT0JNVWpO?=
 =?utf-8?B?TzJFdVFRNmlQWU1paVVZdHpLUzBvbldGOHNZRHlsTlF5RGN4YjM3ZzB0SlFu?=
 =?utf-8?B?Z0pMVG5sK1d3b242emhyM3VvLzVKUFlteldMeHFHb3JlZmRUOGs4ZDRhOUZ0?=
 =?utf-8?B?RHVyQmtjOStyM0pFQnc4NHgxUzQxYmpyaEl4ZGxCb3BUS1kvT3ZNRFMxZzV0?=
 =?utf-8?B?NXZpSHhvQktTQzhvcEE0T08zMFZ4SDdUbjdMMHZkcXJtYkdnVmVnNkl1STlX?=
 =?utf-8?B?Um1OK3g4c241VGVXYkRtcFpudzRHZHQxNmhMUGN4NDQyb1R6TFZSbVhGdUZC?=
 =?utf-8?B?ZXNPbUtxQ2p3MHZNS1NsV1ptbjR4UTJXODVZNUp2Q0IvNW9KaERFeStvNjJl?=
 =?utf-8?B?dGVBdWExOGhqcXRxd2NkNFdEK0lyRldGTFlVenVIZlltUk1CYU12Znp1MlBl?=
 =?utf-8?B?YTArYWwrai9oMEw5V1U0OFZzRlRBMDFaSWl0RVo3cnUvcXRsLzk1WkRiRUg0?=
 =?utf-8?B?TDRXOENZRXI2eHRrWDZWZUJEdXg1cngzb2hPMWc1Qk1QZy9LcHRMV2dQUC9Z?=
 =?utf-8?B?VmFPRnRxYWcvMjZjYmpFbDZTelp1UkxZNnpCR1dlc2tra0pKYW1wMjlKQXBu?=
 =?utf-8?B?ZEhjdDk4Qzl5Sk0wczE3SXNvOU51aDUrUXB6S0ZSNDVMVHpzeldKdCtiRkkz?=
 =?utf-8?B?WnJvRnZ6UktudnFuZTZLcjdqZDJlK0cxNzBuV0Jvb0wwTlZRSURjS0lXaUQ4?=
 =?utf-8?B?RlJkYVFNUm9yaXlXT0xwTEs1cnJlTUhrVnowbzBsQngwdFplR013anhSSVNF?=
 =?utf-8?B?NjhXaEZiLzFiMENDdEdVdzhVdGFCVTRsRTRBTzdIaVNNYWJQVHJDYW13aCtv?=
 =?utf-8?B?Rm00NEhPOHM3dHNhRFQ1eWpzTXk1WmFBUDBVUFdLOXptRnJ4MmNMSldDalNs?=
 =?utf-8?B?YWkxQUMrRXIwU1dXNUJrSk1RRld5MW9JQmpVOE1OWnAzR0E2T1ZWZU41SWpi?=
 =?utf-8?B?R1dvdUNIcm5VMEhOaTVxRzVuUlF1eXFEQWQzT3hiRHhjUGJhdXlncmVMS00r?=
 =?utf-8?B?bVFUNk9LZGNSaHNMTHU3LzQ3bmhPTm9DRnI0d1lvWEQxTkxzaWhwWUFyZS92?=
 =?utf-8?B?MWp4OVZnMTg0ZXJ5YWZzZlp2dnFKdzExc0JITVVRclZySEdsN013SlBpQ3pL?=
 =?utf-8?B?Ym9FZ0hMc29iTWM5VU5naGF5RnFHL1BRSlgzSXpXZ2RJdVR4dXplYnJCSmZx?=
 =?utf-8?B?Q0dTbWxzLzZXalJQYm5MdXlYSXdPSTZnMHhvN0tZMzljWjhXd3lES2Y3Slpm?=
 =?utf-8?B?Sm4vOG9pMkgzRmRxQzBFNTVueVA3U094bTBXaUNBVXZPbERIUjRTbk9yaU5K?=
 =?utf-8?B?cW9sNi9HemF3K3U2QlVGSXY5bUdNYmRRNUdEcmtMcjVSdUlXYVRERWt5Qzlt?=
 =?utf-8?B?T1dPSm5rZ1JhNVh2aFZzNEtPb3dWSjNUcnh1cTA5d0tWT0cycFNUaTQxbmIy?=
 =?utf-8?B?aUhvRlY0d0NPSkI4b0k4UjNRWVdrKytFeitSZWxXaTZuYXA5M0JVaEZhbktV?=
 =?utf-8?B?andnVU12Q3QycmZyVEs2SkJrR1NSNTJPWHJXMzgrVXUrWXVXT05QSkVvRGJv?=
 =?utf-8?B?WU9xb1ZQTG5FWkU3ZUhTdGpxaTFtQ1RNajJKWjhYVjZJYUlrU21SSTg5R3RD?=
 =?utf-8?B?U3FBTlorT0oxT3IxUGVEbDBtVmU3VG9GYnI0ZnhnNDdOMjV1ZWVObzdOR3Uw?=
 =?utf-8?B?L2FZT3JHYk1ETlowSzM5YnBJbGRjUFZkcHQrdTRZb21NS3RQWWtNcTBYZ2N6?=
 =?utf-8?B?cFBrdWY0Y1pNUktzN2VNeE5NOFlSRnREVm90ZlMvV2pzclRXRjBXQUtqZVRG?=
 =?utf-8?B?MUIzK1ZqM0tWM0tiSUlSY2JWQ3c1aStVNW9GWjFEZTF2aTRVM0xBTlRNditm?=
 =?utf-8?B?VnlLMHhaWFA4TEhrY0V1NGZMOStXN3I2a3B4T1AwVDRzV0dsa3AzQkhaRGpT?=
 =?utf-8?B?R3NDK09vWCs3MGZ2RjhZUE00enRvdkJxMlQwL3JCQWJvemFuT0M0UDgwUUg3?=
 =?utf-8?B?M3JUdVRFdHRMMjFFVGxLZDYvTU9GMm1qSGt5Z01WZWxnNUJuSEFHcjVNcFNC?=
 =?utf-8?Q?XK4A7/GvRpaJNUa9bMlcW4RmyQ6s1ntQEw8wtLxYKHScJ?=
X-MS-Exchange-AntiSpam-MessageData-1: kMpimqGRpUiHvw==
X-Exchange-RoutingPolicyChecked:
	zxrEeYumZfpxMT+v3Dy4wu2lftX0z+y6rRcpHOzY0eMIRLakcZ0J/CulQozj/Oy9enawpWN4pUvnQVQ2JAfKOi6/f/HX04NwLOnerKtdOFz8+31kd99f8d82BaX5BENW9sXo6o44RlqNqCMRJyjFL9u5rCDexQtANacymlg/7Jmh2sX/Rh6YwWDr0cqjXZAzomBcT2eWiQ0Q7B6tbdJVNKtTD2vxhyVJibkR4uHGKXQyK8z0li+fIU3wLyVJGwXajjjG+Ick/7v5IF7KvAUqCiDLPwS0GDGAEZ0h59bMYkPH+RN42OjDxns+WLzMfZnGI5370x/fqHtwAnQNHl5xDA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704c2252-063f-4ab8-f11a-08df077eaf91
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 16:41:20.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQq4jSbacb/din0laXH2338eJYEgIbP7xv5hXDh44YdWNlCsqmFYgpE/0bY86Kwoyo0A0babiJ8yFxJitNRCqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6492
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDE0MyBTYWx0ZWRfX7b1Uvt9FALD1
 lNO2Q4kQW7YeEKjFC37T+8eG0SYBkRZbLWreGettgQqpAF/mVZQyh/Dg+AhM/jhwHvMGDKHJRF6
 uI0CPCzZsCcRfQmam/ZYc/dY/tkH3Gg=
X-Proofpoint-ORIG-GUID: 43X3VxAJEVuxw192KKih27T7JBAP7N3Q
X-Proofpoint-GUID: 43X3VxAJEVuxw192KKih27T7JBAP7N3Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDE0MyBTYWx0ZWRfXwiyveG53IBuW
 u5nsyjlzYg+t6I7JOCLER6iTd9hBirgwNV52m1IwqhOW+cqKQAGteRLYSUm5xqgmgEWEIXU6JCo
 B8JUJok5jDYQU0XsmjxVeBekrVjmwspEa7fVz4Nikj0DDmk7klW6vwr8Hpu3WmwyRhURY6iN9CT
 tu1Gx0UmLmBxDxIeARb6tn5fkSbsz90+CRfv/SHMS155ik1BdJRS5JUHJDzd6yG0BmKVR6xCLXy
 dITkIecJrq1WNy3qRJ/xRur3efleGPvXpiyi6Lhks7DQyHyBdAi6G5eEjX6DZekwHSgdtsKGYvu
 5XN1TA0VULqmeYFFpdlDlqFg22rxBWYGEBghkOtOhCM/1lJmytcOGI+t/Th+G4Up+86j4OEP5sm
 UjRuUjKkCmCXl2nvt76b+LC2EHJXZuxY3KxYyCACcKiqbwhS8+9OkWz6ajUFo1rf538NOXi20FJ
 nD9X2nOIcIOkVmEj5Ig==
X-Authority-Analysis: v=2.4 cv=UIHt2ify c=1 sm=1 tr=0 ts=6a95aeb2 cx=c_pps
 a=ofxP+VRvIeXlqxG7dm9PvA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=6KgOrB_2K63Cyhqxo4vW:22 a=IXT2DV1lbWpSFN5LiBYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_05,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1011 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310143

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
dGlvbi4KCltDb3BpbG90IGdlbmVyYXRlZCB0aGUgaW50cm9kdWN0aW9uIGxldHRlciBhbmQgcmV2
aWV3ZWQgdGhlIGNvZGVdCgpKw6lyw7RtZSBQb3VpbGxlciAoMik6CiAgd2lmaTogd2Z4OiBmaXgg
cG9zc2libGUgZGV2aWNlIGhhbmcgZHVyaW5nIGluaXQKICBkdC1iaW5kaW5nczogbmV0OiB3aXJl
bGVzczogd2Z4OiBkaXNjb3VyYWdlIE9PQiBJUlEgd2l0aCBTRElPCgogLi4uL2JpbmRpbmdzL25l
dC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgICAgIHwgIDMgKysKIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL3NpbGFicy93ZngvYmguYyAgICAgICAgICB8ICA2ICsrLS0KIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL3NpbGFicy93ZngvYnVzX3NkaW8uYyAgICB8ICAxICsKIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy93ZngvbWFpbi5jICAgICAgICB8IDMxICsrKysrKysrKysrKy0tLS0tLS0KIDQgZmls
ZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgotLSAKMi40Ny4z
Cgo=
