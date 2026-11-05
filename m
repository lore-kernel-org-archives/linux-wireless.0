Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.126
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793883625;
	b=R5mS9FGk6zX1OIch/JHMBHq84RHkHdhFEnDqC8mV4Y6NDmxNeA3EZm4XiBA6jRC9ZAjb
	 HB7s/VJmdYoWnJz+4dwnib+l8JS2GR91Q/HgcSS67cNxZ7TA7BP4i/2XGFt1mjKbulWDF
	 vB7EZj6EjJn1K1fGiTKjUkIvSWW1HFm0B9+0QqJ6nI+/ukZSyJRbKVJMVjE0/76l60dNZ
	 16heNrdowKhANHKu6DW2Z2HcRsjS0bULpz5xTfGlqoXwdQg3P4AlsL+3viaSy9ol/j0lz
	 ejuQ0Khk78Of/yqqNmXGurONSM5X5JSMXioVfiMyDcJgjPmpUkTD85X+Ii5e84bcbbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883625;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
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
	bh=wf295+xeBmQtQWHxjPpqgD/KYd88z00kxccDSMICA3U=;
	b=zVo4jGp10lQiw+raCzbAAq/dE/QVNahSQphgQ1/At140jk9R4jySdOvueqNfRKm6o7WZ
	 CeG2W1ybUAhEl4AWlDZOXQIMsb6Yid7Pt/8IhnXEswrf/G9fiSm8YQt2AlzwUNPMML/8D
	 zhHKdpegAPlPHHPj93dScuPXYUHphptbR+79a/wibREFmj4CrspAzKMnGm5uqL6KFBJeS
	 JD53gsqeZcTZ8M56iAYWKLcLbKD5YRomS4KJWCaV0Hrm1O6i8X1CAkoX3sOSJr3kk/SvF
	 6ZVIC2NCXmGyw3kl3D9a9nCu1K/2Z20nE352uLyfi7Z9nj/sCEVYoC9WQPrSUEifQ2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=UyQDZIvv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.44.126
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023126.outbound.protection.outlook.com [40.107.44.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88D9606A330
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 13:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C88D9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=UyQDZIvv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pv4D7CWC8Fk6zoBug9gSz205uv4id+yjBRS/iNzd2nDRAZkGuL2nJsHJksuI7j3oXU002bhpc7ShS99e9hpWRT3PRemHIprfeA7KQEWDEk+trp3xjGsl/iaJITPco3KCcSG1MULaMlPm68Rqx/XcngIVjm0Ojuy1nbgUq5be8zKSIgKaZHuQN0lsGW+yYhYTNOwR0xo8zOF8eeDrd6Mkl/R8wOxp8tva8Uw9LKjo9jhFR2XKg1J6xrjX9gCDa8hCrPZFVZCKRu5A1Q6Cvaqw94BTcFJVckGRfK+cJK3jQvUl42NMXALpDSsoG7cbXwMtkNv26yMVjI3PJcR1E/TQ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wf295+xeBmQtQWHxjPpqgD/KYd88z00kxccDSMICA3U=;
 b=ffDLQxNdhaHPVDhQIIVqFIUD9WlOSprbMFAvSL/rl335U9W8kCgk1J9caBc2RmPVDz11q8Ndd1J251ycXMeEDo05wb0Qp3MLHmATTSSb4xgWN3SNN3jSnZqYG78hm3Mpi3vZcb+iome5lsDHm2KXdDSPIIMGusSa7O8FRJvyVjlixYseuc4wMZi+TZSVSjLXw2W+pWnO44iOTfGEvUuTDKggc/G1vGvOYD1iynQcX9I08OBJ/WxgjT+5q4RKMf2FFt1rEe2/+YWxIc2GEyjeAtYVSKGwGFGSmW/2d1STuC3xilChLTZLIKTR+2ShsVIdZpZrMhTgGvMunMmwtThsMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wf295+xeBmQtQWHxjPpqgD/KYd88z00kxccDSMICA3U=;
 b=UyQDZIvvNavjOibzKJXHcXsBob5g/H5ScW3orL1RAthRxMvbLUDEvAgntdJxraqLa+gIthC2aeofkHPqeRcjN0EApuwGyWxGDWVTtGi8Tw7WmX+tl8BA/gLXcn4GOOxc5CYPGGmcuc+5W4pTUroZvn6NzI3lkOi0QcxQhTuux2VVYKSue9D68pQTHY3PJ2Dv61tIEP5EFCCgVHLat4GG16cW9Raa5sJEsfx8xZrzezGnAgPe50ZTqqj/zQJvJZa+AgxkTOFmNFy67Hv6bMZevtKv17cSpJkTuSkctm4K+CGB9vsM2ZFwdeP2QgjDUIBGG22mge1EjUCzjm/aCpsdQg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by TYZPR01MB6097.apcprd01.prod.exchangelabs.com
 (2603:1096:405:72::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 13:00:18 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 13:00:18 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: linux-wireless@vger.kernel.org
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v3 2/2] wifi: rtw88: check the C2H payload length before reading it
Date: Thu,  5 Nov 2026 20:59:55 +0800
Message-ID: <20261105125958.3891196-3-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105125958.3891196-1-hhhuang@smu.edu.sg>
References: <20261105125958.3891196-1-hhhuang@smu.edu.sg>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11)
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
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|TYZPR01MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc64e00-6026-4586-7941-08df3b3cbdf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|786006|23010399003|52116014|366016|1800799024|38350700014|261009223027099003|261021121427099003|11063799006|261022075727099003|261021123027099003|261102123227099003|261022105027099003|261026121527099003|56012099006|261026140227099003|261028144727099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RvMn0+3MZjXXAZ0EUBp0d2EBZuXX5WG9ymS48gOb784KEgiN9cRkNvaaq60+wdJ6tXxqlpCNu71BsrFQYqiyHie9CRqTYy22Y+XIUT4M/5gR5MoJHcvtrnXuA6iDyHLYWAJ0eHMjEV5DHJmw7/6APoJA4W+NUzEZWlxINmPoi6gHJ9J8UUfZuLAKzt3T0WfaOf9FWX/7/Ks8aojk6B+TiSKYUejwXNM2VlTNBHQlFLEAyD+u31V43jyxJ8eoGE6dbDNBtswd+hewc13CooC3sGjO4W1ZXcUWZtyVxjM13HBVDY/H39NmTc/BHvGWk93As/BEDuTyQgGysZ7BPypguCKVPaCXdO7eCUqPs2fjTic22Cv9et823W4SLCjL5ayhHDokQ/Tr0M2K5CYCBZffVmNVP5CuNYv7FXHztbuPByXZ+FDgpBHpKlCrcfsvI1nRng/cDBEB58QWvlCEiwJq+c7CyZkubhJ8LIyII6h2FTJoo2c6Igo4oFcZ2hKwzBYBEdyZQnYJz0iRY2g7AclBwzBeW8NAfp1qnr8lGMYZlnTQfKNA51EnIvVT25ViflbqIW2pzsEdzptkxqKhWRFgKC1PjKd7zSAMzZQ9k5gkGH9ZnDN0eyDhApnboHZz1ZizjxnlpiC8rOB8TpoQ8R+cQWr0EX9ztXnYFTIW4TjViD5zWBCFiGTZ4X9IYgsxltIybp8eT27cbd3HjY/UPch8LBggP8Lv4ElT7uvMvucozMA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(786006)(23010399003)(52116014)(366016)(1800799024)(38350700014)(261009223027099003)(261021121427099003)(11063799006)(261022075727099003)(261021123027099003)(261102123227099003)(261022105027099003)(261026121527099003)(56012099006)(261026140227099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T9ANJsNcU7JGSOLs7yOzdrWaYDDwGFES+PajqU3D7woaeDnbizuJnCVPksz7?=
 =?us-ascii?Q?JvpdImGlI9D9Z22Yb50DzoCLmTcDI168UALu/rC8EvkgsEZHFv4HPy8aI/6/?=
 =?us-ascii?Q?X7giR4Y9O6BzjA+WVYESnuYZNFbepVIV2McIeGxY2jqJmg3olY2RIgD8+6c9?=
 =?us-ascii?Q?iwHFwUXbdChO3q2KSdRI9J6zYREao2U/vy6EIFgia4uuEFBpoJG8RKqW+4e/?=
 =?us-ascii?Q?ekkN2sj7dwBnZtMFtEVzTp5EyKdMgDBb8AW41mH30tbdRf/AHBM7krsmbm0o?=
 =?us-ascii?Q?AAERuw/qAN8I4/BaO5FYOp4JGDzqrAoXhb+4HD8//18MdFcidlILHh3kxqjL?=
 =?us-ascii?Q?dA0ozllALeLbP8FCkRXJNdSQaT/VaQw9fbrsyd8q7HSB/W4zwrtFS39WCeDC?=
 =?us-ascii?Q?ZKHNCsmgB96Uc9eYdkWMO1kx6XoNF4KqGBO6usMpijJf8XYKQ+ExWTf3bT+V?=
 =?us-ascii?Q?+Vp9lq6DlddZzMxPTvMook6ycuCA2BQxhU7V5Tqxxt0qP9Ey1jQhjH/9DXc2?=
 =?us-ascii?Q?8upP5uhbsuKarxjqOzBix1wl2zQRMpo0LBlfTYvJ2je1oI6ai9kZ7QGlbAr4?=
 =?us-ascii?Q?SkR5U7s18xB6obqYhE9cqtAxy2jfV4VomwzSuL0B7NvZvceu563sfdFpmwe+?=
 =?us-ascii?Q?DDNO0/iSVtXKN+c7K2mpRWJmf8t/ynQ/t9WsQPSVym4aDdmFZF/bhjHSkeic?=
 =?us-ascii?Q?sElCO7D4mghMAYJhRTDs7cr/S/wYnJqwioAA1HLpYwZZh3uTPNMDosPqsp8N?=
 =?us-ascii?Q?5DPaC/4UHY6z4Qpa5/QI9URA9ct8Vwlobnj6p/QaIqjiNB3iTro5zA8z9PTC?=
 =?us-ascii?Q?is7fmAIFPaga7n6fOhAftKZPmtlRWp8S5M4hzuGRA+j01u/dLduDWRnACOTV?=
 =?us-ascii?Q?JHBakFQt/hLQmr48G9K0Cm+UaVGjO2iCUx5MXbf9ro3ylgUoW4w8kPxWjOh4?=
 =?us-ascii?Q?WpIccqjJOBFSpDailpWKTlkVChrLMEGu48AT8YGC6QVNmNJKrITcpk7/iHxA?=
 =?us-ascii?Q?99aYL6X0JjfwQlo3NlDShcD9OxN3W12V1fP3thkYa2j/Rag0SkiMJUHWZ8Mb?=
 =?us-ascii?Q?8OIpMQxc2xGzMBTbfi9GfxktZbC2Po5lsiG33X3ZhgNkXXX0e52qK3hK2b6B?=
 =?us-ascii?Q?UO2K0mvfQkcSsDh0Fk3BGlmLrg03Sol/yYVfany7phJfT5fOCN/AxEjKp99r?=
 =?us-ascii?Q?ncdlbkvA8ABrAtCUlDSJgYfF2rYmXN0OS5PUDLcsFOArE/3Pgv596kVJMeyl?=
 =?us-ascii?Q?FWPk9Ql8moFJCs7R1ItlYAZ2r/zQBoFAhFJgjBQ5CtfV2AcfAtOsXC5eXE8d?=
 =?us-ascii?Q?pBP1y1xI5P0Tu8TRI+EhXmEiF5ZxjMXofxFpcKCwAsWNsrxCnaWxORmeArzc?=
 =?us-ascii?Q?Q60nGcFY5jnX1XPB9MZ2weCy0h0BOAMgRaBgrSyuWp1JwHZ6iBYYny6bytel?=
 =?us-ascii?Q?Yfvr5P9ZSY3ra5HEvikQk0s7TxS3q1BUqialP8UnOl4M9gmLlN6yzZ6JEz8v?=
 =?us-ascii?Q?XiAF7ScEVaAFbSSi1gNyy+Be8ARZPX25pQzlsGvklngld4WObuaIRgwSd/0Y?=
 =?us-ascii?Q?U3K+Ru/CywTkU0TFjJzXM9H9KG43t4LNTtgS9kgD+7UkIhOii7Q3aG+fHKGC?=
 =?us-ascii?Q?t/+0U2MFJ2qU/IMf/rn3jdKPJEaLIvwndKcVATx5io2MQIe3yVqgdXBCuj7U?=
 =?us-ascii?Q?fCgigcF2cfefZ2aa5XMMnjLTqhVEiM6imfRBSGxX90kdRJFKOU89JGAQJNPN?=
 =?us-ascii?Q?uMgXJMNqcw=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc64e00-6026-4586-7941-08df3b3cbdf0
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 13:00:18.1897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqWhDo/j9Zx98rqZ28sJP7GqvgFK9l0HLJHMfbdWO3KqSJU++XguYYE2cV1cp808eCWy+BW/6jEBUjrzONtYsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB6097

With the previous patch, a C2H packet holds at least the 2-byte C2H
header, but its payload can still be shorter than what the handlers
read. These handlers read fixed payload offsets without checking the
payload length:

 - rtw_fw_scan_result() reads payload[0];
 - rtw_coex_info_response() reads payload[0];
 - rtw_fw_c2h_cmd_handle_ext() reads the sub-command ID in payload[0],
   and rtw_hw_scan_status_report() and rtw_hw_scan_chan_switch() read
   up to payload[2] and payload[4];
 - rtw_tx_report_handle() reads up to payload[6] for C2H_CCX_TX_RPT and
   payload[9] for C2H_CCX_RPT.

With a short payload, these reads are beyond skb->len.

Add rtw_c2h_payload_len() to get the payload length of a C2H skb, and
ignore C2H packets whose payload is too short for the fields the
handler reads. For C2H_SCAN_RESULT, check the length before completing
fw_scan_density, so that a report without payload does not wake the
waiter. A short HW scan status report is not ignored but completes the
scan as aborted; otherwise the scan stays pending until something
aborts it.

For coexistence responses, this only validates the byte inspected by
rtw_coex_info_response(). Length validation for the queued response's
GET_COEX_RESP_*() consumers is left for a separate follow-up.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Fixes: 4136214f7c46 ("rtw88: add BT co-existence support")
Fixes: a853d234e179 ("rtw88: notify fw when driver in scan-period to avoid potential problem")
Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Suggested-by: Luka Gejak <luka.gejak@linux.dev>
Assisted-by: LLM
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
---
 drivers/net/wireless/realtek/rtw88/coex.c |  3 ++-
 drivers/net/wireless/realtek/rtw88/fw.c   | 17 +++++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h   |  8 ++++++++
 drivers/net/wireless/realtek/rtw88/tx.c   |  3 +++
 4 files changed, 28 insertions(+), 3 deletions(-)

v3: complete the HW scan as aborted on a short scan status report
    instead of ignoring it (Luka).
v2: new patch (Luka).

Tested on rtw-next on top of patch 1 with a temporary KUnit test (UML).
C2H packets with the 2-byte header and 0 or 1 payload byte are passed
to rtw_fw_c2h_cmd_rx_irqsafe(); the byte after the header is set to a
value the handler would act on. Verbatim KUnit output:

  before this change:
    # rtw_c2h_scan_result_no_payload_test: payload_len=0 scan_density=0xab completed=1 (want 0x00, 0)
    not ok 1 rtw_c2h_scan_result_no_payload_test
    # rtw_c2h_scan_result_one_byte_test: payload_len=1 scan_density=0xab completed=1 (want 0xab, 1)
    ok 2 rtw_c2h_scan_result_one_byte_test
    # rtw_c2h_coex_resp_no_payload_test: payload_len=0 coex queue len=1 (want 0)
    not ok 3 rtw_c2h_coex_resp_no_payload_test
    # rtw_c2h_coex_resp_one_byte_test: payload_len=1 coex queue len=1 (want 1)
    ok 4 rtw_c2h_coex_resp_one_byte_test
  after this change:
    # rtw_c2h_scan_result_no_payload_test: payload_len=0 scan_density=0x00 completed=0 (want 0x00, 0)
    ok 1 rtw_c2h_scan_result_no_payload_test
    # rtw_c2h_scan_result_one_byte_test: payload_len=1 scan_density=0xab completed=1 (want 0xab, 1)
    ok 2 rtw_c2h_scan_result_one_byte_test
    # rtw_c2h_coex_resp_no_payload_test: payload_len=0 coex queue len=0 (want 0)
    ok 3 rtw_c2h_coex_resp_no_payload_test
    # rtw_c2h_coex_resp_one_byte_test: payload_len=1 coex queue len=1 (want 1)
    ok 4 rtw_c2h_coex_resp_one_byte_test

The HALMAC paths, including the HW scan status report change in v3,
and the TX report path were only compile-tested. Not tested on real
hardware.

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 37c336def419..e2c91efc529d 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -643,7 +643,8 @@ void rtw_coex_info_response(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	struct rtw_coex *coex = &rtwdev->coex;
 	u8 *payload = get_payload_from_coex_resp(skb);
 
-	if (payload[0] != COEX_RESP_ACK_BY_WL_FW) {
+	if (rtw_c2h_payload_len(skb) < 1 ||
+	    payload[0] != COEX_RESP_ACK_BY_WL_FW) {
 		dev_kfree_skb_any(skb);
 		return;
 	}
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 0a909bf79cf5..18d3689054e6 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -96,6 +96,9 @@ static void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev,
 	struct rtw_c2h_cmd *c2h;
 	u8 sub_cmd_id;
 
+	if (rtw_c2h_payload_len(skb) < 1)
+		return;
+
 	c2h = get_c2h_from_skb(skb);
 	sub_cmd_id = c2h->payload[0];
 
@@ -376,8 +379,10 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
 		dev_kfree_skb_any(skb);
 		break;
 	case C2H_SCAN_RESULT:
-		complete(&rtwdev->fw_scan_density);
-		rtw_fw_scan_result(rtwdev, c2h->payload, len);
+		if (len) {
+			complete(&rtwdev->fw_scan_density);
+			rtw_fw_scan_result(rtwdev, c2h->payload, len);
+		}
 		dev_kfree_skb_any(skb);
 		break;
 	default:
@@ -2381,6 +2386,11 @@ void rtw_hw_scan_status_report(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	if (!test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		return;
 
+	if (rtw_c2h_payload_len(skb) < 3) {
+		rtw_hw_scan_complete(rtwdev, vif, true);
+		return;
+	}
+
 	c2h = get_c2h_from_skb(skb);
 	rc = GET_SCAN_REPORT_RETURN_CODE(c2h->payload);
 	aborted = rc != RTW_SCAN_REPORT_SUCCESS;
@@ -2436,6 +2446,9 @@ void rtw_hw_scan_chan_switch(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	if (!test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		return;
 
+	if (rtw_c2h_payload_len(skb) < 5)
+		return;
+
 	c2h = get_c2h_from_skb(skb);
 	chan = GET_CHAN_SWITCH_CENTRAL_CH(c2h->payload);
 	id = GET_CHAN_SWITCH_ID(c2h->payload);
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..6713dfac8c94 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -810,6 +810,14 @@ static inline struct rtw_c2h_cmd *get_c2h_from_skb(struct sk_buff *skb)
 	return (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
 }
 
+/* The C2H header has been validated by rtw_fw_c2h_cmd_rx_irqsafe(). */
+static inline u32 rtw_c2h_payload_len(struct sk_buff *skb)
+{
+	u32 pkt_offset = *((u32 *)skb->cb);
+
+	return skb->len - pkt_offset - sizeof(struct rtw_c2h_cmd);
+}
+
 static inline bool rtw_fw_feature_check(struct rtw_fw_state *fw,
 					enum rtw_fw_feature feature)
 {
diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 701ed7c4f3f7..ddfddd7cb4db 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -241,6 +241,9 @@ void rtw_tx_report_handle(struct rtw_dev *rtwdev, struct sk_buff *skb, int src)
 	u8 sn, st;
 	u8 *n;
 
+	if (rtw_c2h_payload_len(skb) < (src == C2H_CCX_TX_RPT ? 7 : 10))
+		return;
+
 	c2h = get_c2h_from_skb(skb);
 
 	if (src == C2H_CCX_TX_RPT) {
-- 
2.43.0

