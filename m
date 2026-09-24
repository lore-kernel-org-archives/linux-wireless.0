Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D634BEADC;
	Thu, 24 Sep 2026 09:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.183.31.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241309; cv=fail; b=DCGD8Xy4XcwlYahZTXGWBnvQmJfuN5LOyLe04KAw/3DfmxpamkIeVV4CKYjwGEAkdK51AtjaEDjRKl55fEu3DUGzRRnI2gBHUTmeU0w3Vbdtw28oRYS63ZKrkPtJxKoZdjH6UkzN8EdwKxJ3X0BPfWM9ETLYkVEL576UDdrtwTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241309; c=relaxed/simple;
	bh=BkFU0HxRbcL+Rl1peKNUc1mq8E+EUbqE7D814dOyIv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WynZhr6C6erSNoIq2iF607gf3NlYHBvUG7t0fIZpJllGt8NaVhvfF3K+7pXAkUGsvRO3lrf+Hc57ERu/QIk2ie/D0HmbVu/XG5dVsb4SVn2J7l6uLtrOX+ZmBt0S1hgwNkh9X+XPyzScxmgtD/D6mwcTWBzpJjUzETarPKh9lrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=o2TwHfuL; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=LHYmUnnH; arc=fail smtp.client-ip=185.183.31.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="o2TwHfuL";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="LHYmUnnH"
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O6cwTa3564536;
	Thu, 24 Sep 2026 11:14:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=270620241; bh=CCtpewpYnut83tB5LKOmXsfH
	IQF8/tZBBZfPGAHlqpY=; b=o2TwHfuL/k4gxXF7N7iOcgjXZFqCYb6tCzSksecj
	RRLqdMa3PzADJtzdWQg6QlYvQw4mvMUBkaOzGijgKPDkRlwZLSmUDV5pbHGQqSwS
	RO8V55zutJqzDPIEI4jHMNUAvsUSDJiL/NRCqwrmbum51J3vgOeEKq18tIOsfZAQ
	H9fbgZuSNEGp5tu46PRlloLgQExDOeuDoB2yZGMx32aPBGLaywy+CadxsudRoU1s
	1Zd92isCD0FpZQkl7hG31L4Uv6ReQOpEO0WmD8GZ1D0VShW7UnuwptZapnkT+Gj8
	z83GWrwVqUwsaHdh+QsOsBVAmChw2jaowSN0VlZByzIVUQ==
Received: from mrwpr03cu001.outbound.protection.outlook.com (mail-francesouthazon11021132.outbound.protection.outlook.com [40.107.130.132])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gsed1e2g9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:14:44 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=puT9/JuyUKiHJci7Ib/6ddnWRE3Je1g3r903kzr18MySl/aXpPtGzMnDD6ZeebxLxiQ7N8bR+QV/bBDGHyMLHC1U2yMTykyD/JdOB1VroGJGTBKt+SK9UHlNvmd55NZgWAKNFhAczmGCQ6eKRMxxfGzkUhxZGQ6ZlyUnX+ylApe97K3JCYoAj1q6LCQRP5LcPdftGxZBYLHPEZu60gFg5N5yuwj3hgHBwKAtL94/o5wJ5JsgfN8d29zf+3sUjJewd4oD4q91YvwvPXVHjdLlaz0SuEgIt0XTq6L2yzEb2GGJuFh5AuW5nTG9hvyWIDalnkKuvx7lABnlxFLSNO9NgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCtpewpYnut83tB5LKOmXsfHIQF8/tZBBZfPGAHlqpY=;
 b=YcF+WiwvxkJAsR18YbowMg7YwCT0tK+5wyj4iU/MJEC0j++HUYMfOF+tsei3q/q/87aqwhvCVawGlRldbeeK3PX6lm62+KzlWnApLsfkybgYQKxwrB4I2YC0whrexzMu+GlvSpDPho/4hDlLR9foGlmQMqmW1Kw0OIuUA9tzt51oYneNxcoc0NiCwCnJjL+qEyTR3HSjucRLGqgYeGI+YQ11PsoXT9ad/icrDt1M7oQXfhP6YCuslzL4OMZs6VcmGXpY5SqxBTRCIGR/WszFULqZMjc5du5DgcBA+1m9KsdLI/uDGAQKvr4Xqk9VNNG/MqbC4RtFoJuqB2h1OE5Puw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCtpewpYnut83tB5LKOmXsfHIQF8/tZBBZfPGAHlqpY=;
 b=LHYmUnnHWOVx3gwCWtvKh1Mk7Cs4eKj61q9iVJSVHgowIN/1vdIvpUZGuAiu48gxECipfu3DcmPWC7+OInPI/393/pDmyfqsjLYAkHz23m6J/eJ4UNq49QHTi793kan/MgdBOITt0i99l/hrcbhTggovWF8smUz2mLq3fbLv5bY=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by GVXP192MB1758.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:68::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 09:14:43 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0428.015; Thu, 24 Sep 2026
 09:14:43 +0000
