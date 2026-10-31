Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.126
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793469415;
	b=dG++WKFUmml2EA303xFOmBiaRs5feCKRFN3DVg77TsN22JjEEd63mZjdyMpQ6J7Z3J2h
	 JC5gjpxf7gezM0IDnJvtzYBjAEe+t99ohb4D/EifrQJCc4cT1s2P5U7DPBn5AE6RzjCAr
	 BmRHydfAxcp0bJd6vIndve+z3JZ5EP7xUpPLv8vGU1w80zpwMyfp2z9XeHrDXOjTiYMvD
	 P+aJufOGLjYiDd46XczmTvoKP3uCfUGT3rtScmFeX9UtRifHOmjvSjewBN0tuPxjktyvD
	 dCdZB2NilTqXWtP6D46NkZBTjOeNPPQ3es3aRpIl2gAxMajJ1nHH+NyGAUa4PgUWYKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793469415;
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
	bh=l3of9w5CJ8Vj6gtrup622J1b49dadgBL+c+fQkWGRXc=;
	b=jTGih3Um2PBhCquMBljfUi9fjW05tkGk+KEMoi9TqT0NTgm4HjuQMXnVJai0sNnR2xq8
	 DtUBsIFIuRnTW0eT5z78HiBvbkY4RN9LFKHYS/JQVmp9m9SwiK8q/8UtgVLOyZQVnTqrB
	 OblZwWOaNZ/k+oY1h0gi5afaFc4XCKGFPRg0ELujo03lTqZCYMuF+bOcDJpsnUR4rtvKE
	 8iTEXHTvA6jIdZ8MceJ0sN7Q7wTg3pgdS80zsl5ilxcGTiJQua5T6wNEX7lsivN2qngp7
	 uxa3BJvaHX9pj/ld4q412NmewW+uymLYYtEBjPQZufJUipFTMDWDQ5EsELXp5trpq+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=smu.edu.sg;
	spf=pass smtp.mailfrom=smu.edu.sg;
	dkim=pass header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b="P1H/imZH";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.126
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022126.outbound.protection.outlook.com [40.107.75.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349A606A31E
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 17:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6349A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=smu.edu.sg header.i=@smu.edu.sg header.a=rsa-sha256 header.s=selector1 header.b=P1H/imZH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=teDkkkZH9W55Q17s8E8pdQyKp/8Kr9Fn0dn6LdS2Fn5McNUpopAkekVbS9qKtgWuxPO/M1lLnhUcD97hiR2s9J6TyLDih5y+XkJoUjeuUYD+IpdFDXbpelz8rS7tJ4KJolSNFNF10Uks7BAkMB7OcxLPkVcmZx11PGHWdE7pEed3iUDxhoaBjgNeyqvrah5FBa9caRpl/EBqUFBqqYSgVC4WcRg8pYYp+Eka4aY60q6uv+UFH3BZOuY6j4drdoEmyGpOyLMRuG/g+Ul94pWmCg/40W/ZUxY8v8BNKY+c7XKKco4D5PyZ0ILk3lSIm5T2BSYQboPFkMJmhgBvvFyvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3of9w5CJ8Vj6gtrup622J1b49dadgBL+c+fQkWGRXc=;
 b=xPlI3oz7uEzJgrhy8erF4NJGaDH44iYZsn7AMzVHUrI9XZuLFkp9x2d1Jbznj+81U6aifdoazUXsbvlgWsXOixx5gQgZo0zggncWGtW2xiIh2+zhAtVjB4EGKCJKm8fn6ffSjT4lCZ4E0u9R5sDzV2GHpPdVHPJXTWM41aXFX6aayTSfMCJTO73bYn0G7Kz669LpyDFA+cOSzPwNOyKXqZ1HckEL9oSMjdaFhf7t01vy1xiBTfyaJeKr0Ovnl7LFC9V14ou5XGP4vkWkfBRZ/hge9OJnD07zLWYuKZ4rP1l5XDkZpPulUquA+mmUaIPkJ5aVRzS6YKQUjnM5eUiZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3of9w5CJ8Vj6gtrup622J1b49dadgBL+c+fQkWGRXc=;
 b=P1H/imZHAUJ+23d22lTya22G7reO3TtCt9mdreRp8wraaLXIl1wwiDDhb5uwvICvVI4N/O1G6wIaMx9E3/rSUGFY7BfwYckwkHUaG/vdTp0gj9wHhtbCA1eCeU242vYSC5GAC0cpzWwJwgOTfrDYXQgyi+576A02+EOGaQawGqR0vxnn5X+PA6ElGlANOTt5zsDwrjM1/hR36zR7o9FOR57FODUjsHx1oTDLah3fNmCPOX2Fus9TlfzIvxh6xS2OEiPLe1UPIyQgKbV7bjFnNT3YOsOluFrT5YhLzmGewUDhhIdH3RToWdD+Ftv57GmJJ6r5MWyhdOUGa/N+l5Dhdw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b3::11) by KL1PR01MB5904.apcprd01.prod.exchangelabs.com
 (2603:1096:820:125::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 17:56:45 +0000
Received: from TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382]) by
 TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
 ([fe80::9272:a3a2:eb34:7382%5]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 17:56:45 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: linux-wireless@vger.kernel.org
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v2 2/2] wifi: rtw88: check the C2H payload length before reading it
Date: Sun,  1 Nov 2026 01:56:21 +0800
Message-ID: <20261031175621.2228762-3-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031175621.2228762-1-hhhuang@smu.edu.sg>
References: <20261031175621.2228762-1-hhhuang@smu.edu.sg>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:295::9) To TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
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
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4264:EE_|KL1PR01MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fc9ec20-dad6-4359-9dea-08df37785395
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|786006|366016|1800799024|376014|52116014|38350700014|11063799006|56012099006|261009223027099003|261028144727099003|261026121527099003|261021121427099003|261021123027099003|261026140227099003|261022105027099003|261022075727099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ChTBNCDwgTWn9b+SfN+77IZ8VklqzY5FfpHmGl2vKBS6qaM9R+V99bG6ngukef6xbC2D9D4Qca4SwG7zd2yk5F5msW8THiVFkwi0bhawjO8thDVjt8HHsCuRzP9EMRGYmRqPN9M9XiQOXwYRgv9EFaSdkSwv4zgqmC/1KiO9BVnbq5GshXw9AH5H4LPjXLvg6fSVj1fQlFXRqcFTZP7RqJyK0njxrtpsM61z3bWVVogh0HbG2Iw9fjjH7z3pg+I4uFR7DaBuWgUsQUdNOx/vLCGSP2eyDpnqAa99MtAX1tVx7mUVwl8cFE+CnZ2Js8D3E3GiOlwiDQm4iOYD5vyEsaj3cB7yOPMxCNa6/WYlhDKgrTFxwW3YfsmFBUAzQYabBqMGsBEhoi9LdKsaFkr1j5WwtyWHCa+Al9uuwjoHJisSwSXMxAaPIlC4ThkhP6jwmR6shkuYnXu9fGC+/U8tNBFSTkb99YCxayAq+eeqGf37eeUaWXkEwR1g5u5oRVZWNxBQFRG943qwXodFKEvKVBofqy2kWfsdKYgZ8RVZO1wq5Ywe4WYXVaiISwye3jU3o7RShD4pY4x+KcPinVLEYo7qwJs+Okqf5pGVSQ2PyJiAWUMcIv3O/nd4tGFLRtIgi3ltyOPZODQmBfLsSFe6dOL57HQFgWV7gTvPME+Mpp2huc1jtE+FWpyFVQf1uEYlG+06PV70GFzdThCPC3jsbQuJGPu+hxoqwTgxvM6yhhY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR0101MB4264.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(366016)(1800799024)(376014)(52116014)(38350700014)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261021121427099003)(261021123027099003)(261026140227099003)(261022105027099003)(261022075727099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MMoNxRAfSVxFygxHSu7Z/NWUPp+5JVG8REtGIwVvo1Fei0wO6RwxBSGYS9Vd?=
 =?us-ascii?Q?zzq3qhmNJf6s1jsymxvxgMGzcmi2Q+JEEpaXkjxzRIcnG2plQg/+qnwwNPqy?=
 =?us-ascii?Q?V/NTP1Ae1HXBqopq7ujGZhmZEFjgbgKeOWu2TWgvSZIF+bkWUt4f8MnzXWEI?=
 =?us-ascii?Q?9W4ZluI8T7a9eygZSisBBsbhQ/eEMbtNwReskAd/y92KlXbuMyhayPD+u+PO?=
 =?us-ascii?Q?sjbALd0zw2QYylivb7lKAlgGwgNRMb7RkTYbJ6QtctTe53vdJiwUt6OGtXVM?=
 =?us-ascii?Q?3odUgAdnYzBagO08o/URM7jTBzlis18jAOTOsB6AQP+4k3Dx8aqKfbtZwn72?=
 =?us-ascii?Q?nDIktlgzGWSSdNvTRHSkmNEol+HTGkwR/uigv7DlP0DVu605U9BRxxm4Nvxm?=
 =?us-ascii?Q?RJ2oyG2hkpfnIwEzkPNXykciH415CJRVD9RnQA+Inz7Al51//n1zj7rFFMlM?=
 =?us-ascii?Q?a4QJOKkG1BFc5Yy+sdkASqOKvvbiXZAH61HPCDbqWDIHjwHYm4d9Xx3HeyjF?=
 =?us-ascii?Q?UFeWve7HF+OxidrIW3UYbU33hEu/kSBs4zQwH6mgbGw/yZ3EpgXc8NlZD+JN?=
 =?us-ascii?Q?CQWyMv262S1S2Pzn3vfjBr4aJxLk0NrM0FfFs9Yyt2yZPBhafQMahG56YgUB?=
 =?us-ascii?Q?PfoHtaycgSghfwrsFjTgruPNxUou9K+J+HbmLG+8QuuiC96ydtO3FuoGXrNe?=
 =?us-ascii?Q?/W8YGBlBczLUp925Rg3ULxY+0JzHYtP+R4CYqm5boy3daUgHpoeit6XptU94?=
 =?us-ascii?Q?LpuFug5YMEWi99v56k/LkHMgZk5Uk7UbeMVMkbmBvzFu+Ok1CYwYjwFgDpqV?=
 =?us-ascii?Q?g+fabSUjl1GgIEq4Ams/iFcoby7hGgPhqH3Qxha82ER3QY731FcN1Uy68QSH?=
 =?us-ascii?Q?IRg8qB8i+yRLMPpFtUxMVuWjOCH6bPr+yp8HAjrZDoBn7kMCFbZK2oRUp7wj?=
 =?us-ascii?Q?2QoVr+2oxYljMkjHTKK/uLJ2rR+1biOoZ1TDfoWW2r7mnJEv+xYiz9ZkCuz2?=
 =?us-ascii?Q?2M1lmbJv2Kh/0f/T0m0GirQ+nYl5Ho56JyR95zdUoUEhMdoUzWHmqDVOjtdP?=
 =?us-ascii?Q?RVEM3XigHKTHEtZUpgQF0MNQZUOmc3jYOQgKqtXTv35hTSwDZ0XJVYRhmDJu?=
 =?us-ascii?Q?m00FNSD1cYxOpiKxAyOWMsrFmZmxkwaaDaBQw1pYwGcCX4hM+3Tfcdv53i4F?=
 =?us-ascii?Q?Dq+q3ANtP23qqZ2lqe5ncFzyLoNtMow+qJvN9EjYH6HJ417R6Q8UqeNbblAg?=
 =?us-ascii?Q?ZaIxLiXQ8YAwf/ITEpyyX65THdFkvD2UxHZ7TOpn5uj+e/CbOQ97nuKg/Z7p?=
 =?us-ascii?Q?Pik/DnzUesRmLeoMf57e6GTOOMKNE+mGrV+T/exm/uiYSyLMiTmnhMv/gxGS?=
 =?us-ascii?Q?0YMQdfg4+9Bfm2kw51mGEPqXLk4GC91U68r9oq7r7ktsBkw6s5a0xeqAHoke?=
 =?us-ascii?Q?BgSKFhifs1qGnR+QX+1/R3182xSmPUttb4bSP8Zaf0LfYEMWSiv2rg9pnAPu?=
 =?us-ascii?Q?Tdu935VYr4pGJeubL6KFUQIf/eBdV25TCDRfL8hiqQ72mQcd8p1bm6mpqczG?=
 =?us-ascii?Q?8mF7kEnEAkeb6D15ZDYtikigRKXoTLzk5cxUFr4QYWrqlYbmVVn8ChTaD2sY?=
 =?us-ascii?Q?N7vLJstH0cf5wuFPG8AT3VA6ysjxhfe1NMeIWLUu5jYduyCq0skxXcaNdNks?=
 =?us-ascii?Q?wPOt9gvFiVE9gxyniqjEkMwmj0MMc8kf0q9ygNJPauQYgF/lhDH+aU0iKmYe?=
 =?us-ascii?Q?UFuu5HfFOw=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc9ec20-dad6-4359-9dea-08df37785395
X-MS-Exchange-CrossTenant-AuthSource: TY0PR0101MB4264.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 17:56:44.8500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gm4tn/ZAOcdvy9r7w8zGxyprLpbQdeKikL3FR+c76V3xNFzH1G9DeXc2E8CDKL58rgPXEXym2mXIZNjIYx2g5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR01MB5904

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
waiter.

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
 drivers/net/wireless/realtek/rtw88/fw.c   | 15 +++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h   |  8 ++++++++
 drivers/net/wireless/realtek/rtw88/tx.c   |  3 +++
 4 files changed, 26 insertions(+), 3 deletions(-)

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

The HALMAC and TX report paths were only compile-tested. Not tested on
real hardware.

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
index 0a909bf79cf5..6bc684726669 100644
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
@@ -2381,6 +2386,9 @@ void rtw_hw_scan_status_report(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	if (!test_bit(RTW_FLAG_SCANNING, rtwdev->flags))
 		return;
 
+	if (rtw_c2h_payload_len(skb) < 3)
+		return;
+
 	c2h = get_c2h_from_skb(skb);
 	rc = GET_SCAN_REPORT_RETURN_CODE(c2h->payload);
 	aborted = rc != RTW_SCAN_REPORT_SUCCESS;
@@ -2436,6 +2444,9 @@ void rtw_hw_scan_chan_switch(struct rtw_dev *rtwdev, struct sk_buff *skb)
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

