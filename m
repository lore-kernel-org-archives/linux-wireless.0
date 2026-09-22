Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49983E1203;
	Tue, 22 Sep 2026 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.184.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790079978; cv=fail; b=GxZwXpv+252QelPMjQWC7/p0ijjeHl4rj6Ld1d6+D8h7aIdXoTjDEMpgOmUQTN1giFkNo1J/zgRv2W7Dt9Y99SNSf4mcKwZJQErwzfQIqMytwIXIWJ4WFYgF/uPaEsqdGIS1vPGpy6UzZdZ51O2F4vN/w42G0WxGnPoLOtpHPPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790079978; c=relaxed/simple;
	bh=KB0NEjm5hPz/3KMthr9BiL+xetGOmX7HaKZhwUWbXF8=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=tcT7ax/9j0jEzNOndH8JMKJEPdJ7ShC9dLGsEFbPH07lp1OX91Z030eRShggwqzRj+CWhaztoTk0KqNRQdjNz6PFFowHsH0VRdveTqqZi16SY5n0Z/8kigR3/Dp634SvKiLN3NnvC5k/PEbvAqCZvOfwntkYp38TatRn/eZjwm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com; spf=pass smtp.mailfrom=westermo.com; dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b=u6SIOdW4; dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b=OBcjT6sk; arc=fail smtp.client-ip=205.220.184.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=westermo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=westermo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=westermo.com header.i=@westermo.com header.b="u6SIOdW4";
	dkim=pass (1024-bit key) header.d=beijerelectronicsab.onmicrosoft.com header.i=@beijerelectronicsab.onmicrosoft.com header.b="OBcjT6sk"
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
	by mx07-0057a101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBOA8n2536249;
	Tue, 22 Sep 2026 14:25:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=
	cc:content-type:date:from:message-id:mime-version:subject:to; s=
	270620241; bh=m6D2BYNvDcE2EIrqeKWs03kYcf1uGCwyKliILMndZPg=; b=u6
	SIOdW4Ti4YQhAYJwLIiXNygHgRYjK7miEf59ZsU9lsTVA7HOQkbWs14taUAO3IUV
	2JWkJcxROEN6WasC+ieJLJ7yXyi5LQ37uTmOLf7vwQeSWnKPN5pXgZaSMf5rahse
	Vg+t3T4w5iNsnazReMW68mHhxkmpo20JlDqSXppcL7LxExFk8m85X2EOcx0LuOxX
	yrYxXeQT/FBcoxhrjLsJixxx/cuFtiFe6+sSWLgxWPdQw5rczipIe67FNJVycKdD
	3GYPykisXfbMWHsFKKg0cNHcp5sZqnRmW/2Aah3iu8dwVWAi40azq7LceimxQ7SU
	+vG3HJbiZmXrMD2+Nt/g==
