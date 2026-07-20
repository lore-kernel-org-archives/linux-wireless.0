Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FEA3AFCFC
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529834; cv=none; b=hjvZlXdxDTTtYOR5n78zrU8Xiu0/VzqyGaCx/8HAKN8k0JnDm68R2HbDGuoEki9RtcVUVbVh2UW+bgGq87ebXG/4SjVSa2ouOPbdnCwZI+t6tM9K7v9MI162xjYMdwahULP5fyqvf5NIn8FfDhMM8ThHsQ7eR+zlUkEnAGIR2cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529834; c=relaxed/simple;
	bh=CyClcNg/Da64ltRsRG3CihW2CLmZsgzDziuYM0o+6IE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ucy2W2vMcJmjEcqR0Fce5QUsUzjZP2l7MjJN3iVZ8fJ6Sedo0opjGy8u36keove6Vdye7z80QjuQQY2ZyGqQFIPsqFBeEWxFUYLhTCuRB46rsHGIeibn4TgsIM9JbW8cAiHhbVubUAt3HTv+IYfLLfhSlBafixVGI4fRg7j9qtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XbfQoygV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W8v4kYnY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XbfQoygV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W8v4kYnY"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6Rc971800221
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oypFu45XfvZoTRTZc7SyYEzw7BoqUBfDWb3iYCCskVY=; b=XbfQoygV92O2lRDO
	zmtsTxokfPMCpiluhidHMHyDp1K6JAUYzOuVQ7P+G1ZltN99EfkvuzjnAUh3m2do
	W4RYIns4L32dmf7446+gh0KIOY3AuQE7utHTMn1bpI0D0Of4spnJv1ZYZ1ApCJoP
	hvR0ZDIdDTTj4+p6CAL/6jwt+qgLjGXK2j33R7KjAqwkZp4ThRuPe3fpqazKMH4Q
	Pb2uWwGMgP37u9TJVfRNbIWYX3tzCfHQQ9+8asT9Px3ScakJBX+hRtRls1WwyjKv
	ggnreLnhc8O5B6ckdyxaBx3KBZSjsGIulejDMhbt02U1HKqpNFiyDNxuUNgBfEej
	jhl8iA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2c6ct38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:49 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84a4d8fd6deso7860075b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529829; x=1785134629; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oypFu45XfvZoTRTZc7SyYEzw7BoqUBfDWb3iYCCskVY=;
        b=W8v4kYnYAOudMcBidzXCTVmtkC+4UctHNXmvXFq+DsQA8s0CMuXqEmuaMyepGHOrFI
         tG2LrtjO1LRyvFqF5VrxDUlXbgvkrD4tMI9u4jbS61ZpSS3fulmq4zcs8Kjlv2renu2x
         qo5j0q03XxdGqZtLd1l2dolRmjxX724kFSZ5AHIAAJApBYDB6tXYKIhVnskwszRzZo2B
         Ze/dFzctiQoENSO9WZBLIi6mDXaldkZIUgGe/KogIRJsuI1zisGREjdcK6Mu5zVE6fXD
         vNi5ya3TeqGIDRSKqJ5nozX8StbVd3Q7Vf6N7oWbWhyqPA/jphdMfj+CENctjctiuQFC
         nHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529829; x=1785134629;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oypFu45XfvZoTRTZc7SyYEzw7BoqUBfDWb3iYCCskVY=;
        b=qKb1j1nptfU7F2jTzifjq59OeW132++IBtJIzIeO2MO5ijnwJo1YP1AE+u3rQ3j5zK
         +SenFZsLjxkMdyRYX5IXta63l92iqwjrJX1KLEtTP/SDFK1ALUsE/veEDb4mlSa+ljiJ
         jY3tIGLVcCFN7eO6AOYB8JD9/56NiBvQv6V0ZDwfr0pfdIKavk2g8uHpsZFbosx0g3w9
         2i7kcDYaMTZOBXVOUoiw03DY/LvQv1WKKpScM5krNNF0EWqDayIx2j7bDsPjb5IbJSHT
         +o9XRC1lKMysn4HSiL6pHH/lmNbM0y2OXA3My8mmnoVZ0OrVn4GkqM5u57YmKaR3lhWq
         a6Pg==
