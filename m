Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952001;
	b=gDSvm+UrXtwCaDMIDExeweg59nBrktaswDuBqDKILkfM2sNwHIG8PkXr/gPqJLu9lfpR
	 99Rjwv1p0EMr+P9SYJFl7cwqAGB09jq6jOFlfhcrmWKf5pWuppDdA6OiidqrJsjeHq0+L
	 ZsE6TAvf7kAvdwRGEUrMY9/OaKRGOWTuyuoqonP/ythH0Uhhfzve/LERNN/KAoWd2t/df
	 NhOpB+LIf4MHSdtlgrCijs/KPQIeMLt8EUbqdSpRo778CxBBOLai/v6zJ8WtRBpQ1P9cg
	 Fdf2UIjWwSQOG6VQc6mArEHnLCWwyxTrh1sD96EOyZbBiXQ25Svs2o2fSE7U9evpc/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952001;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KTKcAwLOikNJ3R6KQCByC0yWmWzKZzmc0JpPYgX5RpI=;
	b=zGRKL9alnSyy9z3JXcji/pcB43aPd/Ekpr22g5vafHkRuA8L7yGu76vXeuDwRnRCzeUY
	 GzRDbrORgeci/mN7nnPx0h/z0b2F9Jw6Irzrc0ai6xzz+Oo3ttB+BSNwIzMwrtTtWWc0/
	 snZ9CJpvCNPxQvQNlRFiRecBH8CXye+waMjCQaawMHCM/ldHUGgEoTbMInJDT5QwElR4m
	 uCTaCBxPKsA1MG7dsyMH39GhtZ/Pkix20S+7GAOwAfl91FVAizoLTZ32HXH/itmlgy4PS
	 XuKIhH0WzcZbyJr1VKDvrpoVD3TXrJbPWOid0BTvCbxljro7W3kLMt2tcaX/so8ntcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AGLGQS2v;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dKW+Kqux;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716A606EEA7
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8716A606EEA7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AGLGQS2v;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dKW+Kqux
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67R30a128995
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KTKcAwLOikNJ3R6KQCByC0yWmWzKZzmc0JpPYgX5RpI=; b=AGLGQS2vF6NbCcx9
	vE+Xxk/YuinJTBf/MJy/YGfuzbZEEb00vZJ8MWMOjC5cNF/FumTjK8Hg3ybYZ6XJ
	OIfXaBe/Enh+SRLgvajzwGbTBcy/lPYYsE5YSIm4aJrAnvtrsMlR0PD3Uw86ZNt9
	eII2f3zRNZvi9Jks7LEgyl5oQygA0CGa8dOrn2eBG+I7Oc97bf+OYNeJmAfmojlA
	4lJgZH0z4TUB8yiB78hci9kiWC9gM9qrAUgzP997DDbYY3LZzLfws7s7c7yQeN9a
	VTsjfzeNgDV5R3itl4s7vVYrx5FnoNwnCw06m3d7S4EJ44JyyBiGL09lmBOzSIQ0
	ZjDb9g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9sr7w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:59 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b09a466295so366250a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951999; x=1794556799; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KTKcAwLOikNJ3R6KQCByC0yWmWzKZzmc0JpPYgX5RpI=;
        b=dKW+KquxoR8sradPWwPtnLOpUl4M+h7rTNM2mqgte2oOB6UUtlxO1sVO34OwTVquIA
         BDgzLOpZt/uYjQN4mf9kyRtdr0PBGmmBosegOm0MLwLhWknGKwbWK2VPTKwDqAe979Mn
         +Gv9b9NcbPxqnz2URmONfbQBMOrJWdfcu9+nH2PQU+PbWHDSJGru5eEbjrCs1JK3PR5T
         ldZa6bX6KtiEbJZ9by269KxLkcmOctxOa6WI8yVmwPX4PnKZT1eWz4kRHuYx/H5LZb0J
         X83R70enCetNGM3k5XaPYoN/kzjzT69jJE8CR8va8y6dBHWRAjTJoXSwPY0kEEowhb2m
         QUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951999; x=1794556799;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KTKcAwLOikNJ3R6KQCByC0yWmWzKZzmc0JpPYgX5RpI=;
        b=A/g9rUhw2gAtUCHj37tP/JlU9xyTk9x8+oJpPRwV+9Hz2E0TKTIIoUldW9CssYRbjB
         6zXNsjFojWYX90xckaZ4oDSke1aItVVOylQn20ftruKye5gXDiAwfUVp3vV+zjOzhC47
         /i9IXjAeEt2826U2r4O2nYSGNJa4jPgrmm3lI7NZcSIzuJEPs5cxQzFKOcwJTP7i2ovZ
         e376GaM/t3XqdHs3kbRN2m+euU3iCCyXzkev9B3UboQTxC1A2yjEPy3a5CvYQ5YYLvkO
         qORXo4Qg1AANEIweuzeSW4GIKxVn5WM68K01EEV0EHLwYyDpBnpVV5AyLHtuMq0GGyg8
         L0/g==
