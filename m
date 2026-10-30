Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793359872;
	b=gGreL6NhECqDa4lWwwfCtk+XsKOQ+3iSueDqZUXUJgSHBRfQIqPdkoFVUSaWysWo1e+B
	 YokDcs0c6mepZb8dkLP9WYvhqdTiNInc/HTo+9I7RmzG7OjaJq2/+lr7IpaEY4mv8BnFL
	 ETED8GGFBUXSVWHPFpQiEYgB7JvMrUvT0SbGFjKN0uABunjUrpkLTPnRuk66ocqrnlNmx
	 Sf9EgbDvyRxRFEG6mwCDl366AcV+hGGHXnlLpESPwnLVxlkWnJmihiWWfW0AQTBPlDtrE
	 12q9xHS/JqIZ8NqnBEnVbDl+/Q0vYOMfPPVucpT/ri6sc61/m5cKlFryjYOIdhdVzsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359872;
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
	bh=LugBnGKSLbdbNI9D3ua4VBGTSeBb0kDa59QZcTDIFAQ=;
	b=1eFBCoWkGwbFNTCiBX0rA2ZjgAeagOZoBuBQu6LVkXdXhlK93dMO0FJaEdyl+zOCauRp
	 z49GyxlMZnheD+d5cOCJOmydKCxcl2Yr3nv+AqsLIGsnwkMgYKF/0UhwnoGqxWWzrNpuz
	 O9AvVHxVy1bG8xnD0hmbe1eoWG2HdR68R6Nn8USvFDxi/GPnMfMSt9o5wDzCjrxi2VIFV
	 DUSYxdCfYEuCE7Mv8i+UtVBhTIhhdXuLkF1bpTkf8Qu5NtGlUj0LUlKAvQMu1DIyVeqvq
	 vGDvXBWU2C2A52k6ZlKs8Ky5Po0TDVt8h0sEaEhdPtA5E03fKP1tfY5+sRQYf+ZL//w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=jnPD6A6q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.19
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011019.outbound.protection.outlook.com [52.101.65.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CE5606A326
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74CE5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=jnPD6A6q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFrP69fdI1Owatu+cJWuF5kF8GYyGjB/NiW9qt+366hjNAy/FCdTU8KneVQTe7wWku1AhvoqfNJ7XIgulaOUDtmaCVwgNqyv3oczkaIMJlljiMIk8MjCA086kYrGxGF4XH87Ixk7tq601tVYXUEcT8FbJAoAnf+uDtrfzyoHBdDPSh6GYSeDg6cB67Pvr26SMgBetPzKUE0uymhIclnnRbQAWJhSTzv9cHC+W10pvR0Q6uVEc8bMHPYLo3D12l70p0GRhYw/vf4zZZhaG/ZjRmlnvsSrkDh+PMJxi0us91w9Hdnl2Nv0jWY9oIvRUbIHACNMVfQK0LJFdKTqZGDdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LugBnGKSLbdbNI9D3ua4VBGTSeBb0kDa59QZcTDIFAQ=;
 b=nJMIpY8AHWm1Xm67MR5c7Ff/EgKkBQdT53pVOwaH8ft1N4r2yh4C3/f3Txy7RD8V1YPPDugti/YUBouzQiTMb/PBl+uOR7xClJSY1v5Knb5w1x45LCnL0aIKNmLYwq2OytOsHE3Diikw1H+A2e8V5NH0+CJdB2VTCawnEmJY1uCpnCvp/Tm8o9hpqHInpYc3J4GLmHip/00sQAi1VUQSLj0zGdIs76AptZX7PgiYyGZWQbKrzwFiBp0PScXE6ztfhyqCa3NsXzTEGljJrJAld+MlKemYF40C/gfd0SrnEHNQEYimdJ9stFvI3ESkHqMTxJAc6V2eqjgpC9UIYRFK3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LugBnGKSLbdbNI9D3ua4VBGTSeBb0kDa59QZcTDIFAQ=;
 b=jnPD6A6qcKux5DJIKU/ybAHprdnkEoB2aTx+LamPBNDCRt23QQKmZG6EYIxTtPCQpfhXA1dF5bKavV5xGc7HKlp4vBLqG7uGdz1spVdHmzyxEXA8mxmDbCMrD7nmKF3/EXEAF+mJmi+7wmiLfZn7+6Q2rv26PEaplMq5vZKs68zhYuPlMNTM9zTRNUjRL5NPBVucgvQuwSK7z8Qrq/nqVoVhX5W8HawiMvYB1NEqFEq+TIuFM1l5yObBTponwgGN5bB8Nsimj4z3mM0R5cNaOcwqujQnrJactoA2bRhmd+knUfRjxukyQjPlU0NhJwnt6P/zBvvJBx7umfRs/WmoZQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by GV4PR04MB990698.eurprd04.prod.outlook.com (2603:10a6:150:410::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 11:31:08 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0569.008; Fri, 30 Oct 2026
 11:31:08 +0000
From: jeff.chen_1@oss.nxp.com
To: Heyang Tan <thy15333007817@163.com>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	linux-wireless@vger.kernel.org,
	jeff.chen_1@nxp.com,
	francesco@dolcini.it
Subject: Re: [PATCH] wifi: nxpwifi: validate extra-header length in monitor RX
Date: Fri, 30 Oct 2026 19:30:42 +0800
Message-Id: <20261030113042.3895883-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261029032957.1422-1-thy15333007817@163.com>
References: <20261029032957.1422-1-thy15333007817@163.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::18) To VE1PR04MB7280.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|GV4PR04MB990698:EE_
X-MS-Office365-Filtering-Correlation-Id: 599b3246-ada2-4d20-8c36-08df36794aa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|23010399003|22082099003|18002099003|56012099006|261021130227099003|11063799006|261026140227099003|261026135527099003|261026130827099003|261026121527099003|261028144727099003|261022115727099003|261022075727099003|10067099003|261021123027099003|261021121427099003|261022113327099003|261022105027099003|261021133027099003|261021135927099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	nrkUvqVzxe8tQLDeIHIYec5/9w6yQE9TFN3sU/zM5LmjMceJCo+AthHA9ydCZXwKXpUwa2khBsWiD2kfVUtfXySR76R/Z9qaa0oxg73Tr0zs4V8sRh5mLvkRnifdhf2l2ZolYHBzpsDjFRVPTMNpT4XRehc298Cgp5koH7/0h5FzgRYnuU019JNTHScami/TBBtDyxMlAWDbptGLB+mP9RSalpCZPyGpZQ77JM+ZnuKuwzOnjFiBoQEZ4DtsPpZasg/D1QXaRXwkIPsGxekyVp3Gc+gGjtci2kIjnieDUyPf9kJqJV48JZmMvLUDhIaYUFN8+TP4bdIjNtKQ2JIcU/BoMU6hmqyYk37NOuCKeTlUk3+3CcygqkWoUX1la5echxigsuTkmEOfNdKlSiW8yAjoTAN0Xc09S/2/8jOTudJOM3MjknUQs7RP6ntzwzsW3n8z6IbM0fb98fEo70ehwmE/kZRb/pmQTK3gyZhH60+cySz9RYdzoC3w/CxdyZ+WPRqXHwZ8e7SfowD1u4h5UfdZO9EJ3Sx+oWaaNB8IDSa1GH1fkb58wwj56j+gkN25Z2QRyvWldbcFWTAlYvDL1FuubcP2Gu8xHH65sLiyxfr5gy53xKqCkvD126Ukhv6XvhE3UPY1ijOy7Zut+h1MdllsgcqQzlQME7JpX99Lxxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(56012099006)(261021130227099003)(11063799006)(261026140227099003)(261026135527099003)(261026130827099003)(261026121527099003)(261028144727099003)(261022115727099003)(261022075727099003)(10067099003)(261021123027099003)(261021121427099003)(261022113327099003)(261022105027099003)(261021133027099003)(261021135927099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aowzg3GfyWwONXe1bLQ6KEVZ5PWgyU+dSRVBr9bBgYIo3lE31UoozsV2skbQ?=
 =?us-ascii?Q?onglvgFEEXONmB5Y7OfEFYMlCiE6MBk8W+LX87HCi3eYzd690SpMq+0y0N/q?=
 =?us-ascii?Q?NnX8rBMc2HHlb+j/k6z/ZWOUtS9HmKmS4YFQj4kVcd3C5m8wi4tykZKRHAQi?=
 =?us-ascii?Q?vq4WGVVjzsDgtMDBGncYCHvMovzcxTq3a8lyQbaOWtCijg/SPoX3/7F++wzN?=
 =?us-ascii?Q?1lE274Ye20e/9J3AdA5tkYw7MwkM3U4a9RfSltMa6fI0WZB9sD52tk0dh/E3?=
 =?us-ascii?Q?YXDMX0WvqySqLGG19TI0o2F2a6rxLy2BSSHAY7enLVXUiKPaciIzjMzkZox0?=
 =?us-ascii?Q?qxNpWXUCqv89ld4Tc/3S9BtVoyr2BcSMs40dBqX0FYfmomQR0pUlDhEHPaSg?=
 =?us-ascii?Q?QzOqIzivsA/Ftgpv++KiyVfz18OaqpFc8vXnUPcFpvaR7c6GrmFQ8Y+skXjF?=
 =?us-ascii?Q?CZlGKsR7aFz6EVpfW5ZLqE4euCKXZKgVmdh0yi/+2zI1Qzbm5cEvqO0wMbBn?=
 =?us-ascii?Q?sRYlXf6i2/+mGHLg4aJgZ30+mxrHKp/ZrMPKc7mCE4cNenPYio0EHvekHilv?=
 =?us-ascii?Q?QeanMpiskyUZ99ToGpsqZeQ21PJn8say5hp7eMYbmX2Ot62/SMq7BbKR30lm?=
 =?us-ascii?Q?o9pXebbFc+2Fxo+erp+VklkJt/2THSeFTkNz/RllBKerkCZsqFGtkyp7oXlD?=
 =?us-ascii?Q?puNrYVneLlsVb8dKr0lGXQ+otJc4Ggfhs3KBwT9qo4HAW4aR5rUwMOK/IhcI?=
 =?us-ascii?Q?xz9zqxXLEAT974WJ0Yt2J2F826FVzF/2UVOZTCU12c58Z6kE7RhP/laTKxlu?=
 =?us-ascii?Q?uFmnIzEHKXgegix39Y/tNycS4kXSuunwaz1AaktXEVPGSTu84/QHN/kjEZma?=
 =?us-ascii?Q?R8rih/9tJCjs3+wr4wNpi5Blw+5ZN+MvJ7hGjZnxl36Z+X2lh6ALAW+mUibf?=
 =?us-ascii?Q?BM+QzsU0gHKpsZD3fj7lmCn1G+/AjGnBJs9sG1RjNIrPxoioaYEOaImT2PSH?=
 =?us-ascii?Q?G8bXnS/Kt7Kl/RM5x3H2bD9arU5qeuXHxUc3iDQPxtqZoxL7ZbetU6TpEkrN?=
 =?us-ascii?Q?p5kXIwV0uND4+cED8kVgzkeB/DG2hUP73JMI3S7l9eU/4B24ajXRhyTfj+1/?=
 =?us-ascii?Q?/VtWHgxwBdNQQ7x1RsDZWXjIIqCu/tbgvBiqZSSsOvIN4mFuIHnf9CB6JvpI?=
 =?us-ascii?Q?j+wISROG4kCLc9tfpd+6ZnQEhGP4J5lHVGXt0TFZ+T7h1QJqLDtBw+CowXa2?=
 =?us-ascii?Q?b0kuf5FSfCXpWM3vHm7AbZBt75yf+08y+TEoKzweP3gtInJdna+YkABypXpe?=
 =?us-ascii?Q?1S0MVC9K8YolvacgkHIKpE1dEV9YqwzpGw9s+8UhTcqL2GDCrp4ssMuBaJJd?=
 =?us-ascii?Q?w/+Oc6cZvwfOhDx2/gsVTbv0gPx8JUHMv1+fj24XMQ/YIp//MoESBqxD3rBX?=
 =?us-ascii?Q?VSVg5RLWXwkXhgev3+9r7BaR5ndLedeUocC0ze7Zokt5YHj6H1aiLwSyQ8RP?=
 =?us-ascii?Q?OYmBPGy6lOZXeze0ngy1hs7JmfDO7UcSsNZvflwQ0FEobEkJJ5q4pIPFFSU5?=
 =?us-ascii?Q?q6EHRFhbzVvl9JPmFzF+A1vEBj1B2FZ70d9Yo31+C0p7kGUeQK/DIRyEysDb?=
 =?us-ascii?Q?mLoiX4pFc7Az0ShozcBDSxcTgVyWQLkwI+jXBBYnMsSyB4XbznG+T8nfPoen?=
 =?us-ascii?Q?sP88qzs0gO2/sdT+D8Rqy1FGXDH4+erHkKxbLI3qq3gNMfxEADsrC/HN+KoE?=
 =?us-ascii?Q?A6k+aeH1d5zNOpryu6v8ooqmBW/+qSshNRDzCsUX8WtEkxWfzsuD?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599b3246-ada2-4d20-8c36-08df36794aa1
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 11:31:08.4809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayUURt/KVNP2p/lySrpoyMyXTPx63jjNq1K7MnjfbVkM0+2AYNRZg/DTHi9WbthPU+BBgYpZGR8b/JSK7/qjPiRSdI8N1QSaRNft+v5PbJHmDds6abRNvdMHXsOGyfVA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR04MB990698

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Thu, Oct 29, 2026 at 11:29:57 AM +0800, Heyang Tan wrote:
> header flag is set, the memcpy() of the extra header runs past the end
> of the received frame and reads beyond skb->len.
 
I'm not sure I understand this part of the commit message.
This patch seems to validate that rx_pkt_offset is large enough to
contain both struct rxpd and struct rxpd_extra_info. How does this lead
to a read past the end of the received frame or beyond skb->len?

> diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
> index ae8444a14..bc85846d5 100644
> --- a/drivers/net/wireless/nxp/nxpwifi/util.c
> +++ b/drivers/net/wireless/nxp/nxpwifi/util.c
> @@ -616,6 +616,10 @@ int nxpwifi_recv_packet_to_monif(struct nxpwifi_private *priv,
>  
>  	has_ext = rxpd->flags & RXPD_FLAG_EXTRA_HEADER;
>  
> +	if (has_ext &&
> +	    rx_pkt_offset < sizeof(struct rxpd) + sizeof(struct rxpd_extra_info))
> +		return -EINVAL;

Could use sizeof(*rxpd) + sizeof(ext) here for consistency with the
memcpy() below. It would also fix the checkpatch 80-column warning.

