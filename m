Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2C922A4EE
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043715; cv=none; b=HH1Zq8c5LvrKwqEtDnW0rSG99P/Weuw6HYbBR2fFJQYh9GKmxVCrNcZxCMqdLLtW7kUiVEgdAzUn47VrPKl34jFwe0qFceMn5j2qG1CfvkgBysGc4lbC6yfePb5xteroQYs+vIRW+3+tW70/F1D5vT/y7+r0DdD/tpDTIxOawyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043715; c=relaxed/simple;
	bh=YwXCH8gIMFFzI9dTwZAUoCjYfZfXljPB3N3AHm6PjEw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pNOrWJ4P9HfpaonotcgX8Y2aSZji/5Ux0J4x/ykxKm8PeEov9LNEVgqnF7JIOTqL7j0sHO3nfC2ziZMW/8w3P0ud77w8Mw8OnPWm1il+qB+BdBeA9bOz7NBqi3PNU6J7UaUI3kpqYbNdC/UI7SNLUmugN+zotbtFBHR3mDjzNBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C5Gmhn7a; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MZb6lLqJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C5Gmhn7a";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MZb6lLqJ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F2AmVL843758
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=NrZ7pS6mbpk
	4r0IGtTFGbpHRa6q6oKGx2PFvB8mp39Q=; b=C5Gmhn7apcIWjmDrVfTFQLLrq/0
	TztHmmRIPyBtpyy6veAa0Z1GRo+6EN8RtzPqffnxcpjPbc5OabTZHF3Xr9+E/NxF
	p/Y5zYD2ECexg+gfZrImFi8y5fT2Q0rt4V2FPKuq5JPkOEFKCxoHqom0wPl5fXq1
	eypHjCFlB0lgIaAGyLq5M82mYv723H9ry2g3b/6pbZJMDdypP4dzwLzQ8fZShkga
	wSp6D0jDEPojzfj7WZT3n4rdMnFAxLhB0DRTRpt5fGYO27tuWFSTIXsn5BNe2xD1
	uyBlzzlQmFZqTrseFaaTkQQTotxkb1ovPb/FLAdJDR1M8bz8JD5Oh+h6KEA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hae4wtcd8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:12 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a8ae5154e7so6429802a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043712; x=1792648512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NrZ7pS6mbpk4r0IGtTFGbpHRa6q6oKGx2PFvB8mp39Q=;
        b=MZb6lLqJoUdJFdDpR0yy8UBS0/wutYIJM6LMXye3dJujuoYSPTQb58DkkA9vqhi+t9
         xTW8SBacGcq1a7Qp1R2ysj/c4/FYL8cIBvuYhMfdUg/aSH1vzrAMmlwiDPQPFypEGReT
         W+ZwZyKO7PjJYRvklxF5e9e/nZoR/TaiNmCuK+JkXqRgD9+EJjiseFdjzGI729KfL/Ae
         876V6YE2/Zz+0VLmNL9k6vN1as9VGhH2jAh2rra1D9xf2400v0QUJOqa2LHv3oBrC1v7
         ROMCT9MXJmXTdKP3msOzGjB1l1Dprw9fcnhN3qRs6PEzDKS8mtVB3iEtwO+kXY/63KCv
         6B5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043712; x=1792648512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NrZ7pS6mbpk4r0IGtTFGbpHRa6q6oKGx2PFvB8mp39Q=;
        b=qKASkONNKNvW+cw7iI+SLlH0sE8uBkPMDZE6v4j0zwVecX8lnkcovs6ZeMOtye6ek+
         9221fMubtHywVAQOM7M1cWzAVbSS6ef4ywj77QTy+4pgycGX86CjfSTMYZaldmqQ9bt8
         QKe+UTu4gPpbzwPPln1AKxlCFXu1YkpGbMp1M8Ih9gPT7pWZGXLiD2wIq2aeYocegAj2
         d+5xJUevEwtNT/6CRKH1vnqg10yjuBC1lg4d6cAGjhJHY6vQsfVa4HVOnpKWZrnk5azo
         6Bx1TC9jllsHIuDZ6jzmRdt8buVPDdx8mgjxqrcar6CpR+u8SxC1tgiM+ofkJ3WBpm0x
         kc/Q==
X-Gm-Message-State: AFq9FYLuF4NfBkFObxEiSrjZytyRXoMalFeQvIdnVexlTT9tVn0oXIEU
	zqHao1OpkY3vFjtfK1bIUj9S3gKbKmlSdWBA3T2h80pQHcg97pdXcLqbPDjspLR4d8fyeHW4w4f
	cFycwvSw2E3eaPhWWnG69LfWM2L9x4d6zhe7fYeRPws4vOcglrrRBq6ahgCArFontGIPCmA==