Received: from am0pr83cu005.outbound.protection.outlook.com (mail-westeuropeazon11020130.outbound.protection.outlook.com [52.101.69.130])
	by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 4gurs1r282-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 14:25:53 +0200 (MEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPvKfOok2DX4N0ujGV+nIH+QJUVUip8YECJQy+bH9WvdNggnvJSdfolATgrYb34TiF9JWv/t614FMY8hK2WMUe8WcAa7ZgbHV8GCSlu0RmetE6geLx+zdIvHC1GJr0YZ2x/9E1zBb3CDLofW65RQjtgCfYZEu2/M983ufQi4g2xPrZd1232Nb2dZdujNVDSzK+pmERs7K5Keg41LtUtfrb8ZIvjRYX9LQc+Wlu+6BQyrEx22muOJs3WwB8GVyylgWAiXRo0YNfIxSp6UiNel2IHNN1OyTR7xQiLfuqIHOH9ccwlHSWrZxTDUGGei3jZ9Zj3jn8WhmmkVktjkvN2oEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6D2BYNvDcE2EIrqeKWs03kYcf1uGCwyKliILMndZPg=;
 b=Vf+XXKfoLahoWm32aZqaZ3m4BAtMYqRuX9UQ8QsI55UjVAFNj0R/glmf/akF4c2ClcWbuywxfgfqtvL51/htY+98laskVTAnIhYmg4ZMJ95/EDCJ5UyqvNQQPdTtg6gqBEP21yLXqfQPaYMD6txFPAMlzdFeRH9Mg4QQcA9CqzOMevtHGSZ4H1WwuJ88XCLQAUHCsuIP7oThnalPdOhoQSWYxjLdTf7wQLCLgQ2cx3KYbQ/FoXeMAGeSXuAXxYwsJB5D7QtYIyU7ASW71oU4wwr5c6RK3CJqHHCgQjq2g+DETVbbDjl9LaoXjExK5w7F7pQ/vsZf6FCb1lSBx6DfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6D2BYNvDcE2EIrqeKWs03kYcf1uGCwyKliILMndZPg=;
 b=OBcjT6skIWl415YqSOtjBn4+KekaAEmD2YLHcqJ4y/qPcLi6ptmElT4RXDNJz26sDxtdjRdZAe5IX0FVXEOV9nKS3xUpLE63oSKvLuLQ+73vLVvwsiVcb76TOy2F7Y85zJiJVaR4ZU4MyaTsAm/RzR4Usy6ILSBgXXu4XTcGErU=
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4d7::12)
 by GV4P192MB3213.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 12:25:49 +0000
