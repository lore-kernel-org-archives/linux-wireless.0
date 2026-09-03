Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088934FDE71
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 18:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458754; cv=fail; b=OZ3usevHvnntR3mjwZM+mr8iMARcK7O4Dqg+fIRyVBdG31oXABAUq+YbqjsyJJN4imhLPhz714vLhd48BAet34KX6GtsPTiJUTgb6d3iq4BdvPe05GzmO1TZT/cuBbCdG5+Y3lh4gD2aZsKWa21defhNUXSecXAsdsOCdOGt8co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458754; c=relaxed/simple;
	bh=DGBOSFl2xyAsAQkEqbTFqQu0fQLMtpqnJ0KWRxcYzc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aJLETVJ1TLMPCSQ5k5m+Q5XgepGZsQi9/IErJWB0Y8Fi8n+4gNQSQ795a4m3HzdOG9qKmbcpzZ9QBzpeV92WzQY+Wsy6tFgws+mCesg+vINhL49nCoMg7cJQYNiHw2Y62IM16PrJR/IIxNwb8fKp3qdxi0SqGjTrcWHVe/755WU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=cn8FYIZR; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Lszjsv9q; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="cn8FYIZR";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Lszjsv9q"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 683G0kRl1342932;
	Thu, 3 Sep 2026 13:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=DGBOSFl2xyAsAQkEqbTFqQu0fQLMtpqnJ0KWRxcYz
	c0=; b=cn8FYIZRoKRn0qdzdPDo2BMUswyY0TApPDK8ZdIsWqUMdsPskK1icyLC+
	4spi9mhllQ/vKjuQaFZ7uwHnalmr4POF+rIg1gC3foCBVSHqcuGmz2DqutwLkRXy
	iVYh8g9H8uuiswKQK1bmtZU5bSm+w6ue7tbQMJhGygz/z3KlwPkaLf2E92KwOtKg
	rmlLObw3sL3d57cMVG4GGRi9u3UY+Wjj4oZrDMwktaoxhJSqH4+tvhMlgNkwmrjf
	/C5bbevOf/QLLQ9iYVdd9ANbA1nBu5uB0U74toSqLNJR809IhwemYs4WiIMmEf5U
	0qUrpWZWOA2EdEQF74aMZNGThR4Iw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010016.outbound.protection.outlook.com [52.101.201.16])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gewt8p4cu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 13:05:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBZ0pfPbB/3aJEu+2HTminDfTuKflrZRuaTGuhJNBLLrPwyheAXBQETG7y85zE+zyMcn2+n1GjskwqMporUrUTdiYv5oI1QWoOJ1b5IveLDZ7IcXbzFp9gSqe55RhXSLHVxyQTGs5cVelj2PKs7EoibLqdWbtd5vV4ppUT7UR6qxCQRYaNzOdTD/8LTG4hgln1bkint8ruiJWbZrVtJlkfnUiZgTp7L8JERh9Khp5MZwOFlLmjBwGmRowjhPbkJ/9cjJBekD2+iVO0NTXiGJEU0gBpG99BhT2VcDK1PSG7SCEfajwQLipzgr3YD+jb0kzfvjpnxMfURxypZc5KjmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGBOSFl2xyAsAQkEqbTFqQu0fQLMtpqnJ0KWRxcYzc0=;
 b=jXth0JUBoZ640sNNWaEMPiVP6803pLgc7FO6rQyz9mkTB/x2/75f+yf//bmMaumd57O4fXJBUZPoJ7CVytxr7rAx09DZbjniEoWlLeyxRSxW8WG2FP+yBAx0XQWq3+dob0RJWX4MrXucLqyxERKhcrQ9YULPmruPOmQBs5TEl/FqEuyGlz6jzkByGq5SnHLdT207FI7f4BzzIcroMqr7Ul/D/aC2JD3t7fsZeh12CodTGawkhkDVuBIPVdIMBXSXEWQhnPGJbLnqFpjD2nyfG/Uz8GVhcdUqDV9aTPteBzVp6akhC+PLASfE0EmdURUmRxzHGfwM89jl9Wx+Nh+4EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGBOSFl2xyAsAQkEqbTFqQu0fQLMtpqnJ0KWRxcYzc0=;
 b=Lszjsv9qOyGoWRvXJKtbqLjck0owL4DD5fQNIFovdpDiqfG0MsQpbtCArIn+mmo2Icq/YN80SWb1OHbmK/TLydjZhpeAI33Jv/t399W2WtJExxjcJHJdWLsZLT2RFz+hpfRcuB+EYIY/WCHi7e2F+c+6wwLZx/ZJNw72QpIbglU=
