Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED2F496D5E
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590519; cv=none; b=uzQqAh5G9ugi7a5wCySQQ4D5rIWfrxp/RcvS2wzAkpW0eSl6CfNVD0iEka4C+QMP2LG9c/HHAUwF3cukxoDZXj5E6miFPOyBwo0LzK1rG5zZQnKvtm+tVpQBc2KMAMNcZ9IiMgu/SW/G5XxwjtwQOWm/p880EQVXH9soF2XkgdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590519; c=relaxed/simple;
	bh=890wyLLlYwAtmhSaUHiJHIE/HBSF6HgoLdH6glta0y4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kdnyl8mKWamzoY7YVDAbXSk+hVL7/bojL2kNGqk8Qu+U8JPiHZoadRAWVdXQ66OL+b+O31Z/nYwFtVO2saH3vH1bQ4KAjfmCKpOLMNTP+5Q+28ncb6H26F0objfAvorQt7nuZWajhfErO3vtveaCzdSZ6/jTZQbTQ/ILJHMDBKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a+1Unh/1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HVjKVNnt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a+1Unh/1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HVjKVNnt"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9M53M245895
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=KFBzfMUObrB6oJurf3VePte6bIEXkN56PtE
	7y8y904o=; b=a+1Unh/1ToyahMiQwT/pIGlxLRLcz21zBFl7wWfd10I4KSuMPD3
	a4ZSQ9WnLNIe1hdBSbEsiOF5Mcr/Jspt/Df3rkTM5BdW/7HtU6fRaeWrMzzGK9en
	suy7vwf6zvL9brCAbm4RU35YnQtTqsFC1XMgaWK6ImdBsOJ2N/i4JL57KS6IC8TH
	asjqaWlimaoC+NDYzAegeHmIQsQR+9NQXX5C+yyZjCyYBo3kJoBthjKkcWBOoeYV
	NNZ4Wbd3e+fxpptrTcB/xgsmcIlz+LCkC5Gro6IqHu+wL+XCkFFhzw2z8dway+6/
	4eQrsRG/oFmd/oYOv0NT1icOdTUbz0lO4uw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyjt10w6d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:15:17 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso2980079a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 03:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790590514; x=1791195314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KFBzfMUObrB6oJurf3VePte6bIEXkN56PtE7y8y904o=;
        b=HVjKVNnt7EcFem/MTvZb+XKv0JwagrIeMry0H3eRaWs76XSJ8g7+w4oWogqkOgSsEr
         NS+rowRy9QtelnVyGyT5piMpMVCIrm6pENcM5CDZFVtm7LT3/ABAqYzJef1pSD9zgtcI
         kuI9pqrM4N0bnmEV9/xaFU5hT2/AQqE698nPITQJPsCPBreXbxuovgNx2ZSwIHxD8EWz
         BlMzykm+XeYxYdN0KrA38j27QuXEKVR6QMKz/5fKczZ616gmxyOHdH8drCEHm0lQKh1D
         Q+pHtLXtqW1ra2xamkzUyHm5mbrCfYktkxm0WYSnDfQ+umicgBOk1v55xWCEMxFzm+pq
         GIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790590514; x=1791195314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KFBzfMUObrB6oJurf3VePte6bIEXkN56PtE7y8y904o=;
        b=nPtX7x7B9Aku0gYnTSoOW5WkcLGfOOJbSXQ+eLIuK/ooukJWiteMLdlScnWrgFhxHY
         YVn7oEhqgpl9hlznDsBcnuj8FyhDy5ueKP+uM2BKZSgrWqPbtIVlvgdZSd2UOxhUgbD3
         lDwGBPB1ieJad/0AhrCgucd3cJUsHE3No+aW5JuPD7u6Wv93MXDCcYUEAWlPQc1/JX3y
         SKKQ4m/xdRSmo16uJMKrLwAVWRIUyF1obsWIPX7UwZCxMr7l40A8/ykHCzG7eJG6Dhwa
         6oKpf0DXaRuEkwTLZ2TJVDG86jgnYpwBjwJeieVwsU9TQrHsgH38Payw8MHYllUOywgZ
         ipuA==
X-Gm-Message-State: AFq9FYJOq+HxNRVYEweeW8mubwOJtWoXpoNK/fpk6eqzvVFzV7KmrMyp
	pIbxpY2zh3yI3pbH/lu+oo5ZH8NFSQbFBa20SjoJpcqF33AiZzq8HtgXDTkGNma38QYmdv0ADu7
	kULTwRyF39UDMSzBFWDlH68Lw8/7FcYBVgDRTPCMF3wwrv/rTnoaW/7cWJxkG15JOjz92IZG+bT
	kxbA==
X-Gm-Gg: AYBFou3lVr4E6ik9FNd0UwQBEIo0MWCTSGqLHER6Of89TRoyctIZHpa3kBxibk7QHIF
	Pz8q6LckP5jHJhQFIwb/KIO0KSeGKGba66sqUoXk5/WOYWYNrs9Qmya2hFLFoQLwYBkaPcNHDiX
	CUPVeQ68AUMcqI2rGsoefg9iqz+2/yL2qbZ+mYSuM6VItUuuv0QWolH75Sqp4b8nalMj+Y5q/8N
	Ylkm/jomygEjQ8FiPCPEh9KSxh8JzBRuajfIBmRxpAgG2afT/HKc7npkRjV8Vav3v15mZOb5c1l
	2nQ1x9/gyXQTRhbU6mvAyIVRt4nt/zO+IsQO39je/foXZN8eEN2/glrmk2sXj7VbVzCpQM4cG11
	tIFgWVGVKCjb222P/3fkZ/Ij6cQr1pEwVRxzLkXSvzfPixP7Q1NMOj5LhkPllMq9vHKqQT4MMbQ
	n8y0WOxOhruF0WT4DpOjDXuO2nUqt2a7ce
