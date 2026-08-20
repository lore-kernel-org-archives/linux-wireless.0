Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4A2D9EED
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787203477; cv=none; b=HczNFNuXgUy5IkU8DVYGj8MkzHjZbxnSX68TcsKtAAe7xhgoaBET8c5lwDEsN6urFNl5gp/WJWUP5QCQaSKJ7kecTgPMMcc4Vkle1tV5bcVZae63X+2ReLK7EkUmD5EQ78W8b5xlTbZW7XQUS5fj3G0ZOpuU6DPStBSE02kb3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787203477; c=relaxed/simple;
	bh=up6HLiTczTm1MLidXzlW6DMMOoUFjrStRSohr0Y+mpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Er5mGd+z2A3ZNtY+il5BBJN5lwMY5GaiPL+PNBWHmMYPOrJ/RcD63I/uq9erGtuGH42p8QWHjKGJ7KoUwQFA/vB4KOSlNlp/DbHmw/ANHJ9rfhInhM0VMTtUnaMmVk0bMAoFkBoVTnMn5rUGPDkxaMdasabBzkF/g98zTiBXzGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i0eTCwpn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hyo2+DyT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i0eTCwpn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hyo2+DyT"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL8TJt1458722
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=FomK4b+Z6EE0AuWvd+hS/XzhCyVhhrMuKN8
	vsjrrKOs=; b=i0eTCwpnlYYbUMJqdD4fGf5ofM250rMaPCYj5cRVbn238nlOk7b
	iK2Ns+I0Cc+ZG7/AcideeUBBznEbB/o8J/TKmM3OG5C2einmKP7N2RlY7V+rPCi4
	d5dGBh+vQHYldL0Z/yGma29WxUXhwRkW6fjfBfrNKewGC9PJQA5IxMU/zTEsX3TO
	JLrTs/5/ImJ+J/oypWJmp7fLD9B2tBONognFb0L3/EZfjLDogIwkKCXYn7IhorvL
	Lg/melMGIjlNX53BGLHVlUu/Evf/i2/iODHzkAteaxff+lAfW0WVeZtiMeLW7oXA
	u5iNZNAUMQKPvxYJ2w9W0avwaEvjr4nYx+Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es4b6xw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:24:34 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc86a9ef97so34828305ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787203473; x=1787808273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FomK4b+Z6EE0AuWvd+hS/XzhCyVhhrMuKN8vsjrrKOs=;
        b=hyo2+DyTu8fzKZnZRtgf0TCsVDc1GYwspi+oQzEBcKoQqVKrju0ypln4ptfiOPhZjZ
         alJzjemEElB/p44SmUdBPDc/oK5ja0npU+sLQ+JIjt2b65t1TDU7eGvaTosZ/oLV2NIk
         x7fe/rgygEkLo9g4AB+gqpYGuPbuZc+UQilwDqW0QRVJZN5qni2/Vhx/RV97rGY59IUB
         9ZFyr8gnvNCe2DSm7p4RNHAEKgjszqSRI0Xi7qzpBodWIhYrdH1TzIeOUOLrFh6qR4SC
         fkWSyvYDbbH9TTWMqDkvujOQ67WgWqznHFme/Twx04U5kUP8c5YGPR3H8ltpTP0hqO9Q
         n57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787203473; x=1787808273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FomK4b+Z6EE0AuWvd+hS/XzhCyVhhrMuKN8vsjrrKOs=;
        b=bEowgQOEIBMiY0yIEgLtZh+slod7MhpyzVjguGif5ivdsEgai0ncVbArNOFTv4iX8v
         iGXOftLP8wLji5ibuzHbHz34Jv9E6/MMpvkUWUdLbOFGyN677Q7461asKfHlcS8r+E64
         iFWBObge2x5YLn6SRr3Md8HZtlbPtswUVwFleRkmdzeRn85UmqUXBJ3wsw7FfJA84TSb
         NvCAvsPLeW7su7Jk1uXV4atdughYxCvvRYNaNI4gzj5YFATH/6ovrwQD/ByDDZ3H0rGs
         xnycBM/A0SbUQelCRX5E1liwpBlInGTGtv1c+NOZr7DGc3iKB3lKGu7SijIwc/Y3y+66
         KZCQ==
