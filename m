Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010004.outbound.protection.outlook.com [52.103.43.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AD849739D
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 11:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789729492; cv=fail; b=eqsxej9y3CyYBCrpIWfvtdoL+b53ZO7hzTESm+G4A6jKM4TVPVwhLFzzRODXCX+mmCU/mbzXVoagoyT4bs0Zywk1cfWQ5pc2fj3dsOopjt+65MYHOp1pCijHflLHBNgxu98I1Cgv01oeZWM0UruhF9VwfjxJBMN5VwbjOaZqzL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789729492; c=relaxed/simple;
	bh=n4U64QBJfIy50P0SC3YbVoWrp9HuMO5PJD6Eb7fiq2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PrL4Io75rxg8UhLtvx4sBALHRcGYMOpEiDcEI09om5WF7P9DUUnwk4neZhSzfo+S97FyYdGyPXZ9VtkZ5NMuR5ulTho9Swj5g1YnuIQ8l64nwZXZ4n7SBbCHdjlsm/MNEewCF3ZaEc4qPuijRuYSP7jIu+vQjE+PoMW0MfHglxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PY32PSTF; arc=fail smtp.client-ip=52.103.43.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PY32PSTF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJd4EWN/ak1XNi/kUlDXeXgplPWeIti2jhi9y3Cyjv43y/m6GItumPPvNq+EBNefO2/w/SS/5V6FE2u4MRE+3z5wNX+Nql3+BjLzrvLy3A/YQXYh0ARzAHukNwHpdJxCkECsCgZltQ48b9pf9JmQcz9c8QDGbSPT5Y+hhXFdig7deOwl4nvQj1ihC9M66kimSbMIX1XOsHUypiByOQh0XZtyrw8sZmtOEvrmbqnccGpqa3Nuh0FiIKQmtD//VDkh1MAGlE1aiEq3INa1BWZcQqYf+Q5CZsOoOC09cQahGGto4sIlJ+d1oUKAlIBIq/bDxmZQcf3vNd+odt7DpWIJSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4U64QBJfIy50P0SC3YbVoWrp9HuMO5PJD6Eb7fiq2w=;
 b=k9Ji+4Cu0JEL/ZRAW1v3qbO7ct28qa1IiO79kCIY3hXFpnWs77X2pUW55rjCO9SBb0OUasDrUrGXUE04/ds92+yQoyJWssd+qtPsWEjWGTvQ5OycdsDn4nmoKU8z0tMDSarb8J17mBOKIBLFdPb4c1qXn1ezSgRzHJpfQC+8YwsJsH0JiujxB/YPu14M96UbOCAO1ObsVdK1s3/u4IFAX8hPdc0hF7qTEEN7wGH5/7vfx0wE1EvqKlzHsQUHDAsp3ECaGbOMlEZ8GXbBJyOwz1UrSdfodT16+er15q74ZGVFxlBnnPXMwIariaNcHBSQ2MVrMwQaH3vx3TeFun5x0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4U64QBJfIy50P0SC3YbVoWrp9HuMO5PJD6Eb7fiq2w=;
 b=PY32PSTFcQegpGoVcAaVHmSHVtms+seAcVd8BVY1KNJFIKKvtWvLqAtbowfrx6mKffJwgtlAoNJuj6W2YVG+ONVkU+YluFOwmFTFqLRIkhdg1t6kDF+KtYvuvzwPR1avtDNdILeMm12FVKQYnpuVg8vzxuwrwyXq7aaxEslRVPvOWKJZfhMdG7ntW7urITW1+ON2+l2JK84Tkj7RwVvpY8Rqh7WCX1la1RUYPWjCIFPpC85E2eBWxPHe34mG5um1nety2QYDH8TURlHFlqQ5ZR817SJcM71ILiLE8A/L+P9MrF2NIcoebMdq0s2XEeDv057dHn867aN1ahZJfvTmUQ==
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com (2603:1096:604:1a5::10)
 by OSCPR01MB14533.jpnprd01.prod.outlook.com (2603:1096:604:3a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 11:04:48 +0000
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b]) by OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b%6]) with mapi id 15.21.0406.014; Fri, 18 Sep 2026
 11:04:48 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: Re: [RFC 1/2] wifi: mt76: disable NAPI before deleting in dma_cleanup
Date: Fri, 18 Sep 2026 19:04:03 +0800
Message-ID:
 <OSZPR01MB814065F2461844D2AA2A9788BC872@OSZPR01MB8140.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916204750.1439984-1-greearb@candelatech.com>
