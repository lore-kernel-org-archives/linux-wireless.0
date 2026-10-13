Received: from SEVP216CU002.outbound.protection.outlook.com (mail-koreacentralazolkn19012062.outbound.protection.outlook.com [52.103.74.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F13D6CD4;
	Tue, 13 Oct 2026 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883121; cv=fail; b=q20InhsrKSECNphGfhOdmz5HwI224+5UIGfIALWGmtYNZzOgrIh+O6o7eggb6nNdKSJI5ObONFZtVD/3qgFQKbKbqzuxflj0TGXJiBLuPaHCr5xF1+z+zjhYcXFYEhbl6ff7XHMtu7ZEakqnPalmhdimDVVG/SFh2pcyt1E4SLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883121; c=relaxed/simple;
	bh=z6KAlpQa7UPMbMI1WN+EIwOB5waRwzlUQBHY0JGl148=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D+A0kfS1Jz+FjyTEGiRepiUV4sj5sH5nK4EGBbM32r3A7d6kJYCJIbsYiPlRqK96uWM8MQv4dR2Crvv6cIV8xnuP3oi/CBcxcpLr78E2FovM/SUscVPo8pkpvyKY5n8KNrHYZ9XP5oWX/hOmIH7hwEVdZRePXBYC4hYCfLtYqOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alexvernel.com; spf=pass smtp.mailfrom=alexvernel.com; arc=fail smtp.client-ip=52.103.74.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alexvernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alexvernel.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFQbmaX3zV9vAVcFp/3VM3WGZ8yNaMmIrioTcZGiRnD2tKa3wZ4gVYOC4Kya+nDozlnfl8xQWwHIi4d2gb4ZpNTQBwAHy4jyxhvQblhYp8QR/z2Oc+tlRtBef/Lw9KxPqlq5SpfjhQGYmtwqtwkw6qnplE3yPo3LFbiFWLNRHbhOUGuHmU9CJlop5Hej1QaN8ml/LqAwU4FW//vmmGDbbKgbP33fRiICeI/4H9OHyncfOouAZoFKLQ3OH5BsaS7Hnva690U0buJdtk4Ff8YOIJhJiV66tn3pRmhTe51Sz+OmiyBZhf+NZEQ/Y6pFKco+icPvlqPKvybwmXJ8dHVLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxMZLEtZr/mgTVrpUfN8tvSjvxSv1qCefb6shhoXCG0=;
 b=j/B9kXgqgWGvkhJyJ0f4BAclANcPYMr+aZYf4fvN6gxD5brC6yEPgF5p1AnBTcEbI0BiGspFUjXCYxcTIR7W6TUR4a4zAClindbCDuFx6OItldssFoJ4rZom+xfiV0ugHywKX7m2cIhO1pMigr0rws8BU2tOfGjjLY2z+OgYZv6et4QfTCHY4FfXgSel3xpU3f4u0w2FPX7A1U/gU64hJGwE4FZgQyfzlpu0emvqckEAaF4jZtNh/Cj9/TYGFrfj59C46TnK0bQot4EsYHW/vWnfKdZI5ZjxVjZy7m1zG85wOQtRojV3DzOKbKmkqwcqT9b2rOGq1oXqlNJRVXOHfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SLXP216MB1067.KORP216.PROD.OUTLOOK.COM (2603:1096:101:9::6) by
 SE2P216MB2952.KORP216.PROD.OUTLOOK.COM (2603:1096:101:28b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.23; Tue, 13 Oct 2026 09:18:29 +0000
Received: from SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 ([fe80::3dce:2b67:b21b:6152]) by SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 ([fe80::3dce:2b67:b21b:6152%7]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 09:18:29 +0000
From: Alexander Vernel <alex@alexvernel.com>
To: linux-wireless@vger.kernel.org
Cc: loic.poulain@oss.qualcomm.com,
	wcn36xx@lists.infradead.org,
	stephan@gerhold.net,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 1/1] wifi: wcn36xx: validate scan bands against radio capabilities
Date: Tue, 13 Oct 2026 22:18:02 +1300
Message-ID:
 <SLXP216MB1067E773936FD95646687C08B39E2@SLXP216MB1067.KORP216.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <SLXP216MB10675081A1D858B6421D5AF3B39E2@SLXP216MB1067.KORP216.PROD.OUTLOOK.COM>
References: <SLXP216MB10675081A1D858B6421D5AF3B39E2@SLXP216MB1067.KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AK1P299CA0023.NZLP299.PROD.OUTLOOK.COM
 (2603:10c6:108:17::7) To SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:9::6)
X-Microsoft-Original-Message-ID:
 <20261013091802.1064081-2-alex@alexvernel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SLXP216MB1067:EE_|SE2P216MB2952:EE_
X-MS-Office365-Filtering-Correlation-Id: 919139f0-10c6-4c75-f8aa-08df290af145
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|5072599009|23021999003|15080799012|260925184616899003|51005399006|25010399006|12121999013|8060799015|19110799012|440099028|3412199025|40105399003|2607281247196008|30101999006|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0upYMjQYlNc+vbKrLii8tIPuZRys2OX2uR5Tve1dJW69wkuGgXxu/W35ODZ?=
 =?us-ascii?Q?JlEXGnsA5iYAotlX5Vo2LWq4Eg/OE7Pv8IsMpYs/fOOXpCLpQqy559Iggc3X?=
 =?us-ascii?Q?MUu/CQi6nbj9+UkOpD4XgetXm4OThxVNbqo9w9RnVICj3xqYWmzEtG/Yyk9G?=
 =?us-ascii?Q?bM7u3aVWsHcI/IUpWpjjDnpKJQ1gx6oe7wkTUu5Vci/wR/eknUDtI77zZxAt?=
 =?us-ascii?Q?lhKf6Xejw/SmIgctTtAFhrcP1pmPAVVQnSYFQ4Jjx6Bb8ZBWHbgoH+8Ee740?=
 =?us-ascii?Q?BaDo5h6essGqD9XnXf7yL+QWaCJclLjLMEry5B0dkZgxsjIlv8bye/dY8CU7?=
 =?us-ascii?Q?GGff9a6cbYj8x9Mwg4Pu4NKgy/0sV/jIsSOYtIJIumIY9OmUYMxBTKUG3REN?=
 =?us-ascii?Q?oc+Y12pVXrH+oPlBlapIu1IaJDOwKc2sJGZW9v7mblpJTljwSNXwS90jPez9?=
 =?us-ascii?Q?bUBAlwLPMJDvlY7N8OlRMRZ4FNiLgSmzR9ifhzNQkx/YbSayvxlxGvirp+WU?=
 =?us-ascii?Q?s1bAkxQIYVWQw2U10uj9uRemVZEWE+mgaalDdcK/k2LHWy9E5THm+OTo4eYC?=
 =?us-ascii?Q?PFTqs4g+frHPUYWu5HvVUA+sLV9bIE1BLLnaKpgVmWPwTuSnBTdIhhHZ3lWq?=
 =?us-ascii?Q?HRmx/DlDHrFeqV8ypLERNCNJM3uM+sgRbdFBmQp1CARJmhAJQNNQnWFN9jdX?=
 =?us-ascii?Q?dWDbrpZfPGIlvwc6Xd/AMHIWbeM3Hgejewu27CyHk3qqHqvemJ+l44ALBEhg?=
 =?us-ascii?Q?sMfN6atIEx1bmjnCBQ41lGrB2stW2PJ+rT7GtmSm1pETCtox/tsct5DE/V+J?=
 =?us-ascii?Q?MhdbifbN5uxFirCN4rR3Mi2AwZfIPvZNi5sUuciLN3MARa57Fx1fo3Xyu2rt?=
 =?us-ascii?Q?1OVf8Y/MzaVRr7WXC9c5puxE9Ig7mwBkFayvwKFCJs0MoMx2bIIcM6FJq6Wo?=
 =?us-ascii?Q?hV2a+T4km7phFLyNHZIS/PEtiOQY3ey+1HBu5LsgdII=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uKWSbyMHiCIa2i5J+t4hQ0Xu8k6oBipe5z6nbbhV3WjMtz0Ocwu8JWzsBiRH?=
 =?us-ascii?Q?ZajbrZucQxHGzG0rDgKwfzB1f5JqnFINglSYY8+NGWCiBzsYUOKSlMgLkRXW?=
 =?us-ascii?Q?gkwhbkfcIKx6m7VeJK6d0da4fwFTZYKt0rl8gbTAs3Gq5bVh56rxNSNeGbIg?=
 =?us-ascii?Q?b4NWjDI/QY95k6f90LXWqYEH4JBTHLMCg3WhbaJtwxn6n8qRHI6XtuzuTfAH?=
 =?us-ascii?Q?TLJUmUHlmYmdSuxvHw+t9U8FCxN3VjzeZd9pt7sOzafjtpgYjnstAGq3fL3z?=
 =?us-ascii?Q?o9o+Ei4neZXzn1N+nDpmxcIpoAd78IYN2y56+7/C+edeFHQCZvSDupwmceQc?=
 =?us-ascii?Q?yCBU/ZnuUM/h605lztQfwGGnhmb7zUe7NokYhN+ilMunklxaUfm71lEgZVa3?=
 =?us-ascii?Q?QdLAD2it72qcb676kFoSeXzi1iTOk4JdY802wIuMYB0EqM0DK+hvQ2GScGXE?=
 =?us-ascii?Q?x7+asb37IMxsWR89dk63kpQ2wN0dpwjC5pw5Aehy600nOMJN+3av2yTV3hCM?=
 =?us-ascii?Q?Kq+sK9k+y3PKPV9PJHcM31oCx8fvZUc52VaBUrvihLDxeYm8iw89dQzpH2dd?=
 =?us-ascii?Q?YH+YvWifDBQNeDBs642g5CcvXkV7EkfOOuQlbWC2Rp6xjGqIPjBdz32/KfUK?=
 =?us-ascii?Q?pRYasZBYB8HdDjal+o5DWHt0ZdVUjFaM7lAhXhP+GPv1VX9aaK+MZidKuH6c?=
 =?us-ascii?Q?0N39CAW2KFICbiKrDjtEqgimSEglDmH9IhbBzXE/k/RdeZDg+3zvbmMZy5k8?=
 =?us-ascii?Q?Hjxk3Yezo5XjMh6OOH/OV9o3qZXK13ogcTSUMJEn1WRSyq3gpaxlzS9+DTsl?=
 =?us-ascii?Q?u74O7metg9nsVPNVgGj2yhYekMu91s9C/pehFuk9zWdnYKWCNzvTUbxmtuZg?=
 =?us-ascii?Q?M0cjDRU4wkNyjaXsCEexxg4xxVnFuBZ4SJ/iriOcuPtzCKZ78jn+YVGQlqQC?=
 =?us-ascii?Q?YKLvsDoUH6Ii6AnqOPXAh6lac7+Iheo5ESKkpnh39MLprqHzHgnKh9WBIfJO?=
 =?us-ascii?Q?lEaXIAcMaO+QQ/7kEzRaf9uR3PwDhzU60GH9rUTqn8abgPPphTAxNuk71Byr?=
 =?us-ascii?Q?x0wCes4Ml0jc5N9vpLDJA5eTRWr92H6fg2fNpsgbG9du6Ma12FIUSZwOKGnB?=
 =?us-ascii?Q?sCXyNuLuLDD1FC7wezWCwS4kGzfQy1qW50sCbxGy+17K4lXwjdCYkYz10UGF?=
 =?us-ascii?Q?4RXVmbt0lSdMMOYN3Yl5EVpsKEltRtpIfuNyy7zipAjcf+JXMxQfkAsMpYw5?=
 =?us-ascii?Q?cBH6c2iVnZAZFlZv0jOUtgNql/R+ppGPr18DKSlBRsfBbzjr6NiWLgfik3Sx?=
 =?us-ascii?Q?4ey8J9jSz4ew3khyD/GDZlfE1+IPN/fPjRTVVKetRabuXKsoHTYyix4y0Zjx?=
 =?us-ascii?Q?oLr6M9hL/8TPea7IZryM7bfjYAq7Fx3GLvws8DyhswA3TXKBtQ=3D=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-94596.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 919139f0-10c6-4c75-f8aa-08df290af145
X-MS-Exchange-CrossTenant-AuthSource: SLXP216MB1067.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:18:29.3343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2P216MB2952

WCN3620 only registers a 2.4 GHz band, but its firmware can report scan
results with rf_band values that select the 5 GHz channel mapping.
The resulting receive status references an unsupported band. On a
WCN3620 tablet, this caused a NULL dereference in the survey update
called by wcn36xx_rx_skb(), with a reported frequency of 5280 MHz.

Only use the 5 GHz mapping when that band is registered. Otherwise
interpret the descriptor's channel as a 2.4 GHz channel. Reject scan
frequencies absent from the registered channel tables before updating
survey data or delivering the frame to mac80211. Ordinary receive and
valid dual-band scan mappings are unchanged.

This follows Stephan Gerhold's WCN3620 workaround in the msm8916
integration tree, using registered band support instead of a radio-ID
check.

AI tools assisted with crash analysis, adaptation of the workaround,
testing and preparation and review of this submission.

Link: https://github.com/msm8916-mainline/linux/commit/0be2d63a476e83c757d9caafc22eae00bcfd1df8
Fixes: 8a27ca394782 ("wcn36xx: Correct band/freq reporting on RX")
Assisted-by: LLM
Signed-off-by: Alexander Vernel <alex@alexvernel.com>
---
The original crash was on 7.3.0-rc6-tb-x103f-mdp3-r28, based on
6c377d19d4a51 with board/display bring-up patches. The affected txrx.c
matches that mainline base. Firmware reported API 1.5.1.2 and CRM 67946-1.
Selected UART lines (other lines omitted):

  PC is at wcn36xx_rx_skb+0x160/0x74c [wcn36xx]
  LR is at wcn36xx_rx_skb+0x378/0x74c [wcn36xx]
  r3 : 00000000  r2 : c1cec260  r1 : 000014a0  r0 : ffffffc4
  wcn36xx_rx_skb [wcn36xx] from wcn36xx_rx_handle_packets+0x140/0x218 [wcn36xx]
  wcn36xx_rx_handle_packets [wcn36xx] from wcn36xx_dxe_rx_frame+0x70/0xd0 [wcn36xx]
  Kernel panic - not syncing: Fatal exception in interrupt

Decoding the exact module locates the fault in wcn36xx_update_survey(),
inlined into wcn36xx_rx_skb(). The frequency is 0x14a0 = 5280 MHz and
the supported-band pointer is NULL. The raw descriptor was not captured;
neither its exact rf_band value nor the actual receive channel is known.
The fallback follows the earlier workaround. Channel-table membership
checks that the decoded frequency is supported, not that it is the
frequency on which this particular frame was received.

Tested on a Lenovo TB-X103F with WCN3620 using a mainline-based board
bring-up kernel, 7.3.0-rc6-tb-x103f-mdp3-r29.

The 20-minute UART capture showed no kernel alerts. Twelve normal scan
requests were accepted; 4 MiB was uploaded and 48 MiB downloaded with
SHA256 verification. This does not establish that the malformed descriptor
occurred again. No dual-band hardware testing was performed.

An extracted-function host harness passes 261 RX cases covering band and
channel decoding, missing channels, ordinary RX and queue purge. The
original code traps at the unsupported-band survey access. With only the
band guard removed, the synthetic WCN3620 channel-6 case is dropped
instead of delivered as 2437 MHz. With only the channel guard removed,
invalid-frequency cases are not dropped. These are separate expectations;
the mutation tests do not show that both guards are individually needed
to prevent the reported panic.

These tests use shims and do not simulate firmware, concurrency or full
A-MSDU handling. An ARMv7 W=1 kernel/modules/DTB build completed without
warnings.

 drivers/net/wireless/ath/wcn36xx/txrx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 882699879..c12d4a503 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -367,7 +367,9 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		 */
 		u8 hwch = (bd->reserved0 << 4) + bd->rx_ch;
 
-		if (bd->rf_band != 1 && hwch <= sizeof(ab_rx_ch_map) && hwch >= 1) {
+		/* WCN3620 can report a 5 GHz band for 2.4 GHz scan results. */
+		if (wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] &&
+		    bd->rf_band != 1 && hwch <= sizeof(ab_rx_ch_map) && hwch >= 1) {
 			status.band = NL80211_BAND_5GHZ;
 			status.freq = ieee80211_channel_to_frequency(ab_rx_ch_map[hwch - 1],
 								     status.band);
@@ -375,6 +377,9 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 			status.band = NL80211_BAND_2GHZ;
 			status.freq = ieee80211_channel_to_frequency(hwch, status.band);
 		}
+
+		if (!ieee80211_get_channel(wcn->hw->wiphy, status.freq))
+			goto drop;
 	} else {
 		status.band = WCN36XX_BAND(wcn);
 		status.freq = WCN36XX_CENTER_FREQ(wcn);
