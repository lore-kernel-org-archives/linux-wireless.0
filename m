Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952004;
	b=dyJ5WHpkTTY78JI+m6bwiC7HV+I9Fwv1DtIDgkxRV3NwlUKrFik8adRT7t4AY5/Of6VR
	 KpJDXY8A0XxeYHk91nkexGRk9+vpFjQ7baDefKLA/S51N/ZNd6n24+qKHfr5U5BXmvugH
	 aRlr9OHYHZ4L+16wNSQdLUunuXv/AQr3JbMdSvUQYGsiLp6iSEd34AOnSB7EAfhfimLp2
	 u+koYaOrBhfzAkrsG2o/0bOhPejWQAz3zdJXYqIXj46vsXYaIG6lY8VNLhI/Uv++/thYe
	 5P/F158ieajaWl7GjDj0FX1EkJao0IXCi0V2ORSslctSi1AXvCD0h50RU8FIBMVMydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952004;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=gOYWK9XugZsXS7XRYjyj5nEvCnGNo96ScNjgbqrNypM=;
	b=loH4DEUTqHAE8UWQsHymgUQnLf0G19jAfzlzV2bKUezOwPLO7KLYN4mYw9aGQJgrCff7
	 l5+iJFg+kdXUhmsVrfAeIr185R8uudk0Y/iskB+gyQsp8FzUXHAtQ/JT6gEvD6O6Aj/Ma
	 oRCLlslrxUNwCi628ULEL6xy6vk8hGDyeLxy9zYBEkYKvKY98rNxd6ZomviNBiqIyTnZd
	 C4eVhrnxyUiFIDBsXkE9TLvZdlxAhJULf5RtkH3FFTDFx9vhAuNfqe9kVGNLcSufq8UlR
	 cg3fkGvD2XLclSCuOSsYh9FC8c2nC3HBi3l/a7ujc66ocxmq1vuEvw2Bo71LB9M6g6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IORU37R7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fDidxiX1;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476C56083634
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 476C56083634
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IORU37R7;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fDidxiX1
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RTeu3284474
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 08:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gOYWK9XugZsXS7XRYjyj5nEvCnGNo96ScNjgbqrNypM=; b=IORU37R7Fx8682Hr
	emVRz+2nocT1Qbscopq1pVxqb+ZdRoqVy4eWqduZYzxAkOEqU53CMKTbN8swUCdr
	AAN6AC71tbJQ0uPJJgggYWAfFV/tZkqfrfGpiyXUAJ2msyMgmlnXuo3YVzkEIDwO
	i9SD43B4CVKxcJ8qK36bdkMikU7Ra3RTrONsoYrqFXDCq3IvmEucVpQ92O9pZPUm
	SAJutO/QcXANBQ4/Od0+fd3mVQFRa/GAmHpnSbRmCacAar/XC8jWV5ep3qVjCIBv
	kFOEPckaHnYthw02yF9zaZmJNZC0HXxHrkAImbiFsjNKs+J2bnybQx0y1K3uxFcr
	biYZig==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pa1qyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 08:00:02 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0a7cbf164so513713a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 00:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793952001; x=1794556801; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gOYWK9XugZsXS7XRYjyj5nEvCnGNo96ScNjgbqrNypM=;
        b=fDidxiX1IbqvQDtXQEYlOoeQpz3zyHukUHycnmHNRPGw37txO3PccSAL4Jw3/EWsRg
         Ocn7K+2Mos/IERUgjMCyKFwVcbj/7qUds1EywWLMA6w9SHOXby5xTLwjLbypEhz8tZWv
         F2RYosU456ziOBDahlD+wiHyhjlHWhGRveeTioxmw4UipD2eebpuIxHgLKlin7blThWB
         FTXMYN+Bze0CQITfJulgcqSEAlnXilLDD4rhYy+KtDK/54POhb+qpPh53FOTvRDmN5/K
         GU19DuYNGEFJnraUco8XqtC1CbjUygXfUGeGhKBH3SNQCGqoPTFQkBw7a5/5xgDuIMbz
         4oBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793952001; x=1794556801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gOYWK9XugZsXS7XRYjyj5nEvCnGNo96ScNjgbqrNypM=;
        b=EFwvawCsPr30vePsm8OGcvdhn6E9i5oRrU6jG2ssc/IxZNf+a+0ShreRxPnJjxl93I
         A8fJfv6FzQZq9w1zVEPIDW7qwUAY6Sl64IsaXisWjOlAefnJclCa9n4NnH5/1GblgEK5
         g5NmlIZXeZe/ybY/RTo1LUX/4kIO3RXgexzIuI9LPLCeehRrp1I4Ly/PPDyq3u3bYkIS
         lfcQsHM/3qcfLDRqeYKr4c4v5ZvAls3iNxXQ9tK7VXKKABEl96kQo+09WxX/1KZCF8E0
         5r0JoQsY0aRWjsKfLlbf9WRB7Wp49NnQ65IWEQSMdXRisJUON+yqLOUcaQIhG5ypHrcP
         +/EA==