X-Gm-Message-State: AOJu0Yy8tPJuXIUH7oEi9w+tt8EwOMnBSiKNmJopbgqjG+JPrfhHE5Bm
	Lpt92VtVrkgC3eGwb5ng7DRff5jfH+bXT+HHNU+RPFWoBhq9D9+JrkQIIXqcy92twhE/Bkw1/dm
	OiESG/OYUXv8ton8xccAMVp9HOu/zmckYywJYYjAbKKG+qHkjDzxh2ml0w/IwYaofvB62xA==
X-Gm-Gg: AfdE7cki/3CKVtuitNZcZ9bI4rX5iAxwjKy7Ksr8OgTo6+u5qycjjhn48iTwnHcZicX
	nTxGoUotNMhO6E28fpMruBIapj42w0yrUqGxMHg/7FOP2B/aXEELPb++W56LZwOQqcHrId9jFxT
	in1r5ZdVNC7q02TH1dOTSg0MqeQFuAN9sjwkhTwE84EVcFInCeLPzqZHhDH0b7tjzXGRF3s1QWu
	nDSt4dRdnTBtjI7RUgV0PYu2OB1frcZk7E086f4fD/8UAQWmqgeHMaxsDnV334o2U+txj/xrlfF
	t5aZKS7NdAowSvm8plFRLdzcNQpyZp+zEBGqjihuVfH4Gr7t8qCt5NIlI0CENJ1WEucZ5xsdAXI
	+Lh1P/4+ut2oae7i2daRycUIB4a1hbeJ1VU24V9OOjVvA2QqFCqcq7g==
X-Received: by 2002:a05:6a00:3e26:b0:848:2f74:d8d9 with SMTP id d2e1a72fcca58-84c294c875fmr11304455b3a.74.1784529828585;
        Sun, 19 Jul 2026 23:43:48 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e26:b0:848:2f74:d8d9 with SMTP id d2e1a72fcca58-84c294c875fmr11304439b3a.74.1784529828085;
        Sun, 19 Jul 2026 23:43:48 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:46 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:28 +0800
Subject: [PATCH ath-current v2 7/8] wifi: ath12k: defer dp_peer
 registration when firmware allocates MLD peer ID
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-7-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: -Dsuvxkf2ERqVuKvHOwaHYZhQmc4OVU2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX9QM4BlkD9vlz
 Lyy/E5XERwtFHB1yvsEKPy/3TaqtfwXB8pzBZOYHzLTrhxfby4KN3U9gVYdzk3BfgU6YzMJ47AG
 X79bxBNBBnpDmB9uq5+jNUhaGTTOyWllsKLAaqNRbGqTpeiKSplmgDXoZrClJzTBck+ZhOr/5QE
 peAZgIPQDy3lm6eEWbz6Xecqx7oDQn+MV1sAMU+9kICsDXNGhaZ0jGehcum0UC6LzghPoJOuid5
 fcQ3H7IX2aK/FrwQXiFa/kS0zqkuKDdVjITSVAGF771rzmQq0RgvLQMl0kn9Y7JWkYPZ0HlOVLn
 /x6BEREAks22GJGAFfYn3II7PhL6cpnsfh56/DQg8TQLN7z2SFmC/lDw4L7eT4MVE2A6gWsaAIy
 lxIDw0qdoxi9EGn8K/lBi6toPnXoFvhxpFbEJnUjtQ3BJiiCbu3l8vUYFMVpOB+SStHtazjJKCA
 LCtbX4f8hCVzUWg/BmQ==
X-Proofpoint-ORIG-GUID: -Dsuvxkf2ERqVuKvHOwaHYZhQmc4OVU2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX3fmWXG7k/fE0
 5OTAv8bAokfRg3xmZfOC8XtJ899sciAL5pPheeLX9+SPp9+wL0DTxV7ShQRPd6tj6ToBu1RqbFI
 YVzuWRk4FY7tT0v/QAtaZoJsQzfNGqg=
X-Authority-Analysis: v=2.4 cv=CJQamxrD c=1 sm=1 tr=0 ts=6a5dc3a5 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=DmUR2gHJotVURrrF6hgA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200072

