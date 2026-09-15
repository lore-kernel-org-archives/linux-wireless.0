Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51E64399CC
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 05:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450177; cv=none; b=oyZg8y+WLcxck80MMyXmGsRRuBIBtC+1hKw2lp1fIHs0nV0xgqMzApiLktZKBiMgsUPGVfAp1bTRSkEzXYFayAI/J5cEujvbOVwtsL3GTVfyFStVE8vfM1WPOyLb52Iq9NquWqmKB5b8KOpVXFHuEq1QnnVUZLbmCvMJ+ApXOeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450177; c=relaxed/simple;
	bh=uPh9Sj5jl6LGyx3KGZK57jyh89IlUla3noBkL8WXy+0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fT+LrLiE9/1lwhL9LU9nrm8et+u7QFwuzw11oXlHGEZ77+stXChp+P6RWIMA0WSHf81q1hAYtgyjhoVUWLni3qHhDqHkVrVNQUrqcrFL8oBaCegPME2F3W26tTKj10H1ABXekPvVDW/ukfFXvfug3RIg1QXaNd5j+YG56KG07vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pHSR2nYt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RBap2fXY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pHSR2nYt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RBap2fXY"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F2nYiT2298529
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 05:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=mbOqZAw6wTOw63b1G2ExHd4hbkezHdD6QRC
	AfQhtp2o=; b=pHSR2nYtMIC9SwquqTU2J2jPRgVww8itq+ZCa7vVKOyYlvUH15a
	eQBxhNS3bv5eHlCbjRf8z47Cd7YUp+JlOcDh/No+7LGmnep3Sv2RBC+A9p9s25p1
	qOWElfqxvrVc1QsEmt9bCljanUmVv+yYvMCVC5TAVtTsWBGzFGuqYC+2LGEpoCDz
	20cyNoUUxIWIfXVQRsg9/LRhKqmP4wZqax0L1kN8ZZfZH1PwTmrDUzCbAoZfq0zf
	k5XibhRGRMThhbHW6Dpl7+RTy3SQIsK2LDQR1iWBzqdgy1JMuMOsv6wTFJFT3lXt
	tP5mAaczMmS0Z231Z5E7yWcUgaMxWG467lQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpgvtkn3t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 05:29:34 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso7234683a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 22:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789450173; x=1790054973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mbOqZAw6wTOw63b1G2ExHd4hbkezHdD6QRCAfQhtp2o=;
        b=RBap2fXY+fhISrA1xsE8JEIoYGpAegTfd4/I1s3TX2dKnI6EJxiJcMkwadmEAUdLoN
         sWrklkij9Qn2fjL0wsaI1z4DZPZ5EGWSvpjyq+WVnh3zyD4oLumLcmw3k4t2qNFxrKQ/
         iJYu4zpBQXo6G2IEVTnXnL4HskgcxEfJ52J4ezXzL1uktME3Rf6rSkqy6c+uoBIXrQLx
         vRVWd17P6C6NqNW1Tjzrzixs2Xg4Ps1450MB0iMTgQZXWjOuzs9Bu8hNu3NQwiE9mimo
         eRimCibNuy++etMexPcoCnXuh9Y7193NcNM9fSGyo8jso8Kwaoq5TN22trA/T2BqZNAm
         fwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789450173; x=1790054973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbOqZAw6wTOw63b1G2ExHd4hbkezHdD6QRCAfQhtp2o=;
        b=geMnX/9+KRNElOQcfemy1w2yYPybc0G75D4kqjeItsL3KCx8vhUNRhvKRLRe/8OuXS
         H16+2vPyBPO30UvUfLfFi95l2UGUrUZzxu9ImVn4cxA6j0rjq+qN/mNytLpaJbyV4BpZ
         3lBAxy2txOKuizpXMupFr+cjlH6KDHlCKJjzzZeIKQ/5/C6/Pww4IVaRpzDagvAZ0O+O
         d7QXv0+oHsc3lcxTKJrtqjITk9V+AieJKPjlRwSM2R6S1JVpudSZxJwz8GIUzS4QqZT8
         er4dMbg87Czk/sNf54U1TTcIL03T8lCW7rB8cyyyb7IqfU7dtdSztB/GbyrXrr5A4K9o
         5Riw==
X-Gm-Message-State: AFuF++kAUHGfXti180hsqIEq91KEZRbhXH4xtMlK9fqyq32V8m4quVp6
	afh4EZah/bwxku1cIS8pkA1x2JHTLpUodCucI16r9cJlqi1/Zsf0ojFe/hMBin429GJgmGtnPld
	GqZcDnEGIvsdAMedrvok1JwseIh1cnPE6W5Bp3CrwEK9225JgOmXIm6vkxZR5QLVgyWhqlMTEj2
	fCcQ==
