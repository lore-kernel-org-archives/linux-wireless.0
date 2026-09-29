Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011009.outbound.protection.outlook.com [52.103.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028642848BE;
	Tue, 29 Sep 2026 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645369; cv=fail; b=s4cV10gwks5RFQ2QLRYoDx8l5H61Nw8Atyg4M/j79bqjALFZRLMrwZmNsnDwlm7Cl4O0rlNyCTjRDU8txanaw4y/feJjzjrwhjj4Ii2TgE10cxmWtZ3WUz6aaKsmMbcJga9PZpRorDNXPe/8Xvbub7W0uUsu/FX6uS50o9c6M4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645369; c=relaxed/simple;
	bh=8WKrY1SoqI1VYYUudwWuXsridiAhVRbGrKspxnzn9mc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lX6l48S4RIcpeb91v1BNHpyIaBAJ5kWrgxdq7ad4A2SgDKwc6wk86He0ceLKdvscjeGXCG6L1HHRMEUNEe1GOJQiWkzaGrfFo1IdcG7InMN0TwwSdI48zSc8r9qc4oMBl34/pOa1W4xk14UxqnHZbOr6eenZScmC4Ygicp1iyeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=j+PZ5Ojy; arc=fail smtp.client-ip=52.103.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="j+PZ5Ojy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGp3tVwwv3g+tyJz9V2ddl/heL+2/jqXiBmgOVOT3Qy0DlkhBYT9itq2V9K1OHObS2wEnmTDf/mf9H36m9SMDxYoFqDRKGmSgONqbsne/SQ+MIH1XDMolQMlghDJsGHE5kQUVKPwJKgXYhyCctQp7IyqfcFJr1M9KRV1EbsOJ7p2RxfSfHGIwq9EREIGvIZ7xJsgdzy0CDKJXmUrE+OSWdeTUKzayP33/HONiNPPGrlc9bBLj3Aeow2Je+50lI9q+XvMJYCOZmHev0bFLM4dS9PEWMJnNjMPlCQ+J6+1Co3IAxLmS/RZ15qD/S5E49nL0RgteD27pP7SprTuLdZNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4woQ4Rp6i1A08QQxT2jwMZVcSSIgzOV8W7WCTykZQ00=;
 b=EVgeW87QaNtanDyYIDO5cSOa4rbwScPztrAL+HHvUWYB8twEyv2wlxuDNBzWykjxy7DaUbChcQoWtnURKVIwqcrQ3pxxZfRi2asdv4iL4bi7IpBZOprmeQggYYot7eG96+fbVTu/AwGI1/N9Dd/lJCuTOASpLR3Ra+Ts5+H1+9Swfv0egQQecuNhQQympWpj/qPm+YBdZGBYzlI+vAwJ75437zqvVlW0OJ0066JFonoMzxAGsWokEdpubv+QP2OQUE37M0gzHJXBS0bqGE3y+0puBTrWCkw/Dk4LNCzy6T7N7XmDIm3z8PiCU/fYHUm3aQuaxvB66e94q6kK240qWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4woQ4Rp6i1A08QQxT2jwMZVcSSIgzOV8W7WCTykZQ00=;
 b=j+PZ5OjyqUmAGdb/8iy6v2RJ3tuJf+ZW8wT9RjND3ukS56+VLath54sp0d50edDJDJ0ZjvxzsY/1SH3gyhcIIAhBOmwlo9rDF52lv6ybM9Wg7ZNIPf7HmqqrWUqrfF2l1tyHGZ78U/A97SOdnSmb+RiODCJ6NGfY+ohkWeVE075eOyhMXzJkxFOXrS83QmR2l38rc31kimb23dRfnwKHzsArY0nVg7oDVAH51/0z9wMRCfr4JtsoWzfnSiU1FMcXojgilOs8EtVX7pTiWK01MSHtgV+YHIRStjDCa5vFL3w46l4SM6RBMV0SoIMmGblCTfBVuWqsyXniOyPrX5JwOg==
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com (2603:1096:604:1a5::10)
 by TYCPR01MB7162.jpnprd01.prod.outlook.com (2603:1096:400:f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 01:29:24 +0000
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b]) by OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b%4]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 01:29:24 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: [PATCH] wifi: mac80211: add missing fmt line break
Date: Tue, 29 Sep 2026 09:25:13 +0800
Message-ID:
 <OSZPR01MB814085194DDA24DAC2759477BC8C2@OSZPR01MB8140.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TPYP295CA0021.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::11) To OSZPR01MB8140.jpnprd01.prod.outlook.com
 (2603:1096:604:1a5::10)