For chips with host_alloc_ml_id=true (QCN9274 etc.), the host allocates
the MLD peer ID up front; ath12k_dp_peer_create() publishes the dp_peer
into dp_hw->dp_peers[] using that ID immediately. WCN7850/QCC2072 does
not work that way: the firmware picks the ID and only tells the host
afterwards via HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP, so the publication has
to be delayed until the event arrives.

Introduce ATH12K_MLO_PEER_ID_PENDING (0xFFFE) as a sentinel for "is_mlo,
but ID not yet known". On the firmware-allocates path:

  - ath12k_mac_op_sta_state(NOTEXIST->NONE) skips ath12k_peer_ml_alloc()
    and stores PENDING in ahsta->ml_peer_id and dp_params.peer_id;
  - ath12k_dp_peer_create() skips dp_peer registration until a real ID is
    known;
  - ath12k_peer_create() leaves peer->ml_id at INVALID so consumer sites
    do not treat PENDING as a real ID;
  - ath12k_peer_ml_free() and ath12k_mac_dp_peer_cleanup() skip the
    dp_peers[] write and the free_ml_peer_id_map clear when
    host_alloc_ml_id is false or the ID is still PENDING.

The HTT handler change that resolves the PENDING ID is added in a
follow-up patch.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h    |  1 +
 drivers/net/wireless/ath/ath12k/dp_peer.c | 23 +++++++++++++++--------
 drivers/net/wireless/ath/ath12k/mac.c     | 22 ++++++++++++++++------
 drivers/net/wireless/ath/ath12k/peer.c    | 20 +++++++++++++++++---
 4 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 1f56474efbea..8769b41f5db5 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -72,6 +72,7 @@
 
 #define ATH12K_MAX_MLO_PEERS            256
 #define ATH12K_MLO_PEER_ID_INVALID      0xFFFF
+#define ATH12K_MLO_PEER_ID_PENDING      0xFFFE
 
 #define ATH12K_INVALID_RSSI_FULL -1
 #define ATH12K_INVALID_RSSI_EMPTY -128
diff --git a/drivers/net/wireless/ath/ath12k/dp_peer.c b/drivers/net/wireless/ath/ath12k/dp_peer.c
index 47d009a0d61f..2a2eae194007 100644
--- a/drivers/net/wireless/ath/ath12k/dp_peer.c
+++ b/drivers/net/wireless/ath/ath12k/dp_peer.c
@@ -472,7 +472,9 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	dp_peer->is_mlo = params->is_mlo;
 
 	/*
-	 * For MLO client, the host assigns the ML peer ID, so set peer_id in dp_peer
+	 * For MLO client, the ML peer ID, either known or PENDING, needs to be
+	 * initialized here since the following logic depends on it.
+	 *
 	 * For non-MLO client, host gets link peer ID from firmware and will be
 	 * assigned at the time of link peer creation
 	 */
@@ -488,13 +490,17 @@ int ath12k_dp_peer_create(struct ath12k_dp_hw *dp_hw, u8 *addr,
 	list_add(&dp_peer->list, &dp_hw->dp_peers_list);
 
 	/*
-	 * For MLO client, the peer_id for ath12k_dp_peer is allocated by host
-	 * and that peer_id is known at this point, and hence this ath12k_dp_peer
-	 * can be added to the RCU table using the peer_id.
-	 * For non-MLO client, this addition to RCU table shall be done at the
-	 * time of assignment of ath12k_dp_link_peer to ath12k_dp_peer.
+	 * For an MLO client whose ML peer ID is allocated by the host, the
+	 * peer_id is known here and the dp_peer can be added to the RCU
+	 * table using it. For an MLO client on chips where the firmware
+	 * allocates the ID, peer_id is ATH12K_MLO_PEER_ID_PENDING and the
+	 * RCU table publish is deferred to the
+	 * HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP handler. For a non-MLO client
+	 * the publish happens later, at the time of assignment of
+	 * ath12k_dp_link_peer to ath12k_dp_peer.
 	 */
-	if (dp_peer->is_mlo)
+	if (dp_peer->is_mlo &&
+	    dp_peer->peer_id != ATH12K_MLO_PEER_ID_PENDING)
 		rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], dp_peer);
 
 	spin_unlock_bh(&dp_hw->peer_lock);
