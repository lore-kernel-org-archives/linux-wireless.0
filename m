Received: from mx0b-0024c301.pphosted.com (mx0b-0024c301.pphosted.com [148.163.153.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126842D5A01;
	Wed, 16 Sep 2026 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.153.153
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580760; cv=fail; b=bBlIAqeIr9zM0QRy4DuNepvGpVGHCRmgh1qFRs7dSZI63bYJt5AcmkaDYjF7tLSWbkZyuAkMgP0aJfAorqpSnyj6Z0GJy33VhejQE9Ye66Jf4QzWdbk7NQto+JHXhw/GDPZmBNVlUZKWbnzPDbp0fE+jC/z3hbCS+sVQyRmPrs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580760; c=relaxed/simple;
	bh=fUG4LC1Lu2c+h7Jj5Sh7aiMKWoRUEXNHIy6IVoWrvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FXRMmmYVv9aB8PHlRGTCpaNxH/i79LxOWHnnDdmdZras+9DDfmh9hXBmx3tmSPJO994k1P3jZUtClarj9MAIXG62PWCunibkbnuEb0bj+Am08Ipc4HEan5ifFsCGD6U6eWPXCSrYDo1+Bou/LfbrJVY6VDl6rUKpEW6rQq+7NaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=ca4ukkar; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=Vg0pmMZI; arc=fail smtp.client-ip=148.163.153.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="ca4ukkar";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="Vg0pmMZI"
Received: from pps.filterd (m0101742.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GFdZ873283557;
	Wed, 16 Sep 2026 12:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=D2QlC3HX95HPPX4fEx4xB6F8XJZCtevWSk7CA1nClVY=; b=ca4ukkarmin0
	bGD4nSBkiM0uSeNYUEWuapT6LruT8Z2cpG4QuOLAXvqTi/l3qlASmxU8YH7KjaE8
	13a81Z6KT4pOzWWyuSW4b8VBxFwZ9VSzI1cY5RYx+VIvworKQXcHuA5Czmc4kJii
	i1ajp9z/7VDav48pz9Rd+i1kVrCw/czxSDVwIhfdhc7lzJpRUN/0X65dRJiUsxwO
	VL0PkhmUCR+NvjCP70050OVNCnnWoPQ5SmyQP4Uv2Ls5ClohX/J38VJ1iS3DwfZ3
	YecvHdrqw+jatBZWgMDuPri9+XCryOgbOgECwEZsrzg2U3wjdpC9T5YlyPbcaaPl
	O+P27fcQ1g==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023116.outbound.protection.outlook.com [40.93.201.116])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4gn089u4aq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 12:37:40 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3HRIy7XnkJbuaYvAQWfSEMdB+zZGTm5ZQ6JYTxgRfkLGtndrvrp1UikfHebNOuvPyA1YeirLhrljKfgDwT790FyDGzGsul3fWI4RAhjXtLd+DIIv4ChkHKBOE0i0TjZh0xu0WRq5ouHlwy0DAdgNMi88pAALH5UV/h6ifs1HM7pJUKyHZ8qWMQ7+DfV57UW0J163JrJ6is+sfryBI0WLkBtYoQ5D/oKOZ2HMkflMbi7S3sioG27CinocGQHHUrl0/hANVwjF1hkQB4HKZ/1XiMvbM3/4wfC2UxJkfeqCeD25qfsh5dW7aRZP++k9kFjLdKcKG5XbWMHFWwG0JcC2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2QlC3HX95HPPX4fEx4xB6F8XJZCtevWSk7CA1nClVY=;
 b=i3UDv1/83SSU1SNcXLZ1qEPt0HVwxr+WMC48q3emLj6lZPULKUQyGPCP7necZfOaPrcSSounNJX1xV3OgvLzApA0inpHVQ1ntfFO/riouYxDjz52qqYoT/fFTg0C9vwwUT7x8iA809UTgPAhPPggo2j0SwhhAeKkYzj478nzmmvIoyVc4LeHUzTR3P97lHzMI8/0rHGFNo9D8RteZ9q5F+o6iKR/klFFZfVqj2+ev76TWNeQP+w9lHXu8nanx0voGK1bYjIRsR1GY7WzoPAzL7sFajYJ+Hosl1BDvxDL3Rf0v+10p1EuK6Wfux/ya7nUpLfPpVgATwQHqMPyxddJXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2QlC3HX95HPPX4fEx4xB6F8XJZCtevWSk7CA1nClVY=;
 b=Vg0pmMZIJqD2Ycae8QGt9OazQISQvzIiBNJkkA1Va1IJYIvnnAf5QTDMOJH2MbCsy0sdW/r+ea1oDAAaSnMlsBkImyYsiJVt1QKFzjCKjdzgkB5ThRH2Jq2Pw/NnwKM7r8vy7iMPP3WuWSrPE0ka9xFN/+Z6Rt8iOxPz9dSljso=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by IA3PPF849DF23EC.namprd11.prod.outlook.com (2603:10b6:20f:fc04::cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 17:37:38 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 17:37:38 +0000
From: =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH wireless v2] wifi: wfx: validate MIB read length before copying to
 caller
Date: Wed, 16 Sep 2026 10:37:28 -0700
Message-ID: <3635048.QJadu78ljV@nb0018864>
Organization: Silicon Labs
In-Reply-To:
 <AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References:
 <AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: PR1P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:345::18) To IA1PR11MB7773.namprd11.prod.outlook.com
 (2603:10b6:208:3f0::21)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7773:EE_|IA3PPF849DF23EC:EE_
X-MS-Office365-Filtering-Correlation-Id: 6472580c-f1a4-4b9d-de39-08df141933aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|10070799003|23010399003|376014|1800799024|3023799007|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8j2tXbDTSwicQHzUA8bGXphHPgw3pIib2YfkjnLa7VCKIzMTzTIzNi0UvemB6lCk1z4x713eQ2K9SAxoJJBYIcDIp6OZuHm2HcHQOv+To6jOTf6JByKaIgJywOTOwoiFLjrzhKHb3impBA7OpxWkuVO9tqhlvWZmoT6mkzM0xDI2pAGi20DsZyjIiKjk2Du7XMNELoMgNatdFa9uskR+P/trOMD3BKHbCi0CXPFTi/xgYJOzFgUQ0jU8icw4KG3v8lunFDJEKOIg1RS/vbZCbGTt42/y/V9/O7o2p+WDFma2TL1sNrhOxO2i3TE5ioSInY3Q6bE/UHkw0SdKDpnaBiKV/Ja0wlThtAv0Qs2vCgreKynJwYcjHDc2R6KWAi8lLxHwitXjL56t+KM9mo02YxoS6iuc6yQQy4uRVlyP0fD/ObDpk3ePCoJO/hucNSyngFPhVRLiXy/G4ayQ50Fpy5IIdErHKdKxjrM3uFlyRZFCqakfOfELpvuUrhGyBXZERNpnPeMYre3qB1Z+AFFzbNKSPAeR6N8Ym5HM3v9GDRvMvJ5tsJJKyUKk2t33KxusqJnIkTbTJQbp22gpLZajlYhMeSuDlB8o4qZclZZqW5CG5myeyTAn+8fi36bhEf3pG6awu6XloDc4S/mVLKod/RP20W9BfcJLAF43Wis5MEA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(10070799003)(23010399003)(376014)(1800799024)(3023799007)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dyt5bCt2L01QMytvUXlUcnJNaGg3M0dpZ05UazdVc0FNT3kxUWRjLzAwb1hI?=
 =?utf-8?B?NXJ3OHVFZ2RvU2tFRTQ1d2Yzek1Iam9oK1Z6UktCbkplN1BwS1lKWGtwWVB4?=
 =?utf-8?B?SnEwUzVFRUVKOTA2ZHB6eDBGN3FBSU5KNmpQT1RnRkJpeWhIdG9sdW5jZENh?=
 =?utf-8?B?VmNMaGJOOHJnK3FlaHpzK29ua3V6L0p3ajdiRHR5MGFYWWRxRTlJVXFsVENk?=
 =?utf-8?B?UXhGUGtDRkg0bVNjeEppQ1AvcEloU1Ayc0NRYzR5eXM0RU5jYzhhcXJLNU9S?=
 =?utf-8?B?TllqcWk2V0Z6K3BIZ0lhRXlHSEtzdStPVzZuVnFzT09La0dwdm5kUnYrOEo4?=
 =?utf-8?B?MTRhWU5vUDczc1BSSTNVTWhidkkvNXlhQWQ2YmJtcUpKcHF3eHZaVW5OUm13?=
 =?utf-8?B?aVFkbDdDWXNXbk9GeGZMWFJMaFQ4YzF1eDhlU2tZWU1TQmlTTSs0am1GVDdh?=
 =?utf-8?B?VTN4SFJvcVBiQStQbVlDVkxoNGoyWU9NcENXbDNlQktKU3JrV1o0WUdLZ3FK?=
 =?utf-8?B?VnU4LzBnV1JYV1oxM1h2MnJHZUNyMFZYYjhLMERQOFI1WXRVSUpVUE5QdWNn?=
 =?utf-8?B?Z2Y5djNSRzg2U2FHQ1BzZ3drM25VVWFzd1VTUnRzREx3Y3pKVy9DZHhGcGtG?=
 =?utf-8?B?UWFITkszOU9YLytweDB4K3pXSUN2TE1acFF1RkdBS2kwdSt6K2FZanJRYmtx?=
 =?utf-8?B?NFRSRWRNeTZ0Yzc2QkdmWVBPd3h1UXlkVG1IZ3QxTmdxcEFjTzQvTGlDNXRL?=
 =?utf-8?B?VTVYZUlQNS8xQ3R5UHk4SWN4cDk4MWk0eklndGdrMnduYkF3cFp6empqMng0?=
 =?utf-8?B?OFZBa1dnZGVQMkExRlFwWnFIbHh0eUlOSHlxd3NPNTMvdVdQbEh4Z1c5MkhH?=
 =?utf-8?B?WVZodUY3Rm11M0RKaDV1cC93UEE0RXZXRndRUnZhd2xQZXc1VkZjT05LbGRU?=
 =?utf-8?B?RTh4N0pMOUNTZXBGV1kxeU5zTmJuZy9pMkxtNnBML0hxNXlLc0pWY1AxcHly?=
 =?utf-8?B?QVFRbFU4cHA0cXZpdnF5NlRUMW9iT29Jc2ZYNlFOb3RQMGVtT0RJVExZaGZB?=
 =?utf-8?B?S1BmMFBHM3hNWWVyUzdZUE1YcVFCRzBPRWxWbXljZVVieXlJSDluU2NRbCtG?=
 =?utf-8?B?S0Z0cDZ0T0Y5QmYxMGlBdkRudnhHNCtCT0orV2dZckxtZjR4NFkvYm0zUjY0?=
 =?utf-8?B?UERleWxnYTE1Tnpkdm5UOE5UeEVjaWhKVWlleXNJZ3FLZ05yQmlhRFExMFhR?=
 =?utf-8?B?WGIwMGZXakNNbVlVS3JUSG1pSDdNSWo1R0dQU0hSd3dFM3E0MkJSTjhrQ3Jm?=
 =?utf-8?B?MnZoQmJxMGFyWUZObEZZZlFvOWNaWElwSVVsRUxXQjNrTDlOdU5mQVVMck9N?=
 =?utf-8?B?WVdDTEhvUW1xMlh0MTRFdWFCV3dsS0kzazQrckxGVmdmd29xN01YREVhOTdY?=
 =?utf-8?B?SUx6bnlDRmwranFkRTJaRThhSkRUWlJ1N2JYU0V6WHJkclNJbXNuTDB3dUZl?=
 =?utf-8?B?RzkrZ3ZFeWQ3SVNHK09oQW1iR1U0TFRvN2dyS1FFYVRaK2orMGVNTnRBcU05?=
 =?utf-8?B?VUNnVW1vZE02SzF2QmRHM3B2Z29mN2xtQ0dJRVZQcWpuTi9Ub00rMGZlQUR4?=
 =?utf-8?B?RHZZWVA2SGVudWw0QlFBU0ZTNkZOam9QdWQ5L1pSNzJFendMZFU2OGNHQmpp?=
 =?utf-8?B?MVhaMU5KakRnREpNRnV6YXB1QW5NUzEvWm9yNnVtc2o4TGZTQU8xbnNRQXBi?=
 =?utf-8?B?MFIySjFNVFNoTjFtcFcvdldGRHl0REo1LzIybWtIQUtLdUlmckhSZmFMQm4w?=
 =?utf-8?B?aXlGb1N3Y3poSm5BNVNmaHFWY3FHdzZaQTVpai9ZS1V6cUgreWVrS2Jpa0lB?=
 =?utf-8?B?UFhXbXM1c2l1eG1PWVZtOHkreEhmd1BVTVBnZC9MVkpPUkFoZ2xwbWYza1do?=
 =?utf-8?B?K3gwSUg0emhxa3hIdy9DdGdXYzQyWVdMUmxuaTBJRTk2V0pPR3ZWeTdLVFdl?=
 =?utf-8?B?QkJjNGZObzNWTlZLN0hZQnBzcHJHaWtLMWlFMHkxNUwvNXd5TVBpQjJhK3Ix?=
 =?utf-8?B?U3ZBVzdFVWxCRmZDSFBKazI4a1JaNEJZUW9DWFdVYUQrcmZZc01JU2NyTGho?=
 =?utf-8?B?bVl2N3NvSmJ4aFVzcFRhcWwwZVA3a253K1MwY20xRmRwcnQweDBlb0tNWGhm?=
 =?utf-8?B?ZXJYOVFwRlNYbE5wRUQ0TWhDTStTVGZBSlhta2Q1TnFNbmQwNjZnWWNINW9u?=
 =?utf-8?B?SDQ1aXlsaVJQLzZHSXR2eXl0WWVGa1JuYnlnWFpvSVlyS2FBd2VqT1pwRytP?=
 =?utf-8?B?OU9CU0E1MjlYWEErSjZMSjFoR2Q3ZjVKOWoxcjZramY1M0Uwem1XNHRYOUtz?=
 =?utf-8?Q?4joEk5yKOvekmEvazLU008gr9k1Ettee5kCVz5RzFA+/W?=
X-MS-Exchange-AntiSpam-MessageData-1: 5tX7rALRKgJLOw==
X-Exchange-RoutingPolicyChecked:
	dX7Xda+EWW+lpot+Y7XK+gIftmV0v5Ue9Nzhd92pWUbzgftOfNu48v2/XZr7c9gOgIEx32EZkErpjcc+WK5qbY8g/8GHjpsSkLAtv+Ii+ZKWPXycdPQUxfW3I5ZzIwBrP4E5cXmJK0siEH5pv7azFIJsYE5NMOSWhUELTrqpJOP5KaadLlqH+zIVQLtKNC8eHHGgfYl7y85ZL+0l6X0IiYutKnxMmygpVSG4DihLD+OBR6OUr7Zz16GQ6Vt6SVhBkEykP+jBx0abqm5s2QWE2lxA0T9p7BU7/YFY2/Z31FMtrqrCrPkrPFc73f7XXnBai+0uosztnS0BLRF9/rolUg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6472580c-f1a4-4b9d-de39-08df141933aa
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7773.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 17:37:38.4822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5HUBdfwBGrUFSKph94dK9asUqlylM3Z+JN8D6yP8cyc76pxO94tdFXQCqfkG7so4q3ASeP0Sw0g8kVfbP8biQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PPF849DF23EC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI0MSBTYWx0ZWRfXyxrXMjLFhK+4
 umKwZfVK36UZDidaCmtujk60vtExc6mEnNUAeOgliXGgaBexb7z7O0kWvFI6+qw3b+pZKeXSfev
 o4rlJybXMiNY0ygjPf/5pntL58bv+yM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI0MSBTYWx0ZWRfXyq8vzOraojTB
 rbF3n8NKJXVJZv20WFZ84W8CFHEj0nlaQh5Ssk45AeLmzsDMHfMJU47g5xMlRqV8izAOu85q/Bv
 sS8ZPVGR/dEsfu2w4oI+TeUlVt98PDJOUS6OPEbkOrvWMfxS/6B7cl7C4qDIaOGjGz9oJG57Bih
 zGfVlQDQSO7Ti9CjhYUDoBD+0wEjcK4IjwqdxIGrBmMvtar6coN15jtEqhX15kOWdRSj2oZymCn
 jjhcNRFpvpFJGvBS1rwzOk1EGRI2xblJBMIDvaxK7h6b8OqitnQIAZ17OL6FepIyzDOxtcsL0Ao
 OQXqp3gMDGOadX3WfIZGJ+3F6oVE1yyHBkbclGH8NQQrWgRquvVSzv7i/VlkpKDaHdQPWIfr3yF
 tKtnIzpaiBA/Wavt1X8HzH3qrmi7Jb1+5+gMVSPj/7LeUocWjcEfIrh2CCQRrF4PIjvmTdKbCoy
 qnuh7q/5Md3T8wIKVgg==
X-Proofpoint-ORIG-GUID: mGwS7BPTqkrC9kQ9Pi3wT_snaq8OMOtO
X-Proofpoint-GUID: mGwS7BPTqkrC9kQ9Pi3wT_snaq8OMOtO
X-Authority-Analysis: v=2.4 cv=Hv7jiETS c=1 sm=1 tr=0 ts=6aaad3e4 cx=c_pps
 a=0c6nIVSIW9eNWsIgvcvAAQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=buQUfWhnF1OtDDk5FV7I:22 a=MZ-vaWmsU8g_eP1OPOoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160241

On Saturday 12 September 2026 06:47:55 Pacific Daylight Time Aamir Ahmed wr=
ote:
> wfx_hif_read_mib() copies reply->length bytes from the firmware
> response into the caller-provided buffer without checking that
> reply->length does not exceed val_len. A firmware response with
> a length field larger than expected overruns the caller buffer and
> reads past the end of the reply allocation.
>=20
> Replace the dead -ENOMEM check with an active validation that
> reply->length fits within val_len before the memcpy.
>=20
> Fixes: f95a29d40782 ("staging: wfx: add HIF commands helpers")
> Assisted-by: LLM

Usually, you have to specify the name of the tool and the model used. eg.:

    Assisted-by: Codex:GPT-5

[...]
> diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wirel=
ess/silabs/wfx/hif_tx.c
> index 9f403d275cb1..9efb108bd877 100644
> --- a/drivers/net/wireless/silabs/wfx/hif_tx.c
> +++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
> @@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_i=
d, u16 mib_id, void *val, si
>                 dev_warn(wdev->dev, "%s: confirmation mismatch request\n"=
, __func__);
>                 ret =3D -EIO;
>         }
> -       if (ret =3D=3D -ENOMEM)
> +       if (!ret && le16_to_cpu(reply->length) > val_len) {
>                 dev_err(wdev->dev, "buffer is too small to receive %s (%z=
u < %d)\n",
>                         wfx_get_mib_name(mib_id), val_len, le16_to_cpu(re=
ply->length));
> +               ret =3D -EIO;
> +       }
>         if (!ret)
>                 memcpy(val, &reply->mib_data, le16_to_cpu(reply->length))=
;
>         else
>=20
> base-commit: df2908090cda368b01ff43709f51890076c56157

Was this line generated by git-send-email?

--=20
J=C3=A9r=C3=B4me Pouiller


