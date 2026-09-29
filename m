Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010023.outbound.protection.outlook.com [52.103.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56483D669A;
	Tue, 29 Sep 2026 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790648004; cv=fail; b=ENKl8GO6Q64QJnO9HktdGXZMYLxKY6cUmxRcLrjrshkP9iFvKAWMl/nuPLI3G/AF8UDHWgQwQYAGTodppqCJ5hYIVTdg2cZV9+DktLCpv7eX3kxwDR0bHvBJle817IUxbw1rGZc+fIUdqmgyUAPZYumECZCdeVsqmg/slIYIeB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790648004; c=relaxed/simple;
	bh=jlvFPZAQTA5HY/kYg4VCHoNQTFyVh9+Daxwamzvppn0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FryzyZbYahXidrSVpdvHZKUyrfQT+TGZW+ge9EKG5tMzvEfz/w8EtIDNYkBZWgNEi8CdM8XB37+4o0fjaVRn18HvhJSNhkl3Uwww9B1puuXlr3oVANJXd9Dm+vp+8QhD8OYfcWkGgTmUNs832i19gQ7HXuPLlxbU/Rga6lfNXCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=W3x2b17s; arc=fail smtp.client-ip=52.103.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="W3x2b17s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgOmg8+IJZcKPamlFCUVv0ND9xJNMaRIhYpCAv6+FYAejIz+K7SiUJD5J2x3nAJgaZ+jCQeSN5CrSzlliLlDNtWgyNJxMWEy7hl3/eR0Pl4kZiYy9PLZcUl+daSyCTP9vFrVjBb87k3QZkTlHrIWxI4r8P6NH9JwEb6VJBfESC5Z0ZpoWL9trGmi96Cof977qI32Qe2YCGu4u8LVEz/ytzXOq0hRXdTQ2BnKDdXHcnzneKWAk971TLtZWFimLZCc+o3NKhZYMPOfETYhy10qjDXIVz/tjOuHXqbXVmBsp/4ITDHo/pt8FRz3fF2hMOFDMS84KayCDwBgBS0q8kFdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPfjLvkYevzwqKED+gbisyRijMGmm++EnFq4InWjWFs=;
 b=SPos51c9vwAJlDHszJHdSJn9U1sztZNYH0+QiAqZAbQZ0I9vB1J4Rvb+eGIUhVgD3/BlAkcqBsY2JrdsGF9v9X14HND1uhlNqBjPPZuk0Glt63RTVS6CeK0rh3x1iol8uslrBjXF0b6tbAmUeJP+Oa+Gyx7lBirfxtbGZS5FB49YeQt2hMypTGfnBoMaP4StPTGoo7LLUBDu3FvoLt8SZi8qqYsDlh8W+MmMRxRbZuQO6TWNJr2y7RHyVsR8kPWg3UR4XQ5cxq3IukH5rVNqT+nEBdLhXs3v09jBJeuGdtFr3GjkQAIcjRg8QN5d7X6ljphQaVm10+mp9+nS3aVOKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPfjLvkYevzwqKED+gbisyRijMGmm++EnFq4InWjWFs=;
 b=W3x2b17s5Zk4wcHs52yft6OA1Z8qFD1U2X0AdgMgzKd07JNzReBkzO9x55ts2Ygd7GOizyJHrHfcL4AOQ8rlUFQQorWlWJvlfB/3MIdrIdmBCIfQvcCk4oNfZN6uuS685ThzPlqKCMadsZnd5pienh+YTlDwA/NYYm/jdcnKDz23cJS8o4k9zVpWKtNwXkNGaQgyLLh+BwZ52lVxPI5w4HEKya67k8kKroZTUSDM3TrCRVGqV7XE/SKj+FFtVaolPi4wPg5thTSKMFCKeOwFtxFoBjcpuL2poOnK7NxCcCdB8x1UJwWRes9UHYLX6de+wkgzxSeMjDpVvZiLnZuTWQ==
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com (2603:1096:604:1a5::10)
 by TY3PR01MB10453.jpnprd01.prod.outlook.com (2603:1096:400:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:13:19 +0000
Received: from OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b]) by OSZPR01MB8140.jpnprd01.prod.outlook.com
 ([fe80::91ec:49f5:d743:6d5b%4]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:13:19 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: [PATCH wireless-next v2] wifi: mac80211: add missing fmt line break
Date: Tue, 29 Sep 2026 10:12:40 +0800
Message-ID:
 <OSZPR01MB814067378662FBBB72CB11F3BC8C2@OSZPR01MB8140.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::16) To OSZPR01MB8140.jpnprd01.prod.outlook.com
 (2603:1096:604:1a5::10)