@@ -515,7 +521,8 @@ void ath12k_dp_peer_delete(struct ath12k_dp_hw *dp_hw, u8 *addr,
 		return;
 	}
 
-	if (dp_peer->is_mlo)
+	if (dp_peer->is_mlo &&
+	    dp_peer->peer_id != ATH12K_MLO_PEER_ID_PENDING)
 		rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
 
 	list_del(&dp_peer->list);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 485be2998180..533109f9d5bd 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1285,7 +1285,9 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 	spin_lock_bh(&dp_hw->peer_lock);
 	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
 		if (dp_peer->is_mlo) {
-			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
+			if (dp_peer->peer_id != ATH12K_MLO_PEER_ID_PENDING)
+				rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id],
+						   NULL);
 			ath12k_peer_ml_free(ah, ath12k_sta_to_ahsta(dp_peer->sta));
 		}
 
@@ -7746,11 +7748,19 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 		/* ML sta */
 		if (sta->mlo && !ahsta->links_map &&
 		    (hweight16(sta->valid_links) == 1)) {
-			ahsta->ml_peer_id = ath12k_peer_ml_alloc(ah);
-			if (ahsta->ml_peer_id == ATH12K_MLO_PEER_ID_INVALID) {
-				ath12k_hw_warn(ah, "unable to allocate ML peer id for sta %pM",
-					       sta->addr);
-				goto exit;
+			if (ah->host_alloc_ml_id) {
+				ahsta->ml_peer_id = ath12k_peer_ml_alloc(ah);
+				if (ahsta->ml_peer_id == ATH12K_MLO_PEER_ID_INVALID) {
+					ath12k_hw_warn(ah, "unable to allocate ML peer id for sta %pM",
+						       sta->addr);
+					goto exit;
+				}
+			} else {
+				/*
+				 * firmware allocates the ML peer ID and notifies
+				 * the host via HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
+				 */
+				ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_PENDING;
 			}
 
 			dp_params.is_mlo = true;
diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
index ae93731b4177..25e4b79f11d6 100644
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -230,7 +230,16 @@ int ath12k_peer_create(struct ath12k *ar, struct ath12k_link_vif *arvif,
 		/* Fill ML info into created peer */
 		if (sta->mlo) {
 			ml_peer_id = ahsta->ml_peer_id;
-			peer->ml_id = ml_peer_id;
+			/*
+			 * For chips where firmware allocates the ML peer ID,
+			 * ml_peer_id is ATH12K_MLO_PEER_ID_PENDING here. The
+			 * MLO_RX_PEER_MAP HTT event handler fixes up
+			 * peer->ml_id once the ID is known.
+			 */
+			if (ml_peer_id == ATH12K_MLO_PEER_ID_PENDING)
+				peer->ml_id = ATH12K_MLO_PEER_ID_INVALID;
+			else
+				peer->ml_id = ml_peer_id;
 			ether_addr_copy(peer->ml_addr, sta->addr);
 
 			/* the assoc link is considered primary for now */
@@ -285,8 +294,13 @@ void ath12k_peer_ml_free(struct ath12k_hw *ah, struct ath12k_sta *ahsta)
 {
 	lockdep_assert_wiphy(ah->hw->wiphy);
 
-	if (ahsta->ml_peer_id <
-	    (ATH12K_MAX_MLO_PEERS | ATH12K_PEER_ML_ID_VALID))
+	/*
+	 * Only devices that allocate the ID on the host own a slot in
+	 * free_ml_peer_id_map.
+	 */
+	if (ah->host_alloc_ml_id &&
+	    (ahsta->ml_peer_id <
+	     (ATH12K_MAX_MLO_PEERS | ATH12K_PEER_ML_ID_VALID)))
 		clear_bit(ahsta->ml_peer_id & ~ATH12K_PEER_ML_ID_VALID,
 			  ah->free_ml_peer_id_map);
 	ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;

-- 
2.25.1

