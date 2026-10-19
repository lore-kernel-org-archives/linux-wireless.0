Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013048.outbound.protection.outlook.com [40.107.162.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2C1498E00
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 09:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400684; cv=fail; b=lmNuhsTgtTghsvgtfF2modbzCuSm2L9QCDzGyJcJEbW5b2q76a44BKk+mtKFZb9ACVqr8zxpbmt3qbcqgroqSVPZkM+Apo4vzMRE3ArYXKz4emg+PaW2zfvFspqBMI0nVCaN8P8WRjR45r9jsPAwEJovc84SUD+EDgm6vUU53Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400684; c=relaxed/simple;
	bh=+OUwb9Qeug/zo5ZZ1j/TBF0CxWXbBoq2c9p7C7aA17U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k/rwwxxG7xhDhqakQ70uUmF6k76Y9NxJOUC5xSi0flDiikw6j5nOZLnv/N0khsDfUqlOo6e+Vo8eLtmP3FDq3/KC8kV52wrsCaSkly3/hukYwjnL8AJUEhtHXkuJKADMzNx0u3dGgdSPHp5gZ2CBY+lFdIY7sjQ48AVhJZAqPBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=AsHFPWxZ; arc=fail smtp.client-ip=40.107.162.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="AsHFPWxZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJmWzEF9hIZzdZzgFEO6aHXi/Yo3VczOu1ZbfjkwTXPVhe1GLYPW8jYWM24jAopVywP+EGCinY9MMVU/yjZttG5n+4kvKYe0m0xtWIL3zCklqxfLtLVWzod4/kytDn27Q3SXqgDBcwl3f5SQOP12oXsPrGAbPc1uRZ1VdoLUvhDGzqPSelpVKgZVUppO5w836sDQMVKs2q2fFznDZaQTa3TV9ld/THbxSe2xMx6ndDiAAgVocYdqoy28V1iq4IGCgVKed9Oj8cf/vVVcDVeDazYEexkNQP+TuJhelsfpdEQMDn+zQ08JnTaKSM0ks6w0kwE1v8gQcj9f/djjJFONyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep55xFReHPMn6GeCP5xd9kOnLyUTnBDSmfGDJwPP4ck=;
 b=rbML7oVitmbUgdZwyE5uxSa2M+C3Zc84mToUPAF2EWB6Dtcu6o6ZzGGaGQGqxmZgroe/BQcfUctODZAC/b243IPMh3gTa64S2B4OSrVmRinV/2c+if7loRRu81bosn7+K6pNYWj+azTXm2I7LxKTKb1ERaRhOI4UvL+8//e859Jc1f+Z5dXO+EuAKGp9GlBf1VZ885v5d2hv22qZXNsMuRpvmxOIJhieZ6hQ5I0o8zV4NMUkX/d4PBZy03qVlZgqzu2fUxHhbxSE2sUHLjkce1ZCDDFWT5Vld0R0xlYk3NnF/4pxplOASEqUvsXXXrGXLIVL8D0csuWTTj9xL7NW4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep55xFReHPMn6GeCP5xd9kOnLyUTnBDSmfGDJwPP4ck=;
 b=AsHFPWxZhH8er4injzqf89o27WkdDMm/alq5K/WEScQ0Jix/1ldmTs9ESiCA/vdAl1uArZjWkV/q4nNLcUT2z5a+/uUBt4gLNLYSMqpdZV9dI7Xr++yXVlJEmYyd2piY/LdmFCpdROx8LZjG76qKuKB4pbWlOJeRxOMjKDfRbJj7SMpCZbxbH/T7mffj7UuEsA+OCXb17dWx2HO9iNK5HGkNIcjGydB7sAsj13rCgG9Qa19o6CZX83YVJQeHIe0Zky5cIjWNxNvbUaMEPhFYCk5NE2KpwMkWVAFcRR4EshuqEpQy/6btCR/warbZyZnjGlpOMEkjnKtp8Tpfq9WR0Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by GV1PR04MB9151.eurprd04.prod.outlook.com (2603:10a6:150:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 09:04:40 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 09:04:40 +0000
From: jeff.chen_1@oss.nxp.com
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: Jeff Chen <jeff.chen_1@oss.nxp.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] wifi: nxpwifi: reject a NULL command buffer in the 11AX_CFG response handler
Date: Mon, 19 Oct 2026 17:04:11 +0800
Message-Id: <20261019090411.3609086-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016030251.690780-2-yhlee@isslab.korea.ac.kr>
References: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr> <20261016030251.690780-2-yhlee@isslab.korea.ac.kr>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::12) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|GV1PR04MB9151:EE_
X-MS-Office365-Filtering-Correlation-Id: 13e781ba-48d1-4d7f-79c9-08df2dc00197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|376014|11063799006|4143699003|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0Tk5WmntEfRCZoHZiDBWfYJolE83mKrZ6pkA+uI822r3Fw5U2wqhGaSKhAQ0wJtjLGdDvX5uv9ydc76MRw33UmRWDD2id8KkKO6Z4tQJaKt5KEMmJzyWVNaYBdyFCpIpOBB96qO5yT+Joan4r8wVnPRQRhz8Q6Vh+bBwfgEMxmycKQqqQZbAzZMBcXMZjft15JCkIFjwuA85Rv+4xqC/PhEK4Fba4HQsj9T9bi5g0w7XgTg38iaaFLXAUXmF+N/d030E4lQ4Ysddp0j4S/DGdB5wvgI+3QlytGcE2JWbVXzeXtCzUXfxhTYBlU+PMb8QPo/emsF47MriX5lELVNZ3HEaaDJ9SEy2eczfbbwhHKZV+5we7wcXwqE4vnkvGvHMZlxZjWCgZITy+aIinfRuiqlvpPPSxZVRuoE5teTsYkw/o3cXQXiPeZwRbOkqI9wBuHchf2ZBc5YwF9+zW0beo/577gn67m1O+cJu7CWgKVeVkuHn7ibmTz8ADcFUQLYaGYyBnxnTuRQPn2vduipHZzLArMzgdyf60wCmqv0I4crjNQrQM/0s0AQ1fEQUdtS4HMra81wLCrfjytWjz2w911J/fID2cUcdwQHOQHvXHpgPI40oQ/oegffa3zi3NjUyajSfSx2q/qE/Ajv7lMWF7eSbns0R0BaUDGsygh1w1+U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(376014)(11063799006)(4143699003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p8ogRp/WQpI58+BrZCSGSDk6PvuFvf3SA6cpxgKBH20XMe5hLjthynmeeOD4?=
 =?us-ascii?Q?ymdvnnk4Wx6ZLS701NAoivObe7SJv5B8lLrslTsUKNfvibOgJ1uanZshS31X?=
 =?us-ascii?Q?j2tTx+ZuDz3Olv6vuHT6qZQLooWElo/DEpvYCSYDqunUjgrvMCmmVhwHmzQT?=
 =?us-ascii?Q?clXdtYwXSmSjVj8BCCpYOcNgRqff5tdNrxVEGP7BmeUlaCbu8f51NXI68bfI?=
 =?us-ascii?Q?z+7fGX7UvLKPgH0lW6JdS8PIRr8pvKVUpfA9uwkhzg4JcskAzLrV9P1a6Cp3?=
 =?us-ascii?Q?6PVguBEo8l9+cM/LhD+mynjTS+llahJuZETVVL52rqNtjaNTWWETnxhyk93z?=
 =?us-ascii?Q?gSuRE0E/VwBgmOoZDuMFquUseECoJ7XmnRpwKxzCi1Cc/P9303KIY9BoF5Z1?=
 =?us-ascii?Q?O4AetnCDkUEDp9DK4L9Fz2hGBWahO2AajonCm/gliiqviRyfitNwTbrDfH7g?=
 =?us-ascii?Q?mAl2jRDx15g6GFaLXeNbGKY73S48u14b+AtoByOXtuh6Or/hFy9ahKGSfpVd?=
 =?us-ascii?Q?2+qsuva0CpvZNrIDat+VKbbggQnsPemEfPfl4jRjw/LWES/sV7lQdEE06/qn?=
 =?us-ascii?Q?DXTAiZJibUdTXlYzEKa8/EmmaAd/1cO5dD18/H896z/MlcKNXiCv8+FuqKOe?=
 =?us-ascii?Q?sMNcBGoZfQ+OuqCh/hUCs0ZB5MmscITbOLlb6+CODxuvAnDYO98M1Yg/o2O7?=
 =?us-ascii?Q?ylmsNlbQlTkspN4WZX6iP9BUoWc+806Z0ZgRjEzp1TGAUy0rP0o4icxeciW3?=
 =?us-ascii?Q?EGSqunWdtQGgVb50l5erg7I2pMqNJKo3NrEnVPdAQu4A5L8x/54zX10MY3oJ?=
 =?us-ascii?Q?POnqlPD8Usze30eDMPTcbiQ9P4hBwdnevv1Nw2h/Vq9hJHsizrG6VrA5+6+M?=
 =?us-ascii?Q?JfAkZH+JMBHiOnhdwz2s4s/6LrOtB3U4VYlc3ghWZor0zovKfA5BBIFDZttO?=
 =?us-ascii?Q?dOV5o3OsbkMkxsmVA07mWEbILZ1v9PkPsw/3UHVzg8kwHUEQmBEC5Llsx87k?=
 =?us-ascii?Q?odl9EPA92U419RuqJlQUYSsKDSr4reCqQUmP6oKL4Rn5iRE+LvzUvd9UVrnp?=
 =?us-ascii?Q?WJ/3Md4v7zEDI6vBlLXlWyh4n6fMyln5nakUTzM+IzgHdt8+yuip6Ms/Xtd6?=
 =?us-ascii?Q?JhlYQU8gsHNFKzIZ7A57pjF6jKgaqfDCJKXp3p4T13mwFYoCdEQLgY1C8VUc?=
 =?us-ascii?Q?sbSVeEkFkek8CRI3maryx5cmMnuboJVrvy5fpLyGuzG7YyFtoQIdhd6WT34W?=
 =?us-ascii?Q?1nIY0AwN1qyQVq6FQd2TFv2Rzs04rcUxtUjazxr47d3UoZ6wyCVfPiB3XpvK?=
 =?us-ascii?Q?vHqYCaJqjt5KpwMsFytY053PL7v8RS1z1CHd/bjiubRziKuP+vXO7kVViGyN?=
 =?us-ascii?Q?EJbgEQ8GTYU9AkgpCuRhgwhDsd5zcV4PdSoriO7S4ttdZIRnHtD5E6OY1WdH?=
 =?us-ascii?Q?B8Db4BkArYnJuHYV7T1NPxXkZ/aovff0aFBcpIY6TBwrvbvbM8RzkwMemLMO?=
 =?us-ascii?Q?zlz3L8QKuH87j/Wm71OSgb6QhR4so5Bg6RYxrSpvB5RBlQ7cf5Z4znT7gBTo?=
 =?us-ascii?Q?CXOV/M1ERZIKliveYeOGCeHy6nS5BrBVUzbipU3TLDU7SCLiSZnNE8kEGqwa?=
 =?us-ascii?Q?V+rW4xINmBIRZ1bEqHgSLpvRtRXgbkDgYc2QR0yJrtr+i/j/Vq2f1PuhsOH2?=
 =?us-ascii?Q?rAPBLnVrJFPd7sI121uDz3J9tDtlnUgOfEAWsYhIjFV5jnXm8ctST1kHTd2c?=
 =?us-ascii?Q?LkfpCFk+vwaXCUjh8RGJ6pr5/WQtAiHCOwID/EGIuwE4397ZRaM4?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e781ba-48d1-4d7f-79c9-08df2dc00197
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 09:04:39.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0EtQ1hzbPpNtRemWZQ0OPKxus5tTOKn3WFqr67Xg2OGEKDOPsgDW2TP6qc5+4cwn0TyNAdYyusyyTaVNzDqmTdMWY7KXb28nZ0uakgo9WPKRKDkCYbkR4Yud17ZD575
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9151

From: Jeff Chen <jeff.chen_1@oss.nxp.com>

On Fri, Oct 16, 2026 at 12:02:49PM +0900, Yehyeong Lee wrote:
> nxpwifi_ret_11ax_cfg() writes the parsed HE capability through the
> data_buf the command was issued with, and never checks that it is still
> there.
> 
> It may not be. When a synchronous command is interrupted,
> nxpwifi_wait_queue_complete() detaches the buffer because the caller is
> about to go out of scope:
> 
> 	/*
> 	 * The response path writes through cmd_node->data_buf. The
> 	 * caller can release a stack-allocated data_buf after an
> 	 * interrupted wait while a late response is still pending.
> 	 * Detach it from the current command before returning.
> 	 */
> 	spin_lock_bh(&adapter->nxpwifi_cmd_lock);
> 	if (adapter->curr_cmd == cmd_queued)
> 		adapter->curr_cmd->data_buf = NULL;
> 
> A response that arrives after that still reaches
> nxpwifi_process_cmdresp(), which reads the field and hands it to the
> handler as it finds it:
> 
> 	void *data_buf = adapter->curr_cmd->data_buf;
> 
> 	ret = adapter->curr_cmd->cmd_resp(priv, resp, cmdresp_no, data_buf);
> 
> The handler then takes the address of a member of that pointer and stores
> through it, so a response carrying an HE capability TLV writes a few
> bytes at a low fixed address and the kernel oopses.
> nxpwifi_set_11ax_status() issues this command synchronously from the AP
> start path, which is where an interrupted wait comes from.
> 
> Check the buffer first, the way the other response handlers in this
> driver already do -- nxpwifi_ret_sta_802_11_snmp_mib() stores only "if
> (data_buf)" and nxpwifi_ret_sta_reg_access() returns early on
> "!data_buf".
> 
> This is a local denial of service: it needs a command whose wait is
> interrupted and a response that arrives late, both on the local host.
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

thanks,
Jeff

