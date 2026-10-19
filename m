Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011023.outbound.protection.outlook.com [52.101.65.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF5488201
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399941; cv=fail; b=fIxxfITmz5oEQX/+gt20e1v/dSYf8uV8nxswPdup8OL0RbAdwopWnHuKtj2oXzV7TLDxJov+Xg1xoBn2Gkxk6YL9/G8kyU9MFW/Vq2DZflp8dL/Az/wpIKfwnTP6r4slMKJQIavKiRDY/jaEyJ4njyJBXRGeRTx7Pt2kj80EfOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399941; c=relaxed/simple;
	bh=fpfqlcOIrhWtYnLSrnE/++dyR+sh1T2L1mAgq8F6Bi8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YggNt71O+tlLEBQmQRID/ePevJ8mtgISUDG+V9oyyzN72t+BpsAqc78sdkEw47UBodJeyeyuQuesDQW9CvwJr08Qo+G9EuIEx2DX3yCquvVTDV4lE8r8rshYTUGJ3oRTLM5Deoto5AKRIWZ5iu5LV9JvyocMJwvZ9Ya/UwcPkcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=GImeYpux; arc=fail smtp.client-ip=52.101.65.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="GImeYpux"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUNG7HRjC8E479n/1On8xapvXrMS34v0fERM8qx+CA2sytaY5OfP4reA0YGwDaxAoOhuA1HqnftcYpIEVdcPP5ALKuY8G4QnZkaUQLDPteEOaS9FQVJuPnnpfJ9DLVGNX2qojuJ+/StcnnA4qzNYtAIBsXmTV2pTABKAJrtjO0MgbiN/XxMOK6lrMB1/u//8OZVWmsfLOfQCX7aSmVMVjvX64ds6Myaug/ncc5PalhE23tQNAlxPViW/B9PwxIl1ZEhTF9Lg/yK+rh9azDK1wUaRbqtZIU7j9gpvNXsCz7NXFazhJ4z73JrTKeFdj7wfpGiE27uiP7ZE/GWd6b4t7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6Fe1IMMLRXlbATTZECh0hjgB8M42dPkSfY4r/O3dVo=;
 b=O5y7zgAW/ZztdnQbJE3iEV+vn2FcyTelklDybygTnsyKtP8e8T0dyhHC8C0Oi83PDC9/WW7B0e2LOYI2bWpkUhXWFxmSFzLCF0CEdudw72HCv7TWsoR1cTcGpNNDiMchV5UBbnIdeK2ncmhpQQWaLBp8I3uLoefso9cKDZAcB3Ge6z9ukb6PLc861z3Vh1TWxAARcLJedv+NAdi8imtuoUsfZd0NXrFhIVSZI3jqrvtW4y5iNu4nLS03pLB5hQsb9a1zdxLck3t/QX/w9VIUhKzn7BTSc0eQ/QhFFajsnEOaCl4YpLLCBdxkciuz4P99B5vg7XAeOOBAj8tpssEBCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6Fe1IMMLRXlbATTZECh0hjgB8M42dPkSfY4r/O3dVo=;
 b=GImeYpuxfpSnVYDmz7V9GZTRqCTPy7Kp9NNI/nv29n8ET+LrEK4pzNy4NzGnOUUFBTQKZyn3NJUjoi3tFRCYB9gnxJuTmBmFcIXlZ8M+a2HbX/Cz98eqsqhsHPQkZjZ/e+p1ic6K5N1MA5VrjUN7nodJpZYOFZuOQMpLP0LvclWHNEkg7UUvPNKv+xtXQseQMpWho8dp+QHzJ0wtKBaEbaFN2WKH2qGBvE3oBur6WFmb1GuIfeGQRdnJs4/6lHEQaR6rR2RE38f3rE52ewfS6pX/mZu8gZVMdZiVM6FfppK3TQml4RortQ6KV9p9xfzYaTz+kGN6iQCsSQav+uVhrA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by GV2PR04MB12680.eurprd04.prod.outlook.com (2603:10a6:150:36c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Mon, 19 Oct
 2026 08:52:17 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 08:52:16 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Mon, 19 Oct 2026 16:51:43 +0800
Message-Id: <20261019085143.3608754-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016014927.434473-1-yhlee@isslab.korea.ac.kr>
References: <20261016014927.434473-1-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|GV2PR04MB12680:EE_
X-MS-Office365-Filtering-Correlation-Id: 72365875-af0b-43cd-cffa-08df2dbe46a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|19092799006|261009223027099003|56012099006|5023799004|11063799006|10067099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DSrmx9/yZSARbglmqDnbtnsqaniI5Hia9J5Yg4KIf2BCvEmhN22leqkxXXxBX4WgeE5eV0mbYfCD03DnXtn8HEowO7HSvxILSpIKxA30Uhaja6amgEJd/wYXgp9Z7kpMQLGcTbNla59JYe9JUxvGcZXexT6ObO/gNmd1nG/7L8/Fs7iddrJEnGMFoLDcX0MoZJgjvmI3URUH+VaC4dzbkCtZBhcCkZN0ba4PTXwIlJSA6RcokZAKmM48J2ZpigALLQAJGuNWvPAPk3hCkVFVO7uMM/3FE2dhE+kt4m3PfrDrsBI5OetvnRH1MIwCEZgPeeIOzMT68eDaZryjnVvhHPW3ua1vuPHVXWJUE7qTveVew79Dew+yAanOqkFbEP6JIiPhWYKPObLwQtu2G7GgIpi63a/U7FWU+QYKvAD5KzmVAnqVVwPBqwSWBpkgPBgq6nxXI3Pi38FIN9wmaNkctwk3vICWC9hbON0MTV9mFkahPg9DPCM5JG+INyVY5KNOynbrufiaF2OfRtOUuzsXCA87UHF6DTuR2VwBmBbrjLXg0buZAuBkWBMsVMXJbHnw6R+JnhQUsgB3dXeWpr9QjerYbVeSLCwZtFHX+aBD/sCVwSYJilv6vcz4nI1HMu6Be0gByUKA2jtT6E3+JhoDd8BbeiBGEXZJnm67X48XRNU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(19092799006)(261009223027099003)(56012099006)(5023799004)(11063799006)(10067099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3BBSC67f0J4lnGWB2nq8eZIbEFwjf2ZI5XACjEvtHmYTT+v2u1PUgaAMgo9i?=
 =?us-ascii?Q?wyBicC6stAiAaE2Y0e2rHfV7+hHPTJMq5ovfwjLO6GdG2xb+w7ZL1G2MDtZ1?=
 =?us-ascii?Q?ODn3a52Bco6s9UD1sMVfkBZFZZu1Ij8vWrL7J/Ug5uh+R3/ci13HtORciyUB?=
 =?us-ascii?Q?wlkQqOeHNfMbzilVlIRsOj6FMHHxTVlPuJ51oklZwFFBRnsHbWupi6dUGL8h?=
 =?us-ascii?Q?tX9VZQu+zZwzoTJG3EjMxtj7HoAyczHS1Kd6YdRUw4pvjyddbnvAxe7soMJ7?=
 =?us-ascii?Q?HOxnyeXjsU4zWoIFLTDf0I0eq9PW4YiGrTjNeFobkoLOE3laK4hpTfDOxZ2Q?=
 =?us-ascii?Q?S4l8Uz8t52TF1rksYCVAbFMne127KNc6eg8BGfXxiV7xj41lvvoQYC0TGnuF?=
 =?us-ascii?Q?4fVkn7zIU7bN4TAfvctXAIj7Vlo5BSOfa58DU048zM1KJ7VRZJGBpIjuTDHa?=
 =?us-ascii?Q?aKUjxXlUXh3W7vMre9/fMc1cmjQ8w/0DYl4OyDrwIieuLSd9knxDsgLzIkbx?=
 =?us-ascii?Q?Y4s9dg/j6qpz7URvwc53PJayPS1z/BtjQjooCf+FpIw5ByYwV1VifKWQXU+6?=
 =?us-ascii?Q?eyS4FTiSAa0N9NHCzlFa/9Dh0GDWm+u1sXTLQfsHmA03zrxYrS7b8fI0FBD5?=
 =?us-ascii?Q?/bgQdKSbb8GWMNcBdwr6IQ9CbwGr/g+mejx9OFnDA4rquIqH4NS30D+vI6zO?=
 =?us-ascii?Q?CK5z8c7cxC2Ki7+OOKV1KtzPpitfhpe9fVtPuWiTlWGB8UzauKAmTx4hC1Fd?=
 =?us-ascii?Q?EV++r/Bl6t3QXKUSeZZOXH92F2dQyIgwE0XsyrANvPG+HW1qpPqdHwbZ2sF/?=
 =?us-ascii?Q?V5KSdjd5AzvdJc87eRMzGNu0yO5dV2JOIT1KKKBTA66JQtwe0GwEkDOJpSPo?=
 =?us-ascii?Q?vEfXH1xZErqripVUcG2Natpwghqt8hN/N6j1UJ0m3xeEgBALKZTb/My4JtiH?=
 =?us-ascii?Q?ppoPIVcfJANqvaSVwaPsxefuwdj26LKmUoD6pNSl1CFE25U6U0nFVqPvPj22?=
 =?us-ascii?Q?uhWXmUer4IlJXPWuwluExz6KIUM8e74sJPsjUlMHWSmcwhUYMyu/6/JlnXE3?=
 =?us-ascii?Q?dBmQyjkleW6RiOquodZZ+1BMeldVeXNBwYdDnF32Xz11lMTcDK1M0ioTAkTK?=
 =?us-ascii?Q?DnhCEYxgqpgKoYvr/ldl5wzxBuMsaWxWTDg5L73Jb0MBtwEgmIcGty57nZwj?=
 =?us-ascii?Q?Ndt3BsLEkboMCj1dOXuh3mENOBqsrUV3GLkR2kbaJguT3qSA09/ox9vEnIhT?=
 =?us-ascii?Q?6JdEaCvbovazu1i67vXk+FYYnJ4QnZwLFa2UDnajywXOdDtwbH7Iz5LtlnVm?=
 =?us-ascii?Q?CcCRyk/3K4i4oLaBAaJEMN55orLDQw/xgtgwCNA94K7p39YQxzrZy/4ISjnn?=
 =?us-ascii?Q?lqD1xVMwWjrX4eFUt7yfmL+Unjak+A6+j1WIm396aB002sPo5pOg1i8aGGh6?=
 =?us-ascii?Q?0Hjw23NsK4bgVVHc5uMDvWcJDblvSXOb3Bf0ye48ih40EdX4TU2UXqRNZCZO?=
 =?us-ascii?Q?hrGhzJRLPMriopEwP6smD1KG0Wo+zal8t7KTjy1QpzdhzQI+dVXDc5gjwoXq?=
 =?us-ascii?Q?NM9oUIfPw/9mQuwjiWzVqqtels9IN4RBlIuB06MKjkGW9csxGEr02LznQXGP?=
 =?us-ascii?Q?C/hkyoOpsHRRISP1jdm0KAV+F9DYVbG6RksJqA4m30CjWXl4wL34rCU+9YYO?=
 =?us-ascii?Q?7JvF3rUfTrhmoiDWOsVocKBUx/JlLFMqjWFl0sUPy3Fg2olRlZ1oOl+fTQIj?=
 =?us-ascii?Q?y+pkitO5X7DKikkSqFoHQTHkOUk9lUvBK52KZwb48+z1How4Xddq?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72365875-af0b-43cd-cffa-08df2dbe46a2
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 08:52:16.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffCdeIdFPjvuBRuFOuSziwKPR1lriJuMW3ydhY/l8YGf0Yu045GwTnxxMjThhBf10xv2G02ce9Mmoug6c3fMj/AdIsZERlz+Oj/f0jUek2oncNyJHN9pu28YvjLC9Sp3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB12680

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Fri, Oct 16, 2026 at 10:49:27AM +0900, Yehyeong Lee wrote:
> nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns for
> HOST_CMD_11AX_CFG and copies one of them into two fixed-size
> destinations. Nothing bounds any of the three lengths involved.
> 
> The walk length comes straight out of the response:
> 
> 	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
> 
> left_len is a u16 and the two sizes add up to 11, so a response claiming
> fewer than 11 bytes makes the subtraction wrap instead of ending the
> walk, and the loop condition is only "left_len > sizeof(*header)".
> 
> Inside the loop, header->len is used as a memcpy length twice without
> being compared to what is left or to what the destinations hold:
> 
> 	memcpy((u8 *)&he_cap->ext_id,
> 	       (u8 *)header + sizeof(*header) + 1,
> 	       tlv_len);
> 	memcpy(priv->user_he_cap, (u8 *)header, sizeof(*header) + tlv_len);
> 
> The first destination runs from ext_id to the end of struct
> nxpwifi_11ax_he_cap_cfg, which is 50 bytes; the second is
> priv->user_he_cap[HE_CAP_MAX_SIZE], which is 54. header->len is 16 bits.
> nxpwifi_set_11ax_status() declares the struct nxpwifi_11ax_he_cfg this
> writes into on the stack and issues the command synchronously, so the
> frame is still live when the response is parsed.
> 
> Do what the driver already does elsewhere. nxpwifi_ret_get_hw_spec()
> checks that the response is longer than its fixed part before
> subtracting, and nxpwifi_update_vs_ie() rejects a token longer than the
> bytes remaining. Add the matching three checks here: refuse a response
> that cannot hold the fixed part, refuse a TLV that claims more than the
> remaining length, and refuse an HE-capability TLV that does not fit
> either destination. A TLV whose length is within those bounds is copied
> exactly as before, including one that fills both destinations completely.
> 
> This is not a claim of a reachable out-of-bounds write. The lengths come
> from the device firmware, and whether it can emit these values is not
> something the tree answers. The arithmetic reaches past both
> destinations, the idiom is already in the driver, and the checks are
> cheap.
> 
> The driver has not appeared in a released kernel, so there is nothing to
> backport to and no stable tag.
> 

Hi Yehyeong,

The analysis is helpful, but I think the commit message may be
more detailed than necessary.

Could you shorten it to focus on:
- the issue (missing bounds validation),
- the affected code path, and
- the fix (validate response/TLV lengths before copying)?

Most of the detailed reasoning can be inferred from the code
changes themselves.

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