X-Microsoft-Original-Message-ID:
 <20260929012513.1089719-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB8140:EE_|TYCPR01MB7162:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c60a5b9-0e8e-4d72-d4d3-08df1dc897fa
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|22121099003|15080799012|260925184616899003|5072599009|5062599005|25010399006|39105399006|8060799015|19110799012|24121999003|22091999003|41001999006|21061999006|24021099003|4140399003|12121999013|3412199025|440099028|12091999003|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eix/hNqd+/tw9zD81pknM1KKDz7m2tUx1tJw0rKEXCItAT490HYBcucA++DJ?=
 =?us-ascii?Q?aETjpKr9wrR0fLVr4FdKl4WPdW50ZOt2kPSG9Zlqt71gQl9KM3sS9ZvrQ6E8?=
 =?us-ascii?Q?C6xXMt2ZBXxtQejH2o4g9eXpAExsEg144nnNCgm5YnX/G+k/8G74oeFfMD6s?=
 =?us-ascii?Q?A1erercGxh9vZH+2rCQMB1l1Grn5Rz88kz4QlUF5peswP3Ofg/DN3N2LV8Vo?=
 =?us-ascii?Q?b3+LmcsNSKxz1iHrhFhIsLJhutl9WrNqVYSS9vyy+OqIvtSmEQKniV4XbWfJ?=
 =?us-ascii?Q?od7vTk/h/zw2FPiB9JY/eYpWI+S31o33UEiIMVQGAdDgwX8Uz8JT+DzUrH4u?=
 =?us-ascii?Q?scMIFSoiCFFMgOb/8IXmmm0/bR+IL7Rh1lKWnUhVGeCqw/Yowz1+EASjdMlI?=
 =?us-ascii?Q?bAKgs+gV3GbRNEYU6rLYC4kE4Dc5iRDfbN5TTZGlSZzeyKJoZ/tGXTzmSq6G?=
 =?us-ascii?Q?HBrzZSZT0AF8LGf3hNm0k+LPFiJ4lwimq3YTUmHgn6yoRgVBuagRpbgcl/tP?=
 =?us-ascii?Q?6p5nMf5FwF+ZY+E3EAUzFBowMMK0XsTl8+lKJUytP7gJfjJmRikmCORbsNpE?=
 =?us-ascii?Q?0TPTQ5uRyiTUGE34x56K/1TRaqAvtWiEybxPA06pIU6RDL0Kji4K8KbT3k+P?=
 =?us-ascii?Q?l4lg19Zz2BTmcSxuNjbGpNYH9gO2x0a+gKXcaKaoam2phdNDhtyqmFxH4tW6?=
 =?us-ascii?Q?itCpYGlchsOoCLx7UJuWObJZKSAs3EASyWO75nazkUmCOkkTEfPMeB2AIk4f?=
 =?us-ascii?Q?eblNpFa0s8fI2mChCv0e4inSS/6acGzlL2NV1a2gZMBkRYSQ3ipDrNnTfENX?=
 =?us-ascii?Q?DQXCTfN5KaCtQ74dS+V5p7wr+sY4tTAqqzcpm7AhwPFh0Ua3Q7ji+Vx9284o?=
 =?us-ascii?Q?6uKZoOUyMuQeUExgIDwJsJGDqK6MobwJcJ+e9Affai5PtG5zhLNsG+UqIOYS?=
 =?us-ascii?Q?mcLHNQR2HeqUad4RRoF1XUY7sm5yGlxKm1oST+P85kRfNWC2rFtE9HtzecKZ?=
 =?us-ascii?Q?/uCIzxYPrbHHXse3yDVl8HOzalGjm+NlyfV/kjObVEWCw8p2lJeKVUi9NEHS?=
 =?us-ascii?Q?olp3K6Kh3VvHiDFqR4+FVgiqXwBONuVgEMKNlRedF4yiLDp+c33RxbeDsEEy?=
 =?us-ascii?Q?0W4r4IPB2YLhva4iBiLs3BjYXcBHezUMiNAkqtV7Y0SIpmuvfDtoO2+mRZMr?=
 =?us-ascii?Q?JsshjLcyS86EvRrF4FztptAQaEHQs3ncQD/4Zw=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2qCUl1+S+MnsX5eNcJ2hlCmRxt4W+jomyZ7vzB3ulzALkVuPWprwmGCkb66v?=
 =?us-ascii?Q?uyi6v92fjg6qC0NvY/sNXSswEzQMu7LXdKQivetjaZXPbpsjZ96XHai7+F/t?=
 =?us-ascii?Q?CuW/ZDx40rO1v07i4Bj1cyKPS/y2sjLtK6p5guuutGUR71z1WVr6CixqilJe?=
 =?us-ascii?Q?8OFkWVRhwfmUr3QD86KxFMNpG3dVfqlf77MMVUicHTUK/NDhSzO+uQxwiX0S?=
 =?us-ascii?Q?2wnwGS0vvl7uzq1PVYuL5ADRrMUf6v3JKqehiWQSAW3zCKViR/RbxJ06HrNN?=
 =?us-ascii?Q?hyAbbil92zFSAEfDCuhBGkYEKU6zlOXYi7TNsntH/GJnlVqdTAhgfNJPYhod?=
 =?us-ascii?Q?ryqai6pooMk6AiMZp+T2d5wt4EtVYIKUP3b9UIHDnXoT1HPryF3YppYP5PYW?=
 =?us-ascii?Q?asr7JE5KiWEbQC18QhgBycah/4ZijruFjR02tNAwHsJVhJrNlYPeM6WkKFVt?=
 =?us-ascii?Q?kJCE93MMJvMwUbVu6FWGOGoQP9Ttd+Uzwj3XPVGwMZPd8+Ly6hIQQwKlE5Qn?=
 =?us-ascii?Q?Db+1CfSWN1y0o4Doc8iS4JitZEMY2GQzlQ0Q5DWHs2CeGnM81FmmEuDEffqD?=
 =?us-ascii?Q?BeXN42vF+07Hh4mOtNdh9S2hjex79eImHGMv+x0KJGkX38S7SCoqw1vbCHNr?=
 =?us-ascii?Q?nAWOxax+BSeuc7zNOn/3kun2uO1b/3IMpzluCpq0B+VD70Z+ZuCgLG40KNvL?=
 =?us-ascii?Q?HIQ+epj/9WGHhDrMaa4TJBg0jKCebJQdlgKCdQMeLWaYA2v8BYUs6kV9SPzW?=
 =?us-ascii?Q?UJ7G4DDubJUwLLcHXhfoAA44G2Q7fdyDYQvT5ruWMgRjjesxpogLfk8pd7YE?=
 =?us-ascii?Q?Q7iIX6eJlQhRhH7hLTyaWkU7vETJ391IxF9xN0ztVkWONo41eMqWu2MotRLy?=
 =?us-ascii?Q?BAXKAdNLp1Kz840STk17fFoIDbs104ulzx825iMHHqtRH5gyDpkX2uK9I4pu?=
 =?us-ascii?Q?Hu2ANnINcYMF07+Iv+3S6Uk9VbPvaX3rWO8Q5sMw7Fy6wo8Gx6pTNf3DRMd1?=
 =?us-ascii?Q?vm4S7DVWtEQ+2vjibechBRJSQJW/sKFgtPtEXulrOph0TyAhsgTKY0mz6I0v?=
 =?us-ascii?Q?+kZlQkSfAW1OrFEk2mo+tyZhYyDi35YugyK9giUo/tjYCy+PMD3e/jc9eCvs?=
 =?us-ascii?Q?oBXZHzexCHXxl8Q9Y5+/3SK4GbjCKhAyulTFcMOcXqm5u13CSvPOyw+h16D5?=
 =?us-ascii?Q?/2pBgA1kTpTXfMJ1mMhpFdp1x2Y+Kbj9oOmmYKE9tbdDo0uPFzxUdLwvolRb?=
 =?us-ascii?Q?GlCHr8lajnTDCpuDUQuy1Dqd1DBPDm02ZIg78hu1EzqTz0VyqveAlPorG1Ie?=
 =?us-ascii?Q?a2XCInGZTzNWnBDFOkn9R3tM4zI/57Ttot72O9If90LtMIpgFxmL7aVMixlo?=
 =?us-ascii?Q?m3KsUwp1nN1tdO10BfH0uOkPX5im?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c60a5b9-0e8e-4d72-d4d3-08df1dc897fa
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8140.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 01:29:24.2799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7162

