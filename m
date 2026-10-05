Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011038.outbound.protection.outlook.com [40.107.130.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308A51DAF1
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220715; cv=fail; b=BO6SwDiAqy2LrpcEMR1am2Koqhs1cJf1IwLDy1k6q0q586N7SuMWFqTlCtvkNlypHLPBGK263A6Ki6rHPvHV6XcVI/lGawCUKk3++qZaikRoYdbYcuupGzOZlMoe1idTdzFc70CswMnm2EccK0giU+5xwYanW8zagLGujznpVrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220715; c=relaxed/simple;
	bh=kKZq2N8wcB3jg1SbhLDDazflymTfSZbJogLdaI5xpjg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=h3JXQaNQqsOHeyyXITvJPPFt+tH0xDr62ZcSy53kp6P3LDRxV7L3yWR/OBQkj1XZf04gcyloRydGLo6rSkX99CBKw/m8TOz/SGOd0/MjaQXHEujNsWyVre2BqNJHMIGGNtjloI8UmpNhiUjcroDGh1NgshVo523e3aU7w0S8cO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SndbaH/m; arc=fail smtp.client-ip=40.107.130.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SndbaH/m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJ8bvCn/+F8ZNCqIymPZlH4zYUxW+YtVip5Dfq6AbvpriwhNHitqVW1md4Rd52+qAkuXnQOCfqPOEgmH529oaKTHZKaW39Crcacr508wDp95W8SgaqeVr4hFDW1qAJ7tCsZXkxrt5s7jS0hrb9sBoMeQV2005ZH71aMi3wUTnpRyx51NejH8dP1ttypVR9GvNpWJhLCDUi/TVEUb+l/q5oM90DrEhm731FscDI3GV+jrd6J4WC0fkevt+zok5nBK9Ck6k2CKO2DFE1AvpS3TFJqm3/EmAHpsb754jYAxF8mAFz1lAVOfJdPGUgTm5ikjcvgwOOKuBz0N5C4CQIuuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zLjMPFClnUfSAFfylP0Ax1mpqf+PmBT5H+XoIYSaVM=;
 b=J9N05SjpiY6ty2vYETUaEysmntQ+AYKxsUO7r9/P7+K41qfPspx2IRKfmBhK9KAWte+nSo/yFfMXPno9/4JkQ9wqLEHTe+YO9dgtAA1YTYeN43wUHU5qAVrihqMuzM9hvFzE80re6LUzyF0DDHj9d2H9wh1lYT//zdjdC0/G0zWkZn71tFvaR3uXM3takssBiad2Hli9Xy0iF5gZ+B9vxTPNsmH8d/eVzfSWhADmFfqk+lcUjXxOiqDQBIK/MUbvTpCcMmEJrVHPksJXIoh+IrR2l8o4v61iBNaOOeNQr8jRP2uGQoXnlKhWbGBdkp63XjcI46QVwkYHbDGn37DArw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zLjMPFClnUfSAFfylP0Ax1mpqf+PmBT5H+XoIYSaVM=;
 b=SndbaH/m8nuVjIGYht3Eofz5ffu5XaC2cjkxO8FLqJn4Qjlan8tf0oK1vRkUXFXjjRniUQqae3sTSpiMDTHfdcKzdK7yljax/+ZcXXcIEFG7nzGui54zl3R/HhKfkaDtJkU50Mj5Q2pK+bRzb+WoucU7x4VsKCK+clUE5rRa2ANsxCtwK4vOy0R5cJkUAFwmaPdZ/m3RNY+Hdy7LPdyrJLUhbeqFOqVXRZfLGzK6jIgiAvxRrldHOxRJaFCB8rcbiTxzYEeWSyz/jiktAkMs0O3PFTxLNKpRGGAmjrSyomg1y8yE2EyWZ1RU0nsHdRKY4zTv9KIS17zTd+ZEQhhE7A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by DBAPR04MB7367.eurprd04.prod.outlook.com (2603:10a6:10:1aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 17:18:29 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Mon, 5 Oct 2026
 17:18:29 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-fixes-20261006
Date: Tue,  6 Oct 2026 01:18:14 +0800
Message-Id: <20261005171814.2884772-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA5P287CA0329.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:222::16) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|DBAPR04MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa9294f-d513-49ad-45d9-08df2304ac92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|19092799006|376014|366016|10067099003|11063799006|56012099006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lKX2xFvqb66jsQUpOxccHzwvUQxTahMvS7hlUH2n8zwkpTpGbsx3I6yzj1NY++IAJ6wEZI8byFWuN+6y4q65TEH7mXeV8bI7X+ioB7AVEfF4op3NuTtUbuQtEXnwMpSMhwMPsPXwey9T/6etWVI4A1Brgxisx+alTux0fN0BkI4UTCgUwZGtEuQDxWf9V3x/C8bKTz7JMaNEvCFosf+vqZUJJbUcR87x+mxcl2SeQ/9v1r0uc5zV3ULyZ6dN5y+ekoPVEddowXxxHWhhFwuFhyqbq1km70nl+IqdvzfvwtVGGNWAlY+w7n8aWJ+kK+YYe+w43P7ay8KEAX6Iyr/vOxFXKo9IFfwdB1nriQ0n8cSfH0WkbwFSSt1cmL/eZLP74nfpHKImiXxY/LbbZVyXcD26shaTq511jgwQmUXNKBg3DIz3eYox4PkpeV4ASnz2Wf7JXRGGix+apIOYX41FcSUCJgL3Vrvp7VOxnzHqDvIFGhDmFzK0tqjS3Lk4VrITpGRgimGHlf23ICfsU4Xm+Ti2ED7gYkb180CUfKdhbpyOYgatCTmeOeQoI3L75+SZNvDl1amgxoAH6GDsvSBkkM39Zu8+GvNVrsfZckhu5j9GV0o0hy2xXitZY8C6gKFC8/pQiYcLoG99kyYApBbvWkyIqsmmTyDlcgEa1gLXYPI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(19092799006)(376014)(366016)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nMCHqA3Fx/tGfYBvzH1cjzRH2gFknHwxRQCqbITtB+UfkQ6+j9ZPcUpAZTFe?=
 =?us-ascii?Q?5ao/IDB90oEqodbdOjNwU3Nz5nnKUpne8jrh5XGzARg+xX1axY85yvHmWlxV?=
 =?us-ascii?Q?6rfYiCk82V0kz6dNPCtaiZO11hGEk5TXUx/GHd+7INWo//5dOa6ci9LEXHVj?=
 =?us-ascii?Q?KtyC0GSypUUVDBT2dpjAlLDR8F13lF3kXECABu+QAgAA7lQb9SIzWFnKqTUC?=
 =?us-ascii?Q?/hF2iylFTs/zw+KbaOAS8j0Q8OsSVe02dMb/vBNV55zu9uI/uJgAFwTcPSLo?=
 =?us-ascii?Q?XbzBmlIC30OJhZvW2HxZQ/D42CInghBnjj7LGTboG3V8J/KtA24Y0+PqW98s?=
 =?us-ascii?Q?69DMpQr/r1GkdfS+gfGPIf2QF7Xf3IgoS3VhZDnZRHdaUg1LL8AVmYjGZR8c?=
 =?us-ascii?Q?omoDjH5vnSYowSCpcv+tn1GCd4ZsH1MrQQ+4cBkfTp+NgtPzlJdriwHw9nhW?=
 =?us-ascii?Q?9CMGVVVSlS/iItMHCwcfdQXSCw9jGqL+WevsEXkqs1Gz5heo91punYpRqz3M?=
 =?us-ascii?Q?D4SReLC6z+GoR1OKqZlWeFN3xvPXfeCC/x64/6ZXC14VwhjJtQuHdiwQYvlz?=
 =?us-ascii?Q?8FEbO6vnU0gxRCKHfBJ2fxvMag/i//Wr9WCdyJjzxIQj7e4Y8UMLtOAiTQEU?=
 =?us-ascii?Q?4OCuNYCHhUHX/Y3TZ4+MyWLiupZl4gIGnhJZSIvCKfeesS4A7XJUEEnst7W8?=
 =?us-ascii?Q?l+IE4YIysrOKMdbfVicuz0dtwDxVbIJReHm37kFvojY+oGNR2LLFV0ALaSBY?=
 =?us-ascii?Q?+utTFWCXnsRg7gf99Sr0QXh8nSNPh6uA5BeqwAEVfsDy/kc9+anghF9tXk3J?=
 =?us-ascii?Q?VhTBA3h7/CuU2i8/KnvI6OXDhC14d5+WbwuPnPRnOoBdxcM38N3sQyAi9vHx?=
 =?us-ascii?Q?Fc+i0n85HSfTbBcrYhCqXkvPvWUKKoTe1QmtzihfDG3GA2EYOiePcAhwNnUs?=
 =?us-ascii?Q?+LyqNlxDZawj/ILVXRHTB/GhzgNmc/6c755DsGQRmIqjH3+GOAtQGG4bqeXR?=
 =?us-ascii?Q?okaZb28NDoyqkb9uQisYJZReQF/TbB/MtCPkqmCT1T7exQ/CztJqXBocYY3u?=
 =?us-ascii?Q?3jKxdY/nAo2990zklj2tA1cuJdY8g70YKVzuNYI1GF94RvbkIZGr2VHvzym1?=
 =?us-ascii?Q?XvV/5IdsXhGfZWB9aApt3VyPvWBNwCiCQWNgAyCKwnyVVsnXVWDKLB0rtjWE?=
 =?us-ascii?Q?MibC+dVg+j7MlQLCG/ripWrJhf6t0rEJ4jB9SGRo1J/g6QbA0gwHPm7ADYX3?=
 =?us-ascii?Q?LyWAtBVbmmsBddmaazA5ohlZLZxik+avWMGACBDiMHY1Du3WGkui5i3OR56d?=
 =?us-ascii?Q?tIZPqjr3TNA6jJuqSDkAo2IaTJb0mz+CZ9Wp8AFH6pS2sseoYSG6pwPRhRnt?=
 =?us-ascii?Q?84DiJcgIFFbJ6EUVdS476+qPwe9DkErQufvYtm2ZZjGf4sMh6JLewpftwkAw?=
 =?us-ascii?Q?DKrQUQXUfnLO2kg9eB3Utk0oeVXay1Ygc7sI/QvlgJAcAOCA6FWFVwHS96NO?=
 =?us-ascii?Q?XOk7J6QKgr93l2swNKMmAKmb4DvxGNCqxleMPilRfciMXDWbshdZOIEmixzC?=
 =?us-ascii?Q?llISIrAw+TUhDvpk1coO69CDlnLeIxAIZUUJukKV5jR5X6d/Rz2/KwUpLHr2?=
 =?us-ascii?Q?9bP5JyYNbsOFYMzAaNz3DRM47WsMdHyy+8XkobKR9LG7l9j0wlJp52gDiHxh?=
 =?us-ascii?Q?Dhf+RuGAXqgELkSN3mpZ/ABGe5kmozkP9raxky/FT3qid2mYxHbwt0TsK7cO?=
 =?us-ascii?Q?SYA9ET4L5gr/LYiKG1NYmwcR5Y2oKEIKWdseBE0IosVBzbTiiG8x?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa9294f-d513-49ad-45d9-08df2304ac92
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 17:18:29.3361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bk7PFc4ZpcOohoR936W1WhzS2R/3P6NZX2pvR8zI9KqTBOtnAHyxcRauCqg51Au9nXYbd5XI1D6i8f1MwWl/13HjRXghXBQBVW6OkVawPT+71ysldkmoXES/X8m1uVI5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7367

Hi Johannes,

Please pull the following nxpwifi updates for Linux 7.3-rc7.

Thanks,
Jeff


The following changes since commit 49e1f44dc3a659ff450eafe59375e2590ad5cf33:

  Merge tag 'nxpwifi-next-20260929-v3' of https://github.com/nxp-upstream/nxpwifi-next (2026-10-05 17:04:21 +0200)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-fixes-20261006

for you to fetch changes up to 07c294168a6a61ab864038c8ac3a9cc435da829e:

  wifi: nxpwifi: do not delete Rx reorder entries under RCU (2026-10-05 23:12:09 +0800)

----------------------------------------------------------------
nxpwifi updates for 7.3-rc7

This update contains fixes for station list synchronization,
aggregation and reorder buffer cleanup, authentication frame
handling, and several memory safety issues.

Highlights:
- fix concurrent sta_list add/delete races
- clean up station entries on uAP deauthentication
- fix Tx BA stream entry deletion logic
- avoid deleting Rx reorder entries under RCU
- improve aggregation buffer cleanup
- fix authentication frame length validation
- handle authentication frame allocation failures
- fix wakeup timer shutdown ordering

----------------------------------------------------------------
David Carlier (2):
      wifi: nxpwifi: fix inverted check in Tx BA stream entry deletion
      wifi: nxpwifi: do not delete Rx reorder entries under RCU

Linmao Li (7):
      wifi: nxpwifi: protect sta_list against concurrent add and delete
      wifi: nxpwifi: delete the station entry on the uAP deauth event
      wifi: nxpwifi: wait for the wakeup timer before the adapter is freed
      wifi: nxpwifi: free the aggregation buffer when the RA list disappears
      wifi: nxpwifi: zero the channel statistics array
      wifi: nxpwifi: fix the authentication frame length handling
      wifi: nxpwifi: handle authentication frame allocation failures

 drivers/net/wireless/nxp/nxpwifi/11n.c           |  2 +-
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c      |  1 +
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c | 11 +++++----
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c      | 31 ++++++++++++++++++------
 drivers/net/wireless/nxp/nxpwifi/init.c          |  2 +-
 drivers/net/wireless/nxp/nxpwifi/main.c          |  4 +--
 drivers/net/wireless/nxp/nxpwifi/uap_event.c     |  1 +
 drivers/net/wireless/nxp/nxpwifi/util.c          |  8 ++++--
 8 files changed, 42 insertions(+), 18 deletions(-)