X-Gm-Message-State: APuU4Z/+FhGcJhMHi8Ls+Gj1ioiZSmfL81sNEIAUOE1oTb2eHaI+voiU
	2G3kLWlFu2chDx+9M1dm5ntsTDyNY/tFWR8o+qfZyZpOZVpGFL1nzPoCFBrn9mpKIh+O84tjIg3
	+L0W1LakYaACr8/Qs15LwJdK8MztgRGvrB7v2FkPJkMzFGN7jH6REgqmInEpfQ4mUDkui
X-Gm-Gg: AYBFou02+a8EAJhfPvjHJgUHxmxzAvk7gbd535S/OsKOKVEs0SAV+t3OE77DGpIuDrg
	o9R/Ns2MaYYkMzW6sJo11ICTz3XqhjXRaonB11LMq/OkH+YYjSf+lMzqkaZdMxbbXh8CS24EtUA
	JjgwHMbjCkKVyYKLglGw41CcnL9ZxTe0bQlzxHq3AogwXlNS44+/wC9x3JTZcZte4C4ssIkl0ID
	MjuWOT0e4DMVnURfLrYpofK4Po+MRLlKsK12sXva1V4iBd9e7gLhvK2XEpGsuXD0uMgI/17/udk
	Sc6DgAIyqfseEFru2uEtl/02LnlGvesMe9PROQ9gzBHG/b+ONj2vUqx9fozkGAiHlDYriYmm8vk
	zQG3AiwnuggVQuJ0q4P0xyrK/3jwlF3FZrwfxUS/L6Cq9au1f+mtg/X+h3y9Jz7Y0rKSx/9Ri45
	bJ7NbMocqOm0i4PrXemk3mEjyNNqaFkzpdFMBhxj7LZUB0decIquhBkqKpCGA3yNF0GmUZ4zA=
X-Received: by 2002:a17:90b:580b:b0:3aa:f4af:1e16 with SMTP id 98e67ed59e1d1-3b0db5f1545mr1636083a91.7.1793951998640;
        Thu, 05 Nov 2026 23:59:58 -0800 (PST)
X-Received: by 2002:a17:90b:580b:b0:3aa:f4af:1e16 with SMTP id 98e67ed59e1d1-3b0db5f1545mr1636058a91.7.1793951998086;
        Thu, 05 Nov 2026 23:59:58 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:57 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:51 +0530
Subject: [PATCH wireless-next v4 14/21] wifi: mac80211: add driver_op for
 SMD substate changes
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-smd-v4-14-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXzRnPYyokMzj8
 IO6AD3tTpU8U5myA7Y8GuH8e4hKg7sJv25QM2oLPoNRbq427qfRyS4pB/0JoG64NHf8WOJIR2ez
 8/zCmtpsVJAV+lvKkVm0LljT8dLR+0w=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXy5RolsQazGqf
 7RiBB07molHvj4ohGD5dGvLLk3X16VSbFNACSeB1rFPFvv9L5gj3l7Z40kp1Y49cjozUMf7KE7q
 lhoSejMzMI0NnAPWY+4cYFrVJCjiDRVEyPEDeZKBZVBq3L3MaZmJdL24VPO6extN6DwthmR8Y99
 o5Y8T49e1X691ISy4V7azj640Re4rx4lrSY4zLOCySYOjlqX4B1IAu8a05eik67Yo4GDfem58JH
 54UdKuBT++2CosD/w/wMmMqXnvL62/12z0My1eCmJQ26MKoaLueRDGaOzaz+UpfJp7ReJnvSIZW
 o9TZ4qzrjr4BJG0RH0mVlcK89wIoZCTb6+yEp/ut8Vb27fkUxnIu+IGd4ogWWd0rGsrQdV88JNn
 1Or5ynJKb0JTrxp39aIpvrbfln3MDc3nekQYGHUQwGBttygVaMvi0B77o8Nf68JchQCj4KLBqRE
 kDgGCycVXssYEo2a6hA==
