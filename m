Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011020.outbound.protection.outlook.com [52.101.70.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E6463B98
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791293922; cv=fail; b=B++KekphKo2aDxGseHlqEQ0Bm5cQ7tfj2IHoDdbBg78AEYnV2WjAO2IOlU+04Mg7YS7suGFS24E9Pu/rCAQuoJcIyLGrL8mSRv40wVAta54j3RAySlC42Hcp/z4z5iTCZmemgnaV7q6mDIhY1+PGzK8CImvmlk2J+0IluliePUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791293922; c=relaxed/simple;
	bh=/+TDh1tT0WM04Gf37y+P6ipaz58WtOHj+G+AkB0pudM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=dHmPDqdiSV/YyKBoHhMu2rCUy0D4qEIUx6+n1Skvf5LV/PsNYzVFkjtCaH2U5OKmXCdzWd0CSzuNDL/ZJovRWSTVqt3gk5oLYMzAMqeSuNqAtnHraszKQNcLZF8uUDbtsvFrZtdxlPjPe2vL0g3SExlQAVCizTXPoUcMU7p0des=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=F+Qt1lJE; arc=fail smtp.client-ip=52.101.70.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="F+Qt1lJE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0u/NX3oGOK9ROrgWssfKGADT8S1peLO7/HIDN6zg7w1Sw2lj/5HJGMUoKxpqm9adU1r3rxjKlvyMVIjBFAiWjSibE9psbLs+xGs/COKILyhZASjmVMXsNqnd3hCtNbHJIeoQwBQkZR8+pGjLa4cDCgbmxlm8L8Qgvb1gtDlWi2WQiW61/6gsPtwgC9bg0gXanvbbMX4jbHXUh45HJ/3zV2HTpNl4PFsjU5yEsBhcKdZyIDvUm2XQnVqUlAF4DrLufLyk+sbT4rT+l67XF+atOGL2XVd2BCxzzCp6GUdyK7H2WZ+k5uRwr82zyMQuu4NBY5Y1cnclRSDKqXxgjpxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgR9gAZVYRmTKArAde+5+LAAuNa3CgAsvge/SlcaiAU=;
 b=pyndtYHD6hoLAQveawmYGmLe8PZLiqoEiHZJ2L0gycufRQHqlUIk1Qb07IQDfJ4FAcR2q32a5dePuC/rGH/HN4CGXsfYgcA1+mOfXLOoytG3BBuIt3SpiFNJnKOtnNLTHZdHd1RH5BTGP5GNkTr6su7g11FNEofwBi+bfN3LZsjR6tvZwywoKOGTjOmLe0jN/v7yzvBzFFBrRFgy9DYjqBmYNqLRt5LDG1xGNwIGlkcCwsX0YBeDDrtL47BH/0CM3HebGJ18iHOf3zIHmwXaYCJtdGZtOX4wkvpLFbvDNMYF2EASk+J7+D8OB4Xv/zAo1wa1Wq0Xns6UTw/ozmMFXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgR9gAZVYRmTKArAde+5+LAAuNa3CgAsvge/SlcaiAU=;
 b=F+Qt1lJEwb2AAPxvtC/9tG7oXhSRQvC9G9z9fpcryNmjo+lMRU98x5AI8lFiv0HS9E5+sC5bOr0Wn0ObESKIYBCLOvB+15BuYf+Z/RVtsO3mEmVlWVs+n+WQI0Dq3ng80XDfeYwek3RHUwOLBlhZituH5NR4IqdZtgknztXDFzY1srV0qcM4c2lgg5GBvpTVMQ/Q8LGKgFUkbwm+0VmKTC1pDOhF0Umcb9xOIhIkOH5CCQgg1i75DIlKfbT5S5gQt/dkddma04ENH0aSlewyvJGmYTE0Xs7oLaRvrepM5LoPWbVH5zUn/d5AyekVep3psqxptdQbPxTly/RgkgS43g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com (2603:10a6:800:1af::22)
 by BESPR04MB811016.eurprd04.prod.outlook.com (2603:10a6:b10:12c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 13:38:35 +0000
Received: from VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859]) by VE1PR04MB7280.eurprd04.prod.outlook.com
 ([fe80::92fd:f75a:a302:f859%4]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 13:38:35 +0000
From: jeff.chen_1@oss.nxp.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: pull-request: nxpwifi-fixes-20261006-v2
Date: Tue,  6 Oct 2026 21:38:20 +0800
Message-Id: <20261006133820.2922400-1-jeff.chen_1@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To VE1PR04MB7280.eurprd04.prod.outlook.com
 (2603:10a6:800:1af::22)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7280:EE_|BESPR04MB811016:EE_
X-MS-Office365-Filtering-Correlation-Id: 818ebe3b-c703-47bd-b734-08df23af1eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|23010399003|11063799006|56012099006|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	m3Mb3oWVlzHYKVUM0tlP7xhY56j4w5tGoZzpCseqwYIPV+BibkyLOJo3z/lxRhRfsH4c44NOK1kDgkYtreiqd8C3KrhGsCc4co8YIj2DqAucUppszVKYksqpZNaTpMqPi+uD801F3Y+eMCHb6Vy2e1rvnMF1keZ9lhmN/pPdJNKkvtEM+stSCAa2ggF3QlH15U/mV6jIzLNVPxnuxwZFqQNgpDhjObD8A0nhS5dmtRMTR+9OPRSHe5UFOd1QvjAUfdXMkcqPTaKmLTKSoHhcdunhBKrJuEuMgbE+JuI3k9Zv7V32lIQ14OKOUwJHbQlXvdBaLQzVFtaH6TSgAjlQ90pBQm+Pr862p8uwgZGWxNq8A3zMcxNKBvjWXPyFYHlMk2uplAIUlpsDCp3EAHAVTQPVUQCLF8ItuMuIkokLRewjYUO0sR93JeHWdPkCskex/Eo7rH/HSYgXi04/gZEEyEwBiBf62zsYmSO0y8D0tKNIroGtH7T5DHrHVGOBcFGpEDryPne/c6qwzVOyy5LHBzfojiebSoYyGYrO7IjUuAUP6hvyy9lcawF93uZ9xbXH8pWGOt5U5+fhVZqfAsPaxJw47qBJYtJ93ydbtqhEpEZGvpHZQNCxqN3EqZEURIpQoLU3+Kki8ENGLAF4PWLW+aqvVSD3oiKJV5TUokHT0G0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7280.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FZhTqezEw3hfl31ZKV2NEXOQwIlCPQ0P/j+6LpcvHk7VimGj0Mhw9MuL1ru7?=
 =?us-ascii?Q?cjUSnsb0Ka0r55eBiLVdUCdCzFKnfoKYso8m70cdOx9viXNiDvL+jqnaEjrp?=
 =?us-ascii?Q?Bnh3RiNVn6D36FIJUacsO4QTC7SEsdmRofFGrsbMlDjUKg83j6CQtnchq6T8?=
 =?us-ascii?Q?n4sBYlo0lktl2ekFz1py/0dmC64TDhONTCYZfua4rUZF2xN3wL+L8VNCNmys?=
 =?us-ascii?Q?dD6ubWLIpCs4GK/AFwvdgh1G7CDRwcm4WDeAThC9DEy0EOd7JZw2uHzShoYq?=
 =?us-ascii?Q?cF3XjaleJVSquNZyJ74jlVy3LGRwBFRTMtSq1j3Er+WEAFzA6Jr7GyZyRP9Z?=
 =?us-ascii?Q?9jHnH7Gma9o+5ncZAaTP2+aKa+N0OCSoqPeFXKXh/tJEH/8bQa4n4sw7uCDH?=
 =?us-ascii?Q?GRBaA2DnFudzJRlZVMMZ/h/cc+FwG5tQVX6f1KfZ0i6MbnsRknVaivrnQJ7j?=
 =?us-ascii?Q?+Tsv3Bb+Rwz60SlBZnsNmj3eGl2KrmpSQG+TuNuPbmi5GJQkYi+bxg2jJem3?=
 =?us-ascii?Q?5qbsQaZtYN+KbeZ9nHUR7x+DxPw3mC9FhnDpvvbJ/XHnyMFtoXaIgT6IOVEc?=
 =?us-ascii?Q?/qoGe7o7NnJAe9A1P3ES5bheb6D7kb7Hf/HkcKmaunxADaXd3GxWkCPWLkiM?=
 =?us-ascii?Q?buy/nAElXhbm1ReE/nS4ig6c8W+dgRpA3aAzl8hNy7ncj8YvjPLx+9B7cuef?=
 =?us-ascii?Q?0KM1xn8RKRwDM/5tWG9EnZ2S0581rX3hpVTcpNhST2dD1NKDksxYaaV8S4x2?=
 =?us-ascii?Q?fnqYu4hRc3Wg0BP1/mqDjb1KHE9E/GfyN+r9/v6Uwu4E9+PAv/cRhSiPp/QL?=
 =?us-ascii?Q?oP4er6NZbW7FN0f6rO51h+BreGxdw/Z8xlrtOF22UdcsrpeIi70/j/ei5JjD?=
 =?us-ascii?Q?96rHr9xegFCQ+7zwCqIwkszG1PDalqmwaG2na06F8hjBwVXztmtSFj0Qy+Ud?=
 =?us-ascii?Q?gZQ+nkZEsxVT2PJHGpot2JG/bRyikiWiUbAZc6Sye035LeaivU5sLuWga4A+?=
 =?us-ascii?Q?bF3UVnBJTqmjhz2oUOkgkvagXwlFcp76SipNq5Z6hidEhQvv1ycKyO70oXqB?=
 =?us-ascii?Q?LqBMaJfh69ziky7bw6S5JvCBB4rp2zj7aCRE/p55f0RBguCPsbviROHhd4sm?=
 =?us-ascii?Q?+nWH0owKdRHV+r+4DIyOlpJL6mhHcziguYGoxlzJ+DJ8bASc5RRTzUXb/rA2?=
 =?us-ascii?Q?k/BQQdNjeYQUTmGzHBJZSReM1PmK2m0KZCdRXzISk9Qr1+yhUwxYUIODHXJS?=
 =?us-ascii?Q?doCE4jAc87hKfTRgURl5JHyk7gIShTb9trD3VfFyrRCQm9arAsAwi31LkELZ?=
 =?us-ascii?Q?XhUaDAH6xqWwTWvpONgfTc7zt8yGbdmugeDNopODVVA9/XX1GDmVB2MXIoha?=
 =?us-ascii?Q?1DMU3WWBJQrP9et/9Ij1GhUtZxPrDFq2c/+Y1TvIMbC3gQVeXKYGyG4L+/Nb?=
 =?us-ascii?Q?gWK4h364tsapy6RX9VIAtO25hPVir+4dRsXZmEHbhjXfqc3xGE0KHGQ8xeVv?=
 =?us-ascii?Q?YPSEgwrWgGVgb9hRwzvPndgOmi2+pe3hbEMf2TrMZ6OGT0H2ZYMlVPMO+sRK?=
 =?us-ascii?Q?JiHRze1l890XmrDqOlBjezKMEjc42OOcIoDi9hRPakGstAfBqbcz0b6YeofN?=
 =?us-ascii?Q?iljjGUxpAXVFj3MgaYk+vbLYcdhhKj2ZCWHNsw8nRphYEBfZmCnH+OU1YB24?=
 =?us-ascii?Q?NVyqyggqgpDhSMZhTL/F2giWclzi+UgEt7IxqusX8wE6IsyvHzXpMpOc6UYZ?=
 =?us-ascii?Q?2vLqe6zWNPvm6Bu/AhiKv5FQYcHjWavv4+0O35wYz47KRsWpcc9X?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818ebe3b-c703-47bd-b734-08df23af1eab
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7280.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 13:38:35.7582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WuL9OMcVKEsfaX+Az8Qz50UGrlFG5Ef+fyqrC0EHxsgxtAL9d3GYehhZPIvA/r2ejtnp5y3BRqJHP21ZKhb1mqmH4zSEaw8kkFrSbp2RWu1FDQJre/afEQKSmGw0+Ja
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESPR04MB811016

The following changes since commit d24e8ac715de2e16a53c144005b1863660a5fbea:

  Merge tag 'net-7.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 06:41:59 -0700)

are available in the Git repository at:

  https://github.com/nxp-upstream/nxpwifi-next.git tags/nxpwifi-fixes-20261006-v2

for you to fetch changes up to 5e99bdb94720331e2fd38c10c5b1afa1ce640835:

  wifi: nxpwifi: do not delete Rx reorder entries under RCU (2026-10-06 21:13:54 +0800)

----------------------------------------------------------------
nxpwifi updates for 7.3

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