References: <20260916204750.1439984-1-greearb@candelatech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0193.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::22) To OSZPR01MB8140.jpnprd01.prod.outlook.com
 (2603:1096:604:1a5::10)
X-Microsoft-Original-Message-ID:
 <20260918110403.255448-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB8140:EE_|OSCPR01MB14533:EE_
X-MS-Office365-Filtering-Correlation-Id: 27750363-e7ce-45dc-311a-08df1574a6e9
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|8060799015|25010399006|4140399003|5072599009|22091999003|23021999003|15080799012|24021099003|24121999003|16041099003|440099028|4302099013|3412199025|1602099012|53005399003|40105399003|2607281247196008|10035399007|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?POwfPHq3LJdpv8yMAOdq3gJfxxbIbR2hgmLVXQazq0+703+zT+yIyPCsz5qe?=
 =?us-ascii?Q?GAN6WAmdda26qLidso1V+WyNqTqhi4Vf2P4s5AzZLDz4RcIQsBFxwiZR93XM?=
 =?us-ascii?Q?SwlXNBYbybL0Tat9tQj2LFXxrOT5EX2sqrndgEqNFQCCsHEPxVT8zFx8EjxA?=
 =?us-ascii?Q?Hwt0f0JLig8/6B+7jUexDhSkHfdbGjTzkfRbMJYrqdXpeU4/kPVIpSsriGXM?=
 =?us-ascii?Q?kK9wpLZs8a8zoIAaX213Q2qP7HOhilllFUlrL9nF1J+3emxDUSbvAx628LHd?=
 =?us-ascii?Q?5gprfvL6RTQCvaFcIDrCT6V0AnuaXMRZyTGh44zcjMMjjWAdThdm28Fhdwfm?=
 =?us-ascii?Q?dwrZM/jMU3HH13lG+rqcN2YbKt3sqdS7uxPyZD8F/TBEAofF56OvNteJx8AS?=
 =?us-ascii?Q?o8/M3FjramlUYZI51dWzxhxMF4DnIwLs5RD8az/t8jcSeR1e5ly7nZbphVBu?=
 =?us-ascii?Q?dE7D4VCYaYaIYJcCEuy2XyfXtr3AjDzIPHMizD75WgHLwaYLV1ZJgShefZzn?=
 =?us-ascii?Q?wvoETMKCuDo8YuqXi1EHcqh5ldtW0wwIO/bAndZ5dNkj52HAKuFwtjBlmdJT?=
 =?us-ascii?Q?JvkE7kQyKDaSVwKJO93AHaHd6GRT+Mq0F+q2ZR1lXrsdBtwg8AUGccDANgvz?=
 =?us-ascii?Q?G0/YDNaAkrQNC20XrProKL3NbqPdAyg3a7+4u6+9Mj6UWN84fznNsCwcSdPH?=
 =?us-ascii?Q?OYJajrjHQMX3TdJy8cGSA+tMSjtSjmCcmvUmbvuCuljMTVQHHbukUe+2YFCS?=
 =?us-ascii?Q?zaH+eiXmp1OA7qPmzStmPRyTK8iPVKIXPrXQjbTTO1RXceEYSb8NQ+y5J99W?=
 =?us-ascii?Q?4NUjx6A+YX5ZvxKb+81wtnCqNpCzN3L7Qm+I/s/1pG0HyBQppoM0VhC8V+Cl?=
 =?us-ascii?Q?qpT3xERkxknx0Dwo3Gi63vncLBs3kbbOAtPat3BCT37tZCOoiknyb0y726Po?=
 =?us-ascii?Q?miJlp7LryStCZvAgV6HjVJc/a2cOjFq6lRzFDKnN3f7lcmTMVdQEksxxAJp3?=
 =?us-ascii?Q?Pp9IQjaxxZ+b944htGQWnUTtrhikpdstZqxJoLz9/IJfxft2DAhgJUeu31rs?=
 =?us-ascii?Q?db5yvQpqxFWhlrVo2WNcabL9KmNGfCBeXuzkJuLA6bG96xMKvVxy5TO2A98b?=
 =?us-ascii?Q?7YNRUN6RJFgqIu1SxEcZHJxYZ5ZT7WrTDoV7pmQVhuWg/Ex5QotTJko=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eAWhFkAP6lM2ijB+gW2rrMmPUSrNDAri4gjsb1MdS+BhLwRZr0RoRj17C2pI?=
 =?us-ascii?Q?HU4/eRcPAYWEN9w97+0JjOx5WEXMR/AFT7CDwM8zSayTRbqyTgqKE86GCf2n?=
 =?us-ascii?Q?jRihpUJyla2yfpa2MSM9W6Gg1tgjm8SgqB5rCqzRxqcbSRN6Htwcug5/4dSu?=
 =?us-ascii?Q?XG0H1e4PlTJcXI7x9rSEFUB7dKMd0xRjja5hP5vSV9jA9w8u3qDykceraqwz?=
 =?us-ascii?Q?SUFrQF4OOnhyJ7MWaQzoO6IDVNB2E2pOTPha4g5iYtBs0WQwkSuVVyTgZSIE?=
 =?us-ascii?Q?Imj3GSEKbqoJvRPyIvu7vxjCDhX7Vz6ds6aXEFJlimvLkUxyJG77QC8U/Hbn?=
 =?us-ascii?Q?WEob8dVtIVehpwmVMouEEic6hDifLxihDCqwC2n/0hRwYPYeTQsyFvhAEpW+?=
 =?us-ascii?Q?qIq/C+eNAfmOoutZWAVLQfEdbVNnKcsQ7MASJ9morNHuPKohMSqLUoRyMyac?=
 =?us-ascii?Q?8c7POPFAwJen0K9s+Iep5SlRFDCzkj9XD1guMeoepOc2RZKTClpH5xQFm405?=
 =?us-ascii?Q?NyIgrD6nQJ/2emnUsV6LrPK4zO/rcD07gcJ8wSlu/4cVQ226aNUQ0zuEDGj1?=
 =?us-ascii?Q?9I77VB3TrVev9vc8RAlH645T6tBxO85L7lH8NV87qvVbNRmsdTS2lt1Dsaet?=
 =?us-ascii?Q?rSPtwS8+W96QgQSWUw/HFv9L5Qu9Opj7i5jkxlviNYEy2R6x3PMid07k3k5f?=
 =?us-ascii?Q?+584bpd35qF5CZpZoBcwcD0l1FgZyifxwKZqegs5Kuuj45pgMJBLfMdAlAOz?=
 =?us-ascii?Q?C71n/zcm+iNV8o/ZCRDFSmbwRFA/zGH/P3+Mx010o05cphPSooreP0Ci0NmK?=
 =?us-ascii?Q?5Z1rps8w7ffrJqHPng/PLlXqSQV6/brE06NIbT3UhJ+3+djSqt/W5lqQ8XcO?=
 =?us-ascii?Q?MiM6tA2Hb+mgqtjL+E8oFLiUt2qsgxLWngX1z9qKU102CZ7EYvSzKj56OnjK?=
 =?us-ascii?Q?vVIbv9QGUlljbvmj3I4xa6jSNQCMknSuvyYxtv+YL2I7qzkPFLmgW4XEmerU?=
 =?us-ascii?Q?PmNZi4nK6zKXuL6P3NUTbz+a7rnrkiO5ocBVxPXgAAw6Sn0PukiMGd2h+NMs?=
 =?us-ascii?Q?Ir1cYgOXNtT9u2L84Y7Rgc0RKHHsexkbrxChtI+yVkycPfXZq5iBz3LP+4by?=
 =?us-ascii?Q?hd1bBomfyn2Ve6Z+wVr8UMbC/9lhTYuZU0lncc+qJIs+immBslxJf/Xcya5b?=
 =?us-ascii?Q?icAX0URcz6etOMdOxzYH6Lj8FI8AOL0llB/X1Thd7W2fYG2yBpgm5A0pak7n?=
 =?us-ascii?Q?r6O2F1vH7qObttlScOWAMwg3N+/I9TlOfIL9UvLf5NtBUclVgsBCDhoeoWMB?=
 =?us-ascii?Q?p+qV1IXevaHJXJ6QHRjzWLb8+7CxvfB2XUllmCPmgXOK5tvFWgNFh3ZRBGm1?=
 =?us-ascii?Q?1cS0zz3a882xFedBEFYszevzGFfm?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27750363-e7ce-45dc-311a-08df1574a6e9
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8140.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 11:04:47.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB14533

Hi,
This change will result in another regression. See:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3aa1dcaa4f6f5ae08936491e08bd456f331f2d40

Regards,
Shiji Yang