X-Gm-Message-State: AFuF++lzTS5t5O1S2e1hoMklCgyut2CiKNmj/sAOZihx32syEY3th06z
	gF7l0GKRP4BGM8eSPbNz2dPdjvZW828JvzZVM/NciatfKPUiRwF9dQ3CjoTZ3BfzXm7a9yz3tm8
	Qon3CDONrQDQYYjpRc8BFuU+P5bemAxuoNGv/hWg9uCtd/41VY87zf5ob6bwaxajRDGuyNFWOqG
	9NdA==
X-Gm-Gg: AR+sD10x/nZLtGkRCX9kY0+amml9Z76L1YiBG7g25lZCTQZLSKTH4c9NJOhyIdUGPg9
	4x6yJjHbc8qnY9QUNqixptYr9mJo9g+SulT1dCLs8gLp5JtOKhSqne+2KGoiYyn0k0JpBHPdymX
	MEWS5uy3AWAHqfHV7FTEa62fsPZubqi4JbXe1fxcBTNb3chQbwcol2Gg/DD/JSj8Uijmdj7HrpF
	UABnccx6uS6s94RiFhhck4MBRSKeq1ABiThQxkbbuHr9+7j/VGAwxlMaFuOzgjNC0aQSbY8++Xf
	BNuyLXf0xYIQo9qnGIU5OXMWEQC6wM4LKAGuyy0EFUnFxPvVYimUM+aETdAVq+1YAfMEdFnsy42
	yW7dDmBmKtla3fD62FlaK0iLCO7mqesPORcPa4et2ybvQFoPeeycfAQgJtiadNi+ze9+trsum9I
	C0FsoCSVRo5IiYqH7G5vIjyEg=
X-Received: by 2002:a17:902:ef43:b0:2d5:e9d5:8ae with SMTP id d9443c01a7336-2d5fd62ae4fmr195489345ad.5.1787203473337;
        Wed, 19 Aug 2026 22:24:33 -0700 (PDT)
X-Received: by 2002:a17:902:ef43:b0:2d5:e9d5:8ae with SMTP id d9443c01a7336-2d5fd62ae4fmr195488625ad.5.1787203472853;
        Wed, 19 Aug 2026 22:24:32 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cb9f8sm2120665ad.73.2026.08.19.22.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:24:32 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
Subject: [PATCH wireless-next] wifi: mac80211: Report parent AP BSS parameters for AP_VLAN
Date: Thu, 20 Aug 2026 10:54:26 +0530
Message-Id: <20260820052426.3177309-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: GnE8FQlhMoM3Rxi0rbIeZXMj00SlqGIt
X-Authority-Analysis: v=2.4 cv=PZXPQChd c=1 sm=1 tr=0 ts=6a868f92 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=COk6AnOGAAAA:8
 a=EUspDBNiAAAA:8 a=IfjyXQZqvconvXi0t-4A:9 a=1OuFwYUASf3TG4hYMiVC:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDAzNiBTYWx0ZWRfXwfwRXFa12I/R
 IJ6I5+QkBxBaCiSLsAtE63GfKR/3SZnczglOYCCuoAJH6gm+jNpigd1RjALIu8f6vQxg6JZfDNa
 hYMa96vA4/0KlJr+HdVxTU1yt064wCA=
X-Proofpoint-GUID: GnE8FQlhMoM3Rxi0rbIeZXMj00SlqGIt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDAzNiBTYWx0ZWRfX8JKXy7eiuMFU
 CjJNhuiWU+tY+RR6NwFs4Cqzcy2yBa9mAQJHZ3NkyGbxHF3FmbYs8tZx0XtYECHmtPW0DHrUcEx
 HMDhZDs3fTYdldKlaexn/QbNJs76n602dYesqt9CPwn/+9NOSvciab2WgZwYMcHS6ySWpUb//wS
 mSJBOzl8r7xzkEMy/0OhVVRnPmjuTgyypANDZ6Czt8OeTI39VM0V8+0TwENP4H+z4w3DF8P511Z
 D1OA4C7bGUaOEtW/oBcq0+3+SMRBnBHVWnoED8rjrA5n+p9KXdrpJa1NQqj3WIMLgvxZ4IBHjI2
 HYmaUnEtX8xbt2oYmpM+BlTzcsK7CaQvew87S+8VxUYEhSXy3ZKjnA0j2TonS+SilAsaG5lyzfv
 zkcpY0vxrz+0WnVRSi0pVP9+QhkBG6PSS82jF2hZ0WA9l1pNUTmhIAaTn9Kks3FugIHRifR5gGp
 0AHJA3nJjos2gG9Xx+g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200036