Received: from PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce]) by PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 ([fe80::bd96:8c85:982d:19ce%4]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 12:25:49 +0000
Date: Tue, 22 Sep 2026 14:25:41 +0200
From: Michael Pfeifroth <micpf@westermo.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath11k: release peer accounting on peer delete timeout
Message-ID: <arJzxQcf4intXBqS@mpf-ESPRIMO-P9012>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: BE1P281CA0187.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::6) To PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:4d7::12)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3P192MB2868:EE_|GV4P192MB3213:EE_
X-MS-Office365-Filtering-Correlation-Id: c088df32-0403-438f-de5d-08df18a4a29e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|18002099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jnHXy4YSLC6umqk8vQniC6zaBUyIzi3ZDC0r/C7EwF3qFUccmqbExCqsmup6vvJ9djVjHwWCN+3MeNQYv/69bwuXQDRoGZrvv9LKsUR9UPDzjWkr419sJ7TuHpsgysfOWN8TjSPzWDCClXwK6/IziGk8Xj1ReV52VWn7gFokthVV5kLPnqa5aZm4MIsgQ3L0zH7jTXA1NzO2A2fpsxzNREYCS0X6JUmtWMwTTaO//bsWl2OyIyIBF6LMFqqUOcPHo39380+lzkeXC0SoR9lwETVvXywZN4ZeL0H5zcKFjyqqh1YMqOp2fubOrw/He0tcsB4gpXOSq0we8vgbz2Fw7ZpksyI6M4T3LPNnNH54NrIXsvjwzF6EbTu8YBKn/UCrv0um4Lr3EF/gbnKDL7uFgk31XI1TisXhgq71P077GGFvf3fFWGXKP0wBfzb6U1O33uAB+WSN7nOo8lqjeEebDdamwtdTwQZ10N0TXWfxEbwdOsDslq6iY4+RdHCkyf3e2F7/bT/SgkR3UR4iSoYiRrccmuzpldxGH1JvSxxkdGdGV8c+kgw1yyuyW6aDSsxH/6XtVvvHKrHnrhmP8/fnCOELuW/HmBX3koxo2TyUlBo8HtCmuDl8PcEIZ2FsXa9FY6YPtKUur3nTcvb51DqOJkOkYufNni61nWvXjPFN1FM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3P192MB2868.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(18002099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?04hQ4RTrat7i8xBNQ7WuNMpt+4Wozvuk5V7DzvTOcIgOlZsIDbvi3dONl8Is?=
 =?us-ascii?Q?bIQlYO6EyW/rZbgpM7n1f7lu9ITdBcclsrG/I4Y/lKTipRZW7LhIGtegpJa2?=
 =?us-ascii?Q?YTnbM/urYjvwZN+/z3nSxi+vU8QB64Z0Z7Cw0WQKelxE8PpJZxb6pWxQDCjT?=
 =?us-ascii?Q?0bdVsIJ6opCiy4cxpTYpHivpfXZl2o+ZKob3JyjpMnhhVmzut+PWMd5drE+v?=
 =?us-ascii?Q?9imR+cFwz/xVW0YlnkCBti7zDekT6FNKNDiVXerQAZqgt+tXz3SVn09B7+Sc?=
 =?us-ascii?Q?HrP/w+adifJuN6pjv+Ri3DH1kJwOG6FRpNFu++XxCysyE+eLda2fePHXCUhg?=
 =?us-ascii?Q?nGkk9uEbcikad9nWO9ZNbraH81e4sqM39P/CfnCkLiQDqeRwACr1xxrgzSIv?=
 =?us-ascii?Q?5ncNVxHyl3FJSKxrQb88ThDkucktTwXB23dR8d6OgwqjL6X70zlymoQt0dON?=
 =?us-ascii?Q?ALmFDN+J1CXTX8Xx8lfXRUpOn/CuZLbFtO6sdzUHJr2NqfWT35d6bsx3128z?=
 =?us-ascii?Q?PaUOfHXmLJPlUVv51+ga/7DYHmHOfHA1co3YSbmnvu5o7/hO50c7mLzNns2f?=
 =?us-ascii?Q?gXRQ4q+fPWfREQ69qAHEFc2gBaGtxa/oYlrKKaDnav7YeAXXlDoUjKMrDjBk?=
 =?us-ascii?Q?4g7lQ0QPUUdUXbzvo6E8em4S3GOR0dxWX5/Wvup6WyYXemQ1C2VL8BRnMUv1?=
 =?us-ascii?Q?mfdeXMtDIfSRU2Hu/irsLEOgK+oYEWxbTfoK40UP8+6FBYrlEN+S8hv4N+59?=
 =?us-ascii?Q?VeswPJ34ae5lfvCmSRwAy96uE4EKZQ/heYenXX7c1cPJfdozYSpQvfi/oVwl?=
 =?us-ascii?Q?O3k9Pe9aFYIPLVRr4/78+98UrRt51eVkLaspVFMRv09lS+iMX9bCBM34DSTE?=
 =?us-ascii?Q?P5EyEEv9DoMaeQypuoRbNkgq7DE4EVfIDZvQxHiVDDOd+o8dzQmG7tkWCT2o?=
 =?us-ascii?Q?YvfMyVw/CsOurMhrJ+JUs6ZIONR9YnEco5Ku11kG5JyQsdJIilpm3VxzNIIQ?=
 =?us-ascii?Q?5RJ29y8I7YMYLuIBpsh5W4Y3o+rJYTMYUR6LCDwvULxnPbVIEefwXDoFH3tk?=
 =?us-ascii?Q?ocYFEsS24syjUdP+js+VL6/7Kkd/7c6iKVUZ5q2OHPtkC4oI5+qhCTZw3VUe?=
 =?us-ascii?Q?9gZblwrQop89V9dJtwK4l3nearKAKOfNvxokHpjQG0ij3nwV5a9tCnznBpT2?=
 =?us-ascii?Q?pbvMDNTmRMu9VSn1bdvNOiAiPzpcCnLCpKgI2m2XgNxfs4wszbO4xidzR1g5?=
 =?us-ascii?Q?/DxNMaRVNqhSTayAVw47lJJNAyTUu7Nc/8WJLfJsgC0MNSELCf/gCItcL8ak?=
 =?us-ascii?Q?lfrzJzDmq0vqYlqMROpuSJgUW6D0xFYTdyFiT0gviO3dXwhUSRUfx4bHBYWl?=
 =?us-ascii?Q?ehiLwj6lGMHvZtCcTgOnENJ+P7VTzdXlAOc710d1ZP5gz77IEPo16RnM9bsd?=
 =?us-ascii?Q?Ws8IRG4mDKXLmW1w2sE/2CJoi6QEEQDHHahC/CYWwNpKg5YMBob4GF4uXpEi?=
 =?us-ascii?Q?GL+0q8ca1GZaAG7pWHZQcvDzHHjOjgouCCJU/F7rTaVW5c12v66aYVL95Vih?=
 =?us-ascii?Q?tTwlyTn7ciYqDjkFDKIGOMPldbvQdC9gKABjNYu5NbUw/UzSzXxel3X0bYAL?=
 =?us-ascii?Q?okHbXSwsQ/szmdZcR8tTPyY5/ah9Q0NdKz1lxSO22XngmSfVg5eeWUxCuYs8?=
 =?us-ascii?Q?NgmQ64vQGnrWdXLq6/h2q/5WUfulgBM1+RJBVA0ChYFxnH/XG2QSXkWiQS5b?=
 =?us-ascii?Q?X6qlr2G76w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	VbJw0Wlmm6x8Qa2Wj2cU7IQY/AD+aaVgaXAtIsVy2k6nlBSkEZKghNjqT6iXxT5l9pWND/3uAdsMid0lt9PA8Ab5unqCPj/egTeDw77J+PFVGTQ93AO4RZ4XtxYenROWYugZJHKug2nQngnd2Jo9aYyQArsCgSLQUQeSTIwYYgZuENddDoHmdwKKPuq4MKsPpxNN4mcO4V5bl/feu+LSYDeKNXM7vJsLy2Lamrmk8RJ/XId1Eq4Mj8bKAet26tTRye2PLHip8ZLb40Z7aWRzpeBMoerwLALPitJ3Q7h2DpINU+BlBRXZ9I/xPOpZ28sqb+uC4S5kK3/E55EbQu9RHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ui98tLAIbfabTo0DRq41SXy6184GQpik/85wPKXZxV/ZkJcVBcnEL6OAeA9J8h1QFnsDmYjaI0CkhHbcXeWmb5LsFiHvmvvhkURnypfOFFIJzlmIJiZGxEFGo9FmNXZCgMsrqTBpci9T5O+TvgqNT3eHl8zaPqDFo3FhEeZcZ75rJgTGROWZELIOpa34bedbQrUNusHE6fcmIGl/nFoXh5WmHXTmGT10FoZxkRPWEs56EcmD9q/VZd2VsQ9ddVog2HZA7reU4E8uu3g1g8VPl9ry4L0d3w2YTrgTFqigvvrOkLcQStMTtZp5iXi3DC3QURe61bjJefqdJ4dX4qyaGfZUuGDufJw+/MLPKlPPZilsW39hmTSkC8H/MzkOAW+1FJLiMjhEmxS116QSwGaNsIL/5KQfnB5rxAuZ6A/WfWQtP7iNCYevQoRSOijB55rTqbVJYDibAMX1jI/Vn0TjtVDRK0234pHf+MhelrZvUnj2slFqbIxNscKqRvBVaFqgLgHlBg6sPYCFC1ysnrhzFGEploY8rAu/L1ziRmGuZ9RO7UGNqwEaKftTahcaBcTwWU+E8OXG7Ul1zATYzRMOk5RRFuNKeUYqafPl5Az+RSzvapdFVPhwrKpJQzwkgsx2
