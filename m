Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793068689;
	b=uWrgWeMpbj2PKGbPyxSExSafJ5Y37vB1c4xYC9MUNBcIAzBak05So9Nw2hFlmDDboZG0
	 xAAMYRlgnyMkzdmxDmeuWuApAMCJqX6TfInkvCiGo+eog7gfeiEFfwMvBfqYkJ7slcRuo
	 /pzefi0Ocus9BNbJ4oaHJh4AL3iyxhFP8xL98Wu/QvOonMHraxJM8MEzAHgWBzsypSwUP
	 ad5kJP0PY3a2iDVZgdtWsxk2cAYCOHGj1kl+1HXo1kTeyPcM+hliwTBHPozTOwQrTNudx
	 bTTKM2MKOKIU2X3Lc6m823nTUwlBn519bx6lyv879JaUfhk0CHxmojHp3YJoBRkE7tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068689;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=r+kSOr8i+qg4SFUc6eEHl9d/nXbsBxYepRNPQna1YEc=;
	b=YeSiQ1r4xhVhI91MxcN1ksvNgYH/bhxLLjxJXht3JufUos7D9DH5N/6KPl0ygso463E1
	 IutDggiRxm4DZIQ9XRDjAg7bGd+lnGedMZls3U57ge7qQULBJVm1WwMec/RCFJDTFj22x
	 mX+SCh9w/spaCS9jTDmb5sGEC+02JdUUhdfdcejtPrXCE5mwu5T5BeZBS1a39U6RkAVML
	 MVLbtNV0JqbpsduUQWq56Z2VSQehAVxCwnKftIPsN+zJAD6Jg0i6Fn6youNHMIO19hy6N
	 K4gKBJiMEQ+XPn9iHwNaKfuwgnzUdxqMnoNWKswWi4rhNfvSB2cVCQXPwDqZHCeW7mg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=EcsyeTj8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.19
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012019.outbound.protection.outlook.com [52.101.66.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73947606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 02:38:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73947606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=EcsyeTj8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYFjBJ0G5QY5H/OxC69c49R6WgSLCKwUsTXDzP/SY21cjhewKlGaDJcQQL+520JaSR2rOkzGBByfl6I78C9EB2AglWbALzXw/A+3Z6XzN52e2DoCzSj0kmC1BJQy1IRgtE26EA3FkGhFFlCVC3dXCo1jHBH3iMN+CW5f0uH9ohX64ysfn6W1/Fe7rqA8AVHeBBmItD67x6S+vSlJruKpgPs/XaKpHQmHu0+mXppKhPIW0HuWleIEvxjUsnPKyQ0g/+uA3bHNqHlJctsttdo7O8F/gMYtjkaP0zfUYQVbyO5vO5fmcWQOx3Jou0+E/H2t+fQCkULZ5Lto+BEtq4dzqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+kSOr8i+qg4SFUc6eEHl9d/nXbsBxYepRNPQna1YEc=;
 b=SWGJBcKQq4jQpRjiejXZ3zNxgLZ//kaf8mpZDZMZF+yrnFfOM9Eb11n4LudbEhaD8Q6ATcT9Izg3lgTcYxPHe0K5t8oYqkWbkduG6WYY3y5rgy1Uk4OrXTRb0bgS1E59wZeCNao9jOh9bC5KIDFeOFzE6dqb3byp9fKI+8+7fjs8VjzFDAWVQilqqcZctVk67thIRZd/e9/KLT8K2vGhhzDd7nmIxlPzUzB661QIwzCksetAEibgLg8yMceT8IWIdnG22KZEGvNQBmMGYGoK++iYEUIN8DY2qYhH91cZD1fy/ry9zRojeCBkwjoRXYbJto8dII9Ea6i1/OTVbP+J7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+kSOr8i+qg4SFUc6eEHl9d/nXbsBxYepRNPQna1YEc=;
 b=EcsyeTj8QPJVSmSVZOjrwIYcJiULhAQgPzz6FmAeQXDalNy5WUssgBZP8BmrzVah6mVLBoLPXrKu7wLwFbVTLoe7cpqCvpZ0eFAYkn/qfe88Kul9COO92HSU0gAyUnJmfk9urnPhdVe5q9eMU4UCB6bKW9M39m/HB4Jt3D72/+yiGOW1cNSpZDrKyDJu/s5vXONJ22Ew9c5AAfF1Ei7w1aSfX9H5wTc1LG9dRxmHYANd1wgg5uLxzFbx0r5RX9yeJcF+65Ckp68ApRnXvZt/cOXvDRBSomBZaRj0lTz2lTvJH0iNDJJK8Z15Pvd5gkRhmpUoxyCrDHc38kYfKjw/lQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DBBPR04MB7947.eurprd04.prod.outlook.com (2603:10a6:10:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 02:38:05 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 02:38:05 +0000
From: jeff.chen_1@oss.nxp.com
To: Tristan Madani <tristmd@gmail.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	linux-wireless@vger.kernel.org,
	jeff.chen_1@nxp.com
Subject: Re: [PATCH wireless] wifi: nxpwifi: validate scan response TLV sizes before indexed access
Date: Tue, 27 Oct 2026 10:37:21 +0800
Message-Id: <20261027023721.3847100-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261025181531.3744345-1-tristan@talencesecurity.com>
References: <20261025181531.3744345-1-tristan@talencesecurity.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::8) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DBBPR04MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c10a86-38a5-445a-98b4-08df33d353fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|19092799006|366016|261021121427099003|11063799006|56012099006|261022105027099003|10067099003|18002099003|22082099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	m+Zs6j/+WMYHJaXcaARS8XnKH5H9idYwHKavi/RN7Aabsp/x7K+LQZLSYfWT1hoq5VtHu4hun2aB70U4AvuVRz+WLgux99ZZ0DfX/R8ik+ZifPNs0q6DhZzOGafnBxXMMOsA0NiKA39+2YoGcG8P+460K+o/pfOhgZv2Xwiz+Qf1ohW4+NLYoNur4q0R+qlGtBiJql4yXoINynpQFKI1vlu5IF278XCDSKWt+s6Ia8x1b0IU76Kbaw+ja0hjmkhSy7wcuiAGwjzbCO4LB4EevfRAQ4XX126360YYTo7BUymddeLI4ZKAhgi4+stEVhW8O+PaL4RQIiezb9Cl0Hm/HZN563yacI0AxFLuBJmaB/iKA1UkXI20PNjnpByHQN1Gjf8mbqyinWtf1dB1gkQlm7e1Eck95Vbx4CQ4DnX2ZqE7T27sMsmeIWAYtkMzWpk0SieuV4axL2K09drtOSZKO5KZ23ucx19M8McCO4qwc20GrqNVUc0EvTJZwakrrWllqi8YZTLyjoANstRn6qpWbYN4M6l7cBPM/HtJpsPPmjV5lWaWhh7q8pK0IbGLt/dkU9gr+FgfX+kVfY2XDTbC4Rsp323KSf8G9gG5jQ+Wh5esl7KJYRnf6MYRXjfyjqs6EjlgDeXPSE/MoaFHpR4OVSgEPJUuTMKI2O0yQWRPGb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(19092799006)(366016)(261021121427099003)(11063799006)(56012099006)(261022105027099003)(10067099003)(18002099003)(22082099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7dlCdh5eOrzyoXqYhk/11zom2piEpFMN6X6HMd/6AJSch9DAbtUDf0hswtrU?=
 =?us-ascii?Q?0I5QRih6FFrsburVP6ZBxziBUQGftCBgP7ihZXpD9ibxs381q56849AEWfxf?=
 =?us-ascii?Q?n3shyWYDHdTJOG7chpBivX5jvGvoTu92dGYbr5BgYKY0COKxAqE1poaXFvAW?=
 =?us-ascii?Q?79HxzOl5pOKdRkaOmf26AoVRfFjiIOF5bFntosr1/z/7zeSb2GgDM1TAawTr?=
 =?us-ascii?Q?gZ034PoMzrCBaCG3MpuolYUqy8npXoG37IEueI6UNWT5ooe+j30PHPUgzVu2?=
 =?us-ascii?Q?XfV5tyE3OsbCY20Du6kYYr9bZoDivFrqICodg9hsc32wB6WWFrg8S/1KCQ3W?=
 =?us-ascii?Q?3rljaeJ/EQzPHu0wTqzAN/Wm77zL7xOxPbOYZDNEmveZieEhLuttZbHc55xu?=
 =?us-ascii?Q?wXkfuN4fG588Z7pReLrt8Oe86SqBWrAP/w2PRUa5wqR1lWWY8TUN4E1LtdpL?=
 =?us-ascii?Q?XU+ksFbr6K+Rbwxg5taU/PpfhHuHPBWo36mjwGVRo9qYuWJqWwkfSsSZB1aO?=
 =?us-ascii?Q?44Ri4a9RbomWcdHrBGrjleNOyO/1AKHu1u2PEMpbCOysTsqPZIM53ly1dSa7?=
 =?us-ascii?Q?G5X4M+1v234OMTd8B0llTyXoJxrSKigkyBI4OZuAPTK+nobnk/U646hm6g8A?=
 =?us-ascii?Q?dhk3d/Ty0Yfgka2OnUg/ZZMnJqdJMBssJQh0ox3vGJgnkNIh7EK6RPZZFMnd?=
 =?us-ascii?Q?A52XopyUUjzvYpJH+cP+f2y6oVNEQTNBsh42KOYYxmF6YpTH0cncHKORwwRD?=
 =?us-ascii?Q?7Rr4TSaQNCl6G6ad79JFG7scOHSPJcsuZkuuOtiRIEUhNbdLUHsQb3nFHg+d?=
 =?us-ascii?Q?Nn0L4WULGpKtFWWq4rn/obx+NzVUYXeDiEBNrQehHh32S5hK+jIfp/fPL+2O?=
 =?us-ascii?Q?r1NAy/RCQsM/0ea36Duy6jsQ9v+o/neSwFLt0vNADTkrWueOChcrmfJsFwrw?=
 =?us-ascii?Q?fUQ0wZ11I9PODPhUg9SpHtQZEGM58jo48XJhDJNu1gaW1LFp1w7AjSaIUGlI?=
 =?us-ascii?Q?pesHNg2Aa8HcFdZOXzZAbIr9QfCETnnVrDVWlopUQ/fDyTTMoXryXJwJ9WNE?=
 =?us-ascii?Q?7LhWl4l2JDHKxfq6M0Vjzvx6Guw/zT3ELonFfCg2rmTtyIPecHjCYs/epf89?=
 =?us-ascii?Q?iKePygZzHJY1Een5KqITeZvoPBYQ86Zeyw0HCP3PhvovigT3KhBBhzLy5/DF?=
 =?us-ascii?Q?xbKKBsKzohWCRGNG1u3TpC56k7/XbTWScmhpJxrHj3vp3zP2yP+Rrj/Ex6iS?=
 =?us-ascii?Q?11UJ2dYaf3wa1UNmJLEqtOfCg/zopEq8F/3AzBbC949yJSt+l8JqBpJZG9o9?=
 =?us-ascii?Q?5Io4KTnZ1kxE+8VgpIBgsOdB/SmsfMkUOqzyoRHLibmH7I6PARtouB2be2t/?=
 =?us-ascii?Q?vZg8xx2mA/mcTkxJyDq8KisBZ5IxrTVSr/eFeNzvSzZpg3Z4zHjyKu8EbqPT?=
 =?us-ascii?Q?Pd/GyezwzpWacNZuR3meLw2LciTXCL4Ie8etd0CzSuTG3EjTDjfmv07L7ajN?=
 =?us-ascii?Q?Ven3nFQd6PsoUG80fYtGea8p1aeJAh+5dHZUKVjYO28J8dhIfmftCyuPprQ2?=
 =?us-ascii?Q?auiKkA8kRzu7MrAgbjHhcVA3ouSuiVlbMKrnPZdoau2rIv0JMhUsNkKIN88m?=
 =?us-ascii?Q?VhcghkPS2P9rosEzrFDS6mWja64vKwLPluvvKwx//+msdajJHN0sR2As7+6H?=
 =?us-ascii?Q?hv1N9SiLHQpyVMiROs9iq0Qi3qBsf9MTQxOayb36tgIQOFy/kSdEqkgivIWM?=
 =?us-ascii?Q?GPBye3LjfRfwM6AR6AtbTO/s7EB+GyJ0ep2vv+qUSiDedpSH4XVP?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c10a86-38a5-445a-98b4-08df33d353fd
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 02:38:05.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amGzhJqnbsUe3wZ75PoOPJhCZK0Fi4wvDAbRyXC6GjdwpFm0mLxq3MjckL9beLXf2NE9xhNUm9C07jExGV2bBYX6nq6hD0YGcQ0gJ0gQnFQyigbjOfdPvVRuRH24DeQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7947

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Sun, Oct 25, 2026 at 06:15:31 PM +0000, Tristan Madani wrote:
> The scan response handler indexes into TSF and channel-band TLV arrays
> using a loop counter derived from the number of BSS entries, but never
> checks whether the TLV data is large enough. A firmware response with
> fewer TLV entries than BSS entries leads to reads past the TLV buffer.

Hi Tristan,

This patch looks good to me.

Please address the bot warnings before resending:

- Add the missing recipients reported by cc_maintainers.
- Fix the From:/Signed-off-by: email mismatch.

Thanks,
Jeff