X-Gm-Gg: AYBFou3ut3ZB2G5lDwsKvDA4pi0Sg4fvd1bq5jYa+8t2Qqwebj7q8nrVBBc4pmPSM7n
	G7ow9H+/IauuqzduVvKU5hMWBDLX7MWi15h8MihyWjdk9zfksHMuZn17BLtfsLqOn/yV2cpzd2j
	5XqMkOU/LnTXjqIV8cZmZpC24owaLXTFpSdEKSuhnzPIjdWObmXbw/5E++oDqxifDLK9vsFpvf0
	G2qt204IvgpKCx0m+D09p4yGCpH0VEiixFvKFgAdoTNeyL/mjbglQAM32fjUNLdYFTBO315Ahum
	8eCTuEQ4/8sr3SfGHgz7UPPoxQnWm4UEuIAquwKqjpN8jufYajwVGrDAYQHH9yqnN56l0M/RS5S
	uSsRzVnsqdn2MrivbG5FuEmmaAqW+KsFOnyawjo7h3mLiKFaF4+p6pTioGkPJdj25kASl85bWpI
	oKHD/hZq/5OY1C
X-Received: by 2002:a17:90b:5343:b0:3ab:188b:c5bc with SMTP id 98e67ed59e1d1-3ab3a94f0dcmr14760156a91.14.1792043711388;
        Wed, 14 Oct 2026 22:55:11 -0700 (PDT)
X-Received: by 2002:a17:90b:5343:b0:3ab:188b:c5bc with SMTP id 98e67ed59e1d1-3ab3a94f0dcmr14760142a91.14.1792043710825;
        Wed, 14 Oct 2026 22:55:10 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:55:10 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 6/7] wifi: mac80211: map SCS packets to configured TIDs
Date: Thu, 15 Oct 2026 11:24:40 +0530
Message-Id: <20261015055441.680588-7-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
References: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX6Nn1xEiWs2cv
 SMFNfnH58VpxS/2By2v65DodluQQeUQdKLRRBj/SsW7q6ooc7nlF+NmU5CSAZZ94IGhFhU0/3vX
 71TAFeDFmIUq1P/FDW3uxmMibXtnnKM=
X-Proofpoint-ORIG-GUID: aGbkrtbqy3PIfvPS2MLreCF4Ankcu6id
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX1GQgDgEvgghC
 OD7G3AYXwXpA/3rwzJvmXAipWd2ffpEN65Gdu2GaRiQ/ErKYc0/N3aVCrC3RZgs9KgFoTySsFSh
 gfF13yK9QBni3k5nXU0z04T3cAQMqY8JI0PGOGTP+AmOpObJgh0mDJISYXGmUGBHRVquaVbzf9o
 TD0dYYWT3RWcEMSxJ4DR7f3EOSQA60ioFAPC4g1sN4jIV1j8f54uRxwfw7KyuhgZ2sVCTK+Dg6C
 pbK48Gw5QITGWndn41GT/6ocS6/3AmMAkP4zRSDaiYF9FJtgZdSfUZ+deKI9Qv2Yo+V7aQPBc32
 R8Xf6Fi7D8gXpakMxJINBUVHkn6TY1mWgiNUr0yMWJ6SOBHS47vxUbJHdW7rAf2L4xIgFIk4dgE
 Tw55cWLKA4kQrjC3F8EgCi6wtsbntR4j/COLaPS6mk7CyvRKeBpZmT6oTvHOXSh1u8Kp5BsNnuO
 GRhBNKzJe3Gksic2krg==
X-Authority-Analysis: v=2.4 cv=E8BYNqdl c=1 sm=1 tr=0 ts=6ad06ac0 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=DUI1IGLppgL3m5rRpvMA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: aGbkrtbqy3PIfvPS2MLreCF4Ankcu6id
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150023

Use the negotiated SCS descriptor-to-TID mapping when selecting the
transmit queue for packets carrying QoS Management metadata.

The low 16 bits of skb->mark are used as private QoS Management
metadata. Bits 0-7 carry the IEEE Std 802.11-2024 element ID for the
respective QoS Management descriptor: WLAN_EID_SCS_DESCRIPTOR (185,
0xB9) for SCS and WLAN_EID_EXT_MSCS_DESCRIPTOR (88, 0x58) for MSCS.
Bits 8-15 carry the negotiated SCS identifier.

During transmit queue selection, look up the negotiated SCS state for
the station and apply the corresponding TID mapping.

SCS identifier zero is reserved and is rejected before accessing the
RCU-protected per-station QoS state.

