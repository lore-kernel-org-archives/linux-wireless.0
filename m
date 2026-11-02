Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601539;
	b=s0rjv1g5lGj8Ut18ZB9BW6pK3XQyknRytfV38QFLYii3hI67G4KWI5kEbONFO0Ypa48E
	 fYM9X7wWJ2NFSozpz3ugo4Bgk1kRxIgIBCsoGM/EMbrwb01aC4FBiIwh/Qe10ZpVfz46n
	 5XYFImG+WVkf10GWeQpckchNS/U9ndDtl+tp6Vb7bZgIVw3uDEB8xp6tF8ZxvGuULhHGE
	 W4iPM4Y+N/B+mTcXNlHM7ApDnDdIhMf+M9vHT+7PU2MHVwXw1XOLObjnUuRFl3Fsbarxu
	 luSRUup2UEWPSUIuI3YbFgBCZDv+A5WXXOjkAozXhf2FrMSTF3bAisTSJeCcXlNstVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601539;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7F7gp94QtePHTIoc/MUKRs/RoI1a1gYUlINvzEJjLkU=;
	b=njCQo++OMp/QlFbNkAZD94jbxdNcT8ugN0NC4d/zmMuLh2fA/Vk1H+83KUAr/IR3QGC3
	 XIFOM2sWLtjhqUqTwzdMD3K+d7z3vpvEhrdqFgxK75Mu5bp4RcLDj38esQ8bf+c2AmmJh
	 GEyPNrc21ZBYme6vNUglmNA0vCdt5u/eXt4nAalXzglz4KZ8zXWJSEVoPYf0z6q6LIoTB
	 scOfGJmD0bpDcVSF+MPK48sjOftyfIy4I6WL+zrOpvD8W9okb/SM+RVRhH0eTJvcTOtMZ
	 XF38bcLCujoicM5BLLpvTaxYQaAWiyQrpi6PnZJx8OxTb6FMY2AstESgB1Fff+GckxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="YIR2i/zC";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="C/dENXaT";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BE5606A32C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86BE5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=YIR2i/zC;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=C/dENXaT
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vCWX2752988
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7F7gp94QtePHTIoc/MUKRs/RoI1a1gYUlINvzEJjLkU=; b=YIR2i/zCq3JnPLM1
	mb2X7yXbk2LB9uQo4nIIq2X92xe755z7DfeI0/dH3tIc9biFBVD1qlQnnJOFC9ve
	yMSMjSwvSxu0EdfSQ1+lr7PXUwf2bCT0NabA9n2ZpAj7YIuz9bTw0j53gc8tBGEj
	JBJ63K69TEBeU85ggYBePiGP+DpOFG2l+6A2X2DFx+HIcamgfDeJkx6YMeT3hOmn
	tjAo24z/GZewrIK6QO5EQwPiCV1ATKxqHt3hzuVyGo6PTu9ltuevRFHcuiGYHe4/
	29BQH3s8kjWQLfpjtsRq87P9Gz0mtw2/gRHhzX+KivrZyxkTBdz70daO10SRxOYZ
	4n1FYg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hpg200yhn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:57 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ade5b3ae97so2290923a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601536; x=1794206336; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7F7gp94QtePHTIoc/MUKRs/RoI1a1gYUlINvzEJjLkU=;
        b=C/dENXaTWdmUPsTTu+v4KqgMwhlgQpK97WbPAL1DZBqOqgJ//LxtEWOp5XaQ7NTS+J
         hS3QlKzhHE7rsr72/x9Rc83t/r7MNKGw+jsGVCGBsQ1t4ClbTz6cOe8UMBE2H0PdC3wg
         IZf14HKQiLwSbMz72wCX5z+tP6+7zn8oWKEZm0ha/eVfOrUBHgUquqSSEZ3mdGr/5Bjh
         4/c7cRXVpbctlxfiubQ3nckqxQMwZIxHDix7wccF95AgRsF6SLaGyXV9nrns0IguQZAO
         Zn2ndJVhP3TSGqOsSIpjdwq0bWm97DyJ2uQKCtM2qrzGhV8UplEUbZF0pq4ngQQjNri0
         S/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601536; x=1794206336;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7F7gp94QtePHTIoc/MUKRs/RoI1a1gYUlINvzEJjLkU=;
        b=YMcYhDzv5ACD4v0oJU/Y/QEJMbhaCftQMuhaRzvE+6qhsstgE4+JrADfCKYJKWwCXD
         nN51En+AA9iVdS3dD30G4kMxQXpUl2tjhaz32idRq07JMmcyd2O9H+cS5XQ+h/2qvoko
         iPLii/PB/SiV+rDvOr8UzsX7G2EQ8iyaHSk+/Xnyu64hSsVILWAsBJy9RniFv9eI2HZQ
         HkGGKzBxE0eM+1jerEEx3UPm4Tuikz7bS3ImA087RMIW6djc4+tEiBXLFenw0R0K1uQY
         2zyOjFwuFFSu5aJH7LMxFMp75pzSnMIWH4i9mkGDaT3h2M4nXHkowRkdrTmZwZ5vZAp/
         WuTw==