Date: Thu, 24 Sep 2026 11:14:39 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: ath11k: release peer accounting on peer delete
 timeout
Message-ID: <arTp/9A0iMNpIhl2@mpf-ESPRIMO-P9012>
References: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
 <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d8307ee-e9bd-4538-92f8-b33410caecae@oss.qualcomm.com>
X-ClientProxiedBy: GVZP280CA0047.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:273::8) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|GVXP192MB1758:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c75bfe-3343-40a2-f335-08df1a1c450e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|4143699003|10067099003|56012099006|3023799007|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2lz9EAzzIQ/MGZkHfAu2EOZG/lAA55KZxEjGuAmbEWdIxxA1NUSn53K7x9Z+IwtmvSxxdwoL0QV0c/xPZxJeLMslg94RvRuYNkFZzGClTehk46O3aW+jW1snfM9evDf3wYNaPjLqfIJv4jab2/8ZAt3GDTQQqNRIGUor++USZEZi5REitS+U0ZwnbhfBO2sQ1x4xaAsVstCqS7LQnaNnFIXrTKer3apSRaL7R31wUecCXj1PegQPZ9UV6VpWPBjz9iVPP1I47HbvdPFzTkdIOc6yb0hIG8HLTJx0NhdMb6sSk/dl3wr1N/cN7Dea22d0laxaccuw4GK5jdvsDKpCPdBXeR1PsYFvy7J4BHy8AHaBxP+SGJwrue08rXtoAXt3BAcI1stfzH8RZ1ZqUx2vsBbNL91RBLes1r1fUsq3dN200k8Ew+O+TsSBf2tHIPfY2z3LIctblNX5rBESoHsiwQDQr6pt9rSOdRb/mx5X7oKS0VWFPBTdgfPuOPUxd/xACQYC9I4lyjoEliGZIAN0kV9jwK+79oZlFcZ4TCx1AXdYAk6LccS4qW7mGvwXzpc/8p4l4yCjBHBd2DHW+ea+nBjZWb1gKy9XPYMlelp2zUt5vI/+LZbLUl7b5AkW0olOfbIgbAq05fOU9knBhuOWKoPFGwCw68ivGU1xD2pseiw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(4143699003)(10067099003)(56012099006)(3023799007)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IUe5U05NSZNAFe4XKV/OILTIBh4TFBvDqOBqUvbEyiPIxsOvQ+rnhGBdVufj?=
 =?us-ascii?Q?CHq5T3ot8rtIp3brpdBug9HOtYs93HNWeUDyrWsRe2qZ1Y3PmBiXCRffvbMR?=
 =?us-ascii?Q?G1OPiPqjiUFmNtkTVZhhUbLKzODZcoHzOTmAM6Td05qrYGuYQMAVTX2YNTQK?=
 =?us-ascii?Q?NAQ80R/kiulqZhC2iqz1Ry1YlGYNmdYXnXQAX4HO4WUNe0ZjkAGCgPDo+ceY?=
 =?us-ascii?Q?avnkbz7cnmFeU2kdpgg48PIYS83st3eOFd8kSgKgcd8kJny+8jPn5anfKajR?=
 =?us-ascii?Q?p3cctwwV/Fwtggv8C8Mtvi7Dd2ZASJepTXLK0l9o+iUkRrV42pMqiQ/9XTw3?=
 =?us-ascii?Q?g7TWzS7TIvNza7+Vy5Ii7biyQGMw1YcJHU1WysVtooExPnO1ZRaHFnrwMxmb?=
 =?us-ascii?Q?flKD2fmy6sRFb/+tOnNzsMiXXMPoMQf9YFKVx2+u5R6Sqxu5rCrNyw15/a+c?=
 =?us-ascii?Q?3Q8hOdWNVfuptM/E7wsblbuVLM7BmiItNyKgcSm2zUF1rWbbx8uGj4xkHZTC?=
 =?us-ascii?Q?tK5YlsKFv2v8AdmbU9U08xMwtyYnY5Y4xdBFtdhLZj7x0FZjyhIjMciv+ZxG?=
 =?us-ascii?Q?y9slEq0c07Sn1BzDqiuK1DZno3Z6kIbapTb/HqqiE4mV2K1q9N/iq8wX4LnU?=
 =?us-ascii?Q?QgG13XqkR1oB5jUbud8xXfLtpNgndkH4E2odZVnmqEWZ+D5i5pxu/U68W6h1?=
 =?us-ascii?Q?sZcp70pyN1UC+HWQr1hC0N2pNWcDyvWSdR/RzPTgfjlC6KrLDlOPP7nAOd8I?=
 =?us-ascii?Q?QE0edzMfY+RZEUMaPVZIdcDJfkeLVTalXcK7lljuaeQZMiSegqXQQoS5ML3t?=
 =?us-ascii?Q?QdcccEtsttUhIc+PJVnfqefXj0rChFGooEsj34ArlwsBuB889RA0W6JDiRf0?=
 =?us-ascii?Q?3LT/w80ZIsQGdtGmHqsmjcPfYi2xThuagXCe2JCSbSkZCRsbAqY/0I5z2DAP?=
 =?us-ascii?Q?JYib+8t+Nq/QTL4iXEIik0SHinuYyJACyw4UX0nHmMssH4AkV8aFaN64dJoV?=
 =?us-ascii?Q?NHE86bmG//8euGKRsAcr0sNoVHhA02re+NnXUCaeN5lCv3ci3RdqBEoxRD7P?=
 =?us-ascii?Q?Lso4js3ywXRralcV2HEDUXPrEh8WdpkHE4KZx/jLQST83w2FKeU0ErZyQik6?=
 =?us-ascii?Q?lmQgSkmpAdtzGWgre8Cf5PlqHpAu4quUYYnFIH09jd49YYvhHSRCkIKyZ2Hd?=
 =?us-ascii?Q?u0u5OwrCJmf7wtOFRJ1QPTZjsKeTAASE1QGHkjtu+amDbyXwBVpfPYMH5yrq?=
 =?us-ascii?Q?enFkNu7xcEYFXdr3my3+2OK5NK8bPjy6HDwPP2fqJfCMAc0iL03XQNVcj+Kr?=
 =?us-ascii?Q?76dsv5TRA3G8F2AhoGcpywlrV+NFunHRwE0uxS7R8Dv1E/KfG0NQx0M8JEYP?=
 =?us-ascii?Q?qYHH8GUwHFGOWQ4JNCT8hyPXSNh+GjfHE8OqiBULhw+kETajimp8Lp2pzwBQ?=
 =?us-ascii?Q?EzSRxY18E4F8HPANZirSF8iQDWij4MTLw2S2m4yZgbYi+CikFGxylWfti1IJ?=
 =?us-ascii?Q?bqeUM7EytSQvktlFVAnFJMGQ3QKJAxbzxcHZGuFzdO1t821P0ruC6tV4N5TH?=
 =?us-ascii?Q?1IUER1Gm8vnLnwHCGYNQOMPXp+MRCjzZnG4062FpHTSwyYg9PHJiI7OB10GV?=
 =?us-ascii?Q?WM2AZ85H/kSi+XGB2GarS/KaMAAykNIqSoqQiG33cAbMFDluYoCrDsY+iI0/?=
 =?us-ascii?Q?KolaVNS6CzVgcBZlRBhMY6Sdl6mYLK2uD5spUmV2SzFopXkKJI2RHLIFPrxq?=
 =?us-ascii?Q?etNQ9DcSTQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	lBzOMyfhgGmtmUJp050OO2/rmkSNFfCoWsUl7Cc1PoaUUEBRCYZiagDaljpF4CXacAOho9uHL5FSOya/13azza3wuvKWgMEfOSLm+03i+jL8+pWAfRcGKoR43XYZetfa9QgoobJoTNhsVJK7iMwsxv6IdJv9ZNgxVDwM1ktr/LgUEOVWEEyM/ATejahZd2RO2D8bkkIgIFFtihOfUVmPiijLc3F24u4q3+YZnmQtT8eIkfCD8DkZsyLL/fybL46MCHpuChGGDHfEfZ7NlZ39pLFQv2Lk+ht6SEUabt0TYzP9RqzO87yoZ1XpVE16BtgGsHN82hT5lGYRPl1yLtGubw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	68JXIndwdfPtP70dFaDNt8epw3QdR4jkreqZnoBi5Y1tKA7LAl6Kit32j5yZ4namt6zu5ZCFZJMLCHdmIv5r0yeVKguJ4qpgF/Cy6ES1B2bk5YtcsM4bHYN1zDPWv+5TWuonDviEpYG+cj/fiuqYwAG1RD17tm2LcNc6xNKthPqXgyTHvJNKiZ7hNHu3iOOmyFQgdlSjacwAyAu1z+ZOzAzc4L/xH72pZACVyva0hLq9kDYbJ4V8qZUgND562g7A+IPvAfKzDgLLoCFKPkwMPaP0jS17Nqv7TZTfLQQbKYn//WCeWTkYjAOvJLj7P752rPc3YhHp2Cgvty1ohbhiKT9YrKo1aYVvZNfoM33Rw5gHRmbUbJghDEtBpDm+MTa5phM0dZJD0kL2ywza4HDrPRcyb8oeZiEGzTAzpQHl8evKI2uOGPuUW7DrluehThJObs8ZFbsbZuEOJVNC6nd4sLrcv9ZY7zz/nHC5Sfa930npuSwcbqnTEZXYKzD6WCs/xhsvGVHR6DonbdsNvr675jKoKoMuu+TnsT1iYjWKlZrq8YMbZ5PhDjy17FBPCUdf+SKXMqp9/U7VtLfromZdG6Ne6i2NnTgyagAQS0pE7z5PJrcIDtJ6eK4/nIAlbXtS
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c75bfe-3343-40a2-f335-08df1a1c450e
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 09:14:43.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmyDpV+S+SuUPX6k7Cf976p+0dXnUCCCqiFKuMJ58VrYeM0O3WADjoO/bJe3AE2yv6lxyOL2BeI5qLVhl07wmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXP192MB1758
X-MS-Exchange-CrossPremises-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC:
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 104.151.95.196
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext:
	DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: GVXP192MB1758.EURP192.PROD.OUTLOOK.COM