X-Proofpoint-ORIG-GUID: l0cn2bXDFKvUqC8VRnr0v6sCd54JlVTH
X-Authority-Analysis: v=2.4 cv=f6Pdl+yM c=1 sm=1 tr=0 ts=6aed88ff cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=uScroKfZLg1nAwDi7sIA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: l0cn2bXDFKvUqC8VRnr0v6sCd54JlVTH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

During SMD BSS Transition, a non-AP MLD moves through sub-states 4a,
4b, and 4c that impose different frame-filtering rules on the AP MLD.

Add a new driver op that mac80211 calls on each sub-state transition.
This lets drivers perform the necessary hardware queue and filtering
adjustments at each phase of the SMD BSS Transition.

Valid transition order:
  NONE  -> PREP  (ST preparation completed at the target AP MLD)
  NONE  -> EXEC  (ST execution in progress at the current AP MLD)
  EXEC  -> DRAIN (DL drain period started at the current AP MLD)

Suggested-by: Rohan Dutta <drohan@qti.qualcomm.com>
Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/net/mac80211.h    |  26 +++++++++
 net/mac80211/cfg.c        |  59 ++++++++++++++-----
 net/mac80211/driver-ops.c |  24 ++++++++
 net/mac80211/driver-ops.h |   6 ++
 net/mac80211/sta_info.c   | 140 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   |   9 +++
 net/mac80211/trace.h      |  33 +++++++++++
 7 files changed, 284 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23a3f08c72e3..96acdb9ae8f0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4092,6 +4092,24 @@ struct ieee80211_prep_tx_info {
 	int link_id;
 };
 