It was noticed that dmesg sometimes cannot read the last log entry.
Queried using the regex pattern `[^\n]"[,)]`, then manually checked.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
---
 net/mac80211/fils_aead.c  | 6 +++---
 net/mac80211/key.c        | 2 +-
 net/mac80211/mesh.c       | 6 +++---
 net/mac80211/mesh_plink.c | 4 ++--
 net/mac80211/mlme.c       | 6 +++---
 net/mac80211/rate.c       | 2 +-
 net/mac80211/vht.c        | 2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index 293590976489..1686fed0b98b 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -271,7 +271,7 @@ int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					 ies, frame + *frame_len - ies);
 	if (!session || session->datalen != 1 + 8) {
 		mlme_dbg(sdata,
-			 "No (valid) FILS Session element in (Re)Association Response frame from %pM",
+			 "No (valid) FILS Session element in (Re)Association Response frame from %pM\n",
 			 mgmt->sa);
 		return -EINVAL;
 	}
@@ -301,7 +301,7 @@ int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	crypt_len = frame + *frame_len - encr;
 	if (crypt_len < AES_BLOCK_SIZE) {
 		mlme_dbg(sdata,
-			 "Not enough room for AES-SIV data after FILS Session element in (Re)Association Response frame from %pM",
+			 "Not enough room for AES-SIV data after FILS Session element in (Re)Association Response frame from %pM\n",
 			 mgmt->sa);
 		return -EINVAL;
 	}