X-Gm-Message-State: APuU4Z/lPHIW66xVKQttklKfTNMbceBbpIiGzKeFZwi9RLQL5bO/Nvta
	wbQ+RWutVMpTtpgUM7/oB9fBG4o0mZP1Dgw6vni1fIVQ9ayDiNg5kmRTTkSsYYHCsXJbrd7WxEd
	vinzP4Bpslnv4Ew/v/5rmCnpaOS5Fg50JyjzGgVrtH3vHbUHCBACVHf5+0U0GNq3rdFpz1g3PRF
	Gd
X-Gm-Gg: AYBFou33kNCkxY9D6BIxw8nK/D1bul+OCggp57BB7ih36tpQrXMvZzCiaq1IlqwcvEc
	3aul8/rsghdypoeG3ZS+UAKvr+fhx/csvAUkxIIml48bgDNuVKTMPczl0KGe7gV3+/4DRpbeh91
	NPiGjQa+Hsba1xZtqx1iX45f9HH7ovMAuPMniaP47TwUtl/1JuoxRnulSyXziPftQ+NBEyjd23E
	7sEe+16LnYqKWkYH0BRMI/7kjInssY7inQ76dazynWQwSthD/2mM7J13ZOY+LsdPUlyDgziIKmh
	Jw1re1PhzzzdRawyxYWcrKP/1M5AZWPdTFRQnLANIHFs/zv/tva51sAAFMnlvqDqapdVdSawRhk
	dkOm2wUlIzuMlmvE7flWC1HoTFKDNffvP1xZuV76466Ravh0l5+W+RQWG1k/v8Oll6WjmLK088T
	Bh4zT7YR7xW5aZ9IRA23h+KzmrqNJFN+46oS3GGBfaHNTCo+dn+QLXrGmwdp/bFeSz/grCM6U=
X-Received: by 2002:a17:90b:554e:b0:3ac:9f24:44be with SMTP id 98e67ed59e1d1-3b0db6c9b22mr1876583a91.29.1793952001033;
        Fri, 06 Nov 2026 00:00:01 -0800 (PST)
X-Received: by 2002:a17:90b:554e:b0:3ac:9f24:44be with SMTP id 98e67ed59e1d1-3b0db6c9b22mr1876568a91.29.1793952000520;
        Fri, 06 Nov 2026 00:00:00 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:00:00 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:52 +0530
Subject: [PATCH wireless-next v4 15/21] wifi: mac80211: filter uplink and
 downlink frames based on SMD states
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
Message-Id: <20261106-smd-v4-15-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: xAG16ubGl-V80ja4RhcI-LBfYRG259d_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX3Xo/ZIapnTcA
 aoTgkRppJuI79grC3IQF+RQtlIbnzWiLGivJXXTmcqVtA7J2jy5f+xwL5p1mhmPkEGBWtO6wiJ9
 noBC5sdWJ2s8g3zCyStA0nIPMqoR/2A=
X-Authority-Analysis: v=2.4 cv=e7WT2qp/ c=1 sm=1 tr=0 ts=6aed8902 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=AigL14bPCbaQZCUQxqEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXwWhtVlQh5vRm
 kvmA73RwrQ0UwhUKoJFRfpwM2cwvjn3rcoGPu7ZeNQYq4odOYdGIqGpCTuKclTC2JFHKD4R8Gnp
 4/jImuLbYvjXkS7z6jotlKxuicSZI6iyLN+FKDnIfdJKLoezEB/S6Y7iAW/MCT256l2/V7aD7z3
 m0SKJqFJ6JiwaenAfvagIj47th+etS7PPRS8SUOIqrigW6Qfvi4AgC+2h5SF0N0KHBYBrU0IdxK
 G5c63KtIOf43zGRw9CyIYNqR7beFDyxSlVNw19kOpZ8mQ+9a5ni7iEirgN53I6Q9QBZqSWo7g8v
 UyEaiPtLx7vZg6jUYvq+vW4CAXwlwU9qDLwIL/juiInoAhojhW3HXNH0p2PhxcT6Z/hmOFJ5Iwt
 uP8s97l5W3NtKqMpmlnToikL8UEnManZloQlbmT5gSk81RQaaxShRrQ59TRQCN2wqaKu4FFLljX
 1q4CsxBGDZTC4YTZTug==
X-Proofpoint-ORIG-GUID: xAG16ubGl-V80ja4RhcI-LBfYRG259d_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

During SMD BSS Transition, based on the state that the non-AP MLD is
currently in, there are frame filtering conditions imposed in both
uplink and downlink directions, as per IEEE P802.11bn/D2.0, Aug 2026,
subclause 11.3.1.

State 4a:
 - UL/DL: All Class 3 frames except ST Execution Request and Response
   frames are disallowed.

State 4b:
 - UL: Class 3 data frames are disallowed.
 - DL: All Class 3 data, control, management frames are disallowed.