X-Proofpoint-GUID: Zv1jnfjJrNF3hh5joxnoJH_xNWFN2laH
X-Proofpoint-ORIG-GUID: Zv1jnfjJrNF3hh5joxnoJH_xNWFN2laH
X-Authority-Analysis: v=2.4 cv=RJomjIi+ c=1 sm=1 tr=0 ts=6ab4ea04 cx=c_pps
 a=hynW/gvL+xy5Em2YifiLNg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=WQ4YJ39tjzx_Hbm9pN5v:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=zE8YCpc9l94TdHmZPs0A:9 a=CjuIK1q_8ugA:10
 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX5UDB/rjWC12F
 fapOI7T7K0L8gvcWJ2hWZgxoAUhvgfkFiIN0dGR7EQ4Ch0dsoKz2C3tgdafCnPjiiDYGtSOBU7G
 NzMO8aCbOLaMK1+z5kelbHbEWHBQsjw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX+8ClX2kHqjKw
 W3kRTIMxS1x57MB6W0QBsuh1nTxRnljwXTsPsaR956FxPC3LXpjjGfAgEkDRE7KvDt4eoPK/P7K
 WwtQfJeuf6yb7URo1b1TpNaUr8xp5wmI/Cn0OGM9zO36HI0XOxlA0jp5ZV+Swx99ytlGvVQA6iZ
 qVTrIO7Z0mMRhE4lNRs8FoR5qRNYdCrQj4CqYM1yTvnIqHjrZrDSdjNIPibvasWEEzHPqXqeaRd
 CD9H/ycpKVVX/b/oMzLkUyBY5FpB5cfQqGYqSHbTf7Tv1+8tswGQ5SBTgA3lDgNbO7PIb3JvJSk
 YqrbP1cDUlRDf9iN8WmDmPW5KXsZq3Pwoe16SYTSPatnHTarmOB1AXN2fEGFy+UgNJzW19PcFii
 bqLf8M9NoHmJDuThx2Ljxz5GJjY/WC1AlRon9ARQHOzRQ4g2L0kkj0H+jjwsbypMSYYWVaMjS29
 Uu3i8sm+W5Ox+SpU1rg==