X-OriginatorOrg: westermo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c088df32-0403-438f-de5d-08df18a4a29e
X-MS-Exchange-CrossTenant-AuthSource: PA3P192MB2868.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 12:25:49.2833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edJLqDbNigDwppvG0r8T/toqXcEXOsqUb1l1oHWCDMBAuh2VwhjyUgJRl5KfcAI3p8GUX/Y1//3Js5GS6qpZYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P192MB3213
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
X-OrganizationHeadersPreserved: GV4P192MB3213.EURP192.PROD.OUTLOOK.COM
X-Authority-Analysis: v=2.4 cv=XNOl2ghE c=1 sm=1 tr=0 ts=6ab273d1 cx=c_pps
 a=Q+6aeo8k7UnQgFEaqf0cyQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=8gLI3H-aZtYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tr3XZvuDWTETL0Uaxejn:22 a=8ys4xmT3Mru1TjC2zVq1:22
 a=VwQbUJbxAAAA:8 a=N9GNhs4bAAAA:8 a=RYRcPU1aQxtesyULV78A:9 a=CjuIK1q_8ugA:10
 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE3OSBTYWx0ZWRfXzDHYAXxxWQ9p
 IDZlT0qpA/QSLr8z5ZlGRdfgjWDjHMFx7qG90TJ3s/wVpuxxjdEfGUCpyn2AuvMuyCTFcnHwB/B
 OvPSQkjibrVwQd1SE1C64dHzbI+VKdc=