State 4c:
 - UL: All Class 3 frames except QoS Null, Control, and UHR
   Reconfiguration Notify frames are disallowed.
 - DL: All Class 3 frames except Data, Control, and UHR
   Reconfiguration Notify frames are disallowed.

Add the filters in both tx and rx handlers to implement the conditions
to avoid exchanging those frames while the station is transitioning
'seamlessly' (state-4) to the target AP MLD. The unexpected frames will
cause out-of-state operations and leaks in the context transferred.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 net/mac80211/drop.h |  1 +
 net/mac80211/rx.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/net/mac80211/drop.h b/net/mac80211/drop.h
index f433ee17cce5..fe037c94b2ca 100644
--- a/net/mac80211/drop.h
+++ b/net/mac80211/drop.h
@@ -109,6 +109,7 @@ typedef unsigned int __bitwise ieee80211_rx_result;
 	R(RX_DROP_U_UNHANDLED_MGMT_STYPE)	\
 	R(RX_DROP_U_NO_LINK)			\
 	R(RX_DROP_U_DEFRAG_OVERFLOW)		\
+	R(RX_DROP_U_SMD_FILTERED)		\
 /* this line for the trailing \ - add before this */
 
 /* having two enums allows for checking ieee80211_rx_result use with sparse */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..12ba9fbcc983 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1628,6 +1628,49 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_smd_state(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!rx->sta ||
+	    (rx->sdata->vif.type != NL80211_IFTYPE_AP &&
+	     rx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
+	    !test_sta_flag(rx->sta, WLAN_STA_ASSOC) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return RX_CONTINUE;
+
+	switch (rx->sta->smd_state) {
+	case IEEE80211_STA_SMD_NONE:
+		break;
+	case IEEE80211_STA_SMD_PREP:
+		/* 4a: Class 3 disallowed except ST Execution Request */
+		if (ieee80211_is_st_exec_req(rx->skb))
+			break;
+		if (ieee80211_is_class3(rx->skb))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+		/* 4b: Class 3 Data frames disallowed */
+		if (ieee80211_is_data(fc))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	case IEEE80211_STA_SMD_DRAIN:
+		/*
+		 * 4c: Class 3 frames disallowed except QoS Null, Control, and
+		 * UHR Reconfiguration Notify frames.
+		 */
+		if (ieee80211_is_qos_nullfunc(fc) || ieee80211_is_ctl(fc) ||
+		    ieee80211_is_uhr_link_reconf_notify(rx->skb))
+			break;
+		if (ieee80211_is_class3(rx->skb))
+			return RX_DROP_U_SMD_FILTERED;
+		break;
+	}
+
+	return RX_CONTINUE;
+}
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
@@ -4279,6 +4322,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 
 	CALL_RXH(ieee80211_rx_h_check_dup);
 	CALL_RXH(ieee80211_rx_h_check);
+	CALL_RXH(ieee80211_rx_h_smd_state);
 
 	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..216d407237ec 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -308,6 +308,47 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_smd_state(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	__le16 fc = hdr->frame_control;
+
+	if (!tx->sta ||
+	    (tx->sdata->vif.type != NL80211_IFTYPE_AP &&
+	     tx->sdata->vif.type != NL80211_IFTYPE_AP_VLAN) ||
+	    !test_sta_flag(tx->sta, WLAN_STA_ASSOC) ||
+	    !(tx->flags & IEEE80211_TX_UNICAST))
+		return TX_CONTINUE;
+
+	switch (tx->sta->smd_state) {
+	case IEEE80211_STA_SMD_NONE:
+		break;
+	case IEEE80211_STA_SMD_PREP:
+		/* 4a: Class 3 disallowed except ST Execution Response */
+		if (ieee80211_is_st_exec_resp(tx->skb))
+			break;
+		if (ieee80211_is_class3(tx->skb))
+			return TX_DROP;
+		break;
+	case IEEE80211_STA_SMD_EXEC:
+		/* 4b: no restriction */
+		break;
+	case IEEE80211_STA_SMD_DRAIN:
+		/* 4c: Class 3 disallowed except Data, Control,
+		 * UHR Reconfiguration Notify
+		 */
+		if (ieee80211_is_ctl(fc) || ieee80211_is_data(fc) ||
+		    ieee80211_is_uhr_link_reconf_notify(tx->skb))
+			break;
+		if (ieee80211_is_class3(tx->skb))
+			return TX_DROP;
+		break;
+	}
+
+	return TX_CONTINUE;
+}
+
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
  * happen often during normal operation, so dropping the oldest buffered packet
@@ -1881,6 +1922,7 @@ static int invoke_tx_handlers_early(struct ieee80211_tx_data *tx)
 
 	CALL_TXH(ieee80211_tx_h_dynamic_ps);
 	CALL_TXH(ieee80211_tx_h_check_assoc);
+	CALL_TXH(ieee80211_tx_h_smd_state);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);

-- 
2.34.1