On some deployments access points intermittently stop accepting new
station associations after several hours of uptime with frequent
roaming/reconnects. The kernel logs

  ath11k_pci ....: failed to create peer due to insufficient peer entry resource in firmware

and hostapd reports "Could not add STA to kernel driver". A "wifi
down/up" (radio restart) on the affected radio restores service.

Despite the message text, this is not a firmware peer-table exhaustion.
The message is emitted by the driver-side gate in ath11k_peer_create():

	if (ar->num_peers > (ar->max_num_peers - 1))

i.e. the driver's own ar->num_peers accounting has leaked and reached
the ceiling. It is always preceded by a peer-delete that timed out:

  ath11k_pci ....: invalid vdev id in peer delete resp ev 1
  ath11k_pci ....: Timeout in receiving peer delete response
  ath11k_pci ....: failed to delete peer vdev_id .. addr .. ret -110

ath11k_peer_delete() only decrements ar->num_peers when
__ath11k_peer_delete() returns 0. On a delete timeout
__ath11k_peer_delete() returns -ETIMEDOUT, so the decrement is skipped
and one num_peers slot is leaked per event. After max_num_peers such
timeouts ath11k_peer_create() rejects every new station until the radio
is restarted.

In the observed case the peer-unmap event is received normally (there is
no "failed wait for peer deleted" log), so ath11k_peer_unmap_event() has
already removed the peer from ab->peers and freed it; only the num_peers
counter is left wrong. The delete-response completion is missed because
the response event is dropped in ath11k_peer_delete_resp_event() when
ath11k_mac_get_ar_by_vdev_id() cannot resolve the vdev ("invalid vdev id
in peer delete resp ev"), so ar->peer_delete_done is never signalled and
the second wait in ath11k_wait_for_peer_delete_done() times out.

Return success from __ath11k_peer_delete() on the timeout path so that
ath11k_peer_delete() releases the num_peers slot. As a safety net also
drop the local peer if it is still on the list; that only happens in the
other timeout case, where ath11k_wait_for_peer_deleted() itself timed out
and no unmap event removed the peer. The peer has already been removed
from the rhash earlier in __ath11k_peer_delete(), so only the list
removal and free remain, mirroring ath11k_peer_unmap_event(). A late
unmap event would then simply fail to find the peer id and log a harmless
warning instead of touching freed memory.

The problem was reproduced deterministically with an out-of-tree debug
patch that adds module parameters to force
ath11k_wait_for_peer_delete_done() to return -ETIMEDOUT and to cap
max_num_peers: after max_num_peers such deletes the AP permanently
rejects new stations, and with this change it keeps accepting them.

Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
---
v2:
 - Correct the root-cause description: the peer-unmap event is received
   normally, so the peer is already freed; only the num_peers counter
   leaks (Baochen Qiang).
 - Explain that the missed delete-response completion is due to the event
   being dropped on an unresolved vdev id, replacing the vague
   "misrouted" wording.
 - Rework the code comment and switch to netdev comment style.
 drivers/net/wireless/ath/ath11k/peer.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index b30a906..f93a8da 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -341,8 +341,21 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
 	}
 
 	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
-	if (ret)
-		return ret;
+	if (ret) {
+		/*
+		 * The delete timed out. The peer is normally already freed by
+		 * the unmap event; drop it here only if it is still on the
+		 * list. Either way return success so that ath11k_peer_delete()
+		 * releases the num_peers slot instead of leaking it.
+		 */
+		spin_lock_bh(&ab->base_lock);
+		peer = ath11k_peer_find(ab, vdev_id, addr);
+		if (peer) {
+			list_del(&peer->list);
+			kfree(peer);
+		}
+		spin_unlock_bh(&ab->base_lock);
+	}
 
 	return 0;
 }
-- 
2.34.1

