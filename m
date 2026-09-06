Received: from mx0a-0024c301.pphosted.com (mx0a-0024c301.pphosted.com [148.163.149.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF80737A836;
	Sun,  6 Sep 2026 20:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.149.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788727751; cv=fail; b=n90IhalMGS+EGxgxId5dbI33lWYKY3MFkzqbzZERW/HBQ90PyMca/NeA4t7bzMsikZuYPHhwiXIF1mJeQgAzIngXotBOYqrPMKpnCBBZhWtv8Z/lSOHJNNQV0Ko9vTQD0j+Buo20pjItvAQnhbXrz+sV5Mz0qPUhVo7zlPnIjjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788727751; c=relaxed/simple;
	bh=VNfhr8bv89SCu/0mMa+Y1I4HNCAyTuLs+GplZbD/Rrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=klQWLgC5wI8T9enE+JP1LqN1l3ntATl0AeNEeiI3lNTZV1O2qrA3Dt+kGnjQPpzEs9+Y1mWuNpmVkrLDSqZcsidU/EqhE4QEmmp5Q0mQ43E0lPROU4vQqNBh1bchtQ4TnLGvQVloRW0IFbJrUXJRaIoFdRXqyMQqoyUk5pYaURc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com; spf=pass smtp.mailfrom=silabs.com; dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b=do37HNMq; dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b=OM1pX8Ya; arc=fail smtp.client-ip=148.163.149.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=silabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=silabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=silabs.com header.i=@silabs.com header.b="do37HNMq";
	dkim=pass (1024-bit key) header.d=silabs.com header.i=@silabs.com header.b="OM1pX8Ya"
Received: from pps.filterd (m0101743.ppops.net [127.0.0.1])
	by mx0a-0024c301.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KMDw83190266;
	Sun, 6 Sep 2026 15:48:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps12202023;
	 bh=VNfhr8bv89SCu/0mMa+Y1I4HNCAyTuLs+GplZbD/Rrc=; b=do37HNMq2vHi
	LufF2TU0EJX6hoR07PBYY9Rz/9Tzn/nn9hGratTMobp/Fx/4PwaFmABv9bw70960
	NY5ZAU2F44JX011Rcd4M5ZoOjaelGYw0IykJm+O+nKN6oaWwSqzpOnsgI50ue3Bh
	UO7jyCQ6E5R/XfgfSaahxSceyQimZjUqN/SJxykc6TEfe+Rp2vxQuSxmNQec68xv
	ZlEnJ2QXAFCk1gtvEfEZsY+4UNOnn1fWlyrGWLmxsJy7HtWX9XUz3b/hXw+g4NYa
	2Dj+uY89Z2zGd2L0SuVS7X1LMKIcsX66LmT+kqgVKy/6076CvIbWFkHFj7qsXz88
	11FApXLyWQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022124.outbound.protection.outlook.com [40.107.200.124])
	by mx0a-0024c301.pphosted.com (PPS) with ESMTPS id 4ggfd8hksp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 15:48:55 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpXTpI3ZJCSdQGo1XZrPJPNXhKbdjiKMSU686lkqBp/5B6VpGkWNTLTYfVTjG8yOyCKBugCp9pCRsZ3PsRJWxG1zArZcx+ZtZNjsvisaMvQbBpBqvgG0Ex9pf1jcyZHGSnlSjtCi2dzB8dqfbccMV6Fy+U+fgOmi9aS7QkEwxoPBWgJ2j46KVj8KF33JLkEQArdcrpbOARRcpmwhGquI5jmI0cOSOmJZwAX2haY8DeLUh3EGDHcUQX/QdphDFRSarjT0lV63ZuoNd2VXNrsh3WztF8CuyFsIT7hxzhGYsy6IkRk4WXdW0Qlfm2SpKSGzf/+J8QiprW5BzdHgTVVrHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNfhr8bv89SCu/0mMa+Y1I4HNCAyTuLs+GplZbD/Rrc=;
 b=JiV5lt455SqzP+24knHqQp0HkWE93u4U1mSJ/bInbDAwrTudwskeOuWdRFd8YFOTI4yuIQxqj43Nn5hKpZX66OkOWqhciNlbjKxRpI5l/v9L+STOa+NSXSK6MKUkcRq50NspqQ/57BQtBAOIgCp3aLinU7SL357NrC827t56jaX73shziUNuE9b/xiTIK6XXWGrmJzm58uVo/S26iIUkxHXhGcCsMEYOwKf34Mp9TpoYU6qBIDZQO1PSlruzK1BYTZMIjAgLp2fxLVEYKhQh4BRhwWbzRQQFydU1Xh+W1t2Ufc5BYPVdU4RsalR8+b5r/LDXygv2tjlcc2NV1t6M7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silabs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNfhr8bv89SCu/0mMa+Y1I4HNCAyTuLs+GplZbD/Rrc=;
 b=OM1pX8Yato2SOl96M9IRrSMHPlQnPskIjxggCc0dpJ7CiJGhwZswKYawvswZZtWcKJddxyyjMKEROXXNJ6MympgdCRzlmhbacbjqxNcmxSiw+cDdjldyGK/Pk0Ep1pcs1OosguoJWN0O6I/+R0lihoJi9eZE16W3uyP2ulkBDs8=
Received: from IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21)
 by SJ5PPF82E3BEA84.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::83b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 20:48:54 +0000