X-Gm-Message-State: APuU4Z+sosSzI4fTM7lyxAJnW7FsScmoF1j5NK3lJIZdVQjQsH5PSm5K
	mjm+ncDjdZjGrzQJ8xqVRNwgRdrgl/Oz+HYkQ4Bg9Wv09FzQkFYOJ8V4XQKTqCehQ+4hj0MPTGR
	WjFJ6IR/GEjP+7ehytQ4vnUW5QO41CtIdvbWAYeZozFzqykkChl3+ytZ0SkCwP+JTIVgghNgxi1
	QOAHNj
X-Gm-Gg: AYBFou2P18V+EhQdqJw6h9WY+RBZrPwdYXPkI4keKHriy6yrjgzqOiN/yfu23PQivFJ
	Srb6MnSc+7+aVS95bvMzDW8rh6G95mDZwfCvxHAxuQWJWfAOhikAy8yXncuQsHPUwhEHmoDkguL
	nWvb4Lbfv/7+FHfZvGVRMNImW78ZBmUuU1jQkHtQyS/XA+U07hJA7BYjeIZrQ6OmJrld1e8UOtY
	k6ZfGjrSmX4oyGUv900UgPCQE355slpCTmQSwuh3Q7uQ5UVFIID+VUU2tM6eY70hB0kl1s+4unb
	A6NOyCVF2OF5HJG964Ob7UP1O+Ch/BZkCTBlrin0U2U1jkdjLmABVA/HjVaKvUWCcVLMWLzOKOu
	0mBIqHabuU30JjxIU1TRpDVlkVnRK4FNede41WyqhdsW3KQZZGjvX7P3taol/Ixlumm92BA+BwZ
	2BiAzZiuh7bN+Ql0RkVUOQ2CICBQjj
X-Received: by 2002:a17:90b:1cc5:b0:3ae:3d82:5d88 with SMTP id 98e67ed59e1d1-3ae8917bf84mr5450051a91.0.1793601536324;
        Sun, 01 Nov 2026 22:38:56 -0800 (PST)
X-Received: by 2002:a17:90b:1cc5:b0:3ae:3d82:5d88 with SMTP id 98e67ed59e1d1-3ae8917bf84mr5450044a91.0.1793601535616;
        Sun, 01 Nov 2026 22:38:55 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:55 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:14 +0800
Subject: [PATCH ath-next v4 05/11] wifi: ath12k: rename
 ath12k_skb_rxcb::hw_link_id to drv_link_id
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
Message-Id: <20261102-ath12k-logical-link-id-v4-5-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: SGNehOqD5V6wUEeS_iOF6IYOEvA6gz_N
X-Authority-Analysis: v=2.4 cv=fZY4WEQF c=1 sm=1 tr=0 ts=6ae83001 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=NxgKQpyHIDudPh6FZjkA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: SGNehOqD5V6wUEeS_iOF6IYOEvA6gz_N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX0vbyZZND6YEY
 9GR/9plPuTKqbY31hKrMEktFddcduuUtBxSIpYlm3QSmyWno3hHa93FfV0xvsv72u++jP8Y/gVZ
 RrYLglpvwGKCQ8GiJL0YGkHNj1lFsvhKsvJLUWhJR9RvcfWY2PMur0UQdMj15RNYmJ4ktafP8Oo
 gaZOOF36my7a0Sq7itob6Y0FuPHaHafz2gnQKptRTNWTMLpcisrpA6VwaRvDh8CYMBTOH7EqEY0
 C599CVwxQscp9perw7wdil9dBwGmnsjtZHXInZinN1xn84Uotvs0Ce5baN1Ejz2z/Y+QyEoVKMM
 L4PN925/aEF5J3vMIuisuT5ZBG35ypRs6R+J1lFPEqkDrMjoEnP/deWOIZZ/wS0h5AxvdA07j9/
 b5f7TFSqXU+7Thf06N6mBeeennT84vHiNlIHy5iq9a9Lc6esIwS3l/4FqOEDU/CUAiexLjPLpPz
 RHQdL0VwTb6BOuyYJDw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXzhXeGxlBYqpI
 FD5Pw4Ijev+L0tUbLFjEoRV6iY4I2Gz+IGQs36rsFfEHwKapX7OgeEZwNID2m9KYyNHsb3JcIuk
 /nCPQHsaaep+dRv46fNSLV+17k1w7Ug=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

