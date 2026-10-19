Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3F3BCD2A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401001; cv=fail; b=daam4gs4EtjRrfITl6KJtK8cnzkzIJv+7ps0Rw59dgO+CoDXV6EwtpN4s1qdjYrmoBfuSu3oHnn0QO44Aif627sndHccfgURNuA0pjKHqMj8qgJeIHFmZUnIuUE7f7qo+Z90u9ka0CQFxaXnJa/6Kv+h3RBf5gJMelpFqf0EvjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401001; c=relaxed/simple;
	bh=Vtun7qBN3a98Lt1HPhmAF9pA8wRFy4lCcVBSFAk86qg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rt7n4oj7sjRHvDMsshXuRaVSM7SomlBLkxPIEww84QW+PJjpyIM12MyEZ04Df/Di9e5R8qb3NDDnfL5bK9BW9SXoktdfbOsCG6N5PgUCvyEcPRFWkPJQhVkEjWKrclIjZ8Jkts0HmAPFlQhc92HY22YXCZd8UKs0u9qZQQxJNoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=K2bhx/ix; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="K2bhx/ix"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7EbfNdXT9Vt/02znDHDWCKjzX5qKf0t3RFZfKaOybAgC4XdEyOTuMdP1RuFOkBf9KQRnZkxAl1KrvvcfJGXmheEypkoObpzvIOsoTjgzNLZpOSlXne+FpEdqHmXiQliUlJCnkCArwZ4R9Ks75xSEG5mnPd/ODXccFc1EWg3RZ5mwD9iJ57XTwVgxJJcUo53NVSrGJZQH0mQWgFnGrf3jelcIOOt4rfIdH/1Ui5heDLa0e95DPF0slt7o0n7uzs3XXamg39Mz3B2SgVDhpfSuzHANaTbdEddztYUAyFr3Yaj5OGgPbnndl3ADX6TVggR0ElBoZU8QVagt/PIhAvMRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3NuwRRxFkGxCChf531/+tI213tE3A3w+8ATf2dDAgc=;
 b=LC5Zev9yM5FUh3aVOGiobMT4T7nfKQObK1iLyq2jQPwyG6TWeRnSsrTo8xMhSHaeP3xNyA7dnUpM6yKK7vGanbevUsrVn1cYKXYt7V0IwbaCbRRBFjdzIiGDZajP2dKZemJv99ivQ40W1SuSSog3vwJOqhLg+z2ff/udp3Kjky6Glq5DYylTJBZje/A/o2xMnjHPJk9tmBsFO5NmTRljfo4UiOmc08pUlTbaUZmAOIzra3LQXWfkT/8Ons9XB10l4Ecy9LzDsrolG7dbf61jMQpPNasfW48qzoGe88I/k5O0S7fm++0GKBoO2tam/+nJl7xcb6/eGz+hQpJK+IZZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3NuwRRxFkGxCChf531/+tI213tE3A3w+8ATf2dDAgc=;
 b=K2bhx/ixJV2uoCUDZasWLdCfBVWw02fCDoBIuJ2/tj/dkFojMUYEN263yucGhRwMTEufrt593F/K18SBF5i8m/cN3smmzjuqE71pvJZRdNW51rr6/bszKh0FIKGzkE6pgX/AhuP9WpVkUxdWn1HRjIb4jgwmQ0Dr+V3wP6QdmY23c4ZCGW60a+TfdjZJXK5gALBIrl6WwJEOS7yFQWrEdSKuQDKxf/5ebj9pMb365Dj9akAvElh/C1i0hv4q/zY05YsSPVMa/2KPwdQf8WARiJvbjOWcI/h50CaKrkN0uPr9BNk4uqAkfQgBjA6Uk0iZ+7FLbEXFBp6GoCQ46XWAhg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DU4PR04MB12149.eurprd04.prod.outlook.com (2603:10a6:10:642::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 09:09:57 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 09:09:56 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Mon, 19 Oct 2026 17:09:13 +0800
Message-Id: <20261019090914.3609223-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016030251.690780-3-yhlee@isslab.korea.ac.kr>
References: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr> <20261016030251.690780-3-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DU4PR04MB12149:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac3391b-3231-4adf-c97e-08df2dc0beb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|23010399003|56012099006|4143699003|5023799004|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AbSxBOGHdU4NvFuScL/lL/wlJpNFOzbMdFZWG+Ek7WVzCrUUBW4QNzZpSUSR2GdNRWRcRVlsbniXP63QOSDGnCwPrLxAeQi6a2EGAnx7+olS+YWzJAZQ/CSWYsLsj7zEklXb9sb+nwhRt4EOUZec5wtfWziCEZ0FKbglqBVgnkRauPAA0khBn2CQM6tjPVhzejBivZyE0s+EGBbbkiws0YKsCCnw2UBOpgvXcPwLvdAS0vNtXD5IpsdBDqlai4abdfJ+m4CDmapWwHu+sejvp7d/bYowIJ6cKJMA6aA2mJL6xUfaMv8ZMQhdKuIHPZA5HgWZ9n7bdbpIoV2Cu/0wYAHzeJp1wUD5L8T6FeV/nh+2wNXtjkqLu4VcI3Hu8bwT6QwhkwvhvK2HpY6Xz58F9nNU7EpJLWaXs5vy4Rl2jdxqTRf2mAwwjAgv1kMHmAPtxEHzsrNyX8qvvVr3zlQ349pw918O9POuSrHSWbsjUKWsanZF5rYKhTtxgGKlIDPOaigWk17hL9o/ARrtYfefdCy2f3NPoSrO8gRbbJu9feLh+pERplXQIVlfV5xAviLxB3RYl2hQwYcX3pgSs/jac4z4/CQJ5CC5WQVzQg2MUhbC2R1CSlI2PQq7xrZYKD7tvHXNy0IXWKWtYEVWrYF6YW9DwQcbFe4IS2VcW0w48g4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(23010399003)(56012099006)(4143699003)(5023799004)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D1LP8ojnajya06MSjDn72Pgd/2FKmCTxFAk9LuWStR1QNNer0SHNz9yJCHOH?=
 =?us-ascii?Q?sly3ZMv5VyYO+pTGqEX2RMBERFX5fTbKszTV1ubS4NHSAd4UfdNWVqgm6XLS?=
 =?us-ascii?Q?XH1Wqo7sOAimwFPbN1Q9Mn4I1ITaRctNkzdusTFtVsV71lz6S5+7EMxMqEjO?=
 =?us-ascii?Q?O5P2Ph4ud+KQyCQRqcQvAiKz1zP3juW3+9jdySi7zwRncvsznuvn164yM5oM?=
 =?us-ascii?Q?03gEBauiGAayR1oGMM5//Zquh4g018BsB81oBlKoZ0wx6pCHQdLfzhOETE5e?=
 =?us-ascii?Q?/P7UNJdZaZ55zDwH1XlTCzllfp1w3UqxEIa6XPm9hPf8TALvALl+jtamWYBx?=
 =?us-ascii?Q?I44IR1o1MV5Vp2/2lW/8XklimeuN2aeqOq9Aw8IA+mxFXM+PaQtf17rSPOyG?=
 =?us-ascii?Q?lcDILFLzuE6S15bW/upMTIsK9U1lMu832j3+M48RW0ScxKSwANLUQWsYNLR4?=
 =?us-ascii?Q?1TxroXr6un59n9QLmfg7mSPwjKmN8v4PpHbLWPuIoIRQXSq/mLOjdkL10A9u?=
 =?us-ascii?Q?e7VDIOKhPP2EZxw9Gb+e/Vp709yKa7N2BNPMHy5o5jQnGNYBYIBQoEc8zQDI?=
 =?us-ascii?Q?UQxoj6Ai7jyI3pNZ1anmZion6wxbpmolMWv9qXTl+5IIw4Jb2lzO+U+MPZmA?=
 =?us-ascii?Q?G/mwy2w9RRgcdVnFyCrmPTYCnIJOQ8lmSQq5MI46doPtEQfPVJy66NEKbjRj?=
 =?us-ascii?Q?wRoGEt4zBTWv8lKkLVKZSNdYxFYWd2bLcZD6p41l/P7nKv3McjRbm34SWG1W?=
 =?us-ascii?Q?/M2e2godbY5FIKrNVWCkn2fAUfY5o7orVuTmJ7yXE1MmB3fKb6id1rBtUY4C?=
 =?us-ascii?Q?xkAYVoGdBzHLnkkIKQe/+cRqicDAdUIIz/J5eTgL+NZLdcaN2n3gIQQ9aMMg?=
 =?us-ascii?Q?jYs0U80ZB4zEfzjVao5ZAXrxGLNKikai/EQGnWvEh8EzZlKN4ul4N48oBN7X?=
 =?us-ascii?Q?fL65+kEkd+Ylr23oTXn8qzU6CJOyaAymf7J+vLVGKi3jEk2nvSeit431rsOI?=
 =?us-ascii?Q?0tIJ6NKNiJH99URs4yvJD5oscjJUo4XJLSO9JrPKP8yRoHi7cm9PxKY+GZR8?=
 =?us-ascii?Q?4COjRViTc6gBHW9eg1VVcyHNUvnWJp/QyOdG9vFWBS6yFxLvrmSQXEy0I0Us?=
 =?us-ascii?Q?5nCmpftRjjdEjzCe4sxHs7EhAsZAH0s93jLQCUhSDC0s0AM2wh31l6dbFfKO?=
 =?us-ascii?Q?6AGnUluey8X0BipgtRoWId+CgAT8tNhBg3/xajot1Y2HbM2C+xeWpAAtBlDH?=
 =?us-ascii?Q?1C9b7OQM6k93zg6lUllx30GpcA71xyatc5p0wmMoWjWdB4AdnFVh5MsViVEN?=
 =?us-ascii?Q?j7FS6z+eXtg0Ym9uVuhQeV2AlrGEEd4v6xvkgyri+SpRgjAzJPJlV5OXxywh?=
 =?us-ascii?Q?FQ5f5PbuS4bfOdWecRXiYRRzClh4Z8O6buvSP1toZ+s0cHVBettPeLMZw0kZ?=
 =?us-ascii?Q?iSg1+g+IXLtVjWYPaaWPCjiAdo0YRjzfJYGMsAkTVxsaskb97McH8Ppb0+JF?=
 =?us-ascii?Q?wKxzPTERphKlpvinEfZjbzIYluyRvpg4hE8A3KwjZRT/m7FLRf6v/E46uJy+?=
 =?us-ascii?Q?+4wi1vemQraquhsPpjKHjREci+hdUiNj5rjRIEcziYYIKpHTLgDjmJcHY821?=
 =?us-ascii?Q?jq79syXeD87xneIRq3VAG9v6Huzky2pWeqODORg5aT0ngvhQ3Y7oyHRgGDtD?=
 =?us-ascii?Q?KbjKqZQbXyKAwxa4pg9o9zd0gYuG7iO3OU/pIiJQpNqXaVgWKKJpNSS6ZN6m?=
 =?us-ascii?Q?wznxTB8SX6vLKbGlaD/OzCyzqs3p7Ooap+8vvla4nuKycvkvvSGJ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac3391b-3231-4adf-c97e-08df2dc0beb5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 09:09:56.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etf0zjVXyrkM9/1pVDgT58QoutaxkPnc0dUWDevPUttvxc0PmQWqjH58vqkFv+sJuX1SbhZ6FM2lxoztD2tNpsQ/DiETy3L51u9L5+cVYeX4JZ/tqCFa9DPZgvxQntMR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB12149

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Fri, Oct 16, 2026 at 12:02:50PM +0900, Yehyeong Lee wrote:
> nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns for
> HOST_CMD_11AX_CFG and copies one of them into two fixed-size
> destinations. Nothing bounds any of the three lengths involved.

Please keep the commit message more concise and focus on the bug
and the fix. The current version contains more implementation
details than necessary.

>  		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
>  			ext_id = *((u8 *)header + sizeof(*header) + 1);
>  			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
> +				if (tlv_len > sizeof(*he_cap) -
> +				    offsetof(struct nxpwifi_11ax_he_cap_cfg,
> +					     ext_id) ||
> +				    sizeof(*header) + tlv_len >
> +				    sizeof(priv->user_he_cap) ||
> +				    sizeof(*header) + tlv_len >
> +				    sizeof(priv->user_2g_he_cap))
> +					return -EINVAL;

Validate the actual destination buffer. The HE capability TLV
is copied to either user_he_cap or user_2g_he_cap depending on
band_config, but both buffers are checked unconditionally.
This works only because they currently have the same size.
Select the destination first, then validate and copy that
buffer.

thanks,
Jeff