X-Microsoft-Original-Message-ID:
 <20260929021241.1144804-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB8140:EE_|TY3PR01MB10453:EE_
X-MS-Office365-Filtering-Correlation-Id: d7540edd-b608-43c2-2cfa-08df1dcf3a7c
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|8060799015|24121999003|25010399006|22091999003|12121999013|4140399003|24021099003|21061999006|41001999006|15080799012|260925184616899003|5062599005|23021999003|5072599009|52005399003|40105399003|12091999003|1602099012|10035399007|2607281247196008|3412199025|4302099013|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n1CBXJrsZzh5IdCG6BNltc8GkizAlk/2VVuVqJzTiTZfD8h6T9JbOnwEflBp?=
 =?us-ascii?Q?z9Xt5gCmtJUjQlVInvc0H+YZ0r27ZtI/4lkCAsIzQQSFH9DtdkoH20SjXqoI?=
 =?us-ascii?Q?+RTyQ8QrQggbVAx6A3tgfIkcVOodxRmSZ2+arwNu80H3QAERWhUbK9LQ9+Qq?=
 =?us-ascii?Q?dChLs3s2Hjfk6wwrMGV+9gHLeNSSgs8BZlVFJ9qZCiqJKxIaV+xEloLuH9gM?=
 =?us-ascii?Q?Cr6eiOCZ735ad5qzITeLjJncHdaEpq1fnwGeQU0M6Z2SmdAmRBcIn3qDuY8d?=
 =?us-ascii?Q?xZ9xEcs39GMGy9gfQKABKlpsFigx++fOVUIeUgWzSQWyh5DaPvDwgEsljIB+?=
 =?us-ascii?Q?CRmbSalElllksuHERTHXn1mjWuYsiT0dWoVBy8U7svQGRWOCxF0YpqHLgjDG?=
 =?us-ascii?Q?B57XvSAQoUu7TBOBRFdA5cpYm/6C8PzYUnzgZPL6ztkIzPo3Z2GkMVYFZwok?=
 =?us-ascii?Q?X0hUnl3ZrpDau4ZeoCxOc6fwxSuRYYVEgXnv8f92ZZ86wXfK5ZVmrPz5r94/?=
 =?us-ascii?Q?ogKL65QKkfHcxcisqHzG1SSrXA4ECQBaPtWgKy8WQdbGG5ke9ut49eySDGAY?=
 =?us-ascii?Q?tJdnGR5DiPr2JGH22MSwR5gc3grhO4Gw78TaMJCZyu9eMQa8Ec73iTeQ24IG?=
 =?us-ascii?Q?OjVmp1O3P6XsYi7hPxhE26UwusSGDMFgH4gSNslNQJk1WpabviLx1Hf/lgw5?=
 =?us-ascii?Q?a5JN2ruqVJJgjXcEd2EE+vl+UDiI1iMDL1fsh52GrIR5IMcjy+t1H6lZVMTQ?=
 =?us-ascii?Q?5k4Ggmv89/wDNtAxMxXf7mx8b2HUVJzlyQ3k2R943QHp6xQyyoxrg0VoYeo8?=
 =?us-ascii?Q?7IzB5lprBvTCm9hWDrMPNXFMmneToIq7ib0B4SNtzmpS4DPS7A2AIrOlMs6I?=
 =?us-ascii?Q?1MpRmQ0+D3aPdglHTBZAGS/Akm5eMuy5+ezZ0In88ZKg0m8G8EggI7DlVSe3?=
 =?us-ascii?Q?I37dWCN2REDBNk26iWYGIqTiQeEZrqubCigLW7JAKg2g35SlCyjPFmpIZ/OY?=
 =?us-ascii?Q?Do+19WLJD8oOI0CLgi7tYVHHpaWI1qivwB42/4wOO/xblqBadPkvCVcVXdKg?=
 =?us-ascii?Q?cAqpMJ+sRb2z2V0rBRXQiIpAvHjNhsFmLajrW8jcojIdAWdab9Ane95g6nak?=
 =?us-ascii?Q?kAMW/pyUIX4eFxlVicWUgK2xrOj8Jemv79n9stT/BdH+MaTuIj4OOBnn4bqE?=
 =?us-ascii?Q?lml62/KBZbPZtcGZqlssKJIC1dn+XzuuT3o+GHYCChPBS9GCOYTfJ2++cvo?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dJMx5LhOKMz3S8K21UVi3GjA7osgvf2l+QhVF32bvFvlcysxwb6nMNTVgVAR?=
 =?us-ascii?Q?9EVBtCdPp/kLRaa7QiedbcG6BvjR/vDGmbmvZeAFiQoZ+d45G2pzl68X0rvZ?=
 =?us-ascii?Q?EpDr/mINXNGHdPIgLJ8TGwkBahkCZ9Y+UM4vH3IPTgVbZn+KBNw1k1am6Y5k?=
 =?us-ascii?Q?uwNBvlSal5+t2YrO0Bf9pUZNeIjgjTAHUF8wMN5v4wXfeBEgqXJzQiutoV0P?=
 =?us-ascii?Q?Ug5y/9wy2ZLkUjCgQB2Srv0x4BnREjuiL4IN72lOb4NQJGG8XA4l6tBnkRFZ?=
 =?us-ascii?Q?ZALdOXmqLapV0NBqJRlZOgYNxBVxXiJKYsbNKGyTCy6wQusaqEUydwaF/SzR?=
 =?us-ascii?Q?wE0bDjgYCAfPmYQIPnhmGSZklL+2lcKP6L5qC9ugaGJVb8FkSKC6RKLU9xAm?=
 =?us-ascii?Q?d2HKBR5j3wxNtyv/9KNJD/Pc6UPdg67kROvJ86BqOvBrqh1WCZCHwfL0fKjQ?=
 =?us-ascii?Q?aP2twWlLbwqrdeYXl36Zbr0wXCem3X5LxwZ65fLfO9bHkDsnRx78if+rBE59?=
 =?us-ascii?Q?7PNm1oUbcLcDgbq6SJLMKocl9pxmedR7RAtaS2g9+RqyIkUj9bcWqiLkvJnw?=
 =?us-ascii?Q?ixtCfdg/rtrkrl6hQTWCQIBENaUFQMo6wF/ZmJg/ekxd18Jba0e9odecnRAI?=
 =?us-ascii?Q?A4+kLW5qAFHYEYeIk0LxEAKU9KYvPnJ3nqgd18nFGI7iJGQNxYZ4xDJvPLax?=
 =?us-ascii?Q?/EXL6t/6BIZ4aLombxANuZYed1HtyqxTzIovjOArhtVWmWpAayPGCuvyFcb2?=
 =?us-ascii?Q?u40xBY1BlaiyNm3l0FD+TGlu5mNXj7ZWd7QU6x2B7xAizwFNYQfVFjrVNmuO?=
 =?us-ascii?Q?kRqSoy9EDd84WC7oD6czVyrRuB03C6p9+936VT4GnWRctmga+c4Gy3sntieE?=
 =?us-ascii?Q?/KUjOOoWInbnr4ea6O4akkgbC+5WUC028e5A3Xp6ggIy1kM2UZb5SdDp5c+Y?=
 =?us-ascii?Q?Ib+qQIAObmeCxdY//+wGq5oAU7DNieuxtVO+Wrk+khTWhATcOpLYS4ybA0ut?=
 =?us-ascii?Q?YYqOUJHXjNrGeImdecpyhMY6gWIioWd8H1qhz+3QtCTerLWUTyZeXwaWQ1RI?=
 =?us-ascii?Q?Ge5+KeX9vli+Lp+5NZGkppam5S3U+wWcRZDaKwSL4D7dApX7dtyXMR3hN0CT?=
 =?us-ascii?Q?oSIz29yGrA8tW3iti/n8DRkhNxucPMupiie6Okqwgu2ZAlkM2GaOHYWBvMz9?=
 =?us-ascii?Q?NX3BojmVQtCjbdlVkEXfLCXEjgoKItnHX7yd7x/UqOC3WHYL6tbY37Zbs7we?=
 =?us-ascii?Q?5wMmiNpEjPWGApfYktBH44URKwYkmgJ0ejh7hUp5WaH5DlMW3QreQKFlBl6S?=
 =?us-ascii?Q?oUjU5mAeWTcibXmc6TW9vejvR+1fhUQweg/ls4sWuBcXUwJ7MlJqc9gQS7yC?=
 =?us-ascii?Q?SokRH/vdwfGC5ZDkvonOJ3i8mPB4?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7540edd-b608-43c2-2cfa-08df1dcf3a7c
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8140.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:13:19.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10453

It was noticed that dmesg sometimes cannot read the last log entry.
Queried using the regex pattern `(?<!\\n)"[,\)]`, then manually checked.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
---

Changes in v2:
- Correct pattern in the commit message `[^\n]"[,)]` --> `(?<!\\n)"[,\)]` 
- Add wireless-next label

V1: https://lore.kernel.org/linux-wireless/OSZPR01MB814085194DDA24DAC2759477BC8C2@OSZPR01MB8140.jpnprd01.prod.outlook.com/

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