The hw_link_id field of ath12k_skb_rxcb holds the driver link id of the
RX frame. This is the hw_link_id for QCN9274, but for WCN7850/QCC2072 it
is the logical_link_id instead. The hw_link_id name is therefore
misleading for the latter.

Rename it to drv_link_id to reflect that it is the driver link id
regardless of how the underlying value is derived. No functional change
intended.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.h        |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index b0e28d0a152a..f1929997a35a 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -143,7 +143,7 @@ struct ath12k_skb_rxcb {
 	struct hal_rx_desc *rx_desc;
 	u8 err_rel_src;
 	u8 err_code;
-	u8 hw_link_id;
+	u8 drv_link_id;
 	u8 unmapped;
 	u8 is_frag;
 	u8 tid;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 2a0141157426..a59adbb78c76 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -621,7 +621,7 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 
 	while ((msdu = __skb_dequeue(msdu_list))) {
 		rxcb = ATH12K_SKB_RXCB(msdu);
-		hw_link_id = rxcb->hw_link_id;
+		hw_link_id = rxcb->drv_link_id;
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp,
 						    hw_links[hw_link_id].device_id);
 		pdev_idx = ath12k_hw_mac_id_to_pdev_id(partner_dp->hw_params,
@@ -776,7 +776,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 					RX_MSDU_DESC_INFO0_LAST_MSDU_IN_MPDU);
 		rxcb->is_continuation = !!(le32_to_cpu(msdu_info->info0) &
 					   RX_MSDU_DESC_INFO0_MSDU_CONTINUATION);
-		rxcb->hw_link_id = hw_link_id;
+		rxcb->drv_link_id = hw_link_id;
 		rxcb->peer_id = ath12k_wifi7_dp_rx_get_peer_id(dp, dp->peer_metadata_ver,
 							       mpdu_info->peer_meta_data);
 		rxcb->tid = le32_get_bits(mpdu_info->info0,
@@ -2063,7 +2063,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 
 			skb_queue_walk(&scatter_msdu_list, msdu) {
 				rxcb = ATH12K_SKB_RXCB(msdu);
-				rxcb->hw_link_id = hw_link_id;
+				rxcb->drv_link_id = hw_link_id;
 			}
 
 			skb_queue_splice_tail_init(&scatter_msdu_list,
@@ -2071,7 +2071,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		}
 
 		rxcb = ATH12K_SKB_RXCB(msdu);
-		rxcb->hw_link_id = hw_link_id;
+		rxcb->drv_link_id = hw_link_id;
 		__skb_queue_tail(&msdu_list, msdu);
 	}
 
@@ -2102,7 +2102,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 	rcu_read_lock();
 	while ((msdu = __skb_dequeue(&msdu_list))) {
 		rxcb = ATH12K_SKB_RXCB(msdu);
-		hw_link_id = rxcb->hw_link_id;
+		hw_link_id = rxcb->drv_link_id;
 
 		device_id = hw_links[hw_link_id].device_id;
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
@@ -2368,7 +2368,7 @@ ath12k_wifi7_dp_rx_get_link_id_qcn9274(struct ath12k_dp_peer *dp_peer,
 				       struct ath12k_skb_rxcb *rxcb,
 				       struct ieee80211_rx_status *status)
 {
-	return dp_peer->link_id_map[rxcb->hw_link_id];
+	return dp_peer->link_id_map[rxcb->drv_link_id];
 }
 
 int

-- 
2.25.1