X-Received: by 2002:a17:90b:5110:b0:39e:6a7f:6187 with SMTP id 98e67ed59e1d1-3a098ac9ea1mr7280779a91.24.1790590514272;
        Mon, 28 Sep 2026 03:15:14 -0700 (PDT)
X-Received: by 2002:a17:90b:5110:b0:39e:6a7f:6187 with SMTP id 98e67ed59e1d1-3a098ac9ea1mr7280753a91.24.1790590513769;
        Mon, 28 Sep 2026 03:15:13 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99917besm19741641a91.14.2026.09.28.03.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 03:15:13 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH wireless-next v3] wifi: mac80211: Do not report BSS parameters in AP station info
Date: Mon, 28 Sep 2026 15:45:06 +0530
Message-Id: <20260928101506.726663-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfXzVKDMCc669Tr
 hutjVmGic8DqE6tkFWerEV0NwlDlk0omdrCtoupgmuU8aDiecnHmjbrQvKv1dyjJ5IadUuAUS7c
 hj2qSJtROshXDqyzb3ZNquj0jbbf8HTU2dfqzrjLF0JiZsFPWDj/nBYXAM0UoYcZbKXpnT98VfM
 GM494ZIVto5CjOW0nDB5khrjgHKbvNmMTCk9S21nhYBPcVi8hHEohDG60NMEcFwDRcUvpTq0ltX
 PBV1FHTb8fp+ko1Ty7WCa0v3Pmder5ru+rU4nb4imxdsPZlbI99NVVyyQ9Ml1edGSuZSXep5Xdm
 LDBpokfL2+j+H8DOaLH8KBCx61wk7QLPecoVf1s/1Kvxge9ZFDlJdUYR8H921avY3AMgTw8K3VD
 gDtz3xdU/4SCrrZHWWBzxGgxjT1aZysVLKOLzKQTVvS2ujo+GugfWrtJxrGFtKkJEExiciUc48L
 gXrbtyWrhnPsqmzOi8A==
X-Authority-Analysis: v=2.4 cv=V8foQuni c=1 sm=1 tr=0 ts=6aba3e35 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=4KmYPXT4PAyNf4F9tV8A:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: vN8q5VubGFJ81ot0iayl0szow1sl5sFL
X-Proofpoint-GUID: vN8q5VubGFJ81ot0iayl0szow1sl5sFL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfX86kElpHK3jh0
 U54Ud6GKliw0WNsudW/suqjhqInL9XW0SOxNPckwlRHsED0Jr00gKplYEVsBXTthWtz6P/eL460
 REep++LRdPurRzu+0aJeoeaxEQPzOAg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280040

Do not report NL80211_STA_INFO_BSS_PARAM for station information
generated on AP interfaces, as beacon interval, DTIM period, CTS
protection, short preamble and short slot time are AP BSS configuration
parameters already managed by userspace.

Retain BSS parameter reporting for STA interfaces, where these
parameters describe the BSS to which the station is associated.

Use the per-link BSS configuration when populating BSS parameters for
STA link station information.

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
v3:
  -Change the subject and commit message from
   "wifi: mac80211: Report parent AP BSS parameters for AP_VLAN"
  -Stop reporting BSS parameters in station information for AP interfaces.
  -Remove the BSS configuration lookup
v2:
  -Remove unnecessary sdata->bss NULL check.
---
 net/mac80211/sta_info.c | 49 ++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fdf00cbf49d8..cc6dbfc9cad1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2864,7 +2864,6 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 				link_sinfo);
 
 	link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
-			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -3037,15 +3036,20 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 					 link_id);
 	}
 
-	link_sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	link_sinfo->bss_param.dtim_period = link->conf->dtim_period;
-	link_sinfo->bss_param.beacon_interval = link->conf->beacon_int;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		link_sinfo->bss_param.flags = 0;
+		if (link->conf->use_cts_prot)
+			link_sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+		if (link->conf->use_short_preamble)
+			link_sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+		if (link->conf->use_short_slot)
+			link_sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+		link_sinfo->bss_param.dtim_period = link->conf->dtim_period;
+		link_sinfo->bss_param.beacon_interval = link->conf->beacon_int;
+		link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
+	}
 
 	thr = sta_get_expected_throughput(sta);
 	if (!thr && (link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
@@ -3099,7 +3103,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
-			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_ASSOC_AT_BOOTTIME) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
@@ -3267,15 +3270,21 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sta_set_mesh_sinfo(sta, sinfo);
 #endif
 
-	sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
-	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		sinfo->bss_param.flags = 0;
+		if (sdata->vif.bss_conf.use_cts_prot)
+			sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+		if (sdata->vif.bss_conf.use_short_preamble)
+			sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+		if (sdata->vif.bss_conf.use_short_slot)
+			sinfo->bss_param.flags |=
+				BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+		sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
+		sinfo->bss_param.beacon_interval =
+			sdata->vif.bss_conf.beacon_int;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
+	}
 
 	sinfo->sta_flags.set = 0;
 	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |

base-commit: 42a9fb3382fc2573e92f41d203b095d9a372cfc9
-- 
2.34.1