Received: from IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4]) by IA1PR11MB7773.namprd11.prod.outlook.com
 ([fe80::acd3:fd18:5809:64c4%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 20:48:54 +0000
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-devel@silabs.com,
        Alexander Sverdlin <alexander.sverdlin@siemens.com>,
        Lukas Stockmann <lukas.stockmann@siemens.com>,
        Gerard Salvatella <gerard.salvatella@siemens.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Subject: [PATCH wireless-next 2/2] wifi: wfx: fix error code on unsupported firmware
Date: Sun,  6 Sep 2026 22:47:29 +0200
Message-ID: <20260906204831.949692-3-jerome.pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 31ff9153-65d1-470f-b56b-08df0c58433e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|52116014|1800799024|4022899009|10067099003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	S0PRSp1KbFsLjHQ65xasVa23FiOtKwIBBwSU7Iik8ns1PjWx/VNtnSl56HCRBsmXZGsE311WQWEaOGXnTmKZH99rVjE8RBDOkwNrpdkz5aalBkpgeEHPin5X8EZBNlTRWAOZY3oOVUTxe6e8KBwE0bnLL/SBw1AG8yM5FqYt244+aUgC4Hgz8+p1bTl9IjaWZiiWPe8Em1WRWDrXTofj1WsmWQTfcsFnHBW4w4qGSwmEiN9HxDxUrE6Ao5XpjROI6IQmfS3rwkpluu34zX29EfZFidwdpXjLse4yALu84fW20P5t02Vuz6O03Me4mJh7SawphiTY9Jg4XVInlhv7p7yrHl8xtC30EAT0Rl6k3mFTmqjHLrgJMt/WAcwQ6U8yae7L1i0DPyiTmXi5RXRU6RkMemnG/CrKo8yAdQoZlng+bTO+wB4lCqVLITsck5apEG2qpz72jjjPECRdVdkifK9B5NUoRftoA79D9riELzKMOGSdzKtsz/oKTiv7hjDQc+z/4FZ7UWbcc1u5ofhE+t+mIAoZuRoGCiFJWx/K1I43y6PjxF+ihsEuRpljZjOf0hpxGjZiHnVT6JK9h2smsMR16oKVc4cmbUJsqOc9cBAfc7lHo37NQkJ7zZLU6RHsy3LiE66sHPKnG8HlpQHEoEiaVJwEsUm/LT2XKoKZmxw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7773.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(52116014)(1800799024)(4022899009)(10067099003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0hOc2VrRktyektuYlF5VnFzV200TkVadUZPTWNXWkIyWkgwdlNMMzY5cHQw?=
 =?utf-8?B?eGlnaERvTDlxU011OTNoRHVmSTQyVVYrNVR3cjdHSllZREFEWHlGYVcraHkz?=
 =?utf-8?B?VW5YU2lBLzA2WjlBVHllYWtsaUFhOHU5Vk9IdzRkbVc3YWNCaVFkT1ptNDEx?=
 =?utf-8?B?WGZnRm40Z2hBcENZdGxUM2VkTmY3c0hKYnJFTDBCVEplb0ptU2QwWnJBdXdF?=
 =?utf-8?B?MGlwZ2VjaE5rVzlDak1mOTc2blR3Y0JVazlaZStJdnpqRjZYbkZGMERna2c1?=
 =?utf-8?B?SU1CczR3NjhWRC9FNmlqL0dzZUZ0d05pZFFHWG1pU0ltTXFFR3hsbzdXWmM5?=
 =?utf-8?B?dHY5V2NIRklTT0xmVHVzZjRSU00xU3hPK2VETFpkMW5UUmFmeU1GRVJoeWto?=
 =?utf-8?B?dm8zQjRBcUcxelI4dmdCc2lxV2VNaXpScUsxV0lMMDZUMk51TjhHdkhvNzRU?=
 =?utf-8?B?OFlYOGlJNHVnR3d5dHd1QW1qMFNYaDZqeldFV1h3dDlCWjJpRGhaMXFMVGZN?=
 =?utf-8?B?MDFNaW56WDMyVDdtVWRjNlF2NHNVV29nMGpIOERrdGFJQkdPQjJxZ3pXeWY3?=
 =?utf-8?B?azMzSWFXUzd4UFJsUlY0d1FYeGJNaDRaVUgxZnhCWTU3QnQ4N2p0cVN4eGwy?=
 =?utf-8?B?ZGtSS0RYdC9TcThQaWliTVo4YjIyUUlqK0E0MjhlREVkZ1pPbkVkOXFiaFQw?=
 =?utf-8?B?Q29zUFd4Qk5GemVMYWpqSDhTK2NHU0srQUdscGVNOEx3VWI2NmhtY3ROZGVy?=
 =?utf-8?B?OUd5d2kwdkQ2Wk9haFVjbThTVFdNaUk3S2FuM0VYVVlDakRSYjI5ckR6a05C?=
 =?utf-8?B?UjJlMXJhWC9FMzJrYkMvck5RaEMrYm5QZzdmdWVSbS91MnYvMkFDbFRBeExr?=
 =?utf-8?B?b25PMGZwYzJVK0EzalhIOE1Dd0JpSTJrK0E5TmhpbkpBcTZtb3JEMVBXTldQ?=
 =?utf-8?B?WFo1RFBBb3dnUlVqZTExYWxsOFJJTHpwdEphM0ZmVEJWMG1BMEJDMzJ0cC9x?=
 =?utf-8?B?NlhQZENvc1VPUGxRK29HYk9ZajN2NFV2cjg0RmVUQkpOeVlBTXpTWGVOdHpp?=
 =?utf-8?B?bVB3RGRleEtWYTQwZENhaGZhejMwMTUzMFFLQkFKcGdFS2M2VFE0aXUyQWl4?=
 =?utf-8?B?Q2NBUGlHcVYxdzlSZTNKTVdiSjVDQ1crTldRVmV5ZjdFQXhDUEs0ZGo1am1F?=
 =?utf-8?B?d09tK1VLbnJsT0JFVThDcDJ3czNWRzE3aTFLR0tkb3RGb0I2ZjQwM1ZEQ09L?=
 =?utf-8?B?em5aSWZCTXM4MjV0a0xEbS96MG5wVklDb2NsNFBDZUF3VjhxVWM4L1JzTG5Z?=
 =?utf-8?B?Y2RMNEhjMnplYjgwTk1tWVNMSFJDSVIrb28vbEg1Qm0yR0w2aU5SRVpFRjNs?=
 =?utf-8?B?elZtTXpaaDE2NFdvUERDSGp3U3hpTmZOeG9MTXpLbU5OSU10YVlESFVqY0E1?=
 =?utf-8?B?TmZiYVozUGNvYzJudGc5cEZwZEJMUHByUU40UVh3Z1BrRG10bE1lSWhOK1NS?=
 =?utf-8?B?SldtYUdQWkppT2dDNW96bWdSKzl0czIxS3dzSm04RlU1S0REZU5XeCt0bStT?=
 =?utf-8?B?U3U4RGU4Ylo4WkEwVURtSnlEZGplNklLZmlhcURBV0xYVDdqTlE3SVB1bWRl?=
 =?utf-8?B?V3VSY2RCY0l6OWQrUlk2SDFza3Mrd0hIZnZVUkNhNXZKd0lxZFRNOUZ6Tm5R?=
 =?utf-8?B?aGdoUDc0d0VEN0FaS1k0UWpLNFc0bTRGVjFEancvR2JCU040N1FabnNTeVJC?=
 =?utf-8?B?cm5YT2s3YnZLVmk0RjVGcU9wek1NcE1qajd3R0FhYkZlbVhHSkJXTUVQb1Nx?=
 =?utf-8?B?Tks4MTczdnVaQXpmcUVlNXJDRTYrK3NMaG5oV1ZBMFF6NHhEVXVqcTRTM1I5?=
 =?utf-8?B?aGtLM0tNUXhyYWpOWGdPRXB6Wm9GZlFCRlJ5ZlM5UXdXbWlsd2x5R2tnbTB4?=
 =?utf-8?B?OTlmWS9ac3RKeGJ5eXlDd3JJREdIMjdlNFVNeVZhM3VJVkFNUjkvU29BaFNG?=
 =?utf-8?B?TkdyWXFjOWZiSlI5UmZlZDhSeUpHdUgxT0R0TUNMUFJxaDhGQksxTmowZ0dO?=
 =?utf-8?B?L1FOakxnYnRseWk2YXJnZ0w0UlFpbW81N0pGMG1Fcm9SaTYxRDlRUk1OdkZS?=
 =?utf-8?B?YXdjUDRZYlZyKzhLUThkZUVOdVczU29YdjJpQ1ZYdU5Bei9rc3R5eFFaLzdx?=
 =?utf-8?B?OXladHNuUU1iVDdCNWxYczJCY1hINVN4VHBhYXQyNlBIc055cDY4R3dtYnpZ?=
 =?utf-8?B?cjN4ajFVZmlCWjBuekthY2Q0d3FiZlp5b2hRb215Mjh4endFREVXNllmSkox?=
 =?utf-8?B?emNtN21WUEtEaWJvSnpUc2VrQnIycTA1S2IzTWRUdEV1RnllaVJORFB1TU1p?=
 =?utf-8?Q?fkco3oFZtJ+OgEw/XYsLgRm9N6yD3MEajF8Y7Y+zAPX0q?=
X-MS-Exchange-AntiSpam-MessageData-1: 3AFFt/uQmSBtjA==
X-Exchange-RoutingPolicyChecked:
	B/l/xcrGc/a9krHPMz079pUEU45JiR4y2pdQj2D2awUc4inZCsXoBZETg2RmOjJFpM7sYkwyg7DOc0t8sER/lFyoReu1/mb6Dpl/BPAfgb9sXUsSa3uqcfOae6YoZ2PFYqc1cPfTqr0Z5GJPBNaveTWAHxxQfEW2iTj1v9fJXnJcUJnOl1G/QCHUMCvPHBQDBAOK7/s3HJ0NzoSew7PcbcFy4KHCuUe8yLhVR0aFuWyaVM2MKOQ7XADIBmAFA8mfqhsF0+T5Ys6hQx80kkIQ96Uskb2R2f5i9ZfUOmPjpfj0vn20jkuYe1r5Ex37GiKDJYHyRFny2ro5z7ph2F986w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ff9153-65d1-470f-b56b-08df0c58433e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 20:48:54.0073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLVdeowHBTx3TTISsA7dgBox30Z5IvBNyznz/dzQZX+2tb14m0erIHRetwI/1Xlw5OFACGQ4RSaeiWlcJhR3gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF82E3BEA84
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX2pCeUrkm/jlt
 vpwSKuGvkLQqfd7JA1rNolkCS0VLTmUy0erzFS1t8G4BbgmH3xfcVP0iEGW2GqELWDK+jOlhEwL
 jJQ3Az+KFr7OyfvatCiI1Xk7dbbK3xI=
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a9dd1b7 cx=c_pps
 a=6kjKZ7CY8GAURWpkwvnN0g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=M51BFTxLslgA:10
 a=i1IsUcr2s-wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=gIHJBl62Mt9vjvfn7G3b:22
 a=6KgOrB_2K63Cyhqxo4vW:22 a=VwQbUJbxAAAA:8 a=a_U1oVfrAAAA:8 a=2AEO0YjSAAAA:8
 a=KQx4vqutiZ_VMMR5zXMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mfEdxtnoL2ClV70eUVOteWlozi7nB0kt
X-Proofpoint-GUID: mfEdxtnoL2ClV70eUVOteWlozi7nB0kt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDIzMyBTYWx0ZWRfX10mGzEd4PmHa
 Mrgi3RdoM0fCqgSeJoa6z3UJzpKsIeqrZmHzRsqC751xrsbIxcU61SyaI8bu6Fw3lCl5fNplF04
 GKyIc461ABsneojeq2goKRSvUMkd5lkC40A5Xu4nVVC0CZxtAQsbEQep+17u4JxSuvCWoSgFZns
 4MXDTqLxvqzXs3fVUzeuZoSw9NIxQRzRho2t+qSAoyzG9eqvprD4UB9AJK+oxAZLiZHoQZiPJ7g
 dosfODA1jyKyUowhbgEa1mKFeTVzSK9XoGz4tRv+Lbijuc/gq+jraiFTyX87r14RnIqk5gR/k/T
 nAAW6gWF1nnaOfmBMyA44lRbARipezmVJ50tD2uPbqpNBGbTj2inCH7xsfpU00liaECWpTnHL8t
 HMrQ0hUOVfHaI3ERSIk1sBdp+GQFReTDv7zUjj3Iugp5lRvoCV8UprBTiEGYVuYBbBwvns1lkAS
 oq4f6TgiXAn+y7XL2Kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-06_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060233

VGhlICdzZWN1cmUgbGluaycgZmVhdHVyZSBpcyBub3Qgc3VwcG9ydGVkIGJ5IHVwc3RyZWFtICh0
aGUgcmVmZXJlbmNlCmNvZGUgcmVsaWVzIG9uIG1iZWRUTFMgdG8gaW1wbGVtZW50IGl0LCB3aGlj
aCBpcyBub3QgYW4gb3B0aW9uIGZvciB0aGUKTGludXgga2VybmVsKS4KCklmIHRoZSBmaXJtd2Fy
ZSBlbmZvcmNlIHRoZSAnc2VjdXJlIGxpbmsnIGZlYXR1cmUsIHdmeF9wcm9iZSgpIGV4aXRzCmVh
cmx5LiBIb3dldmVyLCBlcnIgc3RpbGwgaG9sZHMgdGhlIHZhbHVlIHJldHVybmVkIGJ5IHRoZSBw
cmV2aW91cyBjYWxsCnRvIHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgpLCB3aGljaCBpcyB0
aGUgbnVtYmVyIG9mIGppZmZpZXMgbGVmdApiZWZvcmUgdGhlIHRpbWVvdXQsIGhlbmNlIHN0cmlj
dGx5IHBvc2l0aXZlICh0aGUgemVybyBjYXNlIGlzIGhhbmRsZWQKanVzdCBhYm92ZSkuCgp3Znhf
cHJvYmUoKSB0aGVyZWZvcmUgcmV0dXJucyBhIHBvc2l0aXZlIHZhbHVlLiBUaGUgYnVzIHByb2Jl
IGZ1bmN0aW9ucwpmb3J3YXJkIGl0IGFzLWlzIGFuZCB0aGUgZHJpdmVyIGNvcmUgbmVnYXRlcyBp
dCAoc2VlIHJlYWxseV9wcm9iZSgpKS4KVGhlIGRldmljZSBkb2VzIG5vdCBnZXQgYm91bmQsIHdo
aWNoIGlzIHRoZSBleHBlY3RlZCBvdXRjb21lLCBidXQgdGhlCnJlcG9ydGVkIGVycm9yIGNvZGUg
aXMgYSBtZWFuaW5nbGVzcyBuZWdhdGl2ZSBqaWZmaWVzIGNvdW50IGluc3RlYWQgb2YKYW4gZXJy
bm8uCgpSZXR1cm4gLUVPUE5PVFNVUFAsIGFzIGFscmVhZHkgZG9uZSBhIGZldyBsaW5lcyBhYm92
ZSB3aGVuIHRoZSBmaXJtd2FyZQpBUEkgdmVyc2lvbiBpcyBub3Qgc3VwcG9ydGVkLgoKQ29waWxv
dCByZXZpZXdlZCB0aGUgY29kZSBhbmQgd3JvdGUgc29tZSBwYXJ0cyBvZiB0aGUgbG9nLgoKUmVw
b3J0ZWQtYnk6IEFsZXhhbmRlciBTdmVyZGxpbiA8YWxleGFuZGVyLnN2ZXJkbGluQHNpZW1lbnMu
Y29tPgpDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9jYzRkZTRlNDBlM2NhNTBl
NzI4OGJlMmI5MDY3ODAyNTc2NTY3YzI1LmNhbWVsQHNpZW1lbnMuY29tLwpBc3Npc3RlZC1ieTog
Q29waWxvdDpjbGF1ZGUtb3B1cy01ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxh
YnMvd2Z4L21haW4uYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9tYWluLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L21haW4uYwppbmRleCBiNmZkOWQ0YzFmNWZjLi4xNmQ1
YjUxZjZmMDNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L21h
aW4uYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L21haW4uYwpAQCAtNDEx
LDYgKzQxMSw3IEBAIGludCB3ZnhfcHJvYmUoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAKIAlpZiAo
d2Rldi0+aHdfY2Fwcy5saW5rX21vZGUgPT0gU0VDX0xJTktfRU5GT1JDRUQpIHsKIAkJZGV2X2Vy
cih3ZGV2LT5kZXYsICJjaGlwIHJlcXVpcmUgc2VjdXJlX2xpbmssIGJ1dCBjYW4ndCBuZWdvdGlh
dGUgaXRcbiIpOworCQllcnIgPSAtRU9QTk9UU1VQUDsKIAkJZ290byBpcnFfdW5zdWJzY3JpYmU7
CiAJfQogCi0tIAoyLjQ3LjMKCg==