Received: from SJ0PR13CA0217.namprd13.prod.outlook.com (2603:10b6:a03:2c1::12)
 by SJ0PR10MB5767.namprd10.prod.outlook.com (2603:10b6:a03:3ef::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 18:05:42 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::2) by SJ0PR13CA0217.outlook.office365.com
 (2603:10b6:a03:2c1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 18:05:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 18:05:42 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 3 Sep
 2026 13:05:28 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 3 Sep
 2026 13:05:28 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 3 Sep 2026 13:05:28 -0500
Received: from [10.249.40.13] ([10.249.40.13])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 683I5Se23027475;
	Thu, 3 Sep 2026 13:05:28 -0500
Message-ID: <ce8278bf-ca96-4c8e-a22f-e8c0f7f865ef@ti.com>
Date: Thu, 3 Sep 2026 13:05:28 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mac80211: mlme: allow VHT/HE connections for 20MHz
 BW STAs
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20260828182501.1540352-1-sabeeh-khan@ti.com>
 <603ff8bf1e9dca88a70ad95ff4ad1b185bd54583.camel@sipsolutions.net>
Content-Language: en-US
From: "Khan, Sabeeh" <sabeeh-khan@ti.com>
In-Reply-To: <603ff8bf1e9dca88a70ad95ff4ad1b185bd54583.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|SJ0PR10MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa50ba4-3f00-4536-1dd3-08df09e5f82f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|18002099003|22082099003|13003099007|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	EKVB0ODkO17TqYDUzRX4QZhU46Ar6b5odM2JxGwDFNiOA/EFYgYv9z1podLzQdGEysQYvOVTFx6t3gPQqp4DzuwLdzi/NZBBEU5Az3h7pAUv5dhlEp8BTmwZjvTd204540cKtG4bI+2GJV1/vZ5vEgW4BA2LiH50h8t0ueiaYP0bx5+GNSaOcd3SIsDlPPn1aXuZdjZoHt8rPwESlYLq2UtmqNTuDl+HGMhNytRzaszUrSyZ+QptT/bBcrwHlk5QRmrwxPwn0V3xcfbs9UmbhU3eh7CkFTxTrpqAhWKEdgy6Jsa0EkzoIQElaMldcYh4nT/RdMLBkVXlxR3rlRQDG2OsU1KpqGlJYH1uob7KRVksqlz5eS1WCyJIB1lU2rCjHGL1N01JFs4R94hPea1vQNx+yGRc4axb/IPmkk553JSbEXBkpa2UBADWnl2l4oUfpACUjP9dzqtYjvQNKdjPNyncbBJfT/8tBBGCJazFT/FdngJUTWwkzbpPxoVM57kORMWd2oLgxDl9osuG0m2O9WvCNlrD53LqvvTShkUIFhr85WuPdPp96cV9EpE3/2kk6WqN5wEJuuPDyqQ4GIjpwC7ejIWSm70I02JvBzxBG/1ROtfTEeh+51/eBiCKHXflzBzBSd7FEeszfz/NYV5Mcw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(13003099007)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	apMPaXm1jw/+jD7MAMYB13522cYAw1Wyrvc2DXBPhjGiFOG7I8unzrvL7mL0GBqTD1zMw6245OqGp46RvvHLIOkZPUzWGMt6Cg6r93eB/tHQ2EyMlMr0taPobDLO1YYQBkX0UG9TrFLRSML8ZrDtZfqcfHs7nHzHJHptpLpK/iHdleInPCw2JnL/WyH4GHYStAWL/YnhoSDjgytei9jcIuVJFoVt+Tm3I46OR9raI4MIKFWAx381njLauC0cQlJPKeyv+idL66Q8XB4FGpfZGXN1EVwUTKq1bvWiT4NiXUZG3ZazaMBXTsqrkkuL6qzxeXRXlc4nr8Rh98epoWoIyNqLCNAMgMssUsnfi8L37WuBm9Vf9D9OQifxrrLXxYT2rqo1wW3hdU9lzek2ytX6k+LnuCXnJGEhFHvnd0nk7fGYkf5/hUJGVHnGdObDLaAW
X-Exchange-RoutingPolicyChecked:
	gvZn6gv4IR2ErRSCl8E4iTHXu1CTVmhH3y29XCDprW/3G53KTZSDOMF+UVJWaW5mJk0oZQIXUvlq+uK7g1zRC/yNk6ebm94cetT3Z2nvLleW7kmeAR+JnUvv5oAH2m0QoMrXKE9UJKHX4q56PUBhAzziOFL0uFhiijz4LBkTbeGf014EHnHZMrt9x19NyKcsU/Fw1t9QTXz2ypkfMbeAtnts/46K4vGPsEoKi43B9tdASf5X/pnp1MDmO3pgHQ9fI294oHZYbcz+z/Zw5SlLdLOAAw4eUl/gzbHuO1CeggPsMYwemovmD72A+5anclNAEGCQpH31Bb5KAadebjpy3Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 18:05:42.4580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa50ba4-3f00-4536-1dd3-08df09e5f82f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5767
X-Authority-Analysis: v=2.4 cv=de+wG3Xe c=1 sm=1 tr=0 ts=6a99b6fc cx=c_pps
 a=3r3V3iWCG03xnAr+XYP7tA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=stkexhm8AAAA:8
 a=IRcuNhEYU_dp-6NqAB8A:9 a=QEXdDO2ut3YA:10 a=pIW3pCRaVxJDc-hWtpF8:22
X-Proofpoint-ORIG-GUID: IKrsy_uQL-nmNjM8l3RpjRDnIwPZsAL7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE1OCBTYWx0ZWRfXx32ayNKvQbbD
 76xG6u1bxpR9FCndt/3nnzCrKs0Sqe4rV6Ii3alf6VmoCG6eU4Teo18whpDeISA+gqw6NJMpi7e
 So4j9QXJNJdvALxNdZrUxvldJsRPeWI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE1OCBTYWx0ZWRfXxz9AWaJxr4vr
 p24oDNFyxgSu8yaE55Abj8wPLE9vsvQ5VUMniG0Pj+j+K0c2whPhjvrQ66jmmEB88Ket6fpWaGx
 9mZn1IGaoTyxPhzgKe2BMor+DsrgVrTn/Kesxb183wOZX5oW93F58exXbgqlUsrx4zpzrv8TUqH
 Sn2DEmPQ2pSmp0MJsHaJIVu2JYBhDjO7E+9J0cBbBp6tJFpxe/Lsx+mvS7Lc4Q6bCYUGfPNmsqH
 fZEV+rozz8ZgzIwOMwS5W0AnNldKXCRvYGwAS+B+o2ZCDn9qdAZ/ndwe4iXzCkYXeI4GAWe9lzf
 ZS1MPNbDBxigukvu7WgApUo7fyOyG7Zt3NEaqOmNpChzifmm+PoiDYBtwLgVDFdCDHFosXQgckn
 90ymGHar4YSuvZHJbGwtYigne6tMbriACnNUstldPH38Z+zHXt5VOhsYaQX7eSLqW40tfEpW92p
 9f6LuNWBmDSJW0ySMqg==
X-Proofpoint-GUID: IKrsy_uQL-nmNjM8l3RpjRDnIwPZsAL7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030158



On 9/3/2026 12:05 PM, Johannes Berg wrote:
> On Fri, 2026-08-28 at 13:25 -0500, Sabeeh Khan wrote:
>> The ieee80211_determine_our_sta_mode function assumes that
>> if a radio supports VHT and is limited to 20MHz BW,
>> then it must be limited to use HT connection.
>>
>> This is incorrect by spec as VHT/HE connections can still
>> be allowed.
> ... Which already says why your patch is incorrect.
>
> I have a real patch for this issue somewhere though, like this:
> https://p.sipsolutions.net/a5d970acf354f0ef.txt
>
> We/I should send it soon.
>
> johannes
Thank you for the review Johannes, and I will wait for your patch.