AP_VLAN interfaces do not maintain independent BSS configuration.
When station information is reported for a 4-address station, BSS
parameters are read from the AP_VLAN interface, causing beacon interval,
DTIM period and BSS capability flags to be reported incorrectly.

Read the BSS configuration from the parent AP when populating station
information for AP_VLAN interfaces. This ensures that beacon interval,
DTIM period, CTS protection, short preamble and short slot time reflect
the parent AP configuration for both legacy and MLO station dumps.

For MLO, the per-link BSS configuration is used so that CTS protection,
short preamble and short slot time reflect the configuration of the
corresponding parent AP link.

Only advertise NL80211_STA_INFO_BSS_PARAM when a valid BSS
configuration is available. This avoids reporting zero-valued BSS
parameters when corresponding BSS configuration is unavailable.

Co-developed-by: Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
Signed-off-by: Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/sta_info.c    | 50 ++++++++++++++++++++++++--------------
 net/mac80211/util.c        | 21 ++++++++++++++++
 3 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..f3e49d980a26 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2982,6 +2982,8 @@ ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 				    const struct ieee80211_uhr_cap *uhr_cap,
 				    u8 uhr_cap_len,
 				    struct link_sta_info *link_sta);
+struct ieee80211_bss_conf *
+ieee80211_get_sdata_bss_conf(struct ieee80211_sub_if_data *sdata, int link_id);
 
 #if IS_ENABLED(CONFIG_MAC80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_MAC80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fdf00cbf49d8..7635e600d1df 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2843,6 +2843,7 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	struct ieee80211_sta_rx_stats *last_rxstats;
 	int i, ac, cpu, link_id = link->link_id;
 	struct link_sta_info *link_sta_info;
+	struct ieee80211_bss_conf *bss_conf;
 	u32 thr = 0;
 
 	last_rxstats = sta_get_last_rx_stats(sta, link_id);
@@ -2864,7 +2865,6 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 				link_sinfo);
 
 	link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
-			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -3038,14 +3038,21 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	}
 
 	link_sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	link_sinfo->bss_param.dtim_period = link->conf->dtim_period;
-	link_sinfo->bss_param.beacon_interval = link->conf->beacon_int;
+
+	bss_conf = ieee80211_get_sdata_bss_conf(sdata, link_id);
+	if (bss_conf) {
+		if (bss_conf->use_cts_prot)
+			link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+		if (bss_conf->use_short_preamble)
+			link_sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+		if (bss_conf->use_short_slot)
+			link_sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+		link_sinfo->bss_param.dtim_period = bss_conf->dtim_period;
+		link_sinfo->bss_param.beacon_interval = bss_conf->beacon_int;
+		link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
+	}
 
 	thr = sta_get_expected_throughput(sta);
 	if (!thr && (link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
@@ -3081,6 +3088,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_bss_conf *bss_conf;
 	u32 thr = 0;
 	int i, ac, cpu;
 	struct ieee80211_sta_rx_stats *last_rxstats;
@@ -3099,7 +3107,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
-			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_ASSOC_AT_BOOTTIME) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
@@ -3268,14 +3275,21 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 #endif
 
 	sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
-	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
+
+	bss_conf = ieee80211_get_sdata_bss_conf(sdata, -1);
+	if (bss_conf) {
+		if (bss_conf->use_cts_prot)
+			sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+		if (bss_conf->use_short_preamble)
+			sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+		if (bss_conf->use_short_slot)
+			sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+		sinfo->bss_param.dtim_period = bss_conf->dtim_period;
+		sinfo->bss_param.beacon_interval = bss_conf->beacon_int;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
+	}
 
 	sinfo->sta_flags.set = 0;
 	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a96078a6bfa2..edef61d061ae 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4752,3 +4752,24 @@ bool ieee80211_vif_nan_started(struct ieee80211_vif *vif)
 	return vif->type == NL80211_IFTYPE_NAN && sdata->u.nan.started;
 }
 EXPORT_SYMBOL_GPL(ieee80211_vif_nan_started);
+
+struct ieee80211_bss_conf *
+ieee80211_get_sdata_bss_conf(struct ieee80211_sub_if_data *sdata, int link_id)
+{
+	struct ieee80211_sub_if_data *bss_sdata = sdata;
+
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		if (!sdata->bss)
+			return NULL;
+
+		bss_sdata = get_bss_sdata(sdata);
+	}
+
+	if (link_id >= 0)
+		return sdata_dereference(bss_sdata->vif.link_conf[link_id],
+					 bss_sdata);
+
+	return &bss_sdata->vif.bss_conf;
+}

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.34.1