X-Gm-Gg: AYBFou2Ws9xsxhO9gFI9nGCTsFZgp6tCDO3eY4pF3X9WGHa647UMw2HZDrIXFDQxxpx
	/UuEh15/2aOhJG/L/ebweOey/Fjav1jl+NZEqZLeZrDcg5fQsBo6WI7/2CFci5dcR9Kp1HzVg7X
	6rMFeebm80dDIQTpsC3Mce+aWE1+4XIKT+izZfxfnm7fBhABEkhR1qYRb+UF8E6qzP5dCCU0miA
	3U4b5rtX23H69lXXlRH5N7olw9IRPj2pEdjeeCTuOBWftPg9yj7+yFc6+GiFuonT/nKb7IFScYS
	luI6lMfutnWRDgbnXGd4RTItILR1CadWCAzTpIrwF0iILlYyDV40NfMQV81UVniJNbuRoQG1t1/
	9/SQzFYDHVXybq80DmNx3rdKTaS9Tm0Ez2JCcbJ1kms8N14zQEF1triq7iQ3pXLmHH0+PdYdCXg
	Ni+40MTP1uDvTD263TaDg7c90=
X-Received: by 2002:a17:90b:17c8:b0:396:65dd:4093 with SMTP id 98e67ed59e1d1-39dec04f9d9mr10779428a91.14.1789450173458;
        Mon, 14 Sep 2026 22:29:33 -0700 (PDT)
X-Received: by 2002:a17:90b:17c8:b0:396:65dd:4093 with SMTP id 98e67ed59e1d1-39dec04f9d9mr10779379a91.14.1789450172943;
        Mon, 14 Sep 2026 22:29:32 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e95075sm30314339eec.11.2026.09.14.22.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 22:29:32 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
Subject: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS parameters for AP_VLAN
Date: Tue, 15 Sep 2026 10:59:23 +0530
Message-Id: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=c/0+0h9l c=1 sm=1 tr=0 ts=6aa8d7be cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=COk6AnOGAAAA:8
 a=EUspDBNiAAAA:8 a=IfjyXQZqvconvXi0t-4A:9 a=mQ_c8vxmzFEMiUWkPHU9:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA3NiBTYWx0ZWRfX0+JryjTUSy1w
 2ntK1fPmyqrnwcsKlTcNQO2JaTOmjTCw+zxPJY/wjNSeSKO317K6OveXeGa2wahA44OX0wwwkiZ
 /VAK9um1uQwo77kD4+MyRdaBkOQIDt1iCX94ZDvs8bCdLBB2bb40I2RKlG5JcpSW+ydVQRmIMof
 EK48ReD/Aht7KpuS3zqPPjRfFdzOA2G2pA1BLKaq1Jdejbq3Dt6OvM9usZqmFdhA3B2TpYZS8Fw
 klN4E6O7g53PT1u4pOavZWHbK5ueVygmEIXy4KZ0kGlD4edZ5IFxhC0lYUOcEQ2NWFseVzVe4fZ
 V9G0AhFULKlTrLVQNiNOhO4ho3MfVNpIVvPIRsNeGQinyf3AXWCiu66BJc/uyF7YV1X9CsaIhQm
 9rrNeb4JOEHt+tREo7HDSK9sKsVnpgykfKdpSVYuQwpBkV3k4SLqKzGtgkoIAQQC9DqOnZ2pIzF
 bQc9a+PTairU1qfQLrQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDA3NiBTYWx0ZWRfX5szh4AapV9CI
 e4botRGjtSoleIafRDed25cYzUtI3TgMMe8t9ltIKKdPmnunZrIyasPvGWgmJmxEUV5yQz64JkI
 Bks5IW6QLufH5p1tYH5ovsiJToyc/DU=
X-Proofpoint-ORIG-GUID: -939WNw65bzXn2-I8Wv5A5H6EzVW1_oy
X-Proofpoint-GUID: -939WNw65bzXn2-I8Wv5A5H6EzVW1_oy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_01,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150076

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
v2:
  -Remove unnecessary sdata->bss NULL check.
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/sta_info.c    | 50 ++++++++++++++++++++++++--------------
 net/mac80211/util.c        | 17 +++++++++++++
 3 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 65311340db40..96978a4a7e2a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2985,6 +2985,8 @@ ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 				    const struct ieee80211_uhr_cap *uhr_cap,
 				    u8 uhr_cap_len,
 				    struct link_sta_info *link_sta);
+struct ieee80211_bss_conf *
+ieee80211_get_sdata_bss_conf(struct ieee80211_sub_if_data *sdata, int link_id);
 
 #if IS_ENABLED(CONFIG_MAC80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_MAC80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fdf00cbf49d8..26c8b41042f8 100644
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
index a96078a6bfa2..3f24862ba713 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4752,3 +4752,20 @@ bool ieee80211_vif_nan_started(struct ieee80211_vif *vif)
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
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		bss_sdata = get_bss_sdata(sdata);
+
+	if (link_id >= 0)
+		return sdata_dereference(bss_sdata->vif.link_conf[link_id],
+					 bss_sdata);
+
+	return &bss_sdata->vif.bss_conf;
+}

base-commit: 27b084bdd009c5c82346d39d7773bab3191dd299
-- 
2.34.1