+/**
+ * enum ieee80211_sta_smd_state - SMD BSS Transition sub-state
+ *
+ * Tracks the 802.11bn SMD BSS Transition sub-state (IEEE P802.11bn/D2.0,
+ * Aug 2026, subclause 11.3.1) for a specific (non-AP MLD, AP MLD) association.
+ *
+ * @IEEE80211_STA_SMD_NONE:  Plain State 4. No sub-state active.
+ * @IEEE80211_STA_SMD_PREP:  State 4a. STA prepared at the target AP MLD
+ * @IEEE80211_STA_SMD_EXEC:  State 4b. ST execution active at the current AP MLD
+ * @IEEE80211_STA_SMD_DRAIN: State 4c. DL draining period at the current AP MLD
+ */
+enum ieee80211_sta_smd_state {
+	IEEE80211_STA_SMD_NONE,
+	IEEE80211_STA_SMD_PREP,
+	IEEE80211_STA_SMD_EXEC,
+	IEEE80211_STA_SMD_DRAIN,
+};
+
 /**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
@@ -4771,6 +4789,9 @@ struct ieee80211_prep_tx_info {
  * @set_eml_op_mode: Configure eMLSR/eMLMR operation mode in the underlay
  *	driver according to the parameter received in the EML Operating mode
  *	notification frame.
+ * @sta_smd_state: Notifies low level driver about IEEE 802.11bn SMD substate
+ *	transition of a station. It must not fail while transitioning down.
+ *	The callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5184,6 +5205,11 @@ struct ieee80211_ops {
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct ieee80211_eml_params *eml_params);
+	int (*sta_smd_state)(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
+			     enum ieee80211_sta_smd_state old_state,
+			     enum ieee80211_sta_smd_state new_state);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1e0ef74a7420..af9fe323c11b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2711,7 +2711,9 @@ static int sta_apply_smd_state_flags(struct sta_info *sta,
 	u32 expected_mask = BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
 			    BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
 			    BIT(NL80211_STA_FLAG_SMD_DL_DRAIN);
+	enum ieee80211_sta_smd_state new_ss;
 	u32 smd_flags;
+	int err;
 
 	if (!(mask & expected_mask))
 		return 0;
@@ -2731,6 +2733,22 @@ static int sta_apply_smd_state_flags(struct sta_info *sta,
 	    (smd_exec_current || smd_dl_drain))
 		return -EINVAL;
 
+	if (smd_prep_target)
+		new_ss = IEEE80211_STA_SMD_PREP;
+	else if (smd_exec_current)
+		new_ss = IEEE80211_STA_SMD_EXEC;
+	else if (smd_dl_drain)
+		new_ss = IEEE80211_STA_SMD_DRAIN;
+	else
+		new_ss = IEEE80211_STA_SMD_NONE;
+
+	if (new_ss == sta->smd_state)
+		return 0;
+
+	err = sta_info_move_smd_state(sta, new_ss, true);
+	if (err)
+		return err;
+
 	if (smd_prep_target) {
 		clear_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
 		clear_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
@@ -2830,26 +2848,17 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.spp_amsdu = set & BIT(NL80211_STA_FLAG_SPP_AMSDU);
 
 	if (mask & BIT(NL80211_STA_FLAG_SMD)) {
-		if (set & BIT(NL80211_STA_FLAG_SMD))
+		if (set & BIT(NL80211_STA_FLAG_SMD)) {
 			set_sta_flag(sta, WLAN_STA_SMD);
-		else if (test_sta_flag(sta, WLAN_STA_SMD))
+		} else if (test_sta_flag(sta, WLAN_STA_SMD)) {
+			sta_info_reset_smd_state(sta, true);
 			clear_sta_flag(sta, WLAN_STA_SMD);
+		}
 	}
 
 	if (params->smd_params.smd_sta)
 		sta->sta.smd_params = params->smd_params;
 
-	/*
-	 * SMD BSS Transition sub-states (IEEE P802.11bn/D2.0, Aug 2026,
-	 * subclause 11.3.1).
-	 * Only meaningful for SMD-capable stations (WLAN_STA_SMD set).
-	 */
-	if (test_sta_flag(sta, WLAN_STA_SMD)) {
-		ret = sta_apply_smd_state_flags(sta, mask, set);
-		if (ret)
-			return ret;
-	}
-
 	/* mark TDLS channel switch support, if the AP allows it */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !sdata->deflink.u.mgd.tdls_chan_switch_prohibited &&
@@ -2954,6 +2963,17 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			return ret;
 	}
 
+	/*
+	 * SMD BSS Transition sub-states (IEEE P802.11bn/D2.0, Aug 2026,
+	 * subclause 11.3.1).
+	 * Only meaningful for SMD-capable stations (WLAN_STA_SMD set).
+	 */
+	if (test_sta_flag(sta, WLAN_STA_SMD)) {
+		ret = sta_apply_smd_state_flags(sta, mask, set);
+		if (ret)
+			return ret;
+	}
+
 	/* Mark the STA as MLO if MLD MAC address is available */
 	if (params->link_sta_params.mld_mac)
 		sta->sta.mlo = true;
@@ -3038,6 +3058,19 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 	 */
 	if (!err && sdata->vif.type == NL80211_IFTYPE_NAN_DATA)
 		ieee80211_nan_update_ndi_carrier(sta->sdata);
+
+	/*
+	 * SMD sub-state was set in sta_apply_parameters() before the station
+	 * was inserted so drv_sta_smd_state() was skipped (WLAN_STA_INSERTED
+	 * was not yet set). Walk the driver step-by-step to the target state.
+	 */
+	if (!err && test_sta_flag(sta, WLAN_STA_SMD) &&
+	    sta->smd_state != IEEE80211_STA_SMD_NONE) {
+		err = sta_info_move_drv_smd_state(sta);
+		if (err)
+			WARN_ON(__sta_info_destroy(sta));
+	}
+
 	return err;
 }
 
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1f3e0765a8ab..710efbfeeb31 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -709,3 +709,27 @@ int drv_link_sta_statistics(struct ieee80211_local *local,
 
 	return 0;
 }