X-Proofpoint-GUID: WdngnqigAOvstPgWc0kfoVjVP1TOdrpq
X-Proofpoint-ORIG-GUID: WdngnqigAOvstPgWc0kfoVjVP1TOdrpq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE3OSBTYWx0ZWRfXxESYTCwvRA0J
 uAI8i0m/VbS97YAVR6qKVYxWTz/rAwR0a1LHEsPC4yj545dSk1jzXNMVYgEL1n8Us8pKScmYDMc
 gPknViIze0H96LO9qmrkPJAMS4QI2XlihV4ppD8u94IieV/C2XsEhO/97f2zYJk+wJOE/ZRdlUr
 avr1R+Oduz/fzqeapmp9AasUQAehINVD7ve3xtK21YeqvOvoMt0MO0lysxkcv8Vy6GgaqSSDAKQ
 j80D2wFspdKbt4gWgFt7/qNtmfTPTau+G6312nzB+ytoEZHcHBjQIrW1U0OHPsoXKBQTYoCU4+N
 1jESEiTakPJXZ3/CIWr+t4Jwh5/EpF7F5amQlGpXw/oruCfHPFxcZYTeIV3kMx1htSvwIHOhssr
 pFWilPvHEo3Lbjn5SUryHS7TqvV6LL3gHSlBiVvUpa3D2O6hmtb3nNEXDOZITgramDgCt4DmAYe
 xORWRFEWejEEmqUbTGg==

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

On such a timeout __ath11k_peer_delete() returns early without removing
the local peer object, and ath11k_peer_delete() consequently skips the
ar->num_peers-- decrement (it only runs on the success path). The normal
free happens asynchronously in ath11k_peer_unmap_event(), which never
runs when the delete response is lost or misrouted (e.g. because the
vdev is already gone by the time the response is processed, hence the
"invalid vdev id in peer delete resp ev" warning). Each timed-out delete
therefore leaks one ar->num_peers slot until max_num_peers is reached
and all further ath11k_peer_create() calls fail.

Free the local peer on the timeout path and return success so that
ath11k_peer_delete() releases the num_peers slot. The peer has already
been removed from the rhash earlier in __ath11k_peer_delete(), so only
the list removal and free remain, mirroring ath11k_peer_unmap_event().
A late unmap event will then simply fail to find the peer id and log a
harmless warning instead of touching freed memory.

The problem was reproduced deterministically with a fault-injection
patch that forces the peer-delete wait to time out: after max_num_peers
such deletes the AP permanently rejects new stations, and with this
change it keeps accepting them.

Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Pfeifroth <micpf@westermo.com>
---
 drivers/net/wireless/ath/ath11k/peer.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index b30a906..ed2d7d8 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -341,8 +341,20 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
 	}
 
 	ret = ath11k_wait_for_peer_delete_done(ar, vdev_id, addr);
-	if (ret)
-		return ret;
+	if (ret) {
+		/* The firmware delete confirmation was lost; free the local
+		 * peer here (already removed from the rhash above) so that
+		 * ath11k_peer_delete() releases the ar->num_peers slot instead
+		 * of leaking it.
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