@@ -309,7 +309,7 @@ int fils_decrypt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			      encr, crypt_len, 5, addr, len, encr);
 	if (res != 0) {
 		mlme_dbg(sdata,
-			 "AES-SIV decryption of (Re)Association Response frame from %pM failed",
+			 "AES-SIV decryption of (Re)Association Response frame from %pM failed\n",
 			 mgmt->sa);
 		return res;
 	}
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f45e792abede..294336b1c1c9 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -337,7 +337,7 @@ static void ieee80211_pairwise_rekey(struct ieee80211_key *old,
 		}
 		if (!wiphy_ext_feature_isset(local->hw.wiphy,
 					     NL80211_EXT_FEATURE_CAN_REPLACE_PTK0)) {
-			pr_warn_ratelimited("Rekeying PTK for STA %pM but driver can't safely do that.",
+			pr_warn_ratelimited("Rekeying PTK for STA %pM but driver can't safely do that.\n",
 					    sta->sta.addr);
 			/* Flushing the driver queues *may* help prevent
 			 * the clear text leaks and freezes.
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4507e4e6ec1..c6047d0daf6c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1529,7 +1529,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata, u64 *changed)
 
 	*changed |= BSS_CHANGED_BEACON;
 
-	mcsa_dbg(sdata, "complete switching to center freq %d MHz",
+	mcsa_dbg(sdata, "complete switching to center freq %d MHz\n",
 		 sdata->vif.bss_conf.chanreq.oper.chan->center_freq);
 	return 0;
 }
@@ -1633,14 +1633,14 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	if (!sdata->vif.bss_conf.csa_active &&
 	    !ieee80211_mesh_process_chnswitch(sdata, elems, false)) {
-		mcsa_dbg(sdata, "Failed to process CSA action frame");
+		mcsa_dbg(sdata, "Failed to process CSA action frame\n");
 		goto free;
 	}
 
 	/* forward or re-broadcast the CSA frame */
 	if (fwd_csa) {
 		if (mesh_fwd_csa_frame(sdata, mgmt, len, elems) < 0)
-			mcsa_dbg(sdata, "Failed to forward the CSA frame");
+			mcsa_dbg(sdata, "Failed to forward the CSA frame\n");
 	}
 free:
 	kfree(elems);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 268857467f29..77a54f28fc70 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -681,7 +681,7 @@ void mesh_plink_timer(struct timer_list *t)
 	 */
 	if (time_before(jiffies, sta->mesh->plink_timer.expires)) {
 		mpl_dbg(sta->sdata,
-			"Ignoring timer for %pM in state %s (timer adjusted)",
+			"Ignoring timer for %pM in state %s (timer adjusted)\n",
 			sta->sta.addr, mplstates[sta->mesh->plink_state]);
 		spin_unlock_bh(&sta->mesh->plink_lock);
 		return;
@@ -691,7 +691,7 @@ void mesh_plink_timer(struct timer_list *t)
 	if (sta->mesh->plink_state == NL80211_PLINK_LISTEN ||
 	    sta->mesh->plink_state == NL80211_PLINK_ESTAB) {
 		mpl_dbg(sta->sdata,
-			"Ignoring timer for %pM in state %s (timer deleted)",
+			"Ignoring timer for %pM in state %s (timer deleted)\n",
 			sta->sta.addr, mplstates[sta->mesh->plink_state]);
 		spin_unlock_bh(&sta->mesh->plink_lock);
 		return;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f51167f0fc46..b323d302ef4f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6623,7 +6623,7 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 			     IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))) {
 		conn->bw_limit = IEEE80211_CONN_BW_LIMIT_80;
 		mlme_link_id_dbg(sdata, link_id,
-				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
+				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz\n");
 	}
 
 	if (req && req->flags & ASSOC_REQ_DISABLE_HE) {
@@ -8733,7 +8733,7 @@ ieee80211_parse_neg_ttlm(struct ieee80211_sub_if_data *sdata,
 			map = ieee80211_get_ttlm(map_size, pos);
 			if (!map) {
 				mlme_dbg(sdata,
-					 "No active links for TID %d", tid);
+					 "No active links for TID %d\n", tid);
 				return -EINVAL;
 			}
 			pos += map_size;
@@ -11011,7 +11011,7 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (len < 1 || len < 1 + *pos) {
 		sdata_info(sdata,
-			   "mlo: reconf: invalid group key data length");
+			   "mlo: reconf: invalid group key data length\n");
 		goto disconnect;
 	}
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 64768abb0a5f..3b5820a0c593 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -318,7 +318,7 @@ void ieee80211_check_rate_mask(struct ieee80211_link_data *link)
 		return;
 
 	sdata_dbg(sdata,
-		  "no overlap between basic rates (0x%x) and user mask (0x%x on band %d) - clearing the latter",
+		  "no overlap between basic rates (0x%x) and user mask (0x%x on band %d) - clearing the latter\n",
 		  basic_rates, user_mask, band);
 	sdata->rc_rateidx_mask[band] = (1 << sband->n_bitrates) - 1;
 }
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 92a4e0450593..958d9ed52fef 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -365,7 +365,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 			}
 		} else {
 			sdata_dbg(sdata,
-				  "Ignore NSS change to invalid %d in VHT opmode notif from %pM",
+				  "Ignore NSS change to invalid %d in VHT opmode notif from %pM\n",
 				  nss, link_sta->pub->addr);
 		}
 	}
-- 
2.53.0