+
+int drv_sta_smd_state(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct ieee80211_sta *sta,
+		      enum ieee80211_sta_smd_state old_state,
+		      enum ieee80211_sta_smd_state new_state)
+{
+	int ret = 0;
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_sta_smd_state(local, sdata, sta, old_state, new_state);
+	if (local->ops->sta_smd_state)
+		ret = local->ops->sta_smd_state(&local->hw, &sdata->vif,
+						sta, old_state, new_state);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 78230779e7fb..0cdd1f1c5315 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1805,4 +1805,10 @@ drv_nan_peer_sched_changed(struct ieee80211_local *local,
 	return ret;
 }
 
+int drv_sta_smd_state(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct ieee80211_sta *sta,
+		      enum ieee80211_sta_smd_state old_state,
+		      enum ieee80211_sta_smd_state new_state);
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..d4d1008887c9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -701,6 +701,7 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_init_frag_cache(&sta->frags);
 
 	sta->sta_state = IEEE80211_STA_NONE;
+	sta->smd_state = IEEE80211_STA_SMD_NONE;
 
 	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		sta->amsdu_mesh_control = -1;
@@ -1527,6 +1528,20 @@ static int _sta_info_move_state(struct sta_info *sta,
 		WARN_ONCE(err,
 			  "Driver is not allowed to fail if the sta_state is transitioning down the list: %d\n",
 			  err);
+
+		/* revert SMD states if STA has transitioned down */
+		if (new_state == IEEE80211_STA_AUTH &&
+		    sta->sta_state == IEEE80211_STA_ASSOC) {
+			if (test_sta_flag(sta, WLAN_STA_SMD) &&
+			    sta->smd_state == IEEE80211_STA_SMD_PREP)
+				sta_info_reset_smd_state(sta, true);
+		} else if (new_state == IEEE80211_STA_ASSOC &&
+			   sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+			if (test_sta_flag(sta, WLAN_STA_SMD) &&
+			    sta->smd_state != IEEE80211_STA_SMD_NONE &&
+			    sta->smd_state != IEEE80211_STA_SMD_PREP)
+				sta_info_reset_smd_state(sta, true);
+		}
 	}
 
 	sta->sta_state = new_state;
@@ -3910,3 +3925,128 @@ bool ieee80211_link_sta_update_rc_bw(struct ieee80211_link_data *link,
 
 	return true;
 }
+
+int sta_info_move_smd_state(struct sta_info *sta,
+			    enum ieee80211_sta_smd_state new_ss,
+			    bool notify)
+{
+	enum ieee80211_sta_smd_state old_ss = sta->smd_state;
+	struct ieee80211_local *local = sta->local;
+	bool notify_driver;
+	int err;
+
+	might_sleep();
+
+	if (old_ss == new_ss)
+		return 0;
+
+	switch (new_ss) {
+	case IEEE80211_STA_SMD_NONE:
+		if (old_ss != IEEE80211_STA_SMD_PREP &&
+		    old_ss != IEEE80211_STA_SMD_EXEC &&
+		    old_ss != IEEE80211_STA_SMD_DRAIN)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+		if (old_ss != IEEE80211_STA_SMD_NONE)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_SMD_DRAIN:
+		if (old_ss != IEEE80211_STA_SMD_EXEC)
+			return -EINVAL;
+		break;
+	case IEEE80211_STA_SMD_PREP:
+		if (old_ss != IEEE80211_STA_SMD_NONE)
+			return -EINVAL;
+		break;
+	default:
+		sdata_err(sta->sdata, "invalid smd state %d", new_ss);
+		return -EINVAL;
+	}
+
+	sta_dbg(sta->sdata, "moving STA %pM SMD state %u -> %u\n",
+		sta->sta.addr, old_ss, new_ss);
+
+	notify_driver = notify && test_sta_flag(sta, WLAN_STA_INSERTED);
+
+	if (new_ss > old_ss && notify_driver) {
+		err = drv_sta_smd_state(local, sta->sdata, &sta->sta, old_ss,
+					new_ss);
+		if (err)
+			return err;
+	}
+
+	if (new_ss < old_ss && notify_driver) {
+		err = drv_sta_smd_state(local, sta->sdata, &sta->sta, old_ss,
+					new_ss);
+		/* driver should not fail moving down SMD states */
+		WARN_ONCE(err,
+			  "Driver should not fail moving down SMD states: %d\n",
+			  err);
+	}
+
+	sta->smd_state = new_ss;
+
+	return 0;
+}
+
+void sta_info_reset_smd_state(struct sta_info *sta, bool notify)
+{
+	if (sta->smd_state == IEEE80211_STA_SMD_NONE)
+		return;
+
+	/* DRAIN -> NONE, EXEC -> NONE or PREP -> NONE */
+	WARN_ON_ONCE(sta_info_move_smd_state(sta, IEEE80211_STA_SMD_NONE,
+					     notify));
+
+	clear_sta_flag(sta, WLAN_STA_SMD_PREP_TARGET);
+	clear_sta_flag(sta, WLAN_STA_SMD_EXEC_CURRENT);
+	clear_sta_flag(sta, WLAN_STA_SMD_DL_DRAIN);
+}
+
+int sta_info_move_drv_smd_state(struct sta_info *sta)
+{
+	enum ieee80211_sta_smd_state new_ss = sta->smd_state;
+	struct ieee80211_local *local = sta->local;
+	int err = 0;
+
+	if (!test_sta_flag(sta, WLAN_STA_INSERTED))
+		return 0;
+
+	switch (new_ss) {
+	case IEEE80211_STA_SMD_PREP:
+		err = drv_sta_smd_state(local, sta->sdata, &sta->sta,
+					IEEE80211_STA_SMD_NONE,
+					IEEE80211_STA_SMD_PREP);
+		if (err)
+			goto rollback;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+	case IEEE80211_STA_SMD_DRAIN:
+		err = drv_sta_smd_state(local, sta->sdata, &sta->sta,
+					IEEE80211_STA_SMD_NONE,
+					IEEE80211_STA_SMD_EXEC);
+		if (err)
+			goto rollback;
+
+		if (new_ss == IEEE80211_STA_SMD_DRAIN)
+			err = drv_sta_smd_state(local, sta->sdata, &sta->sta,
+						IEEE80211_STA_SMD_EXEC,
+						IEEE80211_STA_SMD_DRAIN);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!err)
+		return 0;
+
+	/* if EXEC -> DRAIN failed in the driver, notify EXEC -> NONE */
+	WARN_ON_ONCE(drv_sta_smd_state(local, sta->sdata, &sta->sta,
+				       IEEE80211_STA_SMD_EXEC,
+				       IEEE80211_STA_SMD_NONE));
+
+rollback:
+	sta_info_reset_smd_state(sta, false);
+	return err;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2e9bb2ab567f..d6b40bc3f404 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -723,6 +723,7 @@ struct ieee80211_sta_removed_link_stats {
  *	would be assigned to link[link_id] where link_id is the id assigned
  *	by the AP.
  * @rem_link_stats: accumulated removed link stats
+ * @smd_state: Sub-state for STAs in SMD BSS Transition
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -799,6 +800,8 @@ struct sta_info {
 	struct link_sta_info __rcu *link[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_sta_removed_link_stats rem_link_stats;
 
+	enum ieee80211_sta_smd_state smd_state;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -1177,4 +1180,10 @@ static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 	return r;
 }
 
+int sta_info_move_smd_state(struct sta_info *sta,
+			    enum ieee80211_sta_smd_state new_ss,
+			    bool notify);
+void sta_info_reset_smd_state(struct sta_info *sta, bool notify);
+int sta_info_move_drv_smd_state(struct sta_info *sta);
+
 #endif /* STA_INFO_H */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ea46c3cca21a..83b06e9f72ac 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -3431,6 +3431,39 @@ TRACE_EVENT(drv_nan_peer_sched_changed,
 	)
 );
 
+TRACE_EVENT(drv_sta_smd_state,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 enum ieee80211_sta_smd_state old_state,
+		 enum ieee80211_sta_smd_state new_state),
+
+	TP_ARGS(local, sdata, sta, old_state, new_state),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u32, old_state)
+		__field(u32, new_state)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->old_state = old_state;
+		__entry->new_state = new_state;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT
+		" smd_state: %d->%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		__entry->old_state, __entry->new_state
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.34.1