hostapd programs nftables rules on the netdev egress hook to maintain QoS
Management metadata in the conntrack mark and to copy it into skb->mark
before packets reach mac80211 transmit queue selection, for example:

 nft add rule netdev qos wlan0_wifi_qos meta mark set ct mark

This nftables rule copies the conntrack mark (ct mark) into skb->mark on
egress, allowing the negotiated SCS state to be applied during transmit
queue selection.

The conntrack mark is restored into skb->mark at the final egress hook,
after earlier L3 policy-routing decisions have completed. mac80211 first
checks the QoS Management tag and then validates it against the
per-station state, so SCS metadata is used only when SCS is enabled and
the marked SCS ID is active. Packets without a matching tag or active
descriptor, including ordinary non-SCS traffic, are ignored by this
path.

Intra-BSS forwarding requires per-station peer isolation to ensure the
SCS mark is preserved at transmit queue selection.

This implementation depends on the corresponding hostapd and nftables
configuration that populates the conntrack mark with the QoS Management
metadata.

Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 include/linux/ieee80211.h  |  1 +
 net/mac80211/ieee80211_i.h | 14 ++++++++++++++
 net/mac80211/wme.c         | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 66f9ebe79c61..f235059cbebd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1821,6 +1821,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_SHORT_SSID_LIST = 58,
 	WLAN_EID_EXT_HE_6GHZ_CAPA = 59,
 	WLAN_EID_EXT_UL_MU_POWER_CAPA = 60,
+	WLAN_EID_EXT_MSCS_DESCRIPTOR = 88,
 	WLAN_EID_EXT_EHT_OPERATION = 106,
 	WLAN_EID_EXT_EHT_MULTI_LINK = 107,
 	WLAN_EID_EXT_EHT_CAPABILITY = 108,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 63391a1fd9c6..aa36289b3ae4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -80,6 +80,20 @@ struct ieee80211_mesh_fast_tx;
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
 
+/*
+ * TODO: Synchronize this skb->mark encoding with the userspace application
+ * (hostapd). These values reuse IEEE element IDs, but their use in skb->mark
+ * is an implementation contract between hostapd/nftables and mac80211.
+ */
+/* skb->mark bits [7:0] carry a QoS Management protocol tag. The values
+ * match the IEEE Std 802.11-2024 element IDs for the respective descriptors:
+ * WLAN_EID_SCS_DESCRIPTOR (185) and WLAN_EID_EXT_MSCS_DESCRIPTOR (88).
+ */
+#define IEEE80211_QOS_MGMT_TAG_MASK	GENMASK(7, 0)
+#define IEEE80211_QOS_MGMT_SCS_TAG	WLAN_EID_SCS_DESCRIPTOR
+#define IEEE80211_QOS_MGMT_MSCS_TAG	WLAN_EID_EXT_MSCS_DESCRIPTOR
+#define IEEE80211_QOS_MGMT_ID_MASK	GENMASK(15, 8)
+
 extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 1601be576414..4d1bad27a8d6 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -113,6 +113,41 @@ static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
 	return ieee802_1d_to_ac[skb->priority];
 }
 
+static void
+ieee80211_qos_mgmt_set_priority(struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_sta_qos_rcu *qos;
+	u8 qos_tag;
+	u8 qos_id;
+	u8 tid;
+
+	if (!sta)
+		return;
+
+	qos_tag = u32_get_bits(skb->mark, IEEE80211_QOS_MGMT_TAG_MASK);
+	qos_id = u32_get_bits(skb->mark, IEEE80211_QOS_MGMT_ID_MASK);
+	if (qos_tag != IEEE80211_QOS_MGMT_SCS_TAG)
+		return;
+
+	if (!qos_id)
+		return;
+
+	guard(rcu)();
+	qos = rcu_dereference(sta->qos);
+
+	if (!qos)
+		return;
+
+	if (!qos->data.scs_enabled ||
+	    !test_bit(qos_id, qos->data.active_scs_id))
+		return;
+
+	tid = qos->data.scs_id_tid_mapping[qos_id];
+
+	if (tid < IEEE80211_QOS_MGMT_MAX_TID)
+		skb->priority = tid;
+}
+
 /* Indicate which queue to use for this fully formed 802.11 frame */
 u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
@@ -179,6 +214,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	qos_map = rcu_dereference(sdata->qos_map);
 	skb->priority = cfg80211_classify8021d(skb, qos_map ?
 					       &qos_map->qos_map : NULL);
+	ieee80211_qos_mgmt_set_priority(sta, skb);
 
  downgrade:
 	return ieee80211_downgrade_queue(sdata, sta, skb);
-- 
2.34.1

